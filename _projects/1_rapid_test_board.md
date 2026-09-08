---
layout: page
title: Rapid Test Board
description: 4-layer mixed-signal engine test avionics board designed for high-precision 4-wire RTD temperature sensing, low-noise power delivery, and real-time telemetry.
img: assets/img/rapid_test_board_pcb.png
importance: 1
category: work
---

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0 text-center">
    <img src="{{ '/assets/img/rapid_test_board_pcb.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Rapid Test Board Top-Down PCB Layout">
    <div class="caption">
      Top-Down 3D View and PCB Layout of the Rapid Test Board (RTB) designed in Altium Designer for the Yellow Jacket Space Program (YJSP).
    </div>
  </div>
</div>

## 1. PCB Requirements & Design Specifications

The **Rapid Engine Test Board (RTB)** was engineered for the **Yellow Jacket Space Program (YJSP)** at Georgia Tech to serve as a high-reliability instrumentation node on rocket engine hot-fire test stands. Test stand environments present extreme electromagnetic interference (EMI), high-amplitude inductive flyback from solenoid valves, and ground potential shifts.

To ensure mission success, the board was developed against strict electrical, sensing, and environmental requirements:

| Parameter              | Requirement                                      | Implementation                                                                                     |
| ---------------------- | ------------------------------------------------ | -------------------------------------------------------------------------------------------------- |
| **Input Voltage**      | 24V DC nominal test stand bus                    | Tolerant up to 60V transients; protected with SMAJ26A TVS and PDS3100 reverse protection           |
| **Sensing Accuracy**   | $\pm 0.8^\circ\text{C}$ across operating range   | 4-wire Kelvin RTD interface eliminating lead wire resistance errors                                |
| **Excitation Method**  | No external precision voltage reference drift    | Dual on-chip matched $250\,\mu\text{A}$ / $500\,\mu\text{A}$ IDAC current sources inside ADS114S06 |
| **Noise Attenuation**  | $>9\text{ dB}$ switching noise suppression       | Balanced differential and common-mode RC filter tuned to $f_c = 15.9\text{ kHz}$                   |
| **Power Output Rails** | Regulated 5V and ultra-quiet 3.3V                | TI TPS54560B-Q1 buck regulator (up to 5A) + TI TPS7A2033 ultra-low-noise LDO                       |
| **Compute Core**       | High-speed processing for polynomial calibration | STM32H573RIT6 ARM Cortex-M33 running at 250 MHz with floating-point acceleration                   |
| **Signal Integrity**   | Zero packet loss and clean digital edges         | $47\,\Omega$ series damping resistors on all SPI lines; unbroken ground return plane               |
| **Form Factor**        | Compact, test-stand mountable                    | 4-layer FR-4 board with 4 M3 corner mounting holes and keyed Molex connectors                      |

---

## 2. Top-Down Layout & Component Floorplan

The physical placement of components on the board was partitioned into distinct functional functional zones to isolate high-energy switching loops from sensitive microvolt-level analog sensor signals:

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-10 text-center">
    <img src="{{ '/assets/img/rapid_test_board_pcb.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="PCB Floorplan Breakdown">
    <div class="caption">
      Top-down component floorplan: Power conditioning (top), Analog Front-End (bottom-left), MCU compute (center-right), and JTAG/SWD (bottom-right).
    </div>
  </div>
</div>

### Floorplan Architecture & Routing Strategy:

1. **Power Stage (Top & Top-Left):**
   - **`J2` (Molex Input):** Power enters through a locking 4-pin Molex connector, immediately passing through the fast-acting fuse (`F1`), TVS clamp (`D2`), and reverse-polarity Schottky diode (`D1`).
   - **`U4` (TPS54560B Buck) & `L1` (10 $\mu$H Inductor):** The high-frequency switching loop (VIN capacitor $\to$ high-side FET $\to$ catch diode `D4` $\to$ ground) is kept tightly localized with short, wide copper pours to prevent radiated EMI from coupling into the rest of the board.
   - **`U3` (TPS7A2033 LDO):** Positioned adjacent to the 5V buck output to generate the ultra-low-noise 3.3V analog/digital rail.
2. **Analog Front-End (Bottom-Left):**
   - **`J3` (Molex RTD Sensor Connector):** Dedicated 4-pin connector routing Kelvin excitation and sense leads directly through symmetrical RC filtering network (`R18`-`R22`, `C31`-`C36`).
   - **`U2` (ADS114S06 16-Bit ADC):** Placed directly adjacent to the input filter to minimize analog trace length before digitization.
3. **Digital Processing (Center-Right):**
   - **`U1` (STM32H573 MCU):** Centrally located with decoupling capacitors (`C1`-`C8`) placed on every power pin with direct via-to-ground connections.
   - **Damped SPI Bus:** Traces connecting `U2` to `U1` run over an unbroken Layer 2 ground plane with $47\,\Omega$ series resistors (`R1`, `R2`, `R3`, `R9`, `R10`, `R11`) dampening transmission line ringing.
4. **Debug & Programming (Bottom-Right):**
   - **`J1` (Samtec FTSH-107 Header):** 14-pin micro pitch connector providing standard ARM SWD, SWO trace, and virtual COM port UART access.

---

## 3. Schematic Description & Circuit Architecture

The schematic was designed in **Altium Designer** and structured across two hierarchical sheets:

### Sheet 1: Power Distribution & RTD Sensor Interface (`PowerDistr.SchDoc`)

- **Input Filtering & Protection:** Protects against inductive test stand transients with a high-speed TVS diode (`SMAJ26A`), Eaton 1.5A fuse (`3216FF1.5`), and $1\,\text{M}\Omega$ bleeder resistor with a $1\,\text{kV}$ ceramic capacitor to chassis ground.
- **24V to 5V Step-Down Buck:** Implements the **TI TPS54560B-Q1** with an integrated high-side MOSFET, external bootstrap capacitor (`C21`), and a Type-II compensation network (`R15`, `C29`, `C30`) tuned for stable transient response under dynamic load steps.
- **5V to 3.3V Analog LDO:** The **TI TPS7A2033** linear regulator provides an ultra-low output noise of $6.5\,\mu\text{V}_{\text{RMS}}$ and high PSRR to isolate sensitive ADC reference voltages from switching ripple.
- **4-Wire RTD AFE Network:** Uses balanced series resistors and differential/common-mode capacitors ($C_{\text{diff}} = 100\,\text{nF}$, $C_{\text{cm}} = 10\,\text{nF}$) with a $2.5\,\text{k}\Omega$ reference resistor (`R21`) for ratiometric measurement.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-12 text-center">
    <img src="{{ '/assets/img/rapid_test_board_schematic_page_1.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Sheet 1: Power Distribution and RTD Interface">
    <div class="caption">
      Sheet 1: Power conditioning, buck regulation, analog LDO, and 4-wire RTD differential filtering network.
    </div>
  </div>
</div>

### Sheet 2: Microcontroller, 16-Bit ADC, & JTAG (`JTAG.SchDoc`)

- **Analog-to-Digital Converter:** The **TI ADS114S06IPBS** integrates a low-noise programmable gain amplifier (PGA), internal voltage reference, and dual excitation IDACs. It outputs digitized samples over SPI with a dedicated data-ready interrupt (`DRDY`).
- **High-Performance MCU:** The **STM32H573RIT6** handles real-time sensor polling, floating-point Callendar-Van Dusen polynomial conversion, and telemetry communication. Decoupling capacitors ($100\,\text{nF}$ and $2.2\,\mu\text{F}$ VCAP) ensure stable high-speed switching.
- **Debug Port:** Samtec FTSH-107 header with $10\,\text{k}\Omega$ pull-up/pull-down resistors on SWDIO, SWCLK, JTDI, and NRST lines.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-12 text-center">
    <img src="{{ '/assets/img/rapid_test_board_schematic_page_2.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Sheet 2: STM32 MCU, ADC, and JTAG">
    <div class="caption">
      Sheet 2: STM32H573 MCU, ADS114S06 16-bit Delta-Sigma ADC, and Samtec FTSH-107 JTAG/SWD interface.
    </div>
  </div>
</div>

---

## 4. Embedded Schematic PDF Viewer

You can inspect the complete, interactive vector schematic with all component values, net labels, and pinouts directly below, or open the PDF in a new tab:

<div class="mb-3 text-right">
  <a href="{{ '/assets/pdf/Rapid_Test_Board_Schematic.pdf' | relative_url }}" target="_blank" rel="noopener noreferrer" class="btn btn-sm btn-outline-primary">
    <i class="fa-solid fa-up-right-from-square"></i> Open Schematic PDF in Full Window
  </a>
  <a href="{{ '/assets/pdf/Rapid_Test_Board_Schematic.pdf' | relative_url }}" download class="btn btn-sm btn-primary">
    <i class="fa-solid fa-download"></i> Download Schematic PDF
  </a>
</div>

<div class="card p-1 shadow-sm" style="width: 100%; height: 750px; border: 1px solid #ccc; border-radius: 6px; overflow: hidden;">
  <object data="{{ '/assets/pdf/Rapid_Test_Board_Schematic.pdf' | relative_url }}" type="application/pdf" width="100%" height="100%" style="border: none;">
    <iframe src="{{ '/assets/pdf/Rapid_Test_Board_Schematic.pdf' | relative_url }}" width="100%" height="100%" style="border: none;">
      <p>Your browser does not support embedded PDFs. Please <a href="{{ '/assets/pdf/Rapid_Test_Board_Schematic.pdf' | relative_url }}" target="_blank">click here to download the schematic PDF</a>.</p>
    </iframe>
  </object>
</div>
