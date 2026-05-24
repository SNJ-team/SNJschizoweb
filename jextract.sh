#!/bin/bash
swift run --package-path ~/SNJ/libs/swift-java swift-java jextract \
  --mode jni \
  --input-swift ~/SNJ/projects/SNJschizoweb/Sources/SNJschizoweb \
  --swift-module SNJschizoweb \
  --output-swift ~/SNJ/projects/SNJschizoweb/Sources/SNJschizoweb/generated \
  --output-java ~/SNJ/projects/SNJschizoweb/java/generated/java \
  --java-package com.snj
