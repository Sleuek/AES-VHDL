library ieee;
use ieee.std_logic_1164.all;

USE ieee.numeric_std.ALL;
    
 
entity Exp_Key is
  port (
    KIN : in std_logic_vector(127 downto 0);
    clk, enable : in std_logic;
    KOUT : out std_logic_vector(127 downto 0)
  );
end Exp_Key;


architecture archi of Exp_Key is

component processColumn is
  port (
    C1 : in std_logic_vector(31 downto 0);
    C2 : in std_logic_vector(31 downto 0);

    S : out std_logic_vector(31 downto 0)
  );
end component;

signal continue : integer;
signal E0,E1,E2,E3 : std_logic_vector(31 downto 0);
signal KLOC, KINtoProcess : std_logic_vector(127 downto 0);
signal S0,S1,S2,S3 : std_logic_vector(31 downto 0);
	
type SboxType is array (0 to 255) of std_logic_vector(7 downto 0); --FF = 255
signal SboxData : SboxType := (x"63",x"7c",x"77",x"7b",x"f2",x"6b",x"6f",x"c5",x"30",x"01",x"67",x"2b",x"fe",x"d7",x"ab",x"76",x"ca",x"82",x"c9",x"7d",x"fa",x"59",x"47",x"f0",x"ad",x"d4",x"a2",x"af",x"9c",x"a4",x"72",x"c0",x"b7",x"fd",x"93",x"26",x"36",x"3f",x"f7",x"cc",x"34",x"a5",x"e5",x"f1",x"71",x"d8",x"31",x"15",x"04",x"c7",x"23",x"c3",x"18",x"96",x"05",x"9a",x"07",x"12",x"80",x"e2",x"eb",x"27",x"b2",x"75",x"09",x"83",x"2c",x"1a",x"1b",x"6e",x"5a",x"a0",x"52",x"3b",x"d6",x"b3",x"29",x"e3",x"2f",x"84",x"53",x"d1",x"00",x"ed",x"20",x"fc",x"b1",x"5b",x"6a",x"cb",x"be",x"39",x"4a",x"4c",x"58",x"cf",x"d0",x"ef",x"aa",x"fb",x"43",x"4d",x"33",x"85",x"45",x"f9",x"02",x"7f",x"50",x"3c",x"9f",x"a8",x"51",x"a3",x"40",x"8f",x"92",x"9d",x"38",x"f5",x"bc",x"b6",x"da",x"21",x"10",x"ff",x"f3",x"d2",x"cd",x"0c",x"13",x"ec",x"5f",x"97",x"44",x"17",x"c4",x"a7",x"7e",x"3d",x"64",x"5d",x"19",x"73",x"60",x"81",x"4f",x"dc",x"22",x"2a",x"90",x"88",x"46",x"ee",x"b8",x"14",x"de",x"5e",x"0b",x"db",x"e0",x"32",x"3a",x"0a",x"49",x"06",x"24",x"5c",x"c2",x"d3",x"ac",x"62",x"91",x"95",x"e4",x"79",x"e7",x"c8",x"37",x"6d",x"8d",x"d5",x"4e",x"a9",x"6c",x"56",x"f4",x"ea",x"65",x"7a",x"ae",x"08",x"ba",x"78",x"25",x"2e",x"1c",x"a6",x"b4",x"c6",x"e8",x"dd",x"74",x"1f",x"4b",x"bd",x"8b",x"8a",x"70",x"3e",x"b5",x"66",x"48",x"03",x"f6",x"0e",x"61",x"35",x"57",x"b9",x"86",x"c1",x"1d",x"9e",x"e1",x"f8",x"98",x"11",x"69",x"d9",x"8e",x"94",x"9b",x"1e",x"87",x"e9",x"ce",x"55",x"28",x"df",x"8c",x"a1",x"89",x"0d",x"bf",x"e6",x"42",x"68",x"41",x"99",x"2d",x"0f",x"b0",x"54",x"bb",x"16");
type RconType is array (1 to 11) of std_logic_vector(7 downto 0); --FF = 255
signal RconData : RconType := (x"01", x"02", x"04", x"08", x"10", x"20", x"40", x"80", x"1B", x"36", x"00");

signal C0,C1,C2,C3 : std_logic_vector(31 downto 0);
signal nC0,nC1,nC2,nC3 : std_logic_vector(31 downto 0);

signal gC3,gC4,gC5,gC6 : std_logic_vector(31 downto 0);
signal temp1gC3, temp2gC3 : std_logic_vector(31 downto 0);

signal temp,temp1,temp2 : std_logic_vector(31 downto 0);
signal S0Loc,S1Loc,S2Loc,S3Loc : std_logic_vector( 7 downto 0);
signal roundNumber : integer := 1;

	begin
	KLOC <= KIN;
	process(clk)
		begin
			if(clk'event and clk='1') then
				if (enable ='1' OR continue > 0) then 
					if(continue = 3) then
						KINtoProcess <= nC0 & nC1 & nC2 & nC3;
						roundNumber <= roundNumber +1;
					else
						KINtoProcess <= KLOC;
						continue <= continue  + 1;
					end if;

				else 
					roundNumber <= 1;
					S0 <= (others => '0');	
					S1 <= (others => '0');	
					S2 <= (others => '0');	
					S3 <= (others => '0');	
					continue <= 0;		
				end if;
				if (roundNumber = 11) then
					roundNumber <= 1;
					continue <= 0;
				end if;
			end if;		
			end process;


						C3 <= KINtoProcess(31 downto 0);
						C2 <= KINtoProcess(63 downto 32);
						C1 <= KINtoProcess(95 downto 64);
						C0 <= KINtoProcess(127 downto 96);

						-- first calc with C0 and g(C3)
						temp <= C3(23 downto 0) & C3(31 downto 24);
						S0Loc <= SboxData(to_integer(unsigned(temp(7 downto 0))));  
						S1Loc <= SboxData(to_integer(unsigned(temp(15 downto 8)))); 
						S2Loc <= SboxData(to_integer(unsigned(temp(23 downto 16)))); 
						S3Loc <= SboxData(to_integer(unsigned(temp(31 downto 24)))) XOR RconData(roundNumber); 
						temp2<= S3Loc & S2Loc & S1Loc & S0Loc; 
						
						nC0 <= temp2 XOR C0;            
						nC1 <= nC0 XOR C1;
						nC2 <= nC1 XOR C2;
						nC3 <= nC2 XOR C3;

--										
--					

		process(clk)
		begin
			if(clk'event and clk='1') then
				if (enable ='1' OR continue > 0) then 
					if(continue <3 ) then
						KOUT <= KIN;
					else
						KOUT <= nC0 & nC1 & nC2 & nC3;
					end if;
				end if;

			end if; 
		end process;
		                                                                          
end archi;

--2B7E151628AED2A6ABF7158809CF4F3C

--force -freeze sim:/exp_key/clk 1 0, 0 {50 ns} -r 100
--force -freeze sim:/exp_key/KIN 128'h2B7E151628AED2A6ABF7158809CF4F3C 0
--force -freeze sim:/exp_key/enable 0 0
