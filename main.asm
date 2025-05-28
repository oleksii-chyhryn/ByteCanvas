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

    mov ax, dx          ; Y -> AX
    mov bx, 320
    mul bx              ; AX = Y * 320
    add ax, cx          ; AX = Y * 320 + X
    mov di, ax          ; DI = final offset

    mov ax, 0xA000
    mov es, ax          ; ES = video memory
    mov al, 0x0F        ; white color
    stosb               ; write pixel at ES:DI

    jmp mainloop

quit:
    mov ax, 0x03
    int 0x10
    ret