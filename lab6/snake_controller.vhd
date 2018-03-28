LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
-- Begin entity declaration for "control"
ENTITY snake_controller IS
	-- Begin port declaration
	PORT (
		-- Declare control inputs 
		sw1, sw2, sw3, sw4, sw10 : IN STD_LOGIC; --Switch values from the switches vector
		state_out : out unsigned (15 downto 0); -- This is combined state out (state + size)
		state_in : in std_logic_vector (3 downto 0)
	);
END ENTITY snake_controller;

--  Begin architecture 
ARCHITECTURE logic OF snake_controller IS
	-- size stores the amount of lights to light up, the size of the snake
	signal size: unsigned (15 downto 0);
	-- shift_count is how many times to rotate size left to get all the 1s in the right places
BEGIN
	process (sw1, sw2, sw3, sw4)
		-- This variable is just so we can do a case instead of ugly if conditions
		VARIABLE switches : STD_LOGIC_VECTOR(3 DOWNTO 0);
	begin
		switches := sw4 & sw3 & sw2 & sw1;
		-- Translate the switches to a snake size
		CASE switches IS
			WHEN "0001" =>
				size <= "1000000000000000";
			WHEN "0010" =>
				size <= "1100000000000000";
			WHEN "0011" =>
				size <= "1110000000000000";
			WHEN "0100" =>
				size <= "1111000000000000";
			WHEN "0101" =>
				size <= "1111100000000000";
			WHEN "0110" =>
				size <= "1111110000000000";
			WHEN "0111" =>
				size <= "1111111000000000";
			WHEN "1000" =>
				size <= "1111111100000000";
			WHEN "1001" =>
				size <= "1111111110000000";
			WHEN "1010" =>
				size <= "1111111111000000";
			WHEN "1011" =>
				size <= "1111111111100000";
			WHEN "1100" =>
				size <= "1111111111110000";
			WHEN "1101" =>
				size <= "1111111111111000";
			WHEN "1110" =>
				size <= "1111111111111100";
			WHEN "1111" =>
				size <= "1111111111111110";
			WHEN OTHERS =>
				size <= (others => '0');
		END CASE;
	end process;

	process (size, state_in)
	begin
		-- Rotate the size left shift_count times to get the combined state (state + size)
		state_out <= size rol to_integer(unsigned(state_in));
	end process;

-- End architecture
END ARCHITECTURE logic;
