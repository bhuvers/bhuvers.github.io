---
layout: page
title: Carrborobotics (FRC Team 7763)
description: Lead Electrical & Harnessing Engineer — 12V high-current power distribution (80A peaks), custom buck-regulated coprocessor power for PhotonVision, CAN bus network, and mechanical CAD design.
img: assets/img/carrborobotics_competition.jpg
importance: 2
category: work
---

<div class="row justify-content-sm-center">
  <div class="col-sm-9 mt-3 mt-md-0 text-center">
    <img src="{{ '/assets/img/carrborobotics_competition.jpg' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Carrborobotics Team 7763 Robot on Competition Field">
    <div class="caption">
      FRC Team 7763 (Carrborobotics) competition robot positioned at the Coral loading station during the 2025 FIRST Robotics Competition season.
    </div>
  </div>
</div>

## 1. System & Engineering Overview

**Carrborobotics (FIRST Robotics Competition Team 7763)** competes annually in regional and district events, fielding custom-designed robotics platforms engineered for intense match play.

Serving as the **Lead Electrical and Harnessing Engineer** (August 2024 – April 2025), key responsibilities centered on electrical system architecture, high-current power distribution, sensor harnessing, coprocessor power management, and CAN bus integration. In addition to the electrical subsystems, contributed to the mechanical CAD design in **Onshape**—specifically designing funnel plates and custom polycarbonate protective shielding for CNC routing to safeguard the robot's mechanisms and electronics from high-impact collisions during competition.

### System Architecture Summary:

- **Power Source & Main Trunk:** 12V 18Ah Sealed Lead-Acid (SLA) battery coupled to a 120A thermal-magnetic main breaker, distributing power across the central REV Power Distribution Hub (PDH).
- **High-Current Drive & Lift Channels:** 4-wheel independent swerve drive modules and dual-motor cascading elevator handling transient peaks up to 80A per motor channel.
- **Isolated Coprocessor Supply:** Custom 12V-to-5V step-down buck converter delivering 3A continuous with LC input filtering to power an Orange Pi running PhotonVision.
- **Deterministic Control Bus:** Daisy-chained differential CAN 2.0B network with $120\,\Omega$ controlled termination, interconnecting the RoboRIO, PDH, swerve azimuth/drive motors, CANcoders, elevator motors, and intake controllers.

---

## 2. Electrical Harnessing & High-Current 12V Power Distribution

FIRST Robotics Competition platforms operate under severe mechanical and electrical stress. Sudden direction reversals on independent swerve modules combined with high-load elevator lifts produce transient current spikes approaching **80A per brushless motor channel**.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-10 text-center">
    <img src="{{ '/assets/img/carrborobotics_chassis_assembly.jpg' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Chassis Bellypan Electrical Assembly">
    <div class="caption">
      Bellypan electrical assembly and wire harnessing: 12V battery, REV Power Distribution Hub (PDH), swerve drive motor controllers, and wire management channels.
    </div>
  </div>
</div>

### Electrical Architecture & Implementation:

- **12V High-Current Battery & Bus Standards:**
  - Standardized the main power trunk with **4 AWG ultra-flexible fine-strand copper wiring** routed from the 12V 18Ah AGM battery through **Anderson SB50 high-current connectors** into the 120A main breaker and REV Power Distribution Hub (PDH).
  - Enforced structured wire sizing across all branches: 10–12 AWG for high-draw brushless motor drives, 14–16 AWG for auxiliary actuators, and 18–22 AWG for sensors, logic, and communications.

- **Mitigating Voltage Sag & Under-Voltage Lockout (UVLO):**
  - High current draws during stall conditions or rapid acceleration can pull battery voltage below **7.0V**, triggering automatic RoboRIO brownout protection and motor disable.
  - Software stator current limits and supply current limits were configured in motor controller firmware (CTRE Talon FX / REV SPARK MAX).
  - Capping peak stator current preserved maximum low-end torque while eliminating battery voltage sag and preventing thermal overload on brushless motor windings.

- **Multi-Stage Elevator Harnessing & Drag Chains:**
  - Delivering power and sensor feedback across a 2-meter multi-stage cascading elevator required continuous flex endurance without risking wire pinch, snagging, or fatigue.
  - Implemented continuous-flex **energy chains (drag chains)** along the vertical mast with 3D-printed entry and exit strain-relief brackets, keeping all power, encoder, and limit switch wiring within acceptable dynamic bend radii.

---

## 3. Custom Buck-Regulated Power for PhotonVision Coprocessor

Autonomous scoring and precision field alignment relied on an **Orange Pi coprocessor** running **PhotonVision** for real-time 3D AprilTag fiducial detection (such as Tag ID 12 on the Coral Station) at 50+ FPS.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-10 text-center">
    <img src="{{ '/assets/img/carrborobotics_elevator_wiring.jpg' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Elevator Mast and Energy Chain Wiring">
    <div class="caption">
      Elevator carriage and intake mechanism assembly, showing cable chain routing, structural gusseting, and sensor harnesses.
    </div>
  </div>
</div>

### Problem & Failure Modes:

Single-board computers powered from standard auxiliary ports frequently suffer brownouts, resets, and hardware freezes in FRC environments:

1. **Inductive Kickback & Voltage Transients:** High-current motor commutations generate sharp $L \cdot \frac{di}{dt}$ voltage spikes alongside bus voltage dips down to 8V.
2. **Electrostatic Discharge (ESD):** Static charges accumulated on robot wheels from high-speed carpet friction discharge into exposed coprocessor circuitry and ground paths.

### Engineering Solution:

- Installed a dedicated **custom 12V-to-5V step-down buck converter** rated for **3A continuous (5A peak)** clean DC power to supply the Orange Pi.
- Added a custom **LC low-pass input filter** (shielded inductor and low-ESR ceramic capacitor bank) upstream of the regulator to attenuate motor switching noise and clamp inductive back-EMF spikes.
- Isolated coprocessor chassis grounding to eliminate ground loops and added TVS clamping on the power input lines.
- **Result:** Completely eliminated coprocessor reboot loops, ESD failures, and brownouts across all competition matches.

---

## 4. Deterministic Differential CAN Bus Architecture

Closed-loop feedback and motor synchronization across the robot required deterministic communication without dropped frames:

- **Network Wiring:** Built a unified **differential CAN 2.0B bus** linking the RoboRIO, REV PDH, 8 swerve motor controllers, 4 CANcoder absolute encoders, elevator motors, and intake controllers.
- **Impedance Matching & Termination:** Maintained a controlled **$120\,\Omega$ characteristic impedance** twisted pair across the entire bus topology, terminated with precision $120\,\Omega$ end-of-line resistors to prevent signal reflections.
- **Noise Segregation:** Physically separated CAN twisted pairs from high-current motor stator phase leads to minimize electromagnetic interference (EMI) from inductive brushless motor switching, maintaining sub-10ms packet latency.

---

## 5. CAD Design Contributions & CNC Protective Shielding

In addition to leading the electrical harnessing, contributed to the mechanical CAD design in **Onshape**, focusing on protective elements, funneling geometry, and electrical packaging.

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-9 text-center">
    <img src="{{ '/assets/img/carrborobotics_cad.png' | relative_url }}" class="img-fluid rounded z-depth-1" alt="FRC Team 7763 Full Robot CAD Model">
    <div class="caption">
      Complete 3D Onshape CAD model of the FRC Team 7763 competition robot, showing the swerve chassis, cascading elevator, intake wrist, and protective shielding.
    </div>
  </div>
</div>

### Key Design Contributions:

- **Funnel Plates for Game Piece Acquisition:**
  - Designed custom funnel plates in Onshape to guide and funnel cylindrical game pieces (tubes/coral) directly into the intake rollers during rapid cycling, accommodating misaligned robot approaches.
- **Custom Polycarbonate Pieces for CNC Routing:**
  - Modeled custom polycarbonate protective shielding to protect the robot's chassis, electrical bellypan, swerve modules, and elevator carriage from severe field impacts and aggressive defense.
  - Prepared and exported DXF vector profiles for CNC router milling, optimizing bend reliefs, mounting hole tolerances, and tab geometry for rapid pit replacement.
- **Electrical Packaging & Wire Routing Clearance:**
  - Modeled component placement in CAD before fabrication to ensure optimal center-of-gravity distribution, convenient battery swap access, and verified clearance through the elevator's full range of motion.

---

## 6. Competition Execution & Pit Operations

<div class="row justify-content-sm-center my-3">
  <div class="col-sm-10 text-center">
    <img src="{{ '/assets/img/carrborobotics_pit_repair.jpg' | relative_url }}" class="img-fluid rounded z-depth-1" alt="Competition Pit Maintenance and Electrical Checks">
    <div class="caption">
      Rapid pit diagnostics, mechanical adjustments, and electrical inspection between qualification matches at competition.
    </div>
  </div>
</div>

During regional and championship events, short turnarounds between matches required disciplined operational procedures:

- **Pre-Match Electrical Inspection:** Executed inspection checklists verifying battery internal resistance, CAN bus packet health, main breaker terminal torque, and motor encoder calibrations.
- **Pit Diagnostics & Maintenance:** Performed rapid wiring checks, battery turnarounds, and hardware servicing under tight schedules to maintain 100% electrical uptime across qualification and playoff rounds.

---

## 7. Technical Specifications Summary

| Subsystem                    | Engineering Specification                  | Implementation Details                                                                         |
| :--------------------------- | :----------------------------------------- | :--------------------------------------------------------------------------------------------- |
| **Team & Season**            | FRC Team 7763 (Carrborobotics)             | 2025 FIRST Robotics Competition Season (Reefscape)                                             |
| **Role**                     | Lead Electrical & Harnessing Engineer      | Electrical architecture, high-current PDN, coprocessor power, CAN bus, CAD design              |
| **Primary Power Bus**        | 12V DC nominal (SLA 18Ah battery)          | 120A main breaker, 4 AWG primary leads, Anderson SB50, REV Power Distribution Hub              |
| **Peak Current Capability**  | Up to 80A peak per brushless drive channel | Managed via firmware stator current limits and supply current caps to prevent UVLO (<7.0V)     |
| **Vision Coprocessor Power** | Isolated 12V $\to$ 5V @ 3A step-down       | Custom buck converter with LC input filter, eliminating inductive spikes and ESD reboot cycles |
| **Vision Subsystem**         | PhotonVision on Orange Pi SBC              | High-FPS 3D AprilTag pose estimation and autonomous field alignment                            |
| **Communications Bus**       | Differential CAN 2.0B (1 Mbps)             | Controlled impedance twisted pair, $120\,\Omega$ end-of-line termination, sub-10ms latency     |
| **Elevator Harnessing**      | Multi-stage dynamic flex harness           | Continuous-flex energy chains (drag chains) with custom strain relief mounts                   |
| **CAD Design Contributions** | Onshape 3D modeling                        | Designed funnel plates and custom CNC-routed polycarbonate protective pieces                   |
| **Fabrication Methods**      | CNC router milling & 3D printing           | Polycarbonate protective shielding, aluminum gussets, PETG/TPU brackets                        |
