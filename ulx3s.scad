// Snap-on Screwless Box
// Top and Bottom half snap and lock when pushed together

// PCB

pcb_dim = [37*2.54,20*2.54,1.6];
pcb_pos = [0,2.8,-4]; // from center
pcb_holes_grid = [30,17]*2.54; // assumed center
pcb_hole_dia = 3.2;

// BOX

dim_box_inner = [38*2.54,23*2.54,28.7]; // xyz inside space
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

module connector_cut()
{
  // mounting hole x-position
  //footx = 2*Thick+FootClrX;
  //footy = Thick+FootClrY;
  //cy = 60-8;
  cy = 0;
  if(1)
  translate(pcb_pos+[-pcb_holes_grid[0]/2,dim_box_inner[1]/2+dim_box_thick/2,-8.3])
  {
      // cut off for HDMI
      translate([42.3+0.2,cy,11.5])
        cube([22,10,13],center=true);
      // cut off for AUDIO
      translate([21.47-0.3,cy,11.2+0.5])
        rotate([90,0,0])
          cylinder(d=13.5,h=10,$fn=32,center=true);
      // cut off for 2.5/3.3V jumper
      translate([27.07+2.54,cy,11])
        cube([13,10,7],center=true);
      // cut off for USB1
      translate([8.89+0.2,cy,9.7])
        cube([13,10,9],center=true);
      // cut off for USB2
      translate([67.31+0.2,cy,9.7])
        cube([13,10,9],center=true);
  }    
}

module flatcable_cut()
{
  // flat cable connector spacing between centers
  flatcable_spacing = 35*2.54;
  height=40;
  width=6.8;
  length=57;
  notch=2;
  notch_length=5;
  translate([0,0,0])
  {
    for(i=[-1,1])
      translate([flatcable_spacing*i/2,0,-height/2-0.01])
      {
        cube([width,length,height],center=true);
        translate([-i*notch,0,0])
        cube([width,notch_length,height],center=true);
      }
  }
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
      cube(dim_box_inner+[-30,-23,4*dim_box_thick],center=true);
      sphere(d=dim_box_thick,$fn=32);
    }
    if(1)
    minkowski()
    {
      cube(dim_box_inner+[-35,-7,4*dim_box_thick],center=true);
      sphere(d=dim_box_thick,$fn=32);
    }
    flatcable_cut();
    connector_cut();
  }
}

// side 1:bottom, -1:top
// cut assembly
if(0)
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
if(1)
{
  %pcb_with_parts();
  boxcut(side=1); // top
  boxcut(side=-1); // bottom
}
