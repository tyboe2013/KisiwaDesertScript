-------------------Kisiwa Desert Catch& Release Script by Scriptchacho-------------------
------------- Be sure to check out the readme: https://bit.ly/KisiwaReadme --------------
-----------------------------------User Settings-----------------------------------------
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
LumaOption = 3
--------------
-- Number of Wiplumps
wiplumps = 4
--------------
-- Your VM Name or Number
vm = "Kisiwa Desert C/R"
--------------
-- Keep all Tems instead of releasing it( '1' for active)
keeptem = 0
--------------
-- Set your waiting speed for ALL Actions (100 = 100%)
-- Attention, if going too fast or too slow you will definetly break something
speed = 100
--------------
-- Telegram Notifications when Rebuying (1 is ON, 0 is OFF)
notifications = 1

























----------------------------------------------------------------------------------------------------
-----------------Do Not Change if you don't know what you are doing!!!------------------------------
----------------------------------Attributes--------------------------------------------------------
import ('TemBot.Lua.TemBotLua')
notificationcounter		= 0
enemycounter			= 0
usedcards 				= 0
dead 					= 0
stuckcounter			= 0
lumacounter 			= 0
deadwiplumps			= 0
MovementSwitch 			= 2
DeadBeforeRebuy 		= wiplumps - 2
modifier = 100 / speed
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-------------------------------------Battle Functions-----------------------------------------------
----------------------------------------------------------------------------------------------------

function MainBattle(luma, nr, keep1) -- Main Battle Function
	if tblua:CheckLuma() == true then
		return LumaSetting(luma, nr)
	end
	Exhausted()
	local enemycount = CheckNumberOfEnemies()
	enemycounter = enemycounter + enemycount
	if enemycount == 1 then
		return SingleEncounterBattle(keep1)
	else
		return DoubleEncounterBattle(keep1)
	end
end

function SingleEncounterBattle(keep2) -- sequences for single encounter
	local antistuck = 0
	local turn = 1
	local cards = 0
	local deadtem = 0
	while tblua:IsInWorld() == false
	do
		antistuck = CheckAntiStuck(antistuck)
		if deadtem > 0 and tblua:IsInFight() == true then
			runningaway()
		elseif turn == 1 and tblua:IsInFight() == true then
			SimpleAttack()
			turn = turn + 1
			antistuck = 0
		elseif turn < 6 and tblua:IsInFight() == true then
			cards, antistuck = SoloEncounterCatch()
			turn = turn + 1
		elseif turn == 6 and tblua:IsInFight() == true then
			runningaway()
		else
			if keep2 == 1 then
				KeepTem()
			else
				ReleaseTem()
			end
			SkipExpSkill()
			deadtem = deadtem + SwapDeadTem()
		end
	end
	return cards, deadtem
end

function DoubleEncounterBattle(keep2) -- sequences for double encounters
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
			if deadtem > 0 and tblua:IsInFight() == true then
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
				cards, antistuck = DoubleEncounterCatch()
				turn = turn + 1
			elseif turn < 7 and tblua:IsInFight() == true then
				if CheckNumberOfEnemies() == 2 then
					cards, antistuck = DoubleEncounterCatch()
				else
					cards, antistuck = SoloEncounterCatch()
				end
				turn = turn + 1
			elseif turn == 7 and tblua:IsInFight() == true then
				runningaway()
			else
				if keep2 == 1 then
					KeepTem()
				else
					ReleaseTem()
				end
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
                tblua:Sleep(modifier*RandomRunz)
                tblua:PressKey(0x38)
            else
                local RandomSleepzzz = math.random(455, 694)
                tblua:Sleep(modifier*RandomSleepzzz)
			end
        end 
end

function Exhausted() -- skip turn when exhausted
	if tblua:GetPixelColor(276, 631) == "0xFFFFFF" then
		local sleepy = math.random(74, 132)
		tblua:Sleep(modifier*sleepy)
		tblua:PressKey(0x36)
		tblua:Sleep(modifier*sleepy)
		tblua:Sleep(modifier*sleepy)
		tblua:PressKey(0x36)
		tblua:Sleep(modifier*sleepy)
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

function DoubleEncounterCatch() -- Slower Catch for First Catch Round (DOUBLE Encounter)
    tblua:Sleep(modifier*math.random(666, 999))
    tblua:PressKey(0x37)
	tblua:Sleep(modifier*math.random(666, 999))
	if tblua:GetPixelColor(558, 45) == "0x656565" and tblua:GetPixelColor(548, 22) == "0x656565" and tblua:GetPixelColor(544, 48) == "0x656565" then -- check grey Temcard in Tab
		local cardsempty = 1
		local activateantistuck = 500
		return cardsempty, activateantistuck
	end
	if tblua:GetPixelColor(192,133) ~= "0xFFFFFF" and tblua:GetPixelColor(207,141) ~= "0xFFFFFF" and tblua:GetPixelColor(218,137) ~= "0x1E1E1E" and tblua:GetPixelColor(233,139) ~= "0xE5E5E5" then -- check Temcard in first slot
		tblua:PressKey(0x45)
		tblua:Sleep(modifier*math.random(666, 999))	
		if tblua:GetPixelColor(398, 136) == "0x656565" and tblua:GetPixelColor(414, 220) == "0x387C7D" then -- check if only Saicards available
			local cardsempty = 1
			local activateantistuck = 500
			return cardsempty, activateantistuck    
		end
	end
	tblua:PressKey(0x46)
    tblua:Sleep(modifier*math.random(666, 999))
    tblua:PressKey(0x57)
    tblua:Sleep(modifier*math.random(666, 999))
    tblua:PressKey(0x46)
    tblua:Sleep(modifier*math.random(666, 999))
    tblua:PressKey(0x37)
    tblua:Sleep(modifier*math.random(666, 999))
	if tblua:GetPixelColor(558, 45) == "0x656565" and tblua:GetPixelColor(548, 22) == "0x656565" and tblua:GetPixelColor(544, 48) == "0x656565" then -- check grey Temcard in Tab
		local cardsempty = 1
		local activateantistuck = 500
		return cardsempty, activateantistuck
	end
    tblua:Sleep(modifier*math.random(366, 399))
	if tblua:GetPixelColor(192,133) ~= "0xFFFFFF" and tblua:GetPixelColor(207,141) ~= "0xFFFFFF" and tblua:GetPixelColor(218,137) ~= "0x1E1E1E" and tblua:GetPixelColor(233,139) ~= "0xE5E5E5" then -- check Temcard in first slot
		tblua:PressKey(0x45)
		tblua:Sleep(modifier*math.random(666, 999))	
		if tblua:GetPixelColor(398, 136) == "0x656565" and tblua:GetPixelColor(414, 220) == "0x387C7D" then -- check if only Saicards available
			local cardsempty = 1
			local activateantistuck = 500
			return cardsempty, activateantistuck    
		end
	end
    tblua:PressKey(0x46)
    tblua:Sleep(modifier*math.random(666, 999))
    tblua:PressKey(0x46)
	tblua:Sleep(modifier*math.random(1820, 3594))
	local cardsavailable = 0
	local notstuck = 0
	return cardsavailable, notstuck
end

function SoloEncounterCatch() -- Slower Catch for First Catch Round (SOLO Encounter)
    tblua:Sleep(modifier*math.random(666, 999))
	tblua:PressKey(0x37)
    tblua:Sleep(modifier*math.random(666, 999))
	if tblua:GetPixelColor(558, 45) == "0x656565" and tblua:GetPixelColor(548, 22) == "0x656565" and tblua:GetPixelColor(544, 48) == "0x656565" then -- check grey Temcard in Tab
		local cardsempty = 1
		local activateantistuck = 500
		return cardsempty, activateantistuck
	end
	if tblua:GetPixelColor(192,133) ~= "0xFFFFFF" and tblua:GetPixelColor(207,141) ~= "0xFFFFFF" and tblua:GetPixelColor(218,137) ~= "0x1E1E1E" and tblua:GetPixelColor(233,139) ~= "0xE5E5E5" then -- check Temcard in first slot
		tblua:PressKey(0x45)
		tblua:Sleep(modifier*math.random(666, 999))	
		if tblua:GetPixelColor(398, 136) == "0x656565" and tblua:GetPixelColor(414, 220) == "0x387C7D" then -- check if only Saicards available
			local cardsempty = 1
			local activateantistuck = 500
			return cardsempty, activateantistuck    
		end
	end
	tblua:PressKey(0x46)
    tblua:Sleep(modifier*math.random(666, 999))
	tblua:PressKey(0x37)
    tblua:Sleep(modifier*math.random(666, 999))
	if tblua:GetPixelColor(558, 45) == "0x656565" and tblua:GetPixelColor(548, 22) == "0x656565" and tblua:GetPixelColor(544, 48) == "0x656565" then -- check grey Temcard in Tab
		local cardsempty = 1
		local activateantistuck = 500
		return cardsempty, activateantistuck
	end
    tblua:Sleep(modifier*math.random(366, 399))
	if tblua:GetPixelColor(192,133) ~= "0xFFFFFF" and tblua:GetPixelColor(207,141) ~= "0xFFFFFF" and tblua:GetPixelColor(218,137) ~= "0x1E1E1E" and tblua:GetPixelColor(233,139) ~= "0xE5E5E5" then -- check Temcard in first slot
		tblua:PressKey(0x45)
		tblua:Sleep(modifier*math.random(666, 999))	
		if tblua:GetPixelColor(398, 136) == "0x656565" and tblua:GetPixelColor(414, 220) == "0x387C7D" then -- check if only Saicards available
			local cardsempty = 1
			local activateantistuck = 500
			return cardsempty, activateantistuck    
		end
	end
	tblua:PressKey(0x46)
    tblua:Sleep(modifier*math.random(1820, 3594))
	local cardsavailable = 0
	local notstuck = 0
	return cardsavailable, notstuck
end


function SwitchAttack() -- First Attack used on other Tem
    tblua:Sleep(modifier*math.random(666, 999))
	tblua:PressKey(0x31)
    tblua:Sleep(modifier*math.random(666, 999))
	tblua:PressKey(0x57)
    tblua:Sleep(modifier*math.random(666, 999))
	tblua:PressKey(0x46)
    tblua:Sleep(modifier*math.random(666, 999))
	tblua:PressKey(0x31)
    tblua:Sleep(modifier*math.random(666, 999))
	tblua:PressKey(0x46)
	tblua:Sleep(modifier*math.random(1820, 3594))
end

function SimpleAttack() -- First Attack used on marked Tem
	tblua:Sleep(modifier*math.random(666, 999))
    tblua:PressKey(0x31)
	tblua:Sleep(modifier*math.random(666, 999))
    tblua:PressKey(0x46)
	tblua:Sleep(modifier*math.random(666, 999))
    tblua:PressKey(0x31)
	tblua:Sleep(modifier*math.random(666, 999))
    tblua:PressKey(0x46)
	tblua:Sleep(modifier*math.random(1820, 3594))
end

function ReleaseTem() -- Releasing the Tem
    if tblua:GetPixelColor(750, 530) == "0x1CD1D3" then
		tblua:Sleep(modifier*math.random(400, 999))
        tblua:PressKey(0x44)
        tblua:Sleep(modifier*math.random(366, 999))
        tblua:PressKey(0x46)
        tblua:Sleep(modifier*math.random(366, 999))
        tblua:PressKey(0x46)
        tblua:Sleep(modifier*math.random(1820, 3594))
	end
end

function KeepTem() -- Keeping the Tem
    if tblua:GetPixelColor(750, 530) == "0x1CD1D3" then
		tblua:Sleep(modifier*math.random(666, 999))
        tblua:PressKey(0x46)
        tblua:Sleep(modifier*math.random(366, 999))
        tblua:PressKey(0x46)
        tblua:Sleep(modifier*math.random(366, 999))
        tblua:PressKey(0x46)
        tblua:Sleep(modifier*math.random(1820, 3594))
	end
end

function SkipExpSkill() -- Skips Exp Screen and new Attack Screen
	if tblua:GetPixelColor(215, 255) == "0x1CD1D3" then
		tblua:Sleep(modifier*math.random(666, 999))
		tblua:PressKey(0x1B)
		tblua:Sleep(modifier*math.random(1820, 3594))
	end
	
	if tblua:GetPixelColor(590, 245) == "0x1CD1D3" then
		tblua:Sleep(modifier*math.random(666, 999))
		tblua:PressKey(0x1B)
		tblua:Sleep(modifier*math.random(1820, 3594))
	end
end

function SwapDeadTem() -- Swap Tem if dead
	if tblua:GetPixelColor(1180, 455) == "0x1E1E1E" then
		local tem = 3
		local count = 1
		deadwiplumps = deadwiplumps + 1
		while tblua:GetPixelColor(1180, 455) == "0x1E1E1E"
		do
			while count < tem
			do
				tblua:PressKey(0x53)
                tblua:Sleep(modifier*math.random(1320, 1594))
				count = count + 1
			end
			tblua:PressKey(0x46)
			tblua:Sleep(modifier*math.random(1320, 1594))
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
		tblua:Sleep(modifier*math.random(750, 1594))
		tblua:PressKey(0x1B)
		tblua:Sleep(modifier*math.random(705, 1594))
		tblua:PressKey(0x1B)
		tblua:Sleep(modifier*math.random(750, 1594))
		tblua:PressKey(0x1B)
		tblua:Sleep(modifier*math.random(705, 1594))
		tblua:PressKey(0x1B)
		tblua:Sleep(modifier*math.random(750, 1594))
		tblua:PressKey(0x1B)
		tblua:Sleep(modifier*math.random(705, 1594))
		while tblua:IsInFight() == false and tblua:IsInWorld() == false
		do
			tblua:PressKey(0x1B)
			tblua:Sleep(modifier*math.random(800, 1594))
		end
		local RandomRunz = math.random(330, 694)
        tblua:Sleep(modifier*RandomRunz)
        tblua:PressKey(0x38)
		local RandomRunz = math.random(330, 694)
        tblua:Sleep(modifier*RandomRunz)
        tblua:PressKey(0x38)
		local RandomRunz = math.random(330, 694)
        tblua:Sleep(modifier*RandomRunz)
        tblua:PressKey(0x38)
		local RandomRunz = math.random(330, 694)
        tblua:Sleep(modifier*RandomRunz)
        tblua:PressKey(0x38)
		if value < 450 then
			stuckcounter = stuckcounter + 1
		end
		return 0
	else
	tblua:Sleep(modifier*math.random(650, 800))
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
			lumacounter = lumacounter + 1
			return CardsOnLuma(vmnr)
		else
			WaitForLuma(nr)
		end
	end
end

function WaitForLuma(vmnr) -- Waiting for Luma Option
	tblua:Sleep(500)
	tblua:SendTelegramMessage("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\nMessage from: " .. vmnr .. "\nRunning Kisiwa Desert C/R Script\nLuma Found! Waiting...")
	tblua:TestMessage("Luma Found! Stopping Script and Waiting...")
	tblua:PressKey(0x71)
end

function DisconnectOnLuma(vmnr)
	tblua:Sleep(500)
	tblua:SendTelegramMessage("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\nMessage from: " .. vmnr .. "\nRunning Kisiwa Desert C/R Script\nLuma Found! Disconnecting...")
    local RandomDC = math.random(1548, 3110)
	tblua:Sleep(modifier*RandomDC)
	tblua:PressKey(0x1B)
	tblua:Sleep(modifier*RandomDC)
	tblua:PressKey(0x53)
	tblua:Sleep(modifier*RandomDC)
	tblua:PressKey(0x53)
	tblua:Sleep(modifier*RandomDC)
	tblua:PressKey(0x46)
	tblua:Sleep(modifier*RandomDC)
	tblua:PressKey(0x46)
	tblua:Sleep(modifier*RandomDC)
	tblua:PressKey(0x71)
end

function CardsOnLuma(vmnr)
	tblua:Sleep(500)
	tblua:SendTelegramMessage("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\nMessage from: " .. vmnr .. "\nRunning Kisiwa Desert C/R Script\nLuma Found! Start throwing Cards...")
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
        tblua:Sleep(modifier*tblua:GetTickrate()*math.random(99, 222))
        tblua:KeyUp(0x57)
        return 2
    else
        tblua:KeyDown(0x53)
        tblua:Sleep(modifier*tblua:GetTickrate()*math.random(99, 222))
        tblua:KeyUp(0x53)
        return 1
    end
end

function movementcurved(move) -- movement curved
    if move == 1 then
		tblua:CircleArea()
		tblua:Sleep(modifier*math.random(100, 300))
		return 2
    elseif move == 2 then
        tblua:RandomArea()
		tblua:Sleep(modifier*math.random(700, 1200))
		return 1
    else
        tblua:CircleArea()
		tblua:Sleep(modifier*math.random(100, 300))
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
				tblua:Sleep(modifier*math.random(100, 300))
				changecurve = 2
			elseif changecurve == 2 then
				tblua:RandomArea()
				tblua:Sleep(modifier*math.random(700, 1200))
				changecurve = 1
			else
				tblua:CircleArea()
				tblua:Sleep(modifier*math.random(100, 300))
				changecurve = 2
				end
		end
		return move
    end
end

--------------------------------------------------------------------------------------------------
--------------------------------Rebuy and Heal Movement Functions---------------------------------
--------------------------------------------------------------------------------------------------
function StartRebuy(mov)
	if notifications == 1 then
	notificationcounter = notificationcounter + 1
	tblua:Sleep(500)
	tblua:SendTelegramMessage("-----------------------------\nMessage from: " .. vm .. "\nRunning Kisiwa Desert C/R Script\nRebuying now!!!\nTotal Rebuys: " .. tostring(notificationcounter) .. "\nTotal Encounter: " .. tostring(enemycounter) .. "\nTotal Anti-Stucks activated: " .. tostring(stuckcounter) .. "\nLumas Found: " .. tostring(lumacounter) .. "\nWiplumps killed in action: " .. tostring(deadwiplumps))
	end	
	local randosleep = math.random(1, 9)
    tblua:StopMovement()
	if randosleep == 1 then
		tblua:CheckPause()
		tblua:CheckLogout()
	end
	if mov == 1 then
		RunningToShop() -- running up to store when UP/DOWN Movement
		if randosleep == 2 then
			tblua:CheckPause()
			tblua:CheckLogout()
		end
		FromShopToHeal() -- running to heal station
		if randosleep == 3 then
			tblua:CheckPause()
			tblua:CheckLogout()
		end
		FromHealToShop() -- moving to shop
		if randosleep == 4 then
			tblua:CheckPause()
			tblua:CheckLogout()
		end		
		BuyingCards() -- Talking to Shop and Buy
		if randosleep == 5 then
			tblua:CheckPause()
			tblua:CheckLogout()
		end		
		MoveBackToArea()
	else
		TeleportToShop()
		if randosleep == 2 then
			tblua:CheckPause()
			tblua:CheckLogout()
		end		
		FromShopToHeal() -- running to heal station
		if randosleep == 3 then
			tblua:CheckPause()
			tblua:CheckLogout()
		end
		FromHealToShop() -- moving to shop
		if randosleep == 4 then
			tblua:CheckPause()
			tblua:CheckLogout()
		end
		BuyingCardsAndBombs() -- Talking to Shop and Buy Cards and Smoke Bombs
		if randosleep == 5 then
			tblua:CheckPause()
			tblua:CheckLogout()
		end
		MoveBackToArea()
		RunToArea(randosleep)
	end
	if randosleep == 6 then
		tblua:CheckPause()
		tblua:CheckLogout()
	end
	tblua:Sleep(math.random(1,240000))
	if randosleep == 7 then
		tblua:CheckPause()
		tblua:CheckLogout()
	end
end

function RunningToShop()
--start running up
	tblua:Sleep(math.random(90, 100))
	tblua:KeyDown(0x57)
    tblua:Sleep(math.random(8000, 10000))
    tblua:PressKey(0x57)
    tblua:Sleep(math.random(90,100))
	-- now checks if stuck in fight while running to shop
	while tblua:IsInWorld() == false
	do
		runningaway()
		tblua:Sleep(math.random(80, 100))
		tblua:KeyDown(0x57)
		tblua:Sleep(math.random(8000, 10000))
		tblua:PressKey(0x57)
		tblua:Sleep(100)
    end
end

function TeleportToShop()
	tblua:Sleep(math.random(650, 1500))
	tblua:PressKey(0x49)
	tblua:Sleep(math.random(750, 1300))
	tblua:PressKey(0x45)
	tblua:Sleep(math.random(800, 1250))
	while tblua:GetPixelColor(1013, 177) ~= "0xB1FEFF"
	do
		tblua:PressKey(0x53)
        tblua:Sleep(math.random(650, 1250))	
	end	
	tblua:Sleep(math.random(800, 1000))
	tblua:PressKey(0x46)
	tblua:Sleep(math.random(777, 1000))
	tblua:PressKey(0x46)
	tblua:Sleep(math.random(1000, 2500))
end

function FromShopToHeal()
	tblua:KeyDown(0x41) --move slightly left
    tblua:Sleep(math.random(230, 270))
    tblua:PressKey(0x41)
	tblua:Sleep(math.random(80, 120))
	tblua:KeyDown(0x41) -- move diagonal up/left to healing station
	tblua:Sleep(math.random(8, 12))
	tblua:KeyDown(0x57)					
    tblua:Sleep(math.random(480, 520))
    tblua:PressKey(0x41)
	tblua:Sleep(math.random(180, 220) )
	tblua:PressKey(0x57)  -- stop pressing W last to look in the right direction
	tblua:Sleep(math.random(170, 250))
	while tblua:IsInWorld() == false
	do
		runningaway()
		tblua:KeyDown(0x41) -- move diagonal up/left to healing station
		tblua:Sleep(math.random(8, 10))
		tblua:KeyDown(0x57)					
		tblua:Sleep(math.random(480, 500))
		tblua:PressKey(0x41)
		tblua:Sleep(math.random(180, 200))
		tblua:PressKey(0x57)  -- stop pressing W last to look in the right direction
		tblua:Sleep(math.random(125, 250))
	end	
	tblua:PressKey(0x46) -- start healing and wait a random amount between 7,5s and 10s
	local shortpause = math.random(8)
	if shortpause == 8 then
		tblua:Sleep(math.random(22000, 28000))
	else
		local RandomSleepForHealing = math.random(7500, 10000)
		tblua:Sleep(RandomSleepForHealing)
	end
end

function FromHealToShop()
	tblua:KeyDown(0x44)	-- start moving to the right to seller				
    tblua:Sleep(math.random(400, 742))
    tblua:PressKey(0x44)
	tblua:Sleep(math.random(480, 567))
	while tblua:IsInWorld() == false
	do
		runningaway()
		tblua:KeyDown(0x44)					
		tblua:Sleep(math.random(400, 500))
		tblua:PressKey(0x44)
		tblua:Sleep(math.random(480, 500))	   
	end 

end

function BuyingCards()
    tblua:PressKey(0x46)
    tblua:Sleep(math.random(430, 700))
    tblua:PressKey(0x46)
    tblua:Sleep(math.random(430, 700))
    tblua:PressKey(0x53)
    tblua:Sleep(math.random(430, 700))
    tblua:PressKey(0x53)
    tblua:Sleep(math.random(430, 700))
    tblua:PressKey(0x46)
    tblua:Sleep(math.random(430, 700))
    if tblua:IsInWorld() == false then
		local clicks = 0
        while clicks < 10
		do --Buying TemCards
			tblua:PressKey(0x44)
			clicks = clicks + 1
            tblua:Sleep(math.random(150, 300))
        end
        tblua:PressKey(0x46)
        tblua:Sleep(math.random(500, 2500))
        tblua:PressKey(0x1B)
        tblua:Sleep(math.random(750, 1000))
	end
end	

function BuyingCardsAndBombs()
	local clicks = 0
    tblua:PressKey(0x46)
    tblua:Sleep(math.random(466,600))
    tblua:PressKey(0x46)
    tblua:Sleep(math.random(466, 600))
	tblua:PressKey(0x46)
    tblua:Sleep(math.random(466, 600))
	while clicks < 2
	do --Buying SmokeBombs
		tblua:PressKey(0x44)
		clicks = clicks + 1
        tblua:Sleep(math.random(150, 300))
    end
	local clicks = 0
    tblua:PressKey(0x46)
    tblua:Sleep(math.random(666, 800))
    tblua:PressKey(0x53)
    tblua:Sleep(math.random(466, 600))
    tblua:PressKey(0x53)
    tblua:Sleep(math.random(466, 600))
    tblua:PressKey(0x46)
    tblua:Sleep(math.random(466, 600))
    while clicks < 10
	do --Buying TemCards
		tblua:PressKey(0x44)
		clicks = clicks + 1
        tblua:Sleep(math.random(150, 300))
    end
    tblua:PressKey(0x46)
    tblua:Sleep(math.random(466, 2500))
    tblua:PressKey(0x1B)
    tblua:Sleep(math.random(800, 1000))
end	

function MoveBackToArea()
	-- moving back in front of the seller
    tblua:KeyDown(0x53)
	tblua:Sleep(math.random(8, 12))
	tblua:KeyDown(0x44)
    tblua:Sleep(math.random(200,300))
    tblua:PressKey(0x44)
	tblua:Sleep(math.random(10, 12))
	tblua:PressKey(0x53)
    tblua:Sleep(math.random(10,1000))
end

function RunToArea(wait)
	local counting = 0
	tblua:KeyDown(0x41)
	tblua:Sleep(math.random(2800,3000))
	while tblua:IsInWorld() == false
	do
		tblua:KeyUp(0x41)
		runningaway()
		tblua:KeyDown(0x41) -- move diagonal up/left to healing station
		tblua:Sleep(math.random(800,900))
	end	
	if wait == 8 then
		tblua:KeyUp(0x41)
		tblua:CheckPause()
		tblua:CheckLogout()
		tblua:Sleep(math.random(50,300))
		tblua:KeyDown(0x41)
	end	
	while tblua:GetPixelColor(1197, 88) ~= "0x143F5A" or counting > 500
	do
		tblua:Sleep(math.random(20,40))
		if tblua:IsInWorld() == false then
			tblua:KeyUp(0x41)
			runningaway()
			tblua:KeyDown(0x41)
			tblua:Sleep(math.random(20,40))
		end
		counting = counting + 1
	end
	if wait == 9 then
		tblua:CheckPause()
		tblua:CheckLogout()
		tblua:Sleep(math.random(50,300))
	end	
	if counting <= 500 then
		tblua:KeyUp(0x41)
		tblua:Sleep(math.random(10, 400))
		tblua:KeyDown(0x57)
		tblua:Sleep(math.random(800, 1300))
		tblua:KeyDown(0x41)
		tblua:Sleep(math.random(400, 800))
		tblua:KeyUp(0x41)
		tblua:Sleep(math.random(10, 2000))
		tblua:KeyUp(0x57)
		tblua:Sleep(math.random(400, 800))
	else
		tblua:KeyUp(0x41)
		tblua:Sleep(math.random(10, 400))
	end
end

function Welcome()
	tblua:Sleep(math.random(20, 100))
	tblua:TestMessage("Kisiwa Desert Catch & Release Script\nby Scriptchacho\n\nPlease report any Bugs to Muchacho13#0901 on Discord\n\nIf you like my scripts, consider a small donation :)")
	tblua:Sleep(math.random(20, 100))
	tblua:TestMessage("Next up your Settings!\n\nIf something is wrong, stop the script by pressing F2 and check your Settings at the top of the script!")
	tblua:Sleep(math.random(20, 100))
	tblua:TestMessage("Movement: " .. WelcomeMovement() .. "\nLuma Option: " .. WelcomeLuma() .. "\nNumber of Wiplumps to use: " .. tostring(wiplumps) .. "\nRelease or Keep Tems: " .. WelcomeKeepTem() .. "\nYour Speed is set to: " .. tostring(speed) .. "%\nTelegram Notifications are turned " .. WelcomeNotification())
	tblua:Sleep(math.random(20, 100))
	tblua:TestMessage("If everything is set up correctly, you can start the Script by clicking OK now \n\nDo not forget to Start right in front of the Shop! \n\nHave Fun and Good Luck :)")
	tblua:Sleep(math.random(1000, 1500))
end

function WelcomeMovement()
	if movement == 1 then
		return "Up/Down Delay"
	elseif movement == 2 then
		return "Curved Movement"
	elseif movement == 3 then
		return "Maevement"
	end
end

function WelcomeNotification()
	if notifications == 1 then
		return "ON"
	elseif notifications == 0 then
		return "OFF"
	end
end

function WelcomeKeepTem()
	if keeptem == 1 then
		return "KEEP"
	elseif keeptem == 0 then
		return "RELEASE"
	end
end

function WelcomeLuma()
	if LumaOption == 1 then
		return "Wait on Luma"
	elseif LumaOption == 2 then
		return "Disconnect on Luma"
	elseif LumaOption == 3 then
		return "Only throwing Cards on Luma"
	end
end

------------------------------------------------------------------------------------------------
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
tblua:Sleep(modifier*1000)

if tblua:IsInWorld() == true then
	Welcome()
	RunToArea(0)
	while(true)
	do
------------------------------Doing Movement Overworld Actions-----------------------------------
		while tblua:IsInWorld() == true 
		do
			if usedcards == 1 or dead > DeadBeforeRebuy then
				StartRebuy(movement)
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
				cardsout, deadout = MainBattle(LumaOption, vm, keeptem)
				dead = dead + deadout
				usedcards = usedcards + cardsout
				MovementSwitch = math.random(2)

				tblua:Sleep(modifier*math.random(2, 4000))				
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
