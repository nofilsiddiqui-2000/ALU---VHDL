-- top_module.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_module is
    generic (
        N : integer := 8  -- Bit-width of inputs A and B
    );
    port (
        clk     : in  std_logic;                               -- Clock input
        reset_n : in  std_logic;                               -- Active-low reset
        load    : in  std_logic;                               -- Load signal
        a       : in  std_logic_vector(N-1 downto 0);          -- Signed input A
        b       : in  std_logic_vector(N-1 downto 0);          -- Signed input B
        c       : in  std_logic_vector(7 downto 0);            -- Unsigned input c
        D       : in  std_logic_vector(N-1 downto 0);          -- Unsigned input D
        P       : out std_logic_vector(2*N downto 0);          -- Signed output (A*B)/(2^c) + D
        status  : out std_logic                                -- Status signal (1 when calculation is complete)
    );
end top_module;

architecture Behavioral of top_module is

    -- Component Declarations

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

    component divider_by_2c
        generic (
            N : integer := 8
        );
        port (
            product_in  : in  STD_LOGIC_VECTOR(2*N-1 downto 0);
            c           : in  STD_LOGIC_VECTOR(7 downto 0);
            product_out : out STD_LOGIC_VECTOR(2*N-1 downto 0)
        );
    end component;

    component incrementer
        generic (
            N : integer := 8
        );
        port (
            div_in  : in  STD_LOGIC_VECTOR(2*N-1 downto 0);
            D       : in  STD_LOGIC_VECTOR(N-1 downto 0);
            sum_out : out STD_LOGIC_VECTOR(2*N downto 0)
        );
    end component;

    -- Internal signals
    signal A_reg        : std_logic_vector(N-1 downto 0);
    signal B_reg        : std_logic_vector(N-1 downto 0);
    signal c_reg        : std_logic_vector(7 downto 0);
    signal D_reg        : std_logic_vector(N-1 downto 0);
    signal result_reg   : std_logic_vector(2*N downto 0);
    signal status_reg   : std_logic;  -- Register for status signal

    -- Internal signals for intermediate results
    signal multiplier_P   : std_logic_vector(2*N-1 downto 0);
    signal divider_result : std_logic_vector(2*N-1 downto 0);
    signal adder_result   : std_logic_vector(2*N downto 0);

    -- FSM States
    type state_type is (IDLE, MULTIPLY, DIVIDE, ADD, DONE);
    signal current_state, next_state : state_type;

begin

    -- Output assignments
    P <= result_reg;
    status <= status_reg;

    -- FSM Process
    process(clk, reset_n)
    begin
        if reset_n = '0' then  -- Active-low reset
            current_state <= IDLE;
            A_reg <= (others => '0');
            B_reg <= (others => '0');
            c_reg <= (others => '0');
            D_reg <= (others => '0');
            result_reg <= (others => '0');
            status_reg <= '0';
        elsif rising_edge(clk) then
            current_state <= next_state;

            case current_state is
                when IDLE =>
                    status_reg <= '0';
                    if load = '1' then
                        -- Latch inputs
                        A_reg <= a;
                        B_reg <= b;
                        c_reg <= c;
                        D_reg <= D;
                    end if;

                when MULTIPLY =>
                    status_reg <= '0';
                    -- Multiplication is handled by the array_multiplier component

                when DIVIDE =>
                    status_reg <= '0';
                    -- Division is handled by the divider_by_2c component

                when ADD =>
                    status_reg <= '0';
                    -- Addition is handled by the incrementer component
                    -- Update result_reg with the adder result
                    result_reg <= adder_result;

                when DONE =>
                    status_reg <= '1';
                    -- Remain in DONE state until load is asserted
            end case;
        end if;
    end process;

    -- Next state logic
    process(current_state, load)
    begin
        case current_state is
            when IDLE =>
                if load = '1' then
                    next_state <= MULTIPLY;
                else
                    next_state <= IDLE;
                end if;

            when MULTIPLY =>
                next_state <= DIVIDE;

            when DIVIDE =>
                next_state <= ADD;

            when ADD =>
                next_state <= DONE;

            when DONE =>
                if load = '1' then
                    next_state <= MULTIPLY;
                else
                    next_state <= IDLE;
                end if;
        end case;
    end process;

    -- Component Instantiations

    -- Instantiate the array_multiplier
    mult_inst: array_multiplier
        generic map (
            N => N
        )
        port map (
            A => A_reg,
            B => B_reg,
            Y => multiplier_P
        );

    -- Instantiate the divider_by_2c
    div_inst: divider_by_2c
        generic map (
            N => N
        )
        port map (
            product_in  => multiplier_P,
            c           => c_reg,
            product_out => divider_result
        );

    -- Instantiate the incrementer (adder)
    add_inst: incrementer
        generic map (
            N => N
        )
        port map (
            div_in  => divider_result,
            D       => D_reg,
            sum_out => adder_result
        );

end Behavioral;
