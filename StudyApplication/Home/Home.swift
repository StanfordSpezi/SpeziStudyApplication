//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct Home: View {
    @Environment(StepCountModule.self) var todayStepCount
    @Environment(StudyModule.self) var studyModule
    
    
    var body: some View {
        NavigationStack {
            if let enrolledStudy = studyModule.enrolledStudy {
                ScrollView(.vertical) {
                    
                }
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
    }
}


#Preview {
    Home()
}
