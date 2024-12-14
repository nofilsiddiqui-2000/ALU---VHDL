-- tb_array_multiplier.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_array_multiplier is
end tb_array_multiplier;

architecture Behavioral of tb_array_multiplier is
    constant N : integer := 8;  -- Bit-width (should match array_multiplier)
    
    -- Testbench signals
    signal A       : std_logic_vector(N-1 downto 0);
    signal B       : std_logic_vector(N-1 downto 0);
    signal Y       : std_logic_vector(2*N-1 downto 0);
    
    -- Instantiate the array multiplier component
    component array_multiplier
        generic (
            N : integer := 8
        );
        port (
            A : in  STD_LOGIC_VECTOR(N-1 downto 0);
            B : in  STD_LOGIC_VECTOR(N-1 downto 0);
            Y : out STD_LOGIC_VECTOR(2*N-1 downto 0)
        );
    end component;
    
begin
    -- Unit Under Test (UUT) instantiation
    uut: array_multiplier
        generic map (
            N => N
        )
        port map (
            A => A,
            B => B,
            Y => Y
        );
    
    -- Test process to apply multiple test cases
    process
    begin
        -- Test case 1: 3 * 2 = 6
        A <= std_logic_vector(to_signed(3, N));
        B <= std_logic_vector(to_signed(2, N));
        wait for 10 ns;
        report "Test Case 1: 3 * 2 = " & integer'image(to_integer(signed(Y)));
        assert to_integer(signed(Y)) = 6
            report "Test Case 1 Failed: Expected 6, Got " & integer'image(to_integer(signed(Y)))
            severity error;
        
        -- Test case 2: -4 * 5 = -20
        A <= std_logic_vector(to_signed(-4, N));
        B <= std_logic_vector(to_signed(5, N));
        wait for 10 ns;
        report "Test Case 2: -4 * 5 = " & integer'image(to_integer(signed(Y)));
        assert to_integer(signed(Y)) = -20
            report "Test Case 2 Failed: Expected -20, Got " & integer'image(to_integer(signed(Y)))
            severity error;
        
        -- Test case 3: -7 * -3 = 21
        A <= std_logic_vector(to_signed(-7, N));
        B <= std_logic_vector(to_signed(-3, N));
        wait for 10 ns;
        report "Test Case 3: -7 * -3 = " & integer'image(to_integer(signed(Y)));
        assert to_integer(signed(Y)) = 21
            report "Test Case 3 Failed: Expected 21, Got " & integer'image(to_integer(signed(Y)))
            severity error;
        
        -- Test case 4: 0 * 0 = 0
        A <= (others => '0');
        B <= (others => '0');
        wait for 10 ns;
        report "Test Case 4: 0 * 0 = " & integer'image(to_integer(signed(Y)));
        assert to_integer(signed(Y)) = 0
            report "Test Case 4 Failed: Expected 0, Got " & integer'image(to_integer(signed(Y)))
            severity error;
        
        -- Test case 5: 127 * 1 = 127
        A <= std_logic_vector(to_signed(127, N));
        B <= std_logic_vector(to_signed(1, N));
        wait for 10 ns;
        report "Test Case 5: 127 * 1 = " & integer'image(to_integer(signed(Y)));
        assert to_integer(signed(Y)) = 127
            report "Test Case 5 Failed: Expected 127, Got " & integer'image(to_integer(signed(Y)))
            severity error;
        
        -- Test case 6: -128 * 2 = -256
        A <= std_logic_vector(to_signed(-128, N));
        B <= std_logic_vector(to_signed(2, N));
        wait for 10 ns;
        report "Test Case 6: -128 * 2 = " & integer'image(to_integer(signed(Y)));
        assert to_integer(signed(Y)) = -256
            report "Test Case 6 Failed: Expected -256, Got " & integer'image(to_integer(signed(Y)))
            severity error;
        
        -- Test case 7: 15 * 15 = 225
        A <= std_logic_vector(to_signed(15, N));
        B <= std_logic_vector(to_signed(15, N));
        wait for 10 ns;
        report "Test Case 7: 15 * 15 = " & integer'image(to_integer(signed(Y)));
        assert to_integer(signed(Y)) = 225
            report "Test Case 7 Failed: Expected 225, Got " & integer'image(to_integer(signed(Y)))
            severity error;
        
        -- End simulation
        wait;
    end process;
    
end Behavioral;
