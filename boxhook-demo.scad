include <boxhook.scad>

dim_boxhook = [8,1.2,4];
dim_notch_boxhook = 0.8;

dim_box_inner = [20,15,12]; // inside space
dim_box_thick = 2;
dim_box_outer = dim_box_inner+[dim_box_thick,dim_box_thick,dim_box_thick]*2;

module box()
{
  difference()
  {
    cube(dim_box_outer,center=true);
    cube(dim_box_inner,center=true);
  }
}

module bhdemo()
{
  boxhook(dim=dim_boxhook,notch=dim_notch_boxhook);
}

// side=1 top
// side=-1 bottom
module boxpart(side=1)
{
  // half-cut
  difference()
  {
    box();
    translate([0,0,side*dim_box_outer[2]])
      cube(dim_box_outer*2,center=true);
  }
  // hooks
  translate([0,dim_box_inner[1]/2,dim_boxhook[1]/2])
    boxhook(dim=dim_boxhook,notch=dim_notch_boxhook);
}

// side -1:bottom, 1:top
boxpart(side=1);
