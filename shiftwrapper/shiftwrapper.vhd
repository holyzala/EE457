LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

ENTITY shiftwrapper IS
	PORT (clk : in std_logic;
			reset : in std_logic;
			shift_count : in integer;
			state : in integer;
			shift_out : OUT unsigned (15 downto 0);
			done : out std_logic);
END shiftwrapper;

ARCHITECTURE LogicFunction OF shiftwrapper IS
	signal temp: unsigned := (others => 0);
BEGIN
	process (clk, reset, shift_count, state) is
		signal count : integer := shift_count;
	begin
		if (reset = '1') then
			done <= '0';
			temp <= (others => '0');
			shift_out <= (others => '0');
			count <= shift_count;
		elsif (rising_edge(clk)) then
			if (count > 0) then
				
			end if;
		end if;
	end process;
END LogicFunction;