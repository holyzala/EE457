LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

ENTITY snake_segment_cntrl IS
	PORT (input : IN unsigned (15 downto 0);
		mask : IN unsigned(15 downto 0);
		output :out std_logic_vector(6 downto 0));
END Entity snake_segment_cntrl;

ARCHITECTURE LogicFunction OF snake_segment_cntrl IS

BEGIN
	process (input, mask) IS
		variable masked: unsigned(15 downto 0);
	begin
		masked := input and mask;
		IF masked(15) = '1' OR masked(0) = '1' OR masked(1) = '1' OR masked(2) = '1' THEN
			output <= input(15) & "00" & input(2) & input(1) & input(0) & '0';
		ELSIF masked(14) = '1' OR masked(3) = '1' THEN
			output <= input(14) & "00" & input(3) & "000";
		ELSIF masked(13) = '1' OR masked(4) = '1' THEN
			output <= input(13) & "00" & input(4) & "000";
		ELSIF masked(12) = '1' OR masked(5) = '1' THEN
			output <= input(12) & "00" & input(5) & "000";
		ELSIF masked(11) = '1' OR masked(6) = '1' THEN
			output <= input(11) & "00" & input(6) & "000";
		ELSIF masked(10) = '1' OR masked(9) = '1' OR masked(8) = '1' or masked(7) = '1' THEN
			output <= input(10) & input(9) & input(8) & input(7) & "000";
		ELSE
			output <= "0000000";
		END IF;
	end process;
END LogicFunction;