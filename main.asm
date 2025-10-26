.386
.model flat,stdcall
.stack 4096
INCLUDE Irvine32.inc
ExitProcess proto, dwExitCode:dword

.data
randNum DWORD ?
countArray DWORD 13 DUP(0)   ; 13 counters (for 1–13)
totalCount DWORD 0            ; total numbers generated

.code
main PROC
    call Randomize

generateAgain:
    mov eax, 13
    call RandomRange      ; EAX = 0–12
    inc eax               ; shift to 1–13
    mov randNum, eax

    ;------------------------------------------
    ; Check if number has already appeared 4 times
    ;------------------------------------------
    mov ecx, eax          ; copy number
    dec ecx               ; array is 0-based (1→0, 13→12)
    mov edi, OFFSET countArray
    mov eax, [edi + ecx*4] ; get countArray[ecx]
    cmp eax, 4
    jae generateAgain      ; if count >= 4, skip and try again

    ;------------------------------------------
    ; Otherwise, increment its counter
    ;------------------------------------------
    inc eax
    mov [edi + ecx*4], eax

    ;------------------------------------------
    ; Print number
    ;------------------------------------------
    mov eax, randNum
    call WriteDec
    call Crlf

    ;------------------------------------------
    ; Increment total count and check if done
    ;------------------------------------------
    inc totalCount
    mov eax, totalCount
    cmp eax, 52               ; 13 numbers * 4 each = 52 total
    jb generateAgain          ; if totalCount < 52, continue

    invoke ExitProcess, 0
main ENDP
END main
