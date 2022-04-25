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
