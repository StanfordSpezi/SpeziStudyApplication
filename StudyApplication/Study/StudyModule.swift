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
    
    let studies: [Study] = {
        if ProcessInfo.processInfo.isPreviewSimulator {
            [Study.mockStudy]
        } else {
            [Study.vascTracPaloAltoVA, Study.vascTracStanford]
        }
    }()
    private var states: [Study.State] = [] {
        didSet {
            do {
                try localStorage.store(states, storageKey: StorageKeys.currentlyEnrolledStudies)
            } catch {
                logger.error("Could not store enrolled studies.")
            }
        }
    }
    
    
    var enrolledStudy: Study? {
        #warning(
            """
            We currently only support one enrolled study at the same time.
            Multiplexing in the standard needs to be more complex based on multiple studies.
            """
        )
        guard let enrolledStudy = states.first(where: { $0.enrolled != nil && $0.finished == nil }) else {
            return nil
        }
        
        guard let study = studies.first(where: { $0.id == enrolledStudy.id }) else {
            logger.error("Could not find enrolled study \(enrolledStudy.id)")
            return nil
        }
        
        return study
    }
    
    
    required init() {}
    
    
    func configure() {
        do {
            #warning("We need to store the study state in Firebase and observe changes in the study app.")
            self.states = try localStorage.read(storageKey: StorageKeys.currentlyEnrolledStudies)
        } catch {
            logger.info("Could not retrieve existing enrolled studies.")
            self.states = []
        }
        
        if let enrolledStudy {
            executeHealthKitQueries(for: enrolledStudy)
        }
    }
    
    
    func enrollInStudy(study: Study) async throws {
        guard !states.contains(where: { $0.enrolled != nil && $0.finished == nil }) else {
            throw StudyError.canOnlyEnrollInOneStudy
        }
        
        executeHealthKitQueries(for: study)
        
        for task in study.tasks {
            await scheduler.schedule(task: task)
        }
        
        states.append(Study.State(studyId: study.id, enrolled: .now))
    }
    
    
    private func executeHealthKitQueries(for study: Study) {
        for healthKitDescription in study.healthKit?.healthKitDescriptions ?? [] {
            healthKit.execute(healthKitDescription)
        }
    }
}
