include <boxhook.scad>

dim_boxhook = [8,1.2,5]; // xyz
dim_notch_boxhook = 0.7;
dim_depth_boxhook = [0.3,0.3,2]; // xyz
dim_hook_clr = [0.3,0.3,0.2]; // xyz added to cut for clearance
dim_notch_clr = 0.2; // diameter clearance

dim_box_inner = [20,15,12]; // xyz inside space
dim_box_thick = 2;
dim_box_outer = dim_box_inner+[dim_box_thick,dim_box_thick,dim_box_thick]*2; // xyz outer dim
dim_box_round = 3;

dim_step_cut = [0.7,0.8]; // depth, inside width
dim_step_cut_clr = [0.5,0.5]; // depth, inside width clearance

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

module step_fit_inner(cut=0)
{
  inside_round=dim_box_round/2+dim_box_round/2*dim_step_cut[1]/dim_box_thick;
  translate([0,0,-dim_step_cut[0]-cut*dim_step_cut_clr[0]/2+0.01])
    linear_extrude(dim_step_cut[0]+cut*dim_step_cut_clr[0]/2)
    difference()
    {
      minkowski()
      {
          square([dim_box_inner[0],dim_box_inner[1]]+[dim_step_cut[1],dim_step_cut[1]]*2+cut*[dim_step_cut_clr[1],dim_step_cut_clr[1]]-[inside_round,inside_round],center=true);
          circle(d=inside_round,$fn=32);
      }
      minkowski()
      {
          square([dim_box_inner[0],dim_box_inner[1]]-[dim_box_round,dim_box_round]/2,center=true);
          circle(d=dim_box_round/2-0.01,$fn=32);
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
    box();
    translate([0,0,-side*dim_box_outer[2]])
      cube(dim_box_outer*2,center=true);
    if(side < 0)
    {
      hooks(cut=1);
      step_fit_inner(cut=1);
    }
  }
  if(side > 0)
  {
    hooks(cut=0);
    step_fit_inner(cut=0);
  }
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
