/**
 * junand 08.02.2015
 * last update: 27.12.2015
 *
 * Nachbau der MicroMill-Teile
 * rebuild of the micromill parts
 *
 *      assemble
 *
 */

module assemble_all ( dist = assemble_dist, with_profile = true ) {

    //translate ( [0, -50, -profile_k30_base_size/2] ) 
    rotate ( [90, 0, 0] ) assemble_xy ( dist, with_profile ); 
    //translate ( [0, 120, 50] ) rotate ( [0, 0, 180] ) 
    translate ( [0, -110, profile_k30_base_size/2 + dist] ) rotate ( [0, 0, 180] ) assemble_z ( dist, with_profile, 1.0*z_side_slide_dim [y], 2.0*z_side_slide_dim [y] ); 
    
}

 module assemble_z ( dist = assemble_dist, with_profile = true, z_movable_profile_length = z_side_slide_dim [y], z_fix_profile_length = z_side_slide_dim [y] ) {
 
    // movable profile with spindle clamp
    translate ( [0, -z_side_slide_notch_x_pos [1] - kinetik_width_k30/2, z_fix_profile_length - z_movable_profile_length] ) {
        if ( with_profile ) {
            color ( "silver" ) kinetik_profile_k30 ( z_profile_count, z_movable_profile_length );
        }
        color ( "yellow" ) translate ( [0, 0, z_movable_profile_length + nema17_plate_dim [z] + dist] ) rotate ( [0, 180, 0] ) z_motor_end ();
        color ( "yellow" ) translate ( [0, -profile_k30_base_size/2 -assemble_dist, 0] ) {
            spindle_clamp ( 1 );
            spindle_clamp ( 2 );
        }
    }
    
    // fix profile
    translate ( [0, -z_side_slide_notch_x_pos [0] - kinetik_width_k30/2, 0] ) {
        if ( with_profile ) {
            color ( "silver" ) kinetik_profile_k30 ( z_profile_count, z_fix_profile_length );
        }
        color ( "yellow" ) translate ( [0, 0, z_fix_profile_length + dist] ) z_slide_top ();
        color ( "black" ) translate ( [0, -profile_k30_base_size/2, z_fix_profile_length - z_movable_profile_length -20] ) z_nut ();
    }
    
    // side slides
    color ( "yellow" )
    for ( i = [-1, +1] ) {
        translate ( [i*(z_profile_count*profile_k30_base_size/2 + z_side_slide_dim [z]/2 + dist), 0, z_side_slide_dim [y]/2 + z_fix_profile_length - z_movable_profile_length] ) 
            rotate ( [i*90, 0, -90] ) 
                z_side_slide ();
    }
    
    // z axes
    if ( assemble_show_axes ) {
        color ( "red" )
            translate ( [0, -3, -25] )
                rotate ( [0, 0, 0] )
                    cylinder ( d = 8, h = len_axes );
    }
    
 }

module assemble_y ( dist = assemble_dist, with_profile = true, y_profile_length = y_slide_length ) {
 
    // y slider
    union () {
        color ( "green" ) y_end_support ();    
        translate ( [0, 0, part_height + dist] ) {
            if ( with_profile ) {
                color ( "silver" ) translate ( 2*fudge_dim ) kinetik_profile_k30 ( y_profile_count, y_profile_length +4*fudge );
            }
            color ( "orange" ) rotate ( [0, 0, 90] ) y_slide ();
            translate ( [0, 0, y_profile_length + dist + part_height] ) {
                color ( "green" ) rotate ( [0, 180, 0] ) y_motor_support ();
            }
        }
    }

}

module assemble_x ( dist = assemble_dist, with_profile = true, x_profile_length = x_slide_length ) {

    // x slider
    union () {
        color ( "green" ) rotate ( [180, 180, 0] ) x_end ();
            translate ( [0, 0, part_height + dist] ) {
                color ( "silver" )
                if ( with_profile ) {
                    for ( d = [-1, +1] ) {
                        translate ( [d*(x_profile_count-1)/2*profile_k30_base_size, 0, -2*fudge] ) kinetik_profile_k30 ( 1, x_profile_length +4*fudge );
                    }
                    if ( with_t_plate ) {
                        for ( i = [1 : t_plate_profile_count] ) {
                            translate ( [(0.5 + t_plate_profile_count/2 - i) * profile_k20_end_dim [x], -(nema17_base_size + profile_k20_end_dim[y])/2], 0 ) rotate ( [0, 0, 180] ) kinetik_profile_k20 ( 1, x_profile_length +4*fudge );
                        }
                    }
                }
            color ( "orange" ) rotate ( [0, 0, 90] ) x_slide ();
            translate ( [0, 0, x_profile_length + dist] ) {
                color ( "green" ) translate ( [0, 0, part_height] ) rotate ( [180, 0, 0] ) x_motor_end ();
                translate ( [0, 0, part_height + dist] ) {
                    color ( "orange" ) x_motor_end_support ();
                }
            }
        }
    }
 
}

module assemble_xy ( dist = assemble_dist, with_profile = true, x_profile_length = 1.5*x_slide_length, y_profile_length = 2.0*y_slide_length ) {

    x_slide_move_x = part_height + dist + x_slide_length/2;
    x_slide_move_y = profile_k30_base_size + slide_inner_width_extra + 2*slide_board_depth + dist;

    y_slide_move = part_height + dist + y_slide_length/2;

    translate ( [x_slide_move_x, x_slide_move_y, 0] ) rotate ( [0, 90, 180] ) assemble_x ( dist, with_profile, x_profile_length );
    translate ( [0, 0, -y_slide_move] ) assemble_y ( dist, with_profile, y_profile_length );
    
}
