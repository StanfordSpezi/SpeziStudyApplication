//
// This source file is part of the Stanford Spezi Study Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseAuth
import FirebaseFunctions
import SpeziOnboarding
import SpeziValidation
import SpeziViews
import SwiftUI


struct InvitationCodeView: View {
    private let study: Study
    
    @Environment(OnboardingNavigationPath.self) private var onboardingNavigationPath
    @Environment(StudyModule.self) private var studyModule: StudyModule
    @State private var invitationCode = ""
    @State private var viewState: ViewState = .idle
    @ValidationState private var validation
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
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
                .frame(height: 80)
                .accessibilityHidden(true)
                .foregroundStyle(Color.accentColor)
                .padding(.top, 24)
            Text("Plase enter your invitation code to join the \(study.title) study.")
                .multilineTextAlignment(.center)
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
            if FeatureFlags.disableFirebase || ProcessInfo.processInfo.isPreviewSimulator {
                guard invitationCode == "VASCTRAC" else {
                    throw InviationCodeError.invitationCodeInvalid
                }
                
                try? await Task.sleep(for: .seconds(0.25))
            } else {
                if Auth.auth().currentUser == nil {
                    try await Auth.auth().signInAnonymously()
                }
                
                let checkInvitationCode = Functions.functions().httpsCallable("checkInvitationCode")
                
                do {
                    _ = try await checkInvitationCode.call(
                        [
                            "invitationCode": invitationCode,
                            "studyId": study.id.uuidString
                        ]
                    )
                } catch {
                    throw InviationCodeError.invitationCodeInvalid
                }
            }
            
            try await studyModule.enrollInStudy(study: study)
            
            await onboardingNavigationPath.nextStep()
        } catch let error as LocalizedError {
            viewState = .error(error)
        } catch {
            viewState = .error(String(localized: "Unknown Invitation Code Error"))
        }
    }
}


#Preview {
    OnboardingStack {
        InvitationCodeView(study: StudyModule().studies[0])
    }
        .previewWith(standard: StudyApplicationStandard()) {
            StudyModule()
        }
}
