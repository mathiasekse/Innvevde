library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity d1_alu is
  generic (
    NUM_BITS: integer := 3);
  
  port (
    a, b:     in  std_logic_vector(NUM_BITS-1 downto 0);
    op_code:  in  std_logic_vector(3 downto 0);
    result:   out std_logic_vector(NUM_BITS-1 downto 0)
  );
  end entity d1_alu;

architecture rtl of d1_alu is
  -- Definerer konstantene for de ulike instruksjonssettene
  constant OP_NOTA  : std_logic_vector(3 downto 0) := "0000";
  constant OP_NOTB  : std_logic_vector(3 downto 0) := "0001";
  constant OP_AND   : std_logic_vector(3 downto 0) := "0010";
  constant OP_OR    : std_logic_vector(3 downto 0) := "0011";
  constant OP_NAND  : std_logic_vector(3 downto 0) := "0100";
  constant OP_NOR   : std_logic_vector(3 downto 0) := "0101";
  constant OP_XOR   : std_logic_vector(3 downto 0) := "0110";
  constant OP_XNOR  : std_logic_vector(3 downto 0) := "0111";
  constant OP_TRA   : std_logic_vector(3 downto 0) := "1000";
  constant OP_TRB   : std_logic_vector(3 downto 0) := "1001";
  constant OP_INCA  : std_logic_vector(3 downto 0) := "1010";
  constant OP_INCB  : std_logic_vector(3 downto 0) := "1011";
  constant OP_DECA  : std_logic_vector(3 downto 0) := "1100";
  constant OP_DECB  : std_logic_vector(3 downto 0) := "1101";
  constant OP_ADD   : std_logic_vector(3 downto 0) := "1110";
  -- constant OP_NONE  : std_logic_vector(3 downto 0) := "1111"; -- Overflødig ved bruk av (others => 0)

  
begin
  -- Tilegner logisk/aritmetisk funksjon til de ulike operasjonskodene
  with op_code select
    result <= not a                                       when OP_NOTA,
              not b                                       when OP_NOTB,
              a and b                                     when OP_AND,
              a or b                                      when OP_OR,
              a nand b                                    when OP_NAND,
              a nor b                                     when OP_NOR,
              a xor b                                     when OP_XOR,
              a xnor b                                    when OP_XNOR,
              a                                           when OP_TRA,
              b                                           when OP_TRB,
              std_logic_vector(unsigned(a) + 1)           when OP_INCA,
              std_logic_vector(unsigned(b) + 1)           when OP_INCB,
              std_logic_vector(unsigned(a) - 1)           when OP_DECA,
              std_logic_vector(unsigned(b) - 1)           when OP_DECB,
              std_logic_vector(unsigned(a) + unsigned(b)) when OP_ADD,
              (others => '0')                               when others;
end architecture rtl;