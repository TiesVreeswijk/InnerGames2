import {initializeApp} from "firebase-admin/app";
import {onCall} from "firebase-functions/v2/https";
initializeApp();

export {createLobby2} from "./lobby/createLobby";
export {joinLobby} from "./lobby/joinLobby";

export const debugAuth = onCall({region: "europe-west1"}, async (request) => {
  return {
    auth: request.auth ?? null,
    data: request.data ?? null,
  };
});


