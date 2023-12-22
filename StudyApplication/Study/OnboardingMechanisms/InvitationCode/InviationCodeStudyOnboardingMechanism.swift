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
    
    func createOnboardingView(action: @escaping () async throws -> Void, study: Study) -> AnyView {
        return AnyView(InvitationCodeView(action: action, study: study))
    }
}
