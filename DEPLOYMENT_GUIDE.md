# Pet Quest Legends - Deployment Guide

## Prerequisites

Before deploying, ensure you have:
1. Roblox Studio installed
2. Rojo 7.0+ installed
3. A Roblox account with game creation permissions
4. ProfileService module (for production)

## Step 1: Install ProfileService

For production, you need to replace the mock ProfileService with the real one:

1. Get ProfileService from: https://github.com/MadStudioRoblox/ProfileService
2. Place the ProfileService ModuleScript in `ServerScriptService`
3. Update the require path in `src/server/Services/DataService.lua`:
   ```lua
   -- Change from:
   local ProfileService = require(script.Parent.ProfileServiceMock)
   -- To:
   local ProfileService = require(game:GetService("ServerScriptService").ProfileService)
   ```

## Step 2: Configure Game Settings

### Update Gamepass IDs

Edit `src/shared/Config/GamepassConfig.lua` and replace all gamepass IDs:

```lua
VIP = {
    Id = YOUR_VIP_GAMEPASS_ID,
    -- ...
},
HatchSpeed2x = {
    Id = YOUR_HATCH_SPEED_GAMEPASS_ID,
    -- ...
},
-- etc.
```

To create gamepasses:
1. Go to Roblox Creator Dashboard
2. Select your game
3. Go to "Monetization" > "Passes"
4. Create each gamepass and note the IDs

### Update Product IDs

Edit `src/shared/Config/GamepassConfig.lua` and add product IDs for developer products:

```lua
PremiumEggs = {
    GalaxyEgg = {
        ProductId = YOUR_GALAXY_EGG_PRODUCT_ID,
        -- ...
    },
    -- etc.
}
```

To create developer products:
1. Go to Creator Dashboard > Monetization > Developer Products
2. Create each product
3. Note the product IDs

### Update Asset IDs

Replace placeholder asset IDs with your own:
- Pet models (create or use free models)
- UI icons
- Sound effects
- Particle textures

## Step 3: Sync with Rojo

1. Open terminal in project directory
2. Run: `rojo serve`
3. Open Roblox Studio
4. Install Rojo plugin if not already installed
5. Click "Connect" in Rojo plugin
6. Click "Sync In"

## Step 4: Configure Game Settings in Studio

### Game Settings
1. Go to Home > Game Settings
2. Set game name: "Pet Quest Legends"
3. Set description (use the short description from game description)
4. Set genre: "Adventure"
5. Add tags: "Pets", "Collection", "Trading", "RPG"

### Permissions
1. Enable Studio Access to API Services
2. Enable Third Party Sales (for gamepasses)
3. Enable Third Party Teleports (if needed)

### Security
1. Enable FilteringEnabled (should be on by default)
2. Review all RemoteEvents/Functions for security
3. Test anti-exploit measures

## Step 5: Test Thoroughly

### Local Testing
1. Test in Studio with multiple players (use "Test" > "Players" > 2+)
2. Test all core features:
   - Egg hatching
   - Pet merging
   - Coin collection
   - Trading
   - Guilds
   - Quests
   - World unlocking

### Test Checklist
- [ ] Data saves and loads correctly
- [ ] Coins are collected properly
- [ ] Pets hatch with correct rarities
- [ ] Pet merging works correctly
- [ ] Trading system prevents exploits
- [ ] Guild system functions properly
- [ ] Quests track progress correctly
- [ ] UI displays correctly on all screen sizes
- [ ] No memory leaks (check with Developer Console)
- [ ] Performance is acceptable (60 FPS target)

## Step 6: Publish to Roblox

### First Time Publishing
1. File > Publish to Roblox
2. Choose "Create New Game"
3. Set game name and description
4. Choose appropriate settings
5. Click "Create"

### Updating Existing Game
1. File > Publish to Roblox
2. Select your game
3. Click "Save"

## Step 7: Configure Game on Website

### Game Page
1. Go to Creator Dashboard
2. Select your game
3. Upload thumbnails (1920x1080 recommended)
4. Upload icon (512x512 recommended)
5. Add detailed description
6. Set up social links

### Monetization
1. Set up all gamepasses with proper pricing
2. Set up all developer products
3. Test purchases in a private server first

### Access
1. Start with "Private" for initial testing
2. Move to "Friends" for beta testing
3. Finally set to "Public" for launch

## Step 8: Post-Launch Monitoring

### Monitor These Metrics
- Player retention (Day 1, Day 7, Day 30)
- Average session length
- Monetization rate
- Bug reports
- Performance issues

### Regular Updates
- Add new pets weekly (as planned)
- Add new worlds every 2-3 weeks
- Run weekend events
- Fix bugs promptly
- Listen to player feedback

## Step 9: Optimization Tips

### Performance
- Use object pooling for coins
- Limit particle effects on low-end devices
- Use LOD (Level of Detail) for distant objects
- Optimize pet models (keep poly count low)

### Data Management
- Monitor DataStore usage
- Implement data migration if needed
- Keep backups of player data structure
- Test data wipes in development

### Anti-Exploit
- Validate all client inputs on server
- Use sanity checks for coin amounts
- Rate limit remote calls
- Monitor for suspicious activity

## Step 10: Marketing

### Pre-Launch
- Create social media accounts
- Build a community on Discord
- Create teaser content
- Reach out to Roblox YouTubers

### Launch
- Announce on social media
- Run ads on Roblox (if budget allows)
- Engage with community
- Respond to feedback

### Post-Launch
- Regular content updates
- Community events
- Seasonal updates
- Collaborate with other developers

## Troubleshooting

### Common Issues

**Issue: Data not saving**
- Check ProfileService is properly installed
- Verify DataStore API is enabled
- Check for errors in output

**Issue: Pets not displaying**
- Verify pet models are created correctly
- Check PetDisplayController is running
- Look for errors in client console

**Issue: Coins not collecting**
- Verify CoinService is running
- Check RemoteEvents are connected
- Test collection range

**Issue: UI not showing**
- Check ScreenGui is in PlayerGui
- Verify UIController initialized
- Check for script errors

**Issue: Trading not working**
- Verify both players are in same server
- Check TradingService is initialized
- Test with simple trades first

## Support

For issues or questions:
1. Check the README.md
2. Review code comments
3. Check Roblox DevForum
4. Contact development team

## Version Control

Remember to:
- Commit changes regularly
- Tag releases (v1.0, v1.1, etc.)
- Document changes in changelog
- Keep development and production branches

## Legal

Ensure you have:
- Terms of Service
- Privacy Policy
- Age-appropriate content
- Compliance with Roblox ToS

---

Good luck with your game launch! 🎮🚀