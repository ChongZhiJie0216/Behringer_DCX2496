# Behringer DCX2496 Control Software & Utilities

## Project Overview
This directory contains a pre-compiled software bundle, scripts, and utilities for the remote control and configuration of the Behringer DCX2496 Ultradrive Pro audio processor via RS-232 serial connection. 

The core focus of this toolset is to solve a common communication issue with the legacy `DCX-Remote.exe` software. Modern USB-to-RS232 adapters often fail to wake up in time for the software's rigid port scanning mechanism. To ensure a 100% connection success rate, a custom "Pre-Activation Script" (`Universal-COM-Starter.ps1` / `DCX_Run.exe`) acts as a "pacemaker" by forcefully waking up the COM port (pulling DTR/RTS high) before seamlessly launching the remote software.

## Directory Structure & Key Files

*   **`readme.md`**: Explains the background and logic of the pre-activation script, detailing the issue with legacy COM port scanning and modern USB adapters.
*   **`DCX-Remote.exe`**: The legacy remote control application (v1.16a) for the Behringer DCX2496.
*   **`Script/Universal-COM-Starter.ps1`**: A bilingual (English/Chinese) PowerShell script that pre-activates the selected COM port and baud rate (default 38400) before launching `DCX-Remote.exe`.
*   **`build.cmd`**: A Windows batch script that compiles `Universal-COM-Starter.ps1` into a standalone executable (`DCX_Run.exe`) using the `ps2exe` PowerShell module.
*   **`DCX_Run.exe`**: The compiled version of the PowerShell script, acting as a convenient launcher for the remote software.
*   **`Firmware/DCX_116.bin`**: Firmware update file (version 1.16) for the DCX2496 device.
*   **`Software/COMTransmit_Setup.exe`**: An installer for "COMTransmit", a utility likely used for transferring the `.bin` firmware file to the device.

## Usage & Development Guide

### Launching the Remote Software
To ensure reliable connection with the DCX2496, you should launch the software using the provided activator:
1. Run `DCX_Run.exe` (or `Script\Universal-COM-Starter.ps1`).
2. Follow the interactive prompts to select your COM port and baud rate (38400). 
3. The script will initialize the port, pull the DTR and RTS signals high to establish the physical link, and automatically launch `DCX-Remote.exe`.

### Building the Launcher (`DCX_Run.exe`)
If you modify `Universal-COM-Starter.ps1`, you can recompile it into an executable:
1. Ensure you have the `ps2exe` module installed in PowerShell (`Install-Module ps2exe -Scope CurrentUser`).
2. Run `build.cmd` from the root directory. This will compile the script and generate a new `DCX_Run.exe` with the provided icon (`Script/Serial.ico`).

### Firmware Update
To update the DCX2496 firmware:
1. Install the utility located at `Software/COMTransmit_Setup.exe`.
2. Use it to transmit the `Firmware/DCX_116.bin` file to the connected device.
