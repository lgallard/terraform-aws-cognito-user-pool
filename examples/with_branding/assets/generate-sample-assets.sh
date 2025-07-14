#!/bin/bash
# Generate sample assets for Cognito Managed Login Branding
# Requires ImageMagick (install with: brew install imagemagick)

set -e

echo "🎨 Generating sample branding assets..."

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "❌ ImageMagick not found. Please install it:"
    echo "   macOS: brew install imagemagick"
    echo "   Ubuntu: sudo apt-get install imagemagick"
    echo "   CentOS: sudo yum install ImageMagick"
    exit 1
fi

# Create assets directory if it doesn't exist
mkdir -p "$(dirname "$0")"

cd "$(dirname "$0")"

echo "📝 Creating logo-light.png (200x60px, blue background, white text)..."
if ! convert -size 200x60 xc:"#007bff" \
        -font Arial -pointsize 16 -fill white \
        -gravity center -annotate 0 "My App" \
        logo-light.png 2>/dev/null; then
    echo "❌ Failed to create logo-light.png"
    exit 1
fi

echo "📝 Creating logo-dark.png (200x60px, white background, dark text)..."
if ! convert -size 200x60 xc:"#ffffff" \
        -font Arial -pointsize 16 -fill "#212529" \
        -gravity center -annotate 0 "My App" \
        logo-dark.png 2>/dev/null; then
    echo "❌ Failed to create logo-dark.png"
    exit 1
fi

echo "📝 Creating background.jpg (1920x1080px, gradient)..."
if ! convert -size 1920x1080 gradient:"#007bff"-"#0d6efd" \
        background.jpg 2>/dev/null; then
    echo "❌ Failed to create background.jpg"
    exit 1
fi

echo "📝 Creating favicon.ico (32x32px, blue square)..."
if ! convert -size 32x32 xc:"#007bff" \
        -font Arial -pointsize 14 -fill white \
        -gravity center -annotate 0 "A" \
        favicon.ico 2>/dev/null; then
    echo "❌ Failed to create favicon.ico"
    exit 1
fi

echo "✅ Sample assets generated successfully!"
echo ""
echo "📋 Generated files:"
echo "   - logo-light.png (200x60px) - Light theme logo"
echo "   - logo-dark.png (200x60px) - Dark theme logo" 
echo "   - background.jpg (1920x1080px) - Background image"
echo "   - favicon.ico (32x32px) - Browser favicon"
echo ""
echo "💡 Customize these files with your actual branding assets before deployment."
echo "🔧 Edit colors, text, and dimensions as needed for your brand."