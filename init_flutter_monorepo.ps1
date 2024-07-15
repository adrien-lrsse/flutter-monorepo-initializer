param (
  [Parameter(Mandatory = $true)]
  [string]$PROJECT_NAME
)

Write-Host ""
Write-Host "Initializing Melos for the project '$PROJECT_NAME'..."
Write-Host ""

$unicodeFolder = 0x1F4C2
$folder = [char]::ConvertFromUtf32($unicodeFolder)

$unicodeLoading = 0x1F501
$loading = [char]::ConvertFromUtf32($unicodeLoading)

$unicodeValid = 0x2705
$valid = [char]::ConvertFromUtf32($unicodeValid)

$unicodeFailed = 0x274C
$failed = [char]::ConvertFromUtf32($unicodeFailed)

$unicodeRocket = 0x1F680
$rocket = [char]::ConvertFromUtf32($unicodeRocket)

$unicodeMemo = 0x1F4DD
$memo = [char]::ConvertFromUtf32($unicodeMemo)

$unicodeAccentGrave = 0x0060
$accentGrave = [char]::ConvertFromUtf32($unicodeAccentGrave)

# Create the project folder
Write-Host "$folder Creating the project folder '$PROJECT_NAME'..."
if (!(Test-Path $PROJECT_NAME -PathType Container)) {
  New-Item -ItemType Directory -Path $PROJECT_NAME | Out-Null
  Set-Location -Path $PROJECT_NAME
  Write-Host "$valid Project folder '$PROJECT_NAME' created."
  Write-Host ""
}
else {
  Write-Host "$failed Project folder '$PROJECT_NAME' already exists or cannot be created."
  Write-Host ""
  exit 1
}

# Activate Melos globally
Write-Host "$loading Activating Melos globally..."
if (!(dart pub global activate melos)) {
  Write-Host "$failed Failed to activate Melos."
  Write-Host ""
  exit 1
}
else {
  Write-Host "$valid Melos activated globally."
  Write-Host ""
}

# Create the 'apps' and 'packages' directories at the root
Write-Host "$folder Creating 'apps' and 'packages' directories at the root..."
$appsDir = New-Item -ItemType Directory -Path "apps" -ErrorAction SilentlyContinue
$packagesDir = New-Item -ItemType Directory -Path "packages" -ErrorAction SilentlyContinue

if ($appsDir -ne $null) {
  Write-Host "$valid 'apps' directory created."
}
else {
  Write-Host "$failed Failed to create 'apps' directory."
  Write-Host ""
  exit 1
}

if ($packagesDir -ne $null) {
  Write-Host "$valid 'packages' directory created."
  Write-Host ""
}
else {
  Write-Host "$failed Failed to create 'packages' directory."
  Write-Host ""
  exit 1
}

# Create 'pubspec.yaml' file with required content
Write-Output "$memo Add 'pubspec.yaml' file !"
@"
name: $PROJECT_NAME

environment:
  sdk: '>=3.0.0 <4.0.0'

"@ | Out-File -Encoding utf8 pubspec.yaml
Write-Output ""

# Create 'clean-pubspec-overrides' file
Write-Output "$memo Add 'clean-pubspec-overrides.sh' file !"
@"
#!/bin/bash

# Use the find command to locate and delete pubspec_overrides.yaml files
find . -type f -name "pubspec_overrides.yaml" -exec rm -f {} \;

# Indicate the operation is complete
echo "All pubspec_overrides.yaml files have been deleted from subdirectories."
"@ | Out-File -Encoding utf8 clean-pubspec-overrides.sh
Write-Output ""
Write-Host "$loading Adding Melos as a development dependency..."
dart pub add melos --dev
if ($LASTEXITCODE -ne 0) {
  Write-Host "$failed Failed to add Melos as a development dependency."
  Write-Host ""
  exit 1  # Quitte le script avec un code d'erreur
}
else {
  Write-Host "$valid Melos added as a development dependency."
  Write-Host ""
}



# Create 'melos.yaml' file with required content
Write-Output "$memo Add 'melos.yaml' file !"
@"
name: $PROJECT_NAME

packages:
  - apps/**
  - packages/**

scripts:
  clean-pubspec-overrides:
    run: bash clean-pubspec-overrides.sh
"@ | Out-File -Encoding utf8 melos.yaml
Write-Output ""

# Add README.md file
Write-Output "$memo Add 'README.md' file !"
@"
# $PROJECT_NAME
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos) [![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis) 


## Update dependencies

$accentGrave$accentGrave$accentGrave bash
melos bootstrap
$accentGrave$accentGrave$accentGrave

## Create new application

In the $accentGrave apps $accentGrave folder, run the command :
$accentGrave$accentGrave$accentGrave bash
flutter create new_app
$accentGrave$accentGrave$accentGrave

## Create a new package
In the $accentGrave packages $accentGrave folder, run the command :
$accentGrave$accentGrave$accentGrave bash
very_good create flutter_package package_name --desc "Package Description"
$accentGrave$accentGrave$accentGrave
"@ | Out-File -Encoding utf8 README.md
Write-Output ""

try {
  Write-Host "$loading Running the melos bootstrap command..."
  melos bootstrap
  Write-Host "$valid 'melos bootstrap' executed successfully."
  Write-Host ""
  Write-Host "$rocket Project '$PROJECT_NAME' configured successfully!"
  Write-Host ""
}
catch {
  Write-Host "$failed Failed to execute melos bootstrap."
  Write-Host ""
  exit 1
}
