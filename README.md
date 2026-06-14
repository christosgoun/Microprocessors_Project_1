# Smart Access Control System - ARM Assembly & C

An embedded software implementation of a **Smart Access Control System** developed for the **Microprocessors and Peripherals Lab (1st Assignment, Spring Semester 2026)** at the Department of Electrical and Computer Engineering, Aristotle University of Thessaloniki (AUTh).

The project focuses on bare-metal development for the **NUCLEO-F401RE (Cortex-M4)** microcontroller, combining C for flow control and ARM Assembly (Thumb-2) for performance-critical components, strictly following the AAPCS calling convention.

---

## 🛠️ System Architecture & Functions

The system processes a static alphanumeric identification string (`PIN / Badge ID`) via a C `main()` function and executes the following operations in optimized Assembly:

1. **`compute_access_hash.s`**: Computes an integer Hash value based on character type.
   - Initial value equals string length.
   - Uppercase letters: Added as `ASCII * 2`.
   - Lowercase letters: Converted to uppercase via bitwise mask (`0xDF`) and added to the hash.
   - Digits (0-9): Mapped to specific constants via an in-memory Look-Up Table (LUT).
2. **`compute_clearance_level.s`**: Determines the access level (0 to 5).
   - Computes the Hamming Weight (active bits) using conditional execution blocks (`IT CS` & `ADDCS`).
   - Returns the result modulo 6 (`MOD 6`) using hardware division (`UDIV`).
3. **`lucas_sequence.s`**: Generates the final unlock code by recursively calculating the $n$-th term of the Lucas Sequence ($L(n) = L(n-1) + L(n-2)$), where $n$ is the clearance level.
4. **`compute_checksum.s` (Bonus)**: Enhances security by applying a sequential bitwise XOR on all characters with a hexadecimal `0xAA` Salt constant.

---

## 💻 Development & Testing Environment

- **IDE:** Keil µVision
- **Target Hardware:** NUCLEO-F401RE (Cortex-M4)
- **Toolchain:** ARM Compiler
- **Debugging:** Keil Simulator, Register monitoring, and UART emulation via standard `printf()`.

---

## 📂 Repository Structure

```text
├── src/
│   ├── main.c
│   ├── compute_hash.s
│   ├── compute_clearance.s
│   ├── lucas_sequence.s
│   └── compute_checksum.s
├── doc/
│   └── lab_mikro.pdf          # Laboratory Report
└── README.md
