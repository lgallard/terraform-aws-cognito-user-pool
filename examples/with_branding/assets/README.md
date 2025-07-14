# Assets Directory

This directory should contain the branding assets referenced in the example:

## Required Files

- `logo-light.png` - Logo for light mode (recommended size: 200x60px)
- `logo-dark.png` - Logo for dark mode (recommended size: 200x60px) 
- `background.jpg` - Background image (recommended size: 1920x1080px)
- `favicon.ico` - Favicon (16x16px or 32x32px)

## Asset Guidelines

### Supported Formats
- PNG, JPG, JPEG, SVG, ICO
- Maximum file size: 2MB per asset

### Asset Categories
- `FORM_LOGO` - Logo displayed on the login form
- `PAGE_BACKGROUND` - Background image for the login page
- `FAVICON_ICO` - Favicon for the browser tab
- `PAGE_HEADER_LOGO` - Logo in the page header
- `PAGE_FOOTER_LOGO` - Logo in the page footer
- And more (see AWS documentation)

### Color Modes
- `LIGHT` - Assets for light theme
- `DARK` - Assets for dark theme  
- `BROWSER_ADAPTIVE` - Assets that adapt to browser preference

## Quick Start - Generate Sample Assets

Use the provided script to quickly generate sample assets for testing:

```bash
# Run the asset generation script
./generate-sample-assets.sh
```

This will create all required assets with sample branding. Customize them with your actual brand assets before production use.

## Manual Asset Creation

You can also create placeholder assets manually:

```bash
# Create a simple colored rectangle as logo
convert -size 200x60 xc:blue logo-light.png
convert -size 200x60 xc:white logo-dark.png

# Create a gradient background
convert -size 1920x1080 gradient:blue-lightblue background.jpg

# Create a simple favicon
convert -size 32x32 xc:blue favicon.ico
```

Note: The `convert` command requires ImageMagick to be installed.