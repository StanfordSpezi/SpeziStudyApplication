//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Observation
import SpeziHealthKit
import SpeziLocalStorage
import SpeziScheduler


@Observable
class StudyViewModel {
    private let localStorage: LocalStorage
    private let healthKit: HealthKit
    private let scheduler: StudyApplicationScheduler
    
    let studies: [Study] = [Study.vascTracPaloAltoVA, Study.vascTracStanford]
    private(set) var studyState: [StudyState] {
        didSet {
            try? localStorage.store(studyState)
        }
    }
    
    
    init(
        localStorage: LocalStorage,
        healthKit: HealthKit,
        scheduler: StudyApplicationScheduler
    ) {
        self.localStorage = localStorage
        self.healthKit = healthKit
        self.scheduler = scheduler
        self.studyState = (try? localStorage.read()) ?? []
    }
    
    
    func enrollInStudy(study: Study) async throws {
        guard !studyState.contains(where: { $0.enrolled != nil && $0.finished == nil }) else {
            throw StudyError.canOnlyEnrollInOneStudy
        }
        
        for healthKitDescription in study.healthKit?.healthKitDescriptions ?? [] {
            healthKit.execute(healthKitDescription)
        }
        
        for task in study.tasks {
            await scheduler.schedule(task: task)
        }
        
        studyState.append(StudyState(studyId: study.id, enrolled: .now))
    }
}
