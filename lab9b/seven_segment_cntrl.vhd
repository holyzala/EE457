LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

ENTITY seven_segment_cntrl IS
	PORT (input : IN STD_LOGIC_VECTOR (3 downto 0);
			seg_a : OUT STD_LOGIC_VECTOR(6 downto 0));
			
END seven_segment_cntrl;

ARCHITECTURE LogicFunction OF seven_segment_cntrl IS

-- Simple seven segment controller that takes a 4 bit binary number and converts it to
-- a single hexadecimal number display
BEGIN
	process (input) is
	begin
		case input is
			-- 0
			when "0000" =>
				seg_a <= "1000000";
			-- 1
			when "0001" =>
				seg_a <= "1111001";
			-- 2
			when "0010" =>
				seg_a <= "0100100";
			-- 3
			when "0011" =>
				seg_a <= "0110000";
			-- 4
			when "0100" =>
				seg_a <= "0011001";
			-- 5
			when "0101" =>
				seg_a <= "0010010";
			-- 6
			when "0110" =>
				seg_a <= "0000010";
			-- 7
			when "0111" =>
				seg_a <= "1111000";
			-- 8
			when "1000" =>
				seg_a <= "0000000";
			-- 9
			when "1001" =>
				seg_a <= "0010000";
			-- A
			when "1010" =>
				seg_a <= "0001000";
			-- B
			when "1011" =>
				seg_a <= "0000011";
			-- C
			when "1100" =>
				seg_a <= "1000110";
			-- D
			when "1101" =>
				seg_a <= "0100001";
			-- E
			when "1110" =>
				seg_a <= "0000110";
			-- F
			when "1111" =>
				seg_a <= "0001110";
			-- Unknown, show nothing
			when others =>
				seg_a <= "1111111";
		end case;
	end process;
END LogicFunction;