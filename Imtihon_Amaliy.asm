INCLUDE "EMU8086.INC"
ORG 100H
    MOV CX, 4
    
    ; SALOM DEB AYTYAPMIZ
    PRINT "ASSALOMU ALEYKUM TEMUR RAVSHANOV SIZ YANGI KARTAGA PAROL O'RNATISHINGIZ KERAK !"
    PRINTN
    PRINT "ILTIMOS YANGI PAROLNI KIRITING: " 
    
   INPUT_LOOP:
   
        MOV AH, 07H                 ; TUGMANI BOSISHNI KUTAMIZ (EKRANGA CHIQMAYDI)
        INT 21H                     
        CMP AL, 48                 ; 0 DAN KICHIKMI?
        JB INPUT_LOOP               
        CMP AL, 57                 ; 9 DAN KATTAMI?
        JA INPUT_LOOP               
        MOV PASSWORD[SI], AL       ; PAROLGA SAQLAYMIZ
        MOV AH, 02H                ; EKRANGA CHIQARISH UCHUN
        MOV DL, '*'                ; YULDUZCHA CHIQARAMIZ
        INT 21H                     
        INC SI                     ; KEYINGI BELGIGA O'TAMIZ
                          
    LOOP INPUT_LOOP

    MOV CX, 4
    
    ; PAROL O'RNATILGANINI AYTYAPMIZ
    PRINTN
    PRINT "PAROL MUVOFFAQIYATLI O'RNATILDI !"
    MOV AH, 00H 
    MOV AL, 03H
    INT 10H                    ; EKRANNI TOZALAYMIZ
    PRINT "ILTIMOS PAROLNI KIRITING: "
    
    PASSWORD_CHECK:
        
        MOV AH, 07H                ; PAROLNI KIRITISHNI KUTAMIZ
        INT 21H   
        CMP AL, 48                 ; 0 DAN KICHIKMI?
        JB PASSWORD_CHECK               
        CMP AL, 57                 ; 9 DAN KATTAMI?
        JA PASSWORD_CHECK  
        MOV BL, PASSWORD[DI]       ; SAQLANGAN PAROL BILAN SOLISHTIRAMIZ
        CMP AL, BL 
        JNZ ERROR                  ; XATO BO'LSA ERRORGA O'TAMIZ
        MOV AH, 02H                
        MOV DL, "*"                ; YULDUZCHA CHIQARAMIZ
        INT 21H
        INC DI                     ; KEYINGI BELGIGA O'TAMIZ
                     
    LOOP PASSWORD_CHECK
    
    JMP HOME ; PAROL TO'G'RI BO'LSA HOMEGA SAKRAYMIZ
    
    ERROR:     
        
        MOV AH, 02H
        MOV DL, ' '                ; BO'SH JOY QO'YAMIZ
        INT 21H
        INC COUNT                  ; XATO URINISHNI SANAYMIZ
        CMP COUNT, 3               ; 3 MARTAMI XATO KIRITILDI?
        JA EXIT_MESSAGE            ; AGAR 3 DAN KO'P BO'LSA EXIT_MESSAGE GA O'TAMIZ
        MOV AH, 00H
        MOV AL, 03H
        INT 10H                    ; EKRANNI TOZALAYMIZ
        PRINT "SIZ XATO PAROL KIRITDINGIZ !"
        PRINTN
        PRINT "QAYTA URINMOQCHI BOLSANGIZ ENTERNI BOSING !"
        MOV AH, 07H                
        INT 21H
        CMP AL, 0DH                ; ENTER BOSILDIMI?
        JNZ RESET                  ; YO'Q BO'LSA RESETGA O'TAMIZ
         
        MOV AH, 00H 
        MOV AL, 03H
        INT 10H                    ; EKRANNI TOZALAYMIZ
        MOV DI, 0 
        MOV CX, 4
        PRINT "ILTIMOS PAROLNI KIRITING: " ; QAYTA KIRITISHNI SO'RAYMIZ
        JMP PASSWORD_CHECK
        
    RESET:
                         
        MOV CX, 3
                                
        LOOP_RESET:
        
            MOV AH, 00H
            MOV AL, 03H
            INT 10H                ; EKRANNI TOZALAYMIZ
            PRINT "SIZ MAVJUD BO'LMAGAN BUYRUQNI KIRITDINGIZ !" 
            PRINTN
            PRINTN "ORTGA QAYTISH UCHUN ENTERNI BOSING !"
            MOV AH, 07H                
            INT 21H
            CMP AL, 0DH            ; ENTER BOSILDIMI?
            JE ERROR               ; HA BO'LSA ERRORGA QAYTAMIZ
                    
        LOOP LOOP_RESET
        
    EXIT_MESSAGE:
            
        MOV AH, 00H
        MOV AL, 03H
        INT 10H                    ; EKRANNI TOZALAYMIZ
        PRINT "AKA ODAMNI UNDAY O'YIN QILMANGDA 3 MARTTA HAM ADASHADIMI ODAM !"
        JMP EXIT
    
    HOME:
        
        MOV AH, 00H
        MOV AL, 03H
        INT 10H                    ; EKRANNI TOZALAYMIZ
        PRINT "XALQBAKI BANKOMATIGA XUSH KELIBSIZ !"
        PRINTN
        PRINTN
        PRINT "+-----------------------+" ; MENU USTI
        PRINTN
        PRINT "| 1 | HISOBNI TEKSHIRISH |"
        PRINTN
        PRINT "| 2 | NAQD PUL OLISH     |"
        PRINTN
        PRINT "| 3 | SMS HABARNOMA      |"   ; MENU QATORLARI
        PRINTN
        PRINT "| 4 | PAROL ALMASHTIRISH |"
        PRINTN 
        PRINT "| 5 | KARTA MALUMOTLARI  |"
        PRINTN
        PRINT "+-----------------------+" ; MENU PASTI
        PRINTN    
        PRINTN
        PRINT "KERAKLI BO'LIMNI TANLANG: "
        MOV AH, 1
        INT 21H                    ; TANLOVNI KIRITAMIZ
        MOV CHOOSE, AL
        CMP CHOOSE, 49             ; 1 MI?
        JZ HISOBNI_TEKSHIRISH
        CMP CHOOSE, 50             ; 2 MI?
        JZ NAQD_PUL_OLISH
        CMP CHOOSE, 51             ; 3 MI?
        JZ SMS_HABARNOMA
        CMP CHOOSE, 52             ; 4 MI?
        JZ PAROL_ALMASHTIRISH
        CMP CHOOSE, 53             ; 5 MI?
        JZ KARTA_MALUMOTLARI                   
        
    HISOBNI_TEKSHIRISH:
        
        MOV AH, 00H
        MOV AL, 03H
        INT 10H                    ; EKRANNI TOZALAYMIZ
        PRINT "+-----------------------+" ; KARTA USTI
        PRINTN
        PRINT "| 1234-****-****-3456   |"  ; FAQAT BO'SHI VA OXIRI KO'RINADI
        PRINTN
        PRINT "+-----------------------+" ; KARTA PASTI
        PRINTN
        PRINTN
        PRINT "MAVJUD SUMMA: ****"       ; DASTLAB YULDUZCHALAR CHIQARAMIZ
        PRINTN
        PRINT "SUMMANI KO'RISH UCHUN * BOSING, ORTGA QAYTISH UCHUN ENTERNI BOSING !"
        MOV AH, 07H
        INT 21H                    ; TUGMANI KUTAMIZ
        CMP AL, 0DH                ; ENTER BOSILDIMI?
        JE HOME                    ; HA BO'LSA HOMEGA QAYTAMIZ
        CMP AL, '*'                ; * BOSILDIMI?
        JNE HISOBNI_TEKSHIRISH     ; YO'Q BO'LSA QAYTA SO'RAYMIZ
        
        ; * BOSILSA SUMMANI CHIQARAMIZ
        MOV AH, 00H
        MOV AL, 03H
        INT 10H                    ; EKRANNI TOZALAYMIZ
        PRINT "+-----------------------+" ; KARTA USTI
        PRINTN
        PRINT "| 1234-****-****-3456   |"  ; FAQAT BO'SHI VA OXIRI KO'RINADI
        PRINTN
        PRINT "+-----------------------+" ; KARTA PASTI
        PRINTN
        PRINTN
        PRINT "MAVJUD SUMMA: "
        MOV AX, SUMMA
        CALL PRINT_NUMBER          ; SUMMANI CHIQARAMIZ
        PRINT " SO'M"  
        PRINTN
        PRINT "ORTGA QAYTISH UCHUN ENTERNI BOSING !"
        MOV AH, 07H
        INT 21H
        CMP AL, 0DH                ; ENTER BOSILDIMI?
        JE HOME
        JNE EXIT
        
    NAQD_PUL_OLISH:
        
        MOV AH, 00H
        MOV AL, 03H
        INT 10H                    ; EKRANNI TOZALAYMIZ
        PRINT "+-----------------------+" ; KARTA USTI
        PRINTN
        PRINT "| 1234-****-****-3456   |"  ; FAQAT BO'SHI VA OXIRI KO'RINADI
        PRINTN
        PRINT "+-----------------------+" ; KARTA PASTI
        PRINTN
        PRINTN
        PRINT "YECHIB OLMOQCHI BO'LGAN SUMMANGIZNI KIRITING:       { ESLATMA: KAMISSIYA 1% }"               
        PRINTN
        MOV AH, 0AH
        LEA DX, YECHILADIGAN_SUMMA ; SUMMANI KIRITAMIZ
        INT 21H
        
        ; KIRITILGAN SUMMANI RAQAMGA AYLANTIRAMIZ
        MOV SI, 2
        XOR AX, AX
        XOR BX, BX
    CONVERT_LOOP:
        MOV BL, YECHILADIGAN_SUMMA[SI]
        CMP BL, 0DH                ; ENTER BOSILDIMI?
        JE END_CONVERT
        SUB BL, 30H                ; ASCII DAN RAQAMGA
        MUL TEN                    ; 10 GA KO'PAYTIRAMIZ
        ADD AX, BX                 ; RAQAMNI QO'SHAMIZ
        INC SI                     ; KEYINGI BELGIGA
        JMP CONVERT_LOOP
    END_CONVERT:
        MOV BX, AX                 ; KIRITILGAN SUMMA BX DA
        
        ; KAMISSIYA HISOBLAYMIZ (1%)
        MOV DX, 0
        MOV CX, 100
        DIV CX                     ; AX = BX / 100 (KAMISSIYA)
        ADD BX, AX                 ; BX = SUMMA + KAMISSIYA
        
        ; SUMMA DAN AYIRAMIZ
        CMP BX, SUMMA              ; YETARLIMI?
        JA NOT_ENOUGH              ; YO'Q BO'LSA XATO
        SUB SUMMA, BX              ; SUMMANI KAMAYTIRAMIZ
        
        PRINTN
        PRINT "OPERATSIYA MUVOFFAQIYATLI BAJARILDI!"
        PRINTN
        PRINT "YECHILGAN SUMMA (KAMISSIYA BILAN): "
        MOV AX, BX
        CALL PRINT_NUMBER          ; YECHILGAN SUMMANI CHIQARAMIZ
        PRINT " SO'M"
        PRINTN
        PRINT "QOLGAN SUMMA: "
        MOV AX, SUMMA
        CALL PRINT_NUMBER          ; QOLGAN SUMMANI CHIQARAMIZ
        PRINT " SO'M"
        PRINTN
        PRINT "ORTGA QAYTISH UCHUN ENTERNI BOSING !"
        MOV AH, 07H
        INT 21H
        CMP AL, 0DH                ; ENTER BOSILDIMI?
        JE HOME
        JMP EXIT
        
    NOT_ENOUGH:
        PRINTN
        PRINT "XATO: HISOBDA YETARLI PUL MAVJUD EMAS!"
        PRINTN
        PRINT "ORTGA QAYTISH UCHUN ENTERNI BOSING !"
        MOV AH, 07H
        INT 21H
        CMP AL, 0DH                ; ENTER BOSILDIMI?
        JE HOME
        
    SMS_HABARNOMA:
        MOV AH, 00H
        MOV AL, 03H
        INT 10H                    ; EKRANNI TOZALAYMIZ
        PRINT "SMS HABARNOMA UCHUN TELEFON RAQAMINGIZNI KIRITING (MASALAN: 901234567): "
        PRINTN
        MOV AH, 0AH
        LEA DX, PHONE_NUMBER       ; TELEFON RAQAMINI KIRITAMIZ
        INT 21H
        
        PRINTN
        PRINT "TELEFON RAQAMI MUVOFFAQIYATLI SAQLANDI!"
        MOV PHONE_SET, 1           ; TELEFON RAQAMI SAQLANGANINI BELGILAYMIZ
        PRINTN
        PRINT "ORTGA QAYTISH UCHUN ENTERNI BOSING !"
        MOV AH, 07H
        INT 21H
        CMP AL, 0DH                ; ENTER BOSILDIMI?
        JE HOME
        JMP EXIT
        
    PAROL_ALMASHTIRISH:
        MOV AH, 00H
        MOV AL, 03H
        INT 10H                    ; EKRANNI TOZALAYMIZ
        PRINT "YANGI PAROLNI KIRITING: "
        MOV SI, 0
        MOV CX, 4
    NEW_PASSWORD_LOOP:
        MOV AH, 07H                ; YANGI PAROLNI KIRITAMIZ
        INT 21H
        CMP AL, 48                 ; 0 DAN KICHIKMI?
        JB NEW_PASSWORD_LOOP
        CMP AL, 57                 ; 9 DAN KATTAMI?
        JA NEW_PASSWORD_LOOP
        MOV PASSWORD[SI], AL       ; YANGI PAROLNI SAQLAYMIZ
        MOV AH, 02H
        MOV DL, '*'                ; YULDUZCHA CHIQARAMIZ
        INT 21H
        INC SI                     ; KEYINGI BELGIGA
        LOOP NEW_PASSWORD_LOOP
        
        PRINTN
        PRINT "YANGI PAROL MUVOFFAQIYATLI O'RNATILDI!"
        PRINTN
        PRINT "ORTGA QAYTISH UCHUN ENTERNI BOSING !"
        MOV AH, 07H
        INT 21H
        CMP AL, 0DH                ; ENTER BOSILDIMI?
        JE RELOGIN                 ; YANGI PAROL BILAN QAYTA KIRAMIZ
        
    RELOGIN:
        MOV AH, 00H
        MOV AL, 03H
        INT 10H                    ; EKRANNI TOZALAYMIZ
        PRINT "ILTIMOS PAROLNI KIRITING: "
        MOV DI, 0
        MOV CX, 4
        JMP PASSWORD_CHECK         ; YANGI PAROL BILAN TEKSHIRAMIZ
        
    KARTA_MALUMOTLARI:
        MOV AH, 00H
        MOV AL, 03H
        INT 10H                    ; EKRANNI TOZALAYMIZ
        PRINT "+-----------------------+" ; KARTA USTI
        PRINTN
        PRINT "| 1234-5678-9012-3456   |"  ; TO'LIQ KARTA RAQAMI FAQAT BU YERDA
        PRINTN
        PRINT "| VALID: 03/27          |"  ; AMAL QILISH MUDDATI
        PRINTN
        PRINT "| TEMUR RAVSHANOV       |"  ; ISM
        PRINTN
        PRINT "| PHONE: "                  ; TELEFON RAQAMINI CHIQARAMIZ
        CMP PHONE_SET, 1           ; TELEFON RAQAMI SAQLANGANMI?
        JE PRINT_PHONE_NUMBER      ; HA BO'LSA CHIQARAMIZ
        PRINT "ULANMAGAN      " ; YO'Q BO'LSA ULANMAGAN DEB CHIQARAMIZ
        JMP SKIP_PHONE
    PRINT_PHONE_NUMBER:
        MOV SI, 2
    PRINT_PHONE:
        MOV DL, PHONE_NUMBER[SI]
        CMP DL, 0DH                ; ENTER BILAN TUGADIMI?
        JE END_PHONE
        MOV AH, 02H
        INT 21H                    ; RAQAMNI CHIQARAMIZ
        INC SI
        JMP PRINT_PHONE
    END_PHONE:
        PRINT "      "         ; BO'SH JOY QO'SHIB, QATORNI TO'G'RILAYMIZ
    SKIP_PHONE:
        PRINT "|"
        PRINTN
        PRINT "+-----------------------+" ; KARTA PASTI
        PRINTN
        PRINTN
        PRINT "ORTGA QAYTISH UCHUN ENTERNI BOSING !"
        MOV AH, 07H
        INT 21H
        CMP AL, 0DH                ; ENTER BOSILDIMI?
        JE HOME
        JMP EXIT

EXIT:            
RET 
  
    PASSWORD DB 4 DUP(?)           ; PAROL UCHUN JOY
    COUNT DB 0                     ; XATO URINISHLAR SONI
    CHOOSE DB ?                    ; TANLOV UCHUN O'ZGARUVCHI
    SUMMA DW 65000                 ; HISOBDAGI PUL
    YECHILADIGAN_SUMMA DB 6, ?, 6 DUP(0) ; YECHILADIGAN SUMMA UCHUN BUFER
    PHONE_NUMBER DB 12, ?, 12 DUP(0) ; TELEFON RAQAMI UCHUN BUFER
    PHONE_SET DB 0                 ; TELEFON RAQAMI SAQLANGANMI YO'QMI BELGISI
    TEN DW 10                      ; 10 LIK UCHUN KONSTANTA

; RAQAMNI CHIQARISH UCHUN FUNKSIYA
PRINT_NUMBER PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV BX, 10
    XOR CX, CX                 ; RAQAMLAR SONINI SANAYMIZ
    
    ; RAQAMNI BO'LISH ORQALI AJRATAMIZ
DIVIDE_LOOP:
    XOR DX, DX
    DIV BX                     ; AX = AX / 10, DX = QOLDIQ
    ADD DL, 30H                ; QOLDIQNI ASCII GA AYLANTIRAMIZ
    PUSH DX                    ; QOLDIQNI STACKKA SAQLAYMIZ
    INC CX                     ; RAQAMLAR SONINI OSHIRAMIZ
    CMP AX, 0
    JNE DIVIDE_LOOP
    
    ; STACKDAN RAQAMLARNI CHIQARAMIZ
PRINT_LOOP:
    POP DX
    MOV AH, 02H
    INT 21H                    ; EKRANGA CHIQARAMIZ
    LOOP PRINT_LOOP
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_NUMBER ENDP

END