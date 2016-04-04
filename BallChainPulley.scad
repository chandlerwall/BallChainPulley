// Parametric ball chain pulley
// Based on "Parametric Ball Pulley" by zignig (http://www.thingiverse.com/thing:1322)
// Various modifications have been incorporated by c@swall.us.

// Quality of cylinders/spheres
$fn = 128;

// Motor dimensions
shaft_diameter = 5.1; // 5 was measured (it was too tight)

// Ball chain dimensions
ball_diameter = 3.20; // 3.22 was measured, 3.20 was remeasured
ball_count = 24;
ball_spacing = 4; // Ball center-to-center, 4 was measured and estimated
link_diameter = 0.68; // 0.68 was measured

// Screw options
screw_diameter = 3.05;
nut_diameter = 6.15; // 6.06 was measaured (increased to 6.15 for ease of assembly)
nut_height = 2.5; // 2.25 was measured (increased to 2.5 for ease of assembly)

// Calculate dimensions
wheel_diameter = ball_count*ball_spacing / PI;
wheel_height = ball_diameter*1.75;
boss_diameter = shaft_diameter + (nut_height*2)*2.5;
boss_height = nut_diameter;
pulley_height = wheel_height + boss_height;

// Render
echo(str("Pulley height: ", pulley_height));
echo(str("Pulley diameter: ", wheel_diameter));

translate ([0, 0, pulley_height/2])
pulley();

// Declarations
module pulley ()
{
	difference()
	{
		cylinder (pulley_height, r = wheel_diameter/2, center=true);
		
		// Boss cutout
		translate ([0, 0, pulley_height/2])
		difference ()
		{
			cylinder (boss_height * 2, r = wheel_diameter, center=true);
			cylinder (boss_height * 4, r = boss_diameter/2, center=true);
		}
		
		// Shaft
		cylinder (pulley_height*2, r = shaft_diameter/2, center=true);
		
		// Holes for links between balls
		translate ([0, 0, pulley_height/-2 + wheel_height/2])
		rotate_extrude (convexity = 10)
		translate ([wheel_diameter/2, 0, 0])
		circle (r = link_diameter/2, center = true, $fn=16);

		// Balls
		translate ([0, 0, pulley_height/-2 + wheel_height/2])
		for (i = [1:ball_count])
		{	
			rotate ([0, 0, (360/ball_count) * i])		
			translate ([wheel_diameter/2,0,0])
			sphere (r = ball_diameter/2, $fn=32);
		}
		
		// Screw and nut holes
		translate ([0, 0, pulley_height/2 - boss_height/2])
		rotate ([0, 0, 360])
		{
			translate ([boss_diameter/2, 0, 0])
			rotate ([0 ,90 , 0])
			cylinder (boss_diameter, r = screw_diameter/2, center = true);
			
			translate ([shaft_diameter/2 + (boss_diameter/2 - shaft_diameter/2)/2 - nut_height/4, 0, 0])
			{
				rotate ([0 , 90, 0])
				cylinder (nut_height, r = nut_diameter/2, center = true, $fn = 6);
				
				translate ([0, 0, boss_height / 2])
				cube ([nut_height, sin(60) * nut_diameter, boss_height], center = true);
			}
		}
	}
}
