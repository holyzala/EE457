LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

ENTITY seven_segment_cntrl IS
	PORT (input : IN unsigned (2 downto 0);
			seg_a : OUT std_logic;
			seg_b : OUT std_logic;
			seg_c : OUT std_logic;
			seg_d : OUT std_logic;
			seg_e : OUT std_logic;
			seg_f : OUT std_logic;
			seg_g : OUT std_logic);
END seven_segment_cntrl;

ARCHITECTURE LogicFunction OF seven_segment_cntrl IS

BEGIN
	process (input) is
	begin
		case input is
			when "000" =>
				seg_a <= '1';
				seg_b <= '1';
				seg_c <= '1';
				seg_d <= '1';
				seg_e <= '1';
				seg_f <= '1';
				seg_g <= '0';
			when "001" =>
				seg_a <= '0';
				seg_b <= '1';
				seg_c <= '1';
				seg_d <= '0';
				seg_e <= '0';
				seg_f <= '0';
				seg_g <= '0';
			when "010" =>
				seg_a <= '1';
				seg_b <= '1';
				seg_c <= '0';
				seg_d <= '1';
				seg_e <= '1';
				seg_f <= '0';
				seg_g <= '1';
			when "011" =>
				seg_a <= '1';
				seg_b <= '1';
				seg_c <= '1';
				seg_d <= '1';
				seg_e <= '0';
				seg_f <= '0';
				seg_g <= '1';
			when others =>
				seg_a <= '1';
				seg_b <= '0';
				seg_c <= '0';
				seg_d <= '1';
				seg_e <= '1';
				seg_f <= '1';
				seg_g <= '1';
		end case;
	end process;
END LogicFunction;