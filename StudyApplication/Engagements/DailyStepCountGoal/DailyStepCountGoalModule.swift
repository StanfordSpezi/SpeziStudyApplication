//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import OSLog
import Spezi
import SpeziHealthKit
import SpeziLocalStorage


@Observable
class DailyStepCountGoalModule: Module, EnvironmentAccessible, DefaultInitializable {
    private let logger = Logger(subsystem: "edu.stanford.spezi.studyapplication", category: "TodayStepCount")
    private let healthStore = HKHealthStore()
    
    @ObservationIgnored @Dependency var localStorage: LocalStorage
    @ObservationIgnored @Dependency var healthKit: HealthKit
    
    private var queryTask: Task<Void, Error>?
    private var dayChangedTask: Task<Void, Never>?
    private(set) var todayStepCount: Int = 0
    var stepCountGoal: Int = 10_000 {
        didSet {
            do {
                try localStorage.store(stepCountGoal, storageKey: StorageKeys.dailyStepCountGoal)
            } catch {
                logger.error("Could not store enrolled studies.")
            }
        }
    }
    
    
    required init() { }
    
    
    func configure() {
        do {
            if ProcessInfo.processInfo.isPreviewSimulator {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    self.todayStepCount += Int.random(in: 20...42)
                }
            } else {
                #warning("We need to store the step count goal in Firebase and observe changes in the study app.")
                self.stepCountGoal = try localStorage.read(storageKey: StorageKeys.dailyStepCountGoal)
            }
        } catch {
            logger.info("Could not retrieve existing step count goal.")
        }
        
        // We use observation tracking to observe healthKit.authorized.
        // If the value is false, the query is not executed and the observation tracking will let us know if the value changed.
        withContinousObservation(of: self.healthKit.authorized) { authorized in
            if authorized {
                self.executeStatisticsQuery()
            }
        }
    }
    
    private func executeStatisticsQuery() {
        guard healthKit.authorized else {
            return
        }
        
        if let queryTask {
            queryTask.cancel()
        }
        
        observeDayChanged()
        
        queryTask = Task {
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: .now)
            
            guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
                logger.debug("Could not generate end of day for day: \(startOfDay). Will not execure query.")
                return
            }

            let stepsToday = HKSamplePredicate.quantitySample(
                type: HKQuantityType(.stepCount),
                predicate: HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay)
            )

            let stepsTodayQuery = HKStatisticsCollectionQueryDescriptor(
                predicate: stepsToday,
                options: .cumulativeSum,
                anchorDate: startOfDay,
                intervalComponents: DateComponents(day: 1)
            )
            
            do {
                for try await results in stepsTodayQuery.results(for: healthStore) {
                    guard !Task.isCancelled else {
                        logger.debug("Task was cancelled, exeting results loop.")
                        return
                    }
                    
                    guard let result = results.statisticsCollection.statistics(for: startOfDay),
                          let stepCount = result.sumQuantity()?.doubleValue(for: HKUnit.count()) else {
                        logger.warning("Could not retrieve expected result from startistics collection.")
                        continue
                    }
                    
                    self.todayStepCount = Int(stepCount)
                }
            } catch {
                logger.error("Could not execure HealthKit query: \(error)")
            }
        }
    }
    
    private func observeDayChanged() {
        guard dayChangedTask == nil else {
            return
        }
        
        dayChangedTask = Task {
            for await _ in NotificationCenter.default.notifications(named: .NSCalendarDayChanged) {
                logger.debug("Day did change.")
                executeStatisticsQuery()
            }
        }
    }
    
    
    deinit {
        dayChangedTask?.cancel()
        queryTask?.cancel()
    }
}
