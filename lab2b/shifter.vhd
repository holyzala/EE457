LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

ENTITY shifter IS
	PORT (input : IN unsigned (7 downto 0);
			shift_cntrl : IN unsigned (1 downto 0);
			shift_out : OUT unsigned (15 downto 0));
END shifter;

ARCHITECTURE LogicFunction OF shifter IS

BEGIN
	process (input, shift_cntrl) is
	begin
		if shift_cntrl = 0 or shift_cntrl = 3 then
			shift_out <= "00000000" & input;
		elsif shift_cntrl = 1 then
			shift_out <= "0000" & input & "0000";
		elsif shift_cntrl = 2 then
			shift_out <= input & "00000000";
		else
			shift_out <= (others => '0');
		end if;
	end process;
END LogicFunction;