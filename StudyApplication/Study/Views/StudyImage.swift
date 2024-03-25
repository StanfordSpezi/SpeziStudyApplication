//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct StudyImage: View {
    private let study: Study
    
    
    var body: some View {
        AsyncImage(url: study.titleImage) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(height: 160)
        } placeholder: {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
            .frame(height: 160)
            .background {
                Color(.systemGray5)
            }
            .clipShape(Rectangle())
    }
    
    
    init(study: Study) {
        self.study = study
    }
}

#Preview {
    StudyImage(study: StudyModule().studies[0])
}
