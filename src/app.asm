.386
.model flat, stdcall
option casemap :none

include \MASM32\include\windows.inc
include \MASM32\include\kernel32.inc
include \MASM32\include\user32.inc
include \MASM32\include\masm32.inc

includelib \MASM32\lib\kernel32.lib
includelib \MASM32\lib\user32.lib
includelib \MASM32\lib\masm32.lib

dlgProc proto :DWORD, :DWORD, :DWORD, :DWORD
keyGen  proto :DWORD, :DWORD, :DWORD

.data
    magOne      dd  414C4558h          
    magTwo      dd  4C404C40h          
    table       db "P4JBCN3YV8FGH2IA6KLT1XWDMO7Q9ER5SUZ",0
    dlgName     db "DLGBOX",0

.data?
    magLast     dd ?
    counter     dd ?
    hInst       HINSTANCE ?
    hProfile    HWND ?
    hLevel      HWND ?
    profileNo   dd ?
    levelNo     dd ?
    levelText   db 6 dup(?)

.const
    IDI_APP         equ 200
    IDC_PROFILENUM  equ 1000
    IDC_CALCULATE   equ 1001
    IDC_LEVELNUM    equ 1002
    IDC_LEVELKEY    equ 1003
    IDC_EXIT        equ 1004

.code

start:
    invoke GetModuleHandle, NULL
    mov hInst, eax
    invoke DialogBoxParam, hInst, ADDR dlgName, NULL, ADDR dlgProc, NULL
    invoke ExitProcess, NULL

dlgProc proc hwndDlg:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    .IF uMsg == WM_INITDIALOG
        invoke LoadIcon, hInst, IDI_APP
        invoke SendMessage, hwndDlg, WM_SETICON, ICON_BIG, eax
        invoke GetDlgItem, hwndDlg, IDC_PROFILENUM
        mov hProfile, eax
        jmp AddProfileNum
            proItem1 db "00 - Default User Profile",0
            proItem2 db "01 - 1st User Profile",0
            proItem3 db "02 - 2nd User Profile",0
            proItem4 db "03 - 3rd User Profile",0
            proItem5 db "04 - 4th User Profile",0
            proItem6 db "05 - 5th User Profile",0
            proItem7 db "06 - 6th User Profile",0
            proItem8 db "07 - 7th User Profile",0
            proItem9 db "08 - 8th User Profile",0
            proItem10 db "09 - 9th User Profile",0
            proItem11 db "10 - 10th User Profile",0    
        AddProfileNum:
        invoke SendMessage, hProfile, CB_RESETCONTENT, 0,0
        invoke SendMessage, hProfile, CB_ADDSTRING, 0, ADDR proItem1 
        invoke SendMessage, hProfile, CB_ADDSTRING, 0, ADDR proItem2
        invoke SendMessage, hProfile, CB_ADDSTRING, 0, ADDR proItem3
        invoke SendMessage, hProfile, CB_ADDSTRING, 0, ADDR proItem4
        invoke SendMessage, hProfile, CB_ADDSTRING, 0, ADDR proItem5
        invoke SendMessage, hProfile, CB_ADDSTRING, 0, ADDR proItem6
        invoke SendMessage, hProfile, CB_ADDSTRING, 0, ADDR proItem7
        invoke SendMessage, hProfile, CB_ADDSTRING, 0, ADDR proItem8
        invoke SendMessage, hProfile, CB_ADDSTRING, 0, ADDR proItem9
        invoke SendMessage, hProfile, CB_ADDSTRING, 0, ADDR proItem10
        invoke SendMessage, hProfile, CB_ADDSTRING, 0, ADDR proItem11
        invoke SendMessage, hProfile, CB_SETCURSEL, 0, 0
        invoke GetDlgItem, hwndDlg, IDC_LEVELNUM
        mov hLevel, eax
        jmp AddLevelNum
            lvlItem1 db "02 - A Quiet Blow-Up",0
            lvlItem2 db "03 - Reverse Engineering",0
            lvlItem3 db "04 - Restore Pride",0
            lvlItem4 db "05 - Blind Justice",0
            lvlItem5 db "06 - Menace of the Leopold",0
            lvlItem6 db "07 - Chase of the Wolves",0
            lvlItem7 db "08 - Pyrotechnics",0
            lvlItem8 db "09 - A Courtesy Call",0
            lvlItem9 db "10 - Operation Icarus",0
            lvlItem10 db "11 - In the Soup",0
            lvlItem11 db "12 - Up on the Roof",0   
            lvlItem12 db "13 - David & Goliath",0
            lvlItem13 db "14 - D-Day Kick Off",0
            lvlItem14 db "15 - The End of the Butcher",0
            lvlItem15 db "16 - Stop Wildfire",0
            lvlItem16 db "17 - Before Dawn",0
            lvlItem17 db "18 - The Force of Circumstance",0
            lvlItem18 db "19 - Frustrate Retaliation",0
            lvlItem19 db "20 - Operation Valhalla",0
        AddLevelNum:
        invoke SendMessage, hLevel, CB_RESETCONTENT, 0,0
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem1 
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem2
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem3
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem4
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem5
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem6
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem7
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem8
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem9
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem10
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem11
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem12
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem13
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem14
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem15
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem16
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem17
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem18
        invoke SendMessage, hLevel, CB_ADDSTRING, 0, ADDR lvlItem19
        invoke SendMessage, hLevel, CB_SETCURSEL, 0, 0
        invoke SetFocus, hProfile
    .ELSEIF uMsg == WM_CLOSE
        invoke SendMessage, hwndDlg, WM_COMMAND, IDC_EXIT, NULL
    .ELSEIF uMsg == WM_COMMAND
        .IF wParam == IDC_EXIT
            invoke EndDialog, hwndDlg, NULL
        .ELSEIF wParam == IDC_CALCULATE
            invoke SendMessage, hLevel, CB_GETCURSEL, 0, 0
            add eax, 2
            mov levelNo, eax
            invoke SendMessage, hProfile, CB_GETCURSEL, 0, 0
            invoke keyGen, eax, levelNo, ADDR levelText
            invoke SetDlgItemText, hwndDlg, IDC_LEVELKEY, ADDR levelText
            invoke GetDlgItem, hwndDlg, IDC_LEVELKEY
            invoke SetFocus, eax
        .ENDIF
    .ELSE
        mov eax, FALSE
        ret
    .ENDIF
    mov eax, TRUE
    ret
dlgProc endp

keyGen proc uses ebx ecx edx esi edi ebp profileNum:DWORD, levelNum:DWORD, levelKey:DWORD
    mov esi, levelKey       
    add esi, 3              
    mov edx, levelNum       
    dec edx              
    mov eax, 1
    shl eax, 2
    lea ecx, dword ptr [eax+4*eax]
    lea edi, dword ptr [edx+ecx-1]       
    mov eax, profileNum     
    and eax, 0Fh            
    and edi, 3Fh            
    shl edi, 4              
    or edi, eax             
    and edx, 01FFh          
    shl edi, 9              
    or edi, edx             
    xor eax, eax            
    xor ecx, ecx            
CalculateSomething:
    mov edx, edi            
    sar edx, cl             
    and edx, 1              
    inc ecx                 
    add eax, edx            
    cmp ecx, 20h            
    jb CalculateSomething
    and eax, 1              
    xor edi, magOne
    and edi, 0FFFFFh
    test eax, eax
    je FinishMagic
    ;invoke MessageBox, NULL, ADDR errText, ADDR errText, MB_ICONINFORMATION
    not edi
    and edi, 0FFFFFh            
FinishMagic:
    shl edi, 1
    and eax, 1
    or edi, eax
    xor edi, magTwo
    and edi, 0FFFFFh
    mov magLast, edi
    mov eax, 1
    xor edx, edx
    cmp edi, eax
    jbe FinishQuotient
CalculateQuotient:
    lea ecx, dword ptr [8*eax]
    sub ecx, eax
    inc edx
    lea eax, dword ptr [ecx+4*ecx]
    cmp eax, edi
    jb CalculateQuotient
FinishQuotient:
    dec edx
    mov counter, edx
    cmp edx, 3
    jge InitFour
FillChars:
    mov cl, [table+0]
    inc edx
    mov byte ptr [esi], cl
    dec esi
    cmp edx, 3    
    jl FillChars
    jmp InitFour
InitFour:            
    mov ecx, 23h
    xor edx, edx
    div ecx
    mov ebx, eax
    mov ecx, counter
CalculateFour:    
    mov eax, edi
    xor ebp, ebp
    mov counter, ecx
    xor edx, edx
    div ebx
    movsx eax, al
    xor edx, edx
    mov al, byte ptr [eax+table]
    mov byte ptr [esi], al
Compare:    
    mov cl, byte ptr [edx+table]
    cmp cl, al
    je NextCharInit
    inc edx
    cmp edx, 24h
    jl Compare
    mov ecx, counter
    jmp NextTryInit
NextCharInit:
    mov ecx, counter
    mov ebp, 1
    dec esi
NextTryInit:
    mov eax, ebx
    test ebp, ebp
    jne NextChar
    shl eax, 8
    sub eax, ebx
    neg eax
    add edi, eax
    jmp NextTry
NextChar:
    imul eax, edx
    sub edi, eax
NextTry:
    mov ebp, 23h
    mov eax, ebx
    xor edx, edx
    div ebp
    mov ebx, eax
    dec ecx
    cmp ecx, -1
    jne CalculateFour 
    mov edi, magLast
    mov eax, edi
    mov ecx, edi
    shr eax, 0Ah
    shr ecx, 0fh
    shr edi, 5
    add eax, ecx
    add eax, edi
    and eax, 01Fh
    mov al, byte ptr [eax+table]
    mov byte ptr [esi+5], al
    mov byte ptr [esi+6], 0
    ret            
keyGen endp

end start


