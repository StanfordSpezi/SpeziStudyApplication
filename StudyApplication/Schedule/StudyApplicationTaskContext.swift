//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsR4
import SpeziFHIR


/// The context attached to each task in the Spezi Study Application.
///
/// We currently only support `Questionnaire`s, more cases can be added in the future.
enum StudyApplicationTaskContext: Codable, Identifiable {
    /// The task should display a `Questionnaire`.
    case questionnaire(Questionnaire)
    
    
    var id: Questionnaire.ID {
        switch self {
        case let .questionnaire(questionnaire):
            return questionnaire.id
        }
    }
    
    var actionType: LocalizedStringResource {
        switch self {
        case .questionnaire:
            return LocalizedStringResource("TASK_CONTEXT_ACTION_QUESTIONNAIRE")
        }
    }
}
