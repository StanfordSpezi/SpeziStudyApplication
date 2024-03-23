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
            ScrollView(.vertical) {
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
                    ForEach(studyModule.studies) { study in
                        StudyView(study: study)
                            .shadow(radius: 10)
                            .padding()
                    }
                }
            }
                .scrollBounceBehavior(.basedOnSize)
                .navigationTitle("Studies")
        }
    }
}


#Preview {
    StudiesView()
        .previewWith(standard: StudyApplicationStandard()) {
            StudyModule()
        }
}
