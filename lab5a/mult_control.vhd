--******************************************************************************
--                                                                             *
--                  Copyright (C) 2014 Altera Corporation                      *
--                                                                             *
-- ALTERA, ARRIA, CYCLONE, HARDCOPY, MAX, MEGACORE, NIOS, QUARTUS & STRATIX    *
-- are Reg. U.S. Pat. & Tm. Off. and Altera marks in and outside the U.S.      *
--                                                                             *
-- All information provided herein is provided on an "as is" basis,            *
-- without warranty of any kind.                                               *
--                                                                             *
-- Module Name: mult_control               ile Name: mult_control.vhd          *
--                                                                             *
-- Module Function: state machine control logic for the multiplier             *
--                                                                             *
-- REVISION HISTORY:                                                           *
--******************************************************************************

-- Insert library and use clauses
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Begin entity declaration for "control"
ENTITY mult_control IS
	-- Begin port declaration
	PORT (
		-- Declare control inputs "clk", "reset_a", "start", "count"
		clk, reset_a, start : IN STD_LOGIC;
		count : IN UNSIGNED (1 DOWNTO 0);
		
		-- Declare output control signals "in_sel", "shift_sel", "state_out", "done", "clk_ena" and "sclr_n"
		input_sel, shift_sel : OUT UNSIGNED(1 DOWNTO 0);
		state_out : OUT UNSIGNED(2 DOWNTO 0);
		done, clk_ena, sclr_n : OUT STD_LOGIC
	);
-- End entity
END ENTITY mult_control;

--  Begin architecture 
ARCHITECTURE logic OF mult_control IS
	-- Declare enumberated state type consisting of 6 values:  "idle", "lsb", "mid", "msb", "calc_done" and "err"
	type state_type is (idle, lsb, mid, msb, calc_done, err);
	
	-- Declare two signals named "current_state" and "next_state" to be of enumerated type
	signal current_state: state_type;
	signal next_state: state_type;
 
BEGIN
	-- Create sequential process to control state transitions by making current_state equal to next state on
	--	rising edge transitions; Use asynchronous clear control
	PROCESS (clk, reset_a)
	begin
		if reset_a = '1' then
			current_state <= idle;
		elsif rising_edge (clk) then
			current_state <= next_state;
		end if;
	END PROCESS;
	
	-- Create combinational process & case statement to determine next_state based on current state and inputs
	PROCESS (current_state, start, count)
	BEGIN
		CASE current_state IS
			WHEN idle =>
				IF start = '1' THEN
					next_state <= lsb;
				ELSE
					next_state <= idle;
				END IF;
			when lsb =>
				if start = '0' and count = "00" then
					next_state <= mid;
				else
					next_state <= err;
				end if;
			when mid =>
				if start = '0' and count = "01" then
					next_state <= mid;
				elsif start = '0' and count = "10" then
					next_state <= msb;
				else
					next_state <= err;
				end if;
			when msb =>
				if start = '0' and count = "11" then
					next_state <= calc_done;
				else
					next_state <= err;
				end if;
			when calc_done =>
				if start = '0' then
					next_state <= idle;
				else
					next_state <= err;
				end if;
			when err =>
				if start = '1' then
					next_state <= lsb;
				else
					next_state <= err;
				end if;
			when others =>
				next_state <= err;
		END CASE;
	-- End process
	END PROCESS;

	-- Create process for Mealy output logic for input_sel, shift_sel, done, clk_ena and sclr_n(outputs function of inputs and current_state)
	mealy: PROCESS (current_state, start, count) 
	BEGIN
	
		-- Initialize outputs to default values so case only covers when they change
		-- #### the following default values may need to be changed ####
		input_sel <= "00";
		shift_sel <= "00";
		done <= '0';
		clk_ena <= '0';
		sclr_n <= '1';
		
		CASE current_state IS
			WHEN idle =>
				IF start = '1' THEN
					sclr_n <= '0';
					clk_ena <= '1';
				END IF;
			when lsb =>
				if start = '0' and count = "00" then
					clk_ena <= '1';
				end if;
			when mid =>
				if start = '0' and count = "01" then
					input_sel <= "01";
					shift_sel <= "01";
					clk_ena <= '1';
				elsif start = '0' and count = "10" then
					input_sel <= "10";
					shift_sel <= "01";
					clk_ena <= '1';
				end if;
			when msb =>
				if start = '0' and count = "11" then
					input_sel <= "11";
					shift_sel <= "10";
					clk_ena <= '1';
				end if;
			when calc_done =>
				if start = '0' then
					done <= '1';
				end if;
			when err =>
				if start = '1' then
					clk_ena <= '1';
					sclr_n <= '0';
				end if;
			when others =>
		END CASE;
	-- End process
	END PROCESS mealy;

	-- Create process for Moore output logic for state_out  (outputs function of current_state only)
		moore: PROCESS(current_state)
		BEGIN
			-- Initialize state_out to default values so case only covers when they change
			state_out <= "000";
			
			CASE current_state IS
				WHEN idle =>
				WHEN lsb =>
					state_out <= "001";
				when mid =>
					state_out <= "010";
				when msb =>
					state_out <= "011";
				when calc_done =>
					state_out <= "100";
				when err =>
					state_out <= "101";
				when others =>
			END CASE;
		-- End process
		END PROCESS moore;
-- End architecture
END ARCHITECTURE logic;