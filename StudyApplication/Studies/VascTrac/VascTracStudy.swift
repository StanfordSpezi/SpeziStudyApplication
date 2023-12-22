//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziScheduler


// swiftlint:disable line_length force_unwrapping
// For now, we have this data stored in the app and therefore have to make some force unwraps and have some long lines. It will be loaded from firebase in the future.
extension Study {
    private static var vascTracDescription: String {
        "VascTrac is the first smartphone-based prospective longitudinal study that aims to enable researchers to track the progression of peripheral artery disease (PAD) and monitor patient- reported outcomes of exercise therapies, surgical procedures, and medications. By remotely monitoring daily activity of patients with smartphones, VascTrac aims to introduce precision medicine into the surveillance and management of PAD."
    }
    
    private static var vascTracTasks: [Task<StudyApplicationTaskContext>] {
        []
    }
    
    static var vascTracPaloAltoVA: Study {
        Study(
            id: UUID(uuidString: "02e8b3e6-c4e3-4cd9-b3f2-8bf257825478")!,
            title: "VascTrac - Palo Alto VA",
            titleImage: URL(string: "https://images.squarespace-cdn.com/content/v1/57d09729be659485ada8bdd2/1532817554721-8M7FSA6I81WR09Q5I52X/Intro1.png")!,
            organization: Organization(
                title: "Palo Alto VA Medical Center",
                logo: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Seal_of_the_U.S._Department_of_Veterans_Affairs.svg/240px-Seal_of_the_U.S._Department_of_Veterans_Affairs.svg.png")!
            ),
            description: vascTracDescription,
            onboardingMechanism: InviationCodeStudyOnboardingMechanism(),
            tasks: vascTracTasks
        )
    }
    
    static var vascTracStanford: Study {
        Study(
            id: UUID(uuidString: "911485b5-ccb0-4291-b21b-934307afd1a3")!,
            title: "VascTrac - Stanford University",
            titleImage: URL(string: "https://images.squarespace-cdn.com/content/v1/57d09729be659485ada8bdd2/1532817554721-8M7FSA6I81WR09Q5I52X/Intro1.png")!,
            organization: Organization(
                title: "Stanford University",
                logo: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Seal_of_the_U.S._Department_of_Veterans_Affairs.svg/480px-Seal_of_the_U.S._Department_of_Veterans_Affairs.svg.png")!
            ),
            description: vascTracDescription,
            onboardingMechanism: InviationCodeStudyOnboardingMechanism(),
            tasks: vascTracTasks
        )
    }
}
