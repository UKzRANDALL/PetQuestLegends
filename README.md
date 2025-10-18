# Pet Quest Legends - Roblox Game

A complete pet collection and adventure game for Roblox with hatching, merging, quests, guilds, and trading systems.

## Features

- **Pet System**: Hatch, collect, and merge 100+ unique pets
- **Multiple Worlds**: 6 unique worlds to explore with progression
- **Quest System**: Daily quests, world quests, and achievements
- **Guild System**: Create guilds, contribute, and unlock exclusive rewards
- **Trading System**: Safe pet trading with anti-scam protection
- **Monetization**: Gamepasses, premium eggs, and boosts
- **Events**: Regular updates with limited-time content

## Project Structure

```
pet-quest-legends/
├── src/
│   ├── client/          # Client-side scripts
│   │   ├── Controllers/ # UI and game controllers
│   │   └── UI/          # UI components
│   ├── server/          # Server-side scripts
│   │   ├── Services/    # Game systems
│   │   └── Data/        # Data management
│   ├── shared/          # Shared modules
│   │   ├── Config/      # Game configuration
│   │   ├── Modules/     # Shared utilities
│   │   └── Remotes/     # Remote events/functions
│   └── workspace/       # Workspace objects
├── default.project.json # Rojo configuration
└── README.md
```

## Setup Instructions

### Prerequisites

1. Install [Rojo](https://rojo.space/) (v7.0+)
2. Install [Roblox Studio](https://www.roblox.com/create)

### Installation

1. Clone or download this project
2. Open terminal in project directory
3. Run Rojo:
   ```bash
   rojo serve
   ```
4. Open Roblox Studio
5. Install Rojo plugin from [here](https://www.roblox.com/library/13916111004/Rojo-7)
6. Click "Connect" in the Rojo plugin
7. Click "Sync In" to sync the project

### Development Workflow

1. Make changes to files in `src/` directory
2. Rojo will automatically sync changes to Studio
3. Test in Studio
4. Publish to Roblox when ready

## Configuration

### Pet Configuration
Edit `src/shared/Config/PetConfig.lua` to add/modify pets

### World Configuration
Edit `src/shared/Config/WorldConfig.lua` to add/modify worlds

### Quest Configuration
Edit `src/shared/Config/QuestConfig.lua` to add/modify quests

### Gamepass Configuration
Edit `src/shared/Config/GamepassConfig.lua` to configure gamepasses

## Key Systems

### Data System
- Uses ProfileService for reliable data management
- Auto-saves every 5 minutes
- Session locking prevents data loss

### Pet System
- 5 rarity tiers: Common, Rare, Epic, Legendary, Mythical
- Merge system: Combine 2 identical pets for stronger version
- Pet abilities: Fire, Flying, Ice, Shadow types
- Visual effects based on rarity

### Trading System
- Built-in value calculator
- Trade confirmation system
- Anti-scam protection
- Trade history logging

### Guild System
- Up to 50 members per guild
- Contribution system
- Guild-exclusive pets
- Guild leaderboards

## Monetization

### Gamepasses
- VIP Access
- 2x Hatch Speed
- 3x Coins
- Auto-Hatch
- Extra Pet Slots
- Fast Travel

### Premium Eggs (Robux)
- Galaxy Egg
- Rainbow Egg
- Shadow Egg
- Limited Event Eggs

### Boosts (Robux)
- 2x Coins (1 hour)
- 2x Luck (1 hour)
- 2x Hatch Speed (1 hour)

## Update Schedule

- New pets: Weekly
- New worlds: Every 2-3 weeks
- Events: Every weekend
- Major updates: Quarterly

## Support

For issues or questions, please contact the development team.

## License

All rights reserved. This is proprietary game code.