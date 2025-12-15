# Sociality App

A Flutter app for exploring social work situations through interactive storytelling with multiplayer support.

## 🎯 Features

- **Multiplayer Gameplay**: Host can create games and participants can join via PIN or QR code
- **Interactive Stories**: Navigate through branching narratives with decision points
- **Real-time Voting**: Players vote on choices and see collective results
- **Score Tracking**: Points awarded based on choices made
- **QR Code Support**: Join games by scanning QR codes
- **State Management**: Provider pattern ready for backend integration

## 📱 Screens Created

### Authentication & Setup
1. **WelcomeScreen** - Initial welcome screen with logo and introduction
2. **HomeScreen** - Main screen showing available stories/games
3. **HostStartScreen** - Host view showing participants and game controls
4. **PinShareScreen** - Screen to share PIN code with participants
5. **QRShareScreen** - Screen to share QR code for joining
6. **JoinPinScreen** - Screen for participants to join using PIN code
7. **QRScannerScreen** - Camera screen to scan QR codes

### Gameplay
8. **GameCardScreen** - Display story cards with narrative content
9. **DecisionScreen** - Present choices to players and collect votes
10. **VotingResultsScreen** - Show voting results and winning choice
11. **QuestionScreen** - "Why your choice?" reflection screen

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point with Provider setup
├── models/
│   └── game_models.dart         # Data models (GameStory, Player, GameSession, etc.)
├── providers/
│   └── game_provider.dart       # State management (ready for backend)
├── data/
│   └── game_data.dart           # Story content (currently Skatepark story)
└── screens/
    ├── welcome_screen.dart
    ├── home_screen.dart
    ├── host_start_screen.dart
    ├── pin_share_screen.dart
    ├── qr_share_screen.dart
    ├── join_pin_screen.dart
    ├── qr_scanner_screen.dart
    ├── game_card_screen.dart
    ├── decision_screen.dart
    ├── voting_results_screen.dart
    └── question_screen.dart
```

## 🚀 Setup Instructions

1. **Install Flutter** (if not already installed)
   ```bash
   # Visit https://flutter.dev/docs/get-started/install
   ```

2. **Create the project directory structure:**
   ```bash
   cd /home/claude/sociality_app
   mkdir -p assets/images
   mkdir -p fonts
   ```

3. **Add required assets:**
   - Add app logo to `assets/images/logo.png`
   - Add background image to `assets/images/background.jpg`
   - Add skatepark story images:
     - `assets/images/skatepark_story.jpg`
     - `assets/images/skatepark_start.jpg`
     - `assets/images/skatepark_situation.jpg`
   - Add crown icon to `assets/images/crown.png`
   - (Optional) Add SF Pro fonts to `fonts/` directory

4. **Get dependencies:**
   ```bash
   flutter pub get
   ```

5. **Run the app:**
   ```bash
   flutter run
   ```

## 🎨 Color Scheme

- Primary Background: `#D4A574` (warm tan/coral)
- Primary Blue: `#3949AB` (navy blue)
- Primary Pink: `#E91E8C` (hot pink)
- Light Background: `#F5E6D3` (cream)
- Success Green: `#4CAF50`
- Error Red: `#E57373`
- White: `#FFFFFF`

## 🔄 Navigation Flow

### Host Flow
```
WelcomeScreen → HomeScreen → HostStartScreen
    ↓
PinShareScreen / QRShareScreen (for sharing)
    ↓
GameCardScreen → DecisionScreen → VotingResultsScreen
    ↓
(Next card or end game)
```

### Participant Flow
```
JoinPinScreen / QRScannerScreen
    ↓
(Join game - wait for host)
    ↓
GameCardScreen → DecisionScreen
    ↓
(Wait for results from host)
```

## 🔌 Backend Integration Points

The app is structured to easily integrate with a backend. Key integration points:

### GameProvider Methods (providers/game_provider.dart)
- `createGame()` - Creates a game session (TODO: Call backend API)
- `joinGame()` - Joins a game session (TODO: Validate PIN with backend)
- `submitChoice()` - Submits player's choice (TODO: Send to backend)
- `nextCard()` - Moves to next card (TODO: Sync with backend)

### Suggested Backend API Endpoints
```
POST   /api/games              # Create new game
POST   /api/games/:id/join     # Join game with PIN
GET    /api/games/:id          # Get game state
POST   /api/games/:id/vote     # Submit vote
POST   /api/games/:id/next     # Move to next card (host only)
GET    /api/stories/:id        # Get story content
```

### WebSocket Events (for real-time)
```
player_joined    # New player joined
vote_submitted   # Player voted
all_voted        # All players have voted
card_changed     # Host moved to next card
game_started     # Host started the game
```

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk
  provider: ^6.0.5          # State management
  qr_flutter: ^4.1.0        # Generate QR codes
  mobile_scanner: ^3.5.2    # Scan QR codes
```

## 🎮 Game Content Structure

Stories are defined in `lib/data/game_data.dart`. Each story contains:

- **GameStory**: Overall story metadata
- **GameCard[]**: Sequence of cards with:
  - `CardType.intro` - Introduction/narrative cards
  - `CardType.decision` - Choice points
  - `CardType.outcome` - Results of choices
  - `CardType.question` - Reflection questions

### Adding New Stories

1. Create story data in `game_data.dart`
2. Define all cards with proper navigation
3. Add to story list in `HomeScreen`

## 🛠️ Development Notes

### Current Implementation
- ✅ All UI screens complete
- ✅ Navigation flow working
- ✅ QR code generation and scanning
- ✅ Local state management with Provider
- ✅ Voting and results system
- ✅ Skatepark story content

### TODO for Backend Integration
- [ ] Replace local state with API calls
- [ ] Implement WebSocket for real-time updates
- [ ] Add authentication system
- [ ] Implement game session persistence
- [ ] Add error handling and retry logic
- [ ] Implement proper loading states
- [ ] Add offline support

### Additional Features to Consider
- [ ] Sound effects and music
- [ ] Animations between cards
- [ ] Player avatars
- [ ] Chat system during gameplay
- [ ] Leaderboard
- [ ] Multiple stories/scenarios
- [ ] Admin panel for creating stories
- [ ] Analytics and insights

## 🌐 Platform Support

- ✅ iOS
- ✅ Android
- ⚠️ Web (QR scanning requires native camera)

## 📱 Testing

```bash
# Run tests
flutter test

# Run on iOS simulator
flutter run -d iPhone

# Run on Android emulator
flutter run -d emulator

# Build release
flutter build apk          # Android
flutter build ios          # iOS
```

## 🤝 Contributing

The app structure is modular and ready for team development:
- Each screen is a separate file
- Models are clearly defined
- Provider pattern for state management
- Easy to add new stories and cards

## 📄 License

[Your License Here]

## 👥 Credits

Built for Sociality - Social Work Learning Platform
Tweekracht Sociality 🎯
