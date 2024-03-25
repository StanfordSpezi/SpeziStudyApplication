//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsR4


struct ActiveTask {
    let id: UUID
    let localizedDescription: LocalizedStringResource
}


/// The context attached to each task in the Spezi Study Application.
///
/// We currently only support `Questionnaire`s, more cases can be added in the future.
enum StudyApplicationTaskContext: Codable, Identifiable {
    /// The task should display a `Questionnaire`.
    case questionnaire(Questionnaire)
    /// The task should display an activity task.
    case activeTask(Questionnaire)
        
    
    var id: String {
        switch self {
        case let .questionnaire(questionnaire):
            guard let id = questionnaire.id?.primitiveDescription else {
                fatalError("Could not derive ID from questionnaire.")
            }
            return id
        case let .questionnaire(questionnaire):
            guard let id = questionnaire.id?.primitiveDescription else {
                fatalError("Could not derive ID from questionnaire.")
            }
            return id
        }
    }
    
    var actionType: LocalizedStringResource {
        switch self {
        case .questionnaire:
            return LocalizedStringResource("Start Questionnaire")
        case .activeTask:
            return LocalizedStringResource("Start Active Task")
        }
    }
}
