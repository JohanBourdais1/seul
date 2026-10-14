void* syscall5(
    void* number,
    void* arg1,
    void* arg2,
    void* arg3,
    void* arg4,
    void* arg5
);

typedef unsigned long int uintptr;
typedef long int intptr;

__attribute__((naked))
void* syscall5(void* number, void* arg1, void* arg2, void* arg3, void* arg4, void* arg5)
{
    __asm__ volatile(
        "mov r7, r0\n"
        "mov r0, r1\n"
        "mov r1, r2\n"
        "mov r2, r3\n"
        "ldr r3, [sp, #0]\n"
        "ldr r4, [sp, #4]\n"
        "svc #0\n"
        "bx lr\n"
    );
}

static
intptr write(int fd, void const* data, uintptr nbytes)
{
    return (intptr)
        syscall5(
            (void*)4, /* SYS_write sur ARM */
            (void*)(intptr)fd,
            (void*)data,
            (void*)nbytes,
            0,
            0
        );
}

static void print_hex(unsigned int val)
{
    char buf[11];
    int i;

    buf[0] = '0';
    buf[1] = 'x';
    buf[10] = 0;

    for (i = 9; i >= 2; i--)
    {
        buf[i] = hexchars[val & 0xf];
        val >>= 4;
    }
    write(1, buf, 10);
    write(1, "\n", 1);
}

int main()
{
    int z = 0xcafe;

    write(1, "Avant: z = ", 11);
    print_hex((unsigned int)z);

    /* utilise le syscall 223 pour écrire directement à l'adresse de z */
    int a = 0xdeadbeef;
    int b = 0;
    char op = '+'; /* addition : a + b = 0xdeadbeef + 0 */

    syscall5(
        (void*)223,
        (void*)(intptr)a,
        (void*)(intptr)op,
        (void*)(intptr)b,
        (void*)&z,   /* adresse où le résultat est écrit */
        0
    );

    write(1, "Apres: z = ", 11);
    print_hex((unsigned int)z);

    return 0;
}

__attribute__((naked, noreturn, used))
void _start(void)
{
    __asm__ volatile(
        "bl main\n"
        "mov r7, #1\n"
        "mov r0, #0\n"
        "svc #0\n"
    );
}
