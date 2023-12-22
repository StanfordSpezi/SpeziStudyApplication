//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


protocol StudyOnboardingMechanism: Identifiable {
    static var identifier: String { get }
    
    /// Views must call the study registration functionality (``StudyViewModel/enrollInStudy(study:)``) to ensure that they are correctly enrolled.
    func createOnboardingView(study: Study, studyOnboardingComplete: Binding<Bool>) -> AnyView
}


extension StudyOnboardingMechanism {
    var id: String {
        Self.identifier
    }
}
