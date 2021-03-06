; #########################################################################

    .486                      ; create 32 bit code
    .model flat, stdcall      ; 32 bit memory model
    option casemap :none      ; case sensitive

    .code

; ###########################################################################

RolData proc lpSource:DWORD,ln:DWORD,lpKey:DWORD,lnKey:DWORD

    LOCAL lref :DWORD   ; counter reference for key char position
    LOCAL pcnt :DWORD
    LOCAL bvar :BYTE

    push ebx
    push esi
    push edi

    mov eax, lpKey
    mov pcnt, eax
    add eax, lnKey
    mov lref, eax

    mov esi, lpKey
    mov al,[esi]
    mov bvar, al        ; put 1st byte in bvar

    mov ecx, ln
    mov esi, lpSource
    mov edi, lpSource

  rolSt:
    mov al,[esi]        ; copy 1st byte of source into al
    inc esi

    push ecx
    mov cl, bvar
    rol al, cl          ; rotate byte left by bvar
    pop ecx

  ; ====== This code gets the next byte in the key string ======
  ;        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    push eax
    push esi

    inc pcnt            ; increment byte address
    mov esi, pcnt       ; put it in esi
    mov al,[esi]
    inc esi

    mov ebx, lref
    cmp pcnt, ebx
    jne @F

    mov edx, lpKey      ; put key start address in edx
    mov pcnt, edx       ; reset pcnt to ariginal address
    mov esi, pcnt       ; put original address in esi

    mov al,[esi]
    inc esi

  @@:
    mov bvar, al

    pop esi
    pop eax
  ; ============================================================

    mov [edi], al
    inc edi
    dec ecx

    cmp ecx, 0
    jne rolSt

    pop edi
    pop esi
    pop ebx

    ret

RolData endp

; ###########################################################################

    end