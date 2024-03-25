//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct StudyHeader: View {
    private let study: Study
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(study.title)
                    .font(.title2)
                    .bold()
                Text(study.organization.title)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            HStack(alignment: .top) {
                AsyncImage(url: study.organization.logo) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                    .frame(width: 50)
            }
        }
    }
    
    
    init(study: Study) {
        self.study = study
    }
}

#Preview {
    StudyHeader(study: StudyModule().studies[0])
}
