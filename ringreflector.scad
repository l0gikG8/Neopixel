// compatible with OpenSCAD version 2014.03+ due to 'faces' parameter in polyhedron 

refl_d = 48;		//reflector diameter
refl_t = 1.5;		//reflector wall thickness
refl_h = 22;		//reflector wall height
refl_s = 2;			//space for wiring between ring and next reflector

ring_od = 37;		//LED ring outer diameter
ring_id = 23;		//LED ring inner diameter
ring_h = 4;			//LED ring height
ring_n = 12;		//number of LEDs on ring

tol = 0.98;			//tolerance

main();

module main() {
	difference() {
		union() {
			base_plate();
			core();
			fins();
		}
		shaft();
		cutouts();
	}
}

module base_plate() {
	cylinder (d=refl_d, h=refl_t, $fn=100);
}

module core() {
	cylinder (d=ring_id*tol, h=refl_h+ring_h, $fn=100);
}

module shaft() {
	translate([0,0,-0.5]) cylinder (d=ring_id-2*refl_t, h=refl_h+ring_h+1, $fn=100);
}

module fins() {
	for (i = [1:ring_n]) {
		rotate([0,0,i * 360 / ring_n]) translate([0 , refl_d/2, 0])
			fin(x=refl_t, y1=(refl_d-ring_id)/2, z1=refl_h, y2=(refl_d-ring_od)/2, z2=ring_h+refl_s);
	}
}

module fin(x, y1, z1, y2, z2) {
	union() {
		translate ([ 0, -y1/2, z1   /2 ]) cube( size=[ x, y1, z1 ], center = true);
		translate ([ 0, -y2/2, z1+z2/2 ]) cube( size=[ x, y2, z2 ], center = true);
		translate ([ 0, -y2/2, z1+z2   ]) roof( width=x*tol, length=y2*tol );
	}
}

module roof (width, length) {
	s=width/2;
	l=length/2;
	polyhedron(  points=[ [s,l,0],[s,-l,0],[-s,-l,0],[-s,l,0],[0,l-s,s],[0,-l+s,s] ],
			        faces=[ [0,1,5,4],[1,2,5],[2,3,4,5],[3,0,4],[1,0,3,2] ] );
}

module cutouts() {
	for (i = [1:ring_n]) {
		rotate([ 0, 0, i * 360 / ring_n ]) 
			translate ([ 0, refl_d/2-(refl_d-ring_od)/4, -0.01 ]) 
				roof( width=refl_t/2, length=(refl_d-ring_od)/2 );
	}
}
