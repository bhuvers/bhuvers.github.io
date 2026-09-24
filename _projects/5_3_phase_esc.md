---
layout: page
title: 3-Phase Electronic Speed Controller (ESC)
description: High-performance 3-phase BLDC/PMSM motor speed controller featuring an STM32F405 MCU, IR2103 half-bridge gate drivers, SiR182DP power MOSFETs, INA293 current sense amplifiers, and native AM32 firmware support.
img: assets/img/3_phase_esc_gate_driver.png
importance: 5
category: work
---

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0 text-center">
    <img src="{{ '/assets/img/3_phase_esc_gate_driver.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="3-Phase ESC Gate Driver Schematic">
    <div class="caption">
      Schematic Sheet 4: Phase A Half-Bridge Inverter & Gate Driver Stage featuring the IR2103STRPBF driver, dual SiR182DP power MOSFETs, and TI INA293A2 current-sense amplifier.
    </div>
  </div>
</div>

> [!IMPORTANT]
> **Project Status: Schematic Complete — PCB Layout In Progress**  
> The complete 6-sheet hierarchical electrical schematic for this 3-Phase ESC has been finalized and verified in **Altium Designer**. The physical printed circuit board layout—including high-current polygon routing, parasitic switching loop minimization, thermal via arrays, and mixed-signal domain isolation—is currently **actively in progress**. Comprehensive 3D CAD renders, thermal analyses, and board photos will be added upon layout completion.

---

## 1. Top-Down System Architecture & Inverter Overview

The **3-Phase Electronic Speed Controller (ESC)** is a custom, high-power-density motor inverter designed to drive 3-phase Brushless DC (BLDC) and Permanent Magnet Synchronous Motors (PMSM). Engineered for robotics, unmanned aerial vehicles (UAVs), and high-dynamic-response propulsion systems, the hardware is tailored specifically for the open-source **AM32 32-bit ESC firmware** ecosystem.

The system converts raw DC battery power ($V_{\text{BUS}}$ up to 32V–36V nominal, 6S–8S LiPo) into high-frequency three-phase sinusoidal or trapezoidal pulse-width modulated (PWM) waveforms, offering closed-loop speed control, active freewheeling, and hardware-accelerated telemetry.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-10 text-center">
    <img src="{{ '/assets/img/3_phase_esc_top_level.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="3-Phase ESC Top-Level System Architecture">
    <div class="caption">
      Sheet 1: Top-Level Hierarchical Interconnect Diagram linking the Power Supply, STM32 MCU, and 3-Phase Inverter Half-Bridge Stages.
    </div>
  </div>
</div>

### Subsystem Breakdown:

- **Power Conversion & Protection:** Rugged DC input terminal with `SMAJ26A` transient voltage suppression, `PDS3100-13` 100V Schottky reverse-polarity protection, low-ESR ceramic filter bank, and a **Texas Instruments LMR33640** 40V, 4A synchronous step-down buck converter delivering a clean 3.3V logic rail.
- **Microcontroller Core:** **STM32F405RGT6** ARM Cortex-M4 processor (168 MHz with hardware floating-point unit), advanced 16-bit motor control timer peripherals with dead-time generation, Tag-Connect **TC2030-IDC** SWD debug header, and multi-channel ADC sampling.
- **3-Phase Half-Bridge Inverter:** Three identical half-bridge phases driven by **Infineon IR2103STRPBF** gate drivers, driving six high-performance **Vishay SiR182DP-T1-RE3** 100V N-channel TrenchFETs with ultra-low on-resistance ($R_{DS(\text{on})} \approx 6.4\,\text{m}\Omega$).
- **Telemetry & Sensing Front-End:** Independent low-side phase current sensing using **Texas Instruments INA293A2** high-bandwidth ($1.3\,\text{MHz}$) current sense amplifiers across $10\,\text{m}\Omega$ shunt resistors ($200\,\text{mV}/\text{A}$ transfer scaling), accompanied by phase back-EMF / voltage divider feedback networks ($1/5.7\,\text{V}/\text{V}$) for sensorless commutation and BEMF zero-crossing detection.

---

## 2. Schematic Description & Circuit Architecture

The electrical architecture is designed hierarchically in **Altium Designer** across six dedicated sheets:

- **Sheet 1 (`Top Level Diagram.SchDoc`):** Global top-level block diagram and inter-sheet bus interconnects.
- **Sheet 2 (`Power.SchDoc`):** Step-down buck regulator, input filtering, and transient suppression.
- **Sheet 3 (`MCU Design.SchDoc`):** STM32F405 microcontroller, bypass networks, and Tag-Connect SWD interface.
- **Sheet 4 (`Phase A.SchDoc`):** Phase A half-bridge gate driver, power MOSFETs, current sensing, and BEMF divider.
- **Sheet 5 (`Phase B.SchDoc`):** Phase B half-bridge stage (identical topology to Phase A).
- **Sheet 6 (`Phase C.SchDoc`):** Phase C half-bridge stage (identical topology to Phase A).

---

### Sheet 2: Power Regulation & Protection (`Power.SchDoc`)

The power architecture steps down the raw battery bus voltage ($V_{\text{BUS}}$) to an ultra-stable $3.3\,\text{V}$ rail (`P3V3`) required by the STM32 microcontroller, current sense amplifiers, and gate driver logic.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-10 text-center">
    <img src="{{ '/assets/img/3_phase_esc_power.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Power Supply Schematic">
    <div class="caption">
      Sheet 2: TI LMR33640 40V 4A synchronous buck converter, PDS3100 reverse protection diode, and SMAJ26A TVS clamp.
    </div>
  </div>
</div>

- **Input Transient & Polarity Protection:**
  - **Reverse Polarity Diode (`D1`, `PDS3100-13`):** 100V, 3A surface-mount Schottky barrier rectifier preventing reverse-connection damage.
  - **TVS Diode (`D2`, `SMAJ26A`):** Clamps high-voltage inductive switching spikes and ESD transients generated during hard motor braking or rapid current commutation.
  - **Input Bulk Capacitance (`C1`–`C3`, `C9`, `C10`):** Three parallel $10\,\mu\text{F}$ 50V 1210 ceramic capacitors ($30\,\mu\text{F}$ total) paired with $220\,\text{nF}$ 0805 high-frequency ceramic caps to minimize input impedance and absorb switching ripple.
- **Synchronous Buck Regulator (`U1`, `LMR33640DDDAR`):**
  - High-efficiency 40V, 4A step-down converter operating in an 8-pin SO-PowerPAD package.
  - Power inductor: $6.8\,\mu\text{H}$, 3A shielded inductor (`L1`).
  - High-side bootstrap capacitor: $100\,\text{nF}$ 25V 0603 ceramic capacitor (`C4`).
  - Output Filtering: Quad parallel $22\,\mu\text{F}$ 10V 0805 low-ESR ceramic capacitors (`C5`–`C8`, $88\,\mu\text{F}$ aggregate) providing an exceptionally clean, low-ripple $3.3\,\text{V}$ supply.

---

### Sheet 3: STM32 Microcontroller Core (`MCU Design.SchDoc`)

The compute subsystem executes the high-frequency commutation timing, closed-loop control algorithms, telemetry logging, and digital protocol decoding.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-10 text-center">
    <img src="{{ '/assets/img/3_phase_esc_mcu.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="STM32 MCU Schematic">
    <div class="caption">
      Sheet 3: STM32F405RGT6 168 MHz ARM Cortex-M4 MCU, decoupling networks, and Tag-Connect TC2030-IDC debug interface.
    </div>
  </div>
</div>

- **Microcontroller Core (`U2`, `STM32F405RGT6`):**
  - 168 MHz ARM Cortex-M4 with single-precision hardware FPU, 1 MB Flash, and 192 KB SRAM.
  - Native support for AM32 firmware, enabling DShot300/DShot600, bidirectional DShot RPM feedback, sine-wave startup, and low-latency motor control loops.
- **Power Decoupling & Analog Isolation:**
  - High-density $100\,\text{nF}$ 0201 bypass capacitors (`C14`, `C16`–`C19`) placed adjacent to every `VDD`/`VSS` pin pair.
  - Dedicated $2.2\,\mu\text{F}$ internal regulator stabilization capacitors (`C13`, `C15`) on `VCAP_1` and `VCAP_2`.
  - Analog domain isolation: Ferrite bead `FB1` ($120\,\Omega$ @ 100 MHz) with dual bypass capacitors (`C21`, `C22`, $100\,\text{nF}$) supplying `VDDA` to eliminate digital switching noise from ADC voltage and current sense readings.
- **SWD Debug Header (`J2`, `TC2030-IDC`):**
  - Ultra-compact Tag-Connect 6-pin legless footprint saving board real estate.
  - Protected with a Texas Instruments `SP3420-04UTG` 4-channel ultra-low capacitance TVS diode array and `SMAJ6.5A` clamping diode (`D3`).
- **Signal Pin Mapping:**
  - **Gate Drive Outputs (Advanced Timers):**
    - `HIN - A` (`PB13`), `NLIN - A` (`PA7`)
    - `HIN - B` (`PA8`), `NLIN - B` (`PB14`)
    - `HIN - C` (`PA9`), `NLIN - C` (`PB15`)
  - **Analog Sensing Inputs (Fast ADC Channels):**
    - Phase Voltages: `VSENSE - A` (`PA0`), `VSENSE - B` (`PA1`), `VSENSE - C` (`PA2`)
    - Phase Currents: `ISENSE - A` (`PA4`), `ISENSE - B` (`PA6`), `ISENSE - C` (`PC4`)

---

### Sheets 4–6: Phase A, B, and C Drivers (`Phase A/B/C.SchDoc`)

Each of the three inverter legs consists of an identical, symmetrical half-bridge circuit designed for high $dv/dt$ and $di/dt$ immunity.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-10 text-center">
    <img src="{{ '/assets/img/3_phase_esc_gate_driver.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Phase Driver Schematic">
    <div class="caption">
      Sheet 4: Complete Phase A schematic illustrating the IR2103 half-bridge gate driver, SiR182DP MOSFET pair, INA293 current sense stage, and BEMF voltage divider.
    </div>
  </div>
</div>

- **Half-Bridge Gate Driver (`U3`, `IR2103STRPBF`):**
  - Independent high- and low-side referenced output channels with matched propagation delays.
  - Active high `HIN` controls the high-side switch; active low `/LIN` (`NLIN`) controls the low-side switch with internal shoot-through prevention and dead-time insertion.
  - Floating high-side bootstrap supply formed by high-voltage Schottky diode `D5` (`CDBA2200-HF`, 200V, 2A) and $1\,\mu\text{F}$ ceramic capacitor `C23`.
  - Gate resistors `R6` and `R7` ($100\,\Omega$) dampen parasitic LC ringing between the gate trace inductance and FET input capacitance ($C_{\text{iss}}$), suppressing high-frequency gate oscillations.
- **Power MOSFET Stage (`Q1`, `Q2`, `SiR182DP-T1-RE3`):**
  - 100V N-channel TrenchFET power MOSFETs in thermally enhanced PowerPAK SO-8 packages.
  - Extremely low on-resistance: $R_{DS(\text{on})} \approx 6.4\,\text{m}\Omega$ (typ. @ $V_{GS} = 10\,\text{V}$), minimizing conduction losses ($I^2 R$) during continuous high-amperage operation.
  - High-frequency local DC bus decoupling capacitor `C24` ($4.7\,\mu\text{F}$) located in immediate proximity to the MOSFET half-bridge to minimize switching loop inductance.
- **High-Bandwidth Current Sensing (`U4`, `INA293A2IDBVR`):**
  - Fast, precision current sense amplifier with $1.3\,\text{MHz}$ bandwidth and $-4\,\text{V}$ to $+110\,\text{V}$ common-mode voltage range.
  - Fixed gain of $20\,\text{V}/\text{V}$ sensing across a precision $10\,\text{m}\Omega$ shunt resistor (`R8`):
    $$\text{Transfer Gain} = 20\,\text{V}/\text{V} \times 0.010\,\Omega = 0.20\,\text{V}/\text{A} = 200\,\text{mV}/\text{A}$$
  - Full-scale current measurement capability of $\pm 16.5\,\text{A}$ across the $0\,\text{V}$ to $3.3\,\text{V}$ ADC input range.
  - Output low-pass filter: $1\,\text{k}\Omega$ resistor (`R10`) and $1\,\text{nF}$ capacitor (`C27`) establishing an anti-aliasing cutoff frequency:
    $$f_c = \frac{1}{2\pi \cdot 1\,\text{k}\Omega \cdot 1\,\text{nF}} \approx 159.2\,\text{kHz}$$
- **Phase Voltage / Back-EMF Sensing Divider:**
  - Precision divider composed of $R_9 = 4.7\,\text{k}\Omega$ and $R_{11} = 1.0\,\text{k}\Omega$:
    $$\text{Attenuation Ratio} = \frac{1\,\text{k}\Omega}{4.7\,\text{k}\Omega + 1\,\text{k}\Omega} = \frac{1}{5.7} \approx 0.1754\,\text{V}/\text{V}$$
  - Maps a $0\,\text{V}$ to $18.8\,\text{V}$ phase voltage directly to the $0\,\text{V}$–$3.3\,\text{V}$ ADC input range.
  - Low-pass capacitor `C28` ($10\,\text{nF}$) filters switching transients while retaining back-EMF zero-crossing transitions.
  - Protected with a `SMAJ13A` TVS diode (`D6`) and accessible via probe test point `TP1`.

---

### Embedded Schematic PDF Viewer

Inspect the complete, multi-page vector schematic with all component values, net labels, and pinouts directly below:

<div class="mb-3 text-right">
  <a href="{{ '/assets/pdf/AM32_ESC_Schematic.pdf' | relative_url }}" target="_blank" rel="noopener noreferrer" class="btn btn-sm btn-outline-primary">
    <i class="fa-solid fa-up-right-from-square"></i> Open Schematic PDF in Full Window
  </a>
  <a href="{{ '/assets/pdf/AM32_ESC_Schematic.pdf' | relative_url }}" download class="btn btn-sm btn-primary">
    <i class="fa-solid fa-download"></i> Download Schematic PDF
  </a>
</div>

<div class="card p-1 shadow-sm mb-4" style="width: 100%; height: 750px; border: 1px solid #ccc; border-radius: 6px; overflow: hidden;">
  <object data="{{ '/assets/pdf/AM32_ESC_Schematic.pdf' | relative_url }}" type="application/pdf" width="100%" height="100%" style="border: none;">
    <iframe src="{{ '/assets/pdf/AM32_ESC_Schematic.pdf' | relative_url }}" width="100%" height="100%" style="border: none;">
      <p>Your browser does not support embedded PDFs. Please <a href="{{ '/assets/pdf/AM32_ESC_Schematic.pdf' | relative_url }}" target="_blank">click here to download the schematic PDF</a>.</p>
    </iframe>
  </object>
</div>

---

## 3. Engineering Requirements & Specifications

The table below outlines the electrical, control, and thermal specifications governing the schematic and physical layout design:

| Specification Domain | Target Parameter | Implementation & Circuit Strategy |
| :--- | :--- | :--- |
| **Input Bus Voltage ($V_{\text{BUS}}$)** | 12V to 32V nominal (6S–8S LiPo compatible) | `SMAJ26A` TVS diode, 100V `PDS3100` Schottky reverse protection, 50V-rated ceramic decoupling capacitor bank. |
| **Logic Supply Voltage** | $3.3\,\text{V} \pm 2\%$ regulated rail | High-efficiency TI `LMR33640DDDAR` 40V synchronous buck converter with $88\,\mu\text{F}$ output ceramic bank. |
| **Microcontroller Compute** | 168 MHz ARM Cortex-M4 with hardware FPU | STM32F405RGT6 running AM32 firmware, equipped with advanced motor control timers (complementary PWM + dead-time). |
| **Inverter Topology** | 3-Phase Complementary Half-Bridge | 3x IR2103STRPBF gate drivers with independent high/low side channels, bootstrap diode `CDBA2200-HF`, and $100\,\Omega$ gate damping. |
| **Power Switches** | 6x 100V N-Channel MOSFETs | Vishay `SiR182DP-T1-RE3` ($R_{DS(\text{on})} \approx 6.4\,\text{m}\Omega$, 100A pulsed rating, PowerPAK SO-8 package). |
| **Current Sensing** | Independent 3-phase low-side sensing | 3x TI `INA293A2IDBVR` ($1.3\,\text{MHz}$ bandwidth, 20 V/V gain) across $10\,\text{m}\Omega$ shunt resistors ($200\,\text{mV}/\text{A}$ transfer scaling). |
| **Current Filter Cutoff** | Anti-aliasing for PWM ripple rejection | $1\,\text{k}\Omega$ / $1\,\text{nF}$ low-pass RC network ($f_c \approx 159.2\,\text{kHz}$). |
| **Phase Voltage Sensing** | Back-EMF zero-crossing detection | 4.7 kΩ / 1.0 kΩ precision resistive dividers (5.7:1 attenuation) with $10\,\text{nF}$ filter capacitors and `SMAJ13A` TVS clamps. |
| **Firmware & Protocols** | Native open-source AM32 support | DShot300, DShot600, bidirectional telemetry, active freewheeling, variable PWM frequency ($16\,\text{kHz}$–$48\,\text{kHz}$). |
| **Debug Interface** | High-density SWD programming | Tag-Connect `TC2030-IDC` 6-pin interface protected by `SP3420-04UTG` ESD diode array. |

---

## 4. PCB Layout Strategy & Implementation (In Progress)

The physical PCB layout is currently **in active development** in Altium Designer. High-power brushless motor controllers operate in severe electromagnetic environments where switching currents ($di/dt > 1\,\text{A}/\text{ns}$) and fast voltage slew rates ($dv/dt$) can induce substantial ground bounce and false gate triggering if the layout is not meticulously controlled.

### Key Layout Considerations Under Execution:

1. **High-Current Commutation Loop Minimization:**
   - The primary high-frequency AC switching loop formed by the DC bus capacitors (`C24`), high-side MOSFET drain, switch node, low-side MOSFET source, and the ground return path is routed with minimal physical enclosed area.
   - Minimizing this loop inductance drastically reduces high-frequency inductive ringing ($V_{\text{spike}} = L \cdot \frac{di}{dt}$), protecting the SiR182DP MOSFETs from breakdown without requiring lossy RC snubbers.

2. **4-Layer Copper Stackup & Power Planes:**
   - **Layer 1 (Top Signal & Power):** High-current MOSFET pads, phase motor pads, gate driver traces, and component placement.
   - **Layer 2 (Solid Ground Plane):** Continuous, unbroken reference ground plane directly beneath the switching loops to provide a low-impedance image current return path and magnetic field cancellation.
   - **Layer 3 (Power Polygon & Sensing):** Wide $V_{\text{BUS}}$ and $3.3\,\text{V}$ copper polygons, with sensitive analog current sense lines routed away from switching nodes.
   - **Layer 4 (Bottom Signal & Thermal Plane):** Auxiliary interconnects and broad copper thermal spreaders with extensive thermal via arrays.

3. **Kelvin Current Sensing Routing:**
   - Current sensing traces from shunt resistors (`R8`, `R15`, `R20`) are routed as tight differential Kelvin pairs directly from the inner terminal pads of each shunt to the `IN+` and `IN-` pins of the INA293 amplifiers.
   - This prevents high-current ground plane $I \cdot R$ drops from polluting the delicate analog current measurements.

4. **Thermal Dissipation Architecture:**
   - The PowerPAK SO-8 packages feature large exposed bottom drain pads. Dense matrices of through-hole thermal vias ($0.3\,\text{mm}$ drill) are placed directly under each MOSFET pad, conducting heat from Layer 1 down to internal and bottom-side copper planes.
   - Similar thermal via stitching is placed under the LMR33640 SO-PowerPAD buck regulator to maintain low junction temperatures.

5. **Mixed-Signal Domain Isolation:**
   - The PCB floorplan strictly isolates the board into three zones: the high-power inverter half-bridge section, the DC-DC buck converter power island, and the quiet STM32 MCU / analog sensing zone.
   - Digital SWD traces and MCU oscillator lines are kept well away from the high-voltage phase switching nodes (`PhaseA`, `PhaseB`, `PhaseC`).
