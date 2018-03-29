LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Begin entity declaration for "control"
ENTITY fill_controller IS
	-- Begin port declaration
	PORT (
		-- Declare control inputs 
		state_in : IN STD_LOGIC_VECTOR (2 downto 0);
		hex_out : OUT STD_LOGIC_VECTOR (6 downto 0);
		done : OUT STD_LOGIC;
		clk : IN STD_LOGIC;
		next_cycle : IN STD_LOGIC;
		drain : IN STD_LOGIC;
	);
END ENTITY fill_controller;

--  Begin architecture 
ARCHITECTURE logic OF fill_controller IS
	TYPE state_type IS (fill1, fill2, fill3);

	-- Declare two signals named "head_state" and "next_state" to be of enumerated type
	SIGNAL head_state: state_type;
	SIGNAL next_state: state_type;
	
BEGIN
	-- rising edge transitions; Use asynchronous clear control
	-- set the next state aka move the snake around the clock.
	PROCESS (clk, next_cycle)
	begin
		done <= '0';
		if rising_edge(next_cycle) then
			head_state <= next_state;
		end if;
	END PROCESS;

	-- Figure out the next state for the head based on if they have been swapped
	PROCESS (head_state, state_in)
	BEGIN
		IF state_in = "001" or state_in = "011" THEN
			CASE head_state IS
				WHEN fill1 =>
					next_state <= fill2;
				WHEN fill2 =>
					next_state <= fill3;
				WHEN fill3 =>
					next_state <= wash4;
				WHEN OTHERS =>
					next_state <= fill1;
			END CASE;
		ELSE
			done <= '0';
			next_state <= fill1;
		END IF;
	-- End process
	END PROCESS;

	process (head_state)
	begin
		IF drain = '0' THEN
			CASE head_state IS
				WHEN fill1 =>
					hex_out <= "0111111";
				WHEN fill2 =>
					hex_out <= "1110111";
				WHEN fill3 =>
					hex_out <= "1111110";
				WHEN OTHERS =>
					hex_out <= "1111111";
			END CASE;
		ELSE
			CASE head_state IS
				WHEN fill1 =>
					hex_out <= "1111110";
				WHEN fill2 =>
					hex_out <= "1110111";
				WHEN fill3 =>
					hex_out <= "0111111";
				WHEN OTHERS =>
					hex_out <= "1111111";
			END CASE;
		END IF;
	end process;

-- End architecture
END ARCHITECTURE logic;
