//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct MainView: View {
    enum Tabs: String {
        case home
        case studies
        case schedule
    }
    
    
    static var accountEnabled: Bool {
        !FeatureFlags.disableFirebase && !FeatureFlags.skipOnboarding
    }

    
    @AppStorage(StorageKeys.homeTabSelection) private var selectedTab = Tabs.studies
    @State private var presentingAccount = false

    
    var body: some View {
        TabView(selection: $selectedTab) {
            Home()
                .tag(Tabs.home)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            StudiesView()
                .tag(Tabs.studies)
                .tabItem {
                    Label("Studies", systemImage: "list.clipboard")
                }
            ScheduleView(presentingAccount: $presentingAccount)
                .tag(Tabs.schedule)
                .tabItem {
                    Label("Tasks", systemImage: "checklist")
                }
        }
    }
}


#if DEBUG
#Preview {
    MainView()
}
#endif
