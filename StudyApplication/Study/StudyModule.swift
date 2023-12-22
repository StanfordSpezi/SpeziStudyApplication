//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziLocalStorage


class StudyModule: Module {
    @Dependency var localStorage: LocalStorage
    @Model var studyViewModel: StudyViewModel
    
    
    func configure() {
        studyViewModel = StudyViewModel(localStorage: localStorage)
    }
}
