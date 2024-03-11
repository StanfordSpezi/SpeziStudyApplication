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


@Observable
class StudyModule: Module, EnvironmentAccessible, DefaultInitializable {
    @ObservationIgnored @Application(\.logger) private var logger
    @ObservationIgnored @Dependency private var localStorage: LocalStorage
    @ObservationIgnored @Dependency private var healthKit: HealthKit
    @ObservationIgnored @Dependency private var scheduler: StudyApplicationScheduler
    
    let studies: [Study] = [Study.vascTracPaloAltoVA, Study.vascTracStanford]
    private(set) var studyState: [StudyState] = [] {
        didSet {
            do {
                try localStorage.store(studyState, storageKey: StorageKeys.currentlyEnrolledStudies)
            } catch {
                logger.error("Could not store enrolled studies.")
            }
        }
    }
    
    
    required init() {}
    
    
    func configure() {
        do {
            self.studyState = try localStorage.read(storageKey: StorageKeys.currentlyEnrolledStudies)
        } catch {
            logger.info("Could not retrieve existing enrolled studies.")
            self.studyState = []
        }
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
