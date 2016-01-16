/**
 * junand 08.02.2015
 * last update: 27.12.2015
 *
 * Nachbau der MicroMill-Teile
 * rebuild of the micromill parts
 *
 *      basic
 *
 */

 /**************************************************************************
 *
 * Helper
 *
 **************************************************************************/

 module lineup ( space = 40 ) {
 
   for ( i = [0 : $children - 1] )
     translate ( [0, i * space, 0 ] ) children ( i );
     
 }
 
 
module cubedBox ( dim ) {

    translate ( [-dim[0]/2, -dim[1]/2, 0] ) cube ( dim );
    
}

module roundedBox2 ( dim, corner_radius, sidesonly ) {

    translate ( [0, 0, dim [2]/2] ) roundedBox ( dim, corner_radius, sidesonly );
    
}
 /**************************************************************************
 *
 * Kinetik Profile K20
 *
 **************************************************************************/

module kinetik_slot_k20 ( l = 100 ) {

    translate ( [-kinetik_k20_notch_width/2, -kinetik_k20_notch_depth/2, 0] ) cube ( [kinetik_k20_notch_width, kinetik_k20_notch_depth, l] );
    
}

module kinetik_profile_k20 ( count = 2, l = 100 ) {

    dim = [profile_k20_end_dim[x], profile_k20_end_dim[y], l];
    
    translate ( [+dim[x]/2 * (1 - count) , 0, 0] )
        for ( i = [0:count-1] ) {
            translate ( [i*dim[x], 0, 0] ) {
                difference () {
                    roundedBox2 ( dim, corner_radius, sidesonly );
                    translate ( [0, +dim[y]/2 - kinetik_k20_notch_depth/2 +fudge, -fudge] )kinetik_slot_k20 ( l +2*fudge );
                    for ( dx = [-1, +1] ) {
                        translate ( [dx*13/2, -1.5, -fudge] ) cylinder ( d = 3.3, h = l +2*fudge );
                    }
                }
            }
        }
    
}

module kinetik_profile_end_plate_k20_holes ( count = 1, plate_height = profile_k20_end_dim[height] ) {

    hole_diameter = 4.3;
    dim = profile_k20_end_dim;

    translate ( [+dim[x]/2 * (1 - count) , 0, 0] )
        for ( i = [0:count-1] ) {
            translate ( [i*dim[x], 0, 0] )
                for ( dx = [-1, +1] ) {
                    translate ( [dx*13/2, -1.5, -fudge] ) cylinder ( d = hole_diameter, h = plate_height +2*fudge );
                }
        }

}

module kinetik_profile_end_plate_k20 ( count = 1 ) {

    dim = profile_k20_end_dim;
    
	h = dim [height];
	dim_xy = [count*dim [x], dim [y], dim[y]];

    difference () {
        roundedBox2 ( dim_xy, corner_radius, sidesonly );
        kinetik_profile_end_plate_k20_holes ( count );
    }

}

/**************************************************************************
 *
 * Kinetik Profile K30
 *
 **************************************************************************/

module kinetik_slot_k30 ( l = 100 ) {

    color ( "lime" )
    translate ( [-kinetik_k30_notch_width/2, -kinetik_k30_notch_depth/2, 0] ) cube ( [kinetik_k30_notch_width, kinetik_k30_notch_depth, l] );
    
}

module kinetik_profile_k30 ( count = 2, l = 100 ) {

    _dim = profile_k30_end_dim [ count ];
    dim = [_dim[x], _dim[y], l];
    
    difference () {
        color ( "blue" ) roundedBox2 ( dim, corner_radius, sidesonly );
        
        for ( dx = [-1, +1] ) {
            translate ( [dx*(dim[x]/2-kinetik_k30_notch_depth/2+fudge/10), 0, -fudge] ) rotate ( [0, 0, 90] ) kinetik_slot_k30 ( l +2*fudge );
        }
        
        for ( i = [0 : (count/2-(1-count%2))] ) {
            for ( dx = [-1, +1] ) {
                translate ( [dx*(i+0.5*(1-count%2))*profile_k30_base_size, 0, 0] ) {
                    translate ( [0, 0, -fudge] ) cylinder ( r = M6_radius, h = l +2*fudge );
                    for ( dy = [-1, +1] ) {
                        translate ( [0, dy*(profile_k30_base_size/2-kinetik_k30_notch_depth/2+fudge/10), -fudge] ) rotate ( [0, 0, 0] ) kinetik_slot_k30 ( l +2*fudge );
                    }
                }
            }
        }
        
    }
    
}

module kinetik_profile_end_plate_k30 ( count = 0, mid_hole = false ) {

    dim = profile_k30_end_dim [ count ];
    
	h = dim [height];
	dim_xy = [dim [x], dim [y], 0];

	difference ()  {

		translate ( [0, 0, h/2] )
			roundedBox ( dim, corner_radius, sidesonly );
	
		// M6 left/right
        for ( i = [-1, +1] ) {
            translate ( i * (dim_xy/2 - profile_end_plate_hole_pos) + fudge_dim ) 
                cylinder ( r = M6_radius, h = h + 2*fudge );
        }
	
		// M6 mid
        // TODO
		if ( mid_hole ) {
            // there are only mid holes for count 3 and 4
            if ( count == 3 ) {
                // one extra hole at (0,0)
                translate ( [0, 0, -fudge] ) 
                    cylinder ( r = M6_radius, h = h + 2*fudge );
            }
            else if ( count == 4 ) {
                for ( i = [-1, +1] ) {
                    translate ( [i * profile_end_plate_hole_pos [x], 0, -fudge] ) 
                        cylinder ( r = M6_radius, h = h + 2*fudge );
                }
            }
            
		}

	}

}

 /**************************************************************************
 *
 * Nema 17
 *
 **************************************************************************/

module nema17_mount_plate ( h = nema17_plate_dim [height] ) {

    dim = [nema17_plate_dim [x], nema17_plate_dim [y], h];

    translate ( [0, 0, h/2] )
        roundedBox ( dim, corner_radius, sidesonly );
    
}

module nema17_mount_holes ( h = nema17_plate_dim [height], cutout_radius = nema17_axes_cutout_radius ) {

    // motor axes
    translate ( fudge_dim ) cylinder ( r = cutout_radius, h = h + 2*fudge );
    
    // motor mount
    for ( xx = [-1, 1] ) {
        for ( yy = [-1, 1] ) {
            translate ( [xx * nema17_mounthole_pos_dim [0], yy * nema17_mounthole_pos_dim [1], 0] ) {
                translate ( fudge_dim )
                    cylinder ( r = M3_radius, h = h + 2*fudge );
                translate ( [0, 0, h - M3_bolthead_height] ) 
                    cylinder ( r = M3_bolthead_radius, h = M3_bolthead_height + fudge );
            }
        }
    }

}

 /**************************************************************************
 *
 * Bearing
 *
 **************************************************************************/

module bearing688 () {

    // bearing outer dim 16 mm
    translate ( [0, 0, part_height - bearing688_dim [height]] ) // TODO bad reference X030
        cylinder ( r = bearing688_dim [outer_diameter]/2, h = bearing688_dim [height] + fudge );
    // bearing inner dim 8 mm
    translate ( fudge_dim ) 
        cylinder ( r = bearing688_dim [inner_diameter]/2 + 0.25, h = bearing688_dim [height] + 2*fudge );

}

 /**************************************************************************
 *
 * Slider
 *
 **************************************************************************/

module slide_frame ( inner_width, length, length_cut = 0 ) {

    inner_dim = [profile_k30_base_size + slide_inner_width_extra, inner_width + slide_clearance, length - length_cut +2*fudge];
    outer_dim = [inner_dim [x] + 2*slide_board_depth, inner_width + 2*slide_board_depth, length - length_cut];
    
    //echo ( "slide_dim=", outer_dim );

    difference () {
    
        union () {

            difference () {
                translate ( [0, 0, length/2] ) roundedBox ( outer_dim, 2*corner_radius, sidesonly );
                translate ( [0, 0, length/2] ) roundedBox ( inner_dim, corner_radius, sidesonly );
            }

            // Auswölbungen innen für die Nut
            for ( dir = [-1, 1] ) {
                translate ( [0, dir * inner_dim [y]/2, length_cut/2] )
                    mirror ( [0, dir == 1 ? 1 : 0, 0] ) {
                        // Auswölbung
                        linear_extrude ( height = length - length_cut) {
                            polygon (
                                points = [ [12,0], [9,slide_wall_depth], [-10.5,slide_wall_depth], [-13.5, 0] ],
                                paths = [ [0, 1, 2, 3] ]
                            );
                        }
                        // Nut
                        translate ( [-kinetik_k30_notch_width/2, 3 -fudge, 0] ) cube ( [kinetik_k30_notch_width, kinetik_k30_notch_depth, length - length_cut] );
                    }
            }
            
        }

        // screw holes at the side for inner slider
        for ( zzz = [14 + length_cut/2, length - 14 - length_cut/2] ) {
            translate ( [0, 1.2*outer_dim[y]/2, zzz] ) {
                for ( zz = [-inner_slider_hole_distance/2, +inner_slider_hole_distance/2] ) {
                    translate ( [0, 0, zz] ) 
                        rotate ( [90, 0, 0] ) 
                            cylinder ( r = M3_radius, h = 1.2*outer_dim [y] );
                }
            }
        }
        
        // holes for connecting slides between x and y slide
        for ( zz = [length/2 - slide_connector_distance, length/2 + slide_connector_distance] ) { // h/2 - 35 and h/2 + 35
            translate ( [10, 0, zz] ) {
                for ( yy = [-slide_connector_distance, +slide_connector_distance] ) {
                    translate ( [0, yy, 0] ) 
                        rotate ( [0, 90, 0] ) {
                            cylinder ( r = M3_radius, h = 20 );
                            translate ( [0, 0, 6] ) cylinder ( r = M3_nut_radius, h = 5, $fn=6 );
                        }
                            
                }
            }
        }

    }

}

//----------------------------------------------------------------------------------------------
