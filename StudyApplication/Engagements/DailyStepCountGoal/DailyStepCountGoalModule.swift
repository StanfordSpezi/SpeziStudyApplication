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
import UserNotifications


@Observable
class DailyStepCountGoalModule: Module, EnvironmentAccessible, DefaultInitializable {
    private let logger = Logger(subsystem: "edu.stanford.spezi.studyapplication", category: "TodayStepCount")
    private let healthStore = HKHealthStore()
    
    @ObservationIgnored @Dependency var localStorage: LocalStorage
    @ObservationIgnored @Dependency var healthKit: HealthKit
    
    private var queryTask: Task<Void, Error>?
    private var dayChangedTask: Task<Void, Never>?
    private(set) var todayStepCount: Int = 0 {
        didSet {
            Task {
                await updateStepCountNotification()
            }
        }
    }
    var stepCountGoal: Int = 10_000 {
        didSet {
            do {
                try localStorage.store(stepCountGoal, storageKey: StorageKeys.dailyStepCountGoal)
                
                logger.debug("Step count goal changed to: \(self.stepCountGoal)")
                
                Task {
                    await resetAllNotifications()
                }
            } catch {
                logger.error("Could not store enrolled studies.")
            }
        }
    }
    var notifications: [Date: String] = [:] {
        didSet {
            do {
                try localStorage.store(notifications, storageKey: StorageKeys.dailyStepCountGoalNotifications)
            } catch {
                logger.error("Could not store step count goal notifications.")
            }
        }
    }
    
    private var statisticsCollectionQueryDescriptor: HKStatisticsCollectionQueryDescriptor {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: .now)
        
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            fatalError("Could not generate end of day for day: \(startOfDay). Will not execure query.")
        }

        let stepsToday = HKSamplePredicate.quantitySample(
            type: HKQuantityType(.stepCount),
            predicate: HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay)
        )

        return HKStatisticsCollectionQueryDescriptor(
            predicate: stepsToday,
            options: .cumulativeSum,
            anchorDate: startOfDay,
            intervalComponents: DateComponents(day: 1)
        )
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
                // Important to store the notifications first before retrieving the step count goal as this is used to update notifications.
                self.notifications = try localStorage.read(storageKey: StorageKeys.dailyStepCountGoalNotifications)
                self.stepCountGoal = try localStorage.read(storageKey: StorageKeys.dailyStepCountGoal)
            }
        } catch {
            logger.info("Could not retrieve existing step count goal or notifications.")
        }
        
        // We use observation tracking to observe healthKit.authorized.
        // If the value is false, the query is not executed and the observation tracking will let us know if the value changed.
        withContinousObservation(of: self.healthKit.authorized) { authorized in
            if authorized {
                self.executeStatisticsQuery()
            }
        }
    }
    
    func refreshTodayStepCount() async {
        logger.debug("Refresh today's step count.")
        
        guard let result = try? await statisticsCollectionQueryDescriptor.result(for: healthStore),
              let todayStepCount = result.todayStepCount,
              self.todayStepCount != todayStepCount else {
            return
        }
        
        self.todayStepCount = todayStepCount
        logger.debug("Step count changed to: \(todayStepCount) (Refresh)")
        
        await updateStepCountNotification()
    }
    
    private func resetAllNotifications() async {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: notifications.map(\.value))
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notifications.map(\.value))
        notifications = [:]
        
        logger.debug("Reset all notification.")
        
        await updateStepCountNotification()
    }
    
    private func updateStepCountNotification() async {
        // Remove all already delivered notifications
        let oldNotifications = notifications.filter({ $0.key <= .now })
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: oldNotifications.map(\.value))
        for oldNotification in oldNotifications {
            notifications[oldNotification.key] = nil
            logger.debug("Removed old notification for \(oldNotification.key.formatted(date: .long, time: .omitted)).")
        }
        
        // Schedule Notifications for the next 7 days if they do not already exist
        let startOfDay = Calendar.current.startOfDay(for: .now)
        
        for daysFromNow in 0...7 {
            guard let futureStartOfDay = Calendar.current.date(byAdding: .day, value: daysFromNow, to: startOfDay) else {
                continue
            }
            
            guard notifications[futureStartOfDay] == nil else {
                continue
            }
            
            // We schedule the notifications every day at 5 PM.
            var dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: futureStartOfDay)
            dateComponents.hour = 17
            dateComponents.minute = 0
            
            guard let notificationDate = Calendar.current.date(from: dateComponents), notificationDate > .now else {
                continue
            }
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let content = UNMutableNotificationContent()
            content.title = String(
                localized: "Your Daily Step Goal"
            )
            content.body = String(
                localized: "Reminder to meet your daily step goal of \(stepCountGoal) steps. Open the Spezi Study App to see your current steps for the day."
            )
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            do {
                try await UNUserNotificationCenter.current().add(request)
                logger.debug("Scheduled Notification for \(futureStartOfDay.formatted(date: .long, time: .omitted)) at 5 PM (Goal: \(self.stepCountGoal))")
            } catch {
                logger.warning("Could not schedule notification for \(futureStartOfDay.formatted(date: .long, time: .omitted)) at 5 PM (Goal: \(self.stepCountGoal)): \(error)")
            }
            
            notifications[futureStartOfDay] = request.identifier
        }
        
        
        // Remove notification for today if we are above our step count goal
        if let todaysNotification = notifications[startOfDay], todayStepCount >= stepCountGoal {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [todaysNotification])
            notifications[startOfDay] = nil
            logger.debug("Removed today's step count goal notification as we have reached the step count goal.")
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
            do {
                for try await results in statisticsCollectionQueryDescriptor.results(for: healthStore) {
                    guard !Task.isCancelled else {
                        logger.debug("Task was cancelled, exeting results loop.")
                        return
                    }
                    
                    guard let todayStepCount = results.statisticsCollection.todayStepCount else {
                        logger.warning("Could not retrieve expected result from startistics collection.")
                        continue
                    }
                    
                    self.todayStepCount = todayStepCount
                    logger.debug("Step count changed to: \(todayStepCount)")
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


extension HKStatisticsCollection {
    fileprivate var todayStepCount: Int? {
        guard let result = self.statistics(for: .now),
              let stepCount = result.sumQuantity()?.doubleValue(for: HKUnit.count()) else {
            return nil
        }
        
        return Int(stepCount)
    }
}
