LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

ENTITY snake_segment_cntrl IS
	PORT (
		-- State input (including size)
		input : IN unsigned (15 downto 0);
		-- Mask for determining which bits to look at in this controller
		mask : IN unsigned(15 downto 0);
		-- HEX output
		output :out std_logic_vector(6 downto 0)
	);
END Entity snake_segment_cntrl;

ARCHITECTURE LogicFunction OF snake_segment_cntrl IS
BEGIN
	process (input, mask) IS
		-- Variable to store the input anded with mask
		variable masked: unsigned(15 downto 0);
	begin
		masked := input and mask;
		-- This logic takes some explaining... It essentially figures out which of the six
		-- segments is currently being processed and then does the output accordingly.

		-- We look at the masked bits to determine where there's a 1
		IF masked(15) = '1' OR masked(0) = '1' OR masked(1) = '1' OR masked(2) = '1' THEN
			-- If there's a 1 in one of those 4 then we're in the leftmost segment
			-- and the output can be 1001110 with all lights lit up
			-- We can use input or masked to get the values here, doesn't matter
			output <= not('0' & input(0) & input(1) & input(2) & "00" & input(15));
		ELSIF masked(14) = '1' OR masked(3) = '1' THEN
			output <= not("000" & input(3) & "00" & input(14));
		ELSIF masked(13) = '1' OR masked(4) = '1' THEN
			output <= not("000" & input(4) & "00" & input(13));
		ELSIF masked(12) = '1' OR masked(5) = '1' THEN
			output <= not("000" & input(5) & "00" & input(12));
		ELSIF masked(11) = '1' OR masked(6) = '1' THEN
			output <= not("000" & input(6) & "00" & input(11));
		ELSIF masked(10) = '1' OR masked(9) = '1' OR masked(8) = '1' or masked(7) = '1' THEN
			output <= not("000" & input(7) & input(8) & input(9) & input(10));
		-- If we didn't find any 1s in masked then don't do any lights
		ELSE
			output <= not("0000000");
		END IF;
	end process;
END LogicFunction;
