LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

ENTITY switch_double_dff IS
	PORT (input : IN STD_LOGIC_VECTOR (9 downto 0);
		clock : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		output : OUT STD_LOGIC_VECTOR(9 downto 0)
	);
			
END switch_double_dff;

ARCHITECTURE LogicFunction OF switch_double_dff IS
	signal first_out : STD_LOGIC_VECTOR (9 downto 0);
BEGIN
	process (input, clock, reset) is
	begin
		if reset = '0' then
			first_out <= (others => '0');
		elsif rising_edge(clock) then
			first_out <= input;
		end if;
	end process;
	
	process (first_out, clock, reset) is
	begin
		if reset = '0' then
			output <= (others => '0');
		elsif rising_edge(clock) then
			output <= first_out;
		end if;
	end process;
END LogicFunction;