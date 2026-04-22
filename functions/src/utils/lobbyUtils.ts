import {HttpsError} from "firebase-functions/v2/https";
import {getFirestore} from "firebase-admin/firestore";

const db = getFirestore();

/**
 * Generates a random numeric code.
 * @param {number} length The length of the code.
 * @return {string} A random numeric code.
 */
function randomDigitCode(length = 4): string {
  let result = "";

  for (let i = 0; i < length; i++) {
    result += Math.floor(Math.random() * 10).toString();
  }

  return result;
}

/**
 * Generates a unique 4-digit join code for a waiting lobby.
 * @param {number} maxAttempts Maximum number of attempts.
 * @return {Promise<string>} A unique join code.
 */
export async function generateUniqueJoinCode(
  maxAttempts = 20
): Promise<string> {
  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    const code = randomDigitCode(4);

    const existing = await db
      .collection("lobbies")
      .where("joinCode", "==", code)
      .where("status", "==", "waiting")
      .limit(1)
      .get();

    if (existing.empty) {
      return code;
    }
  }

  throw new HttpsError(
    "resource-exhausted",
    "Could not generate a unique join code."
  );
}

/**
 * Normalizes a display name from incoming request data.
 * @param {unknown} value The raw incoming display name.
 * @return {string} A cleaned display name.
 */
export function normalizeDisplayName(value: unknown): string {
  if (typeof value !== "string") {
    return "Player";
  }

  const trimmed = value.trim();

  if (!trimmed) {
    return "Player";
  }

  return trimmed.substring(0, 30);
}
