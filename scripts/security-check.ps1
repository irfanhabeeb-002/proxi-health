# Security Check Script for Proxi Health (PowerShell)
# Run this before committing to ensure no sensitive data is exposed

Write-Host "Running Security Check..." -ForegroundColor Cyan

$IssuesFound = 0

# Check for sensitive files that should not be committed
Write-Host "Checking for sensitive files..." -ForegroundColor Yellow

$SensitiveFiles = @(
    "lib/firebase_options.dart",
    "android/app/google-services.json",
    "ios/Runner/GoogleService-Info.plist",
    "firebase.json",
    ".env",
    ".env.local",
    ".env.production"
)

foreach ($file in $SensitiveFiles) {
    if (Test-Path $file) {
        Write-Host "SECURITY RISK: $file exists and may contain sensitive data" -ForegroundColor Red
        $IssuesFound++
    }
}

# Check for API keys in code
Write-Host "Scanning for API keys..." -ForegroundColor Yellow

$ApiKeyPatterns = @(
    "AIzaSy[A-Za-z0-9_-]+",
    "[0-9]{10,15}",
    "AAAA[A-Za-z0-9_-]+:[A-Za-z0-9_-]+"
)

foreach ($pattern in $ApiKeyPatterns) {
    $matches = Select-String -Path "lib/*.dart" -Pattern $pattern -Exclude "*example*", "*template*" 2>$null
    if ($matches) {
        Write-Host "POTENTIAL API KEY FOUND: Check the files above" -ForegroundColor Red
        $matches | ForEach-Object { Write-Host "   $($_.Filename):$($_.LineNumber) - $($_.Line.Trim())" -ForegroundColor Red }
        $IssuesFound++
    }
}

# Check .gitignore
Write-Host "Verifying .gitignore..." -ForegroundColor Yellow

$RequiredIgnores = @(
    "lib/firebase_options.dart",
    "**/google-services.json",
    "**/GoogleService-Info.plist",
    "firebase.json",
    ".env"
)

$gitignoreContent = Get-Content .gitignore -ErrorAction SilentlyContinue

foreach ($ignore in $RequiredIgnores) {
    if (-not ($gitignoreContent -contains $ignore)) {
        Write-Host "WARNING: $ignore not found in .gitignore" -ForegroundColor Yellow
        $IssuesFound++
    }
}

# Check for template files
Write-Host "Verifying template files exist..." -ForegroundColor Yellow

$TemplateFiles = @(
    "lib/firebase_options.example.dart",
    "android/app/google-services.example.json",
    "firebase.example.json"
)

foreach ($template in $TemplateFiles) {
    if (-not (Test-Path $template)) {
        Write-Host "WARNING: Template file missing: $template" -ForegroundColor Yellow
    }
}

# Final result
Write-Host ""
if ($IssuesFound -eq 0) {
    Write-Host "SECURITY CHECK PASSED: Repository is safe to commit" -ForegroundColor Green
    exit 0
} else {
    Write-Host "SECURITY CHECK FAILED: $IssuesFound issues found" -ForegroundColor Red
    Write-Host "DO NOT COMMIT until all issues are resolved" -ForegroundColor Red
    exit 1
}