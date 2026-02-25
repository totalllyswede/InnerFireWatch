# InnerFireWatch (Turtle WoW)

Version: 1.1\
Author: Olzon

A lightweight Turtle WoW (1.12.1) addon that alerts you when important
self-buffs expire.

------------------------------------------------------------------------

## Supported Classes & Buffs

### Priest

-   Inner Fire

### Warrior

-   Battle Shout

### Shaman

-   Lightning Shield
-   Water Shield
-   Earth Shield

### Mage

-   Arcane Intellect
-   Ice Armor
-   Mage Armor

------------------------------------------------------------------------

## Features

-   Detects when a tracked buff expires
-   Prints a chat warning
-   Displays red UI error text
-   Optional large center-screen alert (toggleable)
-   Optional sound alert (custom or default)
-   Extremely lightweight and vanilla-friendly

------------------------------------------------------------------------

## Installation

1.  Extract the zip file.

2.  Place the `InnerFireWatch` folder inside:

    `World of Warcraft\Interface\AddOns\`

3.  Restart the client.

4.  Enable the addon at the character selection screen if needed.

------------------------------------------------------------------------

## Slash Commands

-   `/ifw on` --- Enable addon\
-   `/ifw off` --- Disable addon\
-   `/ifw sound on` --- Enable sound\
-   `/ifw sound off` --- Disable sound\
-   `/ifw gained on` --- Message when buff is gained\
-   `/ifw gained off` --- Disable gained message\
-   `/ifw large on` --- Enable large center-screen alert\
-   `/ifw large off` --- Disable large center-screen alert

------------------------------------------------------------------------

## Optional: Custom Sound

To use your own alert sound:

1.  Create this folder inside the addon:

    `Interface\AddOns\InnerFireWatch\sounds\`

2.  Place a file named:

    `expire.wav`

If the file exists, it will be used automatically.\
If not, the default WoW alert sound will play.

------------------------------------------------------------------------

Designed for Turtle WoW.
