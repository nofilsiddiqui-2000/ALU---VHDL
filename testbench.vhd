library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testbench is
end testbench;

architecture Behavioral of testbench is

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

    -- Stimulus Process
    stim_proc: process
        -- Variables for integer representation
        variable a_int       : integer;
        variable b_int       : integer;
        variable c_int       : integer;
        variable D_int       : integer;
        variable product_int : integer;
        variable result_int  : integer;
    begin
        -- Assert reset
        reset_n_tb <= '0';
        wait for 20 ns;
        reset_n_tb <= '1';  -- Deassert reset

        -- Wait for a clock cycle
        wait until rising_edge(clk_tb);

        -- *********** Test Case 1 ***********
        -- Inputs: a = 18, b = -52, c = 3, D = 25
        -- Expected Result: (-936 / 8) + 25 = -117 + 25 = -92
        a_tb <= std_logic_vector(to_signed(18, 8));
        b_tb <= std_logic_vector(to_signed(-52, 8));
        c_tb <= std_logic_vector(to_unsigned(3, 8));
        D_tb <= std_logic_vector(to_unsigned(25, 8));

        -- Assert load
        load_tb <= '1';
        wait until rising_edge(clk_tb);
        load_tb <= '0';

        -- Wait for calculation to complete
        wait until status_tb = '1';

        -- Calculate expected result
        a_int := 18;
        b_int := -52;
        c_int := 3;
        D_int := 25;
        product_int := a_int * b_int;
        result_int := (product_int / (2 ** c_int)) + D_int;

        -- Check the result
        assert to_integer(signed(P_tb)) = result_int
            report "Test Case 1 Failed" severity error;

        -- Wait for status to return to '0'
        wait until status_tb = '0';

        -- Wait for a clock cycle
        wait until rising_edge(clk_tb);

        -- *********** Test Case 2 ***********
        -- Inputs: a = -128, b = 1, c = 0, D = 100
        -- Expected Result: (-128 / 1) + 100 = -128 + 100 = -28
        a_tb <= std_logic_vector(to_signed(-128, 8));
        b_tb <= std_logic_vector(to_signed(1, 8));
        c_tb <= std_logic_vector(to_unsigned(0, 8));
        D_tb <= std_logic_vector(to_unsigned(100, 8));

        -- Assert load
        load_tb <= '1';
        wait until rising_edge(clk_tb);
        load_tb <= '0';

        -- Wait for calculation to complete
        wait until status_tb = '1';

        -- Calculate expected result
        a_int := -128;
        b_int := 1;
        c_int := 0;
        D_int := 100;
        product_int := a_int * b_int;
        result_int := (product_int / (2 ** c_int)) + D_int;

        -- Check the result
        assert to_integer(signed(P_tb)) = result_int
            report "Test Case 2 Failed" severity error;

        -- Wait for status to return to '0'
        wait until status_tb = '0';

        -- Wait for a clock cycle
        wait until rising_edge(clk_tb);

        -- *********** Test Case 3 ***********
        -- Inputs: a = -85, b = -85, c = 4, D = 50
        -- Expected Result: (7225 / 16) + 50 = 451 + 50 = 501
        a_tb <= std_logic_vector(to_signed(-85, 8));
        b_tb <= std_logic_vector(to_signed(-85, 8));
        c_tb <= std_logic_vector(to_unsigned(4, 8));
        D_tb <= std_logic_vector(to_unsigned(50, 8));

        -- Assert load
        load_tb <= '1';
        wait until rising_edge(clk_tb);
        load_tb <= '0';

        -- Wait for calculation to complete
        wait until status_tb = '1';

        -- Calculate expected result
        a_int := -85;
        b_int := -85;
        c_int := 4;
        D_int := 50;
        product_int := a_int * b_int;
        result_int := (product_int / (2 ** c_int)) + D_int;

        -- Check the result
        assert to_integer(signed(P_tb)) = result_int
            report "Test Case 3 Failed" severity error;

        -- Wait for status to return to '0'
        wait until status_tb = '0';

        -- End simulation
        report "Testbench completed successfully." severity note;
        wait;
    end process;

end Behavioral;
