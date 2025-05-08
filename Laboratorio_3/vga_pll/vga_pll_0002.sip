set_global_assignment -entity "vga_pll_0002" -library "lib_vga_pll_0002" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "vga_pll_0002" -library "lib_vga_pll_0002" -name IP_TOOL_VERSION "22.1"
set_global_assignment -entity "vga_pll_0002" -library "lib_vga_pll_0002" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_vga_pll_0002" -name SPD_FILE [file join $::quartus(sip_path) "vga_pll_0002.spd"]

set_global_assignment -library "lib_vga_pll_0002" -name MISC_FILE [file join $::quartus(sip_path) "vga_pll_0002_sim/vga_pll_0002.vo"]
