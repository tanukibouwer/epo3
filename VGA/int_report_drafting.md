---
# title: "VGA Module Design yes"
output: pdf_document
---

# 1. VGA module design

- [1. VGA module design](#1-vga-module-design)
  - [1.1. Introduction](#11-introduction)
  - [1.2. Specifications and boundary conditions](#12-specifications-and-boundary-conditions)
  - [1.3. Subdivision of the VGA module into Submodules](#13-subdivision-of-the-vga-module-into-submodules)
  - [1.4. Design of Submodules](#14-design-of-submodules)
  - [1.5. Simulation and Synthesis of Submodules](#15-simulation-and-synthesis-of-submodules)

<!-- 
Structure
    -introduction
        -? tell what the role of the VGA module is and why it should be made/why it is a seperate submodule
    -required specifications and boundary conditions of the module
        -? first a general description of what the VGA module should be able to do
            -? then use that description to draft a set of specifications
        -? now Take It To The Limit
    -deconstruction of the vga module in submodules
        -the scanner (rtl description)
            -? how one counts and keeps track of which horizontal pixel and which vertical row is being set now. Also synchronises the display to the chip
            -> the 2 sync generators
            -> the 2 counters
        -coloring (structural?/rtl description)
            -? the pixel coloring logic -> this module outputs what color a pixel should be based on the game data recieved from memory (player location, time left, player percentages)
            -> the top of coloring will house the gigantic if-tree that decides what color to draw
            -> the game data will be processed by subblocks of coloring so the desired RELATIVE pixel locations and colors will be known
                -char_offset_adder
                -number_sprite with the dig3_num_splitter
    -design of the submodules and their components
        -? information on how the module should look and how much combinatorial logic compared to registers/latches will be included
    -testbenches/simulation and synthesis 
        - TODO: make testbenches for all the components/submodules
    
 -->

## 1.1. Introduction

As is known, any video game has to have a video output. Without one the game would be impossible to play. For this reason a VGA module will be designed to be able to show the internal data to the player for interpretation. The VGA module can be seen as a application specific graphics card, as it will be designed specifically for the Super Smash Bros chip.
<!-- TODO: insert info about testing and the FPGA -->

## 1.2. Specifications and boundary conditions

To begin the design of the VGA module, one has to first define the required specifications and the boundary conditions the module has to be able to deal with. To begin with the specifications, a broad description would be: "A module that accepts game data from memory and then represents that data accordingly on screen". Although this description is too broad to fully grasp how the module will look like, it does suffice as a stepping stone towards a more detailed specification list.

The application specific specifications for this module are then as follows:

    - Drive a 640x480@60Hz VGA capable monitor
    - Send out a 4-bit color depth RGB signal
    - Interpret and display the game data on screen

Again, these specifications are quite broad yet more detailed and they show the general structure of the module, but lets expand on them.
For the first one, the resolution that has been set is the standard VGA resolution. This resolution is also a colloquiary from the frame refresh rate and pixel clock. The latter being 25.175MHz for exactly a 60 frame refresh rate. Given that the chip this VGA module will be situated on will have a clock frequency of 25MHz, this resolution is the easiest to achieve and display. Then the chip has to send the driver signals and keep track of the frame according to the VGA frame specifications, a 800 pixel long line and a frame of 525 lines and a synchronisation signal for both. This will be important later on when the VGA module will be subdivided into smaller modules. <!-- , there will be 2 sets of counters and synchronisation signal generators. These will then keep track of the frame internally and make sure the display is synchronised to the internal frame.  -->
Then for the RGB signal, this will not be a single line, instead this signal will be a set of 3 lines with an analog signal determining the color displayed on screen. The 4 bit color depth will allow for different intensities of Red (R), Green (G) and Blue (B). The 4-bit color depth means that each different color signal will have 4 logical output bits, resulting in 16 different binary combinations and as such analog output levels. A digital to analog converter will be available on the EPO3 test board and the FPGA to convert the binary outputs to a single analog line and as such the chip will only have to output the binary signals.
Finally for interpreting and displaying the game data on screen. This is important, as the chip has to be able to display the game data correctly. For this a set of data inputs from the memory module will be present, these being the player location data, the player damage percentage and the time left in the match. The information to be displayed on screen can also be read from this data, as it is the exact same. To achieve this placement of data on screen, 

## 1.3. Subdivision of the VGA module into Submodules

## 1.4. Design of Submodules

## 1.5. Simulation and Synthesis of Submodules
