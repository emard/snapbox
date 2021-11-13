include <boxhook.scad>

dim_boxhook = [8,1.2,5];
dim_notch_boxhook = 0.7;
dim_depth_boxhook = [0.3,0.3,2];
dim_hook_clr = [0.2,0.2,0.2]; // added to cut
dim_notch_clr = 0.2;

dim_box_inner = [20,15,12]; // inside space
dim_box_thick = 2;
dim_box_outer = dim_box_inner+[dim_box_thick,dim_box_thick,dim_box_thick]*2;
dim_box_round = 3;

dim_step_cut = [0.5,dim_depth_boxhook[1]+dim_hook_clr[1]/2+0.01]; // depth, inside width
dim_step_cut_clr = [0.2,0.2]; // depth, inside width

module box()
{
  difference()
  {
    minkowski()
    {
      cube(dim_box_outer-[dim_box_round,dim_box_round,dim_box_round],center=true);
      sphere(d=dim_box_round,$fn=32);
    }
    minkowski()
    {
      cube(dim_box_inner-[dim_box_round,dim_box_round,dim_box_round]/2,center=true);
      sphere(d=dim_box_round/2,$fn=32);
    }
    cube(dim_box_inner+[-dim_box_thick*2,-dim_box_thick*2,4*dim_box_thick],center=true);
  }
}

module step_fit(cut=0)
{
  inside_round=dim_box_round/2+dim_box_round/2*dim_step_cut[1]/dim_box_thick;
  translate([0,0,-dim_step_cut_clr[0]])
    linear_extrude(dim_step_cut[0])
    difference()
    {
      minkowski()
      {
          square([dim_box_outer[0],dim_box_outer[1]]-[dim_box_round,dim_box_round],center=true);
          circle(d=dim_box_round,$fn=32);
      }
      if(1)
      minkowski()
      {
          square([dim_box_inner[0],dim_box_inner[1]]+[dim_step_cut[1],dim_step_cut[1]]*2-[inside_round,inside_round],center=true);
          circle(d=inside_round,$fn=32);
      }
  }
}

module hooks(cut=0)
{
      // hooks x
      for(i=[-1,1])
        translate([i*dim_box_inner[0]/2-i*dim_boxhook[1]/2+i*dim_depth_boxhook[0],0,-dim_boxhook[2]/2+dim_depth_boxhook[2]])
          rotate([0,0,-90*i])
          rotate([0,180,0])
            boxhook(dim=dim_boxhook,notch=dim_notch_boxhook,dim_add=cut*dim_hook_clr,notch_add=cut*dim_notch_clr);
      // hooks y
      for(i=[-1,1])
        translate([0,i*dim_box_inner[1]/2-i*dim_boxhook[1]/2+i*dim_depth_boxhook[1],-dim_boxhook[2]/2+dim_depth_boxhook[2]])
          rotate([0,0,90-90*i])
          rotate([0,180,0])
            boxhook(dim=dim_boxhook,notch=dim_notch_boxhook,dim_add=cut*dim_hook_clr,notch_add=cut*dim_notch_clr);
}

// side=1 top
// side=-1 bottom
module boxpart(side=1)
{
  // half-cut
  difference()
  {
    union()
    {
      difference()
      {
        box();
        //step_fit();
        translate([0,0,-side*dim_box_outer[2]])
          cube(dim_box_outer*2,center=true);
      }
      //step_fit();
    }
    if(side < 0)
      hooks(cut=1);
  }
  if(side > 0)
    hooks(cut=0);
}

// side 1:bottom, -1:top
// cut assembly
if(0)
difference()
{
    union()
    {
      boxpart(side=1); // top
      boxpart(side=-1); // bpt
    }
  translate([0,10,0])
    cube([30,20,30],center=true);
}

// šromtomg
if(1)
{
  boxpart(side=1); // top
  boxpart(side=-1); // bottom
}
