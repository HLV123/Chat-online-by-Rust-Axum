# build-deploy.ps1
# Build frontend (client + SSR) -> prerender index.html -> copy vao backend/public
# Chay tu thu muc GOC (chua ca backend/ va frontend/)
#
# Luong:
#   1. bun run build.client   ->  frontend/dist/   (JS chunks)
#   2. bun run build.preview  ->  frontend/server/ (SSR entry)
#   3. bun prerender.mjs      ->  frontend/dist/index.html
#   4. Copy dist/             ->  backend/public/
#   5. cd backend && cargo run
#   6. ngrok http 3000

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  QwikChat - Build & Deploy Script   " -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Kiem tra dang o dung thu muc goc
if (-not (Test-Path "frontend") -or -not (Test-Path "backend")) {
    Write-Host "LOI: Phai chay script nay tu thu muc GOC chua ca frontend/ va backend/" -ForegroundColor Red
    Write-Host "Vi du: cd qwikchat && .\frontend\build-deploy.ps1" -ForegroundColor Yellow
    exit 1
}

# === BUOC 1: Build client (JS chunks) ===
Write-Host "[1/3] Build client (bun run build.client)..." -ForegroundColor Cyan
Set-Location frontend
bun run build.client
if ($LASTEXITCODE -ne 0) {
    Write-Host "LOI: build.client that bai!" -ForegroundColor Red
    Write-Host "Chay 'bun install' truoc neu chua cai dependencies." -ForegroundColor Yellow
    Set-Location ..
    exit 1
}
Write-Host "OK: frontend/dist/ co JS chunks." -ForegroundColor Green

# === BUOC 2: Build SSR entry ===
Write-Host ""
Write-Host "[2/3] Build SSR entry (bun run build.preview)..." -ForegroundColor Cyan
bun run build.preview
if ($LASTEXITCODE -ne 0) {
    Write-Host "LOI: build.preview that bai!" -ForegroundColor Red
    Set-Location ..
    exit 1
}
Write-Host "OK: frontend/server/entry.preview.js san sang." -ForegroundColor Green

# === BUOC 3: Prerender index.html ===
Write-Host ""
Write-Host "[3/3] Prerender index.html..." -ForegroundColor Cyan
bun prerender.mjs
if ($LASTEXITCODE -ne 0) {
    Write-Host "LOI: Prerender that bai!" -ForegroundColor Red
    Set-Location ..
    exit 1
}
Write-Host "OK: frontend/dist/index.html da duoc tao." -ForegroundColor Green

Set-Location ..

# === Copy dist -> backend/public ===
Write-Host ""
Write-Host "Copy dist -> backend/public..." -ForegroundColor Cyan
if (Test-Path "backend\public") {
    Remove-Item -Recurse -Force "backend\public"
}
Copy-Item -Recurse "frontend\dist" "backend\public"
Write-Host "OK: backend\public\ san sang." -ForegroundColor Green

# === XONG ===
Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host "  XONG! Buoc tiep theo:              " -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host "  Terminal 1: cd backend && cargo run" -ForegroundColor White
Write-Host "  Terminal 2: ngrok http 3000         " -ForegroundColor White
Write-Host "  -> Chia se 1 URL ngrok duy nhat.   " -ForegroundColor Yellow
Write-Host ""
