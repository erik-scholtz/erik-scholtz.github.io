#!/usr/bin/env ruby
# frozen_string_literal: true

# Jekyll-style deployment script for GitHub Pages
# This script builds your SolidStart app and prepares it for GitHub Pages

require 'fileutils'

puts "🚀 Starting deployment to GitHub Pages..."

# Configuration
FRONTEND_DIR = "frontend"
BUILD_DIR = "#{FRONTEND_DIR}/.output/public"
SITE_DIR = "_site"
REPO_NAME = "erik-scholtz.github.io"

# Step 1: Build the frontend
puts "📦 Building frontend..."
Dir.chdir(FRONTEND_DIR) do
  system("GH_PAGES=true bun run build") || abort("❌ Build failed!")
end

# Step 2: Prepare the _site directory
puts "📁 Preparing _site directory..."
FileUtils.rm_rf(SITE_DIR)
FileUtils.mkdir_p(SITE_DIR)

# Step 3: Copy build output to _site
puts "📋 Copying build output..."
FileUtils.cp_r(Dir.glob("#{BUILD_DIR}/*"), SITE_DIR)

# Step 4: Create .nojekyll file
puts "🚫 Disabling Jekyll processing..."
FileUtils.touch("#{SITE_DIR}/.nojekyll")

# Step 5: Copy index.html to 404.html for client-side routing
puts "🔄 Setting up client-side routing fallback..."
FileUtils.cp("#{SITE_DIR}/index.html", "#{SITE_DIR}/404.html")

puts "✅ Build complete! Site is ready in '#{SITE_DIR}/'"
puts ""
puts "To deploy:"
puts "  1. Enable GitHub Pages in your repository settings"
puts "  2. Set source to 'GitHub Actions'"
puts "  3. Push to main branch to trigger automatic deployment"
puts ""
puts "Or test locally with:"
puts "  cd _site && python -m http.server 8000"
