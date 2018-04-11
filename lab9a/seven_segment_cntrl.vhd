LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

ENTITY seven_segment_cntrl IS
	PORT (input : IN STD_LOGIC_VECTOR (3 downto 0);
			seg_a : OUT STD_LOGIC_VECTOR(6 downto 0));
			
END seven_segment_cntrl;

ARCHITECTURE LogicFunction OF seven_segment_cntrl IS

BEGIN
	process (input) is
	begin
		case input is
			when "0000" =>
				seg_a <= "1000000";
			when "0001" =>
				seg_a <= "1111001";
			when "0010" =>
				seg_a <= "0100100";
			when "0011" =>
				seg_a <= "0110000";
			when "0100" =>
				seg_a <= "0011001";
			when "0101" =>
				seg_a <= "0010010";
			when "0110" =>
				seg_a <= "0000010";
			when "0111" =>
				seg_a <= "1111000";
			when "1000" =>
				seg_a <= "0000000";
			when "1001" =>
				seg_a <= "0010000";
			when "1010" =>
				seg_a <= "0001000";
			when "1011" =>
				seg_a <= "0000011";
			when "1100" =>
				seg_a <= "1000110";
			when "1101" =>
				seg_a <= "0100001";
			when "1110" =>
				seg_a <= "0000110";
			when "1111" =>
				seg_a <= "0001110";
			when others =>
				seg_a <= "1111111";

		end case;
	end process;
END LogicFunction;