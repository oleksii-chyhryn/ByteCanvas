org 0x100
bits 16

start:
    mov ax, 0x13
    int 0x10

    mov ax, 0x0000
    int 0x33

mainloop:
    mov ah, 0x01
    int 0x16
    jnz quit

    mov ax, 0x0003
    int 0x33
    cmp bx, 1
    jne mainloop

    mov ax, dx          ; Y -> AX
    xor dx, dx
    mov bx, 320
    mul bx              ; AX = Y * 320
    add ax, cx          ; AX = Y * 320 + X
    mov di, ax          ; DI = final offset

    mov ax, 0xA000
    mov es, ax          ; ES = video memory
    mov al, 0x0F        ; white color
    cld
    stosb               ; write pixel at ES:DI

    jmp mainloop

quit:
    mov ax, 0x0001
    int 0x33
    mov ax, 0x0003
    int 0x10
    ret