//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziOnboarding
import SpeziValidation
import SpeziViews
import SwiftUI


struct InvitationCodeView: View {
    private let study: Study
    
    @Environment(StudyViewModel.self) private var studyViewModel: StudyViewModel
    @State private var invitationCode = ""
    @State private var viewState: ViewState = .idle
    @ValidationState private var validation
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Divider()
                invitationCodeHeader
                Divider()
                Grid(horizontalSpacing: 16, verticalSpacing: 16) {
                    invitationCodeView
                }
                    .padding(.top, -8)
                    .padding(.bottom, -12)
                Divider()
                OnboardingActionsView(
                    "Redeem Inviation Code",
                    action: {
                        guard validation.validateSubviews() else {
                            return
                        }
                        
                        await verifyOnboardingCode()
                    }
                )
                    .disabled(invitationCode.isEmpty)
            }
                .padding(.horizontal)
                .padding(.bottom)
                .viewStateAlert(state: $viewState)
                .navigationBarTitleDisplayMode(.large)
                .navigationTitle(String(localized: "Invitation Code"))
        }
    }
    
    
    @ViewBuilder private var invitationCodeView: some View {
        DescriptionGridRow {
            Text("Invitation Code")
        } content: {
            VerifiableTextField(
                LocalizedStringResource("Invitation Code"),
                text: $invitationCode
            )
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.characters)
                .textContentType(.oneTimeCode)
                .validate(input: invitationCode, rules: [invitationCodeValidationRule])
        }
            .receiveValidation(in: $validation)
    }
    
    @ViewBuilder private var invitationCodeHeader: some View {
        VStack(spacing: 32) {
            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .accessibilityHidden(true)
                .foregroundStyle(Color.accentColor)
            Text("Plase enter your invitation code to join the \(study.title) study.")
        }
    }
    
    private var invitationCodeValidationRule: ValidationRule {
        ValidationRule(
            rule: { invitationCode in
                invitationCode.count >= 8
            },
            message: "An invitation code is at least 8 characters long."
        )
    }
    
    
    init(study: Study) {
        self.study = study
    }
    
    
    private func verifyOnboardingCode() async {
        do {
            guard invitationCode == "VASCTRAC" else {
                throw InviationCodeError.invitationCodeInvalid
            }
            
            try await studyViewModel.enrollInStudy(study: study)
        } catch let error as LocalizedError {
            viewState = .error(error)
        } catch {
            viewState = .error(String(localized: "Unknown Invitation Code Error"))
        }
    }
}
