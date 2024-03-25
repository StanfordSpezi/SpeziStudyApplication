//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

/// Constants shared across the Spezi Teamplate Application to access storage information including the `AppStorage` and `SceneStorage`
enum StorageKeys {
    // MARK: - Onboarding
    /// A `Bool` flag indicating of the onboarding was completed.
    static let onboardingFlowComplete = "onboardingFlow.complete"
    /// A `Step` flag indicating the current step in the onboarding process.
    static let onboardingFlowStep = "onboardingFlow.step"
    
    
    // MARK: - Home
    /// The currently selected home tab.
    static let homeTabSelection = "home.tabselection"
    
    
    // MARK: - Study
    /// The currently enrolled studies
    static let currentlyEnrolledStudies = "studies.currentlyEnrolled"
    
    
    // MARK: - Engagements
    /// Daily step count goal
    static let dailyStepCountGoal = "engagement.dailyStepCountGoal"
    /// Daily step count goal
    static let dailyStepCountGoalNotifications = "engagement.dailyStepCountGoal.notifications"
}
