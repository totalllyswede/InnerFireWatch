# InnerFireWatch (Turtle WoW)

Version: 1.0  
Author: Olzon

A lightweight Turtle WoW (1.12.1) addon that alerts you when **Inner
Fire** expires.

## What It Does

-   Detects when Inner Fire falls off
-   Prints a chat warning
-   Displays red error text in the center of the screen
-   Plays an alert sound
-   Minimal and vanilla‑friendly

------------------------------------------------------------------------

## Installation

1.  Extract the zip file.

2.  Place the `InnerFireWatch` folder inside:

    World of Warcraft`\Interface`{=tex}`\AddOns`{=tex}\

3.  Restart the client.

4.  Enable the addon at the character selection screen if needed.

------------------------------------------------------------------------

## Commands

-   `/ifw on` --- Enable addon
-   `/ifw off` --- Disable addon
-   `/ifw sound on` --- Enable sound
-   `/ifw sound off` --- Disable sound
-   `/ifw gained on` --- Message when Inner Fire is gained
-   `/ifw gained off` --- Disable gained message

------------------------------------------------------------------------

## Optional: Custom Sound

If you want to use your own sound:

1.  Create this folder inside the addon:

    `Interface\AddOns\InnerFireWatch\sounds\`

2.  Place a file named:

    `expire.wav`

The addon will automatically use it if the file exists. If not, it will
use the default WoW alert sound.

------------------------------------------------------------------------

Made for Turtle WoW.
