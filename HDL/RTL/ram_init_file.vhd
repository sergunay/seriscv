-- Doxygen labels
--! @file     ram_init_file.vhd
--! @brief
--! @author   Selman Erguenay
--! @date     2020-12-04
----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
----------------------------------------------------------------------------
entity ram_init_file is
  generic(
    RAM_SIZE   : positive := 32;
    INIT_FILE  : string   := "ram_init_file.dat";
    ADDR_NBITS : positive := 6;
	DATA_NBITS : positive := 32);
  port(
    iClk    : in std_logic;
    iWe     : in std_logic;
    iAddr   : in std_logic_vector(ADDR_NBITS-1 downto 0);
    iData   : in std_logic_vector(DATA_NBITS-1 downto 0);
    oData   : out std_logic_vector(DATA_NBITS-1 downto 0));
end entity ram_init_file;

architecture rtl of ram_init_file is
----------------------------------------------------------------------------
  type RamType is array (0 to RAM_SIZE-1) of bit_vector(DATA_NBITS-1 downto 0);

  impure function InitRamFromFile(RamFileName : in string) return RamType is
    FILE RamFile         : text is in RamFileName;
    variable RamFileLine : line;
    variable RAM         : RamType;
  begin
    for I in RamType'range loop
	  readline(RamFile, RamFileLine);
	  read(RamFileLine, RAM(I));
	end loop;
	return RAM;
end function;

  signal RAM : RamType := InitRamFromFile(INIT_FILE);

begin
----------------------------------------------------------------------------

  RAM_WR_RD_PROC: process(iClk)
  begin
    if rising_edge(iClk) then
	  if iWe = '1' then
        RAM(to_integer(unsigned(iAddr))) <= to_bitvector(iData);
	  end if;
	  oData <= to_stdlogicvector(RAM(to_integer(unsigned(iAddr))));
	end if;
  end process RAM_WR_RD_PROC;

----------------------------------------------------------------------------
end architecture rtl;
----------------------------------------------------------------------------
