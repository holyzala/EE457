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
	
	COMPONENT snake_segment_cntrl IS
	
		PORT (
			input : IN unsigned (15 downto 0);
			mask : IN unsigned(15 downto 0);
			output : OUT std_logic_vector( 6 downto 0)
			);
			
	END COMPONENT snake_segment_cntrl;

	COMPONENT snake_controller
		
		PORT (
			-- Declare control inputs 
			reset_a, clk, sw1, sw2, sw3, sw4, sw10 : IN STD_LOGIC;
			
			--count_reset : IN STD_LOGIC;
			-- for time changes; everysecond the snake moves
			--second : IN std_logic;
			
			count: in std_logic;
			
			
			--count : in unsigned (25 downto 0);
			
			
			state_out : out unsigned (15 downto 0)
			--done, clk_ena, sclr_n : OUT STD_LOGIC
		);
		
	END COMPONENT snake_controller;


-- signal and component declartions
-- you will need to create the component declaration for the 7 segment control.
	--signal count: unsigned (25 downto 0);
	
	
	-- DECLARE ALL COMPONENT OUTPUTS HERE!!!!!
	
	signal state_out_before_seg: unsigned(15 downto 0);
	signal secondPassed : std_logic;
	
BEGIN

-- processes, component instantiations, general logic.
	u1: gen_counter 
		generic map (wide => 26, max => 1000)
		PORT MAP (
			clk => clock_50,
			load => '0',
			data => (others => '0'),
			--aclr_n => start_n, 
			--count_out => count(25 downto 0),
			reset => KEY(0),
			enable => '1',
			term => secondPassed
			);

	u2: snake_segment_cntrl PORT MAP (
		input => state_out_before_seg(15 downto 0),
		mask => "1000000000000111",
		output => HEX0( 6 downto 0) 
	);

	u3: snake_segment_cntrl PORT MAP (
		input => state_out_before_seg(15 downto 0),
		mask => "0100000000001000",
		output => HEX1 ( 6 downto 0)
	);

	u4: snake_segment_cntrl PORT MAP (
		input => state_out_before_seg(15 downto 0),
		mask => "0010000000010000",
		output => HEX2 ( 6 downto 0)
	);

	u5: snake_segment_cntrl PORT MAP (
		input => state_out_before_seg(15 downto 0),
		mask => "0001000000100000",
		output => HEX3 ( 6 downto 0)
	);

	u6: snake_segment_cntrl PORT MAP (
		input => state_out_before_seg(15 downto 0),
		mask => "0000100001000000",
		output => HEX4 ( 6 downto 0)
	);

	u7: snake_segment_cntrl PORT MAP (
		input => state_out_before_seg(15 downto 0),
		mask => "0000011110000000",
		output => HEX5 ( 6 downto 0)
	);

	u8: snake_controller PORT MAP (
		sw1 => SW(0),	-- or 9
		sw2 => SW(1),	-- or 8
		sw3 => SW(2),	-- or 7
		sw4 => SW(3),	-- or 6
		sw10 => SW(9),	-- or 0
		clk => clock_50, 
		reset_a => KEY(0), -- or 3
		--start => start,
		count => secondPassed,
		--input_sel => sel(1 downto 0),
		--shift_sel => shift(1 downto 0),
		state_out => state_out_before_seg--(2 downto 0)
		--done => done_flag,
		--clk_ena => clk_ena,
		--sclr_n => sclr_n
		);
				
end;








