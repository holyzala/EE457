library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
	
entity de1_soc_top is
port(
  -- clock inputs
  clock_50 :in std_logic; -- 50 mhz
  td_clk27 :in std_logic; -- 27 mhz
  -- push buttons
  -- the 4 keys are normally high, and go low when pressed
  key      :in std_logic_vector(3 downto 0);
  -- led outputs
  -- ledr (7 downto 0) is the output data
  ledr     :out std_logic_vector(9 downto 0)
);
end de1_soc_top;
	
architecture struct of de1_soc_top is

component clocka_fifo is
port(
  data    :in std_logic_vector (7 downto 0);
  rdclk   :in std_logic ;
  rdreq   :in std_logic ;
  wrclk   :in std_logic ;
  wrreq   :in std_logic ;
  q       :out std_logic_vector (7 downto 0);
  rdempty :out std_logic ;
  rdusedw :out std_logic_vector (8 downto 0);
  wrfull  :out std_logic ;
  wrusedw :out std_logic_vector (8 downto 0)
);
end component;

-- 200mhz outclk_0
component clocka_pll is
port(
  rst      :in std_logic  := '0';
  refclk   :in std_logic  := '0';
  outclk_0 :out std_logic ;
  locked   :out std_logic 
);
end component;

-- 144mhz outclk_0
component clockb_pll is
port(
  rst      :in std_logic  := '0';
  refclk   :in std_logic  := '0';
  outclk_0 :out std_logic ;
  locked   :out std_logic 
);
end component;

component data_source is
port(
  clk       :in std_logic;
  rst       :in std_logic;
  halt      :in std_logic;
  full      :in std_logic;
  filled    :in std_logic_vector(8 downto 0);
  pkt_avail :out std_logic;
  data_out  :out std_logic_vector(7 downto 0);
  data_wr   :out std_logic
);
end component;

component data_sink is
port(
  clk       :in std_logic;
  rst       :in std_logic;
  stall     :in std_logic;
  empty     :in std_logic;
  available :in std_logic_vector(8 downto 0);
  data_rd   :out std_logic
);
end component;

component wumpus is 
port (
  clk       :in  std_logic;
  rst       :in  std_logic;
  in_rdy    :out std_logic;
  out_rdy   :in  std_logic;
  data_in   :in  std_logic_vector (7 downto 0);
  push_in   :in  std_logic;
  data_out  :out std_logic_vector (7 downto 0);
  data_push :out std_logic
);
end component;

signal rst         :std_logic;
signal clocka      :std_logic;
signal clockb      :std_logic;

signal source_data     :std_logic_vector(7 downto 0);
signal sink_data       :std_logic_vector(7 downto 0);
signal data_outa       :std_logic_vector(7 downto 0);
signal data_wumpus     :std_logic_vector(7 downto 0);
signal push_wumpus     :std_logic;
signal stall_data_sink :std_logic;

signal source_full      :std_logic;
signal source_empty     :std_logic;
signal source_filled    :std_logic_vector(8 downto 0);
signal source_wr        :std_logic;
signal halt_data_source :std_logic;
signal sink_empty       :std_logic;
signal sink_filled      :std_logic_vector(8 downto 0);
	
signal out_full :std_logic;
signal out_rd   :std_logic;
signal out_rdy  :std_logic;
	
signal wump_rdy  :std_logic;
signal in_rd     :std_logic;
signal pkt_avail :std_logic;
	
begin

-- combinational logic
rst              <= not key(0);
halt_data_source <= not key(1);
stall_data_sink  <= not key(2);
in_rd            <= wump_rdy and pkt_avail;
out_rdy          <= not out_full;

ledr(9 downto 0) <= "00" & sink_data;

plla :clocka_pll --200mhz
port map(
  rst      => '0',  
  refclk   => clock_50,
  outclk_0 => clocka,
  locked   => open );

pllb :clockb_pll-- 144mhz
port map (
  rst      => '0',
  refclk   => td_clk27,
  outclk_0 => clockb,
  locked   => open);

ds: data_source 
port map (
  clk       => clocka,
  rst       => rst,
  halt      => halt_data_source,
  full      => source_full,
  filled    => source_filled,
  pkt_avail => pkt_avail,
  data_out  => source_data,
  data_wr   => source_wr);

inbound: clocka_fifo 
port map (
  data	  => source_data,
  rdclk	  => clockb,
  rdreq	  => in_rd,
  wrclk    => clocka,
  wrreq    => source_wr,
  q        => data_outa,
  rdempty  => source_empty,
  rdusedw  => open,
  wrfull   => source_full,
  wrusedw  => source_filled);
			
wm: wumpus 
port map (
  clk       => clockb,
  rst       => rst,
  in_rdy    => wump_rdy,		
  out_rdy   => out_rdy,		
  data_in   => data_outa,
  push_in   => in_rd,
  data_out  => data_wumpus,
  data_push => push_wumpus);

outbound : clocka_fifo 
port map (
  data	  => data_wumpus,
  rdclk	  => clocka,
  rdreq	  => out_rd,
  wrclk	  => clockb,
  wrreq	  => push_wumpus,
  q	 	  => sink_data,
  rdempty  => sink_empty,
  rdusedw  => sink_filled,
  wrfull   => out_full,
  wrusedw  => open);

dk: data_sink 
port map (
  clk       => clocka,
  rst       => rst,
  stall     => stall_data_sink,
  empty     => sink_empty,
  available => sink_filled,
  data_rd   => out_rd);

 end architecture;




