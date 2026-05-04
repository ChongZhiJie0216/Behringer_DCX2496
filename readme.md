# Behringer DCX2496 Communication Optimization Script

<div align="center">
  <p><strong>A custom-built "pacemaker" for the DCX2496 software, ensuring it captures hardware communication precisely and rapidly every time.</strong></p>
</div>

---

## 📖 Background & The Core Issue

The official **Behringer DCX-Remote 1.16a** was developed over a decade ago. Its port scanning mechanism is highly rigid; if the system COM port is not in a "fully active" or "handshake-ready" state the exact moment the software initializes, it will fail to recognize the device.

* **Hardware Characteristics:** The DCX2496 rack processor relies on `DTR` (Data Terminal Ready) and `RTS` (Request to Send) signals for RS-232 communication. Many modern USB-to-RS232 adapters do not output these signals while in an idle state.
* **System Environment:** On streamlined systems like Windows 10 LTSC IoT, the OS does not actively poll USB devices at high frequencies. This often results in the hardware remaining in a "semi-sleep" state when the software attempts to scan for it.

## 🛠️ The Solution

To ensure a **100% connection success rate**, this Pre-Activation Script was developed. It acts as a bridge, energizing the port right before launching the software.

1. **Forced Wake-up:** Before the main software starts, the script forcefully opens the selected COM port at the system level.
2. **Signal Compensation:** It manually pulls the `DTR` and `RTS` signals High, "energizing" the USB-to-RS232 chip and ensuring the physical communication link is fully established.
3. **Automated Handover:** Within 800ms of the hardware "waking up," the script releases control of the serial port and seamlessly launches `DCX-Remote.exe`.

## ✨ Features

* **🌐 Bilingual Support:** Accommodates operators with different language preferences (English/Chinese).
* **🔍 Dynamic Recognition:** Automatically scans current system COM ports, eliminating the need to manually check Windows Device Manager.
* **⚙️ Versatility:** Supports custom baud rates (Defaults to **38400**, the optimal rate for DCX units).

## 🚀 Final Result & Usage

By using this script, users no longer need to:
- ❌ Repeatedly plug and unplug USB cables to force software recognition.
- ❌ Constantly verify port numbers in the Device Manager.
- ❌ Deal with the frustration of the software showing an "Offline" status after startup.

### Quick Start
1. Run `DCX_Run.exe` (or `Script\Universal-COM-Starter.ps1`).
2. Follow the on-screen prompts to select your COM port and baud rate (usually `38400`).
3. The script will automatically initialize the port and launch the Behringer `DCX-Remote.exe` software, ready to connect.

## 🏗️ Building the Launcher

If you modify the PowerShell script (`Universal-COM-Starter.ps1`) and wish to recompile the executable launcher (`DCX_Run.exe`):

1. Ensure you have the `ps2exe` module installed in PowerShell:
   ```powershell
   Install-Module ps2exe -Scope CurrentUser
   ```
2. Run `build.cmd` from the root directory. This will compile the script, attach the provided icon, and generate a new `DCX_Run.exe`.

---

*Note: This repository contains utilities to optimize the usage of the legacy Behringer DCX2496 control software. It is not affiliated with Behringer.*