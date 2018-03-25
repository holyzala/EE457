LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


entity DE1_top is
	Port(

		-- 50Mhz clock, i.e. 50 Million rising edges per second
		clock_50 :in  std_logic; 
		-- 7 Segment Display
		-- driving the the individual bit loicall low will
		-- light up the segment.
		HEX0		:out	std_logic_vector( 6 downto 0); -- right most
		HEX1		:out	std_logic_vector( 6 downto 0);	
		HEX2		:out	std_logic_vector( 6 downto 0);	
		HEX3		:out	std_logic_vector( 6 downto 0);	
		HEX4		:out	std_logic_vector( 6 downto 0);	
		HEX5		:out	std_logic_vector( 6 downto 0); -- left most
		
		-- Red LEDs above Slider switches
		-- driving the LEDR signal logically high will light up the Red LED
		-- driving the LEDR signal logicall low will turn off the Red LED 
		LEDR		:out	std_logic_vector( 9 downto 0);	

		-- Push Button
		-- the KEY input is normally high, pressing the KEY
		-- will drive the input low.
		
		KEY		:in   std_logic_vector( 3 downto 0);  
		-- Slider Switch
		-- when the Slider switch is pushed up, away from the board edge
		-- the input signal is logically high, when pushed towards the
		-- board edge, the signal is loically low.
		SW			:in	std_logic_vector( 9 downto 0 )
	);
end entity DE1_top;

architecture struct of DE1_top is
	-- Counter for determining 1 second intervals
	COMPONENT gen_counter
		generic (
			wide : positive; -- how many bits is the counter
			max  : positive  -- what is the max value of the counter ( modulus )
			);

		PORT (
			clk	 :in  std_logic; -- system clock
			data	 :in  std_logic_vector( wide-1 downto 0 ); -- data in for parallel load, use unsigned(data) to cast to unsigned
			load	 :in  std_logic; -- signal to load data into i_count i_count <= unsigned(data);
			enable :in  std_logic; -- clock enable
			reset	 :in  std_logic; -- reset to zeros use i_count <= (others => '0' ) since size depends on generic
			count	 :out std_logic_vector( wide-1 downto 0 ); -- count out
			term	 :out std_logic -- maximum count is reached
		);
	END COMPONENT gen_counter;

	-- 7 segment display controller with mask to determine the bits of state to look at
	COMPONENT snake_segment_cntrl IS
		PORT (
			-- State input
			input : IN unsigned (15 downto 0);
			-- Mask to limit the state bits to look at
			mask : IN unsigned(15 downto 0);
			-- HEX? output
			output : OUT std_logic_vector( 6 downto 0)
		);
	END COMPONENT snake_segment_cntrl;

	-- Main controller for state logic
	COMPONENT snake_controller
		PORT (
			reset_a, clk, sw1, sw2, sw3, sw4, sw10 : IN STD_LOGIC;
			count: in std_logic;
			state_out : out unsigned (15 downto 0)
		);
	END COMPONENT snake_controller;

	-- The combined state out (head_state + size bits) that gets masked into each segment
	signal state_out_before_seg: unsigned(15 downto 0);
	-- Counter determined a second has passed
	signal secondPassed : std_logic;
	-- Reset key notted
	signal key0_n : std_logic;
BEGIN
	-- Set the notted reset signal
	key0_n <= not KEY(0);
	
	-- The counter for second passing
	u1: gen_counter
		-- 26 bits wide and 50,000,000 max for 1 second
		generic map (wide => 26, max => 10)
		PORT MAP (
			clk => clock_50,
			-- We never load it
			load => '0',
			data => (others => '0'),
			-- reset is key0 notted
			reset => key0_n,
			-- Always enabled
			enable => '1',
			-- Once term (max) is hit we have a second
			term => secondPassed
		);

	-- left most display
	u2: snake_segment_cntrl PORT MAP (
		input => state_out_before_seg(15 downto 0),
		mask => "1000000000000111",
		output => HEX5(6 downto 0) 
	);

	u3: snake_segment_cntrl PORT MAP (
		input => state_out_before_seg(15 downto 0),
		mask => "0100000000001000",
		output => HEX4 (6 downto 0)
	);

	u4: snake_segment_cntrl PORT MAP (
		input => state_out_before_seg(15 downto 0),
		mask => "0010000000010000",
		output => HEX3 (6 downto 0)
	);

	u5: snake_segment_cntrl PORT MAP (
		input => state_out_before_seg(15 downto 0),
		mask => "0001000000100000",
		output => HEX2 (6 downto 0)
	);

	u6: snake_segment_cntrl PORT MAP (
		input => state_out_before_seg(15 downto 0),
		mask => "0000100001000000",
		output => HEX1 (6 downto 0)
	);

	-- Right most display
	u7: snake_segment_cntrl PORT MAP (
		input => state_out_before_seg(15 downto 0),
		mask => "0000011110000000",
		output => HEX0 (6 downto 0)
	);

	-- The main controller
	u8: snake_controller PORT MAP (
		sw1 => SW(0),
		sw2 => SW(1),
		sw3 => SW(2),
		sw4 => SW(3),
		sw10 => SW(9),
		clk => clock_50, 
		reset_a => key0_n,
		count => secondPassed,
		state_out => state_out_before_seg
	);				
end;
