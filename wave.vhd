--------------------------------------------------------------------------------
-- Company:       The Ohio State University
-- Engineer:      WAFEEQ JALEEL, TIANXIANG HE
--
-- Create Date:   08:06:46 04/18/2018
-- Design Name:   
-- Module Name:   test - behavior
-- Project Name:  ece3561_proj3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: elevator
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY wave IS
END wave;
 
ARCHITECTURE behavior OF wave IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
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
		signal SYSCLK 	  : STD_LOGIC := '0';
		signal POC 	  : STD_LOGIC := '1';	
		signal UP_REQ : STD_LOGIC_VECTOR (3 downto 1) := (others => '0');
		signal DN_REQ : STD_LOGIC_VECTOR (4 downto 2) := (others => '0');
		signal GO_REQ : STD_LOGIC_VECTOR (4 downto 1) := (others => '0');
		signal OPEN_REQ: STD_LOGIC := '0';
		signal CLOSE_REQ: STD_LOGIC := '0';
		signal ECOMP: STD_LOGIC := '0';
		signal EF : STD_LOGIC_VECTOR (4 downto 1) := (others => '0');
		
		signal FLOOR_IND : STD_LOGIC_VECTOR (4 downto 1) := (others => '0');
		signal EMVUP: STD_LOGIC := '0';
		signal EMVDN: STD_LOGIC := '0';
		signal EOPEN: STD_LOGIC := '0';
		signal ECLOSE: STD_LOGIC := '0';
		
		
		
		constant SYSCLK_period: time := 500ms;	

begin

		 
	con: controller PORT MAP(
		SYSCLK => SYSCLK,
  -- Inputs and outputs
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
		
	
   -- Clock process definitions
   SYSCLK_process :process
   begin
		SYSCLK <= '0';
		wait for SYSCLK_period/2;
		SYSCLK <= '1';
		wait for SYSCLK_period/2;
   end process;

    
    
    -- Stimulus process
    stim_proc: process
    begin		

		wait for SYSCLK_period;
      POC <= '0';

      wait for 1 sec;
      UP_REQ(3) <= '1';
		  
		wait for 1 sec;
      UP_REQ(1) <= '1'; 
	  
		wait for 1 sec;
		DN_REQ(4) <= '1';
		  
		wait for 3 sec ;
		UP_REQ(3) <= '0';
		  
		wait for 3 sec;
		DN_REQ(4) <='0';
		 
		wait for  3 sec;
      GO_REQ(2) <= '1';
		 
		wait for 1 sec;
		GO_REQ(2) <= '0';
		 
		wait for 5.5 sec;
		OPEN_REQ <='1';
		
		wait for 0.5 sec;
		CLOSE_REQ <='1';
		
		wait for 1 sec;
		CLOSE_REQ <= '0';
	  
		wait for 1 sec;
		OPEN_REQ<='0';
		 
		wait for 5.5 sec;
		CLOSE_REQ <= '1';
		  
		wait for 3 sec;
		CLOSE_REQ <= '0';

        

        wait;
    end process;

END;