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
            if FeatureFlags.disableFirebase {
                guard invitationCode == "VASCTRAC" else {
                    throw InviationCodeError.invitationCodeInvalid
                }
                
                try? await Task.sleep(for: .seconds(0.25))
            } else {
                let user: User
                if let currentUser = Auth.auth().currentUser {
                    user = currentUser
                } else {
                    let authResult = try await Auth.auth().signInAnonymously()
                    user = authResult.user
                }
                
                let isAnonymous = user.isAnonymous
                let uid = user.uid
                print("User \(uid) is anonymous: \(isAnonymous)")
                
                let options = HTTPSCallableOptions(requireLimitedUseAppCheckTokens: true)
                let helloWorld = Functions.functions().httpsCallable("helloWorld", options: options)
                
                let result = try await helloWorld.call()
                
                guard let data = result.data as? [String: Any] else {
                    throw InviationCodeError.invitationCodeInvalid
                }
                
                print(data)
            }
            
            try await studyViewModel.enrollInStudy(study: study)
            
            await onboardingNavigationPath.nextStep()
        } catch let error as LocalizedError {
            viewState = .error(error)
        } catch {
            viewState = .error(String(localized: "Unknown Invitation Code Error"))
        }
    }
}
