library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d4_pwm_tb is
end entity d4_pwm_tb;



architecture SimulationModel of d4_pwm_tb is

  ------------------------------------------------------------
  -- Constant declaration
  ------------------------------------------------------------
  constant CLK_PER : time    := 20 ns;   -- 50 MHz
  constant BITS    : integer := 3;
  constant T_PWM   : time    := (2**BITS - 1) * 3 * CLK_PER;  -- 420 ns


  ------------------------------------------------------------
  -- Component declaration
  ------------------------------------------------------------
  component d4_pwm is
    generic (
    CLK_PWM_PER : natural := 60;  -- ns
    CLK_SYS_PER : natural := 20;  -- ns (f_clk = 50 MHz)
    BITS        : natural := 3);
    port (
      clk     : in  std_logic;
      rstn    : in  std_logic;
      duty    : in  std_logic_vector(BITS-1 downto 0);
      pwm_out : out std_logic
    );
  end component d4_pwm;

  ------------------------------------------------------------
  -- Signal declaration
  ------------------------------------------------------------
  -- DUT signals
  signal clk, rstn, pwm_out : std_logic := '0';
  signal duty               : std_logic_vector(BITS-1 downto 0) := (others => '0');

  -- Testbench signals
begin

  ------------------------------------------------------------
  -- Component instantiations
  ------------------------------------------------------------
  i_d4_pwm: component d4_pwm
  port map (
    clk     => clk,
    rstn    => rstn,
    duty    => duty,
    pwm_out => pwm_out
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
  p_rstn: process
  begin
    rstn <= '0';
    wait for 2.2*CLK_PER;
    rstn <= '1';
    wait;
  end process p_rstn;


  -----------------------------------------------------------------------------
    -- purpose: Main process
    -- type   : sequential
    -- inputs : 
  -----------------------------------------------------------------------------
  p_main: process
  begin
    -- Initialize signals
    duty <= (others => '0');

    -- Vent til reset er sluppet
    wait until rstn = '1';
    wait until rising_edge(clk);

    for i in 0 to 2**BITS - 1 loop
      duty <= std_logic_vector(to_unsigned(i, BITS));
      wait for 2 * T_PWM;
    end loop;

    assert false report "Testbench finished" severity failure;
      
    end process p_main;
end architecture SimulationModel;