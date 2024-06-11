# Retro Artist Toolkit

![License][License] 

Welcome to the Retro Artist Toolkit! This repository is designed to provide tools for retro pixel artists. Starting with Aseprite scripts, I aim to expand with more tools in the future to help you create amazing pixel art for retro platforms.

<img src = https://c4.wallpaperflare.com/wallpaper/406/189/125/digital-art-pixel-art-pixelated-pixels-wallpaper-preview.jpg>

#### About

In the last few months, I've been diving deep into programming games for retro consoles, especially the SNES. Following some tutorials, I came across the [SNES Assembly Adventure](https://georgjz.github.io/snesaa01/) by [georgjz](https://github.com/georgjz?tab=repositories). This tutorial really opened my eyes to how SNES graphics work, including converting RGB888 colors to BGR555. You can check it out [here](https://georgjz.github.io/snesaa03/).

After understanding all the steps to convert the RGB888 to BRG555 color, I decided to write my own script to handle this, following the logic from georgjz's tutorial. This script is now part of the Retro Artist Toolkit. Another reason to create my own script is that I had some problems exporting the palette with other tools like SNES_GFX_tools.

I created this repo to share these tools and help other retro pixel artists and retro programmers with their workflow. Right now, it mainly includes Aseprite extensions, but I plan to add more stuff in the future.

#### Notes

##### About the Retro Artist Toolkit
> The Retro Artist Toolkit is still in its early stages. It's not fully mature yet, but I'm actively working on it to make it better and more useful. Stay tuned for updates and improvements!

##### Other tools
> I still use [SNES_GFX_tools](https://github.com/MM102/SNES-Tools-for-Aseprite) to create the binaries of my sprites, to convert its bit depth and to shift the palettes. If you don't know this, you have to check it out, it is a great tool.

#### Aseprite Scripts

* SNES_PALETTE_EXPORTER

#### Getting Started

1. Clone the repository:
``` bash
git clone https://github.com/maganharenan/snes-pal
```
2. Open Aseprite;
3. Click on file and then go to scripts and click on **"Open Scripts Folder"**;
4. Copy the content of the repo to the scripts folder (Only the src folder and the **SNES_PAL.lua** file);
5. Then go again through file and scripts and click on **"Rescan Scripts Folder"**;

#### Usage
After copying the scripts and rescan you will be able to see the scripts in the scripts menu.

<img src = res/palette_exporter.png>

Since the SNES relies on a technique called (indirect) color indexing, you will need to configure the color mode of the sprite to **Indexed** in order to be able to export the palette.

#### Future Plans
* Adding more extensions and tools for different pixel art software.
* Developing standalone tools to assist in pixel art creation and animation.

[License]: https://img.shields.io/badge/license%20-%20MIT%20-%20green