; =============================================================================
;  IST-TagusPark
;
;  Projeto Arquitetura de Computadores
;
;  Grupo 10: Bernardo Galante: 102423 
;            Daniel Pinto: 102518 
;            Henrique Machado: 103266
;
;  Controlos:
;            Tecla 0: movimentar a nave para a esquerda 
;            Tecla 1: disparar míssil
;            Tecla 2: movimentar a nave para a direita 
;            Tecla C: Inicia o jogo
;            Tecla D: Suspende/Retoma o jogo
;            Tecla E: Termina o jogo
;
; =============================================================================
; =============================================================================
; *                                   Constantes                              *
; =============================================================================
DISPLAYS            EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN             EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL             EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
ULTIMA_LINHA        EQU 8       ; ultima linha do teclado 1000B

DEFINE_LINHA        EQU 600AH   ; endereço do comando para definir a linha
DEFINE_COLUNA       EQU 600CH   ; endereço do comando para definir a coluna
DEFINE_PIXEL        EQU 6012H   ; endereço do comando para escrever um pixel  

TOCA_SOM            EQU 605AH   ; endereço do comando para fazer playback de um som 
TERMINA_SOM         EQU 6066H   ; endereço do comando para terminar o playback de um som 
PAUSA_SOM           EQU 605EH   ; endereço do comando para parar a reproducao de um som 
RETOMA_SOM          EQU 6064H   ; endereço do comando para retomar a reproducao de um som 

APAGA_ECRA          EQU 6002H   ; endereço para apagar todos os pixels ligados
APAGA_AVISO         EQU 6040H   ; endereço do comando para apagar o aviso de nenhum cenário selecionado
SELECIONA_ECRA      EQU 6004H   ; endereço do comando para selecionar o ecra no media center
MOSTRA_ECRA         EQU 6006H   ; endereço do comando para mostrar o ecra do media center
ESCONDE_ECRA        EQU 6008H   ; endereço do comando para esconder o ecra do media center
FUNDO_ECRA          EQU 6042H   ; endereço do comando para selecionar uma imagem de fundo

MUSICA_INICIO       EQU 0       ; posicao da primeira musica no media center 
EFEITO_DISPARO      EQU 1       ; posicao do efeito sonoro do disparo do míssil no media center 
EFEITO_EXPLOSAO     EQU 2       ; posicao do efeito sonoro da explosao no media center 
EFEITO_ABSORVE      EQU 3       ; posicao do efeito sonoro da absorção de meteoro bom no media center 

CENARIO_MENU        EQU 0       ; posicao do cenario inicial no media center
CENARIO_JOGO        EQU 1       ; posicao do cenario principal no media center
CENARIO_PAUSA       EQU 2       ; posicao do cenario da pausa no media center
CENARIO_TERMINA     EQU 3       ; posicao do cenario de jogo terminado no media center
CENARIO_GAME_OVER   EQU 4       ; posicao do cenario de jogo perdido no media center
CENARIO_GAME_OVER_ENERGIA EQU 5 ; posicao do cenario de jogo perdido por falta de energia no media center

MAX_LINHA           EQU 31      ; valor máximo das linhas no display
MIN_LINHA           EQU 0       ; valor mínimo das linhas no display
MAX_COLUNA          EQU 63      ; valor máximo das colunas no display
MIN_COLUNA          EQU 0       ; valor mínimo das colunas no display  
LIMITE_INFERIOR     EQU 29      ; valor máximo do display para os meteoros 5x5

MASCARA             EQU 0FH     ; mascara 0000 1111
MASCARA_2           EQU 0F0H    ; mascara 1111 0000

; cor pixels (ARGB)
RED                 EQU 0FF00H  ; cor pixel vermelho
DARK_RED            EQU 0FB00H  ; cor pixel vermelho
DARK_GREEN          EQU 0F0B0H  ; cor pixel verde escuro
DARKER_GREEN        EQU 0F070H  ; cor pixel verde ainda mais escuro
GREY                EQU 0F555H  ; cor pixel cinzento
PINK                EQU 0FF55H  ; cor pixel rosa
PURPLE              EQU 0F746H  ; cor pixel roxo
GREEN               EQU 0F0F0H  ; cor pixel verde
ORANGE              EQU 0FFA2H  ; cor pixel laranja
YELLOW              EQU 0FFE4H  ; cor pixel amarelo
WHITE               EQU 0FFFFH  ; cor pixel branco
MILITARY_GREEN      EQU 0F450H  ; cor pixel cinzento leve
LIGHT_GREEN         EQU 0F0F3H  ; cor pixel verde claro
LIGHT_ORANGE        EQU 0FFC1H  ; cor pixel laranja leve
LIGHT_RED           EQU 0FF52H  ; cor pixel vermelho leve
LIGHT_PINK          EQU 0FF55H  ; cor pixel rosa leve
LIGHT_BLUE          EQU 0F0FFH  ; cor pixel azul claro

; constantes dos bonecos
ALTURA_METEORO      EQU 5
LARGURA_METEORO     EQU 5

ALTURA_ROVER        EQU 4
LARGURA_ROVER       EQU 5

ALTURA_MISSIL       EQU 1
LARGURA_MISSIL      EQU 1

LINHA_ROVER         EQU 27
COLUNA_ROVER        EQU 29
MAX_COLUNA_ROVER    EQU 59      ; valor máximo das colunas do rover

LINHA_METEORO       EQU 0
COLUNA_METEORO      EQU 29

LINHA_MISSIL        EQU 26

DIRECAO_ESQUERDA    EQU -1
DIRECAO_DIREITA     EQU 1

ENERGIA_INICIAL     EQU 64H
DECREMENTA_ENERGIA  EQU -5
INCREMENTA_ENERG5   EQU 5
INCREMENTA_ENERG10  EQU 10

FORA_ECRA           EQU -1

MUDA_TAMANHO_1      EQU 1
MUDA_TAMANHO_2      EQU 4
MUDA_TAMANHO_3      EQU 8
MUDA_TAMANHO_4      EQU 13

; ecras
ECRA_MENU           EQU 0
ECRA_JOGO           EQU 1
ECRA_PAUSA          EQU 2
ECRA_TERMINA        EQU 3
ECRA_GAME_OVER      EQU 4

; =============================================================================
; *                                 Zona de Dados                             *
; =============================================================================
PLACE           1000H

                STACK 200H  ; espaço reservado para a pilha 
SP_inicial:                 ; = 1400H (200H words)

relogios: 
    WORD        relogio_meteoro
    WORD        relogio_missil
    WORD        relogio_energia

energia_rover:
    WORD        ENERGIA_INICIAL

jogo_iniciado:
    WORD        0       ; 0 se não comecou, 1 se já comecou

jogo_pausado:
    WORD        0       ; 0 se está a decorrer, 1 se está em pausa

missil_disparado:
    WORD        0       ; 0 se não há míssil no ecrã, 1 se há

meteoro_bom_ou_mau:
    WORD        0       ; 0 se o meteoro for mau, 1 se for bom 

posicao_rover:
    WORD        COLUNA_ROVER
    WORD        LINHA_ROVER

posicao_missil:
    WORD        FORA_ECRA, LINHA_ROVER      ; coluna, linha

posicao_explosao:
    WORD        FORA_ECRA, FORA_ECRA        ; coluna, linha

posicao_meteoro:
    WORD        COLUNA_METEORO
    WORD        LINHA_METEORO

rover:                 
    WORD        ALTURA_ROVER, LARGURA_ROVER
    WORD        0, 0, ORANGE, 0, 0
    WORD        0, LIGHT_ORANGE, YELLOW, LIGHT_ORANGE, 0
    WORD        RED, LIGHT_RED, YELLOW, LIGHT_RED, RED
    WORD        0, LIGHT_PINK, 0, LIGHT_PINK, 0

meteoro_1x1:
    WORD        1, 1
    WORD        GREY

meteoro_2x2:
    WORD        2, 2
    WORD        GREY, GREY
    WORD        GREY, GREY

meteoro_mau_3x3:
    WORD        3, 3
    WORD        0, LIGHT_RED, 0
    WORD        LIGHT_RED, DARK_RED, LIGHT_RED
    WORD        0, LIGHT_RED, 0

meteoro_bom_3x3:
    WORD        3, 3
    WORD        0, GREEN, 0
    WORD        GREEN, DARKER_GREEN, GREEN
    WORD        0, GREEN, 0
    
meteoro_mau_4x4:                
    WORD        4, 4
    WORD        0, DARK_RED, RED, 0
    WORD        RED, PURPLE, PINK, DARK_RED
    WORD        DARK_RED, LIGHT_RED, PURPLE, RED
    WORD        0, RED, DARK_RED, 0

meteoro_bom_4x4:
    WORD        4, 4
    WORD        0, DARKER_GREEN, DARK_GREEN, 0
    WORD        GREEN, MILITARY_GREEN, LIGHT_GREEN, DARKER_GREEN
    WORD        DARKER_GREEN, GREEN, MILITARY_GREEN, DARK_GREEN
    WORD        0, DARK_GREEN, DARKER_GREEN, 0

meteoro_mau_5x5:                
    WORD        ALTURA_METEORO, LARGURA_METEORO
    WORD        0, DARK_RED, DARK_RED, RED, 0
    WORD        RED, PURPLE, PINK, LIGHT_RED, DARK_RED
    WORD        DARK_RED, PINK, LIGHT_RED, PINK, DARK_RED
    WORD        DARK_RED, LIGHT_RED, PINK, PURPLE, RED
    WORD        0, RED, DARK_RED, DARK_RED, 0

meteoro_bom_5x5:
    WORD        ALTURA_METEORO, LARGURA_METEORO
    WORD        0, DARKER_GREEN, DARKER_GREEN, DARK_GREEN, 0
    WORD        DARK_GREEN, MILITARY_GREEN, LIGHT_GREEN, GREEN, DARKER_GREEN
    WORD        DARKER_GREEN, LIGHT_GREEN, GREEN, LIGHT_GREEN, DARKER_GREEN
    WORD        DARKER_GREEN, GREEN, LIGHT_GREEN, MILITARY_GREEN, DARK_GREEN
    WORD        0, DARK_GREEN, DARKER_GREEN, DARKER_GREEN, 0

missil:
    WORD        ALTURA_MISSIL, LARGURA_MISSIL
    WORD        WHITE   

explosao:
    WORD        5 , 5
    WORD        0, LIGHT_BLUE, 0, LIGHT_BLUE, 0
    WORD        LIGHT_BLUE, 0, LIGHT_BLUE, 0, LIGHT_BLUE
    WORD        0, LIGHT_BLUE, 0, LIGHT_BLUE, 0
    WORD        LIGHT_BLUE, 0, LIGHT_BLUE, 0, LIGHT_BLUE
    WORD        0, LIGHT_BLUE, 0, LIGHT_BLUE, 0

; =============================================================================
; *                                 Código                                    *
; =============================================================================
PLACE 0

inicio:                        ; inicializações
    MOV  SP, SP_inicial
    MOV  BTE, relogios
    MOV  R0, ECRA_MENU         ; posicao do pixel screen do menu
    MOV  R11, CENARIO_MENU     ; cenario do menu
    CALL seleciona_ecra_mostra ; seleciona o ecra e coloca no respetivo pixel screen

; corpo principal do programa
main:
    CALL teclado
    JMP main

; =============================================================================
; *                                  Teclado                                  *
; =============================================================================
teclado:    
    PUSH R0 
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    MOV  R1, ULTIMA_LINHA   ; valor da última linha para comparar posteriormente
    MOV  R2, TEC_LIN        ; endereço do periférico das linhas
    MOV  R3, TEC_COL        ; endereço do periférico das colunas
    MOV  R4, 1              ; linha atual
    MOV  R5, MASCARA        ; 0FH, mantem o nibble low e elimina o nibble high

; =============================================================================
;  espera_tecla: mantém-se neste ciclo até que alguma tecla seja premida.
;                Guarda em R0 e R4 o valor da coluna e da linha da tecla, respetivamente.
; =============================================================================
espera_tecla:               ; neste ciclo espera-se até uma tecla ser premida
    MOVB [R2], R4           ; escrever no periférico de saída (linhas)
    MOVB  R0, [R3]          ; ler do periférico de entrada (colunas)
    AND   R0, R5            ; elimina bits alem dos 0-3
    CMP   R0, 0             ; há tecla premida?
    JNZ   ha_tecla          ; R0 diferente de 0 => ha tecla
    CMP   R4, R1            ; verifica se é a ultima linha (para voltar ao inicio)
    JZ    fim_teclado       ; termina ciclo se estiver na ultima linha
    SHL   R4, 1             ; senão, aumenta a linha
    JMP   espera_tecla      ; avanca para comparar na proxima linha

; =============================================================================
;  ha_tecla: Transforma a informacao recebida do espera_tecla e transforma num
;            número de 0 a 15 correspondente a cada uma das teclas.
; =============================================================================
ha_tecla:
    MOV  R1, R4             ; linha em R1
    CALL converte_decimal   ; Converte R1 em binario e poe em R2
    MOV  R4, R2             ; linha binario em R4
    MOV  R1, R0             ; coluna em R1   
    CALL converte_decimal   ; Converte R1 em binario e poe em R2
    SHL R4, 2               ; linha * 4 
    ADD R4, R2              ; valor decimal (0-15) = 4 * linha + coluna (HEX)
                            ; valor da tecla premida está em R4

; =============================================================================
;  verifica_inicio: verifica na tabela jogo_iniciado se o jogo está a decorrer.
;                   0 se não estiver e 1 se estiver.
; =============================================================================
verifica_inicio:
    MOV R1, jogo_iniciado   ; tabela do jogo iniciado em R1
    MOV R2, [R1]            ; valor da tabela em R2

    CMP R2, 1               ; se o jogo estiver iniciado
    JZ verifica_pausa       ; vai ver se esta em pausa

    MOV R5, 0CH             ; senão espera pela tecla C
    CMP R4, R5
    JZ call_tecla_C
    JMP fim_teclado         ; sai se a tecla C não for premida

; =============================================================================
;  verifica_pausa: verifica na tabela jogo_pausado se o jogo foi colocado em pausa.
;                   0 se não estiver em pausa e 1 se estiver.
; =============================================================================
verifica_pausa:
    MOV R5, 0EH             ; para o jogo se a tecla E for premida
    CMP R4, R5
    JZ call_tecla_E

    MOV R1, jogo_pausado    ; tabela do jogo em pausa em R1
    MOV R2, [R1]            ; valor da tabela em R2

    CMP R2, 0               ; se o jogo não estiver em pausa
    JZ verifica_missil      ; vai verificar se existe míssil no ecra

    MOV R5, 0DH             ; se estiver em pausa
    CMP R4, R5              ; se clicar na tecla D, retoma o jogo
    JZ call_tecla_D_comeca

    JMP fim_teclado         ; se a tecla premida não for a D ou E, volta a procura de tecla

; =============================================================================
;  verifica_missil: verifica na tabela missil_disparado se existe um míssil no ecrã.
;                   0 se não existir e 1 se existir.
; =============================================================================
verifica_missil:                ; verifica se o míssil está no ecra
    MOV R1, missil_disparado    ; tabela do míssil em R1
    MOV R2, [R1]                ; valor da linha do míssil em R2

    CMP R2, 0               ; se R2 = 0 então não há míssil
    JNZ procura_tecla       ; se houver míssil então procura tecla diferente de 1 

    CMP R4, 1               ; se não houver míssil e a tecla premida for a tecla 1
    JZ call_tecla_1         ; então dispara míssil

; =============================================================================
;  procura_tecla:   descobre que tecla foi premida no teclado.
; =============================================================================
procura_tecla: 
    MOV R5, 0DH
    CMP R4, R5
    JZ call_tecla_D_pausa   ; Se for a tecla D, executa call_tecla_D_pausa
    CMP R4, 0
    JZ  call_tecla_0        ; Se for a tecla 0, executa call_tecla_0
    CMP R4, 2
    JZ call_tecla_2         ; Se for a tecla 2, executa call_tecla_2
    JMP fim_teclado         ; Se não encontra tecla sai do ciclo

fim_teclado: 
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    RET  

; =============================================================================
; *                             Ações das Teclas                              *
; =============================================================================
call_tecla_0:
    CALL tecla_0                ; executa a tecla 0
    JMP  tecla_premida_hold     ; continua a executar até a tecla deixar de ser premida

call_tecla_1:
    CALL tecla_1                ; executa a tecla 1
    JMP  tecla_premida          ; apenas uma vez

call_tecla_2:
    CALL tecla_2                ; executa a tecla 2
    JMP  tecla_premida_hold     ; continua a executar até a tecla deixar de ser premida

call_tecla_C:
    CALL tecla_C                ; executa a tecla C
    JMP tecla_premida           ; apenas uma vez

call_tecla_D_comeca:
    CALL tecla_D_comeca         ; executa a tecla D
    JMP tecla_premida           ; apenas uma vez

call_tecla_D_pausa:
    CALL tecla_D_pausa          ; executa a tecla D
    JMP tecla_premida           ; apenas uma vez

call_tecla_E:
    CALL tecla_E                ; executa a tecla E
    JMP tecla_premida           ; apenas uma vez

; =============================================================================
;  tecla_0 - Movimenta rover para a esquerda
; =============================================================================
tecla_0:
    PUSH R0
    PUSH R1
    PUSH R2
    MOV  R2, MIN_COLUNA         ; valor da mínimo da coluna em R2
    CALL obtem_coluna_rover     ; coluna atual do rover em R1
    CMP  R1, R2                 
    JZ   acaba_movimento_rover  ; se estiver no mínimo então não deixa mover
    MOV  R2, DIRECAO_ESQUERDA   ; direção do movimento em R2
    CALL move_rover             ; move rover para a esquerda
    JMP  acaba_movimento_rover

; =============================================================================
;  tecla_1 - Dispara um míssil se ainda não existir um míssil no ecrã
; =============================================================================
tecla_1:
    PUSH R0
    PUSH R2
    PUSH R1
    PUSH R9

    MOV  R2, DECREMENTA_ENERGIA ; decrementa a energia ao disparar
    CALL altera_energia

    MOV  R10, EFEITO_DISPARO    ; reproduz o efeito sonoro do disparo ao disparar
    CALL reproduz_som

    MOV  R0, missil_disparado   ; tabela booleana do míssil em R0
    MOV  R1, [R0]               ; valor atual em R1
    MOV  R1, 1                  ; regista que há míssil
    MOV [R0], R1                ; diz à tabela boolena do míssil que há míssil
    MOV  R0, posicao_rover      ; tabela das coordenadas do rover em R0
    MOV  R9, posicao_missil     ; tabela dos pixels do rover em R9
    MOV  R1, [R0]               ; coluna em do rover em R1
    ADD  R1, 2                  ; poe o míssil na coluna do meio do rover 
    MOV [R9], R1                ; define a coluna a desenhar do míssil
    ADD  R9, 2                  ; aponta para a linha do míssil
    MOV  R1, LINHA_MISSIL       ; linha inicial do míssil
    MOV [R9], R1                ; define a linha inicial do míssil 
    SUB  R9, 2                  ; aponta para a coluna da posição do míssil
    MOV  R0, missil             ; tabela dos pixels do míssil
    CALL desenha_objeto
    EI1                         ; ativa interrupções no relogio do míssil
    EI
    POP  R9
    POP  R2
    POP  R1
    POP  R0
    RET

; =============================================================================
;  tecla_2 - Movimenta rover para a direita
; =============================================================================
tecla_2:
    PUSH R0
    PUSH R1
    PUSH R2
    MOV  R2, MAX_COLUNA_ROVER  ; valor da máximo da coluna em R2
    CALL obtem_coluna_rover    ; coluna atual do rover em R1
    CMP  R1, R2
    JZ   acaba_movimento_rover ; se estiver no máximo então não deixa mover
    MOV  R2, DIRECAO_DIREITA   ; direção do movimento em R2
    CALL move_rover            ; move rover para a direita
    JMP  acaba_movimento_rover

; =============================================================================
;  obtem_coluna_rover - Guarda em R1 a coluna atual do rover  
; =============================================================================
obtem_coluna_rover:
    MOV R0, posicao_rover     ; tabela do rover em R0
    MOV R1, [R0]              ; guarda coluna em R1
    RET     

acaba_movimento_rover:
    POP R2
    POP R1
    POP R0
    RET

; =============================================================================
;  tecla_C - permite interrupções da energia e dos meteoros, regista nas tabelas 
;            booleanas que o jogo foi iniciado. muda para o ecrã de jogo 
; =============================================================================
tecla_C:
    PUSH R0
    PUSH R10
    PUSH R11
    MOV  R0, jogo_iniciado      ; tabela do jogo em R0
    MOV  R10, 1                 ; valor a colocar
    MOV [R0], R10               ; regista que o jogo está iniciado
    MOV  R0, ECRA_JOGO          ; posicao do pixel screen do jogo
    MOV  R11, CENARIO_JOGO      ; posicao do cenario do jogo
    CALL seleciona_ecra_mostra  
    EI0                         ; permite interrupções dos relogios
    EI2                         ; da energia e do meteoro
    EI
    CALL inicia_energia         ; inicia a energia a 100 nos displays
    CALL desenha_rover          ; desenha o rover
    MOV  R10, MUSICA_INICIO     ; música em R3
    CALL reproduz_som           ; reproduz a música
    POP R11
    POP R10
    POP R0
    RET

; =============================================================================
;  tecla_D_comeca - permite interrupções, regista nas tabelas booleanas que o 
;                   jogo não está em pausa. muda para o ecrã de jogo.
; =============================================================================
tecla_D_comeca: ; o jogo esta pausado, vai recomecar
    PUSH R0
    PUSH R10
    PUSH R11
    EI0                         ; permite interrupções dos relogios
    EI2                         ; da energia e do meteoro
    EI
    MOV  R10, jogo_pausado      ; tabela booleana do jogo em pausa em R10
    MOV  R11, 0                 ; valor a colocar
    MOV [R10], R11              ; desativa a pausa
    MOV  R0, ECRA_JOGO          ; numero do pixel screen do jogo
    MOV  R11, CENARIO_JOGO      ; cenario a colocar
    CALL seleciona_ecra_mostra  ; coloca o cenario
    MOV  R10, MUSICA_INICIO     ; música em R10
    CALL retoma_som             ; retoma a reprodução da música
    MOV  R10, missil_disparado  ; tabela booleana do míssil em R10
    MOV  R11, [R10]             ; valor atual da tabela em R11
    CMP  R11, 0                 
    JNZ ativa_relogio_missil    ; se há míssil ativa o relógio do míssil
    POP R11
    POP R10
    POP R0
    JMP main

; =============================================================================
;  tecla_D_pausa - não permite interrupções, regista nas tabelas booleanas que o 
;                  jogo está em pausa. muda para o ecrã de pausa. o teclado apenas
;                  permite a continuação do jogo (tecla D).
; =============================================================================
tecla_D_pausa: ; o jogo esta a decorrer, vai ser pausado
    DI2                 ; não permite interrupções
    DI1
    DI0
    DI
    PUSH R0
    PUSH R1
    PUSH R10
    PUSH R11
    MOV  R10, jogo_pausado      ; tabela booleana do jogo em pausa em R10
    MOV  R11, 1                 ; valor a colocar
    MOV  [R10], R11             ; ativa a pausa
    CALL esconde_cenario_jogo   ; esconde o pixel screen do jogo (1)
    MOV  R0, ECRA_PAUSA         ; numero do pixel screen da pausa
    MOV  R11, CENARIO_PAUSA     ; cenario a colocar
    CALL seleciona_ecra_mostra  ; coloca o cenario
    MOV  R10, MUSICA_INICIO     ; música em R10
    CALL pausa_som              ; pausa a reprodução da música
    POP R11
    POP R10
    POP R1
    POP R0
    RET

; =============================================================================
;  ativa_relogio_missil - permite interrupções do relógio míssil.
; =============================================================================
ativa_relogio_missil:
    EI1                         ; permite interrupções do relógio do míssil
    EI
    POP R11
    POP R10
    POP R0
    JMP main

; =============================================================================
;  tecla_E -   não permite interrupções, regista nas tabelas booleanas que o 
;              jogo não está inciado e não está em pausa. apaga os pixels do 
;              ecrã principal e muda para o ecrã de jogo terminado. reinicia 
;              todos os bonecos.  
; =============================================================================
tecla_E:
    DI2                         ; não permite interrupções 
    DI1
    DI0
    DI
    PUSH R0
    PUSH R10
    PUSH R11
    MOV  R0, jogo_iniciado      ; tabela booleana do jogo em R0
    MOV  R10, 0                 ; valor a colocar
    MOV [R0], R10               ; regista que o jogo não está a decorrer 
    MOV  R0, jogo_pausado       ; tabela booleana do jogo em pausa em R10
    MOV [R0], R10               ; regista que o jogo não está em pausa
    CALL esconde_cenario_jogo   ; esconde o pixel screen do jogo (1)
    MOV  R0, ECRA_TERMINA       ; posicao do pixel screen do jogo terminado
    MOV  R11, CENARIO_TERMINA   ; posicao do cenario do jogo
    CALL seleciona_ecra_mostra  
    MOV  R10, MUSICA_INICIO     ; música em R10
    CALL termina_som            ; termina a reprodução da música
    CALL apaga_pixels_jogo      ; apaga todos os pixels desenhados do ecrã do jogo (1)
    CALL reinicia_rover         ; reinicia o rover
    CALL reinicia_meteoro       ; reinicia o meteoro
    CALL reinicia_missil        ; reinicia o míssil
    POP R11
    POP R10
    POP R0
    RET

; =============================================================================
;  game_over - não permite interrupções, regista nas tabelas booleanas que o 
;              jogo não está inciado e não está em pausa. apaga os pixels do 
;              ecrã principal e reproduz um efeito sonoro.
;              reinicia todos os bonecos.  
; =============================================================================
game_over:
    CALL apaga_pixels_jogo      ; apaga todos os pixels desenhados do ecrã do jogo (1)
    DI2                         ; não permite interrupções
    DI1
    DI0
    DI
    PUSH R0
    PUSH R10
    PUSH R11
    MOV  R10, EFEITO_EXPLOSAO   ; efeito sonoro a reproduzir
    CALL reproduz_som
    MOV  R10, jogo_iniciado     ; tabela booleana do jogo em R10
    MOV  R11, 0                 ; valor a colocar
    MOV  [R10], R11             ; regista que o jogo não está a decorrer 
    ;CALL esconde_cenario_jogo   ; esconde o pixel screen do jogo (1)
    ;MOV  R0, ECRA_GAME_OVER     ; numero do pixel screen do game over
    ;MOV  R11, CENARIO_GAME_OVER ; cenario a colocar
    ;CALL seleciona_ecra_mostra  ; coloca o cenario
    MOV  R10, MUSICA_INICIO     ; música em R10
    CALL termina_som            ; termina a reprodução da música
    CALL reinicia_rover         ; reinicia o rover
    CALL reinicia_meteoro       ; reinicia o meteoro
    CALL reinicia_missil        ; reinicia o míssil  
    POP R11
    POP R10
    POP R0
    JMP main

; =============================================================================
;  tecla_premida - espera se ate nenhuma tecla estar premida
; =============================================================================
tecla_premida:
    MOV  R5, MASCARA        ; mascara 0000 1111
    MOV  R3, TEC_COL        ; endereço das colunas do teclado
    MOVB R0, [R3]           ; ler colunas do periférico de entrada
    AND  R0, R5             ; elimina bits alem dos 0 a 3
    CMP  R0, 0              ; enquanto as colunas não forem 0 (tecla premida)
    JNZ  tecla_premida      ; repetir o ciclo
    JMP  fim_teclado        ; quando não ha teclas premidas sai do teclado

; =============================================================================
;  tecla_premida_hold - mantém a tecla premida e repete a ação da tecla
; =============================================================================
tecla_premida_hold:     
    MOV  R5, MASCARA        ; mascara 0000 1111
    MOV  R3, TEC_COL        ; endereço das colunas do teclado
    MOVB R0, [R3]           ; ler colunas do periférico de entrada
    AND  R0, R5             ; elimina bits alem dos 0 a 3
    CMP  R0, 0              ; enquanto as colunas não forem 0 (tecla premida)
    JNZ  hold               ; faz uma pausa
    JMP  fim_teclado        ; quando acaba a pausa sai do teclado
hold:   
    SUB R3, 4               ; usa R3 = 0E000H para não usar mais registos
    JNZ hold                ; continua até R3 = 0
    JMP fim_teclado

; =============================================================================
; *                            Código de desenho                              *
; =============================================================================
; =============================================================================
;  desenha_objeto - desenha os pixels da tabela do objeto
;  Argumentos - R0 - tabela de pixels do objeto a desenhar
;             - R9 - tabela de cordenadas do objeto a desenhar
; =============================================================================
desenha_objeto:
    PUSH R1             
    PUSH R2             
    PUSH R3             
    PUSH R4             
    PUSH R5             
    PUSH R6             
    PUSH R7             
    PUSH R8      
    MOV  R1, R9                 ; tabela das coordenadas em R1
    MOV  R4, [R1]               ; coluna a desenhar no ecrã em R4
    ADD  R1, 2                  ; 
    MOV  R5, [R1]               ; linha a desenhar no ecrã em R5
    MOV  R1, R0                 ; tabela do objeto em R1
    MOV  R2, [R1]               ; altura (contador linhas) em R2
    ADD  R1, 2                  ; 
    MOV  R3, [R1]               ; largura (contador colunas) em R3
    ADD  R1, 2                  ; proximo pixel
ciclo_linhas:
    MOV  R7, R3                 ; contador auxiliar da largura
    MOV  R8, R4                 ; copia da coluna a desenhar
    CMP  R2, 0                  ; se chegar a ultima linha sai do ciclo
    JNZ  desenha_linha
    JMP  fim_desenha_objeto
desenha_linha:
    MOV  R6, [R1]               ; obtém a cor do próximo pixel do boneco
    CALL desenha_pixel
    ADD  R1, 2                  ; proximo pixel
    ADD  R8, 1                  ; proxima coluna a desenhar
    SUB  R7, 1                  ; decrementa contador de largura
    JNZ  desenha_linha
    SUB  R2, 1                  ; decrementa contador da altura
    ADD  R5, 1                  ; proxima linha a desenhar
    JNZ  ciclo_linhas
fim_desenha_objeto:
    POP  R8
    POP  R7
    POP  R6
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    RET

; =============================================================================
;  apaga_objeto - apaga os pixels do objeto
;  Argumentos - R0 - tabela de pixels do objeto a apagar
;             - R9 - tabela de cordenadas do objeto a apagar
; =============================================================================
apaga_objeto:
    PUSH R1                     
    PUSH R2                     
    PUSH R3                     
    PUSH R4                     
    PUSH R5                     
    PUSH R6                     
    PUSH R7                     
    PUSH R8                     
    MOV  R1, R9                 ; tabela das coordenadas em R1
    MOV  R4, [R1]               ; coluna a desenhar no ecrã em R4
    ADD  R1, 2                  ; 
    MOV  R5, [R1]               ; linha a desenhar no ecrã em R5
    MOV  R1, R0                 ; tabela do objeto em R1
    MOV  R2, [R1]               ; altura (contador linhas) em R2
    ADD  R1, 2                  ; 
    MOV  R3, [R1]               ; largura (contador colunas) em R3
ciclo_apaga_linhas:
    MOV  R7, R3                 ; contador auxiliar da largura
    MOV  R8, R4                 ; copia da coluna a desenhar
    CMP  R2, 0                  ; se chegar a ultima linha sai do ciclo
    JNZ  apaga_linha
    JMP  fim_desenha_objeto
apaga_linha:
    MOV  R6, 0                  ; pixel vazio, apaga
    CALL desenha_pixel
    ADD  R8, 1                  ; proxima coluna a desenhar
    SUB  R7, 1                  ; decrementa contador de largura
    JNZ  apaga_linha
    SUB  R2, 1                  ; decrementa contador da altura
    ADD  R5, 1                  ; proxima linha a desenhar
    JNZ  ciclo_apaga_linhas

; =============================================================================
;  desenha_pixel - desenha um pixel
;  Argumentos: R8 - coluna a desenhar, R5 - linha a desenhar, 
;              R6 - cor do pixel
; =============================================================================
desenha_pixel:
    MOV [DEFINE_COLUNA], R8     ; seleciona a coluna a desenhar
    MOV [DEFINE_LINHA],  R5     ; seleciona a linha a desenhar
    MOV [DEFINE_PIXEL],  R6     ; desenha o pixel
    RET

; =============================================================================
;  desenha_rover - desenha o rover
; =============================================================================
desenha_rover:
    PUSH R0
    PUSH R9 
    MOV  R0, rover
    MOV  R9, posicao_rover
    CALL desenha_objeto
    POP  R9
    POP  R0
    RET

; =============================================================================
; *                             Movimento de Bonecos                          *
; =============================================================================
; =============================================================================
;  move_meteoro - move o rover, apaga da posicao antiga e desenha na nova 
;                 posição
;  Argumentos: R9 - tabela da posicao do meteoro a apagar
; =============================================================================
move_meteoro:
    CALL apaga_objeto            ; desenha meteoro na nova posicao
    ADD  R2, 1                   ; incrementa a linha
    MOV [R1], R2                 ; atualiza a linha na tabela
    CALL desenha_objeto          ; apaga os pixels 
    RET

; =============================================================================
;  move_rover - move o rover, apaga da posicao antiga e desenha na nova 
;  Argumentos: R2 - direção do movimento (esquerda ou direita)
; =============================================================================
move_rover:
    PUSH R0
    PUSH R1 
    PUSH R9
    MOV  R0, rover              ; tabela do rover em R0 
    MOV  R9, posicao_rover
    CALL apaga_objeto           ; apaga os pixels do rover 
    MOV  R1, [R9]               ; coluna em R1
    ADD  R1,  R2                ; incrementa ou decrementa a coluna
    MOV [R9], R1                ; atualiza a coluna na tabela
    CALL desenha_objeto         ; desenha rover na nova posicao
    POP  R9
    POP  R1
    POP  R0
    RET 

; =============================================================================
; *                             Funções Auxiliares                            *
; =============================================================================
; =============================================================================
;  converte_decimal - converte valor em binário em valor decimal
;  Argumentos:   R1 - valor a converter
; =============================================================================
converte_decimal:
    PUSH R1                 ; valor da linha/coluna em binário
    MOV  R2, 0              ; inicializa contador a 0
conta_shifts:
    ADD R2, 1               ; atualiza valor do contador
    SHR R1, 1            
    JNZ conta_shifts     
    SUB R2, 1               ; contador de shifts - 1 = valor de (0 ,3)
    POP R1               
    RET

; =============================================================================
;  reproduz_som - reproduz o som selecionado    
;  pausa_som    - pausa a reprodução do som selecionado 
;  retoma_som   - retoma a reprodução do som selecionado 
;  termina_som  - termina a reprodução do som selecionado 
;  Argumentos: R10 - posicao do som no media center
; =============================================================================
reproduz_som:              
    MOV [TOCA_SOM], R10           ; reproduz o som escolhido
    RET

pausa_som:
    MOV [PAUSA_SOM], R10           ; pausa o som escolhido
    RET

retoma_som:
    MOV [RETOMA_SOM], R10           ; pausa o som escolhido
    RET

termina_som:
    MOV [TERMINA_SOM], R10           ; pausa o som escolhido
    RET

; =============================================================================
;  mostra_display - coloca valor hexadecimal no display (POUT-1)
;  Argumentos: R1 - valor a colocar no display
; =============================================================================
mostra_display:
    MOV [DISPLAYS], R1            
    RET

; =============================================================================
;  coloca_cenario - muda o cenário de fundo
;  Argumentos: R11 - posição da imagem no media center
; =============================================================================
coloca_cenario:
    MOV [FUNDO_ECRA], R11           ; coloca o cenário selecionado no pixel screen
    RET

; =============================================================================
;  seleciona_ecra_mostra - seleciona o pixel screen, coloca a imagem no 
;                          pixel screen e mostra o pixel screen
;  Argumentos: R0 - pixel screen a colocar
;              R11 - imagem a colocar
; =============================================================================
seleciona_ecra_mostra:
    MOV [SELECIONA_ECRA], R0
    CALL coloca_cenario
    MOV [MOSTRA_ECRA], R0
    RET

; =============================================================================
;  esconde_cenario_jogo - esconde o pixel screen do jogo
; =============================================================================
esconde_cenario_jogo: ; esconde o cenario do jogo
    PUSH R1
    MOV  R1, ECRA_JOGO ; pixel screen a esconder
    MOV  [ESCONDE_ECRA], R1
    POP  R1 
    RET

; =============================================================================
;  apaga_pixels_jogo - apaga todos os pixels do pixel screen do jogo
; =============================================================================
apaga_pixels_jogo: ; apaga os pixels do pixel screen do jogo
    PUSH R1
    MOV  R1, ECRA_JOGO ; seleciona o pixel screen 1 (do jogo)
    MOV [APAGA_ECRA], R1
    POP  R1 
    RET

; =============================================================================
;  altera_energia - altera a energia do rover e mostra no display 
;  Argumentos: R2 - valor do aumento ou decremento
; =============================================================================
altera_energia:
    PUSH R0
    PUSH R1
    MOV  R0, energia_rover  ; tabela da energia em R0
    MOV  R1, [R0]           ; energia do rover atual em R1
    ADD  R1, R2             ; altera energia
    MOV  R2, ENERGIA_INICIAL
    CMP  R1, R2            
    JGE  energia_a_100
    MOV [R0], R1            ; atualiza na tabela da energia
    CALL hexa_para_decimal
    CALL mostra_display     ; mostra a energia no display
    CMP  R1, 0
    JZ   energia_a_0
    POP  R1
    POP  R0
    RET 

; =============================================================================
;  energia_a_100 - coloca a energia a 100 no display, volta a onde 
;                  altera_energia foi chamado
; =============================================================================
energia_a_100:
    MOV  R1, ENERGIA_INICIAL
    MOV [R0], R1                ; atualiza energia na tabela 
    CALL hexa_para_decimal
    CALL mostra_display
    POP  R1
    POP  R0
    RET

; =============================================================================
;  energia_a_0 - acaba o jogo, muda para o cenario de game over sem energia
; =============================================================================
energia_a_0:
    CALL esconde_cenario_jogo           ; esconde o pixel screen do jogo (1)
    MOV  R0, ECRA_GAME_OVER             ; numero do pixel screen do game over
    MOV  R11, CENARIO_GAME_OVER_ENERGIA ; cenario a colocar
    CALL seleciona_ecra_mostra          ; coloca o cenario
    CALL game_over
    POP  R1
    POP  R0
    RET

; =============================================================================
;  inicia_energia - inicia a energia a 100 no display
; =============================================================================
inicia_energia:
    PUSH R0
    PUSH R1 
    MOV  R0, energia_rover
    MOV  R1, ENERGIA_INICIAL
    MOV [R0], R1                ; atualiza energia na tabela 
    CALL hexa_para_decimal
    CALL mostra_display
    POP  R1 
    POP  R0
    RET 

; =============================================================================
;  reinicia_rover - reinicia as coordenadas e a energia do rover
; =============================================================================
reinicia_rover:
    PUSH R0
    PUSH R1
    MOV  R0, posicao_rover  ; tabela das coordenadas em R0
    MOV  R1, [R0]           ; coluna atual em R1
    MOV  R1, COLUNA_ROVER   ; poe valor inicial da coluna
    MOV [R0], R1            ; atualiza coluna
    ADD  R0, 2              ; vai a linha
    MOV  R1, [R0]           ; linha atual em R1
    MOV  R1, LINHA_ROVER    ; poe valor inicial da linha 
    MOV [R0], R1            ; atualiza linha
    MOV  R0, energia_rover   ; tabela da energia em R0
    MOV  R1, [R0]            ; energia atual em R0
    MOV  R1, ENERGIA_INICIAL ; energia incial
    MOV [R0], R1             ; reset da energia
    POP  R1
    POP  R0
    RET

; =============================================================================
;  reinicia_meteoro - reinicia as coordenadas e o tipo do meteoro com valores 
;                     pseudo  aleatórios.
; =============================================================================
reinicia_meteoro:
    PUSH R0
    PUSH R1
    PUSH R4
    PUSH R5
    CALL pseudo_random          ; coloca numero pseudo aleatorio em R5
    MOV  R0, 8                  ; para multiplicar por 8
    MUL  R5, R0                 ; multiplica R5 por 8, obtém múltiplos 
                                ; de 8 de 0 a 63 para a posução do meteoro
    MOV  R0, posicao_meteoro    ; tabela das coordenadas em R0
    MOV [R0], R5                ; atualiza coluna
    ADD  R0, 2                  ; vai a linha
    MOV  R1, LINHA_METEORO      ; poe valor inicial da linha em R1
    MOV [R0], R1                ; atualiza linha
    CALL pseudo_booleano        ; poe 0 ou 1 em R4 aleatoriamente
    MOV  R0, meteoro_bom_ou_mau ; tabela do tipo do meteoro em R0
    MOV [R0], R4                ; escreve novo valor na tabela
    POP R5
    POP R4
    POP R1
    POP R0
    RET

; =============================================================================
;  reinicia_missil - reinicia as coordenadas do míssil, regista na tabela 
;                    booleana que não há míssil ativo, não permite interrupções 
;                    no relógio do míssil
; =============================================================================
reinicia_missil:
    PUSH R0
    PUSH R1
    MOV  R0, posicao_missil ; tabela das coordenadas em R0
    MOV  R1, [R0]           ; coluna atual em R1
    MOV  R1, FORA_ECRA      ; novo valor, fora do ecrã
    MOV [R0], R1            ; poe o míssil fora do ecrã
    ADD  R0, 2              ; vai a linha
    MOV  R1, [R0]           ; linha atual em R1
    MOV  R1, LINHA_MISSIL   ; poe valor inicial da linha
    MOV [R0], R1            ; atualiza linha
    MOV  R0, missil_disparado
    MOV  R1, 0
    MOV [R0], R1            ; reset do míssil disparado
    DI1                     ; impede interrupções no relógio do míssil
    DI
    POP R1
    POP R0
    RET

; =============================================================================
;  hexa_para_decimal - Converte valores hexadecimais em decimais
;  Argumentos: R1 - valor hexadecimal a converter
;              R2 - valor do fator 
;              R3 - guarda o digito 
;              R4 - resultado auxiliar
;  Resultado em R1
; =============================================================================
hexa_para_decimal:
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    MOV  R2, 1000           ; inicializa fator
    MOV  R4, 0              ; inicializa resultado a 0
    MOV  R5, 10             ; valor do fator final/ valor a dividir
ciclo_conversor: 
    MOD  R1, R2             ; resto da divisão do valor do hexadecimal pelo fator
    DIV  R2, R5             ; divide o fator por 10
    MOV  R3, R1             ; guarda o numero em R3
    DIV  R3, R2             ; divide pelo fator
    SHL  R4, 4              ; dá espaço ao digito seguinte
    OR   R4, R3             ; coloca o digito na posição correta
    CMP  R2, R5             ; se o fator for menor do que 10
    JLT  fim_conversor      ; acaba o ciclo
    JMP  ciclo_conversor    ; senão continua
fim_conversor:
    MOV  R1, R4             ; coloca o valor convertido no registo original
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    RET

; =============================================================================
; *                            Código das Colisões                            *
; =============================================================================
; =============================================================================
;  rover_colisao_esquerda -  verifica se o rover está à esquerda do meteoro
; =============================================================================
rover_colisao_esquerda:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    MOV R1, posicao_meteoro     ; tabela das coordenadas do meteoro em R1
    MOV R2, [R1]                ; valor atual das colunas do meteoro em R2
    MOV R3, posicao_rover       ; tabela das coordenadas do rover em R3
    MOV R4, [R3]                ; valor atual das colunas do rover em R4 
    ADD R4, 4                   ; valor da coluna mais à direita do rover em R4
    CMP R2, R4                    
    JLE rover_colisao_direita   ; se o rover está à esquerda do meteoro verifica 
                                ; o lado direito
fim_colisao:
    POP R4
    POP R3
    POP R2
    POP R1
    RET

; =============================================================================
;  rover_colisao_direita -  verifica se o rover está à direita do meteoro
; =============================================================================
rover_colisao_direita:
    ADD R2, 4                   ; valor da coluna mais à direita do meteoro
    SUB R4, 4                   ; valor da coluna mais à esquerda do rover
    CMP R2, R4                  
    JGE rover_colisao_baixo     ; se o rover está à direita do meteoro verifica 
                                ; se colidiu com a parte de baixo do meteoro
    JMP fim_colisao

; =============================================================================
;  rover_colisao_baixo -  verifica se o meteoro está a ultrapassar a
;                         primeira linha do rover.
; =============================================================================
rover_colisao_baixo:
    ADD R1, 2                   ; aponta para a linha do meteoro
    MOV R2, [R1]                ; valor atual da linha do meteoro em R2
    ADD R2, 5                   ; valor mais em baixo do meteoro em R2
    ADD R3, 2                   ; aponta para a linha do rover
    MOV R4, [R3]                ; valor atual da linha do rover em R4
    CMP R2, R4                  ; se a linha de baixo do meteoro estiver abaixo
                                ; da linha de cima do rover há colisão
    JGE efetua_colisao_rover 
    JMP fim_colisao

; =============================================================================
;  efetua_colisao_rover -  verifica se o meteoro é bom ou mau
; =============================================================================
efetua_colisao_rover:
    CALL bom_ou_mau             
    POP  R9
    POP  R7
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    JMP main

; =============================================================================
;  bom_ou_mau - executa a colisão do rover com o meteoro bom ou mau
; =============================================================================
bom_ou_mau:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R9
    MOV R0, meteoro_bom_ou_mau      ; tabela booleana do tipo de meteoro em R0
    MOV R1, [R0]                    ; valor atual em R1
    CMP R1, 0                       ; vê se o meteoro é mau ou bom
    JZ colisao_mau                  ; rover vai colidir com meteoro o mau
    JMP colisao_bom                 ; senão rover colide com  meteoroo bom

; =============================================================================
;  colisao_mau - rover colidiu com um meteoro mau logo termina o jogo
; =============================================================================
colisao_mau:
    CALL esconde_cenario_jogo   ; esconde o pixel screen do jogo (1)
    MOV  R0, ECRA_GAME_OVER     ; numero do pixel screen do game over
    MOV  R11, CENARIO_GAME_OVER ; cenario a colocar
    CALL seleciona_ecra_mostra  ; coloca o cenario
    CALL game_over
    POP R9
    POP R2
    POP R1
    POP R0
    RET
; =============================================================================
;  colisao_mau - rover colidiu com um meteoro bom, incrementa a energia
; =============================================================================
colisao_bom:
    PUSH R10
    MOV  R10, EFEITO_ABSORVE        ; efeito sonoro da absorção de meteoro bom
    CALL reproduz_som               ; reproduz o som
    MOV R0, meteoro_bom_5x5         ; argumentos do apaga objeto
    MOV R9, posicao_meteoro
    CALL apaga_objeto               ; apaga o meteoro
    CALL reinicia_meteoro          
    MOV  R2, INCREMENTA_ENERG10     ; atualiza energia
    CALL altera_energia
    EI                              ; permite interrupções nos relógios               
    POP R10
    POP R9
    POP R2
    POP R1
    POP R0
    RET


; =============================================================================
;  missil_colisao_esquerda -  verifica se o míssil está à esquerda do meteoro
; =============================================================================
missil_colisao_esquerda:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    MOV R1, posicao_meteoro         ; tabela da posicao do meteoro
    MOV R2, [R1]                    ; coluna do meteoro em R2
    MOV R3, posicao_missil          ; tabela da posicao do míssil
    MOV R4, [R3]                    ; coluna do míssil em R4
    CMP R2, R4                      
    JLE missil_colisao_direita      ; se o míssil está à esquerda do meteoro 
                                    ; verifica o lado direito
    JMP fim_colisao

; =============================================================================
;  missil_colisao_direita -  verifica se o míssil está à direita do meteoro
; =============================================================================
missil_colisao_direita:
    ADD R2, 1                       ; adiciona 1 à coluna do meteoro
    ADD R2, R5                      ; adciona offset à coluna do meteoro
    CMP R2, R4                      ; testa limite inferior do meteoro
    JGE missil_colisao_baixo        ; se o míssil está à direita do meteoro 
    JMP fim_colisao

; =============================================================================
;  missil_colisao_baixo -  verifica se o míssil está a ultrapassar a
;                          última linha do meteoro.
; =============================================================================
missil_colisao_baixo:
    ADD R1, 2                   ; aponta para a linha do meteoro na tabela
    MOV R2, [R1]                ; linha do meteoro em R2
    ADD R2, 1                   ; adiciona 1 à linha
    ADD R2, R5                  ; adiciona offset à linha
    ADD R3, 2                   ; aponta para a linha do míssil na tabela
    MOV R4, [R3]                ; linha do míssil em R4
    CMP R2, R4
    JGE efetua_colisao_missil   ; vê se o míssil colidiu com o meteoro
    JMP fim_colisao

; =============================================================================
;  efetua_colisao_missil - há colisão, vê se colidiu com meteoro bom ou mau  
; =============================================================================
efetua_colisao_missil:
    PUSH R0
    PUSH R1
    PUSH R10                        ; para chamar reproduz_som
    MOV R0, missil_disparado        ; tabela booleana do míssil disparado em R0
    MOV R1, [R0]                    ; valor atual em R1
    CMP R1, 1                       ; vê se há míssil
    JZ  bom_ou_mau_missil           ; se sim vai ver se está a colidir com meteoro 
                                    ; bom ou mau
    POP R1
    POP R0

; =============================================================================
;  bom_ou_mau_missil - executa a colisão do míssil com o meteoro bom ou mau
; =============================================================================
bom_ou_mau_missil:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R9
    MOV R0, meteoro_bom_ou_mau      ; tabela booleana do tipo de meteoro em R0
    MOV R1, [R0]                    ; valor atual em R1
    CMP R1, 0                       ; vê se o meteoro é mau ou bom
    JZ colisao_mau_missil           ; míssil vai colidir com meteoro o mau
    JMP colisao_bom_missil          ; senão míssil colide com  meteoroo bom

; =============================================================================
;  colisao_mau_missil - míssil colidiu com um meteoro mau, aumenta energia, 
;                       desenha explosão e reproduz efeito sonoro da explosão
; =============================================================================
colisao_mau_missil:
    MOV  R2, INCREMENTA_ENERG5    ; atualiza energia
    CALL altera_energia
    
    MOV R0, meteoro_mau_5x5     ; tabela de pixels do meteoro em R0
    MOV R9, posicao_meteoro     ; posicao do meteoro em R9
    MOV R6, [R9]                ; poe coluna do meteoro atual em R6
    ADD R9, 2                   ; aponta para a linha
    MOV R7, [R9]                ; poe linha do meteoro atual em R7
    SUB R9, 2                   ; reset para o inicio da tabela da posicao do meteoro
    MOV R2, posicao_explosao
    MOV [R2], R6                ; linha da explosao 
    ADD R2, 2
    MOV [R2], R7                ; coluna da explosao
    CALL apaga_objeto           ; apaga meteoro
    MOV R9, posicao_explosao    ; argumentos do desenha_objeto
    MOV R0, explosao
    CALL desenha_objeto         ; desenha explosao
    MOV  R10, EFEITO_EXPLOSAO   
    CALL reproduz_som           ; reproduz efeito sonoro da explosão
    CALL reinicia_missil
    CALL reinicia_meteoro
    JMP fim_colisao_missil

; =============================================================================
;  colisao_bom_missil - míssil colidiu com um meteoro bom, desenha explosão
;                       e reproduz efeito sonoro da explosão
; =============================================================================
colisao_bom_missil:
    MOV R0, meteoro_mau_5x5     ; tabela de pixels do meteoro em R0
    MOV R9, posicao_meteoro     ; posicao do meteoro em R9
    MOV R6, [R9]                ; poe coluna do meteoro atual em R6
    ADD R9, 2                   ; aponta para a linha
    MOV R7, [R9]                ; poe linha do meteoro atual em R7
    SUB R9, 2                   ; reset para o inicio da tabela da posicao do meteoro

    MOV R2, posicao_explosao
    MOV [R2], R6                ; linha da explosao 
    ADD R2, 2
    MOV [R2], R7                ; coluna da explosao
    CALL apaga_objeto           ; apaga meteoro
    MOV R9, posicao_explosao    ; argumentos do desenha_objeto
    MOV R0, explosao
    CALL desenha_objeto         ; desenha explosao
    MOV  R10, EFEITO_EXPLOSAO   ; reproduz efeito sonoro da explosão
    CALL reproduz_som
    CALL reinicia_missil
    CALL reinicia_meteoro
fim_colisao_missil:
    EI                          ; permite interrupções nos relógios               
    POP  R9
    POP  R7
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    JMP main 

; =============================================================================
;  pseudo_random - gera um valor pseudo aleatório de 0 a 7 (8 resultados 
;                  possíveis). Lê os pins levantados das colunas do teclado e 
;                  coloca os valores aleatórios no nibble low de R5.
;  Resultado em R5.
; =============================================================================
pseudo_random: 
    PUSH R1
    PUSH R2
    PUSH R3
    MOV  R1, TEC_COL        ; endereço para ler as colunas
    MOV  R2, MASCARA_2      ; mascara para eliminar o nibble low
    MOVB R3, [R1]           ; ler do periférico de entrada (colunas)
    AND  R3, R2             ; elimina bits alem dos 7-4
    SHR  R3, 5              ; coloca os bits 7 a 5 (aleatórios) nos bits 2 A 0
    MOV  R5, R3             ; numero aleatorio colocado em R5
    POP  R3
    POP  R2
    POP  R1
    RET 


; =============================================================================
;  pseudo_booleano - gera um valor pseudo aleatório entre 0 e 1.
;                    A probabilidade de o resultado ser 1 é de 25%
;                    A probabilidade de o resultado ser 0 é de 75%
;  Resultado em R4.
; =============================================================================
pseudo_booleano:
    PUSH R0
    PUSH R5
    CALL pseudo_random  ; valor de 0 a 7, pseudo aleatorio em R5
    MOV  R0, 3          ; valor para calcular o resto da divisao
    MOD  R5, R0         ; R5 devolve ou 2 valores iguais a 2 ou 6 
                        ; valores menores do que 2
    CMP  R5, 2
    JLT  assign_zero    ; se for menor do que 2 vai por 0 no resultado
    MOV  R4, 1          ; senão devolve 1
fim_pseudo_booleano:
    POP  R5
    POP  R0
    RET
assign_zero:
    MOV  R4, 0
    JMP  fim_pseudo_booleano

; =============================================================================
; *                            Código das Interrupções                        *
; =============================================================================
; =============================================================================
;  relogio_meteoro - Rotina que move o meteoro
; =============================================================================
relogio_meteoro:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R7
    PUSH R9
    MOV  R9, posicao_explosao           ; tabela das coordenadas da explosão em R9
    CALL verifica_explosao              ; apaga a explosão se estiver no ecrã

    MOV  R9 , jogo_iniciado             ; verifica se o jogo está a decorrer
    MOV  R1 , [R9]                     
    CMP  R1, 0
    JZ   verifica_inicio_transporte     ; se não estiver a decorrer vai esperar pela tecla C
    MOV  R9 , jogo_pausado              ; verifica se o jogo está em pausa
    MOV  R1 , [R9]
    CMP  R1, 1                        
    JZ   verifica_pausa_transporte      ; se está em pausa espera vai pela tecla D

    MOV R9, posicao_meteoro             ; tabela das coordenadas do meteoro 
    MOV R1, R9                          ; cria copia auxiliar para não estragar 
    ADD R1, 2                           ; aponta para a linha
    MOV R2, [R1]                        ; linha do meteoro em R2

    CMP R2, MUDA_TAMANHO_1              ; se estiver em cima da linha 1
    JLE desenha_meteoro_1x1             ; desenha o meteoro 1x1

    CMP R2, MUDA_TAMANHO_2              ; se estiver em cima da linha 4
    JLE desenha_meteoro_2x2             ; desenha o meteoro 2x2

    MOV R3, meteoro_bom_ou_mau          ; tabela do tipo de meteoro em R3
    MOV R4, [R3]                        ; põe o valor em R4
    CMP R4, 1                           ; se for 1 desenha o meteoro bom
    JZ desenha_bom                      ; se não desenha o mau

    MOV R7, MUDA_TAMANHO_3              ; se estiver em cima da linha 8
    CMP R2, R7                          ; desenha o meteoro mau 3x3 
    JLE desenha_meteoro_mau_3x3          

    MOV R7, MUDA_TAMANHO_4              ; se estiver em cima da linha 13
    CMP R2, R7                          ; desenha o meteoro mau 4x4
    JLE desenha_meteoro_mau_4x4

    MOV R7, LIMITE_INFERIOR             ; se não estiver no limite inferior do ecrã
    CMP R2, R7                          ; desenha o meteoro mau 5x5
    JLE desenha_meteoro_mau_5x5

    MOV R0, meteoro_mau_5x5             ; tabela de pixels do meteoro mau 5x5 em R0
    CALL apaga_objeto                   ; apaga o meteoro do ecrã
    CALL reinicia_meteoro               ; reinicia as coordenadas e o tipo do meteoro
fim_relogio_meteoro:
    POP  R9
    POP  R7
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    RFE

; =============================================================================
;  desenha_meteoro_NxN - Desenha um meteoro longínquo, bom ou mau
;  Argumentos: R0 - tabela de pixeis do meteoro a desenhar           
; =============================================================================
desenha_meteoro_1x1:
    MOV  R0, meteoro_1x1            ; tabela de pixels do meteoro pequeno
    CALL move_meteoro               ; move meteoro para baixo
    JMP  fim_relogio_meteoro_desliga    

desenha_meteoro_2x2:
    MOV  R0, meteoro_2x2            ; tabela de pixels do meteoro 2x2
    CALL move_meteoro               ; desenha e move meteoro
    JMP  fim_relogio_meteoro_desliga

; =============================================================================
;  desenha_meteoro_mau_NxN - Desenha um meteoro mau
;  Argumentos: R0 - tabela de pixeis do meteoro mau a desenhar           
; =============================================================================
desenha_meteoro_mau_3x3:
    MOV  R5, 1                      ; offset a ser adicionado a linha
    MOV  R0, meteoro_mau_3x3        ; tabela de pixels do meteoro mau 3x3
    CALL seleciona_meteoro_desenha  
    JMP  fim_relogio_meteoro_desliga

desenha_meteoro_mau_4x4:
    MOV  R5, 2                      ; offset a ser adicionado a linha
    MOV  R0, meteoro_mau_4x4        ; tabela de pixels do meteoro mau 4x4
    CALL seleciona_meteoro_desenha  
    JMP  fim_relogio_meteoro_desliga

desenha_meteoro_mau_5x5:
    MOV  R5, 3                      ; offset a ser adicionado a linha
    MOV  R0, meteoro_mau_5x5        ; tabela de pixels do meteoro mau 5x5
    CALL seleciona_meteoro_desenha  
    JMP  fim_relogio_meteoro_desliga

; =============================================================================
;  desenha_meteoro_bom_NxN - Desenha um meteoro bom
;  Argumentos: R0 - tabela de pixeis do meteoro bom a desenhar           
; =============================================================================
desenha_meteoro_bom_3x3:
    MOV  R5, 1                      ; offset a ser adicionado a linha
    MOV  R0, meteoro_bom_3x3        ; tabela de pixels do meteoro bom 3x3
    CALL seleciona_meteoro_desenha  
    JMP  fim_relogio_meteoro_desliga

desenha_meteoro_bom_4x4:
    MOV  R5, 2                      ; offset a ser adicionado a linha 
    MOV  R0, meteoro_bom_4x4        ; tabela de pixels do meteoro mau 5x5
    CALL seleciona_meteoro_desenha            
    JMP  fim_relogio_meteoro_desliga   

desenha_meteoro_bom_5x5:
    MOV  R5, 3                      ; offset a ser adicionado a linha
    MOV  R0, meteoro_bom_5x5        ; tabela de pixels do meteoro mau 5x5
    CALL seleciona_meteoro_desenha  
    JMP  fim_relogio_meteoro_desliga

verifica_inicio_transporte:         ; auxiliar para permitir JMP fora dos limites
    JMP verifica_inicio

verifica_pausa_transporte:          ; auxiliar para permitir JMP fora dos limites
    JMP verifica_pausa

; =============================================================================
;  seleciona_meteoro_desenha - verifica se há colisão entre os bonecos e, se
;                              não houver, move o meteoro           
; =============================================================================
seleciona_meteoro_desenha:
    CALL rover_colisao_esquerda     ; verifica se colidiu com o rover
    CALL missil_colisao_esquerda    ; verifica se colidiu com o míssil
    CALL move_meteoro               ; desenha e move meteoro
    RET 

; =============================================================================
;  fim_relogio_meteoro_desliga - impede interrupções do relogio dos meteoros          
; =============================================================================
fim_relogio_meteoro_desliga:
    DI0                             
    JMP fim_relogio_meteoro

; =============================================================================
;  verifica_explosao - verifica se a explosão está dentro do ecrã
; =============================================================================
verifica_explosao:
    MOV R1, [R9]            ; coluna da explosão em R1
    MOV R2, FORA_ECRA       ; valor a comparar
    CMP R1, R2              ; vê se a explosão está fora do ecrã
    JNZ apaga_explosao      ; se estiver no ecrã apaga a explosão
    RET

; =============================================================================
;  apaga_explosao - apaga a explosão do ecrã
; =============================================================================
apaga_explosao:
    MOV  R0, explosao       ; tabela de pixels da explosão em R0
    CALL apaga_objeto       ; apaga a explosão
    RET

; =============================================================================
;  desenha_bom - desenha o meteoro bom no ecrã sequencialmente
; =============================================================================
desenha_bom:
    MOV R7, MUDA_TAMANHO_3          
    CMP R2, R7                      ; se estiver em cima da linha 8  
    JLE desenha_meteoro_bom_3x3     ; desenha o meteoro bom 3x3 

    MOV R7, MUDA_TAMANHO_4          
    CMP R2, R7                      ; se estiver em cima da linha 13 
    JLE desenha_meteoro_bom_4x4     ; desenha o meteoro bom 4x4 

    MOV R7, LIMITE_INFERIOR         
    CMP R2, R7                      ; se não estiver no limite inferior do ecrã
    JLE desenha_meteoro_bom_5x5     ; desenha o meteoro bom 5x5

    MOV  R0, meteoro_bom_5x5        ; tabela de pixels do meteoro mau 5x5 em R0
    CALL apaga_objeto               ; apaga o meteoro do ecrã
    CALL reinicia_meteoro           ; reinicia as coordenadas e o tipo do meteoro
    JMP  fim_relogio_meteoro

; =============================================================================
;  relogio_missil - Rotina que move o míssil
; =============================================================================
relogio_missil:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R9

    MOV  R0, jogo_iniciado          ; vê se o jogo está a decorrer
    MOV  R9, [R0]           
    CMP  R9, 0             
    JZ   fim_relogio_missil_desliga ; desativa o míssil se o jogo estiver em pausa

    MOV  R9, posicao_missil         ; tabela das coordenadas do míssil em R9
    MOV  R0, missil                 ; tabela dos pixels do míssil em R0
    MOV  R1, R9                     ; cria copia auxiliar para não estragar original
    ADD  R1, 2                      ; aponta para a linha
    MOV  R2, [R1]                   ; linha em R2
    CMP  R2, 0                      ; vê se o míssil está nos limites
    JZ   fim_relogio_missil_desliga ; se está no topo do ecrã vai tirar o míssil
    CALL apaga_objeto               ; apaga o míssil para descrever o movimento
    SUB  R2, 1                      ; decrementa a linha do míssil
    MOV [R1], R2                    ; atualiza a linha
    CALL desenha_objeto             ; desenha em baixo
fim_relogio_missil:
    POP  R9
    POP  R2
    POP  R1
    POP  R0
    RFE  
fim_relogio_missil_desliga:
    DI1                         ; impede interrupções no relógio do míssil
    CALL apaga_objeto           ; apaga o míssil
    MOV  R0, missil_disparado   ; tabela booleana do míssil em R0
    MOV  R1, [R0]               ; põe o valor atual em R1
    MOV  R1, 0                  ; tira o míssil
    MOV [R0], R1                ; atualiza a tabela e regista que não há míssil
    JMP fim_relogio_missil

; =============================================================================
;  relogio_energia - Rotina que decrementa a energia do rover periodicamente
; =============================================================================
relogio_energia:
    PUSH R2       
    MOV  R2, DECREMENTA_ENERGIA ; decrementa o valor 
    CALL altera_energia         ; atualiza na tabela de energia e mostra no display 
    POP  R2 
    RFE
