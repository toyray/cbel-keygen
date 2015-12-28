## Commandos: Behind Enemy Lines Mission Password Generator

### Key Generation Function

- Calculate magic based on current mission number, profile number, ALEX and L@L@
- Calculate four characters of the mission password, decrementing from character 4 to 1
- Calculate fifth character of the mission password based on magic

### Disassembly (W32DASM)

```
* Referenced by a CALL at Addresses:
|:004315D3   , :00439BA6   
|
:0046BD10 56                      push esi
:0046BD11 57                      push edi
:0046BD12 C701FFFFFFFF            mov dword ptr [ecx], FFFFFFFF
:0046BD18 8BF1                    mov esi, ecx
:0046BD1A C7410CFFFFFFFF          mov [ecx+0C], FFFFFFFF
:0046BD21 C6461000                mov [esi+10], 00
:0046BD25 8B54240C                mov edx, dword ptr [esp+0C]
:0046BD29 B9FFFFFFFF              mov ecx, FFFFFFFF
:0046BD2E 8BFA                    mov edi, edx
:0046BD30 2BC0                    sub eax, eax
:0046BD32 C74604FFFFFFFF          mov [esi+04], FFFFFFFF
:0046BD39 C74608FFFFFFFF          mov [esi+08], FFFFFFFF
:0046BD40 C7464400000000          mov [esi+44], 00000000
:0046BD47 F2                      repnz
:0046BD48 AE                      scasb
:0046BD49 F7D1                    not ecx
:0046BD4B 49                      dec ecx
:0046BD4C 83F904                  cmp ecx, 00000004
:0046BD4F 7640                    jbe 0046BD91
:0046BD51 52                      push edx
:0046BD52 A154226000              mov eax, dword ptr [00602254]
:0046BD57 8B902C140000            mov edx, dword ptr [eax+0000142C]
:0046BD5D 8B4A0C                  mov ecx, dword ptr [edx+0C]
:0046BD60 E8EBD00600              call 004D8E50                 		; get current mission no + 6
:0046BD65 83E806                  sub eax, 00000006             		; get [Actual Mission No]
:0046BD68 8B4C2410                mov ecx, dword ptr [esp+10]   		; mov 1 into ecx
:0046BD6C 8B542414                mov edx, dword ptr [esp+14]			; mov [Actual Mission No] into edx
:0046BD70 8B7C2418                mov edi, dword ptr [esp+18]			; mov [Profile No] into edi (starts at 0)
:0046BD74 890E                    mov dword ptr [esi], ecx	
:0046BD76 895604                  mov dword ptr [esi+04], edx
:0046BD79 57                      push edi
:0046BD7A 894608                  mov dword ptr [esi+08], eax
:0046BD7D 52                      push edx
:0046BD7E 897E0C                  mov dword ptr [esi+0C], edi
:0046BD81 C7464401000000          mov [esi+44], 00000001
:0046BD88 51                      push ecx
:0046BD89 50                      push eax
:0046BD8A 8BCE                    mov ecx, esi
:0046BD8C E86F030000              call 0046C100							; call function to generate [Mission Password]

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046BD4F(C)
|
:0046BD91 8BC6                    mov eax, esi							; mov [Mission Password] into eax
:0046BD93 5F                      pop edi
:0046BD94 5E                      pop esi
:0046BD95 C21000                  ret 0010

_____________________________________________________________________________________________________________________________


* Referenced by a CALL at Addresses:
|:0046BD02   , :0046BD8C   , :0046BDE8   
|
:0046C100 8B442408                mov eax, dword ptr [esp+08]			; mov 1 into eax
:0046C104 56                      push esi
:0046C105 C1E002                  shl eax, 02							; mul eax by 2
:0046C108 57                      push edi
:0046C109 8BF1                    mov esi, ecx
:0046C10B 8B54240C                mov edx, dword ptr [esp+0C]			; mov [Actual Mission No] into edx
:0046C10F 8D0C80                  lea ecx, dword ptr [eax+4*eax]		; mul eax by 5 and mov it into ecx
:0046C112 8B442418                mov eax, dword ptr [esp+18]			; mov [Profile No] into eax
:0046C116 83E00F                  and eax, 0000000F						; mod [Profile No] by 15
:0046C119 8D7C0AFF                lea edi, dword ptr [edx+ecx-01]		; mov edx+ecx-1 into [Magic]	
:0046C11D 83E73F                  and edi, 0000003F						; mod [Magic] by 63
:0046C120 C1E704                  shl edi, 04							; mul [Magic] by 16
:0046C123 33C9                    xor ecx, ecx				
:0046C125 0BF8                    or edi, eax							; or  [Magic] with eax
:0046C127 8B442414                mov eax, dword ptr [esp+14]			; mov [Actual Misssion No] into eax
:0046C12B C1E709                  shl edi, 09							; mul [Magic] by 512
:0046C12E 25FF010000              and eax, 000001FF						; mod [Magic] by 511
:0046C133 0BF8                    or edi, eax							; or  [Magic] with eax
:0046C135 33C0                    xor eax, eax

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C144(C)
|
:0046C137 8BD7                    mov edx, edi							; mov [Magic] into edx
:0046C139 D3FA                    sar edx, cl							; div [Magic] by ecx (starts from 2^0 to 2^20)
:0046C13B 83E201                  and edx, 00000001						; mod [Magic] by 1
:0046C13E 41                      inc ecx								; inc ecx (counter)
:0046C13F 03C2                    add eax, edx							; add [Magic] with eax
:0046C141 83F920                  cmp ecx, 00000020						; check if counter less than 32
:0046C144 72F1                    jb 0046C137
:0046C146 83E001                  and eax, 00000001						; mod eax by 1
:0046C149 333D34195F00            xor edi, dword ptr [005F1934]			; xor [Magic] with ALEX
:0046C14F 81E7FFFF0F00            and edi, 000FFFFF						; mod [Magic] with FFFFF
:0046C155 85C0                    test eax, eax							; check if eax = 0
:0046C157 7408                    je 0046C161
:0046C159 F7D7                    not edi								; not [Magic]
:0046C15B 81E7FFFF0F00            and edi, 000FFFFF						; mod [Magic] with FFFFF

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C157(C)
|
:0046C161 03FF                    add edi, edi							; mul [Magic] by 2
:0046C163 83E001                  and eax, 00000001						; mod eax by 1
:0046C166 0BF8                    or edi, eax							; or [Magic] with eax 
:0046C168 A130195F00              mov eax, dword ptr [005F1930]			; mov L@L@ into eax
:0046C16D 33F8                    xor edi, eax							; xor [Magic] into eax
:0046C16F 8BCE                    mov ecx, esi		
:0046C171 81E7FFFF0F00            and edi, 000FFFFF						; mod [Magic] into FFFFF
:0046C177 8D4610                  lea eax, dword ptr [esi+10]
:0046C17A 50                      push eax
:0046C17B 57                      push edi
:0046C17C E8CF000000              call 0046C250							; call function to generate 1-4 chars of [Mission Password]
:0046C181 8BC7                    mov eax, edi							; mov [Magic] into eax
:0046C183 8BCF                    mov ecx, edi							; mov [Magic] into eax
:0046C185 C1E80A                  shr eax, 0A							; div eax by 1024
:0046C188 C1E90F                  shr ecx, 0F							; div eax by 32678
:0046C18B C1EF05                  shr edi, 05							; div edi by 32
:0046C18E 03C1                    add eax, ecx							; add ecx to eax	
:0046C190 03C7                    add eax, edi							; add edi to eax
:0046C192 5F                      pop edi
:0046C193 83E01F                  and eax, 0000001F						; mod eax by 31
:0046C196 8A8008195F00            mov al, byte ptr [eax+005F1908]		; select char eax from [Table]	
:0046C19C C6461500                mov [esi+15], 00						; append null char at end of [Mission Password]
:0046C1A0 884614                  mov byte ptr [esi+14], al				; mov al into 5th pos of [Mission Password]
:0046C1A3 5E                      pop esi
:0046C1A4 C21000                  ret 0010

_____________________________________________________________________________________________________________________________


* Referenced by a CALL at Address:
|:0046C17C   
|
:0046C250 83EC08                  sub esp, 00000008
:0046C253 B801000000              mov eax, 00000001	
:0046C258 C744240000000000        mov [esp], 00000000
:0046C260 53                      push ebx
:0046C261 56                      push esi
:0046C262 8B742414                mov esi, dword ptr [esp+14]			; mov [Magic] into esi
:0046C266 57                      push edi
:0046C267 55                      push ebp
:0046C268 3BF0                    cmp esi, eax							; check if [Magic] is less or equal to 1
:0046C26A 7619                    jbe 0046C285				

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C283(C)
|
:0046C26C 8D0CC500000000          lea ecx, dword ptr [8*eax+00000000]	; mov 8*eax into ecx
:0046C273 8B542410                mov edx, dword ptr [esp+10]			; mov [Counter] into edx (starts at 0)
:0046C277 2BC8                    sub ecx, eax							; sub eax from ecx
:0046C279 42                      inc edx								; increment [Counter]
:0046C27A 89542410                mov dword ptr [esp+10], edx			; mov edx into [Counter]
:0046C27E 8D0489                  lea eax, dword ptr [ecx+4*ecx]		; mov 5*ecx into eax
:0046C281 3BC6                    cmp eax, esi							; if eax is less than [Magic]
:0046C283 72E7                    jb 0046C26C

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C26A(C)
|
:0046C285 8B4C2410                mov ecx, dword ptr [esp+10]			; mov [Counter] into ecx
:0046C289 49                      dec ecx								; dec ecx
:0046C28A 894C2410                mov dword ptr [esp+10], ecx			; mov [Counter] into ecx
:0046C28E 83F903                  cmp ecx, 00000003						; if [Counter] is greater or equal to 3
:0046C291 7D1F                    jge 0046C2B2
:0046C293 8D5101                  lea edx, dword ptr [ecx+01]			; add [Counter] with 1 and mov into edx
:0046C296 8B7C2420                mov edi, dword ptr [esp+20]		
:0046C29A 83FA03                  cmp edx, 00000003						; check if edx is greater than 3
:0046C29D 7F17                    jg 0046C2B6

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C2AE(C)
|
:0046C29F 8A0D08195F00            mov cl, byte ptr [005F1908]			; mov "P" into cl
:0046C2A5 42                      inc edx								; inc edx
:0046C2A6 83FA03                  cmp edx, 00000003						; check if edx is less or equal to 3
:0046C2A9 90                      nop
:0046C2AA 884C17FF                mov byte ptr [edi+edx-01], cl			; mov cl into nth pos in [Mission Password] (n starts at 4)
:0046C2AE 7EEF                    jle 0046C29F				
:0046C2B0 EB04                    jmp 0046C2B6					

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C291(C)
|
:0046C2B2 8B7C2420                mov edi, dword ptr [esp+20]

* Referenced by a (U)nconditional or (C)onditional Jump at Addresses:
|:0046C29D(C), :0046C2B0(U)
|
:0046C2B6 B923000000              mov ecx, 00000023						; mov 35 into ecx
:0046C2BB 2BD2                    sub edx, edx							; xor edx, edx
:0046C2BD F7F1                    div ecx								; div eax by 23
:0046C2BF 8BD8                    mov ebx, eax							; mov [Quotient] into eax
:0046C2C1 8B4C2410                mov ecx, dword ptr [esp+10]			; mov [Counter] into ecx
:0046C2C5 85C9                    test ecx, ecx							; check if ecx is less than 0
:0046C2C7 7C5F                    jl 0046C328

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C326(C)
|
:0046C2C9 8BC6                    mov eax, esi
:0046C2CB 2BD2                    sub edx, edx							; xor edx, edx
:0046C2CD 33ED                    xor ebp, ebp							; xor ebp, ebp
:0046C2CF 894C2414                mov dword ptr [esp+14], ecx			; mov [Counter] into ecx
:0046C2D3 F7F3                    div ebx								; div eax by ebx
:0046C2D5 0FBEC0                  movsx eax, al							; mov al into eax
:0046C2D8 33D2                    xor edx, edx							; xor edx, edx (charCounter)
:0046C2DA 8A8008195F00            mov al, byte ptr [eax+005F1908]		; select char eax from [Table]
:0046C2E0 880439                  mov byte ptr [ecx+edi], al			; mov al into nth pos in [Mission Password] (n starts at 4)

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C2F1(C)
|
:0046C2E3 8A8A08195F00            mov cl, byte ptr [edx+005F1908]		; select char edx from [Table]
:0046C2E9 3AC8                    cmp cl, al							; check if al is equal to cl
:0046C2EB 740C                    je 0046C2F9			
:0046C2ED 42                      inc edx								; inc charCounter
:0046C2EE 83FA24                  cmp edx, 00000024						; check if charCounter is less than 36
:0046C2F1 7CF0                    jl 0046C2E3
:0046C2F3 8B4C2414                mov ecx, dword ptr [esp+14]			; mov [Counter] into ecx
:0046C2F7 EB09                    jmp 0046C302	

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C2EB(C)
|
:0046C2F9 8B4C2414                mov ecx, dword ptr [esp+14]			; mov [Counter] into ecx
:0046C2FD BD01000000              mov ebp, 00000001						; mov ebp, 1

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C2F7(U)
|
:0046C302 8BC3                    mov eax, ebx							; mov ebx into eax			
:0046C304 85ED                    test ebp, ebp							; check if current char matched
:0046C306 750B                    jne 0046C313
:0046C308 C1E008                  shl eax, 08							; ** NOT NEEDED **
:0046C30B 2BC3                    sub eax, ebx							; ** NOT NEEDED **
:0046C30D F7D8                    neg eax								; ** NOT NEEDED **
:0046C30F 03F0                    add esi, eax							; ** NOT NEEDED **
:0046C311 EB05                    jmp 0046C318							; ** NOT NEEDED **

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C306(C)
|
:0046C313 0FAFC2                  imul eax, edx							; mul eax with charCounter
:0046C316 2BF0                    sub esi, eax							; sub eax from [Magic]

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C311(U)
|
:0046C318 BD23000000              mov ebp, 00000023						; mov 35 into ebp
:0046C31D 8BC3                    mov eax, ebx							; mov ebx into eax
:0046C31F 2BD2                    sub edx, edx							; xor edx, edx
:0046C321 F7F5                    div ebp								; div eax by ebp
:0046C323 8BD8                    mov ebx, eax							; mov [Quotient] into eax
:0046C325 49                      dec ecx								; dec [Counter]
:0046C326 79A1                    jns 0046C2C9							; if [Counter] is less than 0

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C2C7(C)
|
:0046C328 33D2                    xor edx, edx							; ** DELETE FROM THIS BYTE ONWARDS **	
:0046C32A BE01000000              mov esi, 00000001			 	
:0046C32F 33C9                    xor ecx, ecx				 
:0046C331 8B442410                mov eax, dword ptr [esp+10]
:0046C335 3BC1                    cmp eax, ecx
:0046C337 7C54                    jl 0046C38D

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C38B(C)
|
:0046C339 33ED                    xor ebp, ebp
:0046C33B 33DB                    xor ebx, ebx
:0046C33D 8A0439                  mov al, byte ptr [ecx+edi]
:0046C340 894C2414                mov dword ptr [esp+14], ecx

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C352(C)
|
:0046C344 8A8D08195F00            mov cl, byte ptr [ebp+005F1908]
:0046C34A 3AC8                    cmp cl, al
:0046C34C 740C                    je 0046C35A
:0046C34E 45                      inc ebp
:0046C34F 83FD24                  cmp ebp, 00000024
:0046C352 7CF0                    jl 0046C344
:0046C354 8B4C2414                mov ecx, dword ptr [esp+14]
:0046C358 EB09                    jmp 0046C363

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C34C(C)
|
:0046C35A 8B4C2414                mov ecx, dword ptr [esp+14]
:0046C35E BB01000000              mov ebx, 00000001

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C358(U)
|
:0046C363 85DB                    test ebx, ebx
:0046C365 750B                    jne 0046C372
:0046C367 8BC6                    mov eax, esi
:0046C369 2BD6                    sub edx, esi
:0046C36B C1E008                  shl eax, 08
:0046C36E 03D0                    add edx, eax
:0046C370 EB05                    jmp 0046C377

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C365(C)
|
:0046C372 0FAFEE                  imul ebp, esi
:0046C375 03D5                    add edx, ebp

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C370(U)
|
:0046C377 8D04F500000000          lea eax, dword ptr [8*esi+00000000]
:0046C37E 41                      inc ecx
:0046C37F 2BC6                    sub eax, esi
:0046C381 8B5C2410                mov ebx, dword ptr [esp+10]
:0046C385 3BD9                    cmp ebx, ecx
:0046C387 90                      nop
:0046C388 8D3480                  lea esi, dword ptr [eax+4*eax]
:0046C38B 7DAC                    jge 0046C339

* Referenced by a (U)nconditional or (C)onditional Jump at Address:
|:0046C337(C)
|
:0046C38D 5D                      pop ebp
:0046C38E 5F                      pop edi
:0046C38F 5E                      pop esi
:0046C390 5B                      pop ebx
:0046C391 83C408                  add esp, 00000008
:0046C394 C20800                  ret 0008
```