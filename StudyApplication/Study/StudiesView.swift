//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct StudiesView: View {
    @Environment(StudyViewModel.self) var studyViewModel
    
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                ForEach(studyViewModel.studies) { study in
                    StudyView(study: study)
                        .shadow(radius: 10)
                        .padding()
                }
            }
                .navigationTitle("Studies")
        }
    }
}
