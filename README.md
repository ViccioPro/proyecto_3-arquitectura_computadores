# Proyecto 3 — Pochoco SoC: del RTL al GDSII en GF180MCU

**Arquitectura de Computadores 2026-20 · Universidad de los Andes · Grupo 16**
Andrés Berríos · Víctor Parada · Sebastián Trigo

Este repositorio lleva el **Pochoco SoC** (procesador RISC-V Espino), con el **juego de reflejos del Proyecto 2**, desde el RTL hasta un **GDSII**, usando el flujo abierto **LibreLane** y el PDK **GF180MCU**. El resultado es un **macro digital implementado con celdas estándar**, no un chip completo listo para encapsular: sus puertos son terminales lógicos que, en un chip completo, se conectarían a pads de I/O.

El análisis completo está en el informe del proyecto.

---

## Versiones utilizadas en la corrida final

Para que los resultados sean reproducibles, estas son las versiones exactas de la corrida final:

| Elemento | Versión |
|---|---|
| LibreLane | **3.0.17** (instalado con Nix) |
| PDK | **`gf180mcuD`**, revisión de Open PDKs **`54435919abffb937387ec956209f9cf5fd2dfbee`** (gestionada con Ciel) |
| Biblioteca de celdas estándar | **`gf180mcu_fd_sc_mcu7t5v0`** |
| Yosys / Verilator / Icarus Verilog | Incluidos en el entorno Nix de LibreLane 3.0.17 (Yosys 0.62, Verilator 5.044) |

---

## Diseño final

| Parámetro | Valor |
|---|---|
| Módulo superior | `asic_top` (`rtl/asic_top.v`) |
| Período de reloj (`CLOCK_PERIOD`) | 100 ns (10 MHz) |
| Utilización objetivo (`FP_CORE_UTIL`) | 40 % |
| Memoria | Estrategia 1: ROM combinacional de 100 palabras + RAM de datos de 2 palabras |
| Síntesis | `SYNTH_HIERARCHY_MODE = deferred_flatten` (permite medir el área por módulo) |
| `TenthCycles` | 1.000.000 (una décima de segundo a 10 MHz) |

| Resultado | Valor |
|---|---|
| Área de celdas (síntesis) | 151.424,9 µm² |
| Área del die | 406.549 µm² (≈ 0,407 mm²) |
| Flip-flops | 909 |
| DRC (Magic) / LVS (Netgen) | 0 errores / *Circuits match uniquely* |
| Antena | 10 violaciones detectadas, 0 después de la reparación (12 jumpers) |
| Setup / hold (T = 100 ns) | Cumple en todos los corners (setup WNS +46,89 ns en `max_ss_125C_4v50`) |
| Frecuencia máxima | 18,80 MHz (`CLOCK_PERIOD` mínimo = 53,2 ns) |

> El DRC de KLayout no se ejecuta porque `KLAYOUT_DRC_RUNSET` no está definido para `gf180mcuD` en LibreLane 3.0.17; la verificación de reglas se hace con Magic.

---

## Estructura del repositorio

```
.
├── README.md                    Este archivo
├── docs/                        Informe del Proyecto 2 (referencia)
└── eda/pochoco_asic/            Diseño del macro ASIC
    ├── rtl/                     RTL del diseño entregado
    │   ├── asic_top.v           Módulo superior del macro (reemplaza a game_top.v)
    │   ├── pochoco_soc.v        SoC con reset externo y sincronizador de 2 FF
    │   ├── pochoco_periph.v     Periféricos (LEDs, displays, botones, décimas de segundo)
    │   ├── pochoco_cycle_counter.v  Contador de ciclos (módulo propio para trazabilidad)
    │   ├── pochoco_spi_slave.v
    │   ├── espino_core/         Procesador Espino (register file con flip-flops)
    │   ├── mem_s1/              Estrategia 1: ROM combinacional + RAM reducida (USADA)
    │   └── mem_s2/              Estrategia 2: memoria unificada de flip-flops
    ├── sw/                      Programas en ensamblador (game.s) y sus .hex
    ├── assembler_v1.py          Assembler del Proyecto 2
    ├── assembler_v2.py          Assembler extendido: genera game.hex, la ROM (mem_s1)
    │                            y la memoria de flip-flops (mem_s2)
    ├── config.json              Configuración de la corrida final (T = 100 ns, U = 40 %)
    ├── config_timing_*.json     Barrido de CLOCK_PERIOD (sección 3.4)
    ├── config_util_*.json       Barrido de FP_CORE_UTIL (sección 3.5)
    ├── fpga_orig/               Versiones originales (FPGA) de los archivos modificados
    ├── evidencia_3_1/           Logs de las construcciones dependientes de la FPGA
    ├── evidencia_3_5/           Métricas del barrido de utilización y layout al 73 %
    ├── evidencia_3_6/           Reportes de DRC, LVS y antena; layout anotado
    └── evidencia_3_7/           Simulación post-síntesis (RTL, netlist, testbench y log)
```

La carpeta `runs/` (resultados de LibreLane) no se sube al repositorio: se regenera al ejecutar el flujo.

---

## Instalación

Probado en Linux (CachyOS, basado en Arch). Se necesita **Nix** con el caché binario de LibreLane.

**1. Instalar Nix** (cerrar y volver a abrir la terminal al terminar):

```bash
curl --proto '=https' --tlsv1.2 -fsSL https://artifacts.nixos.org/nix-installer | sh -s -- install --no-confirm --extra-conf "
    extra-substituters = https://nix-cache.fossi-foundation.org
    extra-trusted-public-keys = nix-cache.fossi-foundation.org:3+K59iFwXqKsL7BNu6Guy0v+uTlwsxYQxjspXzqLYQs=
    extra-experimental-features = nix-command flakes
"
```

**2. Clonar LibreLane en la versión usada:**

```bash
git clone https://github.com/librelane/librelane ~/eda/librelane
cd ~/eda/librelane
git checkout 3.0.17
```

**3. Entrar al entorno y verificar:**

```bash
cd ~/eda/librelane
nix-shell
librelane --smoke-test
```

**4. Descargar y activar el PDK en la revisión usada:**

```bash
librelane --pdk gf180mcuD --smoke-test
ciel enable --pdk-family gf180mcu 54435919abffb937387ec956209f9cf5fd2dfbee
```

> LibreLane requiere el locale `en_US.UTF-8` habilitado en el sistema. Si al correr el diseño aparece `The PDK gf180mcuD was not found`, ejecutar el comando `ciel enable` anterior y usar siempre `--pdk gf180mcuD` en el comando de LibreLane.

---

## Cómo reproducir los resultados

Todos los comandos se ejecutan **dentro del `nix-shell`**, en la carpeta `eda/pochoco_asic`.

### Regenerar la memoria a partir de `game.s`

```bash
python3 assembler_v2.py sw/game.s sw/game.hex rtl/mem_s1/pochoco_rom.v rtl/mem_s2/pochoco_ram.v
```

Genera `game.hex`, la ROM de la estrategia 1 y la memoria de flip-flops de la estrategia 2. Para usar la estrategia 2, cambiar `mem_s1` por `mem_s2` en `VERILOG_FILES` de `config.json`.

### Corrida final

```bash
librelane --pdk gf180mcuD config.json --run-tag final
```

Los resultados quedan en `runs/final/`: GDSII en `final/gds/`, netlist en `final/nl/` y métricas en `final/metrics.csv`.

### Barrido de período (sección 3.4)

```bash
for t in 60 55 54_5 53_2 50; do
  librelane --pdk gf180mcuD config_timing_$t.json --run-tag p3_4_T$t
done
```

### Barrido de utilización (sección 3.5)

```bash
for u in 50 60 70 72 73 74 75 80; do
  librelane --pdk gf180mcuD config_util_$u.json --run-tag p3_5_U$u
done
```

Las corridas de 74, 75 y 80 % fallan con `DPL-0036 Detailed placement failed` (falta de espacio para los buffers de reloj o de reparación). El área mínima que completa el flujo es la de 73 %.

### Simulación post-síntesis (sección 3.7)

Se ejecuta en una copia de `evidencia_3_7`, que contiene el RTL con `TenthCycles = 100` para acortar la espera de 3 s:

```bash
cp -r evidencia_3_7 ../sim_3_7 && cd ../sim_3_7

# 1. Síntesis sin retardos
librelane --pdk gf180mcuD config.json --run-tag sim37 --to Yosys.Synthesis

# 2. Renombrar el módulo del netlist
sed 's/^module asic_top(/module asic_top_gate(/' \
    runs/sim37/*-yosys-synthesis/asic_top.nl.v > asic_top_gate.nl.v

# 3. Compilar y simular con los modelos funcionales de las celdas
M=$(echo ~/.ciel/ciel/gf180mcu/versions/*/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu7t5v0/verilog)
iverilog -g2012 -DFUNCTIONAL -o sim_compare.vvp tb_compare.v \
    rtl/*.v rtl/espino_core/*.v rtl/mem_s1/*.v asic_top_gate.nl.v \
    $M/primitives.v $M/gf180mcu_fd_sc_mcu7t5v0.v
vvp sim_compare.vvp | tee comparacion.log
```

El resultado esperado termina con `TEST 3.7 OK` y `RTL Y POSTSINTESIS COINCIDEN`.

### Ver el layout

```bash
librelane --pdk gf180mcuD config.json --run-tag final --flow OpenInKLayout
librelane --pdk gf180mcuD config.json --run-tag final --flow OpenInOpenROAD
```

---

## Cambios respecto al RTL de FPGA (Proyecto 2)

| Construcción de FPGA | Reemplazo en el ASIC |
|---|---|
| BRAM `SB_RAM40_4K` en el register file | Banco de 15 × 32 flip-flops, lectura sincrónica, `x0` forzado a 0 |
| Carga de la memoria con `$readmemh` | ROM combinacional generada por `assembler_v2.py` + RAM de 2 palabras |
| Reset de encendido con valor inicial (`por_cnt`) | Entrada `rst_ni` externa con sincronizador de 2 flip-flops |
| Reloj de 25 MHz asumido (`TENTH_CYCLES = 2.500.000`) | `TenthCycles = 1.000.000` para 10 MHz |
| Puertos de la placa (UART, `goboard.pcf`) | `asic_top.v` solo con reloj, reset, LEDs, botones, displays y SPI |

Las versiones originales de los archivos modificados están en `fpga_orig/`.
