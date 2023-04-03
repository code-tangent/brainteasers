//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Michael Fernandez
// 
// Create Date: 03/04/2023
// Module Name: ascii_char_to_decimal_value
// Description: One byte ascii number per cycle converted to bin and concatinated in binary_out with as low latency as possible
//              Takes one cycle of non-valid to reset. Comments inline for anything that was tricky
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module ascii_char_to_decimal_value#(
    parameter                                               ASCII_CHAR_TO_CONVERT = 5
    )(
    input wire                                              clk,
    input wire                                              ascii_char_valid,
    input wire      [7:0]                                   ascii_char,

    output logic                                            binary_out_valid,
    output logic    [$clog2(10**ASCII_CHAR_TO_CONVERT)-1:0] binary_out
);

    //convert 0-9 ascii to bin takes lower 4 bits for binary value
    logic [ASCII_CHAR_TO_CONVERT-2:0] [3:0]         binary_value_prev   = 0; //-2 b.c. lower bits output is converted comb
    logic [$clog2(10**ASCII_CHAR_TO_CONVERT)-1:0]   binary_out_upper    = 0;

    integer i,k;

    always_ff @(posedge clk)
        if(ascii_char_valid) 
            binary_value_prev[0] <= ascii_char[3:0];
        else //flush out the old values and prepare for next valid. 
            binary_value_prev[0] <= 0;

    always_ff @(posedge clk) begin
        for(i = 1; i < ASCII_CHAR_TO_CONVERT-1; i++) begin
            if(ascii_char_valid)
                binary_value_prev[i] <= binary_value_prev[i-1];
            else //flush out the old values and prepare for next valid. 
                binary_value_prev[i] <= 0;
        end
    end

    always_comb begin
        binary_out_upper = 0;
        for(k = 0; k < ASCII_CHAR_TO_CONVERT-1; k++) begin
            binary_out_upper = binary_out_upper + binary_value_prev[k] * 10**(k+1); //[0] is actually in the 10's position, so k+1
        end
    end

    always_comb binary_out_valid    = ascii_char_valid;
    always_comb binary_out          = binary_out_upper + ascii_char[3:0];

endmodule