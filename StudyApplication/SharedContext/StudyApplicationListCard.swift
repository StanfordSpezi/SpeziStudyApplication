//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct StudyApplicationListCard<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    
    var content: () -> Content
    
    
    var body: some View {
        content()
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background {
                Color(uiColor: colorScheme == .light ? .systemBackground : .secondarySystemBackground)
                    .ignoresSafeArea()
            }
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .listRowBackground(Color(.systemGroupedBackground))
            .listRowSeparator(.hidden)
    }
    
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
}


extension List {
    func studyApplicationList() -> some View {
        self
            .listRowSpacing(-8)
            .listSectionSpacing(-16)
            .listStyle(.plain)
            .background {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
            }
    }
}

extension Text {
    func studyApplicationHeaderStyle() -> some View {
        self
            .font(.title2.bold())
            .foregroundStyle(Color(.label))
    }
}


#Preview("Sections") {
    NavigationStack {
        List {
            ForEach(0..<2) { _ in
                Section(
                    content: {
                        ForEach(0..<2) { _ in
                            StudyApplicationListCard {
                                HStack {
                                    Text("Content ...")
                                    Spacer()
                                }
                            }
                        }
                            .listRowSeparator(.hidden)
                    },
                    header: {
                        Text("\(.now, style: .date)")
                            .studyApplicationHeaderStyle()
                    }
                )
            }
        }
            .studyApplicationList()
            .navigationTitle("List With Sections")
    }
}

#Preview("No Sections") {
    NavigationStack {
        List {
            ForEach(0..<2) { _ in
                StudyApplicationListCard {
                    HStack {
                        Text("Content ...")
                        Spacer()
                    }
                }
            }
        }
            .studyApplicationList()
            .navigationTitle("List Without Sections")
    }
}
