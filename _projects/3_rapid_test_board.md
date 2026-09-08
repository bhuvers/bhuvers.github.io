---
layout: page
title: Rapid Test Board
description: 4-layer mixed-signal engine test avionics board designed for high-precision 4-wire RTD temperature sensing, low-noise power delivery, and real-time telemetry.
img: assets/img/rapid_test_board_pcb.png
importance: 3
category: work
---

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0 text-center">
    <img src="{{ '/assets/img/rapid_test_board_pcb.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Rapid Test Board Top-Down 3D Layout">
    <div class="caption">
      Top-Down 3D PCB View of the Rapid Engine Test Board (RTB) — Yellow Jacket Space Program (YJSP), Georgia Tech.
    </div>
  </div>
</div>

## 1. Top-Down System Architecture & Block Diagram

The **Rapid Engine Test Board (RTB)** is an embedded instrumentation node developed for the **Yellow Jacket Space Program (YJSP)** to measure real-time temperature telemetry during rocket engine hot-fire testing.

The top-down architecture is structured into three tightly coupled subsystems: the **Power Distribution Network (PDN)**, the **Analog Front End (AFE)**, and the **Digital Processing & Debug Core**.

- **Power Distribution Network (PDN):** 24V bus protection (`SMAJ26A`, fuse, diode), TPS54560B buck regulator (24V → 5V), and TPS7A2033 low-noise LDO (5V → 3.3V).
- **Analog Front End (AFE):** 4-wire RTD input, symmetrical RC anti-aliasing filter ($f_c = 15.9\,\text{kHz}$), and TI ADS114S06 16-bit delta-sigma ADC with matched IDAC current excitation.
- **Compute & Debug Core:** STM32H573 ARM Cortex-M33 processor (250 MHz), $47\,\Omega$ series-damped SPI bus, and Samtec FTSH-107 SWD/JTAG debug interface.

### Signal & Power Flow:

1. **Power Path:** 24V raw DC bus power enters via Molex connector `J2`, passes through overvoltage/overcurrent protection, and is stepped down to 5V via a high-efficiency buck converter before an ultra-low-noise LDO produces a quiet 3.3V rail.
2. **Sensor Signal Path:** The 4-wire RTD sensor connects to `J3`. Dual matched current sources (IDACs) from the ADS114S06 excite the platinum element ratiometrically, while Kelvin sense lines pass through a balanced anti-aliasing filter to the ADC.
3. **Data & Telemetry Path:** Digitized 16-bit samples are streamed over a series-damped SPI bus to the STM32H573 microcontroller, which performs floating-point Callendar-Van Dusen polynomial conversion and routes telemetry to the test stand DAQ system.

---

## 2. Schematic Description & Circuit Architecture

The complete schematic was designed in **Altium Designer** and organized into two hierarchical sheets:

### Sheet 1: Power Distribution & RTD Sensor Interface (`PowerDistr.SchDoc`)

- **Input Filtering & Transient Protection:**
  - `SMAJ26A` TVS diode clamps test stand inductive transients and electrostatic discharge.
  - `Eaton 3216FF1.5` fast-acting surface-mount fuse provides overcurrent protection.
  - `PDS3100-13` 100V 3A Schottky diode protects against reverse battery/polarity hookups.
  - High-voltage $1\,\text{kV}$ $4.7\,\text{nF}$ ceramic capacitor (`C20`) with $1\,\text{M}\Omega$ bleed resistor (`R13`) couples connector shield to chassis ground.
- **24V to 5V Step-Down Buck Converter:**
  - Implements the **TI TPS54560B-Q1** (60V, 5A peak step-down regulator).
  - Includes a $10\,\mu\text{H}$ 9.1A shielded power inductor (`L1`), low-ESR input capacitor bank (`C17`-`C19`), and frequency compensation network (`R15`, `C29`, `C30`).
- **5V to 3.3V Analog LDO:**
  - The **TI TPS7A2033** linear regulator provides an ultra-low output noise ($6.5\,\mu\text{V}_{\text{RMS}}$) and high PSRR to isolate sensitive ADC reference voltages from buck switching harmonics.
- **4-Wire RTD AFE Filter:**
  - Symmetrical differential ($C_{32}, C_{35} = 100\,\text{nF}$) and common-mode ($C_{31}, C_{33}, C_{34}, C_{36} = 10\,\text{nF}$) filtering network tuned with $1\,\text{k}\Omega$ resistors (`R18`-`R22`).
  - Precision $2.5\,\text{k}\Omega$ reference resistor (`R21`) establishes ratiometric measurement cancellation.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-12 text-center">
    <img src="{{ '/assets/img/rapid_test_board_schematic_page_1.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Sheet 1: Power Distribution and RTD Interface">
    <div class="caption">
      Sheet 1: Power conditioning, TPS54560B buck regulator, TPS7A2033 LDO, and 4-wire RTD differential filter.
    </div>
  </div>
</div>

### Sheet 2: Microcontroller, 16-Bit ADC, & JTAG (`JTAG.SchDoc`)

- **16-Bit Delta-Sigma ADC:**
  - **TI ADS114S06IPBS** featuring 6 differential analog inputs, programmable gain amplifier (PGA), and dual programmable IDAC current sources.
  - Dedicated hardware data-ready line (`DRDY`) triggers interrupt-driven sampling on the host MCU.
- **Microcontroller Core:**
  - **STM32H573RIT6** ARM Cortex-M33 running at up to 250 MHz with integrated hardware floating-point unit (FPU).
  - Dedicated decoupling capacitors (`C1`-`C8`) placed immediately adjacent to every power pin pair with dual $2.2\,\mu\text{F}$ VCAP capacitors (`C7`, `C8`).
- **Damped SPI Bus:**
  - $47\,\Omega$ series termination damping resistors (`R1`, `R2`, `R3`, `R9`, `R10`, `R11`) placed on `CS`, `START`, `MOSI`, `SCLK`, `MISO`, and `DRDY` to eliminate high-speed transmission line reflections and ringing.
- **JTAG / SWD Debug Header:**
  - **Samtec FTSH-107-01-F-DV-K-P-TR** 14-pin micro-pitch connector with pull-ups on SWDIO, SWCLK, JTDI, and reset lines.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-12 text-center">
    <img src="{{ '/assets/img/rapid_test_board_schematic_page_2.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Sheet 2: STM32 MCU, ADC, and JTAG">
    <div class="caption">
      Sheet 2: STM32H573 Cortex-M33 host processor, ADS114S06 16-bit ADC, and Samtec FTSH-107 debug interface.
    </div>
  </div>
</div>

### Embedded Schematic PDF Viewer

Inspect the complete vector schematic with all component values, net labels, and pinouts directly below:

<div class="mb-3 text-right">
  <a href="{{ '/assets/pdf/Rapid_Test_Board_Schematic.pdf' | relative_url }}" target="_blank" rel="noopener noreferrer" class="btn btn-sm btn-outline-primary">
    <i class="fa-solid fa-up-right-from-square"></i> Open Schematic PDF in Full Window
  </a>
  <a href="{{ '/assets/pdf/Rapid_Test_Board_Schematic.pdf' | relative_url }}" download class="btn btn-sm btn-primary">
    <i class="fa-solid fa-download"></i> Download Schematic PDF
  </a>
</div>

<div class="card p-1 shadow-sm mb-4" style="width: 100%; height: 750px; border: 1px solid #ccc; border-radius: 6px; overflow: hidden;">
  <object data="{{ '/assets/pdf/Rapid_Test_Board_Schematic.pdf' | relative_url }}" type="application/pdf" width="100%" height="100%" style="border: none;">
    <iframe src="{{ '/assets/pdf/Rapid_Test_Board_Schematic.pdf' | relative_url }}" width="100%" height="100%" style="border: none;">
      <p>Your browser does not support embedded PDFs. Please <a href="{{ '/assets/pdf/Rapid_Test_Board_Schematic.pdf' | relative_url }}" target="_blank">click here to download the schematic PDF</a>.</p>
    </iframe>
  </object>
</div>

---

## 3. Requirements of the PCB

Rocket engine test stands generate extreme vibration, inductive kickback from valve solenoids, and wide temperature swings. The RTB was designed to satisfy demanding engineering requirements across electrical, sensing, and mechanical domains:

| Requirement Category          | Specification                                                             | Implementation & Verification                                                                                                                          |
| ----------------------------- | ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Input Voltage Range**       | 24V DC nominal test stand bus (tolerance up to 60V transient spikes)      | TVS diode clamp (`SMAJ26A`), fast-acting fuse (`3216FF1.5`), and 100V reverse-polarity Schottky diode (`PDS3100`).                                     |
| **Sensing Precision**         | Measurement uncertainty within $\pm 0.8^\circ\text{C}$                    | 4-wire Kelvin sensing interface eliminating lead-wire resistance degradation.                                                                          |
| **Excitation Drift Immunity** | Zero drift from voltage reference fluctuations                            | On-chip dual matched IDACs ($250\,\mu\text{A}$ / $500\,\mu\text{A}$) providing true ratiometric sensing against precision reference resistor $R_{21}$. |
| **Noise Attenuation**         | $>9\text{ dB}$ attenuation of high-frequency solenoid/PWM switching noise | Balanced differential and common-mode RC anti-aliasing filter tuned to $f_c = 15.9\text{ kHz}$ via LTspice AC simulation.                              |
| **Power Conversion**          | High-efficiency multi-rail supply (24V $\to$ 5V $\to$ 3.3V)               | TI TPS54560B buck regulator ($10\,\mu\text{H}$ inductor) paired with TI TPS7A2033 ultra-low-noise analog LDO ($6.5\,\mu\text{V}_{\text{RMS}}$).        |
| **Microcontroller Compute**   | Real-time sensor polling and polynomial temperature conversion            | STM32H573 (ARM Cortex-M33 @ 250 MHz) with hardware floating-point acceleration.                                                                        |
| **Digital Signal Integrity**  | Suppression of reflections, ringing, and crosstalk on SPI lines           | $47\,\Omega$ series damping resistors on all digital lines; unbroken Layer 2 ground reference plane.                                                   |
| **Physical & Mechanical**     | Compact, test-stand mountable form factor                                 | 4-layer FR-4 board with 4 M3 corner mounting holes with gold-plated annular clearance and keyed locking Molex connectors.                              |

---

## 4. Picture of Layout & Physical Implementation

The physical layout of the Rapid Test Board was designed in Altium Designer to ensure optimal signal integrity, thermal dissipation, and noise isolation.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-10 text-center">
    <img src="{{ '/assets/img/rapid_test_board_pcb.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Rapid Test Board Top-Down PCB Layout">
    <div class="caption">
      Top-down 3D PCB layout render showing physical component placement, connector orientation, and functional zone isolation.
    </div>
  </div>
</div>

### Layout Architecture & Floorplan Breakdown:

1. **Functional Zoning & Separation:**
   - **Power Section (Top Edge):** Locking Molex power connector (`J2`), fuse (`F1`), TVS diode (`D2`), and reverse protection diode (`D1`) sit immediately at the top-left edge. The buck converter (`U4`) and inductor (`L1`) are placed with minimal loop area directly between input and output ceramic capacitors.
   - **Analog Front-End (Bottom-Left):** Molex RTD connector (`J3`) and symmetric passive filtering network (`R18`-`R22`, `C31`-`C36`) are clustered directly adjacent to the ADS114S06 ADC (`U2`), minimizing low-level analog trace lengths.
   - **Compute Core (Center-Right):** The STM32H573 MCU (`U1`) is centrally placed with dedicated local bypass capacitors on every power pin.
   - **JTAG / Programming (Bottom-Right):** Samtec FTSH-107 header (`J1`) is located along the bottom edge for easy test stand accessibility.

2. **4-Layer Board Stackup:**
   - **Layer 1 (Top Signal):** High-speed digital traces, analog sensor signals, and component pads.
   - **Layer 2 (Ground Plane):** Continuous, unbroken ground plane providing low-impedance return current paths for all high-frequency signals.
   - **Layer 3 (Power Plane):** Split power polygons distributing 24V, 5V, and 3.3V power rails.
   - **Layer 4 (Bottom Signal & Thermal):** Auxiliary routing with extensive copper pours and thermal via stitching beneath the TPS54560B PowerPAD and LDO to conduct heat through the board.

3. **Grounding & Shielding:**
   - Perimeter ground stitching vias connect top, inner, and bottom copper fills to suppress edge-radiated emissions.
   - Solid reference planes underneath all critical SPI traces ensure controlled characteristic impedance and prevent differential signal degradation.
