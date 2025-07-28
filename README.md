# Functional Verification of an SPI Memory Interface Using UVM

This project implements a modular **SPI (Serial Peripheral Interface) Controller** and verifies its functionality using a **UVM-based testbench**. The controller supports both **read and write operations** and ensures protocol correctness through a finite state machine (FSM)-based architecture.

---

## 📌 Project Overview

The SPI controller acts as a **master** and communicates with a **memory slave** module over an SPI interface. The controller supports:

- 8-bit **address** and **data**.
- Serialized **read** and **write** operations.
- Protocol-level control with `CS_N`, `MOSI`, `MISO`, and status signals.
- Robust **error handling** and status reporting.

This project also features **functional verification** using the **Universal Verification Methodology (UVM)** framework.

---

## 🧩 SPI Controller Block Diagram

![SPI Controller Block Diagram](images/Schematic.png)

---

## 🔄 FSM (Finite State Machine) Design

The controller uses an FSM to manage operation sequences:

- `IDLE`: Wait for transaction.
- `LOAD`: Load input data into internal shift register.
- `CHECK_OP`: Check for read/write enable.
- `SEND_DATA`: Serially transmit address and data.
- `SEND_ADDR`: Transmit address for read.
- `CHECK_READY`: Wait for memory to assert ready.
- `READ_DATA`: Receive read data from memory.
- `ERROR`: Triggered when an invalid operation or address occurs.

![FSM Diagram](images/Controller.png)

---

## 🧪 UVM Testbench Architecture

The verification environment was developed using **SystemVerilog + UVM**. The testbench architecture includes:

- **UVM Agent**:
  - Driver: Drives SPI stimulus to the DUT.
  - Monitor: Observes DUT response and sends it to the scoreboard.
- **UVM Sequencer + Sequences**:
  - Generates read and write transactions.
- **UVM Scoreboard**:
  - Compares DUT output with expected behavior.
- **UVM Test**:
  - Controls sequence execution and monitors success criteria.
- **Assertions**:
  - Protocol-level assertions were implemented to catch violations.

---

## ✅ Verification Output Results

The following test scenarios were verified:

- ✔️ Simple Write Operation
- ✔️ Simple Read Operation
- ✔️ Read After Write (RAW)
- ✔️ Invalid Address Handling
- ✔️ Protocol Compliance

Below are some simulation waveforms:

### ✔️ Write Transaction Validation
![Write Transaction](images/1.png)

---

### ✔️ Read Transaction Validation
![Read Transaction](images/2.png)

---

### ✔️ Read After Write Transaction (RAW)
![Read After Write](images/3.png)

---

## 🧠 Key Learnings

- Design and implementation of a custom SPI controller with FSM.
- Interfacing SPI controller with memory for serial read/write operations.
- Building reusable and scalable UVM components.
- Performing functional coverage analysis and protocol compliance testing.
- Debugging and tracing corner-case failures using waveform tools.

---
