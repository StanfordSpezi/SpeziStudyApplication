//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct DailyStepCountGoal: View {
    let study: Study
    @Environment(DailyStepCountGoalModule.self) var dailyStepCountGoalModule
    
    
    var body: some View {
        Text("Today's step count: \(dailyStepCountGoalModule.todayStepCount)")
    }
}


#Preview {
    let studyModule = StudyModule()
    
    return DailyStepCountGoal(study: studyModule.studies[0])
        .previewWith {
            DailyStepCountGoalModule()
            studyModule
        }
}
