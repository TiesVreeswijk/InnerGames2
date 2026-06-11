# Tweekracht Sociality

Companion app for the Tweekracht Sociality board game. The app combines multiplayer lobbies, branching scenario gameplay, and Firebase-backed state syncing for social learning sessions.

## Overview

This project is a Flutter application with Firebase integration.

- Players sign in anonymously with Firebase Auth.
- Hosts create a lobby and receive a 4-digit join code.
- Other players join the same lobby with that code.
- The lobby syncs in real time through Cloud Firestore.
- The host starts the game and all players move into the same scenario flow.
- Scenarios and answers are loaded from Firestore.
- App settings currently support language switching and text scaling.

## Current Functionality

### Multiplayer lobby flow

- Create a lobby through a Firebase Callable Function.
- Join a lobby with a 4-digit PIN.
- Show connected players in real time.
- Preserve player avatar selection in the lobby.
- Host can start the game for everyone in the lobby.
- Host closing or finishing a lobby returns players to the app flow safely.

### Scenario gameplay

- Load scenarios dynamically from Firestore.
- Present story cards and answer choices.
- Move through branching scenarios.
- Sync the current scenario through the lobby document.
- Support host-driven progression in multiplayer sessions.
- Handle end-state and game-over flows.

### App experience

- Splash, welcome, home, create/join, avatar selection, lobby, story, and settings screens.
- Dutch and English language support through the app settings provider.
- Adjustable text scale applied across the app.
- Sharing support through the installed share package.

## Current Limitations

- QR join is not fully implemented in the active flow yet. The `/join-qr` route currently shows a placeholder screen.
- The older `lib/providers/game_provider.dart` file is a prototype local state manager and is not the main multiplayer implementation anymore.
- Some legacy screens remain in the repository from earlier iterations.

## Tech Stack

- Flutter
- Provider
- Firebase Core
- Firebase Auth
- Cloud Firestore
- Cloud Functions
- QR Flutter
- Mobile Scanner
- Share Plus

## Project Structure

```text
lib/
    main.dart                  App entry point and route registration
    firebase_options.dart      Firebase platform configuration
    models/                    Lobby, scenario, and story models
    providers/                 App settings and legacy local game state
    screens/                   UI flow for onboarding, lobby, gameplay, settings
    services/                  Firebase auth, lobby, and scenario access
    theme/                     Shared styling
    widgets/                   Reusable UI components

functions/
    src/                       Firebase Cloud Functions source
    lib/                       Compiled Cloud Functions output
```

## Main App Flow

### Host flow

```text
Splash -> Welcome -> Home -> Create/Join -> Host Name -> Story Selection
-> Lobby Creation -> Host Lobby -> Start Game -> Story Flow
```

### Player flow

```text
Splash -> Welcome -> Home -> Create/Join -> Name Entry -> Join PIN
-> Player Lobby -> Wait for Host -> Story Flow
```

## Firebase Responsibilities

### Authentication

The app signs users in anonymously on startup so every player has a Firebase identity without requiring a full account flow.

### Cloud Functions

The active backend entry points are:

- `createLobby2`: creates a lobby, generates a unique 4-digit join code, and stores the host as the first player.
- `joinLobby`: validates a join code and adds a player to the lobby.
- `debugAuth`: simple callable helper for inspecting auth payloads during development.

### Firestore

Firestore stores:

- lobbies
- lobby players
- scenarios
- scenario answers

## Setup

### Prerequisites

- Flutter SDK
- Dart SDK
- Firebase project configured for this app
- Android Studio and/or Xcode for mobile builds
- Node.js for Cloud Functions development

### Install dependencies

```bash
flutter pub get
cd functions
npm install
```

### Firebase configuration

This repository already contains platform Firebase config files and `lib/firebase_options.dart`, but you still need a matching Firebase project and deployed backend resources.

Make sure these are valid for your environment:

- `android/app/google-services.json`
- `ios/GoogleService-Info.plist`
- `lib/firebase_options.dart`

### Run the app

```bash
flutter run
```

### Run tests

```bash
flutter test
```

### Deploy Cloud Functions

```bash
cd functions
npm run build
firebase deploy --only functions
```

## Notes For Development

- The active multiplayer architecture lives in `lib/services/` and `functions/src/`.
- `AppSettingsProvider` is the active provider used by the app shell.
- `GameProvider` represents an older prototype flow and should not be treated as the source of truth for current multiplayer behavior.
- Scenario content is expected in Firestore rather than hardcoded local data for the active game flow.

## Platform Support

- Android
- iOS
- Web support may require extra work for camera-dependent flows such as QR scanning

## Credits

Built for Tweekracht Sociality.

 ## colorscheme 

 check the figma for the design choses and the colors used