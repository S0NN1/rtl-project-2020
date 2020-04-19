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
	port(
		i_clk     : in  std_logic;      --clock synchronizing FSM
		i_start   : in  std_logic;      --signal to start read RAM process
		i_rst     : in  std_logic;      --signal resetting FSM
		i_data    : in  std_logic_vector(7 downto 0); --signal from RAM with value requested
		o_address : out std_logic_vector(15 downto 0); --signal from FSM to RAM requesting address
		o_done    : out std_logic;      --signal identifying session terminated
		o_en      : out std_logic;      --signal to access RAM
		o_we      : out std_logic;      --signal to write on RAM
		o_data    : out std_logic_vector(7 downto 0) --signal containing data to write
	);
end project_reti_logiche;

architecture behavioral of project_reti_logiche is
	type state_type is (reset, start, first_read, read_ram, fetch_ram);
	signal current_state, next_state : state_type; --FSM states
	signal value                     : std_logic_vector(7 downto 0); --8th address containing input value 

begin
	process(i_clk)
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then
				current_state <= reset;
			end if;
		else
			current_state <= next_state;
		end if;
	end process;
	process(current_state)
	begin
		case current_state is
			when reset =>
				o_en   <= '0';
				o_we   <= '0';
				o_done <= '0';
			when start =>
				if i_start = '1' then
					o_en <= '1';
				end if;
			when first_read =>
			when read_ram =>
			when fetch_ram =>
		end case;
	end process;
end behavioral;
