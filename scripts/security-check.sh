#!/bin/bash

# Security Check Script for Proxi Health
# Run this before committing to ensure no sensitive data is exposed

echo "🔍 Running Security Check..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ISSUES_FOUND=0

# Check for sensitive files that should not be committed
echo "📁 Checking for sensitive files..."

SENSITIVE_FILES=(
    "lib/firebase_options.dart"
    "android/app/google-services.json"
    "ios/Runner/GoogleService-Info.plist"
    "firebase.json"
    ".env"
    ".env.local"
    ".env.production"
)

for file in "${SENSITIVE_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${RED}❌ SECURITY RISK: $file exists and may contain sensitive data${NC}"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
done

# Check for API keys in code
echo "🔑 Scanning for API keys..."

API_KEY_PATTERNS=(
    "AIzaSy[A-Za-z0-9_-]+"
    "[0-9]{10,15}"
    "AAAA[A-Za-z0-9_-]+:[A-Za-z0-9_-]+"
)

for pattern in "${API_KEY_PATTERNS[@]}"; do
    if grep -r -E "$pattern" lib/ --exclude-dir=test 2>/dev/null | grep -v "example" | grep -v "YOUR_" | grep -v "PLACEHOLDER"; then
        echo -e "${RED}❌ POTENTIAL API KEY FOUND: Check the files above${NC}"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
done

# Check .gitignore
echo "📝 Verifying .gitignore..."

REQUIRED_IGNORES=(
    "lib/firebase_options.dart"
    "**/google-services.json"
    "**/GoogleService-Info.plist"
    "firebase.json"
    ".env"
)

for ignore in "${REQUIRED_IGNORES[@]}"; do
    if ! grep -q "$ignore" .gitignore; then
        echo -e "${YELLOW}⚠️  WARNING: $ignore not found in .gitignore${NC}"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
done

# Check for template files
echo "📋 Verifying template files exist..."

TEMPLATE_FILES=(
    "lib/firebase_options.example.dart"
    "android/app/google-services.example.json"
    "firebase.example.json"
)

for template in "${TEMPLATE_FILES[@]}"; do
    if [ ! -f "$template" ]; then
        echo -e "${YELLOW}⚠️  WARNING: Template file missing: $template${NC}"
    fi
done

# Final result
echo ""
if [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${GREEN}✅ SECURITY CHECK PASSED: Repository is safe to commit${NC}"
    exit 0
else
    echo -e "${RED}❌ SECURITY CHECK FAILED: $ISSUES_FOUND issues found${NC}"
    echo -e "${RED}🚨 DO NOT COMMIT until all issues are resolved${NC}"
    exit 1
fi