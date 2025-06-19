module spi_master #(parameter DIVIDER = 5) (
    input  logic clk, rst_n,
    input  logic start,
    input  logic [7:0] data_in,
    output logic [7:0] data_out,
    output logic done,
    output logic sclk,
    output logic cs_n,
    output logic mosi,
    input  logic miso
);
    typedef enum {IDLE, TRANSFER} state_t;
    state_t state;
    
    logic [7:0] tx_reg;
    logic [7:0] rx_reg;
    logic [15:0] clk_div;
    logic [4:0] half_cycle_count;
    logic sclk_int;
    
    assign sclk = sclk_int;
    assign data_out = rx_reg;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            done <= 0;
            cs_n <= 1;
            sclk_int <= 0;
            mosi <= 0;
            clk_div <= 0;
            half_cycle_count <= 0;
            rx_reg <= 0;
            tx_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    cs_n <= 1;
                    sclk_int <= 0;
                    if (start) begin
                        state <= TRANSFER;
                        cs_n <= 0;
                        tx_reg <= data_in;
                        rx_reg <= 0;
                        mosi <= data_in[7];
                        clk_div <= DIVIDER;
                        half_cycle_count <= 0;
                    end
                end
                
                TRANSFER: begin
                    if (clk_div > 0) begin
                        clk_div <= clk_div - 1;
                    end else begin
                        clk_div <= DIVIDER;
                        sclk_int <= ~sclk_int;
                        half_cycle_count <= half_cycle_count + 1;
                        
                        if (sclk_int) begin // Falling edge
                            if (half_cycle_count < 15) begin
                                tx_reg <= {tx_reg[6:0], 1'b0};
                                mosi <= tx_reg[6];
                            end
                        end else begin // Rising edge
                            if (half_cycle_count < 16) begin
                                rx_reg <= {rx_reg[6:0], miso};
                            end
                        end
                        
                        if (half_cycle_count == 16) begin
                            state <= IDLE;
                            done <= 1;
                            cs_n <= 1;
                        end
                    end
                end
            endcase
        end
    end
endmodule