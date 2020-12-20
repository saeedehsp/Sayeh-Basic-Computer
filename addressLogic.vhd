library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity AddressLogic is
    port (
        PCside, Rside : in std_logic_vector (15 downto 0);
        Iside  : in std_logic_vector (7 downto 0);
        ResetPC, PCplusI, PCplus1, R0plusI : in std_logic := '0';
        R0plus0 : in std_logic := '1';
        ALout  : out std_logic_vector (15 downto 0) := "0000000000000000"
    );
end AddressLogic;

architecture dataflow of AddressLogic is
begin
    process (PCside, Rside, Iside, ResetPC, PCplusI, PCplus1, R0plusI, R0plus0)
        variable temp : std_logic_vector (4 downto 0);
    begin
        temp := (ResetPC & PCplusI & PCplus1 & R0plusI & R0plus0);
        case temp is
            when "10000" => ALout <= (others => '0');
            when "01000" => ALout <= std_logic_vector(unsigned(PCside) + unsigned(Iside));
            when "00100" => ALout <= std_logic_vector(unsigned(PCside) + 1);
            when "00010" => ALout <= std_logic_vector(unsigned(Rside) + unsigned(Iside));
            when "00001" => ALout <= Rside;
            when others  => ALout <= PCside;
        end case;
    end process;
end dataflow;