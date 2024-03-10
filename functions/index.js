//
// This source file is part of the StudyApplication based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

const { onCall } = require("firebase-functions/v2/https");

exports.helloWorld = onCall(
  {
    enforceAppCheck: true, // Reject requests with missing or invalid App Check tokens.
    consumeAppCheckToken: true  // Consume the token after verification.
  },
  (request) => {
    // request.app contains data from App Check, including the app ID.
    return { message: "Hello World" };
  }
);