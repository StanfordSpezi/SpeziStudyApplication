//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct StudiesView: View {
    @Environment(StudyModule.self) var studyModule
    
    
    var body: some View {
        NavigationStack {
            Group {
                if studyModule.studies.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label("No Studies", systemImage: "list.clipboard")
                        },
                        description: {
                            Text(
                                """
                                There are no studies to enroll to at the moment.
                                Please check back in the future; we add studies on a rolling basis.
                                """
                            )
                        }
                    )
                } else {
                    List {
                        ForEach(studyModule.studies) { study in
                            StudyApplicationListCard {
                                StudyView(study: study)
                                    .padding(.horizontal, -16)
                                    .padding(.vertical, -8)
                            }
                        }
                    }
                        .studyApplicationList()
                }
            }
                .navigationTitle("Studies")
                .background {
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea(.all)
                }
        }
    }
}


#Preview {
    StudiesView()
        .previewWith(standard: StudyApplicationStandard()) {
            StudyModule()
        }
}
