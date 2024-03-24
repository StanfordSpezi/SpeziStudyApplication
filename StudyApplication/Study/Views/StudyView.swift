//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziHealthKit
import SpeziLocalStorage
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
            imageView
            studyDescription
            Divider()
            enrollSection
        }
            .background {
                Color(uiColor: .systemBackground)
                    .ignoresSafeArea()
            }
            .clipShape(Rectangle())
            .sheet(isPresented: $showEnrollSheet) {
                StudyOnboardingFlow(study: study, studyOnboardingComplete: !$showEnrollSheet)
            }
    }
    
    @ViewBuilder private var imageView: some View {
        AsyncImage(url: study.titleImage) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(height: 160)
        } placeholder: {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
            .frame(height: 160)
            .background {
                Color(.systemGray5)
            }
    }
    
    @ViewBuilder private var studyDescription: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading) {
                    Text(study.title)
                        .font(.title2)
                        .bold()
                    Text(study.organization.title)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                HStack(alignment: .top) {
                    AsyncImage(url: study.organization.logo) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                        .frame(width: 50)
                }
            }
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
