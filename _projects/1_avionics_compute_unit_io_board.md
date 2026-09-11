---
layout: page
title: Avionics Compute Unit IO Board
description: High-density mixed-signal avionics carrier board featuring a 168-pin high-speed mezzanine connector, 60V step-down power conversion, bidirectional IV sensing, 24-bit delta-sigma ADC telemetry, Ethernet, and logic analyzer breakouts.
img: assets/img/acu_io_board_xray.png
importance: 1
category: work
---

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0 text-center">
    <img src="{{ '/assets/img/acu_io_board_xray.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Avionics Compute Unit IO Board Altium Layout X-Ray">
    <div class="caption">
      Altium Designer Composite X-Ray Routing &amp; Layer Layout of the Avionics Compute Unit (ACU) IO Board — Yellow Jacket Space Program (YJSP), Georgia Tech. Responsible Engineer: Bhuvanesh Senthil.
    </div>
  </div>
</div>

## 1. Top-Down System Architecture & Block Diagram

The **Avionics Compute Unit IO Board (ACU IO Board)** is a mission-critical carrier and instrumentation platform engineered for the **Yellow Jacket Space Program (YJSP)** at the **Georgia Institute of Technology**.

Designed to mate directly with the central Avionics Compute Unit mezzanine flight card via a high-density board-to-board connector, the ACU IO Board serves as the primary gateway for rocket power distribution, high-resolution multi-rail power telemetry, flight network communications, and comprehensive ground test instrumentation.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-9 text-center">
    <img src="{{ '/assets/img/acu_io_board_diagram.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="ACU IO Board System Block Diagram">
    <div class="caption">
      Top-Down System Architecture Block Diagram showing power regulation, sensing, mezzanine interconnect, and peripheral interfaces.
    </div>
  </div>
</div>

- **Power Distribution Network (PDN):** D-Sub 9-pin input ($V_{\text{BUS}} \le 60\,\text{V}$ @ 2A), transient protection (`SMAJ51A`, `C1Q4` 4A fuse, $2\times 47\,\mu\text{F}$ 80V bulk capacitors), Maxim MAX17503 synchronous buck (5V @ 500 kHz PWM), and ST LDL1117S33R low-noise LDO (3.3V).
- **Telemetry & Data Acquisition (DAQ):** Dual INA293B3Q current-sense amplifiers across $10\,\text{m}\Omega$ Kelvin shunts ($1\,\text{V}/\text{A}$ gain, $160\,\text{Hz}$ LPF) monitoring 5V and 3.3V rails, digitized alongside resistor-divided bus voltages by a TI ADS124S06 24-bit delta-sigma ADC.
- **Mezzanine Interconnect:** Hirose FX10A-168S-SV 168-pin high-density stacking connector linking to the central Avionics Compute Unit.
- **Communications & Debug Breakouts:** Abracon ARJM11 Magjack with integrated magnetics and TI TPD4EUSB30 ESD clamp; ten perimeter test headers (`J1`–`J10`) routing 118 GPIO lines, 5 SPI buses, 2 I2C buses, 3 UARTs, and RS-232.

### Signal & Power Flow:

1. **High-Voltage Power Input & Protection:** Raw bus power ($V_{\text{BUS}}$ nominal $24\,\text{V}$–$48\,\text{V}$, transient capability up to $60\,\text{V}$) enters through a rugged 9-pin D-Sub connector (`J11`). Transients are clamped by a high-power unidirectional TVS diode (`SMAJ51A`), fast-acting overcurrent protection is provided by a surface-mount 4A fuse (`C1Q4`), and bus stability is maintained by dual $80\,\text{V}$ $47\,\mu\text{F}$ low-ESR bulk capacitors (`C2`, `C3`).
2. **Synchronous Buck & Linear Regulation:** The Maxim **MAX17503** synchronous step-down regulator converts $V_{\text{BUS}}$ down to $5.0\,\text{V}$ at high efficiency with a $500\,\text{kHz}$ forced PWM switching frequency. A downstream STMicroelectronics **LDL1117S33R** linear regulator provides an ultra-low-noise $3.3\,\text{V}$ rail for digital logic, precision ADC analog domains, and communication line pull-ups.
3. **Current & Voltage Sensing (IV-SNS):** Both $5\,\text{V}$ and $3.3\,\text{V}$ rails pass through dedicated Texas Instruments **INA293B3QDBVRQ1** current-sense amplifiers across $10\,\text{m}\Omega$ 4-terminal Kelvin shunt resistors (`R5`, `R18`). Tuned for a transfer characteristic of $1\,\text{V}/\text{A}$ and filtered by $160\,\text{Hz}$ anti-aliasing RC networks, the signals are digitized alongside resistor-divided bus voltages ($1/2\,\text{V}/\text{V}$) by a 24-bit delta-sigma ADC.
4. **Mezzanine Compute Gateway:** A 168-pin **Hirose FX10A-168S-SV** board-to-board connector couples the carrier directly to the ACU flight computer card, carrying the digitized telemetry, Ethernet MDI lines, and over 100 high-speed GPIO and protocol buses.
5. **Logic Analyzer & Protocol Breakout:** Ten dual-row headers (`J1` through `J10`) route 118 GPIO lines, 5 independent SPI buses, 2 I2C buses (with on-board $4.7\,\text{k}\Omega$ pull-ups), 3 UARTs, and RS-232 flow-control signals directly to probe pins for hardware-in-the-loop (HIL) logic analyzer validation.

---

## 2. Schematic Description & Circuit Architecture

The schematic was developed in **Altium Designer** utilizing an 8-sheet hierarchical design methodology (`ACU IO Board.PrjPcb`, Revision 1.0) to ensure modular verification, clean impedance boundaries, and signal isolation.

- **Sheet 1:** `Cover Page.SchDoc` — Project metadata, revision tracking, and global sheet index
- **Sheet 2:** `Top Level.SchDoc` — Top-level hierarchical block diagram and bus interconnects
- **Sheet 3:** `Input Connectors.SchDoc` — D-Sub 9-pin power entry and Hirose FX10A 168-pin mezzanine connector
- **Sheet 4:** `5V Power.SchDoc` — MAX17503 60V synchronous buck regulator and 5V IV sensing stage
- **Sheet 5:** `3.3V Power.SchDoc` — LDL1117S33R low-noise LDO and 3.3V IV sensing stage
- **Sheet 6:** `Ethernet.SchDoc` — ARJM11 Magjack with integrated magnetics and TPD4EUSB30 ESD clamp
- **Sheet 7:** `ADC.SchDoc` — TI ADS124S06 24-bit delta-sigma ADC and series-damped SPI5 interface
- **Sheet 8:** `PinHeader.SchDoc` — J1–J10 logic analyzer breakouts and I2C pull-up networks

---

### Sheet 2: Top-Level System Hierarchy (`Top Level.SchDoc`)

Sheet 2 defines the hierarchical bus wiring, multi-channel power distribution nets (`VBUS`, `P5V0`, `P3V3`, `GND`), differential telemetry buses (`IVSNS - 5V`, `IVSNS - 3.3V`), and peripheral inter-sheet links between the power converters, the mezzanine interface, and the output headers.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-12 text-center">
    <img src="{{ '/assets/img/acu_io_board_schematic_page_2.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Sheet 2: Top Level Schematic">
    <div class="caption">
      Sheet 2: Top-Level hierarchical block diagram interconnecting power, sensing, compute, Ethernet, and protocol breakout sheets.
    </div>
  </div>
</div>

---

### Sheet 3: Input Connectors & High-Density Interconnect (`Input Connectors.SchDoc`)

- **High-Voltage Power Input Connector (`J11`):**
  - Implements a rugged 9-pin D-Sub connector (**ASSMANN A-DS-09-A/KG-T2S**).
  - Pins 1 and 2 are ganged together to carry the positive power bus (`VBUS`), while Pins 3, 4, 8, and 9 provide low-impedance ground returns.
  - Connector shell chassis grounding is decoupled to electrical ground via a high-voltage $1\,\text{kV}$, $4.7\,\text{nF}$ ceramic capacitor (`C1`) in parallel with a $1\,\text{M}\Omega$ bleed resistor (`R1`) to drain electrostatic charge while blocking low-frequency ground loops.
- **Overvoltage & Inrush Surge Protection:**
  - Fast-acting surface mount 4A fuse (`F1`, **Bel Fuse C1Q4**).
  - Unidirectional transient voltage suppressor diode (`D1`, **SMAJ51A**) rated for $400\,\text{W}$ peak pulse power to clamp inductive surges on long ground support harnesses.
  - Dual high-voltage bulk storage capacitors (`C2`, `C3`: $80\,\text{V}$, $47\,\mu\text{F}$) absorb inductive transient energy and stabilize the input bus during instantaneous current steps.
- **Mezzanine Flight Computer Connector (`J1A` / `J1B`):**
  - High-density 168-pin surface-mount connector (**Hirose FX10A-168S-SV**) with $0.5\,\text{mm}$ pitch and integrated ground blades.
  - Houses 118 general-purpose digital I/O lines mapped across STM32 ports A through K, Ethernet Media Independent Interface differential pairs, and dedicated hardware buses (SPI1, SPI2, SPI4, SPI5, SPI6, I2C1, I2C2, UART4, UART5, UART7).

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-12 text-center">
    <img src="{{ '/assets/img/acu_io_board_schematic_page_3.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Sheet 3: Input Connectors Schematic">
    <div class="caption">
      Sheet 3: D-Sub 9-pin power entry stage, C1Q4 4A fuse, SMAJ51A TVS, 80V bulk filter bank, and Hirose FX10A 168-pin mezzanine connector.
    </div>
  </div>
</div>

---

### Sheet 4: 5V Step-Down Buck Converter & 5V IV Sensing (`5V Power.SchDoc`)

- **High-Voltage Synchronous Buck Converter (`U2`):**
  - Maxim Integrated **MAX17503** wide-input step-down converter with integrated high-side and low-side MOSFETs.
  - Input voltage operating range: $4.5\,\text{V}$ to $60\,\text{V}$, capable of delivering up to $5\,\text{A}$ continuous load current.
  - Configured for forced PWM operation at a switching frequency of $f_{\text{sw}} = 500\,\text{kHz}$ via `MODE` pin pull-down, maintaining predictable electromagnetic radiation characteristics without pulse-skipping subharmonic noise.
  - Soft-start timing capacitor $C_{14} = 22\,\text{nF}$ sets a controlled monotonic startup time of $t_{\text{ss}} = 3.96\,\text{ms}$ ($t_{\text{ss}} = \frac{C_{\text{ss}} \times 0.9\,\text{V}}{5\,\mu\text{A}}$), eliminating input bus voltage sag and inrush current trip events during ignition startup sequences.
  - Power inductor: $22\,\mu\text{H}$, $5.8\,\text{A}$ saturation current shielded inductor (`L1`).
  - Feedback network: Precision resistor divider consisting of $R_6 = 143\,\text{k}\Omega$ and $R_8 = 31.6\,\text{k}\Omega$ ($0.1\%$ tolerance) to regulate the output precisely to $5.0\,\text{V}$.
  - Output filtering: Triple $22\,\mu\text{F}$ $25\,\text{V}$ ceramic capacitors (`C10`, `C11`, `C12`) paired with an output clamp TVS diode (`D2`, **SMAJ6.5A**).
- **High-Precision 5V Current Sensing (5V ISENSE):**
  - Implements the Texas Instruments **INA293B3QDBVRQ1** automotive-grade, high-bandwidth ($1.3\,\text{MHz}$) current sense amplifier (`U1`).
  - Sense element: $10\,\text{m}\Omega$ 4-terminal Kelvin shunt resistor (`R5`, 4-terminal surface mount package).
  - Internal gain: $100\,\text{V}/\text{V}$, establishing a clean $1\,\text{V}/\text{A}$ transfer scaling:
    $$\text{Gain} = 100\,\text{V}/\text{V} \times 0.010\,\Omega = 1.0\,\text{V}/\text{A}$$
  - Symmetrical input filter: $100\,\Omega$ series resistors (`R3`, `R4`) and $100\,\text{nF}$ capacitor (`C6`) forming a differential low-pass anti-aliasing filter tuned to $f_c \approx 160\,\text{Hz}$ to eliminate buck switching ripple from the current measurement.
- **5V Bus Voltage Sensing (5V VSENSE):**
  - Symmetrical $10\,\text{k}\Omega$ / $10\,\text{k}\Omega$ resistor divider (`R7`, `R9`) providing a $1/2\,\text{V}/\text{V}$ ratio, scaling the $5.0\,\text{V}$ rail down to $2.5\,\text{V}$ for the ADC input. Filtered with a $100\,\text{nF}$ capacitor (`C15`).
- **Visual Diagnostics:** Status LED `D3` driven through a $1.3\,\text{k}\Omega$ resistor (`R10`), setting a nominal $2\,\text{mA}$ forward current based on the $2.4\,\text{V}$ LED forward voltage:
  $$R_{\text{LED}} = \frac{5.0\,\text{V} - 2.4\,\text{V}}{2\,\text{mA}} = 1.3\,\text{k}\Omega$$

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-12 text-center">
    <img src="{{ '/assets/img/acu_io_board_schematic_page_4.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Sheet 4: 5V Power and Sensing Schematic">
    <div class="caption">
      Sheet 4: MAX17503 60V synchronous buck regulator, INA293B3Q 1 V/A current sense circuit, and 1/2 V/V voltage sensing divider.
    </div>
  </div>
</div>

---

### Sheet 5: 3.3V Low-Noise LDO & 3.3V IV Sensing (`3.3V Power.SchDoc`)

- **Linear Regulator Stage (`U4`):**
  - STMicroelectronics **LDL1117S33R** fixed $3.3\,\text{V}$ low-dropout linear regulator supplied directly from the regulated $5.0\,\text{V}$ buck rail.
  - Provides a clean, ripple-free power supply for sensitive analog reference rails and high-speed CMOS logic.
  - Decoupled with a $1\,\mu\text{F}$ input capacitor (`C20`) and a $4.7\,\mu\text{F}$ low-ESR ceramic output capacitor (`C21`).
  - Output clamped by a **SMAJ5.0A** TVS diode (`D5`) to guard against reverse induction or overvoltage transients.
- **High-Precision 3.3V Current Sensing (3.3V ISENSE):**
  - Texas Instruments **INA293B3QDBVRQ1** current sense amplifier (`U3`) monitoring current draw across a dedicated $10\,\text{m}\Omega$ Kelvin shunt (`R18`).
  - Configured identically to the 5V rail for a unified telemetry gain of $1\,\text{V}/\text{A}$ and filtered by a $160\,\text{Hz}$ RC network (`R16`, `R17`, `C19`).
- **3.3V Bus Voltage Sensing (3.3V VSENSE):**
  - Precision $10\,\text{k}\Omega$ / $10\,\text{k}\Omega$ divider (`R19`, `R20`) providing a $1/2\,\text{V}/\text{V}$ ratio, mapping $3.3\,\text{V}$ to $1.65\,\text{V}$ with bypass capacitor `C22`.
- **Visual Diagnostics:** Status LED `D6` powered through a $450\,\Omega$ resistor (`R21`):
  $$R_{\text{LED}} = \frac{3.3\,\text{V} - 2.4\,\text{V}}{2\,\text{mA}} = 450\,\Omega$$

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-12 text-center">
    <img src="{{ '/assets/img/acu_io_board_schematic_page_5.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Sheet 5: 3.3V Power and Sensing Schematic">
    <div class="caption">
      Sheet 5: LDL1117S33R linear regulator, INA293B3Q 3.3V current sensing stage, and 1/2 V/V voltage sensing divider.
    </div>
  </div>
</div>

---

### Sheet 6: Ethernet Magjack & Transient Protection (`Ethernet.SchDoc`)

- **Integrated Magnetics Magjack (`J13`):**
  - Abracon / Amphenol **ARJM11D7-009-AB-EW2** 10/100/1000 Base-T RJ45 modular jack with integrated 1:1 isolation transformers and common-mode chokes.
  - Differential transmit and receive pairs (`MDI0_P`/`N`, `MDI1_P`/`N`) route directly to the Hirose mezzanine connector.
  - Connector indicator LEDs are intentionally left floating on the carrier board, as the Ethernet PHY and LED driver logic reside on the central ACU compute module.
- **High-Speed ESD Protection Array (`D4`):**
  - Texas Instruments **TPD4EUSB30** 4-channel ultra-low capacitance transient voltage suppressor array.
  - Ultra-low line capacitance of $0.8\,\text{pF}$ preserves edge rates and prevents inter-symbol interference (ISI) on high-speed Ethernet differential pairs while providing $\pm 15\,\text{kV}$ IEC 61000-4-2 air-gap ESD protection.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-12 text-center">
    <img src="{{ '/assets/img/acu_io_board_schematic_page_6.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Sheet 6: Ethernet Magjack Schematic">
    <div class="caption">
      Sheet 6: ARJM11 Magjack with integrated isolation magnetics and TPD4EUSB30 ultra-low capacitance ESD clamp.
    </div>
  </div>
</div>

---

### Sheet 7: High-Resolution 24-Bit ADC Subsystem (`ADC.SchDoc`)

- **24-Bit Delta-Sigma ADC (`U5`):**
  - Texas Instruments **ADS124S06IPBS** high-precision 24-bit delta-sigma converter with programmable gain amplifier (PGA), internal voltage reference, and multi-channel input multiplexer.
  - Channel Mapping:
    - **AIN2:** 3.3V Bus Current Telemetry (`ISNS - 3.3V`)
    - **AIN3:** 3.3V Bus Voltage Telemetry (`VSNS - 3.3V`)
    - **AIN4:** 5V Bus Current Telemetry (`ISNS - 5V`)
    - **AIN5:** 5V Bus Voltage Telemetry (`VSNS - 5V`)
- **Hardware Pin Strapping & Design Rationale:**
  - `RESET` is tied high to $3.3\,\text{V}$, and `START`/`SYNC` is tied low because sample initiation and conversion timing are governed deterministically via the dedicated SPI chip-select line (`SPI5-CS#`).
  - `CLK` is tied to ground, configuring the ADS124S06 to utilize its internal low-drift clock oscillator, eliminating the need to route noisy external quartz crystal traces across the board.
- **Series-Damped SPI Bus (`SPI5`):**
  - $47\,\Omega$ series termination damping resistors (`R22`, `R23`, `R24`, `R25`) are placed in series with `SPI5-CS#`, `SPI5-MOSI`, `SPI5-SCLK`, and `SPI5-MISO`.
  - Together with the parasitic capacitance of the long board traces and mezzanine mating contacts, these form a low-pass RC filter that dampens high-frequency transmission line reflections, overshoot, and crosstalk.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-12 text-center">
    <img src="{{ '/assets/img/acu_io_board_schematic_page_7.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Sheet 7: ADC Schematic">
    <div class="caption">
      Sheet 7: TI ADS124S06 24-bit ADC, multi-channel power telemetry inputs, and 47Ω series-damped SPI5 bus.
    </div>
  </div>
</div>

---

### Sheet 8: Pin Headers & Embedded Protocol Breakout (`PinHeader.SchDoc`)

- **Comprehensive Logic Analyzer Interface (`J1` through `J10`):**
  - Ten dual-row $2\times 7$ pin headers (`PH2-14-UA`) arranged along the left and right perimeters of the board.
  - Engineered specifically for rapid diagnostic capture with digital logic analyzers and oscilloscopes during test stand integration.
  - Breaks out **118 GPIO lines** grouped across GPIO banks A through K.
- **Embedded Serial Protocols Bank:**
  - **SPI:** Five independent SPI buses brought to test pins (SPI1, SPI2, SPI4, SPI5, SPI6).
  - **I2C:** Two high-speed I2C buses (I2C1, I2C2) equipped with dedicated on-board $4.7\,\text{k}\Omega$ pull-up resistor networks (`R11`, `R12`, `R13`, `R14`) referenced to $3.3\,\text{V}$.
  - **UART / RS-232:** UART5, UART7, and UART4 with dedicated hardware flow-control lines (`UART4-TX`, `UART4-RX`, `UART4-RTS`, `UART4-CTS`) routed to an external RS-232 transceiver stage.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-12 text-center">
    <img src="{{ '/assets/img/acu_io_board_schematic_page_8.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Sheet 8: Pin Headers Schematic">
    <div class="caption">
      Sheet 8: J1–J10 dual-row test headers, 118 GPIO breakouts, 5 SPI buses, 2 I2C buses with 4.7kΩ pull-ups, and UART/RS-232 lines.
    </div>
  </div>
</div>

---

### Embedded Schematic PDF Viewer

Inspect the full vector schematic with all component values, net labels, and pin connections directly below:

<div class="mb-3 text-right">
  <a href="{{ '/assets/pdf/ACU_IO_Board_Schematic.pdf' | relative_url }}" target="_blank" rel="noopener noreferrer" class="btn btn-sm btn-outline-primary">
    <i class="fa-solid fa-up-right-from-square"></i> Open Schematic PDF in Full Window
  </a>
  <a href="{{ '/assets/pdf/ACU_IO_Board_Schematic.pdf' | relative_url }}" download class="btn btn-sm btn-primary">
    <i class="fa-solid fa-download"></i> Download Schematic PDF
  </a>
</div>

<div class="card p-1 shadow-sm mb-4" style="width: 100%; height: 750px; border: 1px solid #ccc; border-radius: 6px; overflow: hidden;">
  <object data="{{ '/assets/pdf/ACU_IO_Board_Schematic.pdf' | relative_url }}" type="application/pdf" width="100%" height="100%" style="border: none;">
    <iframe src="{{ '/assets/pdf/ACU_IO_Board_Schematic.pdf' | relative_url }}" width="100%" height="100%" style="border: none;">
      <p>Your browser does not support embedded PDFs. Please <a href="{{ '/assets/pdf/ACU_IO_Board_Schematic.pdf' | relative_url }}" target="_blank">click here to download the schematic PDF</a>.</p>
    </iframe>
  </object>
</div>

---

## 3. Requirements of the PCB

Operating in rocket ground test stands and flight avionics bays requires stringent engineering tolerances to withstand extreme vibration, severe inductive switching transients from high-current valves, and high-density digital routing.

| Requirement Category              | Engineering Specification                                                                                        | Implementation & Circuit Strategy                                                                                                                                            |
| :-------------------------------- | :--------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Input Voltage Range**           | $24\,\text{V}$–$48\,\text{V}$ nominal DC bus, transient tolerance up to $60\,\text{V}$                           | Input TVS clamp (`SMAJ51A`), fast-acting 4A fuse (`C1Q4`), and dual $80\,\text{V}$ $47\,\mu\text{F}$ bulk ceramic/electrolytic capacitors.                                   |
| **Step-Down Power Conversion**    | High-efficiency step-down to $5.0\,\text{V}$ @ up to $5\,\text{A}$ continuous                                    | Maxim **MAX17503** synchronous buck converter operating at $500\,\text{kHz}$ forced PWM with a $22\,\mu\text{H}$ $5.8\,\text{A}$ shielded inductor.                          |
| **Low-Noise Logic Power**         | Ultra-clean $3.3\,\text{V}$ supply for ADC analog domains and high-speed digital buses                           | STMicroelectronics **LDL1117S33R** low-dropout linear regulator with high power-supply rejection ratio (PSRR) and TVS clamping (`SMAJ5.0A`).                                 |
| **Inrush Current Suppression**    | Controlled power ramp-up to eliminate test stand voltage collapse                                                | $3.96\,\text{ms}$ soft-start profile configured via $22\,\text{nF}$ capacitor on MAX17503 `SS` pin.                                                                          |
| **Bidirectional Current Sense**   | High-side current monitoring on both $5\,\text{V}$ and $3.3\,\text{V}$ rails with $1\,\text{V}/\text{A}$ scaling | Dual Texas Instruments **INA293B3QDBVRQ1** amplifiers across 4-terminal $10\,\text{m}\Omega$ Kelvin shunts with $160\,\text{Hz}$ anti-aliasing RC low-pass filters.          |
| **Voltage Telemetry Scaling**     | Rail monitoring compatible with $0\,\text{V}$–$3.3\,\text{V}$ ADC input spans                                    | Precision $10\,\text{k}\Omega$ / $10\,\text{k}\Omega$ ($1/2\,\text{V}/\text{V}$) resistor dividers with ceramic noise filtering capacitors.                                  |
| **Analog Digitization Precision** | High-resolution, multi-channel synchronous telemetry acquisition                                                 | Texas Instruments **ADS124S06IPBS** 24-bit delta-sigma ADC with internal low-jitter oscillator and programmable gain amplifier.                                              |
| **High-Density Mezzanine Link**   | Low-loss, high-bandwidth card-to-carrier interface with high pin count                                           | Hirose **FX10A-168S-SV** 168-pin $0.5\,\text{mm}$ pitch connector featuring integrated ground blades and mechanical alignment bosses.                                        |
| **Ethernet Physical Layer**       | Ruggedized 10/100/1000Base-T physical link with ESD immunity                                                     | Abracon **ARJM11D7-009-AB-EW2** Magjack with integrated isolation magnetics paired with TI **TPD4EUSB30** ultra-low capacitance ($0.8\,\text{pF}$) ESD protection array.     |
| **Test Stand Observability**      | Comprehensive signal probing for hardware-in-the-loop (HIL) automated test fixtures                              | 10 perimeter headers (`J1`–`J10`) routing 118 GPIO lines, 5 SPI buses, 2 I2C buses (with on-board $4.7\,\text{k}\Omega$ pull-ups), 3 UARTs, and RS-232 flow control signals. |
| **Signal Integrity**              | Suppression of reflections, ringing, and crosstalk across the carrier-to-mezzanine interface                     | $47\,\Omega$ series source damping resistors on `SPI5` lines; length-matched $100\,\Omega$ differential routing for Ethernet; solid, unbroken reference ground planes.       |

---

## 4. Picture of Layout & Physical Implementation

The physical layout was designed in **Altium Designer** with a rigorous functional zoning strategy that physically isolates high-voltage switching converters from sensitive analog instrumentation and high-speed digital buses.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-10 text-center">
    <img src="{{ '/assets/img/acu_io_board_pcb.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="ACU IO Board Top-Down PCB Layout">
    <div class="caption">
      Top-Down 3D PCB Layout Render of the Avionics Compute Unit (ACU) IO Board with mated ACU mezzanine flight computer showing functional zone partitioning, connector placement, and the central mezzanine mating interface.
    </div>
  </div>
</div>

### Layout Architecture & Floorplan Breakdown:

1. **Power Input & Conversion Zone (Top Edge):**
   - The ASSMANN 9-pin D-Sub power connector (`J11`), `C1Q4` fuse, `SMAJ51A` TVS diode, and dual $80\,\text{V}$ bulk capacitors are positioned along the top edge to constrain high-voltage circulating currents to the board perimeter.
   - The MAX17503 buck converter (`U2`), power inductor (`L1`), and output ceramic capacitors form an ultra-compact switching loop with broad copper pours to minimize parasitic trace inductance and radiated EMI.
   - The LDL1117S33R linear regulator is placed immediately adjacent to the 5V buck output, with thermal vias linking its exposed pad to inner ground and thermal spreader planes.

2. **Precision Telemetry & ADC Island (Upper Center & Right):**
   - The 4-terminal Kelvin current sense resistors (`R5`, `R18`) and INA293 amplifiers are routed using dedicated differential Kelvin sense pairs directly from the inner shunt pads, eliminating copper trace resistance errors.
   - The ADS124S06 24-bit ADC (`U5`) sits on a quiet analog copper region, isolated from digital switching noise. Decoupling capacitors are placed within millimeters of the device power pins.

3. **Central Mezzanine Stacking Interface:**
   - The Hirose FX10A-168S-SV connector is centrally located to allow the ACU mezzanine flight computer to stack securely above the carrier.
   - Fine-pitch ($0.5\,\text{mm}$) fanouts utilize micro-vias and symmetrical escape channels to maintain signal integrity across all 168 pins.

4. **Ethernet Magnetics & Differential Routing (Bottom Edge):**
   - The ARJM11 Magjack (`J13`) is situated on the bottom edge for easy panel accessibility.
   - Transmit and receive pairs are routed with tightly controlled $100\,\Omega$ differential impedance, matched trace lengths, and zero stubs through the TPD4EUSB30 ESD protection array.

5. **Dual-Flank Logic Analyzer Breakout Headers (Left & Right Flanks):**
   - Headers `J1` through `J10` flank the left and right outer board boundaries.
   - Silk-screen pinout legends are printed adjacent to every pin pair to allow instant probe attachment with logic analyzers and oscilloscopes during benchtop testing.

6. **4-Layer Board Stackup & Grounding:**
   - **Layer 1 (Top Signal & Components):** High-speed differential pairs, analog sense traces, and component pads.
   - **Layer 2 (Ground Plane):** Continuous, unbroken solid ground plane providing low-impedance return current paths for all high-speed signals.
   - **Layer 3 (Power Plane):** Partitioned power polygons distributing $V_{\text{BUS}}$, $5.0\,\text{V}$, and $3.3\,\text{V}$ rails.
   - **Layer 4 (Bottom Signal & Thermal Plane):** Auxiliary routing, ground flood, and extensive thermal via stitching underneath the buck converter and linear regulator.
