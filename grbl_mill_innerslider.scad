/**
 * junand 08.02.2015
 *
 * Nachbau der MicroMill-Teile
 * rebuild of the micromill parts
 *
 *      innerslider
 *
 */

 /**************************************************************************
 *
 * Inner Slider
 *
 **************************************************************************/

a = 8.1; // vorher 8.0
b = 1.75;
d = 2.80;
e = 6.80;
    
module _innerSlider ( len = 10 ) {

    bevel_alpha = 45;
    bevel_height = 0.3;
    
    bevel_cube_w = 4;
    bevel_cube_h = bevel_height * cos ( bevel_alpha );

    intersection () {
    
        difference () {
        
            linear_extrude ( height = len ) {
                polygon (
                    points = [
                        [-a,0], [-a,b], [-d,e], [d,e], [a,b], [a,0]
                    ],
                    paths = [
                        [0, 1, 2, 3, 4, 5]
                    ]
                );
            }
            
            // Phase erste Ebene
            for ( d = [-1, +1] ) {
                translate ( [d*a, 0, -fudge] ) 
                        rotate ( [0, 0, d*bevel_alpha] ) translate ( [-bevel_cube_w/2, 0, 0] ) cube ( [bevel_cube_w, bevel_cube_h, len +2*fudge] );
            }
            
        }

        // Ecken "abrunden"
        rotate ( [-90, 0, 0] ) translate ( [0, -len/2, e/2] ) roundedBox ( [2*a, len, e], 3, sidesonly );
        
    }

}

module innerSliderHole ( l = 10 ) {

    cylinder ( r = M3_radius, h = l );
    translate ( [0, 0, 0] ) rotate ( [0, 0, 30] ) cylinder ( d = M3_nut_diameter, h = M3_nut_height, $fn = 6 );

}

module innerSliderHolePair () {

    for ( z = [-inner_slider_hole_distance/2, +inner_slider_hole_distance/2] ) {
        translate ( [0, e +fudge, z] ) rotate ( [90, 0, 0] ) innerSliderHole ( e +2*fudge );
    }

}

module innerSliderShort () {

    len = inner_slider_short_len;

    difference () {

        _innerSlider ( len );
        
        // M3 Befestigung
        translate ( [0, 0, len/2] ) innerSliderHolePair ();
        
    }
    
}

module innerSliderLong ( len = z_side_slide_dim [y] ) {

    difference () {

        _innerSlider ( len );
        
        // M3 Befestigung
        for ( zz = [-36, +36] ) {
            translate ( [0, 0, len/2 + zz] ) innerSliderHolePair ();
        }
        
    }
    
}

