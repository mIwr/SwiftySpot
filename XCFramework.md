# Creating XCFramework

## Make Platform archives

### From XCode project file

macOS

```
xcodebuild archive -project SwiftySpot.xcodeproj -scheme SwiftySpot \
-destination "generic/platform=macOS" -archivePath "archives/SwiftySpot-macOS" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
```

iOS

```
xcodebuild archive -project SwiftySpot.xcodeproj -scheme SwiftySpot \
-destination "generic/platform=iOS" -archivePath "archives/SwiftySpot-iOS" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
```

iOS simulator

```
xcodebuild archive -project SwiftySpot.xcodeproj -scheme SwiftySpot \
-destination "generic/platform=iOS Simulator" -archivePath "archives/SwiftySpot-iOSSim" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
```

watchOS

```
xcodebuild archive -project SwiftySpot.xcodeproj -scheme SwiftySpot \
-destination "generic/platform=watchOS" -archivePath "archives/SwiftySpot-watchOS" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
```

watchOS simulator

```
xcodebuild archive -project SwiftySpot.xcodeproj -scheme SwiftySpot \
-destination "generic/platform=watchOS Simulator" -archivePath "archives/SwiftySpot-watchOSSim" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
```

tvOS

```
xcodebuild archive -project SwiftySpot.xcodeproj -scheme SwiftySpot \
-destination "generic/platform=tvOS" -archivePath "archives/SwiftySpot-tvOS" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
```

tvOS Simulator

```
xcodebuild archive -project SwiftySpot.xcodeproj -scheme SwiftySpot \
-destination "generic/platform=tvOS Simulator" -archivePath "archives/SwiftySpot-tvOSSim" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
```

### From Package.swift file

First of all you need set lybrary type as *.dynamic*

```swift
//...
products: [
        .library(
            name: "SwiftySpot",
            type: .dynamic,
            targets: ["SwiftySpot"]),
],
//...
```

macOS

```
xcodebuild archive -scheme SwiftySpot -destination "generic/platform=macOS" \
-archivePath "archives/SwiftySpot-macOS" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
INSTALL_PATH=/Library/Frameworks MODULES_FOLDER_PATH=SwiftySpot.framework/Modules \
PRODUCT_TYPE=com.apple.product-type.framework \
PUBLIC_HEADERS_FOLDER_PATH=SwiftySpot.framework/Headers \
SWIFT_INSTALL_OBJC_HEADER=YES
```

iOS

```
xcodebuild archive -scheme SwiftySpot -destination "generic/platform=iOS" \
-archivePath "archives/SwiftySpot-iOS" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
INSTALL_PATH=/Library/Frameworks MODULES_FOLDER_PATH=SwiftySpot.framework/Modules \
PRODUCT_TYPE=com.apple.product-type.framework \
PUBLIC_HEADERS_FOLDER_PATH=SwiftySpot.framework/Headers \
SWIFT_INSTALL_OBJC_HEADER=YES
```

iOS simulator

```
xcodebuild archive -scheme SwiftySpot -destination "generic/platform=iOS Simulator" \
-archivePath "archives/SwiftySpot-iOSSim" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES DEFINE_MODULES=YES\
INSTALL_PATH=/Library/Frameworks MODULES_FOLDER_PATH=SwiftySpot.framework/Modules \
PRODUCT_TYPE=com.apple.product-type.framework \
PUBLIC_HEADERS_FOLDER_PATH=SwiftySpot.framework/Headers \
SWIFT_INSTALL_OBJC_HEADER=YES
```

watchOS

```
xcodebuild archive -scheme SwiftySpot -destination "generic/platform=watchOS" \
-archivePath "archives/SwiftySpot-watchOS" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
INSTALL_PATH=/Library/Frameworks MODULES_FOLDER_PATH=SwiftySpot.framework/Modules \
PRODUCT_TYPE=com.apple.product-type.framework \
PUBLIC_HEADERS_FOLDER_PATH=SwiftySpot.framework/Headers \
SWIFT_INSTALL_OBJC_HEADER=YES
```

watchOS Simulator

```
xcodebuild archive -scheme SwiftySpot -destination "generic/platform=watchOS Simulator" \
-archivePath "archives/SwiftySpot-watchOSSim" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
INSTALL_PATH=/Library/Frameworks MODULES_FOLDER_PATH=SwiftySpot.framework/Modules \
PRODUCT_TYPE=com.apple.product-type.framework \
PUBLIC_HEADERS_FOLDER_PATH=SwiftySpot.framework/Headers \
SWIFT_INSTALL_OBJC_HEADER=YES
```

tvOS

```
xcodebuild archive -scheme SwiftySpot -destination "generic/platform=tvOS" \
-archivePath "archives/SwiftySpot-tvOS" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
INSTALL_PATH=/Library/Frameworks MODULES_FOLDER_PATH=SwiftySpot.framework/Modules \
PRODUCT_TYPE=com.apple.product-type.framework \
PUBLIC_HEADERS_FOLDER_PATH=SwiftySpot.framework/Headers \
SWIFT_INSTALL_OBJC_HEADER=YES
```

tvOS Simulator

```
xcodebuild archive -scheme SwiftySpot -destination "generic/platform=tvOS Simulator" \
-archivePath "archives/SwiftySpot-tvOSSim" \
SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
INSTALL_PATH=/Library/Frameworks MODULES_FOLDER_PATH=SwiftySpot.framework/Modules \
PRODUCT_TYPE=com.apple.product-type.framework \
PUBLIC_HEADERS_FOLDER_PATH=SwiftySpot.framework/Headers \
SWIFT_INSTALL_OBJC_HEADER=YES
```

## Build XCFramework

```
xcodebuild -create-xcframework \
-framework archives/SwiftySpot-macOS.xcarchive/Products/Library/Frameworks/SwiftySpot.framework -debug-symbols "$(pwd -P)"/archives/SwiftySpot-macOS.xcarchive/dSYMs/SwiftySpot.framework.dSYM \
-framework archives/SwiftySpot-iOS.xcarchive/Products/Library/Frameworks/SwiftySpot.framework -debug-symbols "$(pwd -P)"/archives/SwiftySpot-iOS.xcarchive/dSYMs/SwiftySpot.framework.dSYM \
-framework archives/SwiftySpot-iOSSim.xcarchive/Products/Library/Frameworks/SwiftySpot.framework -debug-symbols "$(pwd -P)"/archives/SwiftySpot-iOSSim.xcarchive/dSYMs/SwiftySpot.framework.dSYM \
-framework archives/SwiftySpot-watchOS.xcarchive/Products/Library/Frameworks/SwiftySpot.framework -debug-symbols "$(pwd -P)"/archives/SwiftySpot-watchOS.xcarchive/dSYMs/SwiftySpot.framework.dSYM \
-framework archives/SwiftySpot-watchOSSim.xcarchive/Products/Library/Frameworks/SwiftySpot.framework -debug-symbols "$(pwd -P)"/archives/SwiftySpot-watchOSSim.xcarchive/dSYMs/SwiftySpot.framework.dSYM \
-framework archives/SwiftySpot-tvOS.xcarchive/Products/Library/Frameworks/SwiftySpot.framework -debug-symbols "$(pwd -P)"/archives/SwiftySpot-tvOS.xcarchive/dSYMs/SwiftySpot.framework.dSYM \
-framework archives/SwiftySpot-tvOSSim.xcarchive/Products/Library/Frameworks/SwiftySpot.framework -debug-symbols "$(pwd -P)"/archives/SwiftySpot-tvOSSim.xcarchive/dSYMs/SwiftySpot.framework.dSYM \
-output archives/SwiftySpot.xcframework
```

## SPM checksum

Compress XCFramework directory and compute the checksum for archive:
```
swift package compute-checksum archives/SwiftySpot.xcframework.zip
```
