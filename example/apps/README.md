# apps
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

This directory contains all the applications for the project.

## Create a new Flutter app

``` bash
flutter create app
```

## Add a ` .env `

In the root app folder, create a ` .env ` file and the in the ` pubspec.yaml `, add the next section in ` flutter ` :

``` yaml
flutter:
  assets:
    - .env
```

## Add a local package dependencies

If you want to add the package ` my_package ` created in the ` packages/ ` folder in your app. Open ` pubspec.yaml ` and in the ` dependencies ` section add the following line :

``` yaml
dependencies:
    my_package:
```

Then, to update the dependencies, run the following command :
``` bash
melos bootstrap
```

