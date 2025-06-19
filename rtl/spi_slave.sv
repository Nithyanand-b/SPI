module spi_slave (
    input  logic sclk,
    input  logic cs_n,
    input  logic mosi,
    output logic miso
);
    logic [7:0] shift_reg;
    
    // Reset shift register to 0xAA when chip select is active
    always @(negedge cs_n) begin
        shift_reg <= 8'hAA;
    end
    
    // Shift data on falling edge of SCLK
    always @(negedge sclk) begin
        if (!cs_n) begin
            shift_reg <= {shift_reg[6:0], mosi};
        end
    end
    
    // Output MSB of shift register
    assign miso = (!cs_n) ? shift_reg[7] : 1'b0;
endmodule