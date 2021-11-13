// Snap-on Screwless Box
// Top and Bottom half snap and lock when pushed together

// PCB

pcb_dim = [37*2.54,20*2.54,1.6];
pcb_pos = [0,2.8,-4]; // from center
pcb_holes_grid = [30,17]*2.54; // assumed center
pcb_hole_dia = 3.2;

// BOX

dim_box_inner = [39*2.54,23*2.54,28.7]; // xyz inside space
dim_box_thick = 2;
dim_box_outer = dim_box_inner+[dim_box_thick,dim_box_thick,dim_box_thick]*2; // xyz outer dim
dim_box_round = 3;
dim_box_split = 0; // split line 0:half +:to top -:to bottom

dim_boxhook = [10,1.2,5]; // xyz hook size
dim_pos_boxhook = [37,18]; // xy from center (2 hooks at each side, total 8 hooks), if zero, then 4 hooks
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
pcb_col_pin_dim = [3,2.8]; // pin dia,height
pcb_col_pin_clr = [0.5,0.5]; // pin dia,height clearance

include <snapbox.scad>

module pcb_with_parts()
{
  pcb();
  // esp32
  dim_esp32=[18,31.4,0.8];
  pos_esp32=[-pcb_dim[0]/2+dim_esp32[0]/2+14.22,-6.3,0];
  translate(pcb_pos+[0,-pcb_dim[1]/2+dim_esp32[1]/2,-pcb_dim[2]/2-dim_esp32[2]/2]+pos_esp32)
    cube(dim_esp32,center=true);
  dim_st7789=[20,20,1];
  pos_st7789=[0,0,17];
  translate(pcb_pos+pos_st7789)
    cube(dim_st7789,center=true);
  pin_dim=[0.5,0.5,12];
  for(k=[-1,1]) // sides
    for(i=[-0.5,0.5]) // 2 pin rows
      for(j=[0:19]) // each pin
        translate(pcb_pos+[(17.5*k+i)*2.54,(j-9.5)*2.54,-4])
          cube(pin_dim,center=true);
    
}

module boxcut(side=1)
{
  difference()
  {
    boxpart(side);
    // cut for print time saving
    translate([0,3,0])
    minkowski()
    {
      cube(dim_box_inner+[-7,-23,4*dim_box_thick],center=true);
      sphere(d=dim_box_thick,$fn=32);
    }
    minkowski()
    {
      cube(dim_box_inner+[-30,-7,4*dim_box_thick],center=true);
      sphere(d=dim_box_thick,$fn=32);
    }    
  }
}

// side 1:bottom, -1:top
// cut assembly
if(1)
difference()
{
  %pcb_with_parts();
  union()
  {
      boxcut(side=1); // top
      boxcut(side=-1); // bpt
  }
  if(1)
  rotate([0,0,0])
  translate([0,100,0])
    cube([200,200,200],center=true);
  if(0)
  translate([0,0,10.5])
    cube([40,40,20],center=true);
}

// 3D print
if(0)
{
  %pcb_with_parts();
  boxcut(side=1); // top
  boxcut(side=-1); // bottom
}
