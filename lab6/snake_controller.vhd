LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
-- Begin entity declaration for "control"
ENTITY snake_control IS
	-- Begin port declaration
	PORT (
		-- Declare control inputs 
		clk, key1, sw1, sw2, sw3, sw4, sw10 : IN STD_LOGIC;

		-- for time changes; everysecond the snake moves
		second : IN std_logic;
		count : in unsigned (25 downto 0);
		state_out : out unsigned (15 downto 0);
		count_reset : out std_logic;

		-- Declare output control signals  AKA the segments for the seven seg display(6 of these)
	);
END ENTITY snake_control;
--  Begin architecture 
ARCHITECTURE logic OF snake_control IS
	TYPE state_type IS (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15);
	-- maybe err state
	-- Declare two signals named "head_state" and "next_state" to be of enumerated type
	SIGNAL head_state: state_type;
	SIGNAL next_state: state_type;
	signal size: unsigned (15 downto 0);
	signal shift_count: integer;
BEGIN
	--  rising edge transitions; Use asynchronous clear control

	-- set the next state aka move the snake around the clock.
	PROCESS (clk, reset_a)
	begin 
		if reset_a = '1' then
			head_state <= s1;
		elsif rising_Edge(clk) then
			head_state <= next_state;
		end if;
	END PROCESS;

	-- Figure out the next state for the head based on if they have been swapped
	-- and if the second has passed.
	PROCESS (count)
	BEGIN
		CASE head_state IS
			WHEN s1 =>
				IF count = '1' THEN
					IF sw10 = '1' THEN
						next_state <= s16;
					ELSE
						next_state <= s2;
					END IF;
				END IF;

			WHEN s2=>
				IF count = '1' THEN
					IF sw10 = '1' THEN
						next_state <= s1;
					ELSE
						next_state <= s3;
					END IF;
				END IF;

			WHEN s3=>
				IF count = '1' THEN
					IF sw10 = '1' THEN
						next_state <= s2;
					ELSE
						next_state <= s4;
					END IF;
				END IF;

			WHEN s4=>
				IF count = '1' THEN
					IF sw10 = '1' THEN
						next_state <= s3;
					ELSE
						next_state <= s5;
					END IF;
				END IF;
			WHEN s5=>
				IF count = '1' THEN
					IF sw10 = '1' THEN
						next_state <= s4;
					ELSE
						next_state <= s6;
					END IF;
				END IF;
			WHEN s6=>
				IF count = '1' THEN
					IF sw10 = '1' THEN
						next_state <= s5;
					ELSE
						next_state <= s7;
					END IF;
				END IF;
			WHEN s7=>
				IF count = '1' THEN
					IF sw10 = '1' THEN
						next_state <= s6;
					ELSE
						next_state <= s8;
					END IF;
				END IF;
			WHEN s8=>
				IF count = '1' THEN
					IF sw10 = '1' THEN
						next_state <= s7;
					ELSE
						next_state <= s9;
					END IF;
				END IF;
			WHEN s9=>
				IF count = '1' THEN
					IF sw10 = '1' THEN
						next_state <= s8;
					ELSE
						next_state <= s10;
					END IF;
				END IF;
			WHEN s10=>
				IF count = '1' THEN
					IF sw10 = '1' THEN
						next_state <= s9;
					ELSE
						next_state <= s11;
					END IF;
				END IF;
			WHEN s11=>
				IF count = '1' THEN
					IF sw10 = '1' THEN
						next_state <= s10;
					ELSE
						next_state <= s12;
					END IF;
				END IF;
			WHEN s12=>
				IF count = '1' THEN
					IF sw10 = '1' THEN
						next_state <= s11;
					ELSE
						next_state <= s13;
					END IF;
				END IF;
			WHEN s13=>
				IF count = '1' THEN
					IF sw10 = '1' THEN
						next_state <= s12;
					ELSE
						next_state <= s14;
					END IF;
				END IF;
			WHEN s14=>
				IF count = '1' THEN
					IF sw10 = '1' THEN
						next_state <= s13;
					ELSE
						next_state <= s15;
					END IF;
				END IF;
			WHEN s15=>
				IF count = '1' THEN
					IF sw10 = '1' THEN
						next_state <= s14;
					ELSE
						next_state <= s16;
					END IF;
				END IF;
			WHEN s16=>
				IF count = '1' THEN
					IF sw10 = '1' THEN
						next_state <= s15;
					ELSE
						next_state <= s1;
					END IF;
				END IF;

		END CASE;
		count_reset <= '1';
	-- End process
	END PROCESS;

	process (sw1, sw2, sw3, sw4)
		variable tempsize unsigned (16 downto 0 ) := "0000000000000000";
	begin
		if sw4 = '0' and sw3 = '0' and sw2 = '0' and sw1 = '1' then
			tempsize := "1000000000000000";
		elsif sw4 = '0' and sw3 = '0' and sw2 = '1' and sw1 = '0' then
			tempsize := "1100000000000000";
		elsif sw4 = '0' and sw3 = '0' and sw2 = '1' and sw1 = '1' then
			tempsize := "1110000000000000";
		elsif sw4 = '0' and sw3 = '1' and sw2 = '0' and sw1 = '0' then
			tempsize := "1111000000000000";
		elsif sw4 = '0' and sw3 = '1' and sw2 = '0' and sw1 = '1' then
			tempsize := "1111100000000000";
		elsif sw4 = '0' and sw3 = '1' and sw2 = '1' and sw1 = '0' then
			tempsize := "1111110000000000";
		elsif sw4 = '0' and sw3 = '1' and sw2 = '1' and sw1 = '1' then
			tempsize := "1111111000000000";
		elsif sw4 = '1' and sw3 = '0' and sw2 = '0' and sw1 = '0' then
			tempsize := "1111111100000000";
		elsif sw4 = '1' and sw3 = '0' and sw2 = '0' and sw1 = '1' then
			tempsize := "1111111110000000";
		elsif sw4 = '1' and sw3 = '0' and sw2 = '1' and sw1 = '0' then
			tempsize := "1111111111000000";
		elsif sw4 = '1' and sw3 = '0' and sw2 = '1' and sw1 = '1' then
			tempsize := "1111111111100000";
		elsif sw4 = '1' and sw3 = '1' and sw2 = '0' and sw1 = '0' then
			tempsize := "1111111111110000";
		elsif sw4 = '1' and sw3 = '1' and sw2 = '0' and sw1 = '1' then
			tempsize := "1111111111111000";
		elsif sw4 = '1' and sw3 = '1' and sw2 = '1' and sw1 = '0' then
			tempsize := "1111111111111100";
		elsif sw4 = '1' and sw3 = '1' and sw2 = '1' and sw1 = '1' then
			tempsize := "1111111111111110";
		else
			tempsize := (others => '0');
		end if;
		size <= tempsize;
	end process;

	-- Create process for Moore output logic for state_out  (outputs function of head_state only)
	moore: PROCESS(head_state)
	BEGIN
		-- Initialize state_out to default values so case only covers when they change
		state_out <= (others => '0');
		CASE head_state IS
			WHEN s1 =>
				shift_count <= 15;
			WHEN s2 =>
				shift_count <= 14;
			WHEN s3 =>
				shift_count <= 13;
			WHEN s4 =>
				shift_count <= 12;
			WHEN s5 =>
				shift_count <= 11;
			WHEN s6 =>
				shift_count <= 10;
			WHEN s7 =>
				shift_count <= 9;
			WHEN s8 =>
				shift_count <= 8;
			WHEN s9 =>
				shift_count <= 7;
			WHEN s10 =>
				shift_count <= 6;
			WHEN s11 =>
				shift_count <= 5;
			WHEN s12 =>
				shift_count <= 4;
			WHEN s13 =>
				shift_count <= 3;
			WHEN s14 =>
				shift_count <= 2;
			WHEN s15 =>
				shift_count <= 1;
			WHEN others =>
				shift_count <= 0;
		END CASE;
		-- End process
	END PROCESS moore;
		
	process (size, shift_count)
	begin
		state_out <= size rol shift_count;
	end process;
		
-- End architecture
END ARCHITECTURE logic;