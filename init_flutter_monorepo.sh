#!/bin/bash

# Check if a project name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <PROJECT_NAME>"
  exit 1
fi

PROJECT_NAME=$1

echo ""
echo "Initializing Melos for the project '$PROJECT_NAME'..."
echo ""

# Unicode characters
unicodeFolder="📂"
unicodeLoading="🔁"
unicodeValid="✅"
unicodeFailed="❌"
unicodeRocket="🚀"
unicodeMemo="📝"
unicodeAccentGrave="`")

# Create the project folder
echo "$folder Creating the project folder '$PROJECT_NAME'..."
if [ ! -d "$PROJECT_NAME" ]; then
  mkdir "$PROJECT_NAME"
  cd "$PROJECT_NAME" || exit
  echo "$valid Project folder '$PROJECT_NAME' created."
  echo ""
else
  echo "$failed Project folder '$PROJECT_NAME' already exists or cannot be created."
  echo ""
  exit 1
fi

# Activate Melos globally
echo "$loading Activating Melos globally..."
if ! dart pub global activate melos; then
  echo "$failed Failed to activate Melos."
  echo ""
  exit 1
else
  echo "$valid Melos activated globally."
  echo ""
fi

# Activate Very Good CLI globally
echo "$loading Activating Very Good CLI globally..."
if ! dart pub global activate very_good_cli; then
  echo "$failed Failed to activate Very Good CLI."
  echo ""
  exit 1
else
  echo "$valid Very Good CLI activated globally."
  echo ""
fi

# Create the 'apps' and 'packages' directories at the root
echo "$folder Creating 'apps' and 'packages' directories at the root..."
if mkdir -p apps; then
  echo "$valid 'apps' directory created."
else
  echo "$failed Failed to create 'apps' directory."
  echo ""
  exit 1
fi

if mkdir -p packages; then
  echo "$valid 'packages' directory created."
  echo ""
else
  echo "$failed Failed to create 'packages' directory."
  echo ""
  exit 1
fi

# Create 'pubspec.yaml' file with required content
echo "$memo Add 'pubspec.yaml' file !"
cat <<EOF >pubspec.yaml
name: $PROJECT_NAME

environment:
  sdk: '>=3.0.0 <4.0.0'
EOF
echo ""

# Create 'clean-pubspec-overrides' file
echo "$memo Add 'clean-pubspec-overrides.sh' file !"
cat <<EOF >clean-pubspec-overrides.sh
#!/bin/bash

# Use the find command to locate and delete pubspec_overrides.yaml files
find . -type f -name "pubspec_overrides.yaml" -exec rm -f {} \;

# Indicate the operation is complete
echo "All pubspec_overrides.yaml files have been deleted from subdirectories."
EOF
echo ""

echo "$loading Adding Melos as a development dependency..."
if ! dart pub add melos --dev; then
  echo "$failed Failed to add Melos as a development dependency."
  echo ""
  exit 1
else
  echo "$valid Melos added as a development dependency."
  echo ""
fi

# Create 'melos.yaml' file with required content
echo "$memo Add 'melos.yaml' file !"
cat <<EOF >melos.yaml
name: $PROJECT_NAME

packages:
  - apps/**
  - packages/**

scripts:
  clean-pubspec-overrides:
    run: bash clean-pubspec-overrides.sh
EOF
echo ""

# Add README.md file
echo "$memo Add 'README.md' file !"
cat <<EOF >README.md
# $PROJECT_NAME
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos) [![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis) 

## Update dependencies

${accentGrave}${accentGrave}${accentGrave} bash
melos bootstrap
${accentGrave}${accentGrave}${accentGrave}

## Create new application

In the ${accentGrave}apps${accentGrave} folder, run the command :
${accentGrave}${accentGrave}${accentGrave} bash
flutter create new_app
${accentGrave}${accentGrave}${accentGrave}

## Create a new package
In the ${accentGrave}packages${accentGrave} folder, run the command :
${accentGrave}${accentGrave}${accentGrave} bash
very_good create flutter_package package_name --desc "Package Description"
${accentGrave}${accentGrave}${accentGrave}
EOF
echo ""

# Add README.md file in 'apps' directory
echo "$memo Add 'README.md' file in 'apps' directory !"
cat <<EOF >apps/README.md
# apps
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

This directory contains all the applications for the project.

## Create a new Flutter app

${accentGrave}${accentGrave}${accentGrave} bash
flutter create app
${accentGrave}${accentGrave}${accentGrave}

## Add a ${accentGrave}.env${accentGrave}

In the root app folder, create a ${accentGrave}.env${accentGrave} file and the in the ${accentGrave}pubspec.yaml${accentGrave}, add the next section in ${accentGrave}flutter${accentGrave} :

${accentGrave}${accentGrave}${accentGrave} yaml
flutter:
  assets:
    - .env
${accentGrave}${accentGrave}${accentGrave}

## Add a local package dependencies

If you want to add the package ${accentGrave}my_package${accentGrave} created in the ${accentGrave}packages/${accentGrave} folder in your app. Open ${accentGrave}pubspec.yaml${accentGrave} and in the ${accentGrave}dependencies${accentGrave} section add the following line :

${accentGrave}${accentGrave}${accentGrave} yaml
dependencies:
    my_package:
${accentGrave}${accentGrave}${accentGrave}

Then, to update the dependencies, run the following command :
${accentGrave}${accentGrave}${accentGrave} bash
melos bootstrap
${accentGrave}${accentGrave}${accentGrave}
EOF
echo ""

# Add README.md file in 'packages' directory
echo "$memo Add 'README.md' file in 'packages' directory !"
cat <<EOF >packages/README.md
# packages

[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

This directory contains all the packages for the project.

## Init a package

To init a new package, we use ${accentGrave}very_good_cli${accentGrave}. The library provides templates for packages and apps.

To create a new package, run the command :

${accentGrave}${accentGrave}${accentGrave} bash
very_good create flutter_package package_name --desc "Package Description"
${accentGrave}${accentGrave}${accentGrave}
EOF
echo ""

# Run the melos bootstrap command
echo "$loading Running the melos bootstrap command..."
if melos bootstrap; then
  echo "$valid 'melos bootstrap' executed successfully."
  echo ""
  echo "$rocket Project '$PROJECT_NAME' configured successfully!"
  echo ""
else
  echo "$failed Failed to execute melos bootstrap."
  echo ""
  exit 1
fi
