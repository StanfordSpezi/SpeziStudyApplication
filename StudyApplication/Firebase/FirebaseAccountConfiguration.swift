//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Spezi
import class FirebaseAuth.Auth
import SpeziFirebaseConfiguration


/// Module to configure firebase auth for anonumous authentication.
final class FirebaseAccountConfiguration: Module {
    @Dependency private var configureFirebaseApp: ConfigureFirebaseApp

    private let emulatorSettings: (host: String, port: Int)?
    
    
    /// - Parameters:
    ///   - emulatorSettings: The emulator settings. The default value is `nil`, connecting the FirebaseAccount module to the Firebase Auth cloud instance.
    init(
        emulatorSettings: (host: String, port: Int)? = nil
    ) {
        self.emulatorSettings = emulatorSettings
    }
    
    
    func configure() {
        if let emulatorSettings {
            Auth.auth().useEmulator(withHost: emulatorSettings.host, port: emulatorSettings.port)
        }
    }
}
