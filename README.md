# KisiwaDesertScript
A Catch/Release Script for the Kisiwa Desert with a lot of Features

##### Main Features:
- [x] 3 different movements available
- [x] different Luma Options available
- [x] Vullfy detection for survivability
- [x] automatic Temcard and Smoke Bomb Rebuy and TemTem Heal when almost out of cards or too many dead Tems in team
- [x] Fast Teleport to Temporium with Smoke Bombs when using "safe" Movements
- [x] Safety Running Away when it takes too much rounds to catch and release or the bot gets confused when lags happen

##### ToDo:
- [ ] Bug Fixes
- [ ] more Lua Options
- [ ] Update Movements
- [ ] Cleaner Scripting
- [ ] More customization Options (Custom Sleep and Waiting Times and more)
- [ ] Telegram message when the script stops (because of error or something)
- [ ] you tell me what to add...

## Preparation and Requirements
##### Mandatory:
- 2 Wiplumps with Cold Breeze
- Text Speed to 'Instant' in Game Settings

##### Recommended:
- 5 max lvl Wiplumps with Cold Breeze
- 1 tanky max lvl TemTem
- 99 TemCards
- at least 10 Smoke Bombs
- quite a few Pansuns to rebuy Smoke Bombs and Temcards

##### Optional:
- 99 Smoke Bombs
- Gear 'Decoy', 'Four-Leaf Clover', 'Baton Pass', 'Hopeless Tonic' and 'DoubleScreen'

## User Settings
You have the option to change a few Settings. These are found directly on top of the script:

##### Movement Options
   1. Up/Down - Unsafe Movement but does not require Smoke Bombs for Rebuy and Heal
   2. Curved Movement - Does a curve when changing directions
   3. Maevement - A Mix between Random, Circle and Curved Movements
   
##### Luma Options
   1. Wait on Luma - Stops the script and waits for User input
   2. Disconnect on Luma - Stops the script and closes the game
   
##### Number of Wiplumps
   - You have to change the number according to the wiplumps you have in your team
   - This is needed so the script knows when to return to heal
   - min 2, max 5
   
##### Amount of TemCards before going to rebuy
   - obvious, set the amount of TemCards thrown before refill at Temporium
   - min 1, max 99

##### Your VM Name or Number
   - This is only for Telegram notification if you have multiple VM's to know which VM found a Luma
   - Set the Name your VM is called, needs to be inside the "", for example `vm = "TemBot VM Nr 3"`


## How-To

## Changelog

## Donations
If you like my work you can consider a small donation for a beer [here](https://www.paypal.me/scriptchacho)

## Special Thanks
- NhMarco for creating TemBot and making it possible to create LUA-Scripts
- Mae for awesome Movement and help making these scripts. Mae's Github: https://github.com/MaeBot
- Slagathor for help with PixelDetection. Slagathor's Github: https://github.com/tyboe2013
- The whole TemBot Team and the Community!
