set project example_project
set top_module vga_project
set target xc7a35tcpg236-1
set bitstream_file build/${project}.runs/impl_1/${top_module}.bit

proc usage {} {
    puts "usage: vivado -mode tcl -source [info script] -tclargs \[simulation/bitstream/program\]"
    exit 1
}

if {($argc != 1) || ([lindex $argv 0] ni {"simulation" "bitstream" "program"})} {
    usage
}



if {[lindex $argv 0] == "program"} {
    open_hw
    connect_hw_server
    current_hw_target [get_hw_targets *]
    open_hw_target
    current_hw_device [lindex [get_hw_devices] 0]
    refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]

    set_property PROBES.FILE {} [lindex [get_hw_devices] 0]
    set_property FULL_PROBES.FILE {} [lindex [get_hw_devices] 0]
    set_property PROGRAM.FILE ${bitstream_file} [lindex [get_hw_devices] 0]

    program_hw_devices [lindex [get_hw_devices] 0]
    refresh_hw_device [lindex [get_hw_devices] 0]
    
    exit
} else {
    file mkdir build
    create_project ${project} build -part ${target} -force
}

read_xdc {
    constraints/vga_example.xdc
}

read_verilog {
    rtl/vga_project.v
    rtl/vga_timing.v
    rtl/reset.v
    rtl/draw_map.v
    rtl/clk_wiz_0.v
    rtl/clk_wiz_0_clk_wiz.v
    rtl/draw_menu.v
    rtl/base_control.v
    rtl/mouse_130to65.v
    rtl/mouse_image.v
    rtl/pmod_joystick.v
    rtl/clk_5hz.v
    rtl/clk_66_67khz.v
    rtl/pmod_jstk.v
    rtl/spi_ctrl.v
    rtl/spi_mode0.v
    rtl/tank_gen.v
    rtl/tank_oponent.v
    rtl/control.v
    rtl/delay.v
    rtl/delay_op.v
    rtl/draw_tank.v
    rtl/draw_tank_op.v
    rtl/image_tank_up.v
    rtl/image_tank_up_op.v
    rtl/delay_for_draw.v
    rtl/delay_for_draw_op.v
    rtl/gui.v
    rtl/delay_gui.v
    rtl/disp_hex_mux.v
    rtl/mod_m_counter.v
    rtl/uart.v
    rtl/uart_rx.v
    rtl/uart_tx.v
    rtl/register_rxd.v
    rtl/register_txd.v
    rtl/gun_ctrl.v
    rtl/choose_the_image_of_tank.v
    rtl/image_tank_down.v
    rtl/image_tank_left.v
    rtl/image_tank_right.v
    rtl/opponent_bullet.v
    rtl/choose_image_tank_op.v
    rtl/image_tank_down_op.v
    rtl/image_tank_right_op.v
    rtl/image_tank_left_op.v
    rtl/hp_state.v
    rtl/end_game.v
    rtl/image_lose.v
    rtl/image_win.v
    rtl/choose_image_of_end_game.v
    rtl/image_menu.v
    rtl/draw_image_menu.v
}

add_files* {
   rtl/image_tank_up.data
   rtl/image_dirop_up.data
   rtl/image_dir_down.data
   rtl/image_dir_left.data
   rtl/image_dir_right.data
   rtl/image_dirop_down.data
   rtl/image_dirop_left.data
   rtl/image_dirop_right.data
   rtl/lose.data
   rtl/win.data
   rtl/menu_start.data
}

read_vhdl {
    rtl/Ps2Interface.vhd
    rtl/MouseCtl.vhd
}

add_files -fileset sim_1 {
    sim/testbench.v
    sim/tiff_writer.v
}

set_property top ${top_module} [current_fileset]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

if {[lindex $argv 0] == "simulation"} {
    launch_simulation
    start_gui
} else {
    launch_runs synth_1 -jobs 8
    wait_on_run synth_1

    launch_runs impl_1 -to_step write_bitstream -jobs 8
    wait_on_run impl_1
    exit
}
