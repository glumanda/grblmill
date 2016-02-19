/**
 * junand 27.12.2015
 * last update: 27.12.2015
 *
 * Nachbau der MicroMill-Teile
 * rebuild of the micromill parts
 *
 *      parts
 *
 */
 
/**************************************************************************
 *
 * X Axes
 *
 **************************************************************************/
  
module tplate_support () {

    dim = profile_k30_end_dim [ x_profile_count ];
    
	h = dim [height];
	dim_xy = [dim [x], dim [y], 0];
    
    support_dim = [5*profile_k20_end_dim[x], 2*M4_bolthead_diameter, (nema17_base_size - profile_k30_base_size)/2];

    difference () {
        translate ( [0, 0, support_dim[z]/2] - support_dim/2 ) 
            cube ( support_dim );
     		// M6 left/right
        for ( i = [-1, +1] ) {
            translate ( i * (dim_xy/2 - profile_end_plate_hole_pos) + fudge_dim ) {
                cylinder ( d = M4_diameter, h = support_dim[z] + 2*fudge );
                translate ( [0, 0, support_dim[z] - M4_bolthead_height] ) cylinder ( d = M4_bolthead_diameter, h = M4_bolthead_height +2*fudge );
            }
        }
    }
}

*x_end_tplate();
module x_end_tplate () {

    difference () {
        hull () {
            translate ( [0, (nema17_base_size + profile_k20_end_dim[y])/2, 0] ) 
                kinetik_profile_end_plate_k20 ( t_plate_profile_count );
            for ( dx = [-1, +1] ) {
                translate ( [dx*(profile_k30_end_dim[x_profile_count][x] + nema17_base_size)/4 -dx*corner_radius/2, profile_k30_base_size/2 - corner_radius/2, 0] ) 
                    cubedBox ( [profile_k30_end_dim[x_profile_count][x]/2 - nema17_base_size/2 + corner_radius, 2*corner_radius+10, profile_k30_end_dim[x_profile_count][z]] );
            }
        }
        translate ( [0, (nema17_base_size + profile_k20_end_dim[y])/2, 0] ) 
            kinetik_profile_end_plate_k20_holes ( t_plate_profile_count );
    }

 }
 
 module x_end ( with_t_plate = with_t_plate ){

	difference () {
        union () {
            kinetik_profile_end_plate_k30 ( x_profile_count, false );
            if ( with_t_plate ) x_end_tplate ();
        }
        translate ( [0, 1, 0] ) bearing688 ();
	}

}

module x_motor_end ( with_t_plate = with_t_plate ) {

	difference () {
		union () {
            kinetik_profile_end_plate_k30 ( x_profile_count, false );
            nema17_mount_plate ();
            if ( with_t_plate ) x_end_tplate ();
		}
        nema17_mount_holes ();
	}

}

module x_motor_end_extension () {
    
    cutout_dim = [nema17_base_size +2*fudge, 0.55*nema17_base_size, x_motor_end_extension_length -8 ];

    difference () {
        nema17_mount_plate ( x_motor_end_extension_length );
        nema17_mount_holes ( x_motor_end_extension_length, nema17_axes_cutout_radius + 3 );
        //translate ( [-nema17_base_size/2 -fudge, 0, delta/2] ) cube ( [nema17_base_size +2*fudge, 10, x_motor_end_extension_length - delta] );
        for ( rot = [0, 90] ) {
            rotate ( [0, 0, rot] )
                translate ( ([0, 0, cutout_dim[z]-fudge] -cutout_dim)/2  ) 
                    cube ( cutout_dim );
        }
    }
}

module x_slide () {

    nut_holder_outer_diameter = TR8_nut [outer_diameter] + 5;
    x_dim = [profile_k30_base_size + slide_inner_width_extra + 2*slide_board_depth, x_slide_inner_width + 2*slide_board_depth, x_slide_length];
    
    intersection () {
    
        difference () {

            // Halter für TR8 Mutter
            union () {

                slide_frame ( x_slide_inner_width, x_slide_length, shorter_x_slide ? x_slide_length_cut : 0 );
                
                translate ( [0, 0, shorter_x_slide ? x_slide_length_cut/2 : 0] ) {
                    hull () {
                        cylinder ( d = nut_holder_outer_diameter, h = TR8_nut [height] );
                        translate ( [TR8_nut [outer_diameter], -nut_holder_outer_diameter/2, 0] ) cube ( [1, nut_holder_outer_diameter, TR8_nut [height]] );
                    }
                }

            }

            translate ( [0, 0, shorter_x_slide ? x_slide_length_cut/2 : 0] ) {

                // TR8
                translate ( fudge_dim ) cylinder ( d = TR8_nut [outer_diameter], h = TR8_nut [height] +2*fudge ); 

                // M3 screws for inner slider
                translate ( [0, 0, TR8_nut [height]/2] ) rotate ( [0, 90, 0] ) {
                    cylinder ( r = M3_radius, h = nut_holder_outer_diameter );
                    cylinder ( d = M3_nut_diameter, h = nut_holder_outer_diameter/2 + 1, $fn = 6 );
                    translate ( [0, 0, 19] ) cylinder ( r = M3_bolthead_radius, h = nut_holder_outer_diameter );
                }
                
            }
            
        }
    
        // x slider top cut
        translate ( -x_dim/2 + [11 -fudge, -fudge, x_slide_length/2 -fudge] ) cube ( x_dim + [2*fudge, 2*fudge, 2*fudge] );
        
    }

}

/**************************************************************************
 *
 * Y Axes
 *
 **************************************************************************/

module y_support ( count ) {

    dim = profile_k30_end_dim [ count ];

 	x = dim [x];
 	y = dim [y];
 	h = dim [height];

    // Stütze für die Profilhalterung
    hull () {
        for ( d = [-1, +1] ) {
            translate ( [d * (x/2 - corner_radius/2), -y/2, 0] )
                translate ( [-corner_radius/2, 0, 0] ) cube ( [corner_radius, corner_radius, h] );
            translate ( [d * (x/2+6.5), -55, 0] )
                cylinder ( r = corner_radius, h = h );
        }
    }
    
}

module y_end_support () {

	difference () {
        union () {
            kinetik_profile_end_plate_k30 ( y_profile_count, true );
            y_support ( y_profile_count );
        }
        // bearing center is 22 mm from lower boundary of end support
        translate ( [0, bearing688_end_plate_pos, 0] ) bearing688 ();
	}
 
 }

 module y_motor_end_support () {
 
	difference () {
        union () {
            kinetik_profile_end_plate_k30 ( y_profile_count, true );
            y_support ( y_profile_count );
        }
        translate ( [0, bearing688_end_plate_pos, 0] ) nema17_mount_holes ();
	}

}

module y_slide () {

    // juand 08.03.2015 changend from 35 mm to 34.5 mm
    TR8_nut_x = -35;
    TR8_nut_x = -34.5;
    
    TR8_extra = 5;

    hh = 2;
    h = TR8_nut [height] + hh;

    l_M3 = TR8_nut [outer_diameter] + 2*TR8_extra + 5; // 5 für die Auswölbung
    h_M3_nut = 2.1;
    
    difference () {

        union () {
            slide_frame ( y_slide_inner_width, y_slide_length );
            // Halter für TR8 Mutter
            // TODO Verdickung für Schraubbefestigung wie z_nut einbauen
            hull () {
                // "Schale" um TR8 Mutter
                //translate ( [0, y_nut, 0] ) cylinder ( d = TR8_nut [outer_diameter] + TR8_extra, h = h );
                translate ( [TR8_nut_x, 0, 0] ) cylinder ( d = TR8_nut [outer_diameter] + TR8_extra, h = TR8_nut [height] ); 
                for ( dy = [-1, +1] ) {
                    translate ( [-(profile_k30_base_size + slide_inner_width_extra + 2)/2, dy*(TR8_nut [outer_diameter] + 2*TR8_extra)/2, 0] ) cylinder ( d = 1, h = TR8_nut [height] );
                    for ( dx = [-1, +1] ) {
                        translate ( [TR8_nut_x + dx*9.5/2, dy*(TR8_nut [outer_diameter] + 2*TR8_extra)/2, 0] ) cylinder ( d = 1, h = TR8_nut [height] );
                    }
                }
            }
        }

        // TR8 Buchse
        translate ( [TR8_nut_x, 0, -fudge] ) cylinder ( d = TR8_nut [outer_diameter], h = TR8_nut [height] +2*fudge ); 
        
        // seitl. Schrauben für M3 Befestigung
        translate ( [TR8_nut_x, 0, h/2] ) rotate ( [0, 0, 90] ) {
            // Loch für Schraube
            translate ( [-l_M3/2 -fudge, 0, 0] ) rotate ( [0, 90, 0] ) cylinder ( r = M3_radius, h = l_M3 +2*fudge );
            // Durchmesser für eine Mutter ist Abstand der "Flächen" dividiert durch sin(60)
            translate ( [-TR8_nut [outer_diameter]/2 -h_M3_nut, 0, 0] ) rotate ( [0, 90, 0] ) cylinder ( d = M3_nut_diameter, h = TR8_nut [outer_diameter] +2*h_M3_nut, $fn = 6 );
        }
    }
    
}

/**************************************************************************
 *
 * Z Axes
 *
 **************************************************************************/

module z_motor_end () {

 	h = part_height;
    d = 32.5 -5 +2.1; // Motorachse um 5mm vom feststehenden Profil wegbringen und nun Aufhängung geändert und nun Motorachse 2,1 mm weg vom Profil
    d = 29.6;

	difference () {
        union () {
            kinetik_profile_end_plate_k30 ( z_profile_count, false );
            translate ( [0, d, 0] ) {
                hull () {
                    nema17_mount_plate ();
                    // Eckenfüller
                    for ( d = [-1, +1] ) {
                        translate ( [d * nema17_base_size/1.45, -nema17_base_size/2, 0] )
                            cylinder ( h = h );
                    }
                }
            }
        }
        translate ( [0, d, 0] ) nema17_mount_holes ();
	}

}

module z_nut () {

    length_fixing_screw_hole = z_nut_shell_base_width + support_cylinder_diameter;
    
    difference () {
    
    union () {

        // base plate
        translate ( [0, -z_nut_base_plate_dim [z]/2, z_nut_base_plate_dim[y]/2] ) 
            rotate ( [90, 0, 0] ) 
                roundedBox ( z_nut_base_plate_dim - [z_nut_base_reduction, 0, 0], corner_radius, sidesonly );

        // shell around nut
        hull () {

            // shell base
            translate ( [0, z_nut_y_pos, 0] ) 
                cylinder ( d = TR8_nut [outer_diameter] + 2*TR8_nut_shell_width, h = TR8_nut_shell_height );
            
            // fixing screw
            for ( dx = [-1, +1] ) {
                translate ( [dx*z_nut_shell_base_width/2, 0, 0] ) {
                    for ( y = [-support_cylinder_diameter, z_nut_y_pos - z_nut_fixing_screw_base_width/2] ) {
                        translate ( [0, y, 0] )
                            cylinder ( d = support_cylinder_diameter, h = TR8_nut_shell_height );
                    }
                }
                *for ( dy = [-1, +1] ) {
                    translate ( [dx*(TR8_nut [outer_diameter]/2 + TR8_nut_shell_width), z_nut_y_pos + dy*z_nut_fixing_screw_base_width/2, 0] ) 
                        cylinder ( d = support_cylinder_diameter, h = TR8_nut_shell_height  );
                }
            }
        }

        // notch
        for ( dx = [-1, +1] ) {
            //translate ( [dx*profile_k30_base_size/2 - kinetik_k30_notch_width/2, kinetik_k30_notch_depth, 0] )
            translate ( [dx * ( z_nut_base_plate_dim[x]/2 - profile_k30_base_size/2 ) - kinetik_k30_notch_width/2, kinetik_k30_notch_depth, 0] )
                rotate ( [90, 0, 0] ) 
                    cube ( [kinetik_k30_notch_width, z_nut_base_plate_dim [y], kinetik_k30_notch_depth] );
        }

    }
        
        // sidly screw for fixing the nut
        translate ( [0, z_nut_y_pos, 0] ) {

            translate ( [0, 0, TR8_nut_shell_height/2] ) {
        
                // hole for screws
                translate ( [-length_fixing_screw_hole/2 -fudge, 0, 0] ) 
                    rotate ( [0, 90, 0] ) 
                        cylinder ( r = M3_radius, h = length_fixing_screw_hole +2*fudge );
                        
                // indention for nuts
                translate ( [-TR8_nut [outer_diameter]/2 -M3_nut_height, 0, 0] ) 
                    rotate ( [0, 90, 0] ) 
                        cylinder ( d = M3_nut_diameter, h = TR8_nut [outer_diameter] +2*M3_nut_height, $fn = 6 );
            }

        
            // Loch/Ausschnitt für TR8 Mutter
            translate ( [0, 0, TR8_nut_shell_base_height] ) 
                cylinder ( d = TR8_nut [outer_diameter], h = z_nut_base_plate_dim [y] +2*fudge );
            
            // Loch/Auschnitt für Achse
            translate ( fudge_dim ) 
                cylinder ( d = TR8_nut_axes_cutout_diameter, h = z_nut_base_plate_dim [y] +2*fudge );
                
        }
        
        // Schraublöcher für Profilbefestigung
        for ( i = [-1, +1] ) {
//            for ( j = [0.25, 0.75] ) {
            for ( j = [0.75] ) {
                translate ( [i * ( z_nut_base_plate_dim[x]/2 - profile_k30_base_size/2 ), kinetik_k30_notch_depth +fudge, j*z_nut_base_plate_dim[y]] )
                    rotate ( [90, 0, 0] ) 
                        cylinder ( r = M4_radius, h = 10 );
            }
        }
        
    }

}

module z_end () {

    kinetik_profile_end_plate_k30 ( z_profile_count, false);

}

module z_side_slide () {

    difference () {
        
        union () {
            // base
            roundedBox ( z_side_slide_dim, corner_radius, sidesonly );
            
            // notches
            translate ( [0, -z_side_slide_dim [y]/2, z_side_slide_dim[height]/2 -fudge] ) {
                for ( x = z_side_slide_notch_x_pos ) {
                    translate ( [x, 0, 0] ) {
                        cube ( [kinetik_k30_notch_width, z_side_slide_dim [y], kinetik_k30_notch_depth] );
                        if ( with_z_slder_notch_base ) {
                            translate ( [(kinetik_k30_notch_width - kinetik_k30_notch_base_width)/2, 0, 0] ) 
                                cube ( [kinetik_k30_notch_base_width, z_side_slide_dim [y], kinetik_k30_notch_base_depth] );
                        }
                    }
                }
            }
        }
        
        // holes for slider mount (M3)
        for ( z_side_slide_yy = [-36, +36] ) {
            translate ( [z_side_slide_notch_x_pos [0] + kinetik_k30_notch_width/2, z_side_slide_yy, -10] ) {
                for ( z_side_slide_y = [-inner_slider_hole_distance/2, +inner_slider_hole_distance/2] ) {
                    translate ( [0, z_side_slide_y, 0] ) cylinder ( r = M3_radius, h = 20 );
                }
            }
        }
        
        // holes and cutouts for fixed mount (M6)
        for ( z_side_slide_yyy = [-35, 0, 35] ) {
            translate ( [z_side_slide_notch_x_pos [1] + kinetik_k30_notch_width/2, z_side_slide_yyy, 0] ) {
                translate ( [0, 0, -10] ) cylinder ( r = M4_radius, h = 20 );
                translate ( [0, 0, z_side_slide_dim [height]/2] ) cylinder ( r = M6_radius +3, h = 10 );
            }
        }
        
    }
    
}

/**************************************************************************
 *
 * Coupler
 *
 **************************************************************************/

module coupler () {

    rotate ( [-90, 0, 0] ) coupler_v2 ();
    
}

module coupler_v1 () {

    difference () {
        translate ( [-10, 10, 0] ) rotate ( [90, 0, 0] ) import ( "coupleur.stl" );
        cylinder ( d = 5.5, h = 31 );
    }
    
}

module coupler_v2 () {
    
    len = 25;

    difference () {
        translate ( [-20/2, len/2, 0] ) rotate ( [90, 0, 0] ) import ( "Z_Split_Coupler.stl" );
        rotate ( [-90, 0, 0] ) translate ( [0, 0, 0] ) cylinder ( d = 4.9, h = len/2 +fudge );
        rotate ( [+90, 0, 0] ) translate ( [0, 0, 0] ) cylinder ( d = 8, h = len/2 +fudge );
    }
    
}


/**************************************************************************
 *
 * Arduino Uno + Spindle Board Holder
 *
 **************************************************************************/

 module board_holder_screws ( y1 = 0, y2 = 0 ) {

     h = 4;
    r_extra = 4;
    
    rr = M6_radius + r_extra;

    // Halterung M6
    for ( p = [[-profile_k30_base_size/2, y1, 0] , [+profile_k30_base_size/2,  y2, 1] ] ) {
        translate ( [p[x], p[y], 0] )
            difference () {
                union () {
                    cylinder ( r = rr, h = h );
                    mirror ( [0, p[2], 0] ) 
                    linear_extrude ( height = h ) {
                        polygon (
                            points = [ [-rr, 0], [+rr, 0], [+rr, -rr], [-rr, -rr] ],
                            paths= [ [0, 1, 2, 3] ]
                        );
                    }
                }
                translate ( [0, 0, -fudge] )cylinder ( r = M6_radius, h = h + 2*fudge );
            }
    }

 }
 
*arduino_uno_holder ();
module arduino_uno_holder () {

    import ( "Arduino_Covered_Bumper2.stl" );
    board_holder_screws ( 41, -27.5 );

}

module spindle_board_holder () {

    board_l = 75.5;
    border_w = 2*3;
    corner_l = 10;

    corner_d = board_l/2 - corner_l/2 + border_w/2;
    screw_d = board_l/2 - 3.3;
    
    bottom_h = 1.2;
    nut_h = 2.5;
    corner_h = nut_h + 2;
    border_h = corner_h + 2;

    difference () {
        union () {
            difference () {
                translate ( [0, 0, 0] ) cubedBox ( [board_l + border_w, board_l + border_w, border_h] );
                translate ( [0, 0, bottom_h] ) cubedBox ( [board_l, board_l, border_h - bottom_h +fudge] );
            }
            union () {
                for ( x = [-corner_d, +corner_d] ) {
                    for ( y = [-corner_d, +corner_d] ) {
                        translate ( [x, y, 0] ) roundedBox2 ( [corner_l, corner_l, corner_h], corner_radius, sidesonly );
                    }
                }
            }
        }
        for ( x = [-screw_d, +screw_d] ) {
            for ( y = [-screw_d, +screw_d] ) {
                // Loch für Schraube
                translate ( [x, y, -fudge] ) cylinder ( r = M3_radius, h = border_h +2*fudge );
                // Durchmesser für eine Mutter ist Abstand der "Flächen" dividiert durch sin(60)
                translate ( [x, y, -fudge] ) cylinder ( d = 5.5 / sin ( 60 ), h = 2, $fn = 6 );
            }
        }
    }

    board_holder_screws ( board_l/2+9, -(board_l/2+9) );
    
}

/**************************************************************************
 *
 * Spindle Clamp
 *
 **************************************************************************/

*spindle_clamp (); 

module spindle_clamp ( part = 0, separation_plane = 0 ) {

    clamp_height = 2*profile_k30_base_size;
    plate_dim = [profile_k30_end_dim [z_profile_count][x], part_height/2, clamp_height];

    stopper_height = 2;
    
    spindle_diameter = 52;
    extra_outer_diamter = 5;
    spindle_clamp_y = -35; // ausgemessen!
    
    spindle_clamp_box_length = spindle_diameter + extra_outer_diamter + 30;
    spindle_clamp_box_width = 20;
    
    cam_diameter = 9.99;
    cam_y = spindle_clamp_y - spindle_diameter/2 -cam_diameter +extra_outer_diamter/2 -0.5;
    
    part1_intersection_box_depth = -spindle_clamp_y;
    part2_intersection_box_depth = (spindle_diameter + extra_outer_diamter)/2 + cam_diameter + extra_outer_diamter/2 +fudge;
    part_clearance = 0.1;
    part_clearance = 1;

    // HACK for test
    *difference () {
        len = 3;
        cylinder ( d = cam_diameter + extra_outer_diamter, h = len );
        translate ( fudge_dim ) cylinder ( d = cam_diameter, h = len + 2*fudge );
    }

    if ( separation_plane != 0 ) {
        color ( "blue" ) translate ( [-50, spindle_clamp_y - part_clearance, -fudge] ) cube ( [100, part_clearance, plate_dim [z] +2*fudge] );
    }
    
    intersection () {

        if ( part == 0 ) {
            // do nothing
        }
        else if ( part == 1 ) {
            // main part
            translate ( [-spindle_clamp_box_length/2 -fudge, -part1_intersection_box_depth +fudge, 0] ) 
                cube ( [spindle_clamp_box_length + 2*fudge, part1_intersection_box_depth + kinetik_k30_notch_depth +fudge, plate_dim [z]] );
        }
        else if ( part == 2 ) {
            // clamp
            translate ( [-spindle_clamp_box_length/2 -fudge, -part2_intersection_box_depth + spindle_clamp_y - part_clearance, 0] ) 
                cube ( [spindle_clamp_box_length + 2*fudge, part2_intersection_box_depth, plate_dim [z]] );
        }

        difference () {
        
            union () {
            
                // notch
                for ( dx = [-1, +1] ) {
                    //translate ( [dx*profile_k30_base_size/2 - kinetik_k30_notch_width/2, kinetik_k30_notch_depth, 0] )
                    translate ( [dx * ( plate_dim[x]/2 - profile_k30_base_size/2 ) - kinetik_k30_notch_width/2, 0, 0] )
                        cube ( [kinetik_k30_notch_width, kinetik_k30_notch_depth, plate_dim [z], ] );
                }

                hull () {
                    translate ( [-plate_dim [x]/2, -plate_dim [y], 0] ) cube ( plate_dim );
                    translate ( [0, spindle_clamp_y, 0] ) cylinder ( d = spindle_diameter + extra_outer_diamter, h = clamp_height );
                    // cam holder
                    if ( spindle_clamp_with_cam_holder ) {
                        translate ( [0, cam_y, 0] ) cylinder ( d = cam_diameter + extra_outer_diamter, h = 40 );
                    }
                }

                
                translate ( [-spindle_clamp_box_length/2, spindle_clamp_y - spindle_clamp_box_width/2, 0] ) {
                    difference () {
                        cube ( [spindle_clamp_box_length, spindle_clamp_box_width, plate_dim [z]] );
                        // Schraublöcher für Klemme
                        for ( i = [-1, +1] ) {
                            for ( j = [0.25, 0.75] ) {
                                //translate ( [i * ( plate_dim[x]/2 - profile_k30_base_size/2 ), kinetik_k30_notch_depth +fudge, j*plate_dim[z]] )
                                translate ( [
                                                spindle_clamp_box_length/2 + 0.25*i*(spindle_clamp_box_length + spindle_diameter + extra_outer_diamter), 
                                                spindle_clamp_box_width +fudge, 
                                                j*plate_dim[z]
                                            ] )
                                    rotate ( [90, 30, 0] ) {
                                        cylinder ( r = M6_radius, h = spindle_clamp_box_width +2*fudge );
                                        cylinder ( r = M6_nut_radius, h = 0.7*M6_nut_height, $fn = 6 );
                                    }
                            }
                        }
                    }
                }
                
            }
            
            // cam holder
            if ( spindle_clamp_with_cam_holder ) {
                translate ( [0, cam_y, -fudge] ) cylinder ( d = cam_diameter, h = clamp_height + 2*fudge );
            }

            // Loch/Ausschnitt
            translate ( [0, spindle_clamp_y, stopper_height] ) cylinder ( d = spindle_diameter, h = plate_dim [z] +2*fudge );
            // Loch/Auschnitt für Achse
            translate ( [0, spindle_clamp_y, -fudge] ) cylinder ( d = spindle_diameter - 20, h = plate_dim [z] +2*fudge );
            
            // Schraublöcher für Profilbefestigung
            for ( i = [-1, +1] ) {
                for ( j = [0.25, 0.75] ) {
                    translate ( [i * ( plate_dim[x]/2 - profile_k30_base_size/2 ), kinetik_k30_notch_depth +fudge, j*plate_dim[z]] )
                        rotate ( [90, 0, 0] ) {
                            cylinder ( r = M6_radius - 0.5, h = 30 ); // HACK to avoiding support, needs to redrill
                            translate ( [0, 0, 8.2] ) cylinder ( r = M6_bolthead_radius, h = M6_bolthead_height + 7 );
                        }
                }
            }
            
            
        }
    }
}

 module spindle_clamp_V1 ( part = 0 ) {
 
    dim = profile_k30_end_dim [ z_profile_count ];
    
	h = 40;
	dim2 = [dim [x], dim [y], h + 2*fudge];
    lx = 85; 
    ly_extra = 5;
    ly = profile_k30_base_size + ly_extra;
    l = 60;
    
    h_nut = ly - (80 - 52.5) + M6_nut_height;

    difference () {
        translate ( [-lx/2, -ly/2 + ly_extra/2 +fudge, -h/2] ) cube ( [lx, ly, h] );
        translate ( fudge_dim/2 ) roundedBox ( dim2, corner_radius, sidesonly );
        for ( x = [-35, +35] ) {
            translate ( [x*0.75, 0, 0] ) rotate ( [0, x/abs(x)*90, 0] ) cylinder ( r = M6_radius, h = 20 );
            for ( z = [-10, +10] ) {
                translate ( [x, 0, z] ) {
                    translate ( [0, l/2, 0] ) rotate ( [90, 0, 0] ) cylinder ( r = M6_radius, h = l );
                    *translate ( [0, profile_k30_base_size/2 + ly_extra +2*fudge, 0] ) rotate ( [90, 30, 0] ) cylinder ( r = M6_nut_radius, h = M6_nut_height, $fn = 6 );
                    // Länge Schrauibe 80 ./. Bauteil 52.5 -> verbleibt 27.5 ./. Mutternhöhe 4.75 -> 22.75
                    // d.h. von 22.75 bis 35 muss Mutter ausgespart werden
                    translate ( [0, profile_k30_base_size/2 + ly_extra +2*fudge, 0] ) rotate ( [90, 30, 0] ) cylinder ( r = M6_nut_radius, h = h_nut, $fn = 6 );
                    
                }
                *translate ( [x, 0, z] ) {
                    translate ( [0, -15+8 -fudge, 0] ) rotate ( [90, 0, 0] ) cylinder ( r = M6_radius, h = 8 );
                    translate ( [0, -15 +8, 0] ) rotate ( [90, 0, 0] ) cylinder ( r = M6_nut_radius, h = M6_nut_height, $fn = 6 );
                    translate ( [-x/abs(x)*4, -15 +8, 0] ) rotate ( [90, 0, 0] ) cylinder ( r = M6_nut_radius, h = M6_nut_height, $fn = 6 );
                    
                }
            }
        }
    }
    
 }
 

//-------------------------------------------------------------------------
