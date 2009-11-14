
# ================================================================================
# BuildKit - Libraries Build Script
# Copyright (c) 2009, Semantap.
# Created: June 12, 2009     - dpm
# Updated: September 8, 2009 - dpm
# Updated: November 13, 2009 - dpm 
# ================================================================================

# ================================================================================
# Note
# ================================================================================
# The SDKVersion is now ignored but still required. The script and xcconfigs have 
# been refactored to always use latest SDKROOT and set IPHONEOS_DEPLOYMENT_TARGET
# to the desired OS version. See Configurations/Platform.xcconfig
# ================================================================================

Usage()
{
    builtin echo "iPhone Build Script, version 1.0\n"
    builtin echo "Usage: Build.command <SDKVersion> <BuildConfiguration>"
    builtin echo "\t<SDKVersion>         = A SDK Version"
    builtin echo "\t\tAvailable          = [3.1.2 (Default)]"
    builtin echo "\t<BuildConfiguration> = A Build Configuration"
    builtin echo "\t\tAvailable          = [Debug (Default)| Profile | Release | Adhoc | Distribution]"
    builtin echo "\n"
}

set -e

# process arguments
if [ $# -eq 1 ]; then
    SELECTED_SDK_VERSION="$1"
    Usage
    exit 1
elif [ $# -eq 2 ]; then
    SELECTED_SDK_VERSION="$1"
    SELECTED_BUILD_CONFIGURATION="$2"
else
    Usage
    exit 1
fi

echo $TARGET_SDK_VERSION
echo $TARGET_SDK_TYPE

# ================================================================================
# Debug | Profile | Release | Adhoc | Distribution
# ================================================================================

export BUILD_CONFIGURATION=$SELECTED_BUILD_CONFIGURATION
export BUILD_SDK_VERSION=$SELECTED_SDK_VERSION


# ================================================================================
# iphoneos[*] | iphonesimulator[*]
# ================================================================================

export BUILD_DEVICE_SDK_NAME=iphoneos
export BUILD_SIMULATOR_SDK_NAME=iphonesimulator

export BUILD_DEVICE_SDK=$BUILD_DEVICE_SDK_NAME$BUILD_SDK_VERSION
export BUILD_SIMULATOR_SDK=$BUILD_SIMULATOR_SDK_NAME$BUILD_SDK_VERSION


# ================================================================================
# Current working directory.
# ================================================================================

export BUILD_ROOT=$PWD
export LIBRARIES_ROOT=$PWD/Libraries
export VENDOR_ROOT=$PWD/Vendors


# ================================================================================
# Location of Shared Build Directory
# ================================================================================

export BUILD_DIR=../Build/

# ================================================================================
# Location of Shared Build Libraries
# ================================================================================

export BUILD_SDK_DIR=$BUILD_DIR/Libraries

echo "Xcode Version"
echo "________________________________________________________________________________\n"
xcodebuild -version
echo "\n"

echo "Available SDKs"
echo "________________________________________________________________________________\n"
xcodebuild -showsdks
echo "\n"

echo "SDK Versions"
echo "________________________________________________________________________________\n"
xcodebuild -version -sdk $BUILD_DEVICE_SDK
xcodebuild -version -sdk $BUILD_SIMULATOR_SDK
echo "\n"


echo "Build Configuration"
echo "________________________________________________________________________________\n"

echo "Build Configuration  =" $BUILD_CONFIGURATION
echo "Build SDK Version    =" $BUILD_SDK_VERSION
echo "Device SDK Name      =" $BUILD_DEVICE_SDK
echo "Simulator SDK Name   =" $BUILD_SIMULATOR_SDK
echo "Root Build Directory =" $BUILD_ROOT
echo "Deployment Directory =" $BUILD_SDK_DIR
echo "\n"


# ================================================================================
# Clean
# ================================================================================

echo "Cleaning Deployed Libraries"
echo "________________________________________________________________________________\n"

rm -dRfv $BUILD_SDK_DIR/$BUILD_DEVICE_SDK_NAME.sdk/$BUILD_SDK_VERSION/JSONKit
rm -dRfv $BUILD_SDK_DIR/$BUILD_SIMULATOR_SDK_NAME.sdk/$BUILD_SDK_VERSION/JSONKit

rm -dRfv $BUILD_SDK_DIR/$BUILD_DEVICE_SDK_NAME.sdk/$BUILD_SDK_VERSION/XMLKit
rm -dRfv $BUILD_SDK_DIR/$BUILD_SIMULATOR_SDK_NAME.sdk/$BUILD_SDK_VERSION/XMLKit

rm -dRfv $BUILD_SDK_DIR/$BUILD_DEVICE_SDK_NAME.sdk/$BUILD_SDK_VERSION/UXKit
rm -dRfv $BUILD_SDK_DIR/$BUILD_SIMULATOR_SDK_NAME.sdk/$BUILD_SDK_VERSION/UXKit


# ================================================================================
# Libraries
# ================================================================================ 

echo "Building UXKit"
echo "________________________________________________________________________________\n"
cd $LIBRARIES_ROOT/UXKit

echo "Cleaning..."
xcodebuild -sdk $BUILD_DEVICE_SDK -target UXKit -configuration $BUILD_CONFIGURATION -project UXKit.xcodeproj clean
xcodebuild -sdk $BUILD_SIMULATOR_SDK -target UXKit -configuration $BUILD_CONFIGURATION -project UXKit.xcodeproj clean

echo "Building..."
xcodebuild -sdk $BUILD_DEVICE_SDK -target UXKit -configuration $BUILD_CONFIGURATION -project UXKit.xcodeproj build
xcodebuild -sdk $BUILD_SIMULATOR_SDK -target UXKit -configuration $BUILD_CONFIGURATION -project UXKit.xcodeproj build


# ================================================================================
# Vendor Libraries
# ================================================================================

echo "Building JSONKit"
echo "________________________________________________________________________________\n"
cd $VENDOR_ROOT/JSONKit

echo "Cleaning..."
xcodebuild -sdk $BUILD_DEVICE_SDK -target JSONKit -configuration $BUILD_CONFIGURATION -project JSONKit.xcodeproj clean
xcodebuild -sdk $BUILD_SIMULATOR_SDK -target JSONKit -configuration $BUILD_CONFIGURATION -project JSONKit.xcodeproj clean

echo "Building..."
xcodebuild -sdk $BUILD_DEVICE_SDK -target JSONKit -configuration $BUILD_CONFIGURATION -project JSONKit.xcodeproj build
xcodebuild -sdk $BUILD_SIMULATOR_SDK -target JSONKit -configuration $BUILD_CONFIGURATION -project JSONKit.xcodeproj build


echo "Building XMLKit"
echo "________________________________________________________________________________\n"
cd $VENDOR_ROOT/XMLKit

echo "Cleaning..."
xcodebuild -sdk $BUILD_DEVICE_SDK -target XMLKit -configuration $BUILD_CONFIGURATION -project XMLKit.xcodeproj clean
xcodebuild -sdk $BUILD_SIMULATOR_SDK -target XMLKit -configuration $BUILD_CONFIGURATION -project XMLKit.xcodeproj clean

echo "Building..."
xcodebuild -sdk $BUILD_DEVICE_SDK -target XMLKit -configuration $BUILD_CONFIGURATION -project XMLKit.xcodeproj build
xcodebuild -sdk $BUILD_SIMULATOR_SDK -target XMLKit -configuration $BUILD_CONFIGURATION -project XMLKit.xcodeproj build
