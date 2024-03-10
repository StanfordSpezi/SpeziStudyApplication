//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziOnboarding
import SwiftUI


struct Consent: View {
    let consentDocument: String
    @Environment(OnboardingNavigationPath.self) private var onboardingNavigationPath
    
    
    var body: some View {
        OnboardingConsentView(
            markdown: {
                Data(consentDocument.utf8)
            },
            action: {
                onboardingNavigationPath.nextStep()
            }
        )
    }
}


#if DEBUG
#Preview {
    guard let studyConsentDocument = Study.vascTracStanford.consentDocument else {
        fatalError("Could not load consent document.")
    }
    
    return OnboardingStack {
        Consent(consentDocument: studyConsentDocument)
    }
        .previewWith(standard: StudyApplicationStandard()) {
            OnboardingDataSource()
        }
}
#endif
