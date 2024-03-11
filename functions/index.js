//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

const {onCall} = require("firebase-functions/v2/https");
const {logger, https} = require("firebase-functions/v2");
const { FieldValue } = require('firebase-admin/firestore');
const admin = require("firebase-admin");

admin.initializeApp();

exports.checkInvitationCode = onCall(async (request) => {
  if (!request.auth || !request.auth.uid) {
    throw new https.HttpsError(
        "unauthenticated",
        "User is not properly authenticated.",
    );
  }

  const {invitationCode, studyId} = request.data;
  const userId = request.auth.uid;
  const firestore = admin.firestore();

  logger.debug(`User (${userId}) -> Study ${studyId}, InvitationCode ${invitationCode}`);

  try {
    const invitationCodeRef = firestore.doc(`studies/${studyId}/invitationCodes/${invitationCode}`);
    const invitationCodeDoc = await invitationCodeRef.get();

    if (!invitationCodeDoc.exists || invitationCodeDoc.data().used) {
      throw new https.HttpsError("not-found", "Invitation code not found or already used.");
    }

    const userStudyRef = firestore.doc(`users/${userId}/studies/${studyId}`);
    const userStudyDoc = await userStudyRef.get();

    if (userStudyDoc.exists) {
      throw new https.HttpsError("already-exists", "User is already enrolled in the study.");
    }

    await firestore.runTransaction(async (transaction) => {
      transaction.set(userStudyRef, {
        invitationCode: invitationCode,
        dateOfEnrollment: FieldValue.serverTimestamp(),
      });

      transaction.update(invitationCodeRef, {
        used: true,
        usedBy: userId,
      });
    });

    logger.debug(`User (${userId}) successfully enrolled in study (${studyId}) with invitation code: ${invitationCode}`);

    return {};
  } catch (error) {
    logger.error(`Error processing request: ${error.message}`);
    if (!error.code) {
      throw new https.HttpsError("internal", "Internal server error.");
    }
    throw error;
  }
});
