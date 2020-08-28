# KisiwaDesertScript
A Catch/Release Script for the Kisiwa Desert with a lot of Features

##### Main Features:
- [x] 3 different movements available
- [x] 3 Luma Options available
- [x] Vullfy detection for survivability
- [x] automatic Temcard and Smoke Bomb Rebuy and TemTem Heal when almost out of cards or too many dead Tems in team
- [x] Fast Teleport to Temporium with Smoke Bombs when using "safe" Movements
- [x] Safety Running Away when it takes too much rounds to catch and release or the bot gets confused when lags happen

##### To-Do:
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

## LUA Settings
You have the option to change a few Settings inside the LUA. These are found directly on top of the script:

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

##### Your VM Name or Number
   - This is only for Telegram notification if you have multiple VM's to know which VM found a Luma
   - Set the Name your VM is called, needs to be inside the "", for example `vm = "TemBot VM Nr 3"`

## How-To

##### 1. Download the Script
   You can Download the latest release [here](https://github.com/Muchacho13Scripts/KisiwaDesertScript/releases)
   
   Click on 'Assets' and download the LUA file

##### 2. Start TemBot

##### 3. Edit your Settings in 'Main Settings' and 'Misc Settings'
   Check these Screenshots:

##### 4. Load up the LUA Script
   Click on 'Load File' and open the downloaded LUA File

##### 5. Change Settings in LUA Script to your liking
   Check 'User Settings' in this ReadMe for more information
   
   You may have to scroll down a bit to see all Settings
   
##### 6. Start TemTem and move in front of Kisiwa Desert Shop
   Start here:
   
##### 7. Start the Script 
   Default Button to start is 'F3'
   
   Stop the Script with 'F2'

## Changelog

##### V1 - Initial GitHub Release

## Donations
If you like my work you can consider a small donation for a beer [here](https://www.paypal.me/scriptchacho)


## Bug Reporting
If you find any bugs report them here (I still need to figure out how GitHub works) or send a message on Discord: Muchacho13#0901

## Special Thanks
- NhMarco for creating TemBot and making it possible to create LUA-Scripts
- Mae for awesome Movement, Vullfy detection and help making these scripts. Mae's Github: https://github.com/MaeBot
- Slagathor for help with PixelDetection. Slagathor's Github: https://github.com/tyboe2013
- The whole TemBot Team and the TemBot Community!
