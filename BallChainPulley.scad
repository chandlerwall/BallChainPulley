// Parametric ball chain pulley
// Based on "Parametric Ball Pulley" by zignig (http://www.thingiverse.com/thing:1322)
// Various modifications have been incorporated by c@swall.us.

// Quality of cylinders/spheres
$fn = 128;
part_spacing = 10;

// Motor dimensions
shaft_diameter = 5.2; // 5 was measured (it was too tight)

// Ball chain dimensions
ball_diameter = 3.30; // 3.22 was measured, 3.20 was remeasured (3.3 is used for more "connected" operation)
ball_count = 24;
ball_spacing = 4; // Ball center-to-center, 4 was measured and estimated
link_diameter = 0.68; // 0.68 was measured

// Screw and nut dimensions
screw_diameter = 3.05;
nut_diameter = 6.15; // 6.06 was measaured (increased to 6.15 for ease of assembly)
nut_height = 2.5; // 2.25 was measured (increased to 2.5 for ease of assembly)

// Flare dimensions
flare_height = 1.75;
flare_lip_height = flare_height * 1/8;
flare_angle = 35;


// Pulley calculations
wheel_diameter = ball_count * ball_spacing/PI;
wheel_height = ball_diameter * 1.1;
flared_wheel_height = wheel_height + 2 * (flare_height + flare_lip_height);
boss_diameter = shaft_diameter + (nut_height * 2) * 2.5;
boss_height = nut_diameter;
pulley_height = flared_wheel_height + boss_height;


// Diagnostic output
echo(str("Pulley height: ", pulley_height));
echo(str("Pulley diameter: ", wheel_diameter));


// Render
pulley();

// Module declarations
module pulley()
{
    difference()
    {
        union()
        {
            pulleyWheel();
            
            translate([0, 0, flared_wheel_height])
            pulleyBoss();
        }

        // Motor shaft
        cylinder(h = pulley_height * 2, r = shaft_diameter/2, center=true);

        // Screw and nut holes
        translate([0, 0, flared_wheel_height])
        {
            translate([boss_diameter/2, 0, 0])
            rotate([0 ,90 , 0])
            cylinder(h = boss_diameter, r = screw_diameter/2, center = true);
            
            translate([shaft_diameter/2 + (boss_diameter/2 - shaft_diameter/2)/2 - nut_height/4, 0, 0])
            {
                rotate([0 , 90, 0])
                cylinder(h = nut_height, r = nut_diameter/2, center = true, $fn = 6);
                
                translate([0, 0, boss_height / 2])
                cube([nut_height, sin(60) * nut_diameter, boss_height], center = true);
            }
        }
    }
}

module pulleyBoss()
{
    cylinder(boss_height, r = boss_diameter/2, center=true);
}

module pulleyWheel()
{
    difference()
    {
        union()
        {
            // Top flare
            translate([0, 0, wheel_height/2 + flare_height/2])
            pulleyFlare();

            // Wheel
            cylinder(wheel_height, r = wheel_diameter/2, center=true);

            // Bottom flare
            translate([0, 0, -(wheel_height/2 + flare_height/2)])
            mirror([0, 0, 1])
            pulleyFlare();
        }

        // Ball links
        rotate_extrude(convexity = 10)
        translate([wheel_diameter/2, 0, 0])
        circle(r = link_diameter/2, center = true, $fn = 16);

        // Balls
        translate([0, 0, 0])
        for(i = [1:ball_count])
        {
            rotate([0, 0,(360/ball_count) * i])
            translate([wheel_diameter/2, 0, 0])
            sphere(r = ball_diameter/2, $fn = 32);
        }
    }
}

module pulleyFlare()
{
    hull()
    {
        translate([0, 0, flare_height])
        cylinder(h = flare_lip_height, r = wheel_diameter/2 + flare_height/tan(90 - flare_angle), center = true);
        
        cylinder(h = flare_height, r = wheel_diameter/2, center = true);
    }
}
