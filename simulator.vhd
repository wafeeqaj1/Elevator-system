----------------------------------------------------------------------------------
-- Company: 		The Ohio State University
-- Engineer: 		Wafeeq Jaleel
-- 
-- Create Date:    10:18:04 04/16/2022 
-- Design Name: 
-- Module Name:    simulator - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity simulator is
    Port ( EMVUP : in  STD_LOGIC;		-- Tells the simulator to move upward
           EMVDN : in  STD_LOGIC;		-- Tells the simulator to move downward
           EOPEN : in  STD_LOGIC;		-- Tells the simulator to open the door
           ECLOSE : in  STD_LOGIC;		-- Tells the simulator to close the door
           SYSCLK : in  STD_LOGIC;		
           POC : in  STD_LOGIC;			-- Reset state
           ECOMP : buffer  STD_LOGIC;	-- Receives 1 from the simulator when an operation is done
           EF : out  STD_LOGIC_VECTOR (4 downto 1));	 -- Current floor
			  
end simulator;

architecture Behavioral of simulator is
	signal COUNTER : UNSIGNED(2 downto 0);  --counter as unsigned int for delaying the operation
	signal FLOOR : UNSIGNED(4 downto 1);	  -- current floor as unsigned int

BEGIN
	EF<=STD_LOGIC_VECTOR(FLOOR);
	process(SYSCLK)
	begin
		if SYSCLK'event and SYSCLK ='1' then
		
			if POC = '0' then						--not in reset state
				if ECOMP='0' then					--checks if it is and on going operation
                if COUNTER= "000" then		--checks if the counter has reached the end
                    ECOMP <= '1';
                else
                    COUNTER <= COUNTER - 1;
                end if;
			
				else
					if EMVUP = '1' and FLOOR(4) = '0' then --checks the elavtor has to move up and isn't in the top floor						
						ECOMP <= '0';
						COUNTER <= "100";					--setting for 2 sec, four clock cycle			
						FLOOR <= FLOOR sll 1;			--left shifting the floor number
				
					elsif EMVDN = '1' and FLOOR(1) ='0' then --checks the elavtor has to down and isn't in the first floor								
						ECOMP <= '0';
						COUNTER <= "100";
						FLOOR <= FLOOR srl 1;		--right shifting the floor number 
			
					elsif EOPEN = '1' then 			--checks whether to open the door
						ECOMP <= '0';
						COUNTER <= "101";				--setting the timer for 3 sec
			
					elsif ECLOSE ='1' then 			--check whether to close the door
						ECOMP <= '0';	
						COUNTER <= "101";
					end if;
				end if;
			
			elsif POC = '1' then 					--reset state
				FLOOR <= "0001";
				ECOMP <= '1';
			end if;
		end if;
	end process;
END;