//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import OrderedCollections
import SpeziQuestionnaire
import SpeziScheduler
import SwiftUI


struct ScheduleView: View {
    @Environment(StudyApplicationStandard.self) private var standard
    @Environment(StudyApplicationScheduler.self) private var scheduler
    
    @State private var presentedContext: EventContext?
    @Binding private var presentingAccount: Bool
    
    
    private var eventContextsByDate: OrderedDictionary<Date, [EventContext]> {
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

        return OrderedDictionary(grouping: eventContexts) { eventContext in
            Calendar.current.startOfDay(for: eventContext.event.scheduledAt)
        }
    }
    
    
    var body: some View {
        NavigationStack {
            Group {
                let eventContextsByDate = eventContextsByDate
                if eventContextsByDate.isEmpty {
                    emptyListView
                } else {
                    listView(eventContextsByDate: eventContextsByDate)
                }
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
            .background {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
            }
    }
    
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
    
    
    @ViewBuilder
    private func listView(eventContextsByDate: OrderedDictionary<Date, [EventContext]>) -> some View {
        List(eventContextsByDate.keys, id: \.timeIntervalSinceNow) { startOfDay in
            Section(
                content: {
                    ForEach(eventContextsByDate[startOfDay] ?? [], id: \.event) { eventContext in
                        StudyApplicationListCard {
                            EventContextView(eventContext: eventContext)
                                .onTapGesture {
                                    if !eventContext.event.complete && eventContext.event.due {
                                        presentedContext = eventContext
                                    }
                                }
                        }
                    }
                },
                header: {
                    Text("\(startOfDay, style: .date)")
                        .studyApplicationHeaderStyle()
                }
            )
        }
            .studyApplicationList()
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
}


#Preview("Mock Study") {
    let studyModule = StudyModule()
    
    return ScheduleView(presentingAccount: .constant(false))
        .previewWith(standard: StudyApplicationStandard()) {
            studyModule
        }
        .task {
            try? await studyModule.enrollInStudy(study: studyModule.studies[0])
        }
}

#Preview("No Tasks") {
    ScheduleView(presentingAccount: .constant(false))
        .previewWith(standard: StudyApplicationStandard()) {
            StudyApplicationScheduler()
        }
}
