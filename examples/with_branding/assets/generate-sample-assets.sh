#!/bin/bash
# Generate sample SVG assets for Cognito Managed Login Branding
# Creates SVG files that match the example configuration

set -e

echo "🎨 Generating sample branding assets..."

# Create assets directory if it doesn't exist
mkdir -p "$(dirname "$0")"

cd "$(dirname "$0")"

# Function to validate file size (2MB limit)
validate_file_size() {
    local file="$1"
    local max_size=2097152  # 2MB in bytes
    
    if [[ -f "$file" ]]; then
        local file_size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo "0")
        if [[ $file_size -gt $max_size ]]; then
            echo "❌ Warning: $file exceeds 2MB limit ($file_size bytes)"
            return 1
        fi
    fi
    return 0
}

echo "📝 Creating logo-light.svg (200x60px, blue background, white text)..."
cat > logo-light.svg << 'EOF'
<svg width="200" height="60" xmlns="http://www.w3.org/2000/svg">
  <rect width="200" height="60" fill="#007bff"/>
  <text x="100" y="35" font-family="Arial, sans-serif" font-size="16" fill="white" text-anchor="middle" dominant-baseline="middle">My App</text>
</svg>
EOF

echo "📝 Creating logo-dark.svg (200x60px, white background, dark text)..."
cat > logo-dark.svg << 'EOF'
<svg width="200" height="60" xmlns="http://www.w3.org/2000/svg">
  <rect width="200" height="60" fill="#ffffff"/>
  <text x="100" y="35" font-family="Arial, sans-serif" font-size="16" fill="#212529" text-anchor="middle" dominant-baseline="middle">My App</text>
</svg>
EOF

echo "📝 Creating background.svg (1920x1080px, gradient)..."
cat > background.svg << 'EOF'
<svg width="1920" height="1080" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#007bff;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#0d6efd;stop-opacity:1" />
    </linearGradient>
  </defs>
  <rect width="1920" height="1080" fill="url(#grad1)"/>
</svg>
EOF

echo "📝 Creating favicon.svg (32x32px, blue square)..."
cat > favicon.svg << 'EOF'
<svg width="32" height="32" xmlns="http://www.w3.org/2000/svg">
  <rect width="32" height="32" fill="#007bff"/>
  <text x="16" y="20" font-family="Arial, sans-serif" font-size="14" fill="white" text-anchor="middle" dominant-baseline="middle">A</text>
</svg>
EOF

# Validate file sizes
echo "🔍 Validating file sizes..."
files_created=("logo-light.svg" "logo-dark.svg" "background.svg" "favicon.svg")
validation_failed=false

for file in "${files_created[@]}"; do
    if ! validate_file_size "$file"; then
        validation_failed=true
    fi
done

if [[ "$validation_failed" == true ]]; then
    echo "❌ Some files exceed the 2MB limit. Please optimize them before deployment."
    exit 1
fi

echo "✅ Sample assets generated successfully!"
echo ""
echo "📋 Generated files:"
echo "   - logo-light.svg (200x60px) - Light theme logo"
echo "   - logo-dark.svg (200x60px) - Dark theme logo" 
echo "   - background.svg (1920x1080px) - Background image"
echo "   - favicon.svg (32x32px) - Browser favicon"
echo ""
echo "💡 Customize these files with your actual branding assets before deployment."
echo "🔧 Edit colors, text, and dimensions as needed for your brand."
echo "✅ All files are under the 2MB AWS limit and ready for use."