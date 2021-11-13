module boxhook(dim=[10,1.2,10],notch=0.8)
{
  cube(dim,center=true);
  translate([0,dim[1]/2,dim[2]/2-notch/2])
    rotate([0,90,0])
      cylinder(d=notch,h=dim[0],$fn=32,center=true);
}
