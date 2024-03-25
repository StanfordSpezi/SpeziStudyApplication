//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct DailyStepCountGoal: View {
    enum Constants {
        static let stepCountGoalIncrement = 500
    }
    
    let study: Study
    @Environment(DailyStepCountGoalModule.self) var dailyStepCountGoalModule
    
    
    var body: some View {
        VStack {
            todayStepCountSection
            Divider()
            goalSection
        }
    }
    
    
    @ViewBuilder private var todayStepCountSection: some View {
        ZStack {
            Gauge(progress: Double(dailyStepCountGoalModule.todayStepCount) / Double(dailyStepCountGoalModule.stepCountGoal))
            VStack {
                Text("\(dailyStepCountGoalModule.todayStepCount)")
                    .font(.largeTitle.bold().monospacedDigit())
                    .minimumScaleFactor(0.3)
                    .contentTransition(.numericText())
                    .animation(.easeOut, value: dailyStepCountGoalModule.todayStepCount)
                Text("Steps Today")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
                .padding(.horizontal, 20)
        }
            .frame(minHeight: 140, idealHeight: 180, maxHeight: 200)
            .padding()
            .padding(.horizontal, 32)
    }
    
    @ViewBuilder private var goalSection: some View {
        HStack(alignment: .firstTextBaseline) {
            Spacer()
            decreaseDailyStepCountGoalButton
            VStack {
                Text("\(dailyStepCountGoalModule.stepCountGoal)")
                    .font(.title.bold().monospacedDigit())
                    .contentTransition(.numericText())
                    .animation(.easeOut, value: dailyStepCountGoalModule.stepCountGoal)
                Text("Daily Step Count Goal")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
                .frame(minWidth: 150)
                .accessibilityLabel(Text("Daily Step Count Goal: \(dailyStepCountGoalModule.stepCountGoal)"))
            increaseDailyStepCountGoalButton
            Spacer()
        }
            .padding(.top)
    }
    
    @ViewBuilder private var decreaseDailyStepCountGoalButton: some View {
        Button(
            action: {
                guard dailyStepCountGoalModule.stepCountGoal > 3 * Constants.stepCountGoalIncrement else {
                    dailyStepCountGoalModule.stepCountGoal = 2 * Constants.stepCountGoalIncrement
                    return
                }
                dailyStepCountGoalModule.stepCountGoal -= Constants.stepCountGoalIncrement
            },
            label: {
                Image(systemName: "minus.circle")
                    .accessibilityLabel(Text("Decrease Step Count Goal by \(Constants.stepCountGoalIncrement)"))
            }
        )
            .font(.title)
            .foregroundStyle(Color.accentColor)
            .buttonStyle(.borderless)
    }
    
    @ViewBuilder private var increaseDailyStepCountGoalButton: some View {
        Button(
            action: {
                dailyStepCountGoalModule.stepCountGoal += Constants.stepCountGoalIncrement
            },
            label: {
                Image(systemName: "plus.circle")
                    .accessibilityLabel(Text("Increase Step Count Goal by \(Constants.stepCountGoalIncrement)"))
            }
        )
            .font(.title)
            .foregroundStyle(Color.accentColor)
            .buttonStyle(.borderless)
    }
}


#Preview {
    let studyModule = StudyModule()
    
    
    return NavigationStack {
        List {
            StudyApplicationListCard {
                DailyStepCountGoal(study: studyModule.studies[0])
            }
        }
            .studyApplicationList()
            .navigationTitle("Daily Step Goal")
    }
        .previewWith(standard: StudyApplicationStandard()) {
            DailyStepCountGoalModule()
            studyModule
        }
        .task {
            try? await studyModule.enrollInStudy(study: studyModule.studies[0])
        }
}
