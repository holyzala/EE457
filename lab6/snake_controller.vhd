LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
-- Begin entity declaration for "control"
ENTITY snake_controller IS
	-- Begin port declaration
	PORT (
		-- Declare control inputs 
		clk, reset_a : IN STD_LOGIC; -- system clock, custom reset signal(KEY1 Press)
		sw1, sw2, sw3, sw4, sw10 : IN STD_LOGIC; --Switch values from the switches vector
		count : in std_logic; -- 1 if we've reached a second interval
		state_out : out unsigned (15 downto 0) -- This is combined state out (state + size)
	);
END ENTITY snake_controller;

--  Begin architecture 
ARCHITECTURE logic OF snake_controller IS
	TYPE state_type IS (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15);

	-- Declare two signals named "head_state" and "next_state" to be of enumerated type
	SIGNAL head_state: state_type;
	SIGNAL next_state: state_type;
	-- size stores the amount of lights to light up, the size of the snake
	signal size: unsigned (15 downto 0);
	-- shift_count is how many times to rotate size left to get all the 1s in the right places
	signal shift_count: integer;
	
BEGIN
	-- rising edge transitions; Use asynchronous clear control
	-- set the next state aka move the snake around the clock.
	PROCESS (clk, reset_a)
	begin 
		if reset_a = '1' then
			head_state <= s1;
		elsif rising_edge(clk) then
			if count = '1' then
				head_state <= next_state;
			end if;
		end if;
	END PROCESS;

	-- Figure out the next state for the head based on if they have been swapped
	PROCESS (head_state, sw10)
	BEGIN
		IF sw10 = '0' then -- Going clockwise
			CASE head_state IS
				WHEN s0 =>
					next_state <= s1;
				WHEN s1=>
					next_state <= s2;
				WHEN s2=>
					next_state <= s3;
				WHEN s3=>
					next_state <= s4;
				WHEN s4=>
					next_state <= s5;
				WHEN s5=>
					next_state <= s6;
				WHEN s6=>
					next_state <= s7;
				WHEN s7=>
					next_state <= s8;
				WHEN s8=>
					next_state <= s9;
				WHEN s9=>
					next_state <= s10;
				WHEN s10=>
					next_state <= s11;
				WHEN s11=>
					next_state <= s12;
				WHEN s12=>
					next_state <= s13;
				WHEN s13=>
					next_state <= s14;
				WHEN s14=>
					next_state <= s15;
				WHEN s15=>
					next_state <= s0;
				WHEN others =>
					next_state <= s0;
			END CASE;
		ELSE -- Going counter clockwise
			CASE head_state IS
				WHEN s0 =>
					next_state <= s15;
				WHEN s1=>
					next_state <= s0;
				WHEN s2=>
					next_state <= s1;
				WHEN s3=>
					next_state <= s2;
				WHEN s4=>
					next_state <= s3;
				WHEN s5=>
					next_state <= s4;
				WHEN s6=>
					next_state <= s5;
				WHEN s7=>
					next_state <= s6;
				WHEN s8=>
					next_state <= s7;
				WHEN s9=>
					next_state <= s8;
				WHEN s10=>
					next_state <= s9;
				WHEN s11=>
					next_state <= s10;
				WHEN s12=>
					next_state <= s11;
				WHEN s13=>
					next_state <= s12;
				WHEN s14=>
					next_state <= s13;
				WHEN s15=>
					next_state <= s14;
				WHEN others =>
					next_state <= s0;
			END CASE;
		END IF;
	-- End process
	END PROCESS;

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

	PROCESS(head_state)
	BEGIN
		-- Translate head_state into an amount to rotate the size
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
	END PROCESS;

	process (size, shift_count)
	begin
		-- Rotate the size left shift_count times to get the combined state (state + size)
		state_out <= size rol shift_count;
	end process;

-- End architecture
END ARCHITECTURE logic;
