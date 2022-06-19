LIBRARY ieee  ; 
    USE ieee.NUMERIC_STD.all  ; 
    USE ieee.std_logic_1164.all  ; 
    use ieee.math_real.all;

library vunit_lib;
context vunit_lib.vunit_context;

    use work.sigma_delta_simulation_model_pkg.all;

entity delta_sigma_filtering_tb is
  generic (runner_cfg : string);
end;

architecture vunit_simulation of delta_sigma_filtering_tb is

    constant clock_period      : time    := 1 ns;
    constant simtime_in_clocks : integer := 5000;
    
    signal simulator_clock     : std_logic := '0';
    signal simulation_counter  : natural   := 0;
    -----------------------------------
    -- simulation specific signals ----

    signal sdm_model : sdm_model_record := init_sdm_model;
    signal sdm_io : std_logic := '0';
    signal sini : real := 0.0;

    signal filter : real := 0.0;

begin

------------------------------------------------------------------------
    simtime : process
    begin
        test_runner_setup(runner, runner_cfg);
        wait for simtime_in_clocks*clock_period;
        test_runner_cleanup(runner); -- Simulation ends here
        wait;
    end process simtime;	

    simulator_clock <= not simulator_clock after clock_period/2.0;
------------------------------------------------------------------------

    stimulus : process(simulator_clock)

    begin
        if rising_edge(simulator_clock) then
            simulation_counter <= simulation_counter + 1;



            create_sdm_model(sdm_model, 0.9 * sin((real(simulation_counter)/400.0*math_pi) mod (2.0*math_pi)));
            sdm_io <= sdm_model.output;

            sini <= sin((real(simulation_counter)/400.0*math_pi) mod (2.0*math_pi));


        end if; -- rising_edge
    end process stimulus;	
------------------------------------------------------------------------
end vunit_simulation;
