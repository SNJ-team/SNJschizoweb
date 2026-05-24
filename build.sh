#!/bin/bash

# Change to "release" for production build
BUILD_CONFIG="debug"
# BUILD_CONFIG="release"

set -e

# Fix libswiftCompatibilitySpan if needed
if [ ! -f ~/SNJ/libs/swift-java/.build/arm64-apple-macosx/debug/libswiftCompatibilitySpan.dylib ]; then
    echo "Fixing libswiftCompatibilitySpan..."
    cp "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift-6.2/macosx/libswiftCompatibilitySpan.dylib" "~/SNJ/libs/swift-java/.build/arm64-apple-macosx/debug/"
fi

echo "Extracting Java bindings from Swift..."
./jextract.sh

echo "Building Swift..."
swift build -c $BUILD_CONFIG --package-path ~/SNJ/projects/SNJschizoweb

if [ ! -f ~/SNJ/libs/swift-java/.build/arm64-apple-macosx/debug/libSwiftRuntimeFunctions.dylib ]; then
    echo "Building SwiftRuntimeFunctions..."
    swift build --package-path ~/SNJ/libs/swift-java --product SwiftRuntimeFunctions
fi

echo "Copying Swift libraries..."
mkdir -p ~/SNJ/server/SNJschizoweb/plugins/swiftlibs
mkdir -p ~/SNJ/projects/SNJschizoweb/dist/swiftlibs
cp ~/SNJ/projects/SNJschizoweb/.build/arm64-apple-macosx/$BUILD_CONFIG/libSNJschizoweb.dylib ~/SNJ/projects/SNJschizoweb/dist/swiftlibs/
cp ~/SNJ/projects/SNJschizoweb/.build/arm64-apple-macosx/$BUILD_CONFIG/libSwiftJava.dylib ~/SNJ/projects/SNJschizoweb/dist/swiftlibs/
cp ~/SNJ/libs/swift-java/.build/arm64-apple-macosx/debug/libSwiftRuntimeFunctions.dylib ~/SNJ/projects/SNJschizoweb/dist/swiftlibs/



echo "Building Java jar with updated bindings..."
cd ~/SNJ/projects/SNJschizoweb/java
gradle build
cp ~/SNJ/projects/SNJschizoweb/java/build/libs/SNJschizoweb.jar ~/SNJ/projects/SNJschizoweb/dist/

echo "Deploying..."
cp build/libs/SNJschizoweb.jar ~/SNJ/server/swiftandjava/plugins/
cp ~/SNJ/projects/SNJschizoweb/dist/swiftlibs/*.dylib ~/SNJ/server/swiftandjava/plugins/swiftlibs/

echo "Done!"
