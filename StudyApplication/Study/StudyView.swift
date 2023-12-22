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
    @Environment(StudyViewModel.self) private var studyViewModel: StudyViewModel
    
    
    private var enrolled: Bool {
        studyViewModel.studyState.contains(where: { $0.studyId == study.id })
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
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .sheet(isPresented: $showEnrollSheet) {
                StudyOnboardingFlow(study: study, studyOnboardingComplete: $showEnrollSheet)
            }
    }
    
    @ViewBuilder private var imageView: some View {
        AsyncImage(url: study.titleImage) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(height: 160)
        } placeholder: {
            ProgressView()
        }
            .frame(height: 160)
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
    let studyViewModel = StudyViewModel(
        localStorage: LocalStorage(),
        healthKit: HealthKit(),
        scheduler: StudyApplicationScheduler()
    )
    
    return ZStack {
        Color.gray
        StudyView(study: studyViewModel.studies[0])
            .environment(studyViewModel)
    }
}
