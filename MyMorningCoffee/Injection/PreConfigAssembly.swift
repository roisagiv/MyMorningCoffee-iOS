//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Firebase
import GRDB
import Keys
import Swinject

class PreConfigAssembly: Assembly {
  func assemble(container: Container) {
    let log = Environment.log

    // DatabaseWriter
    container.register(DatabaseWriter.self) { _ in
      do {
        return try DatabaseFactory.create(log: true)
      } catch {
        return DatabaseFactory.createInMemory(log: log)
      }
    }.inObjectScope(ObjectScope.container)

    // Router
    container.register(Router.self) { _ in Router() }

    // RemoveConfig
    container.register(RemoteConfigType.self) { _ in
      let keys = MyMorningCoffeeKeys()
      let options = FirebaseOptions(
        googleAppID: keys.firebaseGoogleAppID,
        gcmSenderID: keys.firebaseGCMSenderID
      )
      FirebaseApp.configure(options: options)
      let remoteConfig = RemoteConfig.remoteConfig()
      remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")

      #if DEBUG
        remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)
//        FirebaseConfiguration.shared.setLoggerLevel(.debug)
      #endif

      return FirebaseRemoteConfig(remoteConfig: RemoteConfig.remoteConfig())
    }.inObjectScope(.container)

    // BuildIdentity
    container.register(BuildIdentityServiceType.self) { _ in BuildIdentityService() }
  }
}
