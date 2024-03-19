# Creating XCFramework

## Make Platform archives

macOS

```
xcodebuild archive -project SwiftySpot.xcodeproj -scheme SwiftySpot \
-destination "generic/platform=macOS" -archivePath "archives/SwiftySpot-macOS" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
```

iOS simulator

```
xcodebuild archive -project SwiftySpot.xcodeproj -scheme SwiftySpot \
-destination "generic/platform=iOS Simulator" -archivePath "archives/SwiftySpot-iOSSim" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
```

iOS

```
xcodebuild archive -project SwiftySpot.xcodeproj -scheme SwiftySpot \
-destination "generic/platform=iOS" -archivePath "archives/SwiftySpot-iOS" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
```

watchOS

```
xcodebuild archive -project SwiftySpot.xcodeproj -scheme SwiftySpot \
-destination "generic/platform=watchOS" -archivePath "archives/SwiftySpot-watchOS" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
```

tvOS

```
xcodebuild archive -project SwiftySpot.xcodeproj -scheme SwiftySpot \
-destination "generic/platform=tvOS" -archivePath "archives/SwiftySpot-tvOS" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
```

## Build XCFramework

```
xcodebuild -create-xcframework \
-framework archives/SwiftySpot-macOS.xcarchive/Products/Library/Frameworks/SwiftySpot.framework -debug-symbols "$(pwd -P)"/archives/SwiftySpot-macOS.xcarchive/dSYMs/SwiftySpot.framework.dSYM \
-framework archives/SwiftySpot-iOSSim.xcarchive/Products/Library/Frameworks/SwiftySpot.framework -debug-symbols "$(pwd -P)"/archives/SwiftySpot-iOSSim.xcarchive/dSYMs/SwiftySpot.framework.dSYM \
-framework archives/SwiftySpot-iOS.xcarchive/Products/Library/Frameworks/SwiftySpot.framework -debug-symbols "$(pwd -P)"/archives/SwiftySpot-iOS.xcarchive/dSYMs/SwiftySpot.framework.dSYM \
-framework archives/SwiftySpot-watchOS.xcarchive/Products/Library/Frameworks/SwiftySpot.framework -debug-symbols "$(pwd -P)"/archives/SwiftySpot-watchOS.xcarchive/dSYMs/SwiftySpot.framework.dSYM \
-framework archives/SwiftySpot-tvOS.xcarchive/Products/Library/Frameworks/SwiftySpot.framework -debug-symbols "$(pwd -P)"/archives/SwiftySpot-tvOS.xcarchive/dSYMs/SwiftySpot.framework.dSYM \
-output archives/SwiftySpot.xcframework
```
