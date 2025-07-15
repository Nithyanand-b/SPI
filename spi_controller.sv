module spi_controller(
    input write_en, clk, rst_n, ready, op_done,
    input [7:0] addr, data_in,
    output [7:0] data_out,
    output reg cs_n, mosi,
    input miso,
    output reg done, error
);

reg [16:0] data_reg;  // {data_in[7:0], addr[7:0], write_en}
reg [7:0] data_out_reg;
integer count = 0;

typedef enum bit [2:0] {
    IDLE = 0, 
    LOAD = 1, 
    CHECK_OP = 2, 
    SEND_DATA = 3, 
    READ_DATA1 = 4, 
    READ_DATA2 = 5, 
    ERROR = 6, 
    CHECK_READY = 7
} state_type;

state_type state = IDLE; 

always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        count <= 0;
        cs_n  <= 1'b1;
        mosi  <= 1'b0; 
        error <= 1'b0;
        done  <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                cs_n  <= 1'b1;
                mosi  <= 1'b0;
                state <= LOAD;
                error <= 1'b0;
                done  <= 1'b0;
            end
            
            LOAD: begin
                data_reg <= {data_in, addr, write_en};
                state    <= CHECK_OP;
            end
 
            CHECK_OP: begin
                if (write_en == 1'b1 && addr < 32) begin
                    cs_n  <= 1'b0;
                    state <= SEND_DATA;
                end
                else if (write_en == 1'b0 && addr < 32) begin
                    state <= READ_DATA1;
                    cs_n  <= 1'b0;
                end
                else begin
                    state <= ERROR;
                    cs_n  <= 1'b1;
                end
            end
 
            SEND_DATA: begin
                if (count <= 16) begin
                    count <= count + 1;
                    mosi  <= data_reg[count];
                    state <= SEND_DATA;
                end
                else begin
                    cs_n <= 1'b1;
                    mosi <= 1'b0;
                    if (op_done) begin
                        count <= 0;
                        done  <= 1'b1;
                        state <= IDLE;
                    end
                    else begin
                        state <= SEND_DATA;
                    end
                end
            end
 
            READ_DATA1: begin
                if (count <= 8) begin
                    count <= count + 1;
                    mosi  <= data_reg[count];
                    state <= READ_DATA1;
                end
                else begin
                    count <= 0;
                    cs_n  <= 1'b1;
                    state <= CHECK_READY;
                end
            end
   
            CHECK_READY: begin
                if (ready) state <= READ_DATA2;
                else state <= CHECK_READY;
            end
 
            READ_DATA2: begin
                if (count <= 7) begin
                    data_out_reg[count] <= miso;
                    count <= count + 1;
                    state <= READ_DATA2;
                end
                else begin
                    count <= 0;
                    done  <= 1'b1;
                    state <= IDLE;
                end
            end
            
            ERROR: begin
                error <= 1'b1;
                state <= IDLE;
                done  <= 1'b1;
            end
            
            default: begin
                state <= IDLE;
                count <= 0;
            end
        endcase
    end 
end 

assign data_out = data_out_reg;

endmodule