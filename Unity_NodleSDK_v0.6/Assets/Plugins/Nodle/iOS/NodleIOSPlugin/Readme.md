place the entries in the folowing files:


info.plist

 <key>NSBluetoothAlwaysUsageDescription</key>
    <string>Need for scan</string>
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>We need location access to scan properly</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>We need it to be able to scan</string>
    <key>NSLocationUsageDescription</key>
    <string>We need location for background</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>location is required for nodle</string>
    <key>UIBackgroundModes</key>
    <array>
      <string>bluetooth-central</string>
      <string>bluetooth-peripheral</string>
      <string>fetch</string>
      <string>location</string>
      <string>processing</string>
    </array>



Podfile you can extend this file and more pods if you require.


platform :ios, '13.0'

target 'UnityFramework' do
  use_frameworks! 

  pod 'NodleSDK'
  pod 'SQLite.swift', '~> 0.13.3'
  pod 'SwiftCBOR', '~> 0.4.5'
  pod 'SwiftProtobuf', '~> 1.19.0'
  target 'Unity-iPhone' do
  end
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name == "SQLite.swift" or target.name == "SwiftCBOR" or  target.name == "SwiftProtobuf" or target.name == "NodleSDK"
        target.build_configurations.each do |config|
          config.build_settings["BUILD_LIBRARY_FOR_DISTRIBUTION"] = "YES"
        end
      end
    end
  end

