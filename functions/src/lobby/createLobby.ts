import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp} from "firebase-admin/app";
import {FieldValue, getFirestore} from "firebase-admin/firestore";

initializeApp();
const db = getFirestore();

function randomDigitCode(length = 4): string {
  let result = "";
  for (let i = 0; i < length; i++) {
    result += Math.floor(Math.random() * 10).toString();
  }
  return result;
}

async function generateUniqueJoinCode(maxAttempts = 20): Promise<string> {
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

function normalizeDisplayName(value: unknown): string {
  if (typeof value !== "string") {
    return "Player";
  }

  const trimmed = value.trim();
  if (!trimmed) {
    return "Player";
  }

  return trimmed.substring(0, 30);
}

export const createLobby2 = onCall(
  {region: "europe-west1"},
  async (request) => {
    const fallbackUid = request.data?.uid;
    const rawDisplayName = request.data?.displayName;

    const uid =
            typeof fallbackUid === "string" && fallbackUid.trim().length > 0 ?
              fallbackUid.trim() :
              null;

    if (!uid) {
      throw new HttpsError("invalid-argument", "No uid provided.");
    }

    const displayName = normalizeDisplayName(rawDisplayName);
    const joinCode = await generateUniqueJoinCode();

    const lobbyRef = db.collection("lobbies").doc();
    const playerRef = lobbyRef.collection("players").doc(uid);

    await db.runTransaction(async (tx) => {
      tx.set(lobbyRef, {
        joinCode,
        hostUid: uid,
        status: "waiting",
        gamePhase: "lobby",
        maxPlayers: 6,
        playerCount: 1,
        allReady: false,
        createdAt: FieldValue.serverTimestamp(),
      });

      tx.set(playerRef, {
        uid,
        displayName,
        isHost: true,
        isReady: false,
        connected: true,
        joinedAt: FieldValue.serverTimestamp(),
      });
    });

    return {
      success: true,
      lobbyId: lobbyRef.id,
      joinCode,
    };
  }
);
