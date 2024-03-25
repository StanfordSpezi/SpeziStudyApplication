//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziScheduler


struct Study: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case id
        case title
        case titleImage
        case organization
        case description
        case onboardingMechanism
        case consentDocument
        case healthKit
        case notificationDescription
        case tasks
        case engagements
    }
    
    
    let id: UUID
    let title: String
    let titleImage: URL
    let organization: Organization
    let description: String
    let onboardingMechanism: any StudyOnboardingMechanism
    let consentDocument: String?
    let healthKit: Study.HealthKitAccess?
    let notificationDescription: String?
    let tasks: [Task<StudyApplicationTaskContext>]
    let engagements: [Engagement]
    
    
    init(
        id: UUID,
        title: String,
        titleImage: URL,
        organization: Organization,
        description: String,
        onboardingMechanism: any StudyOnboardingMechanism,
        consentDocument: String? = nil,
        healthKit: Study.HealthKitAccess? = nil,
        notificationDescription: String? = nil,
        tasks: [Task<StudyApplicationTaskContext>] = [],
        engagements: [Engagement] = []
    ) {
        self.id = id
        self.title = title
        self.titleImage = titleImage
        self.organization = organization
        self.description = description
        self.onboardingMechanism = onboardingMechanism
        self.consentDocument = consentDocument
        self.healthKit = healthKit
        self.notificationDescription = notificationDescription
        self.tasks = tasks
        self.engagements = engagements
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.titleImage = try container.decode(URL.self, forKey: .titleImage)
        self.organization = try container.decode(Organization.self, forKey: .organization)
        self.description = try container.decode(String.self, forKey: .description)
        
        let studyOnboardingMechanism = try container.decode(String.self, forKey: .onboardingMechanism)
        switch studyOnboardingMechanism {
        case InviationCodeStudyOnboardingMechanism.identifier:
            self.onboardingMechanism = InviationCodeStudyOnboardingMechanism()
        default:
            throw DecodingError.valueNotFound(
                (any StudyOnboardingMechanism).self,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid ")
            )
        }
        
        self.consentDocument = try container.decodeIfPresent(String.self, forKey: .consentDocument)
        self.healthKit = try container.decodeIfPresent(Study.HealthKitAccess.self, forKey: .healthKit)
        self.notificationDescription = try container.decodeIfPresent(String.self, forKey: .notificationDescription)
        self.tasks = try container.decodeIfPresent([Task<StudyApplicationTaskContext>].self, forKey: .tasks) ?? []
        self.engagements = try container.decodeIfPresent([Engagement].self, forKey: .engagements) ?? []
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.titleImage, forKey: .titleImage)
        try container.encode(self.organization, forKey: .organization)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.onboardingMechanism.id, forKey: .onboardingMechanism)
        try container.encode(self.consentDocument, forKey: .consentDocument)
        try container.encode(self.healthKit, forKey: .healthKit)
        try container.encode(self.notificationDescription, forKey: .notificationDescription)
        try container.encode(self.tasks, forKey: .tasks)
        try container.encode(self.engagements, forKey: .engagements)
    }
}
