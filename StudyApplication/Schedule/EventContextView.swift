//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziScheduler
import SwiftUI


struct EventContextView: View {
    let eventContext: EventContext
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    if eventContext.event.complete {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.accentColor)
                            .font(.system(size: 30))
                            .accessibilityHidden(true)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text(verbatim: eventContext.task.title)
                            .font(.headline)
                            .accessibilityLabel(
                                eventContext.event.complete
                                    ? "COMPLETED_TASK_LABEL \(eventContext.task.title)"
                                    : "TASK_LABEL \(eventContext.task.title)"
                            )
                        Text(verbatim: format(eventDate: eventContext.event.scheduledAt))
                            .font(.subheadline)
                    }
                }
                Divider()
                Text(eventContext.task.description)
                    .font(.callout)
                if !eventContext.event.complete && eventContext.event.due {
                    Text(eventContext.task.context.actionType)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.top, 8)
                }
            }
        }
            .disabled(eventContext.event.complete)
            .contentShape(Rectangle())
    }
    
    
    private func format(eventDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: eventDate)
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    guard let task = Study.vascTracStanford.tasks.first,
          let event = task.events(from: .now.addingTimeInterval(-60 * 60 * 24)).first else {
        fatalError("Could not load task")
    }
    
    return List {
        Section(
            content: {
                ForEach(0..<2) { _ in
                    EventContextView(eventContext: EventContext(event: event, task: task))
                }
                    .listRowSeparator(.hidden)
            },
            header: {
                Text("\(.now, style: .date)")
            }
        )
    }
        .listStyle(.plain)
}
