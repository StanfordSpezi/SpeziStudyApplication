//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseFunctions
import Spezi
import SpeziFirebaseConfiguration


/// Module to configure Firebase Functions
final class FirebaseFunctionsConfiguration: Module {
    @Dependency private var configureFirebaseApp: ConfigureFirebaseApp

    private let emulatorSettings: (host: String, port: Int)?
    
    
    /// - Parameters:
    ///   - emulatorSettings: The emulator settings. The default value is `nil`, connecting the FirebaseFunctions module to the Firebase Functions cloud instance.
    init(
        emulatorSettings: (host: String, port: Int)? = nil
    ) {
        self.emulatorSettings = emulatorSettings
    }
    
    
    func configure() {
        if let emulatorSettings {
            Functions.functions().useEmulator(withHost: emulatorSettings.host, port: emulatorSettings.port)
        }
    }
}
