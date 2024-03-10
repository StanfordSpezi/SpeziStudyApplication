//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziFirebaseAccount
import SpeziHealthKit
import SpeziOnboarding
import SwiftUI


/// Displays an multi-step onboarding flow for the StudyApplication.
struct OnboardingFlow: View {
    @Environment(HealthKit.self) private var healthKitDataSource
    @Environment(StudyApplicationScheduler.self) private var scheduler

    @AppStorage(StorageKeys.onboardingFlowComplete) private var completedOnboardingFlow = false
    
    @State private var localNotificationAuthorization = false
    
    
    private var healthKitAuthorization: Bool {
        // As HealthKit not available in preview simulator
        if ProcessInfo.processInfo.isPreviewSimulator {
            return false
        }
        
        return healthKitDataSource.authorized
    }
    
    
    var body: some View {
        OnboardingStack(onboardingFlowComplete: $completedOnboardingFlow) {
            Welcome()
            InterestingModules()
        }
            .interactiveDismissDisabled(!completedOnboardingFlow)
    }
}


#if DEBUG
#Preview {
    OnboardingFlow()
        .previewWith(standard: StudyApplicationStandard()) {}
}
#endif
