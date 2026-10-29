// Estrategia 1 (seccion 3.2): ROM combinacional + RAM de datos reducida.
// Reemplaza la memoria unificada de FPGA (BRAM inicializada con $readmemh).
// - Puerto A: ROM generada por assembler_v2.py desde game.s, con registro de
//   salida para conservar la latencia de 1 ciclo de la BRAM original.
// - Puerto B: RAM de datos de DataWords palabras con flip-flops.

module pochoco_ram #(
  parameter DataWords = 16
) (
  input  wire        clk_i,

  // Port A: instruction
  input  wire        a_req_i,
  input  wire [31:0] a_addr_i,
  output reg  [31:0] a_rdata_o,

  // Port B: data
  input  wire        b_req_i,
  input  wire        b_we_i,
  input  wire [3:0]  b_be_i,
  input  wire [31:0] b_addr_i,
  input  wire [31:0] b_wdata_i,
  output reg  [31:0] b_rdata_o
);

  // ---------------- Instrucciones: ROM ----------------
  wire [31:0] rom_data;

  pochoco_rom u_rom (
    .addr_i (a_addr_i[31:2]),
    .data_o (rom_data)
  );

  always @(posedge clk_i) begin
    if (a_req_i) a_rdata_o <= rom_data;
  end

  // ---------------- Datos: RAM reducida ----------------
  localparam DAddrW = $clog2(DataWords);

  reg  [31:0]       dmem [0:DataWords-1];
  wire [DAddrW-1:0] b_word = b_addr_i[DAddrW+1:2];

  always @(posedge clk_i) begin
    if (b_req_i && b_we_i) begin
      if (b_be_i[0]) dmem[b_word][7:0]   <= b_wdata_i[7:0];
      if (b_be_i[1]) dmem[b_word][15:8]  <= b_wdata_i[15:8];
      if (b_be_i[2]) dmem[b_word][23:16] <= b_wdata_i[23:16];
      if (b_be_i[3]) dmem[b_word][31:24] <= b_wdata_i[31:24];
    end
    b_rdata_o <= dmem[b_word];
  end

endmodule
