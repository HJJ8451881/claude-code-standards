---
name: raspberry-pi-deploy
description: Gotchas and conventions for deploying services on Raspberry Pi 5 running ARM64 Linux with Wayland — systemd unit ordering, UART/GPIO conflicts with GPS and SDR hardware, desktop and input method setup, and remote access. Use when writing systemd units, debugging boot-order or serial-port problems, or setting up VNC, screen recording, or input methods on a Pi.
---

# Raspberry Pi deployment

Applies to Pi 5 nodes running a Wayland session under a dedicated non-root deploy user. Verify hostname and paths before assuming — there is often more than one Pi in play.

## systemd

- **Child processes survive SIGTERM.** When a unit's `ExecStart` is a wrapper script that launches the real process, systemd's stop signal goes to the script, not the child. Use `exec` in the wrapper so the real process inherits PID, or set `KillMode=mixed` and handle the signal explicitly. Symptom: `systemctl stop` returns but the process is still holding the device.
- **`WorkingDirectory` typos fail late and confusingly.** The unit loads fine and only fails at start, often with an error that points at the wrong thing. Verify the path exists before enabling.
- **Hardware-dependent units need real ordering, not just `After=network.target`.** Units touching USB SDR or UART devices should wait on the actual device — use `BindsTo=` / `After=` with the relevant `.device` unit or a udev rule, otherwise they race the kernel enumerating the hardware.

## UART and GPS

- **GPS module can block boot.** A GPS module wired to the Pi's UART can back-power or hold lines during boot and stall it. Isolate power and signal lines, or diode-isolate the supply, before concluding the module is dead.
- Confirm the serial console is disabled on the UART intended for use, otherwise getty and the application fight over the port.

## Wayland desktop

- Screen recording: `wf-recorder`. X11-era tools do not work in this session.
- Overlay indicators (recording dot, status widgets): GTK + `GtkLayerShell`. Standard always-on-top window hints are ignored under Wayland.
- Chinese input: `fcitx5`. Set the Wayland environment variables in the session, not in `.bashrc` — a shell rc file loads too late for the GUI session.

## Remote access

- VNC: **TigerVNC**, not RealVNC — some VNC clients' built-in viewers cannot connect to RealVNC's protocol variant.
- For services exposed publicly: nginx as reverse proxy behind a tunnel that terminates TLS, so nginx listens plain on localhost.

## SD card backup

`dd` image + SHA256 verification, then `pishrink.sh` to compress. Always verify the hash before trusting a backup.

<!-- When this file passes ~150 lines, split into references/ by section and keep this as an index. -->
