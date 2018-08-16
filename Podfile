platform :ios, "11"

pod "SwiftLint", "0.27.0"
pod "SwiftFormat/CLI", "0.35.2"

target "MyMorningCoffee" do
  use_frameworks!

  # Rx
  $Rx = "4.2.0"
  pod "RxSwift", $Rx
  pod "RxCocoa", $Rx

  # Network
  pod "Moya/RxSwift", "11.0.2"

  # UI
  pod "Reusable", "4.0.2"
  pod "SwiftHEXColors", "1.1.2"

  # Firebase
  $Firebase = "5.6.0"
  pod "Firebase/Database", $Firebase

  # material.io
  $MaterialComponents = "60.1.0"
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

  target "MyMorningCoffeeTests" do
    inherit! :search_paths

    pod "Quick", "1.3.1"
    pod "Nimble", "7.1.3"
  end
end
