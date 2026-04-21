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

function normalizeGameTitle(value: unknown): string {
  if (typeof value !== "string") {
    return "Untitled game";
  }

  const trimmed = value.trim();

  if (!trimmed) {
    return "Untitled game";
  }

  return trimmed.substring(0, 80);
}

function normalizeJoinCode(value: unknown): string {
  if (typeof value !== "string") {
    throw new HttpsError("invalid-argument", "Join code must be a string.");
  }

  const trimmed = value.trim();

  if (!/^\d{4}$/.test(trimmed)) {
    throw new HttpsError("invalid-argument", "Join code must be 4 digits.");
  }

  return trimmed;
}

function getUidFromRequest(request: any): string {
  const authUid = request.auth?.uid;
  const fallbackUid = request.data?.uid;

  const uid =
        typeof authUid === "string" && authUid.trim().length > 0 ?
          authUid.trim() :
          typeof fallbackUid === "string" && fallbackUid.trim().length > 0 ?
            fallbackUid.trim() :
            null;

  if (!uid) {
    throw new HttpsError("unauthenticated", "No uid available.");
  }

  return uid;
}

export const createLobby2 = onCall(
  {region: "europe-west1"},
  async (request) => {
    const uid = getUidFromRequest(request);

    const displayName = normalizeDisplayName(request.data?.displayName);
    const gameTitle = normalizeGameTitle(request.data?.gameTitle);
    const joinCode = await generateUniqueJoinCode();

    const lobbyRef = db.collection("lobbies").doc();
    const playerRef = lobbyRef.collection("players").doc(uid);

    await db.runTransaction(async (tx) => {
      tx.set(lobbyRef, {
        joinCode,
        gameTitle,
        hostUid: uid,
        status: "waiting",
        gamePhase: "lobby",
        maxPlayers: 6,
        playerCount: 1,
        allReady: false,
        createdAt: FieldValue.serverTimestamp(),
        startedAt: null,
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
      gameTitle,
    };
  }
);

export const joinLobbyByCode = onCall(
  {region: "europe-west1"},
  async (request) => {
    const uid = getUidFromRequest(request);

    const joinCode = normalizeJoinCode(request.data?.joinCode);
    const displayName = normalizeDisplayName(request.data?.displayName);

    const lobbyQuery = await db
      .collection("lobbies")
      .where("joinCode", "==", joinCode)
      .where("status", "==", "waiting")
      .limit(1)
      .get();

    if (lobbyQuery.empty) {
      throw new HttpsError(
        "not-found",
        "No waiting lobby found with this join code."
      );
    }

    const lobbyDoc = lobbyQuery.docs[0];
    const lobbyRef = lobbyDoc.ref;
    const playerRef = lobbyRef.collection("players").doc(uid);

    await db.runTransaction(async (tx) => {
      const freshLobbyDoc = await tx.get(lobbyRef);

      if (!freshLobbyDoc.exists) {
        throw new HttpsError("not-found", "Lobby no longer exists.");
      }

      const lobbyData = freshLobbyDoc.data();

      if (lobbyData?.status !== "waiting") {
        throw new HttpsError(
          "failed-precondition",
          "This lobby has already started."
        );
      }

      const playerDoc = await tx.get(playerRef);

      if (playerDoc.exists) {
        tx.update(playerRef, {
          displayName,
          connected: true,
          lastSeenAt: FieldValue.serverTimestamp(),
        });

        return;
      }

      const maxPlayers = lobbyData?.maxPlayers ?? 6;
      const playerCount = lobbyData?.playerCount ?? 0;

      if (playerCount >= maxPlayers) {
        throw new HttpsError("resource-exhausted", "Lobby is full.");
      }

      tx.set(playerRef, {
        uid,
        displayName,
        isHost: false,
        isReady: false,
        connected: true,
        joinedAt: FieldValue.serverTimestamp(),
      });

      tx.update(lobbyRef, {
        playerCount: FieldValue.increment(1),
      });
    });

    return {
      success: true,
      lobbyId: lobbyRef.id,
      joinCode,
      gameTitle: lobbyDoc.data().gameTitle ?? "Untitled game",
    };
  }
);

export const startLobbyGame = onCall(
  {region: "europe-west1"},
  async (request) => {
    const uid = getUidFromRequest(request);

    const lobbyId = request.data?.lobbyId;

    if (typeof lobbyId !== "string" || lobbyId.trim().length > 0) {
      throw new HttpsError("invalid-argument", "No lobbyId provided.");
    }

    const lobbyRef = db.collection("lobbies").doc(lobbyId.trim());

    await db.runTransaction(async (tx) => {
      const lobbyDoc = await tx.get(lobbyRef);

      if (!lobbyDoc.exists) {
        throw new HttpsError("not-found", "Lobby not found.");
      }

      const lobbyData = lobbyDoc.data();

      if (lobbyData?.hostUid !== uid) {
        throw new HttpsError(
          "permission-denied",
          "Only the host can start the game."
        );
      }

      if (lobbyData?.status !== "waiting") {
        throw new HttpsError(
          "failed-precondition",
          "Lobby is not waiting anymore."
        );
      }

      tx.update(lobbyRef, {
        status: "started",
        gamePhase: "started",
        startedAt: FieldValue.serverTimestamp(),
      });
    });

    return {
      success: true,
      lobbyId,
    };
  }
);
