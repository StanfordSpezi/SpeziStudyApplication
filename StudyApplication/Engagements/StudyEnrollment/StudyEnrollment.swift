//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct StudyEnrollment: View {
    let study: Study
    @Environment(StudyModule.self) var studyModule
    
    
    private var enrollmentDate: Date {
        guard let enrollmentDate = studyModule.studyState(for: study.id).enrolled else {
            fatalError("For a study to be displaying the enrollment engagement it must be actively enrolled.")
        }
        
        return enrollmentDate
    }
    
    var body: some View {
        Text("You are enrolled in the \(study.title) since \(enrollmentDate, style: .date)")
    }
}

#Preview {
    let studyModule = StudyModule()
    
    return StudyEnrollment(study: studyModule.studies[0])
        .previewWith {
            studyModule
        }
}
