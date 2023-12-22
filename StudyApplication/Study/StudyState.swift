//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


struct StudyState: Codable, Identifiable {
    var id: Study.ID {
        studyId
    }
    
    let studyId: Study.ID
    let enrolled: Date?
    
    
    init(studyId: Study.ID, enrolled: Date? = .now) {
        self.studyId = studyId
        self.enrolled = enrolled
    }
}
