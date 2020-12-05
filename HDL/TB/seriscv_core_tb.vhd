--! @file       seriscv_core_tb.vhd
--! @brief      a short description what can be found in the file
--! @author     Selman Erguenay
--! @date       2020-12-04
----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;
----------------------------------------------------------------------------
entity seriscv_core_tb is
end entity;

architecture tb of seriscv_core_tb is

  component seriscv_core is
  port(
    iClk  : in std_logic;
    iRst  : in std_logic
  );
  end component;

  -- Simulation constants
  constant C_CLK_PER : time := 83.33 ns;

  -- Simulation control signals
  signal sim_clk  : std_logic := '0';
  signal sim_rst  : std_logic := '0';
  signal sim_stop : boolean   := FALSE;    -- stop simulation?

begin
----------------------------------------------------------------------------

  DUV: seriscv_core
    port map(
    iClk => sim_clk,
    iRst => sim_rst);

  CLK_STIM : sim_clk <= not sim_clk after C_CLK_PER/2 when not sim_stop;

  STIM_PROC: process

    procedure init is
    begin
      sim_rst       <= '1';
      wait for 400 ns;
      sim_rst        <= '0';
    end procedure init;

  begin
    init;
    wait for 5 ms;
    sim_stop   <= True;
    wait;
  end process STIM_PROC;

----------------------------------------------------------------------------
end architecture tb;
----------------------------------------------------------------------------
