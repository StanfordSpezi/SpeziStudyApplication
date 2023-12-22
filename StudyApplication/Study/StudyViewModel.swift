//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Observation
import SpeziLocalStorage


@Observable
class StudyViewModel {
    private let localStorage: LocalStorage
    let studies: [Study] = [Study.vascTracPaloAltoVA, Study.vascTracStanford]
    private(set) var studyState: [StudyState] {
        didSet {
            try? localStorage.store(studyState)
        }
    }
    
    
    init(localStorage: LocalStorage) {
        self.localStorage = localStorage
        self.studyState = (try? localStorage.read()) ?? []
    }
    
    
    func enrollInStudy(study: Study.ID) async throws {
        guard !studyState.contains(where: { $0.enrolled != nil && $0.finished == nil }) else {
            throw StudyError.canOnlyEnrollInOneStudy
        }
        
        studyState.append(StudyState(studyId: study, enrolled: .now))
    }
}
