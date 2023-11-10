Pod::Spec.new do |spec|
  spec.name         = "SwiftySpot"
  spec.version      = "0.4.10"
  spec.summary      = "Unofficial Spotify API"
  spec.homepage     = "https://github.com/mIwr/SwiftySpot"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "mIwr" => "https://github.com/mIwr" }
  spec.ios.deployment_target = "11.0"
  spec.osx.deployment_target = "10.13"
  spec.swift_version = "5.0"
  spec.source        = { :git => "https://github.com/mIwr/SwiftySpot.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/SwiftySpot/*.swift", "Sources/SwiftySpot/**/*.swift"
  spec.exclude_files = "Sources/Exclude", "Sources/Exclude/*.*"
  spec.framework     = "Foundation"
  spec.dependency      "SwiftProtobuf"
end
