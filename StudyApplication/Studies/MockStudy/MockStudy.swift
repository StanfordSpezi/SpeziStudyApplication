//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsR4
import SpeziHealthKit
import SpeziScheduler


// swiftlint:disable line_length force_unwrapping
extension Study {
    private static var mockDescription: String {
        "Our mission is to advance digital health research and applications by fostering an accessible health ecosystem at the Stanford Byers Center for Biodesign. We develop, implement, and investigate digital health solutions that improve health journeys. Our flagship project, Stanford Spezi, is an open-source framework for building modular, interoperable, and scalable digital health applications."
    }
    
    private static var vascTracTasks: [SpeziScheduler.Task<StudyApplicationTaskContext>] {
        [
            Task(
                title: "Example Title",
                description: "This is a bit longer example description that is rendered with a task.",
                schedule: Schedule(
                    start: .now,
                    repetition: .matching(DateComponents(hour: 23, minute: 59)),
                    end: .numberOfEvents(1)
                ),
                notifications: true,
                context: .questionnaire(Questionnaire.phq9)
            )
        ]
    }
    
    private static var mockHealthKitAccess: Study.HealthKitAccess {
        Study.HealthKitAccess(
            usageDescription: "The Mock Study requires access to your step count to get a complete picture about your health status."
        ) {
            CollectSamples(
                [
                    HKQuantityType(.stepCount)
                ],
                deliverySetting: .background(.automatic)
            )
        }
    }
    
    static var mockStudy: Study {
        Study(
            id: UUID(uuidString: "02E8B3E6-C4E3-4CD9-B3F2-8BF257825470")!,
            title: "Mock Study",
            titleImage: URL(string: "https://bdh.sites.stanford.edu/sites/g/files/sbiybj28491/files/styles/breakpoint_2xl_2x/public/media/image/photo-epel-stanford-campus.jpg.webp?itok=StftZAgI")!,
            organization: Organization(
                title: "Stanford Byers Center for Biodesing",
                logo: URL(string: "https://pbs.twimg.com/profile_images/1372580239805616129/OlR0Y3Ae_400x400.jpg")!
            ),
            description: mockDescription,
            onboardingMechanism: InviationCodeStudyOnboardingMechanism(),
            consentDocument: "This is an example consent",
            healthKit: mockHealthKitAccess,
            notificationDescription: "The Mock Study wants to send you notifications to remind you about answering your questinnaires.",
            tasks: vascTracTasks,
            engagements: [
                .studyEnrollment,
                .dailyStepCountGoal
            ]
        )
    }
}
