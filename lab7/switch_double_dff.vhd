LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

ENTITY switch_double_dff IS
	generic (
		wide : positive -- how many bits is the counter
	);
	PORT (input : IN STD_LOGIC_VECTOR (wide-1 downto 0);
		clock : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		output : OUT STD_LOGIC_VECTOR(wide-1 downto 0)
	);
			
END switch_double_dff;

-- Double D Flip Flop
ARCHITECTURE LogicFunction OF switch_double_dff IS
	-- Output from the first D Flip Flop
	signal first_out : STD_LOGIC_VECTOR (wide-1 downto 0);
BEGIN
	-- First D Flip Flop
	process (input, clock, reset) is
	begin
		if reset = '0' then
			first_out <= (others => '0');
		elsif rising_edge(clock) then
			first_out <= input;
		end if;
	end process;
	
	-- Second D Flip Flop
	process (first_out, clock, reset) is
	begin
		if reset = '0' then
			output <= (others => '0');
		elsif rising_edge(clock) then
			output <= first_out;
		end if;
	end process;
END LogicFunction;