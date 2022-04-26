message = " ok  X:4"
# print(message)
if message.startswith("resend:"):
    print('resend')

if message.startswith("ok") or message.startswith(" ok"):
    if not ("X:" in message or " Y:" in message or " Z:" in message or " E:" in message) and not (" T:" in message or " T0:" in message or " B:" in message or " C:" in message):
        print("znovu")
    else:
        print("jedeme dal")

if message.startswith("X:") or " Y:" in message or " Z:" in message or " E:" in message:
    print('pozice')

if " T:" in message or " T0:" in message or " B:" in message or " C:" in message:
    # print(message)
    print('teplota')


message = """
echo:V85 stored settings retrieved (609 bytes; crc 57264)
echo:; Linear Units:
G21 ; (mm)
echo:; Temperature Units:
echo:  M149 C ; Units in Celsius
echo:; Filament settings (Disabled):
echo:  M200 S0 D1.75
echo:; Steps per unit:
echo:  M92 X40.00 Y40.00 Z199.70 E72.46
echo:; Max feedrates (units/s):
echo:  M203 X300.00 Y300.00 Z5.00 E25.00
echo:; Max Acceleration (units/s2):
echo:  M201 X3000.00 Y3000.00 Z100.00 E3000.00
echo:; Acceleration (units/s2) (P<print-accel> R<retract-accel> T<travel-accel>):
echo:  M204 P3000.00 R3000.00 T3000.00
echo:; Advanced (B<min_segment_time_us> S<min_feedrate> T<min_travel_feedrate> J<junc_dev>):
echo:  M205 B20000.00 S0.00 T0.00 J0.01
echo:; Home offset:
echo:  M206 X0.00 Y0.00 Z0.00
echo:; Auto Bed Leveling:
echo:  M420 S0 Z0.00 ; Leveling OFF
echo:  G29 W I0 J0 Z0.22954
echo:  G29 W I1 J0 Z0.14942
echo:  G29 W I2 J0 Z0.33971
echo:  G29 W I0 J1 Z0.11938
echo:  G29 W I1 J1 Z0.00421
echo:  G29 W I2 J1 Z0.10936
echo:  G29 W I0 J2 Z0.24457
echo:  G29 W I1 J2 Z0.16445
echo:  G29 W I2 J2 Z0.31467
echo:; Hotend PID:
echo:  M301 P22.20 I1.08 D114.00
echo:; Z-Probe Offset:
echo:  M851 X0.00 Y16.00 Z-2.90 ; (mm)
echo:; Stepper driver current:
echo:  M906 X800 Y800 Z800
echo:  M906 I1 Z800
echo:  M906 T0 E800
echo:; Driver stepping mode:
echo:  M569 S1 X Y Z
echo:  M569 S1 I1 Z
echo:  M569 S1 T0 E
"""