<?php
// ============================================================
//  GYM One Installer – Utolsó lépés: fájlok telepítése
// ============================================================
ob_start();
session_start();

require_once __DIR__ . '/../helpers.php';

$langData     = loadTranslations();
$lang         = $langData['lang'];
$languages    = $langData['languages'];
$translations = $langData['translations'];
$assetBase    = '../';

// ------------------------------------------------------------
// AJAX POST: telepítés végrehajtása lépésenkénti SSE-vel
// A böngésző Server-Sent Events segítségével valós idejű
// visszajelzést kap – nem kell fehér oldalt nézni percekig.
// ------------------------------------------------------------
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['install'])) {
    ob_end_clean();
    header('Content-Type: text/event-stream');
    header('Cache-Control: no-cache');
    header('X-Accel-Buffering: no'); // Nginx puffer kikapcsolás

    // Flush segédfüggvény
    function sendEvent(string $type, string $message, int $progress = 0): void {
        $data = json_encode(['type' => $type, 'message' => $message, 'progress' => $progress]);
        echo "data: {$data}\n\n";
        if (ob_get_level() > 0) ob_flush();
        flush();
    }

    set_time_limit(300);

    $repoOwner      = 'Ganzosupremo';  // Sankris Gymnastics fork
    $repoName       = 'GYM-One';
    $parentDir      = dirname(__DIR__);
    $tempZipFile    = TEMP_DIR . 'GYM-One-main.zip';
    $outputDir      = TEMP_DIR . 'gym-one-latest';
    $tempExtractDir = TEMP_DIR . 'gym-one-extract';
    $tempDir        = $parentDir . '/temp';

    try {
        // 1. ZIP letöltés
        sendEvent('progress', $translations['install-downloading'] ?? 'Downloading GYM One...', 10);

        $zipUrl = "https://github.com/{$repoOwner}/{$repoName}/archive/refs/heads/main.zip";
        $ch = curl_init($zipUrl);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_USERAGENT      => 'GYMOne-Installer/1.0',
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_TIMEOUT        => 120,
            CURLOPT_SSL_VERIFYPEER => true,
        ]);
        $zipContent = curl_exec($ch);
        $curlError  = curl_error($ch);
        $httpCode   = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($zipContent === false || $curlError) {
            throw new Exception('Download failed: ' . $curlError);
        }
        if ($httpCode !== 200) {
            throw new Exception("GitHub returned HTTP {$httpCode}");
        }

        // 2. ZIP mentése temp/-be (írható)
        sendEvent('progress', $translations['install-saving'] ?? 'Saving archive...', 25);
        if (file_put_contents($tempZipFile, $zipContent) === false) {
            throw new Exception('Failed to save ZIP file to: ' . $tempZipFile);
        }
        unset($zipContent);

        // 3. Kicsomagolás – shell unzip paranccsal, PHP ZipArchive fallback
        sendEvent('progress', $translations['install-extracting'] ?? 'Extracting files...', 40);

        if (!is_dir($tempExtractDir)) {
            mkdir($tempExtractDir, 0755, true);
        }

        exec('which unzip 2>/dev/null', $whichOut, $whichCode);
        if ($whichCode === 0) {
            $cmd = 'unzip -q ' . escapeshellarg($tempZipFile) . ' -d ' . escapeshellarg($tempExtractDir) . ' 2>&1';
            exec($cmd, $unzipOut, $unzipCode);
            if ($unzipCode !== 0) {
                throw new Exception('unzip failed: ' . implode(' ', $unzipOut));
            }
        } else {
            $zip = new ZipArchive();
            if ($zip->open($tempZipFile) !== true) {
                throw new Exception('Failed to open ZIP archive. Size: ' . filesize($tempZipFile) . ' bytes');
            }
            $zip->extractTo($tempExtractDir);
            $zip->close();
        }

        sendEvent('progress', $translations['install-extracting'] ?? 'Extracting files...', 55);

        // Az első almappát keressük meg (pl. GYM-ONE-main)
        $extracted = array_diff(scandir($tempExtractDir), ['.', '..']);
        $sourceDir = null;
        foreach ($extracted as $item) {
            if (is_dir($tempExtractDir . '/' . $item)) {
                $sourceDir = $tempExtractDir . '/' . $item;
                break;
            }
        }

        if (!$sourceDir || !is_dir($sourceDir)) {
            throw new Exception('Could not locate extracted directory. Found: ' . implode(', ', $extracted));
        }

        // sourceDir → outputDir mozgatás (exec mv – cross-partition safe)
        if (!is_dir($outputDir)) {
            mkdir($outputDir, 0777, true);
        }
        exec('mv ' . escapeshellarg($sourceDir) . '/* ' . escapeshellarg($outputDir) . '/ 2>&1');
        exec('mv ' . escapeshellarg($sourceDir) . '/.[!.]* ' . escapeshellarg($outputDir) . '/ 2>/dev/null');
        exec('rm -rf ' . escapeshellarg($tempExtractDir));
        exec('rm -f ' . escapeshellarg($tempZipFile));

        // 4. Régi installer fájlok törlése
        sendEvent('progress', $translations['install-cleanup'] ?? 'Cleaning up installer...', 60);
        foreach (array_diff(scandir($parentDir), ['.', '..', 'temp', 'gym-one-latest']) as $file) {
            $path = $parentDir . DIRECTORY_SEPARATOR . $file;
            exec('rm -rf ' . escapeshellarg($path));
        }

        // 5. .env áthelyezése a temp/-ből
        sendEvent('progress', $translations['install-moving-env'] ?? 'Moving configuration...', 75);
        if (file_exists($tempDir . '/.env')) {
            exec('cp ' . escapeshellarg($tempDir . '/.env') . ' ' . escapeshellarg($parentDir . '/.env'));
        }

        // 6. gym-one-latest tartalmát a gyökérbe mozgatjuk
        sendEvent('progress', $translations['install-finalizing'] ?? 'Finalizing installation...', 90);
        exec('mv ' . escapeshellarg($outputDir) . '/* ' . escapeshellarg($parentDir) . '/ 2>&1', $mvOut, $mvCode);
        exec('mv ' . escapeshellarg($outputDir) . '/.[!.]* ' . escapeshellarg($parentDir) . '/ 2>/dev/null');
        exec('rm -rf ' . escapeshellarg($outputDir));
        exec('rm -rf ' . escapeshellarg($tempDir));

        writeLog('LASTONE', '🎉 Installation complete! Files deployed successfully.');
        sendEvent('done', $translations['install-success'] ?? 'Installation complete!', 100);

    } catch (Exception $e) {
        writeLog('LASTONE', '❌ Installation failed: ' . $e->getMessage());
        sendEvent('error', $e->getMessage(), 0);
    }
    exit();
}

// Rekurzív törlés segédfüggvény
function deleteDir(string $dir): void {
    if (!is_dir($dir)) return;
    foreach (array_diff(scandir($dir), ['.', '..']) as $item) {
        $path = $dir . DIRECTORY_SEPARATOR . $item;
        is_dir($path) ? deleteDir($path) : unlink($path);
    }
    rmdir($dir);
}

ob_end_clean();
?>
<?php include __DIR__ . '/../partials/header.php'; ?>

<div class="container justify-content-center">
  <div class="row text-center justify-content-center">

    <div class="col-md-8 mx-auto text-center mb-5">
      <h1 class="mb-3 fw-semibold"><?php echo e($translations['installer'] ?? 'Install GYM One'); ?></h1>
      <p class="lead mb-4 fs-4">
        <?php echo e($translations['installerVersion'] ?? ''); ?> &ndash; <?php echo e(INSTALLER_VERSION); ?>
      </p>
    </div>

    <div class="col-md-8 mx-auto text-center mb-5">
      <div class="card">
        <div class="card-body">

          <p class="text-center mb-4"><?php echo e($translations['click-toinstall'] ?? ''); ?></p>

          <button id="installBtn" class="btn btn-primary btn-lg w-100">
            <?php echo e($translations['installbtnlastone'] ?? 'Install GYM One'); ?>
          </button>

          <div class="install-progress mt-4" id="progressArea" style="display:none;">
            <div class="progress" style="height: 28px;">
              <div class="progress-bar progress-bar-striped progress-bar-animated bg-success"
                   id="progressBar" style="width: 0%;" role="progressbar"
                   aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">
                0%
              </div>
            </div>
            <p id="statusMessage" class="text-center mt-3 fw-semibold"> – </p>
          </div>

        </div>
      </div>
    </div>

  </div>
</div>

<script>
  document.getElementById('installBtn').addEventListener('click', function () {
    const btn           = this;
    const progressArea  = document.getElementById('progressArea');
    const progressBar   = document.getElementById('progressBar');
    const statusMessage = document.getElementById('statusMessage');

    btn.disabled       = true;
    btn.textContent    = '⏳ Installing...';
    progressArea.style.display = 'block';

    function setProgress(pct, msg) {
      progressBar.style.width  = pct + '%';
      progressBar.textContent  = pct + '%';
      progressBar.setAttribute('aria-valuenow', pct);
      statusMessage.textContent = msg;
    }

    // Server-Sent Events a valós idejű visszajelzéshez
    // Az SSE-t fetch POST-tal indítjuk
    fetch('', {
      method : 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body   : 'install=1',
    }).then(response => {
      const reader = response.body.getReader();
      const decoder = new TextDecoder();
      let buffer = '';

      function read() {
        reader.read().then(({ done, value }) => {
          if (done) return;

          buffer += decoder.decode(value, { stream: true });
          const lines = buffer.split('\n');
          buffer = lines.pop(); // utolsó esetleg csonka sor megőrzése

          for (const line of lines) {
            if (!line.startsWith('data:')) continue;
            try {
              const event = JSON.parse(line.slice(5).trim());
              setProgress(event.progress, event.message);

              if (event.type === 'done') {
                progressBar.classList.remove('progress-bar-animated');
                statusMessage.className = 'text-center mt-3 fw-semibold text-success';
                // Átirányítás 2 mp után
                setTimeout(() => { window.location.href = '../'; }, 2000);
              } else if (event.type === 'error') {
                progressBar.classList.remove('progress-bar-animated', 'bg-success');
                progressBar.classList.add('bg-danger');
                statusMessage.className = 'text-center mt-3 fw-semibold text-danger';
                btn.disabled    = false;
                btn.textContent = '🔄 Retry';
              }
            } catch (e) { /* JSON parse hiba, kihagyjuk */ }
          }
          read();
        });
      }
      read();
    }).catch(() => {
      setProgress(0, '❌ Network error. Please try again.');
      progressBar.classList.add('bg-danger');
      btn.disabled    = false;
      btn.textContent = '🔄 Retry';
    });
  });
</script>

<?php include __DIR__ . '/../partials/footer.php'; ?>