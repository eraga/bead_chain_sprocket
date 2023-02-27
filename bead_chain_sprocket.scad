// this is rework of
// https://www.thingiverse.com/thing:38006


function bead_chain_sprocket_name(type) = type[0];
function bead_chain_sprocket_link_len(type) = type[1];
function bead_chain_sprocket_ball_radius(type) = type[2];
function bead_chain_sprocket_n_teeth(type) = type[3];
function bead_chain_sprocket_link_radius(type) = type[4];

function bead_chain_sprocket_radius(type) =
        bead_chain_sprocket_n_teeth(type) *
        (bead_chain_sprocket_ball_radius(type) * 2 + bead_chain_sprocket_link_len(type)) /
        PI / 2;



function bead_chain_sprocket_h(type) = bead_chain_sprocket_ball_radius(type) * 2 * (1 + .25 + .2 );


module make_sphere_ring(ring_radius, sphere_radius, num_spheres) {
    union(){
        for (i = [0:num_spheres]){
            rotate([0,0,i*360/num_spheres])
                translate([ring_radius,0,0])hull() {
                    sphere(sphere_radius);
                    translate([-.5 * sphere_radius,0,0])sphere(sphere_radius);
                    translate([0,0,.25 * sphere_radius])sphere(sphere_radius);
                    translate([0,0,-.25 * sphere_radius])sphere(sphere_radius);
                }
        }
    }
}

module make_torus(ring_radius, inner_radius) {
    // openscad apparently can't handle rotate_extrude in a difference, so this isn't a real cylinder
    /*rotate_extrude(convexity=10)translate([ring_radius, 0, 0])circle(inner_radius);*/
    difference() {
        cylinder (
        h = inner_radius*2,
        r = ring_radius,
        center = true);
        cylinder (
        h = inner_radius * 2,
        r = ring_radius - 2*inner_radius,
        center = true);
    }
}

module bead_chain_ring(type) {
    r = bead_chain_sprocket_radius(type);
    ball_radius = bead_chain_sprocket_ball_radius(type);
    n_teeth = bead_chain_sprocket_n_teeth(type);
    link_radius = bead_chain_sprocket_link_radius(type);

    union() {
        make_sphere_ring(r, ball_radius, n_teeth);
        make_torus(r+.2, link_radius);
    }
}
module bead_chain_sprocket_half(type, $fn = 21) {
    r = bead_chain_sprocket_radius(type);
    h = bead_chain_sprocket_h(type);


    difference() {
        union() {
            translate([0,0,-h/4])
                cylinder(h=h/2, r=r, center=true, $fn = bead_chain_sprocket_n_teeth(type));
        }

        bead_chain_ring(type);
    }
}
