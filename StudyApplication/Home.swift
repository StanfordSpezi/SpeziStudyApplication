//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SpeziMockWebService
import SwiftUI


struct HomeView: View {
    enum Tabs: String {
        case schedule
        case contact
        case mockUpload
    }
    
    static var accountEnabled: Bool {
        FeatureFlags.accountEnabled && (!FeatureFlags.disableFirebase && !FeatureFlags.skipOnboarding)
    }


    @AppStorage(StorageKeys.homeTabSelection) private var selectedTab = Tabs.schedule
    @State private var presentingAccount = false

    
    var body: some View {
        TabView(selection: $selectedTab) {
            ScheduleView(presentingAccount: $presentingAccount)
                .tag(Tabs.schedule)
                .tabItem {
                    Label("Tasks", systemImage: "list.clipboard")
                }
        }
            .sheet(isPresented: $presentingAccount) {
                AccountSheet()
            }
            .verifyRequiredAccountDetails(Self.accountEnabled)
    }
}


#if DEBUG
#Preview {
    let details = AccountDetails.Builder()
        .set(\.userId, value: "lelandstanford@stanford.edu")
        .set(\.name, value: PersonNameComponents(givenName: "Leland", familyName: "Stanford"))
    
    return HomeView()
        .environment(Account(building: details, active: MockUserIdPasswordAccountService()))
        .environment(StudyApplicationScheduler())
        .environment(MockWebService())
}
#endif
