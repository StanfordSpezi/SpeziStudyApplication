//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziHealthKit
import SpeziOnboarding
import SwiftUI


struct StudyView: View {
    private let study: Study
    @State private var showEnrollSheet = false
    @Environment(StudyModule.self) private var studyModule: StudyModule
    
    
    private var enrolled: Bool {
        studyModule.enrolledStudy?.id == study.id
    }
    
    var body: some View {
        VStack(spacing: 0) {
            StudyImage(study: study)
            studyDescription
            Divider()
            enrollSection
        }
            .background {
                Color(uiColor: .systemBackground)
                    .ignoresSafeArea()
            }
            .sheet(isPresented: $showEnrollSheet) {
                StudyOnboardingFlow(study: study, studyOnboardingComplete: !$showEnrollSheet)
            }
    }
    
    @ViewBuilder private var studyDescription: some View {
        VStack(spacing: 0) {
            StudyHeader(study: study)
                .padding()
            Divider()
            Text(study.description)
                .multilineTextAlignment(.leading)
                .lineLimit(6)
                .padding()
        }
            .background {
                Color(uiColor: .systemBackground)
                    .ignoresSafeArea()
            }
    }
    
    @ViewBuilder private var enrollSection: some View {
        OnboardingActionsView(enrolled ? "Already Enrolled" : "Enroll") {
            showEnrollSheet = true
        }
            .padding()
            .disabled(enrolled)
    }
    
    
    init(study: Study) {
        self.study = study
    }
}


#Preview {
    ZStack {
        Color(.systemGroupedBackground)
            .edgesIgnoringSafeArea(.all)
        StudyView(study: StudyModule().studies[0])
    }
        .previewWith(standard: StudyApplicationStandard()) {
            StudyModule()
        }
}
