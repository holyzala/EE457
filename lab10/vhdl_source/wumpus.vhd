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
signal stage2_1 : std_logic_vector(7 downto 0);
signal stage3_1 : std_logic_vector(7 downto 0);
signal stage4_1 : std_logic_vector(7 downto 0);
signal stage5_1 : std_logic_vector(7 downto 0);

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
  dout => stage2);

process (clk, stage2) begin
	if rising_edge(clk) then
		stage2_1 <= stage2;
	end if;
end process;

f2: frazzle 
port map ( 
  din  => stage2_1,
  dout => stage3);

process (clk, stage3) begin
	if rising_edge(clk) then
		stage3_1 <= stage3;
	end if;
end process;

f3: frazzle 
port map (
  din  => stage3_1,
  dout => stage4);
  
process (clk, stage4) begin
	if rising_edge(clk) then
		stage4_1 <= stage4;
	end if;
end process;

f4: frazzle 
port map (
  din  => stage4_1,
  dout => stage5);
  
process (clk, stage5) begin
	if rising_edge(clk) then
		stage5_1 <= stage5;
	end if;
end process;

f5: frazzle 
port map(
  din  => stage5_1,
  dout => stage6);

end architecture;

