# Valve Intro for Garry's Mod

A fun little project I made out of boredom to bring back the classic Valve startup video in Garry's Mod.

---

## About

GMod removed native support for the startup video a long time ago, so this mod can't bring it back *natively*. Instead, it uses pure Lua to play the intro video as early as possible—no DLL injections or hacks, just clean code.

---

## How to Add or Change the Video

The mod currently includes the Valve intro from Source 2007 (Orange Box era).

### What You Need:
- A copy of Garry's Mod or another Source game that has the intro video.
- A way to convert `.bik` files to `.webm` (tools like [HandBrake](https://handbrake.fr/) or [FFmpeg](https://ffmpeg.org/) work great).

### Steps:
1. Convert your `.bik` video to `.webm` if needed.
2. Replace the existing `valve.webm` file in the mod folder (alongside `setup.exe` and `valve_intro.lua`).
3. If the mod is already installed, **uninstall** it first, then reinstall to load the new video.

---

## Troubleshooting & Support

If you run into any issues or have ideas, feel free to open an issue in the repo’s Issues tab!
