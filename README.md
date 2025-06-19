# Valve Intro for Garry's Mod

A fun little project I made out of boredom to bring back the classic Valve startup video in Garry's Mod.

---

## About

GMod removed native support for the startup video a long time ago, so this mod can't bring it back *natively*. Instead, it uses pure Lua to play the intro video as early as possible—no DLL injections or hacks, just clean code.

---

## How to Change the Video

The mod currently includes the Valve intro from Source 2007 (Orange Box era), but if you would like to change it please follow the steps below

### What You Need:
- A copy of the Source game that has the intro video.
- A way to convert `.bik` files to `.webm` (tools like [HandBrake](https://handbrake.fr/) or [FFmpeg](https://ffmpeg.org/) work great).

### Steps:
1. **Locate the `.bik` file:**
   - Navigate to your Source game’s media folder (e.g., `C:\Program Files (x86)\Steam\steamapps\common\Portal 2\portal2\media` or similar).
   - Look for the startup video file, typically named something like `valve.bik` or `intro.bik`.
   - Copy this file to your mod folder.

2. **Convert `.bik` to `.webm` (if needed):**
   - Use a video converter like [HandBrake](https://handbrake.fr/) or [FFmpeg](https://ffmpeg.org/) to convert the `.bik` file to `.webm`.
   - Example FFmpeg command:  
     ```bash
     ffmpeg -i valve.bik -c:v libvpx -crf 10 -b:v 1M -c:a libvorbis valve.webm
     ```

3. **Replace the existing video:**
   - Put your new `valve.webm` file in the mod folder (next to `setup.exe` and `valve_intro.lua`), replacing the old one.

4. **Reinstall the mod:**
   - If the mod is already installed, uninstall it first, then reinstall to apply the new video.

---

Any issues or questions? Hit me up in the Issues tab!
