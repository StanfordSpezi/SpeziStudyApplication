//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziFirebaseStorage
import SpeziFirestore
import SpeziHealthKit
import SpeziOnboarding
@_spi(Spezi) import SpeziScheduler
import SwiftUI


class StudyApplicationDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: StudyApplicationStandard()) {
            if !FeatureFlags.disableFirebase {
                if FeatureFlags.useFirebaseEmulator {
                    FirebaseFunctionsConfiguration(emulatorSettings: (host: "localhost", port: 5001))
                    FirebaseAccountConfiguration(emulatorSettings: (host: "localhost", port: 9099))
                    FirebaseStorageConfiguration(emulatorSettings: (host: "localhost", port: 9199))
                } else {
                    FirebaseAccountConfiguration()
                    FirebaseFunctionsConfiguration()
                    FirebaseStorageConfiguration()
                }
                firestore
            }
            if HKHealthStore.isHealthDataAvailable() {
                HealthKit()
            }
            StudyApplicationScheduler()
            SchedulerStorage(for: StudyApplicationScheduler.self, mockedStorage: false)
            OnboardingDataSource()
            StudyModule()
        }
    }
    
    
    private var firestore: Firestore {
        let settings = FirestoreSettings()
        if FeatureFlags.useFirebaseEmulator {
            settings.host = "localhost:8080"
            settings.cacheSettings = MemoryCacheSettings()
            settings.isSSLEnabled = false
        }
        
        return Firestore(
            settings: settings
        )
    }
}
