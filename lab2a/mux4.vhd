LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
USE ieee.STD_LOGIC_1164.all;

ENTITY mux4 IS
	PORT (mux_in_a, mux_in_b : IN unsigned (3 downto 0);
	mux_sel : IN std_logic;
	mux_out : OUT unsigned (3 downto 0));
END mux4;

ARCHITECTURE LogicFunction OF mux4 IS

BEGIN
	process (mux_in_a, mux_in_b, mux_sel) is
	begin
		if mux_sel = '0' then
			mux_out <= mux_in_a;
		else
			mux_out <= mux_in_b;
		end if;
	end process;
END LogicFunction;