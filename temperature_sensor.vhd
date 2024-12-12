----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2024 15:17:36
-- Design Name: 
-- Module Name: temperature_sensor - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity temperature_sensor is
    Port ( clk          : in  STD_LOGIC;               -- Main clock signal
           reset          : in  STD_LOGIC;               -- Reset signal
           dht_data    : inout STD_LOGIC;              -- Data pin to/from DHT11
           temperature  : out INTEGER;  -- 8-bit temperature value
           --humidity     : out STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit humidity value
           s : out INTEGER;
           ready   : out STD_LOGIC);                -- Data ready signal
end temperature_sensor;

architecture Behavioral of temperature_sensor is
    -- States for the finite state machine
    type state_type is (IDLE, START, WAIT_RESPONSE, READ_DATA, CHECKSUM, DONE);
    signal state, next_state : state_type;
    
    -- Internal signals to handle timing
    signal bit_count : integer range 0 to 39 := 0;  -- To keep track of the 40 bits
    signal data_buffer : STD_LOGIC_VECTOR(39 downto 0); -- Data buffer for received bits
    signal clk_div : integer range 0 to 500000 := 0; -- Clock divider for timing control
    signal dht11_ready : STD_LOGIC := '0'; -- To check when data is ready
    signal temp : STD_LOGIC_VECTOR(7 downto 0) := "00000000";

begin

    -- State machine process for DHT11 communication
    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            bit_count <= 0;
            data_buffer <= (others => '0');
            --ready <= '0';
            --humidity <= (others => '0');
            --temp <= (others => '0');
            dht_data <= 'Z'; -- Set pin as high impedance (input)
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- State transitions and actions
    process(state, clk_div, dht_data)
    begin
        case state is
            when IDLE =>
                s <= 0;
                dht_data <= 'Z'; -- Set pin to high impedance, ready to send start signal
                ready <= '0';
                if clk_div = 50000 then  -- Wait for enough clock cycles to pass for timing
                    next_state <= START;
                else
                    next_state <= IDLE;
                end if;

            when START =>
                s <= 1;
                dht_data <= '0';  -- Send start signal to DHT11
                if clk_div = 180000 then  -- Delay for 18ms (start signal)
                    dht_data <= 'Z';  -- Release the pin
                    next_state <= WAIT_RESPONSE;
                else
                    next_state <= START;
                end if;

            when WAIT_RESPONSE =>
                s <= 2;
                if clk_div = 80 then  -- Wait for the response from the DHT11
                    if dht_data = '0' then
                        next_state <= READ_DATA;
                    else
                        next_state <= WAIT_RESPONSE;
                    end if;
                else
                    next_state <= WAIT_RESPONSE;
                end if;

            when READ_DATA =>
                s <= 3;
                -- Read 40 bits of data from DHT11
                if bit_count < 40 then
                    if clk_div = 70 then
                        -- Read the bit from the DHT11 pin and store it in the data buffer
                        data_buffer(bit_count) <= dht_data;
                        bit_count <= bit_count + 1;
                    end if;
                    next_state <= READ_DATA;
                else
                    next_state <= CHECKSUM;
                end if;

            when CHECKSUM =>
                s <= 4;
                -- Verify checksum here
                -- DHT11 checksum is the sum of the first 4 bytes (humidity and temperature)
                -- If checksum is correct, process the data
                if data_buffer(39 downto 32) = "1111" then
                    -- Extract temperature and humidity
                    --humidity <= data_buffer(15 downto 8);
                    temp <= data_buffer(23 downto 16);
                    ready <= '1';  -- Data is ready
                end if;
                next_state <= DONE;

            when DONE =>
                s <= 5;
                -- Wait for the next read cycle
                if clk_div = 500000 then
                    next_state <= IDLE;
                    ready <= '0';  -- Clear the data ready flag
                else
                    next_state <= DONE;
                end if;
        end case;
    end process;

    -- Clock divider for timing control
    process(clk)
    begin
        if reset = '1' then
            clk_div <= 0;
        elsif rising_edge(clk) then
            if clk_div = 500000 then  -- Adjust the divider for accurate timing
                clk_div <= 0;
            else
                clk_div <= clk_div + 1;
            end if;
        end if;
    end process;
    
    process(clk, temp) -- change from binary to int
        begin
        temperature <= TO_INTEGER(UNSIGNED(temp));
        end process;  

end Behavioral;