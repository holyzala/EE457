LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;


ENTITY washing_controller IS
	PORT(
		-- Declare control inputs
		sw0, sw1 : IN STd_LOgIC;
		clk : IN STD_LOGIC;
		-- done signal from the lower states
		start : IN STD_LOGIC;
		donesig : IN STD_LOGIC;
		donesig2 : IN STD_LOGIC;
		donesig3 : IN STD_LOGIC;
		
		-- key 0
		stop : IN STD_LOGIC;
		
		-- output bit vector representing the states
		state_out : OUT STD_LOGIC_VECTOR (2 downto 0);
		reset_out : OUT STD_LOGIC
	);

END ENTITY washing_controller;

-- Begin Architecture
ARCHITECTURE Logic of washing_Controller IS

	TYPE state_type IS (idle, fill, wash, spin, drain, drain1, rinse, fill2);

	SIGNAL current_state: state_type;
	SIGNAL next_state: state_type;
	-- Determine if we're in the middle of a wash cycle
	SIGNAL running : STD_LOGIC;

BEGIN
	PROCESS (clk, stop, start)
		-- stores the done state of lower cycles to determine if we move to the next state
		VARIABLE done_flg : STD_LOGIC;
	BEGIN
		-- Get the lower state machine statuses (if any are done move state)
		done_flg := donesig or donesig2 or donesig3;
		-- Check if the start button has been pushed
		IF start = '1' THEN
			-- If we're already running, do nothing
			IF running = '0' THEN
				-- Otherwise we want to move to the next state
				done_flg := '1';
			END IF;
		END IF;
		-- If the stop button is pressed we want to go to idle
		IF stop = '1' THEN
			if current_state = idle then
				current_state <= idle;
			-- If we aren't already in idle we have to go through drain first
			else
				current_state <= drain;
			end if;
		elsif rising_edge(clk) THEN
			-- Instead of turning the counters on and off we just reset them all every time
			-- we change states, that way every sub state starts with a fresh counter state
			if done_flg = '1' THEN
				reset_out <= '1';
				current_state <= next_state;
			else
				reset_out <= '0';
			end if;
		end if;
	END Process;

	
	outer_state: Process (sw0, sw1, current_state)
		 
		VARIABLE switches :STD_LOGIC_VECTOR(1 downto 0);
		
	BEGIN
		switches := sw1 & sw0;
		-- default is assume we are running, set to 0 when we aren't
		running <= '1';
		-- switches determine the two different wash cycles
		if switches = "01" then
			CASE current_state IS
				WHEN idle =>
					running <= '0';
					next_state <= fill;
				WHEN fill =>
					next_state <= wash;
				WHEN wash =>
					next_state <= drain1;
				WHEN drain1 => 
					next_state <= fill2;
				WHEN fill2 =>
					next_state <= rinse;
				WHEN rinse =>
					next_state <= spin;
				WHEN spin =>
					next_state <= drain;
				WHEN drain =>
					next_state <= idle;
				WHEN OTHERS =>
					running <= '0';
					next_state <= idle;
			END CASE;
			
		elsif switches = "10" then
			CASE current_state IS
				WHEN idle =>
					running <= '0';
					next_state <= fill;
				WHEN fill =>
					next_state <= wash;
				WHEN wash =>
					next_state <= spin;
				WHEN spin =>
					next_state <= drain;
				WHEN drain =>
					next_state <= idle;
				WHEN OTHERS =>
					running <= '0';
					next_state <= idle;			
			END CASE;
		-- any other switch state means it's not a valid input
		else
			running <= '0';
			next_state <= idle;
		end if;
		
	END Process;
	
	Process (current_state)
	Begin
		-- use a 3 bit vector to represent states to pass them to the inner state machines
		CASE current_state IS
			WHEN idle =>
				state_out <= "000";
			WHEN fill =>
				state_out <= "001";
			WHEN fill2 =>
				state_out <= "001";
			WHEN wash =>
				state_out <= "010";
			WHEN rinse =>
				state_out <= "010";
			WHEN drain =>
				state_out <= "011";
			WHEN drain1 =>
				state_out <= "011";
			WHEN spin =>
				state_out <= "100";
			WHEN OTHERS =>
				state_out <= "000";
		END CASE;
	END PROCESS;
	
END Logic;