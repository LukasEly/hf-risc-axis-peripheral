library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity leds_sw_axis is
	generic (
		DATA_WIDTH : integer := 16;
		STOP_WIDTH : integer := 1
	);
	port (
		-- external interface signals
		switches_i : in std_logic_vector(DATA_WIDTH-1 downto 0);
		leds_o : out std_logic_vector(DATA_WIDTH-1 downto 0);
		-- AXI stream interface signals
		axis_aclk_i : in std_logic;
		axis_aresetn_i : in std_logic;
		-- master axi stream interface
		m_axis_tready_i : in  std_logic; -- Switches
		m_axis_tvalid_o : out std_logic;
		m_axis_tdata_o : out std_logic_vector(DATA_WIDTH-1 downto 0);
		-- slave axi stream interface
		s_axis_tready_o : out std_logic; -- LEDs
		s_axis_tvalid_i : in  std_logic;
		s_axis_tdata_i : in  std_logic_vector(DATA_WIDTH-1 downto 0) 
	);
end leds_sw_axis;

architecture leds_sw_arch of leds_sw_axis is
	signal leds_tready : std_logic;
	signal switches_tvalid : std_logic;
	type state_type is (st_idle, st_data);
	signal state : state_type;
	signal leds_data : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal switches_data : std_logic_vector(DATA_WIDTH-1 downto 0);
begin
	s_axis_tready_o <= leds_tready;
	leds_o <= leds_data; -- Atualiza os LEDs na saída
	m_axis_tdata_o <= switches_data; -- Passa para o software o valor dos switches quando todos os LEDs são 1
	m_axis_tvalid_o <= switches_tvalid;

	in_out_process: process(axis_aclk_i) is
	begin
		if axis_aresetn_i = '0' then
			leds_tready <= '0';
			switches_tvalid <= '0';
			leds_data <= (others => '0');
			switches_data <= (others => '0');
		elsif axis_aclk_i'event and axis_aclk_i = '1' then
			case state is
				when st_idle =>					
					switches_tvalid <= '1'; -- libera a entrada de qualquer valor dos switches
					leds_tready <= '1'; -- Libera a saída do valor dos LEDs
					if s_axis_tvalid_i = '1' then
						leds_data <= s_axis_tdata_i; -- Pega o valor dos LEDs do software
						state <= st_data;
					end if;
					if m_axis_tready_i = '1' then
						switches_data <= switches_i; -- Pega o valor atual do switch
						state <= st_data;
					end if;
				when st_data =>
					leds_tready <= '0'; -- Bloqueia a saída do valor dos LEDs
					switches_tvalid <= '0'; -- bloqueia a entrada de qualquer valor dos switches
					state <= st_idle;
			end case;
		end if;
	end process;

end leds_sw_arch;
