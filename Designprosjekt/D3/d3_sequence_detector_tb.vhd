---------------------------------------------------------------------------------
-- Testbench of d3_sequence_detector
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Entity of testbench (empty)
entity d3_sequence_detector_tb is
end d3_sequence_detector_tb;


architecture SimulationModel of d3_sequence_detector_tb is

   -----------------------------------------------------------------------------
   -- Constant declaration
   -----------------------------------------------------------------------------
   constant c_ClkPer : time := 20 ns;      -- 50 MHz

   -- Data sequence for testing of detection
   constant c_data   : std_logic_vector(15 downto 0) := "0100101101011010";


   -----------------------------------------------------------------------------
   -- Component declarasion
   -----------------------------------------------------------------------------
   component d3_sequence_detector
      port (
         clk       : in  std_logic;
         rst       : in  std_logic;
         data      : in  std_logic;
         seq_found : out std_logic
      );
   end component d3_sequence_detector;


   -----------------------------------------------------------------------------
   -- Signal declaration
   -----------------------------------------------------------------------------
   -- DUT signals
   signal clk       : std_logic;
   signal rst       : std_logic;
   signal data      : std_logic;
   signal seq_found : std_logic;

   -- Testbench signals
   signal fasit    : std_logic;
  

begin

   -----------------------------------------------------------------------------
   -- Component instantiations
   -----------------------------------------------------------------------------
   i_d3_sequence_detector: component d3_sequence_detector
    port map (
      clk       => clk,
      rst       => rst,
      data      => data,
      seq_found => seq_found
      );


   -----------------------------------------------------------------------------
   -- purpose: Generation of clock
   -- type   : sequential
   -- inputs : none
   -- outputs: clk
   -----------------------------------------------------------------------------
   p_clk: process is
   begin  -- process p_clk
      clk <= '0';
      wait for c_ClkPer/2;
      clk <= '1';
      wait for c_ClkPer/2;
   end process p_clk;


   -----------------------------------------------------------------------------
   -- purpose: Generation of reset
   -- type   : sequential
   -- inputs : none
   -- outputs: reset
   -----------------------------------------------------------------------------
   p_rst: process is
   begin  -- process p_rst
      rst <= '1';
      wait for 2.2*c_ClkPer;
      rst <= '0';
      wait;
   end process p_rst;


   -----------------------------------------------------------------------------
   -- purpose: Main process
   -- type   : sequential
   -- inputs : 
   -----------------------------------------------------------------------------
   p_main: process
      variable v_fasit : std_logic;
   begin
      -- Initialize signals
      data  <= '0';

      -- Initialize variables
      fasit <= '0';

      -- Wait for falling edge after reset
      wait until rst = '0';
      wait until rising_edge(Clk);

      -- Create data signal and check response
      for i in c_data'length-1 downto 0 loop
         data <= c_data(i);
         wait until rising_edge(Clk);
         wait for 1 ns;
         if i < c_data'length-4 then
            fasit <= c_data(i+3) and not c_data(i+2) and c_data(i+1) and c_data(i);
            wait for 1 ns;
            assert seq_found = fasit report "Wrong state on seqFound signal" severity error;
         else
            fasit <= '0';
            wait for 1 ns;
            assert seq_found = fasit report "Wrong state on seqFound signal" severity error;
         end if;
      end loop;

      -- Terminate testbench
      wait for c_ClkPer;
      assert false report "Testbench finished" severity failure;

   end process p_main;

end architecture SimulationModel;

