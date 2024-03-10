//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

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
        Array(eventContextsByDate.keys).sorted()
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
                .onChange(of: scheduler.tasks, initial: true) {
                    calculateEventContextsByDate()
                }
                .sheet(item: $presentedContext) { presentedContext in
                    destination(withContext: presentedContext)
                }
                .navigationTitle("Tasks")
        }
    }
    
    @ViewBuilder private var emptyListView: some View {
        ContentUnavailableView {
            Label("No Tasks", systemImage: "list.clipboard")
        } description: {
            Text("No tasks scheduled for your enrolled studies.")
        }
    }
    
    @ViewBuilder private var listView: some View {
        List(startOfDays, id: \.timeIntervalSinceNow) { startOfDay in
            Section(format(startOfDay: startOfDay)) {
                ForEach(eventContextsByDate[startOfDay] ?? [], id: \.event) { eventContext in
                    EventContextView(eventContext: eventContext)
                        .onTapGesture {
                            if !eventContext.event.complete && eventContext.event.due {
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
                    from: .distantPast,
                    to: .numberOfEvents(100)
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
        .previewWith(standard: StudyApplicationStandard()) {
            StudyApplicationScheduler()
        }
}
#endif
