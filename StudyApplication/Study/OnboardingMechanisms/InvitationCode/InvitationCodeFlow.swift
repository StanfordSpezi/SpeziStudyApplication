//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct InvitationCodeFlow: View {
    private let study: Study
    private let closeEnrollment: () async throws -> Void
    
    
    var body: some View {
        NavigationStack {
            InvitationCodeView(study: study, closeEnrollment: closeEnrollment)
        }
            .interactiveDismissDisabled()
    }
    
    
    init(study: Study, closeEnrollment: @escaping () async throws -> Void) {
        self.study = study
        self.closeEnrollment = closeEnrollment
    }
}
