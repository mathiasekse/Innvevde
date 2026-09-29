library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d2_counter_tb is
end entity d2_counter_tb;



architecture SimulationModel of d2_counter_tb is

   -----------------------------------------------------------------------------
   -- Constant declaration
   -----------------------------------------------------------------------------
   constant CLK_PER  : time    := 20 ns;    -- 50 MHz
   constant NUM_BITS : integer := 10;


   -----------------------------------------------------------------------------
   -- Component declarasion
   -----------------------------------------------------------------------------
   component d2_counter is
      generic (
         F_CNT    : natural := 5;     -- Simulate a count update every 100 ns 
         NUM_BITS : natural := 10);   -- Number of bits in output
      port (
         clk, rst, ena, cnt_sel: in  std_logic;
         count: out std_logic_vector(NUM_BITS-1 downto 0)
         );
   end component d2_counter;


   -----------------------------------------------------------------------------
   -- Signal declaration
   -----------------------------------------------------------------------------
   -- DUT signals
   signal clk, rst, ena, cnt_sel : std_logic;
   signal count                  : std_logic_vector(NUM_BITS-1 downto 0);

   -- Testbench signals
  

begin

   -----------------------------------------------------------------------------
   -- Component instantiations
   -----------------------------------------------------------------------------
   i_d2_counter: component d2_counter
   port map (
      clk     => clk,
      rst     => rst,
      ena     => ena,
      cnt_sel => cnt_sel,
      count   => count
   );


   -----------------------------------------------------------------------------
   -- purpose: control the clk-signal
   -- type   : sequential
   -- inputs : 
   -----------------------------------------------------------------------------
   p_clk: process
   begin
      clk <= '0';
      wait for CLK_PER/2;
      clk <= '1';
      wait for CLK_PER/2;
   end process p_clk;


   -----------------------------------------------------------------------------
   -- purpose: control the rst-signal
   -- type   : sequential
   -- inputs : 
   -----------------------------------------------------------------------------
   p_rst: process
   begin
      rst <= '0';
      wait for 2.2*CLK_PER;
      rst <= '1';
      wait;
   end process p_rst;

   -----------------------------------------------------------------------------
   -- purpose: Main process
   -- type   : sequential
   -- inputs : 
   -----------------------------------------------------------------------------
   p_main: process
   begin
      -- Initialize signals
      ena     <= '0';
      cnt_sel <= '0';

      wait until rst = '1';
      wait until rising_edge(clk);
      wait for 1 ps;

      -- Count binary
      ena <= '1';
      wait for 102400 ns;
      wait for 10*CLK_PER;
      ena <= '0';
      wait for 10*CLK_PER;

      -- Count with LFSR
      cnt_sel <= '1';
      ena <= '1';
      wait for 102400 ns;
      wait for 10*CLK_PER;
      ena <= '0';
      wait for 10*CLK_PER;
 
      assert false report "Testbench finished" severity failure;

   end process p_main;

end architecture SimulationModel;
