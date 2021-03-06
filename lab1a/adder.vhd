LIBRARY ieee;
USE ieee.NUMERIC_STD.all;

ENTITY adder IS
	PORT (dataa, datab : IN unsigned (15 downto 0);
	sum : OUT unsigned (15 downto 0));
END adder;

ARCHITECTURE LogicFunction OF adder IS

BEGIN
	sum <= dataa + datab;
END LogicFunction;