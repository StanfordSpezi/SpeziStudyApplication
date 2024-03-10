//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziHealthKit
import SpeziOnboarding
import SwiftUI


struct StudyOnboardingFlow: View {
    private let study: Study
    
    @Environment(HealthKit.self) private var healthKit
    @Environment(StudyApplicationScheduler.self) private var scheduler
        
    @Binding var studyOnboardingComplete: Bool
    @State private var localNotificationAuthorization = false
    @State private var healthKitAuthorization = false
    
    
    var body: some View {
        OnboardingStack(onboardingFlowComplete: $studyOnboardingComplete) {
            study.onboardingMechanism.createOnboardingView(study: study, studyOnboardingComplete: $studyOnboardingComplete)
            if let consentDocument = study.consentDocument {
                Consent(consentDocument: consentDocument)
            }
            if study.healthKit != nil, !healthKitAuthorization {
                HealthKitPermissions(study: study)
            }
            if !study.tasks.isEmpty, !localNotificationAuthorization {
                NotificationPermissions(study: study)
            }
        }
            .task {
                localNotificationAuthorization = await scheduler.localNotificationAuthorization
            }
            .onChange(of: healthKit.authorized, initial: true) {
                guard HKHealthStore.isHealthDataAvailable() else {
                    healthKitAuthorization = true
                    return
                }
                
                healthKitAuthorization = healthKit.authorized
            }
            .interactiveDismissDisabled()
    }
    
    
    init(study: Study, studyOnboardingComplete: Binding<Bool>) {
        self.study = study
        self._studyOnboardingComplete = studyOnboardingComplete
    }
}
