//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct StudyEnrollment: View {
    private let study: Study
    @Environment(StudyModule.self) private var studyModule
    @State private var startOfDay: Date = Calendar.current.startOfDay(for: .now)
    
    
    private var daysEnrolled: Int {
        guard let enrollmentDate = studyModule.studyState(for: study.id).enrolled else {
            fatalError("For a study to be displaying the enrollment engagement it must be actively enrolled.")
        }
        
        let enrollmentDistance = Calendar.current.dateComponents([.day], from: enrollmentDate, to: startOfDay)
        
        return enrollmentDistance.day ?? 0
    }
    
    var body: some View {
        VStack {
            StudyHeader(study: study)
            Divider()
            HStack(alignment: .firstTextBaseline, spacing: 32) {
                informationSection(String(daysEnrolled), description: "Days in Study")
                #warning("Might be cool to add a section about the completed tasks here as well.")
            }
                .padding(.horizontal)
        }
            .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
                startOfDay = Calendar.current.startOfDay(for: .now)
            }
    }
    
    
    init(study: Study) {
        self.study = study
    }
    
    
    private func informationSection(_ value: String, description: String) -> some View {
        VStack(alignment: .center) {
            Text(value)
                .font(.largeTitle.bold().monospacedDigit())
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
            .frame(minWidth: 0, maxWidth: .infinity)
    }
}


#Preview {
    let studyModule = StudyModule()
    
    return List {
        StudyApplicationListCard {
            StudyEnrollment(study: studyModule.studies[0])
        }
    }
        .studyApplicationList()
        .previewWith(standard: StudyApplicationStandard()) {
            studyModule
        }
        .task {
            try? await studyModule.enrollInStudy(study: studyModule.studies[0])
        }
}
