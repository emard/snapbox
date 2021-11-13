// Snap-on Screwless Box
// Top and Bottom half snap and lock when pushed together

// PCB

pcb_dim = [20,18,1.6];
pcb_pos = [0,0,-4]; // from center
pcb_holes_grid = [16,14];
pcb_hole_dia = 2.2;

// BOX

dim_box_inner = [21,19,12]; // xyz inside space
dim_box_thick = 2;
dim_box_outer = dim_box_inner+[dim_box_thick,dim_box_thick,dim_box_thick]*2; // xyz outer dim
dim_box_round = 3;
dim_box_split = 1; // split line 0:half +:to top -:to bottom

dim_boxhook = [8,1.2,5]; // xyz hook size
dim_pos_boxhook = [0,0]; // xy from center (2 hooks at each side, total 8 hooks), if zero, then 4 hooks
dim_notch_boxhook = 0.7; // hook notch dia
dim_depth_boxhook = [0.3,0.3,2]; // xyz hook depth
dim_hook_clr = [0.3,0.3,0.4]; // xyz added to cut for clearance
dim_notch_clr = 0.3; // added to diameter for clearance

dim_step_cut = 1*[0.9,0.9]; // [depth, inside_width]
dim_step_cut_clr = 1*[0.6,0.6]; // [depth, inside_width] clearance

// PCB columns
pcb_col_top_dia = [4,5]; // top col: top,bot dia
pcb_col_bot_dia = [4,5]; // bot col: top,bot dia
pcb_col_clr = 0.4; // pcb col clearance
pcb_col_pin_dim = [2,2.4]; // pin dia,height
pcb_col_pin_clr = [0.5,0.5]; // pin dia,height clearance

include <snapbox.scad>

module boxcut(side=1)
{
  difference()
  {
    boxpart(side);
    // cut for print time saving
    minkowski()
    {
      cube(dim_box_inner+[-dim_box_thick*5,-dim_box_thick*5,4*dim_box_thick],center=true);
      sphere(d=dim_box_thick,$fn=32);
    }
  }
}

// side 1:bottom, -1:top
// cut assembly
if(0)
difference()
{
  %pcb();
  union()
  {
      boxcut(side=1); // top
      boxcut(side=-1); // bpt
  }
  if(1)
  rotate([0,0,0])
  translate([0,10,0])
    cube([40,20,40],center=true);
  if(0)
  translate([0,0,10.5])
    cube([40,40,20],center=true);
}

// 3D print
if(1)
{
  boxcut(side=1); // top
  boxcut(side=-1); // bottom
}
