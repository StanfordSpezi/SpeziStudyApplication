//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import HealthKitOnFHIR
import OSLog
import PDFKit
import Spezi
import SpeziFirestore
import SpeziHealthKit
import SpeziOnboarding
import SpeziQuestionnaire
import SwiftUI


actor StudyApplicationStandard: Standard, EnvironmentAccessible, HealthKitConstraint, OnboardingConstraint {
    enum StudyApplicationStandardError: Error {
        case userNotAuthenticatedYet
        case userNotEnrolledInStudy
    }

    private static var userCollection: CollectionReference {
        Firestore.firestore().collection("users")
    }
    
    
    @Application(\.logger) private var logger: Logger
    @Dependency private var studyModule: StudyModule
    
    
    private var studyDocumentReference: DocumentReference {
        get async throws {
            guard let userId = Auth.auth().currentUser?.uid else {
                throw StudyApplicationStandardError.userNotAuthenticatedYet
            }
            
            guard let enrolledStudy = studyModule.enrolledStudy else {
                throw StudyApplicationStandardError.userNotEnrolledInStudy
            }

            return Self.userCollection.document(userId).collection("studies").document(enrolledStudy.id.uuidString)
        }
    }
    
    private var studyBucketReference: StorageReference {
        get async throws {
            guard let userId = Auth.auth().currentUser?.uid else {
                throw StudyApplicationStandardError.userNotAuthenticatedYet
            }
            
            guard let enrolledStudy = studyModule.enrolledStudy else {
                throw StudyApplicationStandardError.userNotEnrolledInStudy
            }
            
            return Storage.storage().reference().child("users/\(userId)/studies/\(enrolledStudy.id.uuidString)")
        }
    }


    init() { }


    func add(sample: HKSample) async {
        guard !FeatureFlags.disableFirebase else {
            logger.debug("Firebase disabled - would upload HKSample: \(sample)")
            return
        }
        
        do {
            try await healthKitDocument(id: sample.id).setData(from: sample.resource)
        } catch {
            logger.error("Could not store HealthKit sample: \(error)")
        }
    }
    
    func remove(sample: HKDeletedObject) async {
        guard !FeatureFlags.disableFirebase else {
            logger.debug("Firebase disabled - would remove HKDeletedObject: \(sample)")
            return
        }
        
        do {
            try await healthKitDocument(id: sample.uuid).delete()
        } catch {
            logger.error("Could not remove HealthKit sample: \(error)")
        }
    }
    
    func add(response: ModelsR4.QuestionnaireResponse) async {
        guard !FeatureFlags.disableFirebase else {
            logger.debug("Firebase disabled - would upload questionnaire response: \(response.description)")
            return
        }
        
        let id = response.identifier?.value?.value?.string ?? UUID().uuidString
        
        do {
            try await studyDocumentReference
                .collection("QuestionnaireResponse") // Add all HealthKit sources in a /QuestionnaireResponse collection.
                .document(id) // Set the document identifier to the id of the response.
                .setData(from: response)
        } catch {
            logger.error("Could not store questionnaire response: \(error)")
        }
    }
    
    
    private func healthKitDocument(id uuid: UUID) async throws -> DocumentReference {
        try await studyDocumentReference
            .collection("HealthKit") // Add all HealthKit sources in a /HealthKit collection.
            .document(uuid.uuidString) // Set the document identifier to the UUID of the document.
    }
    
    /// Stores the given consent form in the user's document directory with a unique timestamped filename.
    ///
    /// - Parameter consent: The consent form's data to be stored as a `PDFDocument`.
    func store(consent: PDFDocument) async {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HHmmss"
        let dateString = formatter.string(from: Date())
        
        guard !FeatureFlags.disableFirebase else {
            guard let basePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                logger.error("Could not create path for writing consent form to user document directory.")
                return
            }
            
            let filePath = basePath.appending(path: "consentForm_\(dateString).pdf")
            consent.write(to: filePath)
            
            return
        }
        
        do {
            guard let consentData = consent.dataRepresentation() else {
                logger.error("Could not store consent form.")
                return
            }
            
            let metadata = StorageMetadata()
            metadata.contentType = "application/pdf"
            _ = try await studyBucketReference.child("consent/\(dateString).pdf").putDataAsync(consentData, metadata: metadata)
        } catch {
            logger.error("Could not store consent form: \(error)")
        }
    }
}
