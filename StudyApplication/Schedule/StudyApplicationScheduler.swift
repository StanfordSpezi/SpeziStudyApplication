//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziScheduler


/// A `Scheduler` using the ``StudyApplicationTaskContext`` to schedule and manage tasks and events in the
/// Spezi Study Application.
typealias StudyApplicationScheduler = Scheduler<StudyApplicationTaskContext>
