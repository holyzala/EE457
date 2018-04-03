LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


entity DE1_top is
	Port(

		-- 50Mhz clock, i.e. 50 Million rising edges per second
		clock_50 :in  std_logic; 
		
		-- 7 Segment Display
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
	
	
	COMPONENT washing_controller
		PORT(
			-- Declare control inputs
			sw0, sw1 : IN STd_LOgIC;
			clk : IN STD_LOGIC;
			-- done signal from the lower states
			start : IN STD_LOGIC;
			donesig : IN STD_LOGIC;
			donesig2 : IN STD_LOGIC;
			donesig3 : IN STD_LOGIC;
			-- key 0
			stop : IN STD_LOGIC;
			
			-- output bit vector representing the states
			state_out : OUT STD_LOGIC_VECTOR (2 downto 0)
			);
	END COMPONENT washing_controller;
	
	COMPONENT fill_controller IS

	PORT (
		-- Declare control inputs 
		state_in : IN STD_LOGIC_VECTOR (2 downto 0);
		hex_out : OUT STD_LOGIC_VECTOR (6 downto 0);
		done : OUT STD_LOGIC;
		clk : IN STD_LOGIC;
		next_cycle: IN STD_LOGIC

	);
	END COMPONENT fill_controller;

	
	COMPONENT wash_controller IS
	-- Begin port declaration
	PORT (
		-- Declare control inputs 
		state_in : IN STD_LOGIC_VECTOR (2 downto 0);
		hex_out : OUT STD_LOGIC_VECTOR (6 downto 0);
		done : OUT STD_LOGIC;
		next_cycle: IN STD_LOGIC

	);
	END COMPONENT wash_controller;
	
	COMPONENT spin_controller IS
	-- Begin port declaration
	PORT (
		-- Declare control inputs 
		state_in : IN STD_LOGIC_VECTOR (2 downto 0);
		hex_out : OUT STD_LOGIC_VECTOR (6 downto 0);
		done : OUT STD_LOGIC;
		next_cycle: IN STD_LOGIC
	);
	END COMPONENT spin_controller;
	
	COMPONENT hexmux IS
	PORT (
		hex_a, hex_b : IN std_logic_vector (6 downto 0);
		state_sel : IN STD_lOGIC_VECTOR (2 downto 0);
		hex_out : OUT std_logic_vector (6 downto 0)
		);
	END COMPONENT hexmux;

	-- Declare signals to go between components
	SIGNAL fill_drain : STD_LOGIC;
	SIGNAL wash_rinse: STD_LOGIC;
	SIGNAL spin : STD_LOGIC;
	SIGNAL stop_n : STD_LOGIC;
	SIGNAL start_n : STD_LOGIC;
	SIGNAL state: STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL fill_done : STD_LOGIC;
	SIGNAL spin_done : STD_LOGIC;
	SIGNAL wash_done : STD_LOGIC;
	SIGNAL hex_out_b : std_logic_vector (6 downto 0);
	SIGNAL hex_out_a : std_logic_vector (6 downto 0);


BEGIN
	
		stop_n <= not KEY(0);
		start_n <= not KEY(1);

	-- FOR THE COUNTERS NEED TO RESET THE COUNTERS ON THE START OF THE PROCESSES
	-- counter for spin
		u1: gen_counter
		-- 26 bits wide and 50,000,000 max for 1 second
		generic map (wide => 26, max => 50000000/4)
		PORT MAP (
			clk => clock_50,
			-- We never load it
			load => '0',
			data => (others => '0'),
			-- reset is key0 notted
			reset => stop_n,
			-- Always enabled
			enable => '1',
			-- Once term (max) is hit we have a second
			term => spin
		);
	
	
	--couter for wash/rinse
		u2: gen_counter
		-- 26 bits wide and 50,000,000 max for 1 second
		generic map (wide => 26, max => 100000000/7)
		PORT MAP (
			clk => clock_50,
			-- We never load it
			load => '0',
			data => (others => '0'),
			-- reset is key0 notted
			reset => stop_n,
			-- Always enabled
			enable => '1',
			-- Once term (max) is hit we have a second
			term => wash_rinse
		);
	
	
	-- counter for fill/drain
		u3: gen_counter
		-- 26 bits wide and 50,000,000 max for 1 second
		generic map (wide => 26, max => 50000000)
		PORT MAP (
			clk => clock_50,
			-- We never load it
			load => '0',
			data => (others => '0'),
			-- reset is key0 notted
			reset => stop_n,
			-- Always enabled
			enable => '1',
			-- Once term (max) is hit we have a second
			term => fill_drain
		);
	
		-- 3 DONE SIGNALS??????
		u4: washing_controller
		PORT MAP (
			clk => clock_50,
			sw0=> SW(0),
			sw1=> SW(1),
			start => start_n,
			donesig => fill_done,
			donesig2 => wash_done,
			donesig3 => spin_done,
			stop=> stop_n,
			state_out => state
		);
		
		u5: fill_controller
			PORT MAP (
				state_in => state,
				hex_out=> HEX0,
				done => fill_done,
				clk => clock_50,
				next_cycle => fill_drain
		);
		
		u6: spin_controller
			PORT MAP (
 				state_in => state,
				hex_out => hex_out_b,
				done => spin_done,
				next_cycle => spin
		);
		
		u7: wash_controller
			PORT MAP (
				state_in => state,
				hex_out => hex_out_a,
				done => wash_done,
				next_cycle => wash_rinse
		);
		
		u8: hexmux
			PORT MAP (
				hex_a => hex_out_a,
				hex_b => hex_out_b,
				state_sel => state,
				hex_out => HEX1
		);
END;
