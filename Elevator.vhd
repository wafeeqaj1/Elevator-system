----------------------------------------------------------------------------------
-- Company: 		The Ohio State University
-- Engineer: 		WAFEEQ JALEEL, TIANXIANG HE
-- 
-- Create Date:    11:16:09 04/16/2022 
-- Design Name: 
-- Module Name:    Elevator - Behavioral 
-- Project Name: 	 ECE 3561 PROJECT 3
-- Target Devices: 
-- Tool versions: 
-- Description: 	The file that connects controller and simulator
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Elevator is
    Port ( UP_REQ : in  STD_LOGIC_VECTOR (3 downto 1);
           DN_REQ : in  STD_LOGIC_VECTOR (4 downto 2);
           GO_REQ : in  STD_LOGIC_VECTOR (4 downto 1);
           FLOOR_IND : out  STD_LOGIC_VECTOR (4 downto 1);
           POC : in  STD_LOGIC;
           SYSCLK : in  STD_LOGIC;
			  OPEN_REQ: in STD_LOGIC; 
			  CLOSE_REQ :in STD_LOGIC);
end Elevator;

architecture Behavioral of Elevator is

COMPONENT simulator 
PORT(EMVUP : in  STD_LOGIC;
           EMVDN : in  STD_LOGIC;
           EOPEN : in  STD_LOGIC;
           ECLOSE : in  STD_LOGIC;
           SYSCLK : in  STD_LOGIC;
           POC : in  STD_LOGIC;
           ECOMP : buffer  STD_LOGIC;
           EF : out  STD_LOGIC_VECTOR (4 downto 1));
END COMPONENT;

COMPONENT controller
PORT( 
	SYSCLK : in  STD_LOGIC;
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
			  OPEN_REQ: in STD_LOGIC; 
			  CLOSE_REQ :in STD_LOGIC);

END COMPONENT;
		
		signal EMVUP: STD_LOGIC;
		signal EMVDN: STD_LOGIC;
		signal EOPEN: STD_LOGIC;
		signal ECLOSE: STD_LOGIC;
		signal ECOMP: STD_LOGIC;
		signal EF: STD_LOGIC_VECTOR (4 downto 1);
			

begin
	sim: simulator PORT MAP(
		 EMVUP => EMVUP,
		 EMVDN => EMVDN,
       EOPEN => EOPEN,
       ECLOSE => ECLOSE,
		 SYSCLK => SYSCLK,
		 POC => POC,
		 ECOMP => ECOMP,
		 EF => EF
		 );
		
	con: controller PORT MAP(
		SYSCLK => SYSCLK,
      POC=> POC,
      UP_REQ => UP_REQ,
      DN_REQ => DN_REQ,
      GO_REQ => GO_REQ,
      ECOMP => ECOMP,
      EF => EF,

      FLOOR_IND => FLOOR_IND,
      EMVUP => EMVUP, 
      EMVDN => EMVDN,
      EOPEN => EOPEN,
      ECLOSE => ECLOSE,
		OPEN_REQ => OPEN_REQ,
		CLOSE_REQ => CLOSE_REQ
		
		);
	

end Behavioral;

