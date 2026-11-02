`timescale 1ns/1ps

module tb_compare;

  reg clk = 0;
  reg rst_n = 0;
  reg [3:0] btn = 0;

  wire [3:0] led_r, led_g;
  wire [6:0] s1_r, s2_r, s1_g, s2_g;
  wire spi_r, spi_g;

  integer ciclo = 0;
  integer inicio_r, inicio_g;
  integer fin_r, fin_g;
  integer error_r, error_g;
  integer reinicio_r, reinicio_g;

  reg [3:0] objetivo;
  reg [3:0] incorrecto;

  always #5 clk = ~clk;

  asic_top rtl (
    .clk_i(clk), .rst_ni(rst_n),
    .btn_i(btn), .led_o(led_r),
    .seg1_o(s1_r), .seg2_o(s2_r),
    .spi_sclk_i(1'b0),
    .spi_mosi_i(1'b0),
    .spi_cs_ni(1'b1),
    .spi_miso_o(spi_r)
  );

  asic_top_gate gate_dut (
    .clk_i(clk), .rst_ni(rst_n),
    .btn_i(btn), .led_o(led_g),
    .seg1_o(s1_g), .seg2_o(s2_g),
    .spi_sclk_i(1'b0),
    .spi_mosi_i(1'b0),
    .spi_cs_ni(1'b1),
    .spi_miso_o(spi_g)
  );

  // Comparar todas las salidas en cada ciclo.
  always @(posedge clk) begin
    ciclo = ciclo + 1;
    #1;

    if (rst_n && ciclo > 12) begin
      if ({led_r,s1_r,s2_r,spi_r} !==
          {led_g,s1_g,s2_g,spi_g}) begin
        $display("ERROR EN CICLO %0d", ciclo);
        $display("RTL:  LED=%b S1=%b S2=%b",
                 led_r,s1_r,s2_r);
        $display("GATE: LED=%b S1=%b S2=%b",
                 led_g,s1_g,s2_g);
        $fatal(1, "Las simulaciones son diferentes");
      end
    end
  end

  initial begin
    $display("==================================");
    $display(" COMPARACION RTL VS POSTSINTESIS");
    $display("==================================");

    // Reset inicial.
    repeat (8) @(negedge clk);
    rst_n = 1;

    // Pulsacion inicial, en ciclos definidos.
    repeat (150) @(negedge clk);
    btn = 4'b0001;
    $display("Inicio: pulsacion en ciclo %0d", ciclo);

    repeat (50) @(negedge clk);
    btn = 0;

    // Primera ronda.
    wait (led_r === 4'b1111);
    inicio_r = ciclo;
    wait (led_g === 4'b1111);
    inicio_g = ciclo;

    $display("Ronda iniciada: RTL=%0d GATE=%0d",
             inicio_r, inicio_g);

    // Esperar LED objetivo.
    wait (
      led_r === 4'b0001 ||
      led_r === 4'b0010 ||
      led_r === 4'b0100 ||
      led_r === 4'b1000
    );

    objetivo = led_r;

    $display("Objetivo: %b en ciclo %0d",
             objetivo, ciclo);

    // Respuesta correcta.
    repeat (250) @(negedge clk);
    btn = objetivo;

    $display("Boton correcto en ciclo %0d", ciclo);

    repeat (40) @(negedge clk);
    btn = 0;

    // La siguiente ronda indica que
    // la respuesta correcta fue procesada.
    wait (led_r === 4'b1111);
    fin_r = ciclo;
    wait (led_g === 4'b1111);
    fin_g = ciclo;

    $display("");
    $display("RESULTADO RONDA CORRECTA");
    $display("RTL:  %0d ciclos", fin_r - inicio_r);
    $display("GATE: %0d ciclos", fin_g - inicio_g);

    if ((fin_r - inicio_r) !== (fin_g - inicio_g))
      $fatal(1, "Diferencia en ciclos");

    $display("RONDA CORRECTA: OK");

    // Segunda ronda: probar respuesta incorrecta.
    wait (
      led_r === 4'b0001 ||
      led_r === 4'b0010 ||
      led_r === 4'b0100 ||
      led_r === 4'b1000
    );

    objetivo = led_r;
    incorrecto = {objetivo[2:0], objetivo[3]};

    $display("");
    $display("Objetivo segunda ronda: %b", objetivo);
    $display("Boton incorrecto: %b", incorrecto);

    repeat (250) @(negedge clk);
    btn = incorrecto;

    $display("Boton incorrecto en ciclo %0d", ciclo);

    // Los displays deben indicar EE.
    wait (
      led_r === 4'b0000 &&
      s1_r === 7'b0000110 &&
      s2_r === 7'b0000110
    );

    error_r = ciclo;

    wait (
      led_g === 4'b0000 &&
      s1_g === 7'b0000110 &&
      s2_g === 7'b0000110
    );

    error_g = ciclo;

    $display("Error detectado: RTL=%0d GATE=%0d",
             error_r, error_g);

    repeat (40) @(negedge clk);
    btn = 0;

    // Se reinicia la ronda.
    wait (led_r === 4'b1111);
    reinicio_r = ciclo;
    wait (led_g === 4'b1111);
    reinicio_g = ciclo;

    $display("Ronda reiniciada: RTL=%0d GATE=%0d",
             reinicio_r, reinicio_g);

    if (error_r !== error_g ||
        reinicio_r !== reinicio_g)
      $fatal(1, "Diferencia en manejo del error");

    $display("");
    $display("==================================");
    $display(" TEST 3.7 OK");
    $display(" RTL Y POSTSINTESIS COINCIDEN");
    $display("==================================");

    $finish;
  end

  // Evitar que la prueba quede esperando indefinidamente.
  initial begin
    repeat (25000) @(posedge clk);
    $fatal(1, "TIMEOUT");
  end

endmodule
