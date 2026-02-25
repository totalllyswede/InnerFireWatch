# InnerFireWatch (Turtle WoW)

Version: 1.1\
Author: Olzon

A lightweight Turtle WoW (1.12.1) addon that alerts you when key
self-buffs expire.

## What It Tracks

-   **Priest:** Inner Fire
-   **Warrior:** Battle Shout
-   **Shaman:** Lightning Shield, Water Shield, Earth Shield

## What It Does

-   Detects when the tracked buff falls off
-   Prints a chat warning
-   Displays red error text in the center of the screen
-   Optional big center-screen message
-   Plays an alert sound
-   Minimal and vanilla-friendly

------------------------------------------------------------------------

## Installation

1.  Extract the zip file.

2.  Place the `InnerFireWatch` folder inside:

    `World of Warcraft\Interface\AddOns\`

3.  Restart the client.

4.  Enable the addon at the character selection screen if needed.

------------------------------------------------------------------------

## Commands

-   `/ifw on` --- Enable addon
-   `/ifw off` --- Disable addon
-   `/ifw sound on` --- Enable sound
-   `/ifw sound off` --- Disable sound
-   `/ifw gained on` --- Message when the buff is gained
-   `/ifw gained off` --- Disable gained message
-   `/ifw large on` --- Enable big center-screen message
-   `/ifw large off` --- Disable big center-screen message

------------------------------------------------------------------------

## Optional: Custom Sound

If you want to use your own sound:

1.  Create this folder inside the addon:

    `Interface\AddOns\InnerFireWatch\sounds\`

2.  Place a file named:

    `expire.wav`

If the file exists, the addon will play it on expiration. Otherwise it
uses the default WoW alert sound.
