library ieee;
use ieee.std_logic_1164.all;

    
 
entity MixColumns is
  port (
    IN_MixColumns : in std_logic_vector(31 downto 0);

    OUT_MixColumns : out std_logic_vector(31 downto 0)
  );
end MixColumns;


architecture archi of MixColumns is
signal E0,E1,E2,E3 : std_logic_vector(7 downto 0);
signal S0,S1,S2,S3 : std_logic_vector(7 downto 0);
signal xtimeS0, xtimeS1, xtimeS2, xtimeS3 : std_logic_vector(7 downto 0);
component xtime is
  port (
    E1 : in std_logic_vector(7 downto 0);
    E2 : in std_logic_vector(7 downto 0);

    S : out std_logic_vector(7 downto 0)
  );
end component;


	begin

		--decoupage en 4 parties
			E3 <= IN_MixColumns(7 downto 0);
			E2 <= IN_MixColumns(15 downto 8);
			E1 <= IN_MixColumns(23 downto 16);
			E0 <= IN_MixColumns(31 downto 24);
			
			-- S0
			xtime0 : xtime 
      			port map (
				E1  =>  E0,
        			E2  =>  E1,
				S => xtimeS0
     			);
			S0 <= xtimeS0 XOR E1 XOR E2 XOR E3;

			-- S1
			xtime1 : xtime 
      			port map (
				E1  =>  E1,
        			E2  =>  E2,
				S => xtimeS1
     			);
			S1 <= xtimeS1 XOR E2 XOR E3 XOR E0;

			-- S2
			xtime2 : xtime 
      			port map (
				E1  =>  E2,
        			E2  =>  E3,
				S => xtimeS2
     			);
			S2 <= xtimeS2 XOR E3 XOR E0 XOR E1;

			-- S3
			xtime3 : xtime 
      			port map (
				E1  =>  E3,
        			E2  =>  E0,
				S => xtimeS3
     			);
			S3 <= xtimeS3 XOR E0 XOR E1 XOR E2;


			OUT_MixColumns <= S0 & S1 & S2 & S3;
	              
end archi;



-- You can test with D4BF5D30E0B452AEB84111F11E2798E5
-- Should out 