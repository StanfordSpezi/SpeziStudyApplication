//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


enum StudyError: LocalizedError {
    case canOnlyEnrollInOneStudy
    
    
    var errorDescription: String? {
        switch self {
        case .canOnlyEnrollInOneStudy:
            String(localized: "The Spezi Study Application currently only allows enrolling in a single study at the same time.")
        }
    }
}
