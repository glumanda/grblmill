# grblmill

I have derived this work from http://www.thingiverse.com/thing:44854

You need the MCAD library https://github.com/SolidCode/MCAD

##Usage

* open grbl_mill_main.scad in openSCAD to view the assembled mill
  * you can select the viewed part in the main file by commenting out the appropriate line
* in grbl_mill_const.scad you can adjust the main construction
  * in the division Configuration you can configure the count of profile for each direction separatly
  * there are some more flags for configuring the mill
* some tuning is done in directly done in grbl_mill_parts.scad

##This design is

* fully printable 
  * large parts are printed with 0.8 mm nozzle
  * smaller parts with 0.4 mm nozzle
* completly designed with openSCAD
* using alu profiles from http://www.kinetikmsystem.de
  * K30 for the basic construction
    * you can use for all direction a width of 3 basic profiles (like in the original design)
    * but i had some souring restrictions so i am used on y 4 basic profile widh and for the other two 2 profiles
    * length for z: 200 mm (movable) and 300 mm (fix)
    * length for x and y: 260 mm
  * K20 for the t-nut plate
    * length is the same like for x: 260 mm
* the T8 threaded rod and the TR8 nut i have sourced from http://www.metallbau-pietrzak.de (ebay)

##Screws and Rods

* to connect the end parts to the profiles i have used M6 self cutting screws
* to fix the slider and the TR8 nut i used M3 screws
* fixing the t-nut profíles use M4 screws
* the trapezoid rods are 300 mm (x), 250 mm (y) and 200 m (z) long
* the motor coupler on all axes is http://www.thingiverse.com/thing:173335

##CNC-Control-Unit and Spindle

* Arduino Uno with Grbl V0.9g
* GrblShield with DRV8825 driver chips
* the spindle is from ebay (China) with a Driver Board, that can be connected to the Grbl-Board

##Working Area

* xy: 107.5 mm x 84.m mm
* z = about 40 - 50 mm, depedning from tool and using the t-nut profiles
* is enough for milling pcbs or hobbed bolts


 




