// Contador de ciclos de 32 bits agregado en el Proyecto 2.
// Extraido de pochoco_periph.v a un modulo propio para poder
// identificar su area en la sintesis y su ubicacion en el layout.

module pochoco_cycle_counter (
  input  wire        clk_i,
  input  wire        rst_ni,
  output reg  [31:0] count_o
);

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni)
      count_o <= 32'b0;
    else
      count_o <= count_o + 32'd1;
  end

endmodule
