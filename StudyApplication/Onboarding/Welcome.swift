//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziOnboarding
import SwiftUI


struct Welcome: View {
    @Environment(OnboardingNavigationPath.self) private var onboardingNavigationPath
    
    
// swiftlint:disable line_length
    // We disable line lengh checks to ensure that we can fit the complete english text in the SwiftUI views,
    // avoiding unspecific localization keys.
    var body: some View {
        OnboardingView(
            title: "Welcome to the Spezi Study Application",
            subtitle: "Enroll and Participate in Research Projects",
            areas: [
                OnboardingInformationView.Content(
                    icon: {
                        Image(systemName: "apps.iphone")
                            .accessibilityHidden(true)
                    },
                    title: "Right on your phone",
                    description: "Single application to enroll into multiple studies."
                ),
                OnboardingInformationView.Content(
                    icon: {
                        Image(systemName: "shippingbox.fill")
                            .accessibilityHidden(true)
                    },
                    title: "Automatic Data Transfer",
                    description: "After you provide detailed permissions, your data is automatically shared with the studies you participate in."
                ),
                OnboardingInformationView.Content(
                    icon: {
                        Image(systemName: "list.bullet.clipboard.fill")
                            .accessibilityHidden(true)
                    },
                    title: "Surveys, Activity Data, and More",
                    description: "The Spezi Study Application can collect a wide variety of data points that can be helpful for a broad range of digital health studies."
                )
            ],
            actionText: "Welcome",
            action: {
                onboardingNavigationPath.nextStep()
            }
        )
            .padding(.top, 24)
    }
    // swiftlint:enable line_length
}


#if DEBUG
#Preview {
    OnboardingStack {
        Welcome()
    }
}
#endif
