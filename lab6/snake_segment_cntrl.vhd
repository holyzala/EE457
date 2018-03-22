LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

ENTITY snake_segment_cntrl IS
	PORT (input : IN unsigned (15 downto 0);
		output :out std_logic_vector(6 downto 0))
		;
END Entity snake_segment_cntrl;

ARCHITECTURE LogicFunction OF snake_segment_cntrl IS

BEGIN
	process (input) is
		variable temp: std_logic_vector(6 downto 0) := "0000000";
	begin
		if (input (5 downto 0) = "000000") then
			null;
		else
			temp := temp or "1000000";
		end if;
		if (input (13 downto 8) = "000000") then
			null;
		else
			temp := temp or "0001000";
		end if;
		if (input (15) = '1') then
			temp := temp or "0000010";
		end if;
		if (input (14) = '1') then
			temp := temp or "0000100";
		end if;
		if (input (6) = '1') then
			temp := temp or "0100000";
		end if;
		if (input (7) = '1') then
			temp := temp or "0010000";
		end if;
		output <= temp;
	end process;
END LogicFunction;