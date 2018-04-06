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

	TYPE state_type IS (wash1, wash2, wash3, wash4, done_wash);

	-- Declare two signals named "head_state" and "next_state" to be of enumerated type
	SIGNAL head_state: state_type;
	SIGNAL next_state: state_type;
	SIGNAL second_stage: STD_LOGIC;

BEGIN
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

	-- Figure out the next state for the head based on if they have been swapped
	PROCESS (head_state, state_in)
	BEGIN
		done <= '0';
		IF state_in = "010" THEN
			IF second_stage = '0' THEN
				second_stage <= '0';
				CASE head_state IS
					WHEN done_wash =>
						next_state <= wash2;
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
				second_stage <= '1';
				CASE head_state IS
					WHEN wash1 =>
						next_state <= done_wash;
					WHEN done_wash =>
						done <= '1';
						second_stage <= '0';
						next_state <= done_wash;
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
