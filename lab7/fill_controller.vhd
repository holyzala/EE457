LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Begin entity declaration for "control"
ENTITY fill_controller IS
	-- Begin port declaration
	PORT (
		-- Declare control inputs
		state_in : IN STD_LOGIC_VECTOR (2 downto 0); -- Master state
		hex_out : OUT STD_LOGIC_VECTOR (6 downto 0); -- Light sequence
		done : OUT STD_LOGIC; -- If this mini state is complete
		clk : IN STD_LOGIC;
		next_cycle : IN STD_LOGIC -- The counter that acts as a clock in here
	);
END ENTITY fill_controller;

--  Begin architecture
ARCHITECTURE logic OF fill_controller IS
	-- fill1 is empty, fill2 is half full, fill3 is full
	TYPE state_type IS (empty, half, full, done_fill, done_drain);

	-- Declare two signals named "head_state" and "next_state" to be of enumerated type
	SIGNAL head_state: state_type;
	SIGNAL next_state: state_type;

BEGIN
	-- This is the actual moving of the state, tied to the counter
	PROCESS (clk, next_cycle)
	begin
		if rising_edge(clk) then
			if next_cycle = '1' then
				head_state <= next_state;
			else
				head_state <= head_state;
			end if;
		end if;
	END PROCESS;

	-- Figure out the next state for the head
	PROCESS (head_state, state_in)
	BEGIN
		done <= '0';
		-- If we're in fill master state then the water goes up
		IF state_in = "001" THEN
			CASE head_state IS
				WHEN empty =>
					next_state <= half;
				WHEN half =>
					next_state <= full;
				WHEN full =>
					next_state <= done_fill;
				WHEN done_fill =>
					-- When the tub is full we can move to the next state
					done <= '1';
					next_state <= done_fill;
				WHEN done_drain =>
					next_state <= half;
				WHEN OTHERS =>
					next_state <= empty;
			END CASE;
		-- Otherwise it goes down
		ELSIF state_in = "011" THEN
			CASE head_state IS
				WHEN full =>
					next_state <= half;
				WHEN half =>
					next_state <= empty;
				WHEN empty =>
					next_state <= done_drain;
				WHEN done_drain =>
					-- When the tub is empty move to the next state
					done <= '1';
					next_state <= done_drain;
				WHEN done_fill =>
					next_state <= half;
				WHEN OTHERS =>
					next_state <= full;
			END CASE;
		ELSE
			next_state <= head_state;
		END IF;
	-- End process
	END PROCESS;

	-- Determine the hex of the light for the fill cycle
	process (head_state)
	begin
		CASE head_state IS
			WHEN empty =>
				hex_out <= "1110111";
			WHEN done_drain =>
				hex_out <= "1110111";
			WHEN half =>
				hex_out <= "0111111";
			WHEN full =>
				hex_out <= "1111110";
			WHEN done_fill =>
				hex_out <= "1111110";
			WHEN OTHERS =>
				hex_out <= "1111111";
		END CASE;
	end process;

-- End architecture
END ARCHITECTURE logic;
