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
        case tasks
    }
    
    
    let id: UUID
    let title: String
    let titleImage: URL
    let organization: Organization
    let description: String
    let onboardingMechanism: any StudyOnboardingMechanism
    let tasks: [Task<StudyApplicationTaskContext>]
    
    
    init(
        id: UUID,
        title: String,
        titleImage: URL,
        organization: Organization,
        description: String,
        onboardingMechanism: any StudyOnboardingMechanism,
        tasks: [Task<StudyApplicationTaskContext>]
    ) {
        self.id = id
        self.title = title
        self.titleImage = titleImage
        self.organization = organization
        self.description = description
        self.onboardingMechanism = onboardingMechanism
        self.tasks = tasks
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
        
        self.tasks = try container.decode([Task<StudyApplicationTaskContext>].self, forKey: .tasks)
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.titleImage, forKey: .titleImage)
        try container.encode(self.organization, forKey: .organization)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.onboardingMechanism.id, forKey: .onboardingMechanism)
        try container.encode(self.tasks, forKey: .tasks)
    }
}
