# InnerFireWatch (Turtle WoW)

Simple addon for Turtle WoW (1.12.1) that alerts you when **Inner Fire**
expires.

## Features

-   Detects when Inner Fire falls off
-   Prints chat warning
-   Shows red error text in the middle of the screen
-   Plays a sound (custom or default)
-   Lightweight and vanilla-friendly

## Installation

1.  Extract the addon folder.

2.  Place `InnerFireWatch` inside:

    World of Warcraft`\Interface`{=tex}`\AddOns`{=tex}\

3.  Restart the client or type `/reload` if supported.

4.  Enable the addon at character select if needed.

## Slash Commands

-   `/ifw on` --- Enable addon
-   `/ifw off` --- Disable addon
-   `/ifw sound on|off` --- Enable/disable sound
-   `/ifw custom on|off` --- Enable/disable custom sound file
-   `/ifw gained on|off` --- Message when Inner Fire is gained

## Optional Custom Sound

Place a file named:

Interface`\AddOns`{=tex}`\InnerFireWatch`{=tex}`\sounds`{=tex}`\expire`{=tex}.wav

The addon will automatically use it if available.

------------------------------------------------------------------------

Made for Turtle WoW.
