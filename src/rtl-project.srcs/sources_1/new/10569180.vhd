----------------------------------------------------------------------------------
-- company: 
-- engineer: 
-- 
-- create date: 04/17/2020 05:05:22 pm
-- design name: 
-- module name: 10569180 - behavioral
-- project name: 
-- target devices: 
-- tool versions: 
-- description: 
-- 
-- dependencies: 
-- 
-- revision:
-- revision 0.01 - file created
-- additional comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
--use ieee.numeric_std.all;

-- uncomment the following library declaration if instantiating
-- any xilinx leaf cells in this code.
--library unisim;
--use unisim.vcomponents.all;

entity project_reti_logiche is
	port (
		i_clk     : in std_logic;                      --clock synchronizing fsm
		i_start   : in std_logic;                      --signal to start read ram process
		i_rst     : in std_logic;                      --signal resetting fsm
		i_data    : in std_logic_vector(7 downto 0);   --signal from ram with value requested
		o_address : out std_logic_vector(15 downto 0); --signal from fsm to ram requesting address
		o_done    : out std_logic;                     --signal identifying session terminated
		o_en      : out std_logic;                     --signal to access ram
		o_we      : out std_logic;                     --signal to write on ram
		o_data    : out std_logic_vector(7 downto 0)   --signal containing data to write
	);
end project_reti_logiche;

architecture behavioral of project_reti_logiche is
	type state_type is (reset, start, store_data, compare_data, fetch_ram);
	signal current_state, next_state : state_type;                   --FSM states
	signal wz_bit                    : std_logic;                    --working zone bit
	signal offset                    : std_logic_vector(3 downto 0); --working zone offset
	signal data                      : std_logic_vector(7 downto 0); --data requested
	signal counter                   : integer;                      --first read

begin
	process (i_clk)
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then --if reset signal is high return to reset state
				current_state <= reset;
				o_done        <= '0';
				o_en          <= '0';
				o_we          <= '0';
			end if;
		else
			current_state <= next_state; --next FSM state
		end if;
	end process;
	process (current_state)
	begin
		case current_state is
			when reset =>
				if i_start = '0' then
					next_state <= reset;
				elsif i_start = '1' then
					next_state <= reset;
				end if;
			when start =>
				o_address  <= "0000000000001000";
				o_we       <= '0';
				o_en       <= '1';
				wz_bit     <= '0';
				offset     <= "0000";
				next_state <= store_data;
			when store_data =>
				data      <= i_data;
				o_address <= "0000000000000000";
				counter   <= 0;
			when compare_data =>
				for k in 0 to 3 loop
					if unsigned(i_data) = unsigned(data) + to_unsigned(k, 8) then
						wz_bit <= '1';
						if to_unsigned(k, 2) = "00" then
							offset <= "0001";
							exit;
						elsif to_unsigned(k, 2) = "01" then
							offset <= "0010";
							exit;
						elsif to_unsigned(k, 2) = "10" then
							offset <= "0100";
							exit;
						elsif to_unsigned(k, 2) = "11" then
							offset <= "1000";
							exit;
						end if;
					end if;
				end loop;
				if counter /= 7 then
					if wz_bit = '1' then
						o_data <= wz_bit & std_logic_vector(to_unsigned(counter, 3)) & offset;
						o_we   <= '1';
						o_done <= '1';
					else
						counter    <= counter + 1;
						next_state <= compare_data;
					end if;
				else
					if wz_bit = '1' then
						o_data <= wz_bit & std_logic_vector(to_unsigned(counter, 3)) & offset;
						o_we   <= '1';
						o_done <= '1';
					else
						o_data <= wz_bit & data;
						o_we   <= '1';
						o_done <= '1';
					end if;
				end if;
		end case;
	end process;
end behavioral;