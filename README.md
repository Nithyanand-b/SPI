# Functional Verification of an SPI Memory Interface Using UVM
This project implements a robust and modular **SPI (Serial Peripheral Interface) Controller**. It supports both read and write operations with proper protocol handling using a finite state machine (FSM).

---

## 📸 

### 🧩 SPI Controller Block Diagram (DUT)

![SPI Controller Block Diagram](images/Schematic.png)

> **Description**:  
> This shows how the SPI controller interacts with internal data/address registers, the FSM controller, and the MOSI/MISO interface. Core control signals include `clk`, `rst_n`, `write_en`, `addr`, `data_in`, `data_out`, `done`, and `error`.

---
## ✅ Verification Output Results

The SPI controller was successfully verified using a UVM-based testbench. Below are the validated scenarios and observed outcomes:

![](images/1.png)
![](images/2.png)
![](images/3.png)


---
