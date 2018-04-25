set_global_assignment -entity "clockb_pll" -library "lib_clockb_pll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "clockb_pll" -library "lib_clockb_pll" -name IP_TOOL_VERSION "17.1"
set_global_assignment -entity "clockb_pll" -library "lib_clockb_pll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_clockb_pll" -name SPD_FILE [file join $::quartus(sip_path) "clockb_pll.spd"]

set_global_assignment -library "lib_clockb_pll" -name MISC_FILE [file join $::quartus(sip_path) "clockb_pll_sim/clockb_pll.vho"]
