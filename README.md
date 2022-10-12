    _____                        _____           _       _       
   / ____|                      / ____|         (_)     | |      
  | |     _ __ __ _ _____   _  | (___   ___ _ __ _ _ __ | |_ ___ 
  | |    | '__/ _` |_  / | | |  \___ \ / __| '__| | '_ \| __/ __|
  | |____| | | (_| |/ /| |_| |  ____) | (__| |  | | |_) | |_\__ \
   \_____|_|  \__,_/___|\__, | |_____/ \___|_|  |_| .__/ \__|___/
                         __/ |                    | |            
                        |___/                     |_|            


# Thanks For Downloading :D

# Important Notes!
- When a Victim is Ziptied they can spam "Point" (Default: B) to release themselves
- When a Victim is Bagged they can wait until the Bag automatically falls off
- Kidnappers also have the option to remove both before the Victim does

# Dependencies:
- qb-policejob
- qb-radialmenu
- qb-smallresources (Logs)


# Built-In:
- Anti-Cheat Logs
- Exploit Protected
- Face Covering Mask
- Items

## Screenshots
![radialmenu](https://i.imgur.com/uVhb7TB.png)
![items](https://i.imgur.com/4efzQGa.png)



# Setup / Installation:

# 1. Add These Items To qb-core > shared > items.lua
##  You Can Press (Alt + Z) To Make This Easier To Read and Format.
```

-- Crazy Zipties & HeadBags
	['ziptie']						 ={['name'] = 'ziptie', 						['label'] = 'Zip tie',                  ['weight'] = 300, 		['type'] = 'item', 		['image'] = 'ziptie.png',      			['unique'] = false, 	['useable'] = true,		['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A zip tie'},
	['headbag']						 ={['name'] = 'headbag', 						['label'] = 'Head Bag',                 ['weight'] = 500, 		['type'] = 'item', 		['image'] = 'headbag.png',      		['unique'] = true, 		['useable'] = true,		['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A bag to cover someones head'},

```

# 2. Replace Event In (qb-policejob > client >  interactions.lua : ~ line 303) With This Updated Event
```

RegisterNetEvent('police:client:GetEscorted', function(playerId)
    local ped = PlayerPedId()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata["isdead"] or isHandcuffed or PlayerData.metadata["inlaststand"] or PlayerData.metadata['ishandcuffed'] then
            if not isEscorted then
                isEscorted = true
                local dragger = GetPlayerPed(GetPlayerFromServerId(playerId))
                SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(dragger, 0.0, 0.45, 0.0))
                AttachEntityToEntity(ped, dragger, 11816, 0.45, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            else
                isEscorted = false
                DetachEntity(ped, true, false)
            end
            TriggerEvent('hospital:client:isEscorted', isEscorted)
        end
    end)
end)

```

# 3. Add Images to (qb-inventory > html > images) from the images folder here

# 4. 'refresh' (In-Game or Through Tx) then 'ensure crazy-kidnapping' (In-Game or Through Tx)



<!-- Thanks! -->
- To Any and All Who Helped In The Making of This


# License
QBCore Framework
Copyright (C) 2015-2022 ESX (Jérémie N'gadi), Joshua Eger

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>

<!-- QBCore <3 !-->
