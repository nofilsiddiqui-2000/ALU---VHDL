-- tb_top_module.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_top_module is
end tb_top_module;

architecture Behavioral of tb_top_module is
    constant N : integer := 8;  -- Bit-width (should match top_module and array_multiplier)
    
    -- Testbench signals
    signal clk     : std_logic := '0';
    signal reset_n : std_logic := '1';
    signal load    : std_logic := '0';
    signal a       : std_logic_vector(N-1 downto 0);
    signal b       : std_logic_vector(N-1 downto 0);
    signal c       : std_logic_vector(7 downto 0);
    signal D       : std_logic_vector(N-1 downto 0);
    signal P       : std_logic_vector(2*N downto 0);
    signal status  : std_logic;
    
    -- Instantiate the top_module
    component top_module
        generic (
            N : integer := 8
        );
        port (
            clk     : in  std_logic;
            reset_n : in  std_logic;
            load    : in  std_logic;
            a       : in  std_logic_vector(N-1 downto 0);
            b       : in  std_logic_vector(N-1 downto 0);
            c       : in  std_logic_vector(7 downto 0);
            D       : in  std_logic_vector(N-1 downto 0);
            P       : out std_logic_vector(2*N downto 0);
            status  : out std_logic
        );
    end component;
    
begin
    -- Clock generation: 10 ns period
    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    -- Instantiate the top_module
    uut: top_module
        generic map (
            N => N
        )
        port map (
            clk     => clk,
            reset_n => reset_n,
            load    => load,
            a       => a,
            b       => b,
            c       => c,
            D       => D,
            P       => P,
            status  => status
        );
    
    -- Test process to apply multiple test cases
    process
    begin
        -- Initialize Inputs
        reset_n <= '0';
        load    <= '0';
        a       <= (others => '0');
        b       <= (others => '0');
        c       <= (others => '0');
        D       <= (others => '0');
        wait for 10 ns;
        reset_n <= '1';
        wait for 10 ns;
        
        -- Test case 1: 3 * 2 = 6
        load <= '1';
        a    <= std_logic_vector(to_signed(3, N));
        b    <= std_logic_vector(to_signed(2, N));
        c    <= "00000000";  -- 2^0 =1
        D    <= (others => '0');
        wait for 10 ns;
        load <= '0';
        wait for 20 ns;  -- Wait for MULTIPLY, DIVIDE, ADD, DONE
        
        -- Test case 2: -4 * 5 = -20
        load <= '1';
        a    <= std_logic_vector(to_signed(-4, N));
        b    <= std_logic_vector(to_signed(5, N));
        c    <= "00000000";  -- 2^0 =1
        D    <= (others => '0');
        wait for 10 ns;
        load <= '0';
        wait for 20 ns;
        
        -- Test case 3: -7 * -3 = 21
        load <= '1';
        a    <= std_logic_vector(to_signed(-7, N));
        b    <= std_logic_vector(to_signed(-3, N));
        c    <= "00000000";  -- 2^0 =1
        D    <= (others => '0');
        wait for 10 ns;
        load <= '0';
        wait for 20 ns;
        
        -- Test case 4: 0 * 0 = 0
        load <= '1';
        a    <= (others => '0');
        b    <= (others => '0');
        c    <= "00000000";  -- 2^0 =1
        D    <= (others => '0');
        wait for 10 ns;
        load <= '0';
        wait for 20 ns;
        
        -- Test case 5: 127 * 1 = 127
        load <= '1';
        a    <= std_logic_vector(to_signed(127, N));
        b    <= std_logic_vector(to_signed(1, N));
        c    <= "00000000";  -- 2^0 =1
        D    <= (others => '0');
        wait for 10 ns;
        load <= '0';
        wait for 20 ns;
        
        -- Test case 6: -128 * 2 = -256
        load <= '1';
        a    <= std_logic_vector(to_signed(-128, N));
        b    <= std_logic_vector(to_signed(2, N));
        c    <= "00000000";  -- 2^0 =1
        D    <= (others => '0');
        wait for 10 ns;
        load <= '0';
        wait for 20 ns;
        
        -- Test case 7: 15 * 15 = 225
        load <= '1';
        a    <= std_logic_vector(to_signed(15, N));
        b    <= std_logic_vector(to_signed(15, N));
        c    <= "00000000";  -- 2^0 =1
        D    <= (others => '0');
        wait for 10 ns;
        load <= '0';
        wait for 20 ns;
        
        -- Test case 8: -16 * 16 = -256
        load <= '1';
        a    <= std_logic_vector(to_signed(-16, N));
        b    <= std_logic_vector(to_signed(16, N));
        c    <= "00000000";  -- 2^0 =1
        D    <= (others => '0');
        wait for 10 ns;
        load <= '0';
        wait for 20 ns;
        
        -- End of Testbench
        wait;
    end process;

end Behavioral;

