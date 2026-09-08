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
    <img src="{{ '/assets/img/rapid_test_board_pcb.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Rapid Test Board 3D PCB Render" style="max-height: 480px;">
    <div class="caption">
      3D Render of the 4-layer Rapid Test Board (RTB) designed in Altium Designer for the Yellow Jacket Space Program (YJSP).
    </div>
  </div>
</div>

## Overview

The **Rapid Test Board (RTB)** is a custom 4-layer mixed-signal printed circuit board engineered for the **Yellow Jacket Space Program (YJSP)** at Georgia Tech. Rocket engine hot-fire test stands operate in electrically hostile environments characterized by high EMI, inductive switching spikes from solenoid valves, and ground bounce.

The RTB serves as a dedicated sensor instrumentation node, acquiring critical temperature telemetry from a Resistive Temperature Detection (RTD) sensor with laboratory-grade precision while maintaining total signal integrity and transient immunity.

<div class="card mt-3 mb-4 p-3 bg-light border">
  <div class="row">
    <div class="col-md-6">
      <strong>Role:</strong> Responsible Engineer, Schematic & PCB Designer<br>
      <strong>Organization:</strong> Yellow Jacket Space Program (Georgia Tech)<br>
      <strong>CAD Tool:</strong> Altium Designer
    </div>
    <div class="col-md-6">
      <strong>Architecture:</strong> STM32H573 (Cortex-M33) + TI ADS114S06 16-bit ADC<br>
      <strong>Stackup:</strong> 4-Layer FR-4 (Signal - Ground - Power - Signal)<br>
      <strong>Full Schematic:</strong> <a href="{{ '/assets/pdf/Rapid_Test_Board_Schematic.pdf' | relative_url }}" target="_blank"><i class="fa-solid fa-file-pdf"></i> Download Schematic PDF</a>
    </div>
  </div>
</div>

---

## Analog Front End (AFE) & RTD Sensing

Accurate cryogenic and engine temperature monitoring is paramount during hot-fire tests. A 4-wire Kelvin sensing configuration was chosen to eliminate lead wire resistance errors, maintaining measurement uncertainty to within **$\pm 0.8^\circ\text{C}$**.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-12 text-center">
    <img src="{{ '/assets/img/rapid_test_board_schematic_page_1.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Power Distribution and RTD Interface Schematic">
    <div class="caption">
      Sheet 1 Schematic: 24V Input Protection, TPS54560B Buck Regulator, TPS7A2033 LDO, and 4-Wire RTD Differential Filter.
    </div>
  </div>
</div>

### Key AFE Design Highlights

- **Delta-Sigma ADC with Integrated IDACs:** Utilizes the **Texas Instruments ADS114S06IPBS**, a 16-bit, 6-channel delta-sigma ADC with programmable gain amplifier (PGA) and integrated dual matched excitation current sources (IDAC). By driving the RTD sensor with on-chip matched IDACs, excitation error is minimized without external precision voltage references.
- **Symmetrical RC Anti-Aliasing Filter:** The differential sensing lines (`AIN0`, `AIN1`, `AIN2`) and reference lines (`REF0`, `REF1`) pass through a balanced R-C-R differential and common-mode filtering network ($R_{18}, R_{19}, C_{31}, C_{32}, C_{33}$ and $R_{20}, R_{21}, R_{22}, C_{34}, C_{35}, C_{36}$).
- **LTspice AC Analysis & Cutoff Tuning:** Tuned the filter cutoff frequency to a maximum of **15.9 kHz**, attenuating high-frequency PWM and switching noise by **$>9\text{ dB}$** peak-to-peak before reaching the ADC sampling stage.

---

## Power Distribution Network (PDN)

The board accepts raw 24V bus power from the test stand infrastructure and generates regulated **5V** and ultra-quiet **3.3V** rails.

<div class="row">
  <div class="col-md-6">
    <h4>Input Protection Stage</h4>
    <ul>
      <li><strong>TVS Clamping:</strong> High-energy TVS diode (SMAJ26A) clamps input surges, inductive flyback, and ESD transients.</li>
      <li><strong>Overcurrent Protection:</strong> Fast-acting surface-mount fuse (Eaton 3216FF1.5, 1.5A).</li>
      <li><strong>Reverse Polarity Protection:</strong> Low-forward-drop Schottky diode (PDS3100-13, 100V 3A).</li>
      <li><strong>Input Decoupling:</strong> Low-ESR ceramic capacitor bank (three $10\,\mu\text{F}$ 50V 1210 capacitors) to handle inrush currents.</li>
    </ul>
  </div>
  <div class="col-md-6">
    <h4>Voltage Regulation Stages</h4>
    <ul>
      <li><strong>Primary Buck Converter:</strong> <strong>TI TPS54560B-Q1</strong> step-down switching regulator converting 24V down to 5V at high efficiency with a $10\,\mu\text{H}$ 9.1A power inductor and frequency compensation.</li>
      <li><strong>Low-Noise Analog LDO:</strong> <strong>TI TPS7A2033</strong> low-dropout linear regulator converting 5V to an ultra-clean 3.3V rail with high PSRR for the microcontroller core and analog circuitry.</li>
      <li><strong>Rail Clamping:</strong> SMAJ5.0A TVS diode on the 3.3V output rail for secondary overvoltage protection.</li>
    </ul>
  </div>
</div>

---

## Microcontroller & Embedded Interface

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-12 text-center">
    <img src="{{ '/assets/img/rapid_test_board_schematic_page_2.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Microcontroller and Digital Interface Schematic">
    <div class="caption">
      Sheet 2 Schematic: STM32H573 Cortex-M33 MCU, ADS114S06 ADC SPI Interface, and Samtec FTSH-107 JTAG/SWD Debug Port.
    </div>
  </div>
</div>

### Digital Architecture Details

- **Host Processor:** **STM32H573RIT6** ARM Cortex-M33 running at up to 250 MHz with hardware floating-point acceleration for real-time polynomial temperature calculation (Callendar-Van Dusen equation).
- **SPI Interface with Series Damping:** The ADC communicates with the STM32 via high-speed SPI. All digital signal lines (`CS`, `START`, `MOSI`, `SCLK`, `MISO`, `DRDY`) include **$47\,\Omega$ series damping resistors** ($R_1, R_2, R_3, R_9, R_{10}, R_{11}$) placed close to driver pins to suppress transmission line ringing and impedance mismatch reflections.
- **Debug Port:** Standardized 14-pin micro header (**Samtec FTSH-107-01-F-DV-K-P-TR**) supporting SWD debugging, SWO trace output, and UART virtual COM port communication.

---

## PCB Layout & Signal Integrity

The 4-layer stackup was strategically routed to separate noisy switching paths from microvolt-level analog sensor signals:

1. **Layer Stackup:**
   - **Layer 1 (Top Signal):** Component placement, critical high-frequency SPI differential pairs, and sensor traces.
   - **Layer 2 (Ground Plane):** Unbroken reference ground plane beneath the entire board providing low-inductance return current paths.
   - **Layer 3 (Power Plane):** Partitioned power distribution polygons (24V, 5V, 3.3V) with decoupling caps placed directly at IC power pins.
   - **Layer 4 (Bottom Signal):** Auxiliary routing with ground fill and thermal vias connecting hot power pads to bottom copper heat spreaders.
2. **Noise Isolation:** The buck converter switching node (`SW`) and inductor $L_1$ were isolated with compact loops away from the sensitive ADC input pins and RTD connector. Ground stitching vias were placed along board perimeters and plane transitions to minimize EMI emissions.

---

## Documentation & Downloads

- **Schematic PDF:** <a href="{{ '/assets/pdf/Rapid_Test_Board_Schematic.pdf' | relative_url }}" target="_blank"><i class="fa-solid fa-file-pdf"></i> Download Complete Altium Schematic (2 Pages, PDF)</a>
- **Project Images:** High-resolution 3D board render and schematics available in [`assets/img/`](/assets/img/).
