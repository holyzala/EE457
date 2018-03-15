LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

ENTITY reg16 IS
	PORT (datain : IN unsigned (15 downto 0);
			clk : in std_logic;
			sclr_n : in std_logic;
			clk_ena : in std_logic;
			reg_out : OUT unsigned (15 downto 0));
END reg16;

ARCHITECTURE LogicFunction OF reg16 IS

BEGIN
	process (clk) is
	begin
		if rising_edge (clk) then
			if clk_ena = '1' AND sclr_n = '0' then
				reg_out <= (others => '0');
			elsif clk_ena = '1' AND sclr_n /= '0' then
				reg_out <= datain;
			end if;
		end if;
	end process;
END LogicFunction;