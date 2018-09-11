platform :ios, "11"

pod "SwiftLint", "0.27.0"
pod "SwiftFormat/CLI", "0.35.5"

plugin 'cocoapods-keys', {
  :project => "MyMorningCoffee",
  :keys => [
    "MercuryWebParserKey"
  ]
}

target "MyMorningCoffee" do
  use_frameworks!

  # Rx
  $Rx = "4.3.0"
  pod "RxSwift", $Rx
  pod "RxCocoa", $Rx
  
  # DI
  pod "Swinject", "2.5.0"

  # Network
  pod "Moya/RxSwift", "11.0.2"
  pod "AlamofireNetworkActivityLogger", "2.3.0"
  
  # DB
  pod "RxGRDB", "0.12.0"

  # UI
  pod "Reusable", "4.0.3"
  pod "Kingfisher", "4.9.0"
  pod "SwiftHEXColors", "1.1.2"

  # Firebase
  $Firebase = "5.8.0"
  pod "Firebase/Database", $Firebase

  # Material.io
  $MaterialComponents = "63.0.0"
  pod "MaterialComponents/AppBar", $MaterialComponents
  pod "MaterialComponents/AppBar+ColorThemer", $MaterialComponents
  pod "MaterialComponents/AppBar+TypographyThemer", $MaterialComponents
  pod "MaterialComponents/NavigationBar", $MaterialComponents
  pod "MaterialComponents/NavigationBar+ColorThemer", $MaterialComponents
  pod "MaterialComponents/NavigationBar+TypographyThemer", $MaterialComponents
  pod "MaterialComponents/Collections", $MaterialComponents
  pod "MaterialComponents/Cards", $MaterialComponents
  pod "MaterialComponents/Cards+ColorThemer", $MaterialComponents
  pod "MaterialComponents/schemes/Color", $MaterialComponents
  pod "MaterialComponents/schemes/Typography", $MaterialComponents

  # Fake Data
  pod "Fakery", "3.4.0"

  # Dates
  pod "SwiftMoment", "0.7"

  script_phase :name => 'SwiftFormat',
               :script => '"${PODS_ROOT}/SwiftFormat/CommandLineTool/swiftformat" "${SRCROOT}/MyMorningCoffee" "${SRCROOT}/MyMorningCoffeeTests" "--config" ".swiftformat"',
               :execution_position => :before_compile

  script_phase :name => 'SwiftLint',
               :script => '"${PODS_ROOT}/SwiftLint/swiftlint"',
               :execution_position => :before_compile

  target "MyMorningCoffeeTests" do
    inherit! :search_paths

    pod "Quick", "1.3.1"
    pod "Nimble", "7.3.0"
    pod "RxNimble", "4.2.0"
    pod "OHHTTPStubs/Swift", "6.1.0"
    pod "RxBlocking", $Rx
    pod "EarlGrey", "1.15.0"
    pod "Nimble-Snapshots", "6.8.1"
  end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.1'
        end
    end
end
