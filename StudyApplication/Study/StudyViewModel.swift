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
    var studyState: [StudyState] {
        didSet {
            try? localStorage.store(studyState)
        }
    }
    
    
    init(localStorage: LocalStorage) {
        self.localStorage = localStorage
        self.studyState = (try? localStorage.read()) ?? []
    }
}
