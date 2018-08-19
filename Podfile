platform :ios, "11"

pod "SwiftLint", "0.27.0"
pod "SwiftFormat/CLI", "0.35.4"

plugin 'cocoapods-keys', {
  :project => "MyMorningCoffee",
  :keys => [
    "MercuryWebParserKey"
  ]
}

target "MyMorningCoffee" do
  use_frameworks!

  # Rx
  $Rx = "4.2.0"
  pod "RxSwift", $Rx
  pod "RxCocoa", $Rx
  
  # DI
  pod "Swinject", "2.4.1"

  # Network
  pod "Moya/RxSwift", "11.0.2"
  
  # DB
  pod "RxGRDB", "0.11.0"

  # UI
  pod "Reusable", "4.0.3"
  pod "Kingfisher", "4.9.0"
  pod "SwiftHEXColors", "1.1.2"

  # Firebase
  $Firebase = "5.7.0"
  pod "Firebase/Database", $Firebase

  # Material.io
  $MaterialComponents = "62.1.0"
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
  pod "Fakery", "3.3.0"

  # Dates
  pod "SwiftMoment", "0.7"

  target "MyMorningCoffeeTests" do
    inherit! :search_paths

    pod "Quick", "1.3.1"
    pod "Nimble", "7.3.0"
    pod "RxNimble", "4.1.0"
    pod "OHHTTPStubs/Swift", "6.1.0"
    pod "RxBlocking", $Rx
  end
end
