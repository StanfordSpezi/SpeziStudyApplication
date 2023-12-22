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
// For now, we have this data stored in the app and therefore have to make some force unwraps and have some long lines. It will be loaded from firebase in the future.
extension Study {
    private static var ahaLE8Questionnaire: Questionnaire {
        Bundle.main.questionnaire(withName: "AHA LE8")
    }
    private static var berlinQuestionnaire: Questionnaire {
        Bundle.main.questionnaire(withName: "Berlin")
    }
    private static var exerciseBenefitsBarriersQuestionnaire: Questionnaire {
        Bundle.main.questionnaire(withName: "Exercise Benefits Barriers")
    }
    private static var padWalkingImpairmentQuestionnaire: Questionnaire {
        Bundle.main.questionnaire(withName: "PAD Walking Impairment")
    }
    private static var phq9DepressionQuestionnaire: Questionnaire {
        Bundle.main.questionnaire(withName: "PHQ-9 Depression")
    }
    private static var physicalActivityQuestionnaire: Questionnaire {
        Bundle.main.questionnaire(withName: "Physical Activity Questionnaire")
    }
    
    private static var vascTracDescription: String {
        "VascTrac is the first smartphone-based prospective longitudinal study that aims to enable researchers to track the progression of peripheral artery disease (PAD) and monitor patient- reported outcomes of exercise therapies, surgical procedures, and medications. By remotely monitoring daily activity of patients with smartphones, VascTrac aims to introduce precision medicine into the surveillance and management of PAD."
    }
    
    private static var vascTracTasks: [SpeziScheduler.Task<StudyApplicationTaskContext>] {
        [
            task(forQuestionnaire: ahaLE8Questionnaire, title: "AHA LE8", week: 0),
            task(forQuestionnaire: berlinQuestionnaire, title: "Exercise Benefits Barriers", week: 0),
            task(forQuestionnaire: exerciseBenefitsBarriersQuestionnaire, title: "PAD Walking Impairment", week: 0),
            task(forQuestionnaire: padWalkingImpairmentQuestionnaire, title: "PHQ-9 Depression", week: 0),
            task(forQuestionnaire: phq9DepressionQuestionnaire, title: "Physical Activity Questionnaire", week: 0),
            task(forQuestionnaire: ahaLE8Questionnaire, title: "AHA LE8", week: 6),
            task(forQuestionnaire: berlinQuestionnaire, title: "Exercise Benefits Barriers", week: 6),
            task(forQuestionnaire: exerciseBenefitsBarriersQuestionnaire, title: "PAD Walking Impairment", week: 6),
            task(forQuestionnaire: padWalkingImpairmentQuestionnaire, title: "PHQ-9 Depression", week: 6),
            task(forQuestionnaire: phq9DepressionQuestionnaire, title: "Physical Activity Questionnaire", week: 6),
            task(forQuestionnaire: ahaLE8Questionnaire, title: "AHA LE8", week: 14),
            task(forQuestionnaire: berlinQuestionnaire, title: "Exercise Benefits Barriers", week: 14),
            task(forQuestionnaire: exerciseBenefitsBarriersQuestionnaire, title: "PAD Walking Impairment", week: 14),
            task(forQuestionnaire: padWalkingImpairmentQuestionnaire, title: "PHQ-9 Depression", week: 14),
            task(forQuestionnaire: phq9DepressionQuestionnaire, title: "Physical Activity Questionnaire", week: 14),
            task(forQuestionnaire: ahaLE8Questionnaire, title: "AHA LE8", week: 22),
            task(forQuestionnaire: berlinQuestionnaire, title: "Exercise Benefits Barriers", week: 22),
            task(forQuestionnaire: exerciseBenefitsBarriersQuestionnaire, title: "PAD Walking Impairment", week: 22),
            task(forQuestionnaire: padWalkingImpairmentQuestionnaire, title: "PHQ-9 Depression", week: 22),
            task(forQuestionnaire: phq9DepressionQuestionnaire, title: "Physical Activity Questionnaire", week: 22)
        ]
    }
    
    private static var vascTracHealthKitAccess: StudyHealthKitAccess {
        StudyHealthKitAccess(
            usageDescription: "VascTrac requires access to your step count, flight climed, and elements like the walking steadiness score to get a complete picture about your procedure preparation."
        ) {
            CollectSample(
                HKQuantityType(.stepCount),
                deliverySetting: .background(.afterAuthorizationAndApplicationWillLaunch)
            )
            CollectSample(
                HKQuantityType(.flightsClimbed),
                deliverySetting: .background(.afterAuthorizationAndApplicationWillLaunch)
            )
            CollectSamples(
                [
                    HKQuantityType(.walkingSpeed),
                    HKQuantityType(.walkingStepLength),
                    HKQuantityType(.walkingAsymmetryPercentage),
                    HKQuantityType(.walkingHeartRateAverage),
                    HKQuantityType(.walkingDoubleSupportPercentage),
                    HKQuantityType(.appleWalkingSteadiness)
                ],
                deliverySetting: .background(.afterAuthorizationAndApplicationWillLaunch)
            )
            CollectSample(
                HKQuantityType(.vo2Max),
                deliverySetting: .background(.afterAuthorizationAndApplicationWillLaunch)
            )
            CollectSample(
                HKQuantityType(.sixMinuteWalkTestDistance),
                deliverySetting: .background(.afterAuthorizationAndApplicationWillLaunch)
            )
        }
    }
    
    static var vascTracPaloAltoVA: Study {
        Study(
            id: UUID(uuidString: "02e8b3e6-c4e3-4cd9-b3f2-8bf257825478")!,
            title: "VascTrac - Palo Alto VA",
            titleImage: URL(string: "https://images.squarespace-cdn.com/content/v1/57d09729be659485ada8bdd2/1532817554721-8M7FSA6I81WR09Q5I52X/Intro1.png")!,
            organization: Organization(
                title: "Palo Alto VA Medical Center",
                logo: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Seal_of_the_U.S._Department_of_Veterans_Affairs.svg/240px-Seal_of_the_U.S._Department_of_Veterans_Affairs.svg.png")!
            ),
            description: vascTracDescription,
            onboardingMechanism: InviationCodeStudyOnboardingMechanism(),
            consentDocument: "Consent Document Placeholder ...",
            tasks: vascTracTasks
        )
    }
    
    static var vascTracStanford: Study {
        Study(
            id: UUID(uuidString: "911485b5-ccb0-4291-b21b-934307afd1a3")!,
            title: "VascTrac - Stanford University",
            titleImage: URL(string: "https://images.squarespace-cdn.com/content/v1/57d09729be659485ada8bdd2/1532817554721-8M7FSA6I81WR09Q5I52X/Intro1.png")!,
            organization: Organization(
                title: "Stanford University",
                logo: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Seal_of_the_U.S._Department_of_Veterans_Affairs.svg/480px-Seal_of_the_U.S._Department_of_Veterans_Affairs.svg.png")!
            ),
            description: vascTracDescription,
            onboardingMechanism: InviationCodeStudyOnboardingMechanism(),
            consentDocument: "Consent Document Placeholder ...",
            tasks: vascTracTasks
        )
    }
    
    
    static func task(forQuestionnaire questionnaire: Questionnaire, title: String, week: Int) -> SpeziScheduler.Task<StudyApplicationTaskContext> {
        var date = Date.now
        if week > 0 {
            let inXWeeks = Calendar.current.date(byAdding: .day, value: week * 7, to: date) ?? .now
            date = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: inXWeeks) ?? inXWeeks
        }
        
        return Task(
            title: "\(title) - Week \(week)",
            description: "Plase fill out the \(title) questionnaire on week \(week).",
            schedule: Schedule(
                start: date,
                repetition: .matching(DateComponents()),
                end: .numberOfEvents(1)
            ),
            notifications: true,
            context: .questionnaire(questionnaire)
        )
    }
}
