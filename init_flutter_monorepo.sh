#!/bin/bash

# Ensure the PROJECT_NAME variable is provided
if [ -z "$1" ]; then
  echo "Error: PROJECT_NAME is required."
  exit 1
fi

PROJECT_NAME=$1

echo ""
echo "Initializing Melos for the project '$PROJECT_NAME'..."
echo ""

unicodeFolder="📂"
unicodeLoading="🔁"
unicodeValid="✅"
unicodeFailed="❌"
unicodeRocket="🚀"
unicodeMemo="📝"
unicodeAccentGrave="`"

# Create the project folder
echo "$unicodeFolder Creating the project folder '$PROJECT_NAME'..."
if [ ! -d "$PROJECT_NAME" ]; then
  mkdir "$PROJECT_NAME"
  cd "$PROJECT_NAME" || exit
  echo "$unicodeValid Project folder '$PROJECT_NAME' created."
  echo ""
else
  echo "$unicodeFailed Project folder '$PROJECT_NAME' already exists or cannot be created."
  echo ""
  exit 1
fi

# Activate Melos globally
echo "$unicodeLoading Activating Melos globally..."
if ! dart pub global activate melos; then
  echo "$unicodeFailed Failed to activate Melos."
  echo ""
  exit 1
else
  echo "$unicodeValid Melos activated globally."
  echo ""
fi

# Create the 'apps' and 'packages' directories at the root
echo "$unicodeFolder Creating 'apps' and 'packages' directories at the root..."
if mkdir -p "apps"; then
  echo "$unicodeValid 'apps' directory created."
else
  echo "$unicodeFailed Failed to create 'apps' directory."
  echo ""
  exit 1
fi

if mkdir -p "packages"; then
  echo "$unicodeValid 'packages' directory created."
  echo ""
else
  echo "$unicodeFailed Failed to create 'packages' directory."
  echo ""
  exit 1
fi

# Create 'pubspec.yaml' file with required content
echo "$unicodeMemo Add 'pubspec.yaml' file !"
cat <<EOL > pubspec.yaml
name: $PROJECT_NAME

environment:
  sdk: '>=3.0.0 <4.0.0'
EOL
echo ""

# Create 'clean-pubspec-overrides' file
echo "$unicodeMemo Add 'clean-pubspec-overrides.sh' file !"
cat <<'EOL' > clean-pubspec-overrides.sh
#!/bin/bash

# Use the find command to locate and delete pubspec_overrides.yaml files
find . -type f -name "pubspec_overrides.yaml" -exec rm -f {} \;

# Indicate the operation is complete
echo "All pubspec_overrides.yaml files have been deleted from subdirectories."
EOL
chmod +x clean-pubspec-overrides.sh
echo ""

echo "$unicodeLoading Adding Melos as a development dependency..."
if ! dart pub add melos --dev; then
  echo "$unicodeFailed Failed to add Melos as a development dependency."
  echo ""
  exit 1
else
  echo "$unicodeValid Melos added as a development dependency."
  echo ""
fi

# Create 'melos.yaml' file with required content
echo "$unicodeMemo Add 'melos.yaml' file !"
cat <<EOL > melos.yaml
name: $PROJECT_NAME

packages:
  - apps/**
  - packages/**

scripts:
  clean-pubspec-overrides:
    run: bash clean-pubspec-overrides.sh
EOL
echo ""

# Add README.md file
echo "$unicodeMemo Add 'README.md' file !"
cat <<EOL > README.md
# $PROJECT_NAME
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos) [![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis) 

## Update dependencies

${unicodeAccentGrave}${unicodeAccentGrave}${unicodeAccentGrave} bash
melos bootstrap
${unicodeAccentGrave}${unicodeAccentGrave}${unicodeAccentGrave}

## Create new application

In the ${unicodeAccentGrave}apps${unicodeAccentGrave} folder, run the command :
${unicodeAccentGrave}${unicodeAccentGrave}${unicodeAccentGrave} bash
flutter create new_app
${unicodeAccentGrave}${unicodeAccentGrave}${unicodeAccentGrave}

## Create a new package
In the ${unicodeAccentGrave}packages${unicodeAccentGrave} folder, run the command :
${unicodeAccentGrave}${unicodeAccentGrave}${unicodeAccentGrave} bash
very_good create flutter_package package_name --desc "Package Description"
${unicodeAccentGrave}${unicodeAccentGrave}${unicodeAccentGrave}
EOL
echo ""

echo "$unicodeLoading Running the melos bootstrap command..."
if melos bootstrap; then
  echo "$unicodeValid 'melos bootstrap' executed successfully."
  echo ""
  echo "$unicodeRocket Project '$PROJECT_NAME' configured successfully!"
  echo ""
else
  echo "$unicodeFailed Failed to execute melos bootstrap."
  echo ""
  exit 1
fi
