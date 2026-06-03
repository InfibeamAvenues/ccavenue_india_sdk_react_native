require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "ccavenue-india-sdk-react-native"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { :git => "https://www.ia.ooo/.git", :tag => "#{s.version}" }
  s.pod_target_xcconfig = {
    'CLANG_ENABLE_MODULES' => 'YES',
    'SWIFT_VERSION' => '5.0',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "${PODS_TARGET_SRCROOT}/ios/CCAvenueIndiaSDK.xcframework/ios-arm64" "${PODS_TARGET_SRCROOT}/ios/CCAvenueIndiaSDK.xcframework/ios-arm64_x86_64-simulator"'
  }

  s.source_files = "ios/**/*.{h,m,mm,swift,cpp}"
  s.private_header_files = "ios/**/*.h"
  s.vendored_frameworks = "ios/CCAvenueIndiaSDK.xcframework"

  s.dependency "React-Core"
  install_modules_dependencies(s)
end
