//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

const {onCall} = require("firebase-functions/v2/https");
const {logger, https} = require("firebase-functions/v2");


exports.checkInvitationCode = onCall((request) => {
  if (!request.auth || !request.auth.uid) {
    throw new https.HttpsError('unauthenticated', 'User is not properly authenticated.');
  }

  const invitationCode = request.data.invitationCode;
  const uid = request.auth.uid;

  logger.debug("Called by user with id (" + uid + ") -> InvitationCode: " + invitationCode);

  if (invitationCode === "VASCTRAC") {
    return {};
  } else {
    throw new https.HttpsError('invalid-argument', 'Invitation code not correct.');
  }
});