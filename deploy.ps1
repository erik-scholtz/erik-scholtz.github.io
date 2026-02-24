#!/usr/bin/env pwsh
# PowerShell deployment script for GitHub Pages
# This script builds your SolidStart app and prepares it for GitHub Pages

$ErrorActionPreference = "Stop"

Write-Host "🚀 Starting deployment to GitHub Pages..." -ForegroundColor Cyan

# Configuration
$FRONTEND_DIR = "frontend"
$BUILD_DIR = "$FRONTEND_DIR/.output/public"
$SITE_DIR = "_site"

# Step 1: Build the frontend
Write-Host "📦 Building frontend..." -ForegroundColor Yellow
Push-Location $FRONTEND_DIR
$env:GH_PAGES = "true"
try {
    bun run build
    if ($LASTEXITCODE -ne 0) { throw "Build failed!" }
} finally {
    Pop-Location
}

# Step 2: Prepare the _site directory
Write-Host "📁 Preparing _site directory..." -ForegroundColor Yellow
if (Test-Path $SITE_DIR) {
    Remove-Item -Recurse -Force $SITE_DIR
}
New-Item -ItemType Directory -Path $SITE_DIR | Out-Null

# Step 3: Copy build output to _site
Write-Host "📋 Copying build output..." -ForegroundColor Yellow
Copy-Item -Path "$BUILD_DIR/*" -Destination $SITE_DIR -Recurse

# Step 4: Create .nojekyll file
Write-Host "🚫 Disabling Jekyll processing..." -ForegroundColor Yellow
New-Item -ItemType File -Path "$SITE_DIR/.nojekyll" | Out-Null

# Step 5: Copy index.html to 404.html for client-side routing
Write-Host "🔄 Setting up client-side routing fallback..." -ForegroundColor Yellow
Copy-Item -Path "$SITE_DIR/index.html" -Destination "$SITE_DIR/404.html"

Write-Host "✅ Build complete! Site is ready in '$SITE_DIR/'" -ForegroundColor Green
Write-Host ""
Write-Host "To deploy:"
Write-Host "  1. Enable GitHub Pages in your repository settings"
Write-Host "  2. Set source to 'GitHub Actions'"
Write-Host "  3. Push to main branch to trigger automatic deployment"
Write-Host ""
Write-Host "Or test locally with:"
Write-Host "  cd _site && python -m http.server 8000"
