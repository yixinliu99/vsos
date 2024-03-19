org 0x0
bits 16

; set display mode
mov ax, 3
int 0x10

; init segment registers
mov ax, 0
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00

mov si, booting
call print

mov edi, 0x1000; read from disk to 0x1000
mov ecx, 2; read 2 sectors
mov bl, 4; read from drive 0

call read_disk

cmp word [0x1000], 0x55aa
jnz error

jmp 0:0x1008

; blocking
jmp $

read_disk:
    ; set up number of sectors to read
    mov dx, 0x1f2
    mov al, bl
    out dx, al

    inc dx; 0x1f3
    mov al, cl; first 8 bits of LBA
    out dx, al

    inc dx; 0x1f4
    shr ecx, 8
    mov al, cl; next 8 bits of LBA
    out dx, al

    inc dx; 0x1f5
    shr ecx, 8
    mov al, cl; last 8 bits of LBA
    out dx, al

    inc dx; 0x1f6
    shr ecx, 8
    and cl, 0b1111; set 4 MSB to 0

    mov al, 0b1110_0000;
    or al, cl
    out dx, al; main drive, LBA mode

    inc dx; 0x1f7
    mov al, 0x20; read hard disk
    out dx, al

    xor ecx, ecx; clear ecx
    mov cl, bl; get sector count

    .read:
        push cx; save cx
        call .waits; wait for data
        call .reads; read data
        pop cx; restore cx
        loop .read

    ret

    .waits:
        mov dx, 0x1f7
        .check:
            in al, dx
            jmp $+2; jump to next instruction
            jmp $+2; some delay
            jmp $+2
            and al, 0b1000_1000
            cmp al, 0b0000_1000
            jnz .check
        ret

    .reads:
        mov dx, 0x1f0
        mov cx, 256; 256 words per sector
        .readw:
            in ax, dx
            jmp $+2; some delay
            jmp $+2
            jmp $+2
            mov [edi], ax
            add edi, 2
            loop .readw
        ret

print:
    mov ah, 0x0e
.next:
    mov al, [si]
    cmp al, 0
    jz .done
    int 0x10
    inc si
    jmp .next
.done:
    ret

booting:
    db "Booting Onix...", 10, 13, 0; \n\r

error:
    mov si, .msg
    call print
    hlt; halt CPU
    jmp $
    .msg db "Booting Error!!!", 10, 13, 0

; the time instruction is used to copy the given byte ('db' for byte) x times
; (times x db byte). We use $ to find the address of the current instruction
; (right after hlt), and $$ refers to the first used address of this code.
; the bootsector must be 512 bytes long exactly, so we fill all the next bytes
; of the program until the byte 510
times 510 - ($ - $$) db 0

; the two last bytes of a bootsector are always AA and 55; this is a convention
; to localize the end of the boot sector program
db 0x55, 0xaa