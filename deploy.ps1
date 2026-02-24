#!/usr/bin/env pwsh
# PowerShell deployment script for GitHub Pages

$ErrorActionPreference = "Stop"

Write-Host "Starting deployment to GitHub Pages..." -ForegroundColor Cyan

$FRONTEND_DIR = "frontend"
$BUILD_DIR = "$FRONTEND_DIR/.output/public"
$SITE_DIR = "_site"

Write-Host "Building frontend..." -ForegroundColor Yellow
Push-Location $FRONTEND_DIR
$env:GH_PAGES = "true"
try {
    bun run build
    if ($LASTEXITCODE -ne 0) { throw "Build failed!" }
} finally {
    Pop-Location
}

Write-Host "Preparing _site directory..." -ForegroundColor Yellow
if (Test-Path $SITE_DIR) {
    Remove-Item -Recurse -Force $SITE_DIR
}
New-Item -ItemType Directory -Path $SITE_DIR | Out-Null

Write-Host "Copying build output..." -ForegroundColor Yellow
Copy-Item -Path "$BUILD_DIR/*" -Destination $SITE_DIR -Recurse

Write-Host "Creating .nojekyll file..." -ForegroundColor Yellow
New-Item -ItemType File -Path "$SITE_DIR/.nojekyll" | Out-Null

Write-Host "Setting up 404.html for client-side routing..." -ForegroundColor Yellow
Copy-Item -Path "$SITE_DIR/index.html" -Destination "$SITE_DIR/404.html"

Write-Host "Build complete! Site is ready in '$SITE_DIR/'" -ForegroundColor Green
Write-Host ""
Write-Host "To test locally, run:"
Write-Host "  cd _site"
Write-Host "  python -m http.server 8000"
Write-Host ""
Write-Host "Then open http://localhost:8000 in your browser"
