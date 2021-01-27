library ieee;
use ieee.std_logic_1164.all;

    
 
entity ShiftRow is
  port (
    IN_ShiftRow : in std_logic_vector(127 downto 0);

    OUT_ShiftRow : out std_logic_vector(127 downto 0)
  );
end ShiftRow;


architecture archi of ShiftRow is
signal TabToShift : std_logic_vector(127 downto 0);
signal FinalTab : std_logic_vector(127 downto 0);

	begin

		TabToShift <= IN_ShiftRow;

		FinalTab(7 downto 0) <= TabToShift(39 downto 32); 
		FinalTab(15 downto 8) <= TabToShift(79 downto 72);
		FinalTab(23 downto 16) <= TabToShift(119 downto 112);
		FinalTab(31 downto 24) <= TabToShift(31 downto 24);

		FinalTab(39 downto 32) <= TabToShift(71 downto 64);
		FinalTab(47 downto 40) <= TabToShift(111 downto 104);
		FinalTab(55 downto 48) <= TabToShift(23 downto 16);
		FinalTab(63 downto 56) <= TabToShift(63 downto 56);

		FinalTab(71 downto 64) <= TabToShift(103 downto 96);
		FinalTab(79 downto 72) <= TabToShift(15 downto 8);
		FinalTab(87 downto 80) <= TabToShift(55 downto 48);
 		FinalTab(95 downto 88) <= TabToShift(95 downto 88);

		FinalTab(103 downto 96) <= TabToShift(7 downto 0); 
		FinalTab(111 downto 104) <= TabToShift(47 downto 40);
		FinalTab(119 downto 112) <= TabToShift(87 downto 80);   
		FinalTab(127 downto 120) <= TabToShift(127 downto 120);    

	OUT_ShiftRow <= FinalTab;                  
end archi;

-- You can test with D42711AEE0BF98F1B8B45DE51E415230
-- Should out D4BF5D30E0B452AEB84111F11E2798E5