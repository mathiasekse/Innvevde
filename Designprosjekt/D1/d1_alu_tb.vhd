library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d1_alu_tb is
end entity d1_alu_tb;



architecture SimulationModel of d1_alu_tb is

   -----------------------------------------------------------------------------
   -- Constant declaration
   -----------------------------------------------------------------------------
   constant DATAA : std_logic_vector(3 downto 0) := "0111";
   constant DATAB : std_logic_vector(3 downto 0) := "1011";


   -----------------------------------------------------------------------------
   -- Component declarasion
   -----------------------------------------------------------------------------
   component d1_alu is
      generic (
         NUM_BITS: integer := 4);
      port (
         a, b:    in  std_logic_vector(NUM_BITS-1 downto 0);
         op_code: in  std_logic_vector(3 downto 0);
         result:  out std_logic_vector(NUM_BITS-1 downto 0)
      );
   end component d1_alu;


   -----------------------------------------------------------------------------
   -- Signal declaration
   -----------------------------------------------------------------------------
   -- DUT signals
   signal a       : std_logic_vector(3 downto 0);
   signal b       : std_logic_vector(3 downto 0);
   signal op_code : std_logic_vector(3 downto 0);
   signal result  : std_logic_vector(3 downto 0);

   -- Testbench signals
  

begin

   -----------------------------------------------------------------------------
   -- Component instantiations
   -----------------------------------------------------------------------------
   i_exercise1: component d1_alu
   port map (
      a       => a,
      b       => b,
      op_code => op_code,
      result  => result
   );


   -----------------------------------------------------------------------------
   -- purpose: Main process
   -- type   : sequential
   -- inputs : 
   -----------------------------------------------------------------------------
   p_main: process
   begin
      -- Initialize signals
      a <= DATAA;
      b <= DATAB;
      op_code <= "0000";

      wait for 10 ns;
      -- Check respons on Result = not a
      assert result = (not DATAA)
         report "Result NOT correct when op_code=0000" severity error;

      op_code <= "0001";
      wait for 10 ns;
      -- Check respons on Result = not b
      assert result = (not DATAB)
         report "Result NOT correct when op_code=0001" severity error;

      op_code <= "0010";
      wait for 10 ns;
      -- Check respons on Result = a and b
      assert result = (DATAA and DATAB)
         report "Result NOT correct when op_code=0010" severity error;

      op_code <= "0011";
      wait for 10 ns;
      -- Check respons on Result = a or b
      assert result = (DATAA or DATAB)
         report "Result NOT correct when op_code=0011" severity error;

      op_code <= "0100";
      wait for 10 ns;
      -- Check respons on Result = a nand b
      assert result = (DATAA nand DATAB)
         report "Result NOT correct when op_code=0100" severity error;

      op_code <= "0101";
      wait for 10 ns;
      -- Check respons on Result = a nor b
      assert result = (DATAA nor DATAB)
         report "Result NOT correct when op_code=0101" severity error;

      op_code <= "0110";
      wait for 10 ns;
      -- Check respons on Result = a xor b
      assert result = (DATAA xor DATAB)
         report "Result NOT correct when op_code=0110" severity error;

      op_code <= "0111";
      wait for 10 ns;
      -- Check respons on Result = a xnor b
      assert result = (DATAA xnor DATAB)
         report "Result NOT correct when op_code=0111" severity error;

      op_code <= "1000";
      wait for 10 ns;
      -- Check respons on Result = a
      assert result = DATAA
         report "Result NOT correct when op_code=1000" severity error;

      op_code <= "1001";
      wait for 10 ns;
      -- Check respons on Result = b
      assert result = DATAB
         report "Result NOT correct when op_code=1001" severity error;

      op_code <= "1010";
      wait for 10 ns;
      -- Check respons on Result = a + 1
      assert result = std_logic_vector(signed(DATAA) + 1)
         report "Result NOT correct when op_code=1010" severity error;

      op_code <= "1011";
      wait for 10 ns;
      -- Check respons on Result = b + 1
      assert result = std_logic_vector(signed(DATAB) + 1)
         report "Result NOT correct when op_code=1011" severity error;

      op_code <= "1100";
      wait for 10 ns;
      -- Check respons on Result = a - 1
      assert result = std_logic_vector(signed(DATAA) - 1)
         report "Result NOT correct when op_code=1100" severity error;

      op_code <= "1101";
      wait for 10 ns;
      -- Check respons on Result = b - 1
      assert result = std_logic_vector(signed(DATAB) - 1)
         report "Result NOT correct when op_code=1101" severity error;

      op_code <= "1110";
      wait for 10 ns;
      -- Check respons on Result = a + b
      assert result = std_logic_vector(signed(DATAA) + signed(DATAB))
         report "Result NOT correct when op_code=1110" severity error;

      op_code <= "1111";
      wait for 10 ns;
      -- Check respons on Result = all zeros
      assert result = "0000" report "Result NOT correct when op_code=1111" severity error;


      op_code <= "0000";
      wait for 10 ns;
      assert false report "Testbench finished" severity failure;

   end process p_main;

end architecture SimulationModel;
