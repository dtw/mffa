# MakeFishingFunAgain
 The opposite of a fishing bot.

## What is it?
 This is not a fishing bot. MakeFishingFunAgain simply removes the tedious aspects of fishing in FFXI.

 The addon can release items, monsters and big fish (!!!), then recast automatically.

 Any fish you want to land, you do that yourself by playing the minigame.

 For the sake of appearances, a random delay is added to cast and release actions. This can be disabled.

 Automatic recasting can be disabled. The release functions will still work.

 This addon does inject packets. It's the packet that cancels fishing.

## Commands
 When typing commands don't use "[ ]" or "|".
```
//mffa [start|stop] - Starts and stops the addon
//mffa recast       - toggle auto-recast (on by default)
//mffa showrecast   - toggle recast messages (on by default)
//mffa random       - toggle action delays (on by default)
```
## Defaults
  The following are 'on' by default:
  * Release items
  * Release monsters
  * Automatic recast
  * Recast messages
  * Use random cast/release delays

## FAQ

###### How is this the opposite of a fishing bot?
A fishing bot catches fish. This addon lets fish go.

###### Can I AFK while running this addon?
Yes, but you won't catch any fish.

###### What doesn't it do
Manage any inventory, check for bait, check you have a rod. None of that stuff.

In fact, it won't even start fishing. You have to start.

###### Really?
Yes. However, since it will try to cast automatically (once you have started) anything that would stop you fishing does stop the addon.
