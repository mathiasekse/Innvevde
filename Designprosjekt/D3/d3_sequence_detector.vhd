library ieee;
use ieee.std_logic_1164.all;

entity d3_sequence_detector is
  port(
    clk       : in std_logic;
    rst       : in std_logic;
    data      : in std_logic;
    seq_found : out std_logic
  );
end entity d3_sequence_detector;


architecture fsm_rtl of d3_sequence_detector is
  -- Tilegner hver av de 5 tilstandene en 3-bits kode
  -- Bruker std_logic_vector for å bestemme utfallet av de ubrukte kodene 101, 110 og 111, som går til S0 via when others.
  subtype t_state is std_logic_vector(2 downto 0);
  
  constant S0 : t_state := "000";  -- Ingen mønster sett
  constant S1 : t_state := "001";  -- Sett '1'
  constant S2 : t_state := "010";  -- Sett "10"
  constant S3 : t_state := "011";  -- Sett "101"
  constant S4 : t_state := "100";  -- Sett "1011" (altså funnet sekvens)

  signal state      : t_state := S0;     -- Nåværende tilstand
  signal next_state : t_state;           -- Neste tilstand

begin
  -- Sekvensiell prosess som sjekker tilstand
  -- Sjekk av asynkron reset, deretter oppdatering på klokkens stigende flanke
  p_state: process(clk, rst)
  begin
    if rst = '1' then
      state <= S0;
    elsif rising_edge(clk) then
      state <= next_state;          -- State endres til valgt neste tilstand
    end if;
  end process p_state;


  -- Kombinatorisk prosess som velger neste tilstand basert på data
  p_next_state : process(state, data)
  begin
    next_state <= S0;

    case state is
      when S0 =>
        if data = '1' then
          next_state <= S1;
        else 
          next_state <= S0;
        end if;
      when S1 =>
        if data = '1' then
          next_state <= S1;
        else 
          next_state <= S2;
        end if;
      when S2 => 
        if data = '1' then
          next_state <= S3;
        else 
          next_state <= S0;
        end if;
      when S3 =>
        if data = '1' then
          next_state <= S4;
        else 
          next_state <= S2;
        end if;
      when S4 =>
        if data = '1' then
          next_state <= S1;
        else 
          next_state <= S2;
        end if;
      when others =>
        next_state <= S0;
    end case;


  end process p_next_state;
  -- Setter til slutt seq_found = 1 dersom bitmønster '1011' oppdages.
  seq_found <= '1' when state = S4 else '0';

end architecture fsm_rtl;


architecture sr_rtl of d3_sequence_detector is
  constant correct_sequence : std_logic_vector(3 downto 0) := "1011";
  signal data_sequence      : std_logic_vector(3 downto 0) := "0000";

begin

  p_shift_register : process(clk, rst)
  begin
    if rst = '1' then
      data_sequence <= "0000";

    elsif rising_edge(clk) then
      data_sequence <= data_sequence(2 downto 0) & data;
    end if;

  end process p_shift_register;

  seq_found <= '1' when data_sequence = correct_sequence else '0';

end architecture sr_rtl;