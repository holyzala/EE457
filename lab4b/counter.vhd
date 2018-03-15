LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

ENTITY counter IS
	PORT (clk : IN std_logic;
			aclr_n : in std_logic;
			count_out : out unsigned (1 downto 0));
END counter;

ARCHITECTURE LogicFunction OF counter IS

BEGIN
	process (clk, aclr_n)
		variable c : unsigned (1 downto 0);
	begin
		if aclr_n = '0' then
			c := "00";
		elsif rising_edge (clk) then
			c := c + "01";
		end if;
		count_out <= c;
	end process;
END LogicFunction;