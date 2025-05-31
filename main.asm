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
    jz check_mouse

    mov ah, 0x00
    int 0x16
    cmp al, 27
    je quit
    cmp al, '1'
    jb check_mouse
    cmp al, '9'
    ja check_hex

    sub al, '0'
    mov [color], al
check_mouse:
    mov ax, 0x0001
    int 0x33

    mov ax, 0x0003
    int 0x33
    test bx, 1
    jnz draw
    test bx, 2
    jnz erase

    jmp mainloop
check_hex:
    cmp al, 'a'
    jb check_mouse
    cmp al, 'f'
    ja check_mouse

    sub al, 'a'
    add al, 0xA
    mov [color], al
draw:
    mov ax, 0x0002
    int 0x33
    shr cx, 1
    mov ax, dx          ; Y -> AX
    xor dx, dx
    mov bx, 320
    mul bx              ; AX = Y * 320
    add ax, cx          ; AX = Y * 320 + X
    mov di, ax          ; DI = final offset

    mov ax, 0xA000
    mov es, ax          ; ES = video memory
    mov al, [color]
    cld
    stosb               ; write pixel at ES:DI

    jmp mainloop
erase:
    mov ax, 0x0002
    int 0x33
    shr cx, 1
    mov ax, dx          ; Y → AX
    xor dx, dx
    mov bx, 320
    mul bx              ; AX = Y * 320
    add ax, cx          ; AX = Y * 320 + X
    mov di, ax          ; DI = pixel offset

    ; — ES:DI now points at first pixel in video page —
    mov ax, 0xA000
    mov es, ax
    mov al, 0x00        ; color = black (erase)
    cld

    ; clear (X, Y)
    stosb

    ; clear (X+1, Y)
    inc di
    stosb

    ; clear (X, Y+1)
    sub di, 1           ; back to original DI
    add di, 320
    stosb

    ; clear (X+1, Y+1)
    inc di
    stosb

    jmp mainloop
quit:
    mov ax, 0x0001
    int 0x33
    mov ax, 0x0003
    int 0x10
    ret

section .data
color db 0x0F
