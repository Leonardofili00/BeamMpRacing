# BeamMpRacing

The purpose of this mod is to race with different type of sessions on your BeamMP server.

## Summary
1. [Features](#features)
2. [How to Install](#how-to-install)



## Features

<details>
  <summary>Show</summary>

### General
- Fuel consumption
- Tyre wear and temperature
- Pits

### Free practice
- Laptimes leaderboard

### Qualifying
- Laptimes leaderboard

### Race
- Race leaderboard
- Lap/time counter

</details>



## How to install

- Install your BeamMP server ([BeamMP Server Download](https://beammp.com)) and configure it.
- Launch your server once to initialize files.
- Download the last version of the mod ([Mod Releases]()).
- Unzip the mod archive in your server's *Resources* folder.
- Connect your game to your server.

## Command
Help - shows the command list

# For developers

<details>
  <summary>Show</summary>

## Code snippets

### Timer

```
local seconds = 0

function CountSeconds()
    seconds = seconds + 1
end

-- create a custom event called 'EverySecond'
-- and register the handler function 'CountSeconds' to it
MP.RegisterEvent("EverySecond", "CountSeconds")

-- create a timer for this event, which will fire every 1000ms (1s)
MP.CreateEventTimer("EverySecond", 1000)
```

### Getting player position
```
local raw_pos, error = MP.GetPositionRaw(player_id, vehicle_id)

if error == "" then
    print(raw_pos)
else
    print(error)
end
```

### Getting player name
```
MP.GetPlayerName(player_id)
```

### Getting players list
```
local players = MP.GetPlayers()
print(#players) -- note how print() doesn't change
```

### 
```

```

### 
```

```

### 
```

```

### 
```

```
</details>