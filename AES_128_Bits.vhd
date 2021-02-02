library ieee;
use ieee.std_logic_1164.all;

    
 
entity AES_128_Bits is
  port (
    KIN : in std_logic_vector(127 downto 0);
    DIN : in std_logic_vector(127 downto 0);
    rst, start, clk, encrypt : in std_logic;
    
    busy : out std_logic;
    DOUT : out std_logic_vector(127 downto 0)
  );
end AES_128_Bits;



architecture archi of AES_128_Bits is

--STATE MACHINE
signal isState1To9Loc, isState10Loc, isState10LocPrec, isState0Loc, isLastRound1To9Loc: std_logic;
--ADD ROUND KEY
signal fromMixColumns,fromExpKey : std_logic_vector(127 downto 0);
--signal fromPlainText, fromMixColumns, fromShiftRows : std_logic_vector(127 downto 0);
signal InAdd, InShift, InSub, InMix  : std_logic_vector(127 downto 0);


component AES_State_Machine is
port (
    rst, start, clk : in std_logic;
    isState1To9, isState10, isState0, isLastRound1To9 : out std_logic 
  );
end component;

component AddRoundKey is
  port (
    KeyRound : in std_logic_vector(127 downto 0);
    IN_AddRoundKey : in std_logic_vector(127 downto 0);
    OUT_AddRoundKey : out std_logic_vector(127 downto 0)
  );
end component;

--EXPANSION KEY
component Exp_Key is
  port (
    KIN : in std_logic_vector(127 downto 0);
    clk, enable : in std_logic;
    KOUT : out std_logic_vector(127 downto 0)
  );
end component;

component ShiftRow is
  port (
    IN_ShiftRow : in std_logic_vector(127 downto 0);

    OUT_ShiftRow : out std_logic_vector(127 downto 0)
  );
end component;



component SubByte is
  port (
    IN_A : in std_logic_vector(7 downto 0);
    IN_B : in std_logic_vector(7 downto 0);
    Sbox_invSbox : in std_logic;

    OUT_A : out std_logic_vector(7 downto 0);
    OUT_B : out std_logic_vector(7 downto 0)
  );
end component;

component MixColumns is
  port (
    IN_MixColumns : in std_logic_vector(31 downto 0);
    OUT_MixColumns : out std_logic_vector(31 downto 0)
  );
end component;







--cazou
--DECRYPTION

begin
	
	StateMachine0 : AES_State_Machine 
      	port map (
		rst  =>  rst,
        	start  =>  start,
		clk => clk,
		isState1To9 => isState1To9Loc,
		isState10 => isState10Loc,
		isState0 => isState0Loc,
		isLastRound1To9 => isLastRound1To9Loc
     		);

	

--	InAdd <= 
--	 DIN when isState0Loc = '1' else 
--	 fromMixColumns when isState1To9Loc = '1' else
--	 InMix when isState10Loc = '1';


	process(clk)
	begin
		if(clk'event and clk='1') then
			if(rst = '1') then
				DOUT <= (others => '0');
				busy <= '0';

			elsif(start = '1') then
				busy <= '1';
				InAdd <= DIN;
				isState10LocPrec <= '0';
			end if;


			--Encryption part
			if(isState1To9Loc = '1') then
				InAdd <= fromMixColumns;
			end if;
			if(isLastRound1To9Loc = '1' OR isState10LocPrec = '1') then
				InAdd <= InMix;
				if(isState10LocPrec = '1') then
					DOUT <= InSub;
					busy <= '0';
				end if;
				isState10LocPrec <= isLastRound1To9Loc;
			end if;	
			--Decryption part
			




		end if;
	end process;

	AddRoundKey0 : AddRoundKey 
      	port map (
		KeyRound  =>  fromExpKey,
        	IN_AddRoundKey  =>  InAdd,
		OUT_AddRoundKey => InSub
     		);


	Exp_Key0 : Exp_Key 
      	port map (
		KIN  =>  KIN,
        	clk  =>  clk,
		enable => start,
		KOUT => fromExpKey
     		);


	SubByteGenerated :
	for I in 0 to 7 generate
	SubByteX : SubByte
	port map(
   		IN_A => InSub(I*16 +7 downto I *16), 
    		IN_B => InSub(I*16 + 15 downto I *16 + 8), 
    		Sbox_invSbox => '0',
    		OUT_A => InShift(I*16 +7 downto I *16), 
    		OUT_B => InShift(I*16 + 15 downto I *16 + 8) 
	);
	end generate SubByteGenerated;
	
	ShiftRow9 : ShiftRow
  	port map (
    		IN_ShiftRow =>InShift,
    		OUT_ShiftRow => InMix
  	);




	MixColumnsGenerated :
	for I in 0 to 3 generate
	MixColumnsX : MixColumns
	port map (
		IN_MixColumns  =>  InMix(32*I+31 downto 32*I),
        	OUT_MixColumns  =>  fromMixColumns(32*I+31 downto 32*I)
     		);
	end generate MixColumnsGenerated;


 
		
                                        
end archi;