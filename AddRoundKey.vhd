library ieee;
use ieee.std_logic_1164.all;

    
 
entity AddRoundKey is
  port (
    KeyRound : in std_logic_vector(127 downto 0);
    IN_AddRoundKey : in std_logic_vector(127 downto 0);
    OUT_AddRoundKey : out std_logic_vector(127 downto 0)
  );
end AddRoundKey;


architecture archi of AddRoundKey is
	begin
		OUT_AddRoundKey <= IN_AddRoundKey XOR KeyRound;                                                                            
end archi;