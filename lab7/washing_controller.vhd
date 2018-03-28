LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;


ENTITY washing_controller IS
	-- Declare control inputs
	sw0, sw1 : IN STd_LOgIC;
	nextGo : IN STD_LOGIC; --Second has passed
	stop : IN STD_LOGIC;
	


END ENTITY washing_controller;

-- Begin Architecture
ARCHITECTURE Logic of washing_Controller IS
BEGIN
	
	TYPE state_type IS (idle, running, drain, stop);
	
	SIGNAL current_state: state_type;
	SIGNAL next_state: state_type;
	
	
	Process (clk, stop)
	BEGIN
		if stop = '1' THEN
			head_state <= stop;
		elsif rising_edge(clk) THEN
			if nextGo = '1' THEN
				current_state <= next_state;
			end if;
		end if;
	END Process;
	
	
	outer_state: Process
	
	
	END Process;
	
	

	inner_state: Process
	
	
	END Process;

END Logic;