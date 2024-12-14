-- array_multiplier.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity array_multiplier is
    generic (
        N : integer := 8  -- Bit-width of inputs A and B
    );
    Port (
        A : in  STD_LOGIC_VECTOR(N-1 downto 0);  -- Signed input A
        B : in  STD_LOGIC_VECTOR(N-1 downto 0);  -- Signed input B
        Y : out STD_LOGIC_VECTOR(2*N-1 downto 0) -- 2N-bit signed output Y
    );
end array_multiplier;

architecture Behavioral of array_multiplier is
begin
    process(A, B)
        variable sum : unsigned(2*N-1 downto 0) := (others => '0');
        variable A_signed : signed(N-1 downto 0);
        variable B_signed : signed(N-1 downto 0);
        variable A_abs : unsigned(N-1 downto 0);
        variable B_abs : unsigned(N-1 downto 0);
        variable Y_neg : std_logic;
    begin
        -- Convert inputs to signed
        A_signed := signed(A);
        B_signed := signed(B);

        -- Determine the sign of the product (0 = positive, 1 = negative)
        Y_neg := A_signed(N-1) xor B_signed(N-1);

        -- Compute absolute values
        if A_signed(N-1) = '1' then
            A_abs := unsigned(-A_signed);
        else
            A_abs := unsigned(A_signed);
        end if;

        if B_signed(N-1) = '1' then
            B_abs := unsigned(-B_signed);
        else
            B_abs := unsigned(B_signed);
        end if;

        -- Generate partial products and accumulate the sum
        sum := (others => '0');
        for i in 0 to N-1 loop
            if B_abs(i) = '1' then
                sum := sum + (resize(A_abs, 2*N) sll i);
            end if;
        end loop;

        -- Assign the final product with correct sign
        if Y_neg = '1' then
            Y <= std_logic_vector(-signed(sum));
        else
            Y <= std_logic_vector(sum);
        end if;
    end process;
end Behavioral;
