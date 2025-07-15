module spi_memory(
    input clk, rst_n, cs_n, miso,
    output reg ready, mosi, op_done
);

reg [7:0] memory [31:0] = '{default:0};
integer count = 0;
reg [15:0] data_in;
reg [7:0]  data_out;

typedef enum bit [2:0] {
    IDLE = 0, 
    DETECT = 1, 
    STORE = 2, 
    SEND_ADDR = 3, 
    SEND_DATA = 4
} state_type;

state_type state = IDLE;

always @(posedge clk) begin
    if (!rst_n) begin
        state    <= IDLE;
        count    <= 0;
        mosi     <= 0;
        ready    <= 0;
        op_done  <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                count   <= 0;
                mosi    <= 0;
                ready   <= 0;
                op_done <= 0;
                data_in <= 0;
                
                if (!cs_n) state <= DETECT;
                else state <= IDLE;
            end
                  
            DETECT: begin 
                if (miso) state <= STORE;  // Write operation
                else state <= SEND_ADDR;   // Read operation
            end
                   
            STORE: begin
                if (count <= 15) begin
                    data_in[count] <= miso;
                    count <= count + 1;
                    state <= STORE;
                end
                else begin
                    memory[data_in[7:0]] <= data_in[15:8];
                    state   <= IDLE;
                    count   <= 0;
                    op_done <= 1'b1;
                end
            end
                    
            SEND_ADDR: begin
                if (count <= 7) begin
                    data_in[count] <= miso;
                    count <= count + 1;
                    state <= SEND_ADDR;
                end
                else begin
                    count   <= 0;
                    state   <= SEND_DATA;
                    ready   <= 1'b1;
                    data_out <= memory[data_in[7:0]];
                end
            end
                       
            SEND_DATA: begin
                ready <= 1'b0;
                if (count < 8) begin
                    mosi <= data_out[count]; 
                    count <= count + 1;
                    state <= SEND_DATA;
                end 
                else begin
                    count   <= 0;
                    state   <= IDLE;
                    op_done <= 1'b1;
                end     
            end   
                    
            default: state <= IDLE;
        endcase
    end
end

endmodule