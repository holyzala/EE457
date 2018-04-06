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
	SIGNAL started : STD_LOGIC;

BEGIN
	PROCESS (clk, stop, start)
		VARIABLE done_flg : STD_LOGIC;
	BEGIN
		done_flg := donesig or donesig2 or donesig3;
		IF start = '1' THEN
			IF started = '0' THEN
				done_flg := '1';
			END IF;
		END IF;
		IF stop = '1' THEN
			if current_state = idle then
				current_state <= idle;
			else
				current_state <= drain;
			end if;
		elsif rising_edge(clk) THEN
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
		started <= '1';
		if switches = "01" then
			CASE current_state IS
				WHEN idle =>
					started <= '0';
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
					started <= '0';
					next_state <= idle;
			END CASE;
			
		elsif switches = "10" then
			CASE current_state IS
				WHEN idle =>
					started <= '0';
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
					started <= '0';
					next_state <= idle;			
			END CASE;
		
		else
			started <= '0';
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