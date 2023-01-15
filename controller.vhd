----------------------------------------------------------------------------------
-- Company: The Ohio State University
-- Engineer: Tianxiang He, Wafeeq Jaleel
-- 
-- Create Date:    15:15:31 04/18/2022 
-- Design Name: 
-- Module Name:    Controller - Behavioral 
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
use IEEE.NUMERIC_STD.ALL; 
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
 
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
 
entity Controller is
    Port ( SYSCLK : in  STD_LOGIC;
  -- Inputs and outputs
           POC : in  STD_LOGIC; -- Reset state
           UP_REQ : in  STD_LOGIC_VECTOR (3 downto 1); -- Up request from floor 1-3
           DN_REQ : in  STD_LOGIC_VECTOR (4 downto 2); -- Down request from floor 2-4
           GO_REQ : in  STD_LOGIC_VECTOR (4 downto 1); -- Go request inside the elevator at the current floor
           ECOMP : in  STD_LOGIC; -- Receives 1 from the simulator when an operation is done
           EF : in  STD_LOGIC_VECTOR (4 downto 1); -- Current floor
  
           FLOOR_IND : out  STD_LOGIC_VECTOR (4 downto 1); -- Current floor
           EMVUP : out  STD_LOGIC; -- Tells the simulator to move upward
           EMVDN : out  STD_LOGIC; -- Tells the simulator to move downward
           EOPEN : out  STD_LOGIC; -- Tells the simulator to open the door
           ECLOSE : out  STD_LOGIC; -- Tells the simulator to close the door
			  OPEN_REQ: in STD_LOGIC;  --requesting the door to open
			  CLOSE_REQ :in STD_LOGIC); --resuesting the door to close
end Controller;
 
architecture Behavioral of Controller is
-- Internal signals
	signal FLR_ABV : STD_LOGIC_VECTOR (4 downto 1); -- Any floor above the current floor, ex: current floor 3, FLR_ABV = 1000
	signal FLR_BLW : STD_LOGIC_VECTOR (4 downto 1); -- Any floor below the current floor, ex: current floor 3, FLR_BLW = 0010
	signal ALL_REQ: STD_LOGIC_VECTOR (4 downto 1); -- Request from any floor(including the current floor)
	signal ABV_REQ: STD_LOGIC; -- Check if there is a request from floors above
	signal BLW_REQ: STD_LOGIC; -- Check if there is a request from floors below
	signal Current_UP_REQ: STD_LOGIC; -- Check if there is an up request from the current floor
	signal Current_DN_REQ: STD_LOGIC; -- Check if there is a down request from the current floor
	signal Current_GO_REQ: STD_LOGIC; -- Check if the current floor button is being pressed at the current floor
	signal IS_DOOR_OPEN: STD_LOGIC; -- Return 1 if door is open, otherwise return 0
	signal DOOR: STD_LOGIC; -- Return 1 if door should be opened, otherwise return 0
	signal UP: STD_LOGIC; -- Return 1 if elevator is going upward
	signal DN: STD_LOGIC; -- Return 1 if elevator is going downward
	signal DIRECTION: STD_LOGIC;
	

begin
	FLR_BLW <= STD_LOGIC_VECTOR(UNSIGNED(EF) - 1);
	FLR_ABV <= STD_LOGIC_VECTOR(not(UNSIGNED(FLR_BLW)) sll 1);
	ALL_REQ <= ('0' & UP_REQ) or (DN_REQ & '0') or GO_REQ;
	ABV_REQ <= '1' when (UNSIGNED(ALL_REQ) and UNSIGNED(FLR_ABV)) > 0 else '0';
	BLW_REQ <= '1' when (UNSIGNED(ALL_REQ) and UNSIGNED(FLR_BLW)) > 0 else '0';
	Current_UP_REQ <= '1' when UNSIGNED(EF and ('0' & UP_REQ)) > 0 else '0';
	Current_DN_REQ <= '1' when UNSIGNED(EF and (DN_REQ & '0')) > 0 else '0';
	Current_GO_REQ <= '1' when UNSIGNED(EF and GO_REQ) > 0 else '0';
	DOOR <= (Current_UP_REQ and not(DN)) or (Current_DN_REQ and not(UP)) or Current_GO_REQ;
	FLOOR_IND <= EF;

	process(SYSCLK) 
	begin
			if SYSCLK' event and SYSCLK = '1' then
-- Set all outputs to zero (except FLOOR_IND) at beginning
				EMVUP <= '0';
				EMVDN <= '0';
				EOPEN <= '0';
				ECLOSE <= '0';

				if POC = '1' then -- Reset state
					UP <= '0';
					DN <= '0';
					IS_DOOR_OPEN <= '0';
				elsif ECOMP ='1' then

					if IS_DOOR_OPEN = '1' then -- Door is open

						if DOOR = '0' or CLOSE_REQ ='1' then -- Door is open when it should be closed
							IS_DOOR_OPEN <= '0';
							ECLOSE <= '1'; 
							--EOPEN <= '0';
						end if;

					else -- Door is closed

						if DOOR = '1' or OPEN_REQ = '1' then -- Door is closed when it should be opened
							IS_DOOR_OPEN <= '1';
							EOPEN <= '1';
							

						elsif ABV_REQ = '1' and DN = '0' then -- Elevator is moving up and there is a request above
							EMVUP <= '1';
							UP <= '1';
							DN <='0';
							EMVDN<='0';
						

						elsif BLW_REQ = '1' and UP = '0' then -- Elevator is moving down and there is a request below
							EMVDN <= '1';
							DN <= '1';
							UP <='0';
						
						else -- No request, elevator stays still
							UP <= '0';
							DN <= '0';
						end if;

				end if;

			end if;		

		end if;

	end process;

end Behavioral;


