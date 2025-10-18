# Pet Quest Legends - Quick Start Guide

Get your game up and running in 5 minutes!

## Prerequisites

- [Roblox Studio](https://www.roblox.com/create) installed
- [Rojo 7.0+](https://rojo.space/) installed
- Basic understanding of Roblox Studio

## Quick Setup (5 Minutes)

### Step 1: Start Rojo (1 minute)

Open terminal in the project folder and run:
```bash
rojo serve
```

Leave this terminal window open.

### Step 2: Connect Roblox Studio (2 minutes)

1. Open Roblox Studio
2. Install the Rojo plugin from [here](https://www.roblox.com/library/13916111004/Rojo-7) if you haven't
3. In Studio, click the Rojo plugin button
4. Click "Connect" (should connect to localhost:34872)
5. Click "Sync In" to load the project

### Step 3: Test the Game (2 minutes)

1. Click the "Play" button in Studio
2. You should spawn in the Starter Forest
3. Walk around to collect coins automatically
4. Click the UI buttons at the bottom to explore features

## What You Should See

✅ **Working Features:**
- Coins spawning and being collected automatically
- Main HUD showing coins and level
- Bottom navigation buttons (Pets, Hatch, Quests, Shop, Guild)
- Notification system
- Basic world environment

⚠️ **Placeholder Features:**
- UI buttons show "coming soon" notifications
- Pet models are simple colored spheres
- Some advanced features need configuration

## Next Steps

### For Testing
1. Read [README.md](README.md) for full setup
2. Test with 2+ players (Test > Players > 2)
3. Try the core features

### For Development
1. Read [CONFIGURATION_GUIDE.md](CONFIGURATION_GUIDE.md) to customize
2. Add your own pet models
3. Implement full UI screens
4. Add custom assets (icons, sounds, etc.)

### For Deployment
1. Read [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
2. Install real ProfileService
3. Configure gamepass IDs
4. Test thoroughly
5. Publish to Roblox

## Common Issues

### "Failed to connect to Rojo"
- Make sure `rojo serve` is running
- Check the port (default: 34872)
- Restart Rojo and try again

### "No coins spawning"
- Check the Output window for errors
- Make sure server scripts are running
- Verify CoinService initialized

### "UI not showing"
- Check PlayerGui for the ScreenGui
- Look for errors in client console
- Verify UIController initialized

### "Can't collect coins"
- Make sure you're within 10 studs of coins
- Check RemoteEvents are connected
- Verify CoinController is running

## File Structure Overview

```
pet-quest-legends/
├── src/
│   ├── client/          # Client-side code
│   │   ├── Controllers/ # Game logic controllers
│   │   └── init.client.lua
│   ├── server/          # Server-side code
│   │   ├── Services/    # Game systems
│   │   └── init.server.lua
│   ├── shared/          # Shared code
│   │   ├── Config/      # Game configuration
│   │   └── Modules/     # Utility modules
│   └── workspace/       # World setup
├── default.project.json # Rojo configuration
└── README.md           # Full documentation
```

## Key Files to Edit

### Add Pets
`src/shared/Config/PetConfig.lua`

### Add Worlds
`src/shared/Config/WorldConfig.lua`

### Add Quests
`src/shared/Config/QuestConfig.lua`

### Configure Gamepasses
`src/shared/Config/GamepassConfig.lua`

### Modify UI
`src/client/Controllers/UIController.lua`

## Testing Checklist

- [ ] Game loads without errors
- [ ] Coins spawn and can be collected
- [ ] UI displays correctly
- [ ] Navigation buttons work
- [ ] Notifications appear
- [ ] Multiple players can join
- [ ] Data saves (check Output for save messages)

## Getting Help

1. Check the [README.md](README.md) for detailed info
2. Review code comments in the files
3. Check Roblox DevForum for Rojo help
4. Review configuration guides

## What's Next?

Now that you have the basic game running:

1. **Customize Content**
   - Add your own pets
   - Create custom worlds
   - Design unique quests

2. **Improve Visuals**
   - Replace placeholder pet models
   - Add custom UI designs
   - Create world decorations

3. **Add Features**
   - Implement full UI screens
   - Add sound effects
   - Create animations

4. **Prepare for Launch**
   - Set up gamepasses
   - Configure monetization
   - Test thoroughly
   - Market your game

## Pro Tips

💡 **Development Tips:**
- Save your Studio place regularly
- Test with multiple players often
- Use the Output window to debug
- Keep Rojo running while developing

💡 **Configuration Tips:**
- Start with small changes
- Test each change immediately
- Balance for fun, not grind
- Listen to player feedback

💡 **Performance Tips:**
- Monitor memory usage
- Limit particle effects
- Use object pooling
- Optimize scripts

---

**Ready to create an amazing pet collection game? Let's go! 🚀**

For detailed documentation, see:
- [README.md](README.md) - Complete setup guide
- [CONFIGURATION_GUIDE.md](CONFIGURATION_GUIDE.md) - Customization guide
- [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Publishing guide