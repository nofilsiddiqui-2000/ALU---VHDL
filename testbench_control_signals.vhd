library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testbench_control_signals is
end testbench_control_signals;

architecture Behavioral of testbench_control_signals is

    -- Component Declaration for the Unit Under Test (UUT)
    component top_module
        generic (
            N : integer := 8  -- Set the bit-width to 8 bits
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

    -- Signals to connect to the UUT
    signal clk_tb     : std_logic := '0';
    signal reset_n_tb : std_logic := '1';  -- Start with reset not asserted
    signal load_tb    : std_logic := '0';
    signal a_tb       : std_logic_vector(7 downto 0) := (others => '0');
    signal b_tb       : std_logic_vector(7 downto 0) := (others => '0');
    signal c_tb       : std_logic_vector(7 downto 0) := (others => '0');
    signal D_tb       : std_logic_vector(7 downto 0) := (others => '0');
    signal P_tb       : std_logic_vector(16 downto 0);
    signal status_tb  : std_logic;

    -- Constant for zero comparison
    constant ZERO_VECTOR : std_logic_vector(16 downto 0) := (others => '0');

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: top_module
        generic map (
            N => 8  -- Set N to 8 bits
        )
        port map (
            clk     => clk_tb,
            reset_n => reset_n_tb,
            load    => load_tb,
            a       => a_tb,
            b       => b_tb,
            c       => c_tb,
            D       => D_tb,
            P       => P_tb,
            status  => status_tb
        );

    -- Clock generation
    clk_process: process
    begin
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end process;

    -- Control Signals Test Process
    control_test_proc: process
        -- Variables must be declared here, at the beginning of the process
        variable initial_P       : std_logic_vector(16 downto 0);
        variable expected_result : integer;
    begin
        -- Scenario 1: Assert reset while load is high
        -- Expected behavior: No calculation is performed, outputs remain zero

        -- Set initial inputs
        a_tb <= std_logic_vector(to_signed(20, 8));
        b_tb <= std_logic_vector(to_signed(15, 8));
        c_tb <= std_logic_vector(to_unsigned(2, 8));
        D_tb <= std_logic_vector(to_unsigned(10, 8));

        -- Assert reset and load simultaneously
        reset_n_tb <= '0';
        load_tb <= '1';
        wait for 20 ns;

        -- Deassert reset and load
        reset_n_tb <= '1';
        load_tb <= '0';
        wait for 20 ns;

        -- Check that status remains '0' and outputs are zero
        assert status_tb = '0'
            report "Scenario 1 Failed: Status should remain '0' during reset" severity error;
        assert P_tb = ZERO_VECTOR
            report "Scenario 1 Failed: Output P should be zero during reset" severity error;

        -- Scenario 2: Provide inputs without asserting load
        -- Expected behavior: No calculation is performed, status remains '0', output remains unchanged

        -- Set new inputs
        a_tb <= std_logic_vector(to_signed(-30, 8));
        b_tb <= std_logic_vector(to_signed(25, 8));
        c_tb <= std_logic_vector(to_unsigned(3, 8));
        D_tb <= std_logic_vector(to_unsigned(5, 8));

        -- Store initial output
        initial_P := P_tb;

        -- Wait for a few clock cycles without asserting load
        wait for 60 ns;

        -- Check that status remains '0' and output remains unchanged
        assert status_tb = '0'
            report "Scenario 2 Failed: Status should remain '0' when load is not asserted" severity error;
        assert P_tb = initial_P
            report "Scenario 2 Failed: Output P should remain unchanged when load is not asserted" severity error;

        -- Scenario 3: Assert reset during a calculation
        -- Expected behavior: Calculation is aborted, outputs are reset

        -- Assert load to start calculation
        load_tb <= '1';
        wait until rising_edge(clk_tb);
        load_tb <= '0';

        -- Wait for one clock cycle, then assert reset
        wait for 30 ns;
        reset_n_tb <= '0';
        wait for 20 ns;
        reset_n_tb <= '1';

        -- Check that status is '0' and outputs are reset
        assert status_tb = '0'
            report "Scenario 3 Failed: Status should be '0' after reset" severity error;
        assert P_tb = ZERO_VECTOR
            report "Scenario 3 Failed: Output P should be zero after reset" severity error;

        -- Scenario 4: Assert load with valid inputs
        -- Expected behavior: Calculation is performed when load is asserted

        -- Set inputs
        a_tb <= std_logic_vector(to_signed(10, 8));
        b_tb <= std_logic_vector(to_signed(-5, 8));
        c_tb <= std_logic_vector(to_unsigned(1, 8));
        D_tb <= std_logic_vector(to_unsigned(2, 8));

        load_tb <= '1';
        wait until rising_edge(clk_tb);
        load_tb <= '0';

        -- Wait for calculation to complete
        wait until status_tb = '1';

        -- Calculate expected result
        expected_result := ((10 * (-5)) / 2) + 2;

        -- Check the result
        assert to_integer(signed(P_tb)) = expected_result
            report "Scenario 4 Failed: Calculation incorrect" severity error;

        -- Wait for status to return to '0'
        wait until status_tb = '0';

        -- Scenario 5: Do not assert load after previous calculation
        -- Expected behavior: No new calculation is performed, status remains '0', output remains unchanged

        -- Store current output
        initial_P := P_tb;

        -- Wait for several clock cycles without asserting load
        wait for 100 ns;

        -- Check that status remains '0' and output remains unchanged
        assert status_tb = '0'
            report "Scenario 5 Failed: Status should remain '0' without new load" severity error;
        assert P_tb = initial_P
            report "Scenario 5 Failed: Output P should remain unchanged without new load" severity error;

        -- End simulation
        report "Control Signals Testbench completed successfully." severity note;
        wait;
    end process;

end Behavioral;
