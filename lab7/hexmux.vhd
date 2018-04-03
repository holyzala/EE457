LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
USE ieee.STD_LOGIC_1164.all;

ENTITY hexmux IS
	PORT (
		hex_a, hex_b : IN unsigned (6 downto 0);
		state_sel : IN STD_LOGIC_VECTOR (2 downto 0);
		hex_out : OUT unsigned (6 downto 0));
END ENTITY hexmux;

ARCHITECTURE LogicFunction OF hexmux IS

BEGIN
	process (hex_a, hex_b, state_sel) is
	begin
		if state_sel = "010" then
			hex_out <= hex_a;
		elsif state_sel = "100" then
			hex_out <= hex_b;
		else
			hex_out <= "1111111";
		end if;
	end process;
END LogicFunction;