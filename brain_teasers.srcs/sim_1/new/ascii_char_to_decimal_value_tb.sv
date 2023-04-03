`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Michael Fernandez
// 
// Create Date: 03/04/2023
// Module Name: ascii_char_to_decimal_value_tb
// Description: Just simple test to see if design works
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module ascii_char_to_decimal_value_tb();

localparam CLK_FREQUENCY    = 250.0e6;
localparam CLK_HALF_PERIOD  = 1/(CLK_FREQUENCY)*1000e6/2;

localparam                                      ASCII_CHAR_TO_CONVERT   = 5;
logic                                           clk                     = 0;
logic                                           ascii_char_valid        = 0;
logic   [7:0]                                   ascii_char              = 0;
logic                                           binary_out_valid        = 0;
logic   [$clog2(ASCII_CHAR_TO_CONVERT*8)-1:0]   binary_out;      

logic [3:0] i; 

//Generate clk
always begin
    #CLK_HALF_PERIOD clk = 1;
    #CLK_HALF_PERIOD clk = 0;
end
default clocking clock @(posedge clk);
default input #1step output #1;
endclocking

ascii_char_to_decimal_value dut (
    .*
);

function logic [7:0] binary_to_ascii(logic [3:0] binary_value);
    if(binary_value < 10)
        return binary_value + 'h30;
    else begin
        $error("Attempting to convert value greater then 9 to ascii");
        return "0";
    end
endfunction

//Basic Simulation
initial begin
    $display("Starting Sim");
    ##2;

    ascii_char_valid = 1;
    for(i = 0; i < 10; i++) begin
        ascii_char       = binary_to_ascii(i);
        ##1;
    end
    ascii_char_valid    = 0;
    ascii_char          = 0;

    ##5;
    $display("Ending Simulation");
    $finish;
end

endmodule