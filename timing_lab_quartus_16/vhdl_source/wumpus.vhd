LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity wumpus is 
port (
  clk       :in  std_logic;
  rst       :in  std_logic;
  in_rdy    :out std_logic;
  out_rdy   :in  std_logic;
  data_in   :in  std_logic_vector (7 downto 0);
  push_in   :in  std_logic;
  data_out  :out std_logic_vector (7 downto 0);
  data_push :out std_logic);
end entity;
	
architecture rtl of wumpus is

component frazzle is
port (
  din  :in  std_logic_vector(7 downto 0);
  dout :out std_logic_vector(7 downto 0));
end component;	

signal stage1 : std_logic_vector(7 downto 0);
signal stage2 : std_logic_vector(7 downto 0);
signal stage3 : std_logic_vector(7 downto 0);
signal stage4 : std_logic_vector(7 downto 0);
signal stage5 : std_logic_vector(7 downto 0);
signal stage6 : std_logic_vector(7 downto 0);

begin

in_rdy    <= out_rdy;
data_push <= push_in;

regs: process (clk, rst ) begin
  if (rst = '1') then
    stage1   <= (others => '0');
    data_out <= (others => '0'); 
  elsif (rising_edge(clk)) then
    if (push_in = '1') then
      stage1   <= data_in;
      data_out <= stage6;
    end if;
  end if;
end process;

f1: frazzle 
port map(
  din  => stage1,
  dout => stage2); --reg me

f2: frazzle 
port map ( 
  din  => stage2,
  dout => stage3); --reg me

f3: frazzle 
port map (
  din  => stage3,
  dout => stage4); --reg me

f4: frazzle 
port map (
  din  => stage4,
  dout => stage5); --reg me

f5: frazzle 
port map(
  din  => stage5,
  dout => stage6);

end architecture;

