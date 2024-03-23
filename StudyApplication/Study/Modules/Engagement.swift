//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


extension Study {
    enum Engagement: String, Codable {
        case dailyStepCountGoal
        
        
        @ViewBuilder var view: some View {
            switch self {
            case .dailyStepCountGoal:
                Text("Daily Step Count Goal ...")
            }
        }
    }

}
