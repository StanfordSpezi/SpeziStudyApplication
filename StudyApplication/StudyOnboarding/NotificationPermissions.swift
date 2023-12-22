//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziOnboarding
import SpeziScheduler
import SwiftUI


struct NotificationPermissions: View {
    let study: Study
    
    
    @Environment(StudyApplicationScheduler.self) private var scheduler
    @Environment(OnboardingNavigationPath.self) private var onboardingNavigationPath
    
    @State private var notificationProcessing = false
    
    
    var body: some View {
        OnboardingView(
            contentView: {
                VStack {
                    OnboardingTitleView(
                        title: "Notifications",
                        subtitle: "The \(study.title) study would like to schedule notifications."
                    )
                    Spacer()
                    Image(systemName: "bell.square.fill")
                        .font(.system(size: 150))
                        .foregroundColor(.accentColor)
                        .accessibilityHidden(true)
                    if let notificationDescription = study.notificationDescription {
                        Text(notificationDescription)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 16)
                    }
                    Spacer()
                }
            }, actionView: {
                OnboardingActionsView(
                    "Allow Notifications",
                    action: {
                        do {
                            notificationProcessing = true
                            // Notification Authorization is not available in the preview simulator.
                            if ProcessInfo.processInfo.isPreviewSimulator {
                                try await _Concurrency.Task.sleep(for: .seconds(5))
                            } else {
                                try await scheduler.requestLocalNotificationAuthorization()
                            }
                        } catch {
                            print("Could not request notification permissions.")
                        }
                        notificationProcessing = false
                        
                        onboardingNavigationPath.nextStep()
                    }
                )
            }
        )
            .navigationBarBackButtonHidden(notificationProcessing)
            // Small fix as otherwise "Login" or "Sign up" is still shown in the nav bar
            .navigationTitle("")
    }
}


#if DEBUG
#Preview {
    OnboardingStack(startAtStep: NotificationPermissions.self) {
        for onboardingView in OnboardingFlow.previewSimulatorViews {
            onboardingView
        }
    }
}
#endif
