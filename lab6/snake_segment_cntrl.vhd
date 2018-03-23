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
	process (input, mask) is
		variable masked: unsigned(15 downto 0);
		variable temp: std_logic_vector(6 downto 0) := "0000000";
	begin
		masked := input and mask;
		IF masked(0) = '1' OR masked(15) = '1' OR masked(14) = '1' OR masked(13) = '1' THEN
			temp := input(0) & "00" & input(13) & input(14) & input(15) & '0';
		ELSIF masked(1) = '1' OR masked(12) = '1' THEN
			temp := input(1) & "00" & input(12) & "000";
		ELSIF masked(2) = '1' OR masked(11) = '1' THEN
			temp := input(2) & "00" & input(11) & "000";
		ELSIF masked(3) = '1' OR masked(10) = '1' THEN
			temp := input(3) & "00" & input(10) & "000";
		ELSIF masked(4) = '1' OR masked(9) = '1' THEN
			temp := input(4) & "00" & input(9) & "000";
		ELSIF masked(5) = '1' OR masked(6) = '1' OR masked(7) = '1' or masked(8) = '1' THEN
			temp := input(5) & input(6) & input(7) & input(8) & "000";
		ELSE
			temp := "0000000";
		END IF;
		output <= temp;
	end process;
END LogicFunction;