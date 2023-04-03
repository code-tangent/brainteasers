`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Michael Fernandez
// 
// Create Date: 03/04/2023
// Module Name: data_history_matcher_tb
// Description: Just simple test to see if design works
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module data_history_matcher_tb();

localparam CLK_FREQUENCY    = 250.0e6;
localparam CLK_HALF_PERIOD  = 1/(CLK_FREQUENCY)*1000e6/2;

localparam              DATA_LEN    = 8;
logic                   clk         = 0;
logic                   data_valid  = 0;
logic [DATA_LEN-1:0]    data        = 0;
logic                   match;

//Generate clk
always begin
    #CLK_HALF_PERIOD clk = 1;
    #CLK_HALF_PERIOD clk = 0;
end
default clocking clock @(posedge clk);
default input #1step output #1;
endclocking

data_history_matcher dut (
    .*
);

//Basic Simulation
    initial begin
        $display("Starting Sim");
        data_valid  = 1;
        data        = 5;
        ##4;
        data        = 7;
        ##4;
        data        = 5;
        ##2;
        data        = 4;
        ##2;
        data        = 5;
        ##10;
        data_valid  = 0;

        ##100;
        $display("Ending Simulation");
        $finish;
    end


endmodule