//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SpeziQuestionnaire
import SpeziScheduler
import SwiftUI


struct ScheduleView: View {
    @Environment(StudyApplicationStandard.self) private var standard
    @Environment(StudyApplicationScheduler.self) private var scheduler
    @State private var eventContextsByDate: [Date: [EventContext]] = [:]
    @State private var presentedContext: EventContext?


    @Binding private var presentingAccount: Bool
    
    
    private var startOfDays: [Date] {
        Array(eventContextsByDate.keys)
    }
    
    
    var body: some View {
        NavigationStack {
            Group {
                if startOfDays.isEmpty {
                    emptyListView
                } else {
                    listView
                }
            }
                .onChange(of: scheduler) {
                    calculateEventContextsByDate()
                }
                .task {
                    calculateEventContextsByDate()
                }
                .sheet(item: $presentedContext) { presentedContext in
                    destination(withContext: presentedContext)
                }
                .toolbar {
                    if AccountButton.shouldDisplay {
                        AccountButton(isPresented: $presentingAccount)
                    }
                }
                .navigationTitle("Tasks")
        }
    }
    
    @ViewBuilder private var emptyListView: some View {
        VStack(spacing: 32) {
            Image(systemName: "list.clipboard")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .accessibilityHidden(true)
                .foregroundStyle(.secondary)
            Text("No tasks scheduled for today.")
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder private var listView: some View {
        List(startOfDays, id: \.timeIntervalSinceNow) { startOfDay in
            Section(format(startOfDay: startOfDay)) {
                ForEach(eventContextsByDate[startOfDay] ?? [], id: \.event) { eventContext in
                    EventContextView(eventContext: eventContext)
                        .onTapGesture {
                            if !eventContext.event.complete {
                                presentedContext = eventContext
                            }
                        }
                }
            }
        }
    }
    
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
    
    
    private func destination(withContext eventContext: EventContext) -> some View {
        @ViewBuilder var destination: some View {
            switch eventContext.task.context {
            case let .questionnaire(questionnaire):
                QuestionnaireView(questionnaire: questionnaire) { result in
                    presentedContext = nil

                    guard case let .completed(response) = result else {
                        return // user cancelled the task
                    }

                    eventContext.event.complete(true)
                    await standard.add(response: response)
                }
            }
        }
        return destination
    }
    
    
    private func format(startOfDay: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: startOfDay)
    }
    
    private func calculateEventContextsByDate() {
        let eventContexts = scheduler.tasks.flatMap { task in
            task
                .events(
                    from: Calendar.current.startOfDay(for: .now),
                    to: .numberOfEventsOrEndDate(100, .now)
                )
                .map { event in
                    EventContext(event: event, task: task)
                }
        }
            .sorted()
        
        let newEventContextsByDate = Dictionary(grouping: eventContexts) { eventContext in
            Calendar.current.startOfDay(for: eventContext.event.scheduledAt)
        }
        
        eventContextsByDate = newEventContextsByDate
    }
}


#if DEBUG
#Preview("ScheduleView") {
    ScheduleView(presentingAccount: .constant(false))
        .environment(StudyApplicationScheduler())
        .environment(Account())
}

#Preview("ScheduleView") {
    let details = AccountDetails.Builder()
        .set(\.userId, value: "lelandstanford@stanford.edu")
        .set(\.name, value: PersonNameComponents(givenName: "Leland", familyName: "Stanford"))
    
    return ScheduleView(presentingAccount: .constant(true))
        .environment(StudyApplicationScheduler())
        .environment(Account(building: details, active: MockUserIdPasswordAccountService()))
}
#endif
