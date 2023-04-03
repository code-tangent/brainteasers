//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Michael Fernandez
// 
// Create Date: 03/04/2023
// Module Name: data_history_matcher
// Description: Looks at previous cycles and outputs match = 1 if MATCH_VALUE has been seen 'HISTORY_NUM_VALUES_MATCH' times
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module data_history_matcher #(
    parameter                       DATA_LEN = 8
)(
    input wire                      clk,
    input wire                      data_valid,
    input wire      [DATA_LEN-1:0]  data,

    output logic                    match
);


    localparam PREVIOUS_CYCLES_TO_CHECK = 10;
    localparam HISTORY_NUM_VALUES_MATCH = 6;
    localparam MATCH_VALUE              = 5;

    logic [PREVIOUS_CYCLES_TO_CHECK-1:0] [DATA_LEN-1:0] data_previous;
    logic [PREVIOUS_CYCLES_TO_CHECK-1:0]                match_previous;
    logic [$clog2(PREVIOUS_CYCLES_TO_CHECK)-1:0]        total_matches;

    integer i,j,k;

    always_ff @(posedge clk)
        if(data_valid)
            data_previous[0] <= data;

    always_ff @(posedge clk) begin
        for (i = 1; i < PREVIOUS_CYCLES_TO_CHECK; i++) begin
            if(data_valid)
                data_previous[i] <= data_previous[i-1];
        end
    end

    //TODO: Can get one cycle faster if you compare data instead of data_previous[0] to start
    always_comb begin
        for(k = 0; k < PREVIOUS_CYCLES_TO_CHECK; k++) begin
            match_previous[k] = data_previous[k] == MATCH_VALUE;
        end
    end

    always_comb begin
        total_matches = 0;
        for(j = 0; j < PREVIOUS_CYCLES_TO_CHECK; j++) begin
            total_matches = total_matches + match_previous[j];
        end
    end

    always_comb match = total_matches >= HISTORY_NUM_VALUES_MATCH;


endmodule