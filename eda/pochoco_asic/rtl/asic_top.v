// Modulo superior del macro ASIC del Pochoco SoC.
// Reemplaza a game_top.v (FPGA): sin UART y con reset externo.
// Los puertos son terminales logicos del macro, no pads de I/O.
// Displays: bit 0 = segmento A ... bit 6 = segmento G (activos en bajo).

module asic_top (
  input  wire       clk_i,
  input  wire       rst_ni,

  output wire [3:0] led_o,
  input  wire [3:0] btn_i,

  output wire [6:0] seg1_o,
  output wire [6:0] seg2_o,

  input  wire       spi_sclk_i,
  input  wire       spi_mosi_i,
  input  wire       spi_cs_ni,
  output wire       spi_miso_o
);

  pochoco_soc #(
    .TenthCycles (1000000)         // 10 MHz: 1.000.000 ciclos por decima
  ) u_pochoco (
    .i_Clk        (clk_i),
    .i_Rst_n      (rst_ni),

    .o_LED        (led_o),
    .i_Switch     (btn_i),

    .o_Segment1_A (seg1_o[0]), .o_Segment1_B (seg1_o[1]),
    .o_Segment1_C (seg1_o[2]), .o_Segment1_D (seg1_o[3]),
    .o_Segment1_E (seg1_o[4]), .o_Segment1_F (seg1_o[5]),
    .o_Segment1_G (seg1_o[6]),

    .o_Segment2_A (seg2_o[0]), .o_Segment2_B (seg2_o[1]),
    .o_Segment2_C (seg2_o[2]), .o_Segment2_D (seg2_o[3]),
    .o_Segment2_E (seg2_o[4]), .o_Segment2_F (seg2_o[5]),
    .o_Segment2_G (seg2_o[6]),

    .i_SPI_SCLK   (spi_sclk_i),
    .i_SPI_MOSI   (spi_mosi_i),
    .i_SPI_CS_n   (spi_cs_ni),
    .o_SPI_MISO   (spi_miso_o)
  );

endmodule
