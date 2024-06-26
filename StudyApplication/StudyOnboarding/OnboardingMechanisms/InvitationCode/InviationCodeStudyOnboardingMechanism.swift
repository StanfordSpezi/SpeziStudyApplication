//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct InviationCodeStudyOnboardingMechanism: StudyOnboardingMechanism {
    static var identifier = "InviationCode"
    
    
    func createOnboardingView(study: Study, studyOnboardingComplete: Binding<Bool>) -> AnyView {
        AnyView(InvitationCodeView(study: study))
    }
}
