-----------------------Kisiwa Desert Catch& Release Script-------------------------------
-- Be sure to check out the readme: http://bit.ly/KisiwaReadme
-------------------------------User Settings---------------------------------------------
--Movement Options
--1 - Up/Down - Unsafe Movement but does not require Smoke Bombs for Rebuy and Heal
--2 - Curved Movement - Does a curve when changing directions
--3 - Maevement - A Mix between Random, Circle and Curved Movements
movement = 3
--------------
--Luma Options
--1 - Wait on Luma
--2 - Disconnect On Luma
--3 - Only Cards on Luma
LumaOption = 1
--------------
-- Number of Wiplumps
wiplumps = 2
--------------
-- Your VM Name or Number
vm = "Your VM Name"


























----------------------------------------------------------------------------------------------------
-----------------Do Not Change if you don't know what you are doing!!!------------------------------
----------------------------------Attributes--------------------------------------------------------
import ('TemBot.Lua.TemBotLua')
usedcards 				= 0
dead 					= 0
MovementSwitch 			= 2
DeadBeforeRebuy 		= wiplumps - 2
TemcardsBeforeRebuy 	= tblua:GetRebuy()
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-------------------------------------Battle Functions-----------------------------------------------
----------------------------------------------------------------------------------------------------

function MainBattle(luma, nr) -- Main Battle Function
	if tblua:CheckLuma() == true then
		return LumaSetting(luma, nr)
	end
	Exhausted()
	local enemycount = CheckNumberOfEnemies()
	if enemycount == 1 then
		return SingleEncounterBattle()
	else
		return DoubleEncounterBattle()
	end
end

function SingleEncounterBattle() -- sequences for single encounter
	local antistuck = 0
	local turn = 1
	local cards = 0
	local deadtem = 0
	while tblua:IsInWorld() == false
	do
		if deadtem > 0 and tblua:IsInFight() then
			runningaway()
		elseif turn == 1 and tblua:IsInFight() == true then
			SimpleAttack()
			turn = turn + 1
			antistuck = 0
		elseif turn == 2 and tblua:IsInFight() == true then
			cards = cards + SoloEncounterFirstCatch(cards)
			turn = turn + 1
			antistuck = 0
		elseif turn < 6 and tblua:IsInFight() == true then
			cards = cards + SoloEncounterSecondCatch(cards)
			turn = turn + 1
			antistuck = 0
		elseif turn == 6 and tblua:IsInFight() == true then
			runningaway()
		else
			ReleaseTem()
			SkipExpSkill()
			deadtem = deadtem + SwapDeadTem()
			antistuck = CheckAntiStuck(antistuck)
		end
	end
	return cards, deadtem
end

function DoubleEncounterBattle() -- sequences for double encounters
	local antistuck = 0
	local turn = 1
	local cards = 0
	local deadtem = 0
	local vullfy = CheckDoubleVullfy()
	if vullfy == 3 then
		runningaway()
	else	
		while tblua:IsInWorld() == false
		do
			if deadtem > 0 and tblua:IsInFight() then
				runningaway()
			elseif turn == 1 and tblua:IsInFight() == true then
				if vullfy == 2 then
					SwitchAttack()
				else
					SimpleAttack()
				end
				turn = turn + 1
				antistuck = 0
			elseif turn == 2 and tblua:IsInFight() == true then
				SwitchAttack()
				turn = turn + 1
				antistuck = 0
			elseif turn == 3 and tblua:IsInFight() == true then
				cards = cards + DoubleEncounterFirstCatch(cards)
				turn = turn + 1
				antistuck = 0
			elseif turn < 7 and tblua:IsInFight() == true then
				if CheckNumberOfEnemies() == 2 then
					cards = cards + DoubleEncounterSecondCatchTem(cards)
				else
					cards = cards + SoloEncounterSecondCatch(cards)
				end
				turn = turn + 1
				antistuck = 0
			elseif turn == 7 and tblua:IsInFight() == true then
				runningaway()
			else
				ReleaseTem()
				SkipExpSkill()
				deadtem = deadtem + SwapDeadTem()
				antistuck = CheckAntiStuck(antistuck)
			end
		end
	end
	return cards, deadtem
end

function runningaway() -- simple runaway function
	-- runaway sequence
		while tblua:IsInWorld() == false
        do
            if tblua:IsInFight() == true then
                local RandomRunz = math.random(330, 694)
                tblua:Sleep(RandomRunz)
                tblua:PressKey(0x38)
            else
                local RandomSleepzzz = math.random(455, 694)
                tblua:Sleep(RandomSleepzzz)
			end
        end 
end

function Exhausted() -- skip turn when exhausted
	if tblua:GetPixelColor(276, 631) == "0xFFFFFF" then
		local sleepy = math.random(74, 132)
		tblua:Sleep(sleepy)
		tblua:PressKey(0x36)
		tblua:Sleep(sleepy)
		tblua:Sleep(sleepy)
		tblua:PressKey(0x36)
		tblua:Sleep(sleepy)
	end
end

function CheckNumberOfEnemies() -- checks the number of targets
    if tblua:GetPixelColor(1045, 100) == "0x1E1E1E" then
        if tblua:GetPixelColor(777, 65) == "0x1E1E1E" then
			return 2
		else
			return 1
		end
	end
end

function CheckDoubleVullfy() -- check if there are multiple vullfys
    if tblua:GetPixelColor(832, 36) == "0xFFFFFF" and tblua:GetPixelColor(1097, 72) == "0xFFFFFF" then
		return 3 --double vullfy
	elseif tblua:GetPixelColor(832, 36) == "0xFFFFFF" then
		return 2 --vullfy is left
	elseif tblua:GetPixelColor(1097, 72) == "0xFFFFFF" then
		return 1 --vullfy is right
	else
		return 0
	end
end

function DoubleEncounterFirstCatch(cards) -- Slower Catch for First Catch Round (DOUBLE Encounter)
    tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x37)
    tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x45)
    tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x46)
    tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x26)
    tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x46)
    tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x37)
    tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x46)
    tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x46)
	tblua:Sleep(math.random(1820, 3594))
	cards = cards + 2
	return cards
end

function SoloEncounterFirstCatch(cards) -- Slower Catch for First Catch Round (SOLO Encounter)
    tblua:Sleep(math.random(666, 999))
	tblua:PressKey(0x37)
    tblua:Sleep(math.random(666, 999))
	tblua:PressKey(0x45)
    tblua:Sleep(math.random(666, 999))
	tblua:PressKey(0x46)
    tblua:Sleep(math.random(666, 999))
	tblua:PressKey(0x37)
    tblua:Sleep(math.random(666, 999))
	tblua:PressKey(0x46)
    tblua:Sleep(math.random(1820, 3594))
	cards = cards + 2
	return cards
end

function DoubleEncounterSecondCatchTem(cards) -- Faster Catch for Second Catch Round (DOUBLE Encounter)
    tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x37)
    tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x46)
    tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x46)
    tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x37)
    tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x46)
    tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x46)
    tblua:Sleep(math.random(1820, 3594))
	cards = cards + 2
	return cards
end

function SoloEncounterSecondCatch(cards) -- Faster Catch for Second Catch Round (SOLO Encounter)
    tblua:Sleep(math.random(666, 999))
	tblua:PressKey(0x37)
    tblua:Sleep(math.random(666, 999))
	tblua:PressKey(0x46)
    tblua:Sleep(math.random(666, 999))
	tblua:PressKey(0x37)
    tblua:Sleep(math.random(666, 999))
	tblua:PressKey(0x46)
    tblua:Sleep(math.random(1820, 3594))
	cards = cards + 2
	return cards
end

function SwitchAttack() -- First Attack used on other Tem
    tblua:Sleep(math.random(666, 999))
	tblua:PressKey(0x31)
    tblua:Sleep(math.random(666, 999))
	tblua:PressKey(0x26)
    tblua:Sleep(math.random(666, 999))
	tblua:PressKey(0x46)
    tblua:Sleep(math.random(666, 999))
	tblua:PressKey(0x31)
    tblua:Sleep(math.random(666, 999))
	tblua:PressKey(0x46)
	tblua:Sleep(math.random(1820, 3594))
end

function SimpleAttack() -- First Attack used on marked Tem
	tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x31)
	tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x46)
	tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x31)
	tblua:Sleep(math.random(666, 999))
    tblua:PressKey(0x46)
	tblua:Sleep(math.random(1820, 3594))
end

function ReleaseTem() -- Releasing the Tem
    if tblua:GetPixelColor(750, 530) == "0x1CD1D3" then
		tblua:Sleep(math.random(666, 999))
        tblua:PressKey(0x27)
        tblua:Sleep(math.random(666, 999))
        tblua:PressKey(0x46)
        tblua:Sleep(math.random(666, 999))
        tblua:PressKey(0x46)
        tblua:Sleep(math.random(1820, 3594))
	end
end

function KeepTem() -- Releasing the Tem
    if tblua:GetPixelColor(750, 530) == "0x1CD1D3" then
		tblua:Sleep(math.random(666, 999))
        tblua:PressKey(0x46)
        tblua:Sleep(math.random(666, 999))
        tblua:PressKey(0x46)
        tblua:Sleep(math.random(666, 999))
        tblua:PressKey(0x46)
        tblua:Sleep(math.random(1820, 3594))
	end
end

function SkipExpSkill() -- Skips Exp Screen and new Attack Screen
	if tblua:GetPixelColor(215, 255) == "0x1CD1D3" then
		tblua:Sleep(math.random(666, 999))
		tblua:PressKey(0x1B)
		tblua:Sleep(math.random(1820, 3594))
	end
	
	if tblua:GetPixelColor(590, 245) == "0x1CD1D3" then
		tblua:Sleep(math.random(666, 999))
		tblua:PressKey(0x1B)
		tblua:Sleep(math.random(1820, 3594))
	end
end

function SwapDeadTem() -- Swap Tem if dead
	if tblua:GetPixelColor(1180, 455) == "0x1E1E1E" then
		local tem = 3
		local count = 1
		while tblua:GetPixelColor(1180, 455) == "0x1E1E1E"
		do
			while count < tem
			do
				tblua:PressKey(0x28)
                tblua:Sleep(math.random(1320, 1594))
				count = count + 1
			end
			tblua:PressKey(0x46)
			tblua:Sleep(math.random(1320, 1594))
            tem = tem + 1
		end
		return 1
	else
		return 0
	end
end

function CheckAntiStuck(value) -- if nothing happens in fight because of lag, pressing escape to get back to menu and then flee
	if value > 100 then
		tblua:PressKey(0x1B)
		tblua:Sleep(math.random(1320, 1594))
		tblua:PressKey(0x1B)
		tblua:Sleep(math.random(1320, 1594))
		tblua:PressKey(0x1B)
		tblua:Sleep(math.random(1320, 1594))
		tblua:PressKey(0x1B)
		tblua:Sleep(math.random(1320, 1594))
		tblua:PressKey(0x1B)
		tblua:Sleep(math.random(1320, 1594))
		tblua:PressKey(0x1B)
		tblua:Sleep(math.random(1320, 1594))
		while tblua:IsInFight() == false
		do
			tblua:PressKey(0x1B)
			tblua:Sleep(math.random(1320, 1594))
		end
		local RandomRunz = math.random(330, 694)
        tblua:Sleep(RandomRunz)
        tblua:PressKey(0x38)
		local RandomRunz = math.random(330, 694)
        tblua:Sleep(RandomRunz)
        tblua:PressKey(0x38)
		local RandomRunz = math.random(330, 694)
        tblua:Sleep(RandomRunz)
        tblua:PressKey(0x38)
		local RandomRunz = math.random(330, 694)
        tblua:Sleep(RandomRunz)
        tblua:PressKey(0x38)
		value = 0
	else
	tblua:Sleep(math.random(1320, 1594))
	value = value + 1
	return value
	end	

end

----------------------------------------------------------------------------------------------------
--------------------------------------Luma Functions------------------------------------------------
----------------------------------------------------------------------------------------------------

function LumaSetting(option, nr) -- Checks the Luma Option chosen
	if tblua:CheckLuma() == true then
		if option == 1 then
			WaitForLuma(nr)
		elseif option == 2 then
			DisconnectOnLuma(nr)
		elseif option == 3 then
			return CardsOnLuma(vmnr)
		else
			WaitForLuma(nr)
		end
	end
end

function WaitForLuma(vmnr) -- Waiting for Luma Option
	tblua:SendTelegramMessage(vmnr, "Luma Found! Waiting...")
	tblua:TestMessage("Luma Found! Waiting...")
	tblua:PressKey(0x71)
end

function DisconnectOnLuma(vmnr)
	tblua:SendTelegramMessage(vmnr, "Luma Found! Disconnecting...")
    local RandomDC = math.random(1548, 3110)
	tblua:Sleep(RandomDC)
	tblua:PressKey(0x1B)
	tblua:Sleep(RandomDC)
	tblua:PressKey(0x28)
	tblua:Sleep(RandomDC)
	tblua:PressKey(0x28)
	tblua:Sleep(RandomDC)
	tblua:PressKey(0x46)
	tblua:Sleep(RandomDC)
	tblua:PressKey(0x46)
	tblua:Sleep(RandomDC)
	tblua:PressKey(0x71)
end

function CardsOnLuma(vmnr)
	tblua:SendTelegramMessage(vmnr, "Luma Found! Start throwing Cards")
	if CheckNumberOfEnemies() == 1 then
		return LumaSingleEncounterCatch()
	else
		return LumaDoubleEncounterCatch()
	end

end

function LumaSingleEncounterCatch() -- sequences for single encounter
	local antistuck = 0
	local turn = 1
	local cards = 0
	local deadtem = 0
	while tblua:IsInWorld() == false
	do
		if turn == 1 and tblua:IsInFight() == true then
			cards = cards + SoloEncounterFirstCatch(cards)
			turn = turn + 1
			antistuck = 0
		elseif turn == 2 and tblua:IsInFight() == true then
			cards = cards + SoloEncounterSecondCatch(cards)
			antistuck = 0
		else
			KeepTem()
			SkipExpSkill()
			deadtem = deadtem + SwapDeadTem()
			antistuck = CheckAntiStuck(antistuck)
		end
	end
	return cards, deadtem
end

function LumaDoubleEncounterCatch() -- sequences for double encounter
	local antistuck = 0
	local turn = 1
	local cards = 0
	local deadtem = 0
	while tblua:IsInWorld() == false
	do
		if turn == 1 and tblua:IsInFight() == true then
			cards = cards + DoubleEncounterFirstCatch(cards)
			turn = turn + 1
			antistuck = 0
		elseif turn == 2 and tblua:IsInFight() == true then
			if CheckNumberOfEnemies() == 2 then
				cards = cards + DoubleEncounterSecondCatchTem(cards)
			else
				cards = cards + SoloEncounterSecondCatch(cards)
			end
			antistuck = 0
		else
			KeepTem()
			SkipExpSkill()
			deadtem = deadtem + SwapDeadTem()
			antistuck = CheckAntiStuck(antistuck)
		end
	end
	return cards, deadtem
end


----------------------------------------------------------------------------------------------------
-------------------------------------Movement Functions---------------------------------------------
----------------------------------------------------------------------------------------------------

function MainMovement(mov, switch)
    tblua:CheckPause()
    tblua:CheckLogout()
	if mov == 1 then		
		return movementupdown(switch)
	elseif mov == 2 then
		return movementcurved(switch)
	elseif mov == 3 then
		return movementmaevement(switch)
	end
end

function movementupdown(move) -- movement up/down function	
    if move == 1 then
        tblua:KeyDown(0x57)
        tblua:Sleep(tblua:GetTickrate()*math.random(99, 222))
        tblua:KeyUp(0x57)
        return 2
    else
        tblua:KeyDown(0x53)
        tblua:Sleep(tblua:GetTickrate()*math.random(99, 222))
        tblua:KeyUp(0x53)
        return 1
    end
end

function movementcurved(move) -- movement curved
    if move == 1 then
		tblua:CircleArea()
		tblua:Sleep(math.random(100, 300))
		return 2
    elseif move == 2 then
        tblua:RandomArea()
		tblua:Sleep(math.random(700, 1200))
		return 1
    else
        tblua:CircleArea()
		tblua:Sleep(math.random(100, 300))
		return 2
	end
end


function movementmaevement(move) -- movement random/circle/curved
    if move == 1 then
        tblua:CircleArea()
		return move
    elseif move == 2 then
		local changecurve = 1
		while tblua:IsInWorld() == true
		do
			if changecurve == 1 then
				tblua:CircleArea()
				tblua:Sleep(math.random(100, 300))
				changecurve = 2
			elseif changecurve == 2 then
				tblua:RandomArea()
				tblua:Sleep(math.random(700, 1200))
				changecurve = 1
			else
				tblua:CircleArea()
				tblua:Sleep(math.random(100, 300))
				changecurve = 2
				end
		end
		return move
    end
end


--------------------------------Rebuy and Heal Movement Functions---------------------------------
--------------------------------------------------------------------------------------------------
function CheckStartRebuy(mov)
    tblua:StopMovement()
	if mov == 1 then
		RunningToShop() -- running up to store when UP/DOWN Movement
		FromShopToHeal() -- running to heal station
		FromHealToShop() -- moving to shop
		BuyingCards() -- Talking to Shop and Buy
		MoveBackToArea()
	else
		TeleportToShop()
		FromShopToHeal() -- running to heal station
		FromHealToShop() -- moving to shop
		BuyingCardsAndBombs() -- Talking to Shop and Buy Cards and Smoke Bombs
		MoveBackToArea()
	end
	tblua:CheckPause()
	tblua:CheckLogout()
end

function RunningToShop()
--start running up
	tblua:Sleep(100)
	tblua:KeyDown(0x57)
    tblua:Sleep(10000)
    tblua:PressKey(0x57)
    tblua:Sleep(100)
	-- now checks if stuck in fight while running to shop
	while tblua:IsInWorld() == false
	do
		runningaway()
		tblua:Sleep(100)
		tblua:KeyDown(0x57)
		tblua:Sleep(10000)
		tblua:PressKey(0x57)
		tblua:Sleep(100)
    end
end

function TeleportToShop()
	tblua:Sleep(1500)
	tblua:PressKey(0x49)
	tblua:Sleep(1300)
	tblua:PressKey(0x45)
	tblua:Sleep(1250)
	while tblua:GetPixelColor(1013, 177) ~= "0xB1FEFF"
	do
		tblua:PressKey(0x53)
        tblua:Sleep(math.random(850, 1250))	
	end	
	tblua:Sleep(1000)
	tblua:PressKey(0x46)
	tblua:Sleep(1000)
	tblua:PressKey(0x46)
	tblua:Sleep(1000)
end

function FromShopToHeal()
	tblua:KeyDown(0x41) --move slightly left
    tblua:Sleep(250)
    tblua:PressKey(0x41)
	tblua:Sleep(100)
	tblua:KeyDown(0x41) -- move diagonal up/left to healing station
	tblua:Sleep(10)
	tblua:KeyDown(0x57)					
    tblua:Sleep(500)
    tblua:PressKey(0x41)
	tblua:Sleep(200) 
	tblua:PressKey(0x57)  -- stop pressing W last to look in the right direction
	tblua:Sleep(250)
	while tblua:IsInWorld() == false
	do
		runningaway()
		tblua:KeyDown(0x41) -- move diagonal up/left to healing station
		tblua:Sleep(10)
		tblua:KeyDown(0x57)					
		tblua:Sleep(500)
		tblua:PressKey(0x41)
		tblua:Sleep(200) 
		tblua:PressKey(0x57)  -- stop pressing W last to look in the right direction
		tblua:Sleep(250)
	end	
	tblua:PressKey(0x46) -- start healing and wait a random amount between 7,5s and 10s
	local RandomSleepForHealing = math.random(7500, 10000)
    tblua:Sleep(RandomSleepForHealing)
end

function FromHealToShop()
	tblua:KeyDown(0x44)	-- start moving to the right to seller				
    tblua:Sleep(500)
    tblua:PressKey(0x44)
	tblua:Sleep(500)
	while tblua:IsInWorld() == false
	do
		runningaway()
		tblua:KeyDown(0x44)					
		tblua:Sleep(500)
		tblua:PressKey(0x44)
		tblua:Sleep(500)	   
	end 

end

function BuyingCards()
    tblua:PressKey(0x46)
    tblua:Sleep(1000)
    tblua:PressKey(0x46)
    tblua:Sleep(1000)
    tblua:PressKey(0x53)
    tblua:Sleep(1000)
    tblua:PressKey(0x53)
    tblua:Sleep(1000)
    tblua:PressKey(0x46)
    tblua:Sleep(1000)
    if tblua:IsInWorld() == false then
		local clicks = 0
        while clicks < 10
		do --Buying TemCards
			tblua:PressKey(0x44)
			clicks = clicks + 1
            tblua:Sleep(math.random(150, 300))
        end
        tblua:PressKey(0x46)
        tblua:Sleep(2500)
        tblua:PressKey(0x1B)
        tblua:Sleep(1000)
	end
end	

function BuyingCardsAndBombs()
	local clicks = 0
    tblua:PressKey(0x46)
    tblua:Sleep(1000)
    tblua:PressKey(0x46)
    tblua:Sleep(1000)
	tblua:PressKey(0x46)
    tblua:Sleep(1000)
	while clicks < 2
	do --Buying SmokeBombs
		tblua:PressKey(0x44)
		clicks = clicks + 1
        tblua:Sleep(math.random(150, 300))
    end
	local clicks = 0
    tblua:PressKey(0x46)
    tblua:Sleep(2500)
    tblua:PressKey(0x53)
    tblua:Sleep(1000)
    tblua:PressKey(0x53)
    tblua:Sleep(1000)
    tblua:PressKey(0x46)
    tblua:Sleep(1000)
    while clicks < 10
	do --Buying TemCards
		tblua:PressKey(0x44)
		clicks = clicks + 1
        tblua:Sleep(math.random(150, 300))
    end
    tblua:PressKey(0x46)
    tblua:Sleep(2500)
    tblua:PressKey(0x1B)
    tblua:Sleep(1000)
end	

function MoveBackToArea()
	-- moving back in front of the seller
    tblua:KeyDown(0x53)
	tblua:Sleep(10)
	tblua:KeyDown(0x44)
    tblua:Sleep(250)
    tblua:PressKey(0x44)
	tblua:Sleep(10)
	tblua:PressKey(0x53)
    tblua:Sleep(450)
end
------------------------------------End of Rebuy and Heal Funtions------------------------------
------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------- Start of Script ------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Registering the Temtem Window
tblua:RegisterTemTemWindow()
tblua:GetAreaColor()
tblua:Sleep(1000)

if tblua:IsInWorld() == true then

	while(true)
	do
------------------------------Doing Movement Overworld Actions-----------------------------------
		while tblua:IsInWorld() == true 
		do
			if usedcards > TemcardsBeforeRebuy or dead > DeadBeforeRebuy then
				CheckStartRebuy(movement)
				usedcards = 0
				dead = 0
			else
				MovementSwitch = MainMovement(movement, MovementSwitch)  --Start Movement
			end
		end 
---------------------------- End of Doing Movement Overworld Actions-----------------------------

------------------------------------------Battle Scripts-----------------------------------------
		while tblua:IsInWorld() == false --loop if minimap not detected
		do
			tblua:StopMovement()            
			if tblua:IsInFight() == true then --if bot is in fight
				cardsout, deadout = MainBattle(LumaOption, vm)
				dead = dead + deadout
				usedcards = usedcards + cardsout
				MovementSwitch = math.random(2)
				tblua:Sleep(tblua:GetSleepTime())				
			end               
		end
	end
--------------------------------------------End Of Battle Scripts--------------------------------	
else
	MovementSwitch = 0
	tblua:TestMessage("Error: Not ready to start the script")
end

-------------------------------------------------------------------------------------------------

--------------------------------------------- Special Thanks! -----------------------------------
-- NhMarco for creating TemBot and making it possible to create LUA-Scripts
-- Mae for awesome Movement, Vullfy detection and help making these scripts. Mae's Github: https://github.com/MaeBot
-- Slagathor for help with PixelDetection. Slagathor's Github: https://github.com/tyboe2013
-- The whole TemBot Team and the TemBot Community!
