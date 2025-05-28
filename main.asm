org 0x100
bits 16

start:
    mov ax, 0x13
    int 0x10

mainloop:
    mov ah, 0x01
    int 0x16
    jnz quit

    mov ax, 0x0003
    int 0x33
    cmp bx, 1
    jne mainloop

    mov ax, 0xA000
    mov es, ax

    mov di, dx
    mov cx, 320
    mul cx
    add ax, cx
    mov di, ax
    mov al, 15
    stosb

    jmp mainloop

quit:
    mov ax, 0x03
    int 0x10
    ret