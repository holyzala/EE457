LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Begin entity declaration for "control"
ENTITY spin_controller IS
	-- Begin port declaration
	PORT (
		-- Declare control inputs
		state_in : IN STD_LOGIC_VECTOR (2 downto 0);
		hex_out : OUT STD_LOGIC_VECTOR (6 downto 0);
		done : OUT STD_LOGIC;
		clk : IN STD_LOGIC;
		next_cycle : IN STD_LOGIC
	);
END ENTITY spin_controller;

--  Begin architecture
ARCHITECTURE logic OF spin_controller IS
	TYPE state_type IS (spin1, spin2, spin3, spin4, done_spin);

	-- Declare two signals named "head_state" and "next_state" to be of enumerated type
	SIGNAL head_state: state_type;
	SIGNAL next_state: state_type;

-- Check if it's valid to move to the next state
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
		IF state_in = "100" THEN
			CASE head_state IS
				WHEN spin1 =>
					next_state <= spin2;
				WHEN spin2 =>
					next_state <= spin3;
				WHEN spin3 =>
					next_state <= spin4;
				WHEN spin4 =>
					next_state <= done_spin;
				WHEN done_spin =>
					done <= '1';
					next_state <= done_spin;
				WHEN OTHERS =>
					next_state <= spin1;
			END CASE;
		ELSE
			next_state <= spin1;
		END IF;
	-- End process
	END PROCESS;

  -- Determine the hex of the light to light up for the spin cycle
	process (head_state)
	begin
		CASE head_state IS
			WHEN spin1 =>
				hex_out <= "1110111";
			WHEN spin2 =>
				hex_out <= "1111011";
			WHEN spin3 =>
				hex_out <= "0111111";
			WHEN spin4 =>
				hex_out <= "1101111";
			WHEN OTHERS =>
				hex_out <= "1111111";
		END CASE;
	end process;

-- End architecture
END ARCHITECTURE logic;
