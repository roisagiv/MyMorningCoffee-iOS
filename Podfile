platform :ios, "11.4"

pod "SwiftLint", "0.29.3"
pod "SwiftFormat/CLI", "0.37.2"
pod "IBLinter", "0.4.11"

plugin "cocoapods-keys", {
  :project => "MyMorningCoffee",
  :keys => [
    "MercuryWebParserKey",
    "FirebaseGoogleAppID",
    "FirebaseGCMSenderID",
    "FirebaseProjectID",
    "FirebaseClientID",
  ],
}

target "MyMorningCoffee" do
  use_frameworks!

  # Rx
  $Rx = "4.4.0"
  pod "RxSwift", $Rx
  pod "RxCocoa", $Rx
  pod "RxDataSources", "3.1.0"
  pod "RxWebKit", "0.3.7"
  pod "RxSwiftUtilities", "2.1.0"
  pod "Action", "3.9.1"

  # DI
  pod "Swinject", "2.5.0"

  # Network
  pod "Moya/RxSwift", "12.0.1"
  pod "AlamofireNetworkActivityLogger", "2.3.0"

  # DB
  pod "RxGRDB", "0.13.0"

  # UI
  pod "Reusable", "4.0.4"
  pod "Nuke", "7.5.2"
  pod "SwiftHEXColors", "1.2.0"
  pod "Skeleton", "0.3.1"

  # Firebase
  $Firebase = "5.15.0"
  pod "Firebase/Core", $Firebase
  pod "Firebase/Database", $Firebase
  pod "Firebase/Analytics", $Firebase
  pod "Firebase/ABTesting", $Firebase
  pod "Firebase/Performance", $Firebase
  pod "Firebase/RemoteConfig", $Firebase

  # Crashlytics
  pod "Fabric", "1.9.0"
  pod "Crashlytics", "3.12.0"

  # Material.io
  $MaterialComponents = "73.1.0"
  pod "MaterialComponents/AppBar", $MaterialComponents
  pod "MaterialComponents/AppBar+ColorThemer", $MaterialComponents
  pod "MaterialComponents/AppBar+TypographyThemer", $MaterialComponents
  pod "MaterialComponents/NavigationBar", $MaterialComponents
  pod "MaterialComponents/NavigationBar+ColorThemer", $MaterialComponents
  pod "MaterialComponents/NavigationBar+TypographyThemer", $MaterialComponents
  pod "MaterialComponents/Collections", $MaterialComponents
  pod "MaterialComponents/Cards", $MaterialComponents
  pod "MaterialComponents/Cards+ColorThemer", $MaterialComponents
  pod "MaterialComponents/ProgressView", $MaterialComponents
  pod "MaterialComponents/ProgressView+ColorThemer", $MaterialComponents
  pod "MaterialComponents/ActivityIndicator", $MaterialComponents
  pod "MaterialComponents/ActivityIndicator+ColorThemer", $MaterialComponents
  pod "MaterialComponents/BottomSheet", $MaterialComponents
  pod "MaterialComponents/schemes/Color", $MaterialComponents
  pod "MaterialComponents/schemes/Typography", $MaterialComponents

  pod "MaterialDesignSymbol", "2.3.0"

  # Dates
  pod "SwiftMoment", "0.7"

  # Acknowledgements
  pod "AcknowList", "1.8"

  # Deep Link
  pod "Freedom", "2.2.0"

  # Debug
  pod "netfox", "1.14.0", :configurations => ["Debug"]

=begin

  script_phase :name => "SwiftFormat",
               :script => '"${PODS_ROOT}/SwiftFormat/CommandLineTool/swiftformat" "${SRCROOT}/MyMorningCoffee" "${SRCROOT}/MyMorningCoffeeTests" "--config" ".swiftformat"',
               :execution_position => :before_compile

  script_phase :name => "SwiftLint",
               :script => '"${PODS_ROOT}/SwiftLint/swiftlint"',
               :execution_position => :before_compile

=end

  script_phase :name => "Fabric",
               :script => '"${PODS_ROOT}/Fabric/run"',
               :execution_position => :after_compile,
               :input_files => ["$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)"]

  target "MyMorningCoffeeTests" do
    inherit! :search_paths

    pod "Quick", "1.3.2"
    pod "Nimble", "7.3.1"
    pod "OHHTTPStubs/Swift", "6.1.0"
    pod "RxBlocking", $Rx
    pod "EarlGrey", "1.15.0"
    pod "Nimble-Snapshots", "6.9.0"

    # Fake Data
    pod "Fakery", "3.4.0"
  end
end

DEFAULT_SWIFT_VERSION = "4.2"

POD_SWIFT_VERSION_MAP = {"Example" => "4.1"}

post_install do |installer|
  installer.pods_project.targets.each do |target|
    swift_version = POD_SWIFT_VERSION_MAP[target.name] || DEFAULT_SWIFT_VERSION
    puts "Setting #{target.name} Swift version to #{swift_version}"
    target.build_configurations.each do |config|
      config.build_settings["SWIFT_VERSION"] = swift_version
    end

    if target.name == "RxSwift"
      target.build_configurations.each do |config|
        if config.name == "Debug"
          puts "#{target.name} - OTHER_SWIFT_FLAGS"
          config.build_settings["OTHER_SWIFT_FLAGS"] ||= ["-D", "TRACE_RESOURCES"]
        end
      end
    end

  end

  require "fileutils" # for acknowledgements
  FileUtils.cp_r(
    "Pods/Target Support Files/Pods-MyMorningCoffee/Pods-MyMorningCoffee-acknowledgements.plist",
    "MyMorningCoffee/Pods-acknowledgements.plist",
    :remove_destination => true,
  )
end
