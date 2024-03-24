//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


extension Study {
    enum Engagement: String, Codable, Identifiable {
        case studyEnrollment
        case dailyStepCountGoal
        
        
        var id: RawValue {
            rawValue
        }
        
        
        @ViewBuilder
        func view(correlatedToStudy study: Study) -> some View {
            switch self {
            case .dailyStepCountGoal:
                DailyStepCountGoal(study: study)
            case .studyEnrollment:
                DailyStepCountGoal(study: study)
            }
        }
    }
}
