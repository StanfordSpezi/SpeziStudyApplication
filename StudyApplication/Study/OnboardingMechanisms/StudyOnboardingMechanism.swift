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
    
    func createOnboardingView(action: @escaping () async throws -> Void, study: Study) -> AnyView
}


extension StudyOnboardingMechanism {
    var id: String {
        Self.identifier
    }
}
