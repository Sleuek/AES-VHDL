library ieee;
use ieee.std_logic_1164.all;

    
 
entity xtime is
  port (
    E1 : in std_logic_vector(7 downto 0);
    E2 : in std_logic_vector(7 downto 0);

    S : out std_logic_vector(7 downto 0)
  );
end xtime;


architecture archi of xtime is
signal temp,temp1,temp2 : std_logic_vector(7 downto 0);

	begin
			temp <= (E2 XOR E1);
			temp1 <= temp(6) & temp(5) & temp(4) & temp(3) & temp(2) & temp(1) & temp(0) & '0';
			with temp(7) select
  				  temp2 <= temp1 XOR "00011011" when '1',
				             temp1 when others;  
			S<=temp2;                                                                    
end archi;
