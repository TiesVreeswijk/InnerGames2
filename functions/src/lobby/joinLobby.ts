import {onCall, HttpsError} from "firebase-functions/v2/https";
import {FieldValue, getFirestore} from "firebase-admin/firestore";

const db = getFirestore();

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

export const joinLobby = onCall(
  {region: "europe-west1"},
  async (request) => {
    const uidRaw = request.data?.uid;
    const joinCodeRaw = request.data?.joinCode;
    const displayNameRaw = request.data?.displayName;

    const uid =
            typeof uidRaw === "string" && uidRaw.trim().length > 0 ?
              uidRaw.trim() :
              null;

    const joinCode =
            typeof joinCodeRaw === "string" && joinCodeRaw.trim().length > 0 ?
              joinCodeRaw.trim() :
              null;

    if (!uid) {
      throw new HttpsError("invalid-argument", "No uid provided.");
    }

    if (!joinCode) {
      throw new HttpsError("invalid-argument", "No joinCode provided.");
    }

    const displayName = normalizeDisplayName(displayNameRaw);

    const query = await db
      .collection("lobbies")
      .where("joinCode", "==", joinCode)
      .where("status", "==", "waiting")
      .limit(1)
      .get();

    if (query.empty) {
      throw new HttpsError("not-found", "Lobby not found.");
    }

    const lobbyRef = query.docs[0].ref;
    const playerRef = lobbyRef.collection("players").doc(uid);

    await db.runTransaction(async (tx) => {
      const lobbySnap = await tx.get(lobbyRef);
      if (!lobbySnap.exists) {
        throw new HttpsError("not-found", "Lobby not found.");
      }

      const lobbyData = lobbySnap.data();
      const playerCount = (lobbyData?.["playerCount"] ?? 0) as number;
      const maxPlayers = (lobbyData?.["maxPlayers"] ?? 6) as number;

      if (playerCount >= maxPlayers) {
        throw new HttpsError("failed-precondition", "Lobby is full.");
      }

      const existingPlayer = await tx.get(playerRef);
      if (existingPlayer.exists) {
        return;
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
        allReady: false,
      });
    });

    return {
      success: true,
      lobbyId: lobbyRef.id,
      joinCode,
    };
  }
);
