/**
 * junand 30.11.2014
 * last update: 27.12.2015
 *
 * Nachbau der MicroMill-Teile
 * rebuild of the micromill parts
 *
 *      const
 *
 */

/**************************************************************************
 *
 * Basics
 *
 **************************************************************************/

$fn = 360/10;

fudge = 0.1;
fudge_dim = [0, 0, -fudge];

clearance = 0.4;

/**************************************************************************
 *
 * Configuration
 *
 **************************************************************************/

part_height = 10;   // height of all end plates

// number of basic profiles at each axis
x_profile_count = 3;
y_profile_count = 4;
z_profile_count = 2;

spindle_clamp_with_cam_holder = false;
with_t_plate = true;

t_plate_profile_count = 5;

shorter_x_slide = false;

z_nut_base_reduction = 15;
//z_nut_base_reduction = 0;

assemble_show_axes = false; // on for checking alignment

with_z_slder_notch_base = true;
 
/**************************************************************************
 *
 * Index
 *
 **************************************************************************/

//index
outer_diameter = 0; 
inner_diameter = 1;
height = 2;

x = 0;
y = 1;
z = 2;              // identical with height!!! can used synonimously

/**************************************************************************
 *
 * Kinetik Profile
 *
 **************************************************************************/

 // sizes of profiles
profile_k30_base_size = 30;

default_profile_count = 4;

profile3030_k30_end_dim = [profile_k30_base_size, profile_k30_base_size, part_height];
profile6030_k30_end_dim = [2 * profile_k30_base_size, profile_k30_base_size, part_height];
profile9030_k30_end_dim = [3 * profile_k30_base_size, profile_k30_base_size, part_height];
profile12030_k30_end_dim = [4 * profile_k30_base_size, profile_k30_base_size, part_height];

profile_k30_end_dim = [
    [-1, -1, -1],           // placeholder
    profile3030_k30_end_dim,
    profile6030_k30_end_dim,
    profile9030_k30_end_dim,
    profile12030_k30_end_dim
];

// position of profile end holes
profile_end_plate_hole_pos = [profile_k30_base_size/2, profile_k30_base_size/2, 0];

profile_k20_end_dim = [20, 10, part_height];

kinetik_k30_notch_width = 6.40 - 0.10; // according to the drawing this is 6.2 mm, but practical tests result in 6.3 mm
kinetik_k30_notch_depth = 2.85;
kinetik_k30_notch_base_width = 8.00;
kinetik_k30_notch_base_depth = 2.90 - 2.10;

kinetik_k20_notch_width = 5.05;
kinetik_k20_notch_depth = 3;

/**************************************************************************
 *
 * Motor Mount
 *
 **************************************************************************/

nema17_base_size = 42;
nema17_plate_dim = [nema17_base_size, nema17_base_size, part_height];
nema17_axes_cutout_radius = 12;
nema17_base_mounthole_pos = nema17_base_size/2 - 5.5;
nema17_mounthole_pos_dim = [nema17_base_mounthole_pos, nema17_base_mounthole_pos, 0];

x_motor_end_extension_length = 38.5;

/**************************************************************************
 *
 * Screws
 * http://de.wikipedia.org/wiki/Metrisches_ISO-Gewinde
 *
 **************************************************************************/

M3_clearance = clearance;
M3_diameter = 3;
M3_radius = M3_diameter/2 + M3_clearance;
M3_bolthead_radius = 3.25;
M3_bolthead_height = 3;
M3_wrench_size = 5.5;
M3_nut_diameter = M3_wrench_size / sin ( 60 );
M3_nut_radius = M3_nut_diameter/2;
M3_nut_height = 2.3;

M4_clearance = clearance;
M4_diameter = 4;
M4_radius = M4_diameter/2 + M4_clearance;
M4_bolthead_diameter = 6.85;
M4_bolthead_radius = M4_bolthead_diameter/2;
M4_bolthead_height = 3.9;
M4_wrench_size = 7;
M4_nut_diameter = M4_wrench_size / sin ( 60 );
M4_nut_radius = M4_nut_diameter/2;
//M4_nut_height = xx;

M6_clearance = clearance;
M6_diameter = 6;
M6_radius = M6_diameter/2 + M6_clearance;
M6_bolthead_diameter = 9.7;
M6_bolthead_radius = M6_bolthead_diameter/2;
M6_bolthead_height = 6.0;
M6_wrench_size = 10;
M6_nut_diameter = M6_wrench_size / sin ( 60 );
M6_nut_radius = M6_nut_diameter/2;
M6_nut_height = 4.75;

/**************************************************************************
 *
 * TR8 Nuts and Bearings
 *
 **************************************************************************/

TR8_nut = [22 + clearance, -1, 20]; // outer diameter, height
TR8_radius = 8/2;

// outer, inner, height
bearing688_dim = [16 + clearance, 8 + clearance, 5];
bearing688_end_plate_pos = -35;

/**************************************************************************
 *
 * Parts
 *
 **************************************************************************/

corner_radius = 2;
sidesonly = true;

z_nut_base_dim = [26, 31, 12]; // x, y, z

z_side_slide_dim = [95, 100, 5.7]; // x, y, z
z_side_slide_notch_x_pos = [-35.5 -2, +29.5];

inner_slider_short_len = 28;
inner_slider_hole_distance = 12;

z_nut_base_plate_dim = [profile_k30_end_dim [z_profile_count][x], 1.5*profile_k30_base_size, part_height/2];
z_nut_y_pos = -22.5;
z_nut_shell_base_width = TR8_nut [outer_diameter] + 10;
z_nut_fixing_screw_base_width = 10;

TR8_nut_shell_base_height = 2;
TR8_nut_shell_height = TR8_nut [height] + TR8_nut_shell_base_height;
TR8_nut_axes_cutout_diameter = 14;
TR8_nut_shell_width = 2;
// TR8_nut_shell_width = 2.3; // this is better for my slicer

support_cylinder_diameter = 1;

/**************************************************************************
 *
 * Slides
 *
 **************************************************************************/

slide_board_depth = 6; // 6 mm Außenwand
slide_wall_depth = 3; // auf dieser Erhöhung sitzt die Gleitnut
slide_clearance = 0.2;
slide_connector_distance = 35; // distance from midpoint

x_slide_inner_width = profile_k30_end_dim [x_profile_count][x] + 2*slide_wall_depth;
y_slide_inner_width = profile_k30_end_dim [y_profile_count][x] + 2*slide_wall_depth;

x_slide_length = y_slide_inner_width + 2*slide_board_depth;
x_slide_length_cut = 18 + 30;
y_slide_length = x_slide_inner_width + 2*slide_board_depth;

slide_inner_width_extra = 7;

// inner dimension of a slider
// profileX030_end_dim [y] + 2*slide_board_depth + slide_clearance
// 3*30                    + 2*3                         + 0.5 = 96.5 bei 30x90 Profilen

// outer dimension of a slider
// slide_inner_dim [y] + 2*slide_board_depth => 108.5 bei 30x90 Profilen
//          96.5               + 2*      6                  = 108.5

/**************************************************************************
 *
 * Assemble
 *
 **************************************************************************/

assemble_dist = 5;
len_axes = 260;

//----------------------------------------------------------------------------------------------
