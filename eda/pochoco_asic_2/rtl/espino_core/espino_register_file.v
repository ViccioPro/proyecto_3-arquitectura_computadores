// Register file para ASIC: 16 registros x 32 bits implementados con flip-flops.
// Reemplaza la version de FPGA basada en SB_RAM40_4K (BRAM del iCE40).
// Se conserva la lectura sincronica (1 ciclo de latencia) de la BRAM original
// y se fuerza x0 = 0, ya que en silicio los flip-flops no se inicializan.
// No tenemos idea de si va a funcionar correctamente o no
// Quedará documentado en el informe!!!

module espino_register_file (
  input  wire        clk_i,
  input  wire        rst_ni,
  input  wire [3:0]  raddr_a_i,
  output reg  [31:0] rdata_a_o,
  input  wire [3:0]  raddr_b_i,
  output reg  [31:0] rdata_b_o,
  input  wire [3:0]  waddr_i,
  input  wire [31:0] wdata_i,
  input  wire        we_i
);

  reg [31:0] regs [1:15];   // x1..x15; x0 no se almacena

  // Escritura (x0 nunca se escribe)
  always @(posedge clk_i) begin
    if (we_i && (waddr_i != 4'd0))
      regs[waddr_i] <= wdata_i;
  end

  // Lectura sincronica, igual que la BRAM original (read-first)
  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rdata_a_o <= 32'd0;
      rdata_b_o <= 32'd0;
    end else begin
      rdata_a_o <= (raddr_a_i == 4'd0) ? 32'd0 : regs[raddr_a_i];
      rdata_b_o <= (raddr_b_i == 4'd0) ? 32'd0 : regs[raddr_b_i];
    end
  end

endmodule
