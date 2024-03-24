//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct Home: View {
    @Environment(StudyModule.self) var studyModule
    
    
    var body: some View {
        NavigationStack {
            Group {
                if let enrolledStudy = studyModule.enrolledStudy {
                    List {
                        enrolledStudySection(enrolledStudy: enrolledStudy)
                    }
                        .studyApplicationList()
                } else {
                    ContentUnavailableView(
                        label: {
                            Label("No Enrolled Study", systemImage: "list.clipboard")
                        },
                        description: {
                            Text(
                                """
                                You are not enrolled in a study.
                                Please navigate to the Study tab to enroll in a study.
                                """
                            )
                        }
                    )
                }
            }
                .navigationTitle("Home")
        }
    }
    
    
    @ViewBuilder
    private func enrolledStudySection(enrolledStudy: Study) -> some View {
        Section(
            content: {
                if enrolledStudy.engagements.isEmpty {
                    StudyApplicationListCard {
                        Study.Engagement.studyEnrollment.view(correlatedToStudy: enrolledStudy)
                    }
                } else {
                    ForEach(enrolledStudy.engagements) { engagement in
                        StudyApplicationListCard {
                            engagement.view(correlatedToStudy: enrolledStudy)
                        }
                    }
                }
            },
            header: {
                Text(enrolledStudy.title)
                    .studyApplicationHeaderStyle()
            }
        )
    }
}


#Preview("Mock Study") {
    let studyModule = StudyModule()
    
    return Home()
        .previewWith(standard: StudyApplicationStandard()) {
            studyModule
            DailyStepCountGoalModule()
        }
        .task {
            try? await studyModule.enrollInStudy(study: studyModule.studies[0])
        }
}

#Preview("No Enrolled Study") {
    Home()
        .previewWith(standard: StudyApplicationStandard()) {
            StudyModule()
            DailyStepCountGoalModule()
        }
}
