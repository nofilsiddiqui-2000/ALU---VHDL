library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity incrementer is
    generic (
        N : integer := 8  -- Bit-width of the input D
    );
    port (
        div_in      : in  std_logic_vector(2*N-1 downto 0);  -- Signed input from the divider
        D           : in  std_logic_vector(N-1 downto 0);    -- Unsigned input D
        sum_out     : out std_logic_vector(2*N downto 0)     -- Signed output (div_in) + D
    );
end incrementer;

architecture Behavioral of incrementer is
    signal div_signed : signed(2*N-1 downto 0);
    signal D_extended : signed(2*N downto 0);
    signal sum_result : signed(2*N downto 0);
begin
    -- Convert div_in to signed
    div_signed <= signed(div_in);

    -- Extend D to match the size of div_signed
    D_extended <= resize(signed(('0' & D)), 2*N+1);

    -- Perform addition
    sum_result <= resize(div_signed, 2*N+1) + D_extended;

    -- Assign the result to the output
    sum_out <= std_logic_vector(sum_result);
end Behavioral;

-- 