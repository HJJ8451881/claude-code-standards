---
name: ardupilot-params
description: ArduPilot parameter conventions and MAVLink/DroneCAN details — DroneCAN peripheral setup, GPS and airspeed configuration, telemetry stream rates, and RTCM correction delivery over constrained links. Use when configuring flight controller parameters, wiring up a DroneCAN peripheral, tuning telemetry rates, or working on RTK correction transport.
---

# ArduPilot parameters and MAVLink

Parameter names shift between ArduPilot versions — confirm against the running firmware before applying any value below.

## DroneCAN peripherals

Enable the bus before the device will appear:

```
CAN_P1_DRIVER    1          # bind physical port 1 to driver 1
CAN_D1_PROTOCOL  1          # driver 1 speaks DroneCAN
CAN_P1_BITRATE   1000000
```

Second port mirrors this with `CAN_P2_DRIVER 2` / `CAN_D2_PROTOCOL 1`.

Peripherals then need their own type parameter pointing at DroneCAN — GPS and airspeed each have one. Reboot is required; the node will not enumerate on a parameter refresh alone.

Check `CAN_D1_UC_*` node IDs when two peripherals of the same class are on one bus.

## GPS

- DroneCAN GPS units (e.g. the Here-series family) are CAN devices, not serial. Configure them through the CAN parameters above, not `SERIALn_PROTOCOL`.
- Parameter naming changed around ArduPilot 4.5 (`GPS_TYPE` → `GPS1_TYPE`, etc.). Scripts written against the old names fail silently on newer firmware — the set succeeds against a nonexistent parameter in some tools.

## Telemetry stream rates

`SRn_*` parameters are per-serial-port, where `n` matches the telemetry port index. Raising them costs link bandwidth directly.

```
SR0_RAW_SENS  50           # RAW_IMU / SCALED_IMU for vibration analysis
```

For vibration work, 50 Hz on raw sensors is the useful floor. Everything else on that port should be turned down to compensate, or the link saturates and messages drop unpredictably.

## RTCM corrections over constrained links

RTK corrections reach the flight controller as `GPS_RTCM_DATA`:

- Payload is 180 bytes per message, with a `flags` field carrying the fragment bit, fragment ID, and sequence ID.
- A single logical RTCM stream chunk can span up to 4 fragments — roughly 720 bytes maximum. Anything larger must be split at the source.
- Fragments must arrive in order and complete; a dropped fragment invalidates the whole set, and the receiver silently discards it.

**On a low-bandwidth link (e.g. LoRa) this is the binding constraint.** Throughput is far below a typical RTCM3 stream, so the correction set must be filtered down to the message types actually needed for the fix, and the base station update rate reduced, before transport. Sending an unfiltered RTCM3 stream over such a link will not work regardless of fragmentation handling.

## Parsing MAVLink on microcontrollers

For ESP32-class bridge work, `okalachev/mavlink-arduino` is a usable library. Its header paths differ from the upstream generated headers — include paths copied from ArduPilot examples will not resolve.
