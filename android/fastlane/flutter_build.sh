#!/bin/bash
cd ../../
if [ "$1" == "--prod" ]; then
    echo "Running Build Apk Build for Production Release..."
    flutter build apk --flavor prod
elif [ "$1" == "--staging" ]; then
    echo "Running APK Build for Staging Release..."
    flutter build apk --flavor uat
elif [ "$1" == "--dev" ]; then
    echo "Running APK Build for Development Release..."
    flutter build apk --flavor dev
else
    echo "Running Build App Bundle for Production Release..."
    flutter build appbundle --flavor prod
fi