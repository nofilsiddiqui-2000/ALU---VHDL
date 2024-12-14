library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity divider_by_2c is
    generic (
        N : integer := 8  -- Bit-width of the input product (half of the size of product_in)
    );
    port (
        product_in  : in  std_logic_vector(2*N-1 downto 0);  -- Signed input product
        c           : in  std_logic_vector(7 downto 0);      -- Unsigned input c
        product_out : out std_logic_vector(2*N-1 downto 0)   -- Signed output (product_in)/(2^c)
    );
end divider_by_2c;

architecture Behavioral of divider_by_2c is
    signal shift_amt   : integer;
    signal product_s   : signed(2*N-1 downto 0);
    signal product_div : signed(2*N-1 downto 0);
begin
    -- Convert 'c' to integer
    shift_amt <= to_integer(unsigned(c));

    -- Convert input to signed
    product_s <= signed(product_in);

    -- Perform arithmetic right shift using shift_right function
    process(product_s, shift_amt)
    begin
        if shift_amt >= product_s'length then
            if product_s(product_s'high) = '0' then
                product_div <= (others => '0');
            else
                product_div <= (others => '1');
            end if;
        else
            product_div <= shift_right(product_s, shift_amt);
        end if;
    end process;

    -- Assign the output
    product_out <= std_logic_vector(product_div);
end Behavioral;
