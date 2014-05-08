// compatible with OpenSCAD version 2014.03+ due to 'faces' parameter in polyhedron 

refl_d = 48;		//reflector diameter
refl_t = 2;			//reflector wall thickness
refl_h = 20;		//reflector wall height
refl_s = 3;			//space for wiring between ring and next reflector

ring_od = 37;		//LED ring outer diameter
ring_id = 23;		//LED ring inner diameter
ring_h = 7;			//LED ring height
ring_n = 12;		//number of LEDs on ring

tol = 0.98;			//tolerance

difference() {
	union() {
		cylinder (d=refl_d, h=refl_t, $fn=100);
		cylinder (d=ring_id*tol, h=refl_h+ring_h, $fn=100);
		for (i = [1:ring_n]) {
			assign (rotation = i * 360 / ring_n) {
				rotate([0,0,rotation]) translate ([0,refl_d/4,refl_h/2]) cube(size=[refl_t,refl_d/2,refl_h], center = true);
				rotate([0,0,rotation]) translate ([0,refl_d/2-(refl_d-ring_od)/4,refl_h+(ring_h+refl_s)/2]) cube(size=[refl_t,(refl_d-ring_od)/2,ring_h+refl_s], center = true);
				rotate([0,0,rotation]) translate ([0,refl_d/2-(refl_d-ring_od)/4,refl_h+ring_h+refl_s]) pyramid(refl_t/2*tol);
			}
		}
	}
	translate([0,0,-0.5]) cylinder (d=ring_id-2*refl_t, h=refl_h+ring_h+1, $fn=100);
	for (i = [1:ring_n]) {
			#rotate([ 0, 0, i * 360 / ring_n ]) translate ([ 0, refl_d/2-(refl_d-ring_od)/4, -0.01 ]) pyramid(refl_t/2);
	}
}
	
module pyramid (s) {
	polyhedron(  points=[ [s,s,0],[s,-s,0],[-s,-s,0],[-s,s,0],[0,0,s] ],
			        faces=[ [0,1,4],[1,2,4],[2,3,4],[3,0,4],[1,0,3],[2,1,3] ] );
}
