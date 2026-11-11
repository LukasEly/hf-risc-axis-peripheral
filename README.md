# Periférico AXI-Stream de LEDs e chaves para o HF-RISC

Periférico em VHDL que conecta os LEDs e as chaves da placa Nexys A7 ao SoC **HF-RISC** por uma interface **AXI-Stream**. O processador escreve nos LEDs e lê as chaves através de registradores mapeados em memória. Um programa em C demonstra o uso, deslocando um bit aceso pelos LEDs.

## Contexto

Trabalho da disciplina **Construção de Sistemas Digitais** (PUCRS), 4º semestre de Engenharia de Computação.

## Autor

- Lukas Ely

## Tecnologias

- VHDL e AXI-Stream
- SoC [HF-RISC](https://github.com/sjohann81/hf-risc) (RISC-V)
- FPGA Artix-7 (Nexys A7) e Vivado
- C bare metal para o teste em software

## Mapa de registradores

| Endereço | Registrador |
|---|---|
| `0xe4a90010` | status (`MTREADY`, `MTVALID`) |
| `0xe4a90030` | dado enviado aos LEDs |

## Como usar

1. Clone o HF-RISC e copie os arquivos de `rtl/` para o projeto da plataforma Artix-7.
2. Use `rtl/artix7_nexysa7_basic_soc_leds.vhd` como top e `constraints/artix7_nexysa7_basic_soc.xdc` como restrições no Vivado.
3. Para simular, compile o testbench `sim/hf-riscv_leds_sw_axis_tb.vhd` junto com o HF-RISC.
4. Compile `sw/leds_axi.c` com o makefile de software do HF-RISC e carregue na placa.

## Estrutura de pastas

```
.
├── rtl/
│   ├── leds_sw.vhd                        periférico AXI-Stream de LEDs e chaves
│   ├── if_axis.vhd                        ponte entre o barramento do SoC e o AXI-Stream
│   └── artix7_nexysa7_basic_soc_leds.vhd  top da plataforma com o periférico
├── sim/hf-riscv_leds_sw_axis_tb.vhd       testbench
├── constraints/artix7_nexysa7_basic_soc.xdc
├── sw/leds_axi.c                          programa de teste
└── LICENSE                                GPL-2.0, herdada do HF-RISC
```
