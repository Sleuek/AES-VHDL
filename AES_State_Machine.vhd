library ieee;
use ieee.std_logic_1164.all;

    
 
entity AES_State_Machine is
  port (
    rst, start, clk : in std_logic;
    busy, isState1To9, isState10, isState0 : out std_logic 
  );
end AES_State_Machine;



architecture archi of AES_State_Machine is
signal compteur,oldCompteur : integer;





type state_type is (Init,State1To9,State10); --,State0
signal state_reg, state_next: state_type;
signal isState1To9Loc, isState10Loc, isState0Loc, isStateInitLoc, startLoc : std_logic;
	begin 
		process(clk)
		begin
			if(clk'event and clk='1') then
				if (rst ='1') then 
					state_reg <= Init;
				else
					state_reg <= state_next; 
				end if;
			end if; 
		end process;
		
		

		process(clk) begin
			if(clk'event and clk='1') then
			case state_reg is 
				when Init =>
					compteur <= 0;
					isState1To9Loc <= '0';
					isState10Loc <= '0';
					isStateInitLoc <= '1';
					
					if(start = '1') then
						--busy <= '1';
						isState0Loc <= '1';
						isStateInitLoc <= '0';
						state_next <= State1To9;--State0;
					end if;
				      	--busy <= '0';
				

--				when State0 =>
--					isState0Loc <= '1';
--					isStateInitLoc <= '0';
--					state_next <= State1To9; 

				when State1To9 =>
					--busy <= '1';
					isState1To9Loc <= '1';
					isState0Loc <= '0';
					--isStateInitLoc <= '0';
					compteur <= compteur + 1;
					if(compteur = 7) then 
						state_next <= State10;
 					end if; 

				when State10 =>
					isState1To9Loc <= '0';
					isState10Loc <= '1';
					state_next <= Init; 
					
				
			end case;
			end if;
		end process;       


		isState1To9 <= isState1To9Loc;
		isState10 <= isState10Loc;
		isState0 <= isState0Loc;
                                        
end archi;