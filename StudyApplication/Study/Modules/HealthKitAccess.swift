//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziHealthKit


extension Study {
    struct HealthKitAccess: Codable {
        enum CodingKeys: CodingKey {
            case usageDescription
        }
        
        let usageDescription: String
        let healthKitDescriptions: [HealthKitDataSourceDescription]
        
        
        init(
            usageDescription: String,
            @HealthKitDataSourceDescriptionBuilder _ healthKitDataSourceDescriptions: () -> [HealthKitDataSourceDescription]
        ) {
            self.usageDescription = usageDescription
            self.healthKitDescriptions = healthKitDataSourceDescriptions()
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.usageDescription = try container.decode(String.self, forKey: .usageDescription)
#warning("It would be nescessary to make HealthKitDataSourceDescription Codable to ensure that we can load them from firebase.")
            self.healthKitDescriptions = []
        }
        
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.usageDescription, forKey: .usageDescription)
        }
    }
}
