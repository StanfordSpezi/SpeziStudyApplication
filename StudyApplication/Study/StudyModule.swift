//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziHealthKit
import SpeziLocalStorage
import SpeziScheduler


class StudyModule: Module {
    @Dependency var localStorage: LocalStorage
    @Dependency var healthKit: HealthKit
    @Dependency var scheduler: StudyApplicationScheduler
    @Model var studyViewModel: StudyViewModel
    
    
    func configure() {
        studyViewModel = StudyViewModel(
            localStorage: localStorage,
            healthKit: healthKit,
            scheduler: scheduler
        )
    }
}
