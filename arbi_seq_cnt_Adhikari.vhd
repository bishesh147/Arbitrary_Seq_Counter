library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity arbi_seq_counter is
    Port (
        clk: in std_logic;
        reset: in std_logic;
        --ctrl: in std_logic_vector(3 downto 0);
        q: out std_logic_vector(2 downto 0);
        led: out std_logic
    );
end arbi_seq_counter;


architecture rtl of arbi_seq_counter is
    signal cnter1_reg, cnter1_next: unsigned(27 downto 0);
    signal q_reg, q_next: unsigned(2 downto 0);
    type arbi_seq_cnt_type is (s0, s3, s6, s5, s7);
    signal state_reg, state_next: arbi_seq_cnt_type;
begin
    process(clk, reset)
    begin
        if ( reset = '1' ) then
            cnter1_reg <= (others=>'0');
            q_reg <= (others=>'0');
            state_reg <= s0;
        elsif( rising_edge(clk) ) then
            cnter1_reg <= cnter1_next;
            q_reg <= q_next;
            state_reg <= state_next;
        end if;
    end process;

    cnter1_next <= cnter1_reg + 1;
    led <= cnter1_reg(27);
    -- next-state logic
    process (state_reg, q_reg, cnter1_reg)
    begin
        state_next <= state_reg;
        q_next <= q_reg;
        case state_reg is
            when s0 =>
                if (cnter1_reg = "1111111111111111111111111111") then
                    state_next <= s3;
                    q_next <= "011";
                end if;

            when s3 =>
                if (cnter1_reg = "1111111111111111111111111111") then
                    state_next <= s6;
                    q_next <= "110";
                end if;

            when s6 =>
                if (cnter1_reg = "1111111111111111111111111111") then
                    state_next <= s5;
                    q_next <= "101";
                end if;

            when s5 =>
                if (cnter1_reg = "1111111111111111111111111111") then
                    state_next <= s7;
                    q_next <= "111";
                end if;

            when s7 =>
                if (cnter1_reg = "1111111111111111111111111111") then
                    state_next <= s0;
                    q_next <= "000";
                end if;
        end case;
    end process;
    q <= std_logic_vector(q_reg);
end rtl;
    