LIBRARY ieee;
USE ieee.NUMERIC_STD.all;

ENTITY mult4x4 IS
	PORT (dataa, datab : IN unsigned (3 downto 0);
	product : OUT unsigned (7 downto 0));
END mult4x4;

ARCHITECTURE LogicFunction OF mult4x4 IS

BEGIN
	product <= dataa * datab;
END LogicFunction;