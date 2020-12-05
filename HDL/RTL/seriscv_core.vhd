library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
----------------------------------------------------------------------------
entity seriscv_core is
  port(
    iClk  : in std_logic;
    iRst  : in std_logic
  );
end entity seriscv_core;

architecture rtl of seriscv_core is
----------------------------------------------------------------------------
  constant ADDR_NBITS : natural := 5;

  signal pc          : unsigned(ADDR_NBITS-1 downto 0) := (others=>'0');
  signal addr_branch : unsigned(ADDR_NBITS-1 downto 0) := (others=>'0');

  signal branch      : std_logic:= '0';

  signal instruction : std_logic_vector(31 downto 0) := (others=>'0');


  component ram_init_file
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
  end component;


begin
----------------------------------------------------------------------------

  I_MEM_INSTRUCTION: ram_init_file
  generic map(
    RAM_SIZE   => 32,
    INIT_FILE  => "ram_init_file.dat",
    ADDR_NBITS => ADDR_NBITS,
	DATA_NBITS => 32)
  port map(
    iClk    => iClk,
    iWe     => '0',
    iAddr   => std_logic_vector(pc),
    iData   => (others=>'0'),
    oData   => instruction);

  -- Program counter
  PC_PROC: process(iClk)
  begin
    if rising_edge(iClk) then
      if iRst = '1'then
        pc <= (others=>'0');
      elsif branch = '1' then
        pc <= addr_branch;
      else
        pc <= pc+1;
      end if;
    end if;
  end process PC_PROC;




----------------------------------------------------------------------------
end architecture rtl;
----------------------------------------------------------------------------

