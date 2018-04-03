LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Begin entity declaration for "control"
ENTITY wash_controller IS
	-- Begin port declaration
	PORT (
		-- Declare control inputs 
		state_in : IN STD_LOGIC_VECTOR (2 downto 0);
		hex_out : OUT STD_LOGIC_VECTOR (6 downto 0);
		done : OUT STD_LOGIC;
		clk : IN STD_LOGIC;
		next_cycle : IN STD_LOGIC
	);
END ENTITY wash_controller;

--  Begin architecture 
ARCHITECTURE logic OF wash_controller IS

	TYPE state_type IS (wash1, wash2, wash3, wash4);

	-- Declare two signals named "head_state" and "next_state" to be of enumerated type
	SIGNAL head_state: state_type;
	SIGNAL next_state: state_type;
	SIGNAL second_stage: STD_LOGIC;

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
		IF state_in = "010" THEN
			IF second_stage = '0' THEN
				CASE head_state IS
					WHEN wash1 =>
						next_state <= wash2;
					WHEN wash2 =>
						next_state <= wash3;
					WHEN wash3 =>
						next_state <= wash4;
					WHEN wash4 =>
						second_stage <= '1';
						next_state <= wash3;
					WHEN OTHERS =>
						next_state <= wash1;
				END CASE;
			ELSE
				CASE head_state IS
					WHEN wash1 =>
						next_state <= wash1;
						second_stage <= '0';
						done <= '1';
					WHEN wash2 =>
						next_state <= wash1;
					WHEN wash3 =>
						next_state <= wash2;
					WHEN wash4 =>
						next_state <= wash3;
					WHEN OTHERS =>
						next_state <= wash1;
				END CASE;
			END IF;
		ELSE
			done <= '0';
			second_stage <= '0';
			next_state <= wash1;
		END IF;
	-- End process
	END PROCESS;

	process (head_state)
	begin
		CASE head_state IS
			WHEN wash1 =>
				hex_out <= "1110111";
			WHEN wash2 =>
				hex_out <= "1111011";
			WHEN wash3 =>
				hex_out <= "0111111";
			WHEN wash4 =>
				hex_out <= "1101111";
			WHEN OTHERS =>
				hex_out <= "1111111";
		END CASE;
	end process;

-- End architecture
END ARCHITECTURE logic;
