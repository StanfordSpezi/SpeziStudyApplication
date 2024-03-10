//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziOnboarding
import SwiftUI


struct InterestingModules: View {
    @Environment(OnboardingNavigationPath.self) private var onboardingNavigationPath
    
    
// swiftlint:disable line_length
    // We disable line lengh checks to ensure that we can fit the complete english text in the SwiftUI views,
    // avoiding unspecific localization keys.
    var body: some View {
        SequentialOnboardingView(
            title: "Your First Steps",
            subtitle: "Enroll in a Research Study",
            content: [
                SequentialOnboardingView.Content(
                    title: "Find your Research Studies",
                    description: "If you are alredy enrolled in a research study, find it on the application home screen after the onboarding and enter your inviation code."
                ),
                SequentialOnboardingView.Content(
                    title: "Enroll in the Study",
                    description: "You will need to provide the application permission to get access to the data that the study collects."
                ),
                SequentialOnboardingView.Content(
                    title: "Contribute to Science",
                    description: "You are all set. Please follow the Study Schedule and consider enabeling notifications to get informed about any upcoming tasks."
                )
            ],
            actionText: "Finish Onboarding",
            action: {
                onboardingNavigationPath.nextStep()
            }
        )
    }
    // swiftlint:enable line_length
}


#if DEBUG
#Preview {
    OnboardingStack {
        InterestingModules()
    }
}
#endif
