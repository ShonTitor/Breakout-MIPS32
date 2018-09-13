#########################################################################

#                           BREAKOUT!!!                                 #

#########################################################################

#           Programado por Leonardo Lopez y Julio Perez                	#

#      Este programa requiere que el teclado y Display y Bitmap Display #

#      esten conectados a MIPS.                                       	#

# 	Configuracion de Bitmap Display:				#

#       Unit Width: 16                                          	#

#       Unit Height: 16                                                 #

#       Display Width: 512                                              #

#       Display Height: 512						#

#       Base Address for Display: 0x1001000                             #

#########################################################################
.globl main
.include "exceptions.s"

.data 0x10010000
pantalla: .space 32768
vidas: .word 3
bloques_destruidos: .word 0
repetir: .word 0
erados: .word 0
eramenosdos: .word 0
# informacion de esquema del juego

# pantalla
anchoPantalla: 	.word 32
alturaPantalla: .word 32

# colores
colorPlataforma: .word 0x005aff, 0x0048cc, 0x003fb3, 0x0048cc, 0x005aff
colorBloque: .word 0x00ff00, 0x00B200, 0x006600
colorPelota: .word 0xffb732

# variable de vidas

# velocidad a la que se mueve la pelota
T: .word 10
INCREMENTO: .word 100

# Informacion de la pelota
posicionPelotaX: .word 16
posicionPelotaY: .word 16
direccionx: .word 1
direcciony: .word 1
posicion_plataforma: .word 14
direccion: .word 2
matriz_bloques: .word 0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101,0x01010101
e_reloj: .byte 0
e_teclado: .byte 0

.text

main:
	jal init_bola
	jal init_draw
	jal habilitar_interrupciones
main_loop:
	lb $t0, e_teclado
	bnez $t0, teclado
main_loop_reloj:
	lb $t0, e_reloj
	bnez $t0, reloj
	b main_loop

get_pixel: # recibe coordenadas en $a0 y $a1 y devuelve en $v0 la direccion de memoria del pixel correspondiente
	addi $sp, $sp, -4
	sw $fp, ($sp)
	move $fp, $sp
	la $v0, pantalla # direccion del primer pixel
	sll $a1, $a1, 5 # equivalente a multiplicar por 32
	add $t2, $a0, $a1
	sll $t2, $t2, 2 # equivalente a multiplicar por 4	
	add $v0, $v0, $t2
	move $sp, $fp
	lw $fp, ($sp)
	addi $sp, $sp, 4
	jr $ra
	
draw_ball: # dibuja la pelota en la posicion correspondiente
	addi $sp, $sp, -4
	sw $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	lw $a0, posicionPelotaX
	lw $a1, posicionPelotaY
	addi $sp, $sp, -4
	sw $t0, ($sp)
	jal get_pixel
	lw $t0, ($sp)
	addi $sp, $sp, 4
	lw $t0, colorPelota
	sw $t0, ($v0)
	lw $ra, ($sp)
	addi $sp, $sp, 4
	move $sp, $fp
	lw $fp, ($sp)
	addi $sp, $sp, 4
	jr $ra

borrar_bola: # coloca en negro el pixel de la bola
	addi $sp, $sp, -4
	sw $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	lw $a0, posicionPelotaX
	lw $a1, posicionPelotaY
	addi $sp, $sp, -4
	sw $t0, ($sp)
	jal get_pixel
	lw $t0, ($sp)
	addi $sp, $sp, 4
	
	li $t0, 0
	sw $t0, ($v0)
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	move $sp, $fp
	lw $fp, ($sp)
	addi $sp, $sp, 4
	jr $ra

init_bola: # coloca a la bola en el centro de la pantalla y le asigna una direccion aleatoria
	# 16 es la mitad de la pantalla 32x32
	addi $sp, $sp, -4
	sw $fp, ($sp)
	move $fp, $sp
	li $a0, 16
	sw $a0, posicionPelotaX
	sw $a0, posicionPelotaY
	# generando un numero entero pseudoaleatorio en [0,2]
		li $a1, 3
		li $v0, 42
		syscall
		# restandole 1 para que este en [-1,1]
		addi $a0, $a0, -1
		sw $a0, direccionx
		
		beq $a0, -1 , solo1_1
		beqz $a0, solo_22
		beq $a0, 1, solo1_1
		
		solo_22: b conseguir_numero
		verificar_22 : 
				beq $a0, -2, colocar_direccion
				beq $a0, 2, colocar_direccion
				b solo_22
				
		solo1_1: b conseguir_numero
		verificar1_1:
				 beq $a0, 1, colocar_direccion
				beq $a0, -1, colocar_direccion
				b solo1_1
		
		conseguir_numero:
		# en y no puede haber cero, hacemos un loop
		no_cero: bnez $a0, colocar_direccion
			li $a1, 5
			li $v0, 42
			syscall
			# restandole 2 para que este en [-2,2]
			addi $a0, $a0, -2
			b no_cero
		colocar_direccion:
	sw $a0, direcciony
	move $sp, $fp
	lw $fp, ($sp)
	addi $sp, $sp, 4
	jr $ra

init_bloques: # coloca 1 en cada byte de la matriz de bloques para indicar que no han sido destruidos
	addi $sp, $sp, -4
	sw $fp, ($sp)
	move $fp, $sp
	li $t0, 0 # contador
	li $t1, 1
	la $t2, matriz_bloques # direccion en memoria de la matrizd de bloques
	init_bloques_loop:
		sb $t1, ($t2)
		addi $t0, $t0, 1
		addi $t2, $t2, 1
		bne $t0, 128, init_bloques_loop
		
	move $sp, $fp
	lw $fp,($sp)
	addi $sp, $sp, 4
	jr $ra
	
habilitar_interrupciones:
	addi $sp, $sp, -4
	sw $fp, ($sp)
	move $fp, $sp
	mfc0 $t0, $12 # moviendo el registro status a $t0
	ori $t0, $t0, 0x00008101 # encendiendo todos los bits necesarios para interrupcion
	mtc0 $t0, $12 # moviendo el registro de vuelta
	lw $t0, T # valor inicial
	mtc0 $t0, $11  # colocando el compare en 100 para interrupcion de reloj
	li $t0, 0xffff0000 # direccion en memoria del registro de control del receiver
	lw $t1, ($t0) # cargandolo en $t1
	ori $t1, $t1, 0x00000002 # encendiendo bit interrupt enable
	sw $t1, ($t0) # escribiendo de vuelta
	move $sp, $fp
	lw $fp,($sp)
	addi $sp, $sp, 4
	jr $ra

# recibe un color en $a0 y lo coloca negro en todos los pixeles debajo de los bloques
fill:		
	addi $sp, $sp, -4
	sw $fp, ($sp)
	move $fp, $sp
	la $t4, pantalla + 3840 # posicion en memoria del primer pixel despues de los bloques
	li $t5, 0 # contador
	move $t1, $1
	fill_loop:
		sw $a0, 0($t4)
		addi $t4, $t4, 4
		addi $t5, $t5, 1
		bne $t5, 32, fill_loop
		
		move $t1, $zero
		move $sp, $fp
		lw $fp, ($sp)
		addi $sp, $sp, 4
		jr $ra

init_draw: # escribe en memoria para dibujar los elementos en pantalla
	addi $sp, $sp, -4
	sw $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4
	sw $ra, ($sp)

	# colocar casillas en negro
	negro: 
		move $a0, $zero
		addi $sp, $sp, -4
		sw $t1, ($sp)
		addi $sp, $sp, -4
		sw $t4, ($sp)
		jal fill
		lw $t4, ($sp)
		addi $sp, $sp, 4
		lw $t1, ($sp)
		addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $t0, ($sp)
	jal draw_ball
	lw $t0, ($sp)
	addi $sp, $sp, 4
	
	draw_platform: # dibuja la plataforma
		la $t4, pantalla # direccion del primer pixel
		addi $t4, $t4, 3840 # direccion del primer pixel de la penultima fila
		lw $t1, posicion_plataforma
		sll $t1, $t1, 2
		add $t4, $t4, $t1 # primer pixel de la plataforma
		li $t0, 0 # contador
		la $t1, colorPlataforma # direccion del arreglo de colores
		draw_platform_loop:
			beq $t0, 5, draw_blocks
			lw $t2, ($t1) # obteniendo el color
			sw $t2, ($t4)
			addi $t4, $t4, 4 # direccion del proximo pixel
			addi $t1, $t1, 4 # direccion del proximo color
			addi $t0, $t0, 1 # incrementando contador
			b draw_platform_loop
			
	draw_blocks:
		# dibujando los bloques
		move $t0, $zero # contador
		move $t2, $zero # indice del color en el arreglo colorBloque multiplicado por 4
		lw $t1, colorBloque # primer color del arreglo
		la $t4, pantalla # direccion del primer pixel
	
	obtener_color: # guarda en $t1 el color del siguiente bloque
		beq $t2, 12, obtener_color_reset
		la $t3, colorBloque
		add $t3, $t3, $t2
		lw $t1, ($t3)
		b draw_loop
	obtener_color_reset: # si el indice llega a 3 se vuelve al inicio del arreglo
		li $t2, 0
		b obtener_color
	draw_loop: 
		beq $t0,128, draw_fin
		sw $t1, ($t4)
		addi $t4, $t4, 4
		addi $t2, $t2, 4
		addi $t0, $t0, 1
		b obtener_color
		
	draw_fin:
		lw $ra, ($sp)
		addi $sp, $sp, 4
		move $sp, $fp
		lw $fp, ($sp)
		addi $sp, $sp, 4
		jr $ra

terminar_juego_win:
	la $t0, pantalla
	li $t1, 1024

	colocar_negro1: 
		beqz $t1, dibujar_ganar
		sb $zero, 0($t0)
		addi $t0, $t0, 4
		addi $t1,$t1, -1
		b colocar_negro1
	
	dibujar_ganar:
	jal dibujo_ganador
	
	
	
	
	
	
	li $v0, 10
	syscall
	
terminar_juego:
	la $t0, pantalla
	li $t1, 1024
	
	colocar_negro: 
		beqz $t1, fin_perder
		sb $zero, 0($t0)
		addi $t0, $t0, 4
		addi $t1,$t1, -1
		b colocar_negro
		
		
	fin_perder:
	li $v0, 10
	syscall
	
	
	

########################

teclado:
	# colocando en 0 para indicar que ya se atendio la excepcion
	sb $zero, e_teclado
	# obteniendo el caracter le�do del registro data
	li $t8, 0xffff0004
	lw $a0, 0($t8)
	li $a1, 0
	sw $a1, ($t8)
	
	beq $a0, 'a', mover_izquierda
	beq $a0, 'A', mover_izquierda
	beq $a0,'d', mover_derecha
	beq $a0,'D', mover_derecha
	beq $a0, 'q', terminar_juego
	beq $a0, 'Q', terminar_juego
	beq $a0, 'U', aumentar_velocidad
	beq $a0, 'u', aumentar_velocidad
	beq $a0, 'l', disminuir_velocidad
	beq $a0,  'L',disminuir_velocidad
	beq $a0, ' ', pausar
	
	b main_loop
	
	mover_derecha:
		lw $t8, posicion_plataforma
		beq $t8, 0x0000001b, main_loop_reloj
		addi $t8, $t8, 1
		sw $t8 , posicion_plataforma
		addi $t8, $t8, -1
		# cargando posicion exacta de plataforma en $t8
		
		la $t0, pantalla
		addi $t0, $t0, 3840
		sll $t8, $t8, 2
		add $t8, $t8, $t0
		
		# colocando primero en negro
		sw $zero, 0($t8)
		addi $t8, $t8, 4
		
		# $t0 contador
		li $t0, 0
		
		# loop para dibujar
		la $t1, colorPlataforma
		loop_dibujar: 
			beq $t0, 5, main_loop_reloj
			#obteniendo color
			lw $a0, ($t1)
			sw $a0, ($t8)
			addi $t8, $t8, 4 # direccion del proximo pixel
			addi $t1, $t1, 4 # direccion del proximo color
			addi $t0, $t0, 1 # incrementando contador
			b loop_dibujar

	mover_izquierda:
		lw $t8, posicion_plataforma
		beq $t8, 0, main_loop_reloj
		addi $t8, $t8, -1
		sw $t8 , posicion_plataforma
		addi $t8, $t8, 1
		# cargando posicion exacta de plataforma en $t8
		la $t0, pantalla
		addi $t0, $t0, 3840
		sll $t8, $t8, 2
		add $t8, $t8, $t0
		
		# colocando ultimo en negro
		sw $zero, 16($t8)
		addi $t8, $t8, -4
		
		# $t0 contador
		li $t0, 0
		la $t1, colorPlataforma
		# loop para dibujar
		loop_dibujar1:
			beq $t0, 5, main_loop_reloj
			lw $a0, ($t1)
			sw $a0, ($t8)
			addi $t8, $t8, 4 # direccion del proximo pixel
			addi $t1, $t1, 4 # direccion del proximo color
			addi $t0, $t0, 1 # incrementando contador
			b loop_dibujar1
			
		aumentar_velocidad: 
			lw $t0, T
			lw $t1, INCREMENTO
			add $t0, $t0, $t1
			sw $t0, T
			mtc0 $t0, $11
			mtc0 $zero, $9
			b main_loop_reloj
				
			
		disminuir_velocidad:
			lw $t0, T
			lw $t1, INCREMENTO
			subu $t0, $t0, $t1
			sw $t0, T
			mtc0 $t0, $11
			mtc0 $zero, $9
			b main_loop_reloj
			
		pausar: lb $t0, e_teclado
			bnez $t0, teclado
			b pausar
			
reloj:
	# colocando en 0 para indicar que ya se atendio la excepcion
	
	# primero ver si tiene alguna posicion con dos
	
	# obteniendo direccion de la pelota en x
	lw $t0, direccionx
	# obteniendo direccion de la pelota en y
	lw $t1, direcciony
	
	obtener_direcciones:
	beq $t1, 2, colocar_uno
	bne $t1, -2, colisiones
	
	li $t1, -1
	sw $t1, direcciony
	sw $t1, repetir
	sw $t1, eramenosdos
	b colisiones
	
	colocar_uno:
		li $t1, 1
		sw $t1, direcciony
		sw $t1, repetir
		sw $t1, erados
		
	colisiones:
	# Manejo de colisiones
	lw $t0, posicionPelotaX
	lw $a0, posicionPelotaY
	# so se piede una vida
	beq $a0, 31, reinicializar_pelota
	# comprobando si hay colision con la pared
	beq $t0, 0, rebotar_x
	beq $t0, 31, rebotar_x
	beq $a0, 0, rebotar_y
	# comprobando si hay colisiones con un bloque o la plataforma
	ble $a0, 4 , rebotar_bloque
	beq $a0, 29, rebotar_plataforma
	beq $a0, 30, rebotar_plataforma
	
	mover_bola:
	# movimiento de la bola
	lw $s0, posicionPelotaX
	lw $s1, posicionPelotaY
	
	# obteniendo direccion de la pelota en x
	lw $t0, direccionx
	# obteniendo direccion de la pelota en y
	lw $t1, direcciony
	
	# sumandolas a la posicion
	add $s0, $s0, $t0
	add $s1, $s1, $t1
	
	# borramos la anterior
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	addi $sp, $sp, -4
	sw $t0, ($sp)
			
	addi $sp, $sp, -4
	sw $t0, ($sp)
	jal borrar_bola
	lw $t0,($sp)
	addi $sp, $sp, 4
	
	# actualizando etiquetas de posicion
	sw $s0, posicionPelotaX
	sw $s1, posicionPelotaY
	
	# dibujamos la bola en su nueva posicion
	jal draw_ball
	sb $zero, e_reloj
	
	lw $t0, repetir
	beqz $t0, chequeardos
	sw $zero, repetir
	b colisiones
	
	chequeardos:
		lw $t0, erados
		lw $t1, eramenosdos
		bnez $t0, cambiardos
		bnez $t1, cambiarmenosdos
		b main_loop
		cambiardos:
			li $t0, 2
			sw $t0, direcciony
			sw $zero, erados
			b main_loop
			
		cambiarmenosdos:
			li $t0, -2
			sw $t0, direcciony
			sw $zero, eramenosdos
			b main_loop
			
		
	
	# cuando la pelota entra en terreno de bloques
	rebotar_bloque: 
		li $t9, 0 # contador
		li $t7, 0 # se coloca en 1 si hubo rebote
		pre_rebotar_bloque_loop:
			# obteniendo posicion del bloque
			beq $t9, 1, rebotar_bloque_x
			beq $t9, 2, rebotar_bloque_xy
		rebotar_bloque_y: # para colisiones en el eje y
			lw $t0, posicionPelotaX
			lw $a0, posicionPelotaY
			lw $t4, direcciony
			# si la direccion es 0, se ignora este caso
			beqz $t4, rebotar_bloque_fin
			add $a0, $a0, $t4
			b rebotar_bloque_loop
		rebotar_bloque_x: # para colisiones en el eje x
			lw $t0, posicionPelotaX
			lw $a0, posicionPelotaY
			lw $t4, direccionx
			# si la direccion es 0, se ignora este caso
			beqz $t4, rebotar_bloque_fin
			add $t0, $t0, $t4
			b rebotar_bloque_loop
		rebotar_bloque_xy: # para colisiones en diagonal
			lw $t0, posicionPelotaX
			lw $a0, posicionPelotaY
			# si alguna de las direcciones es 0, se ignora este caso
			lw $t4, direccionx
			beqz $t4, rebotar_bloque_fin
			add $t0, $t0, $t4
			lw $t4, direcciony
			beqz $t4, rebotar_bloque_fin
			add $a0, $a0, $t4
		rebotar_bloque_loop:
			la $v0, pantalla # direccion del primer pixel
			sll $a0, $a0, 5 # equivalente a multiplicar por 32
			add $t2, $t0, $a0
			# si $t2 es mayor que 127 la direccion no corresponde a un bloque
			bge $t2, 128, mover_bola
			# direccion de la matriz booleana de bloques
			la $t1, matriz_bloques
			add $t1, $t1, $t2
			lb $t8, ($t1)
			# si es igual a 0, el bloque ya fue destruido
			beqz $t8, rebotar_bloque_fin
			# si es distinto de 0, se destruye el bloque y rebota la bola
			sb $zero, ($t1)
			li $t7, 1 # indicando que hubo al menos un rebote
			# obteniendo pixel del bloque
			sll $t2, $t2, 2 # equivalente a multiplicar por 4
			add $v0, $v0, $t2
			sw $zero, ($v0) # colocando el pixel en 0
			
			# sumar 1 a T por descripcion de juego
			lw $t0, T
			addi $t0, $t0, 1
			sw $t0, T
			mtc0 $t0, $11
			mtc0 $zero, $9
			# sumando 1 al contador de bloques destruidos
			lw $t8, bloques_destruidos
			addi $t8, $t8, 1
			beq $t8, 128, terminar_juego_win
			sw $t8, bloques_destruidos
			
			# actualizando la direccion
			beq $t9, 1, actualizar_direccion_x
			beq $t9, 2, actualizar_direccion_xy
			actualizar_direccion_y:
				lw $t8, direcciony
				neg $t8, $t8
				sw $t8, direcciony
				
				lw $t0, erados
				lw $t1, eramenosdos
				bnez $t0, cambiar_datosdos_bloque
				bnez $t1, cambiar_datosmenos_bloque
				
				b rebotar_bloque_fin
			actualizar_direccion_x:
				lw $t8, direccionx
				neg $t8, $t8
				sw $t8, direccionx
				b rebotar_bloque_fin
			actualizar_direccion_xy:
				lw $t8, direcciony
				neg $t8, $t8
				sw $t8, direcciony
				lw $t8, direccionx
				neg $t8, $t8
				sw $t8, direccionx
				
				lw $t0, erados
				lw $t1, eramenosdos
				bnez $t0, cambiar_datosdos_bloque
				bnez $t1, cambiar_datosmenos_bloque
				
				b rebotar_bloque_fin
				
			cambiar_datosdos_bloque:
				li $t0, -1
				sw $t0, direcciony
				li $t0, 1
				sw $t0, eramenosdos
				sw $zero, erados
				sw $zero, repetir
				b rebotar_bloque_fin
				
			cambiar_datosmenos_bloque:
				li $t0, 1
				sw $t0, direcciony
				li $t0, 1
				sw $t0, erados
				sw $zero, eramenosdos
				sw $zero, repetir
		
		rebotar_bloque_fin:
			# comprobando si aun quedan iteraciones
			addi $t9, $t9, 1
			ble $t9, 2, pre_rebotar_bloque_loop
			beqz, $t7, mover_bola
			b obtener_direcciones # si hubieron colisiones se repite el proceso
			#b mover_bola
		
		
	rebotar_y:
		lw $t0, erados
		lw $t1, eramenosdos
		bnez $t0, cambiar_datosdos
		bnez $t1, cambiar_datosmenos	
		lw $t8, direcciony
		neg $t8, $t8
		sw $t8, direcciony
		b mover_bola
		
		cambiar_datosdos:
		li $t0, -2
		sw $t0, direcciony
		sw $zero, erados
		sw $zero, repetir
		b mover_bola
		
		cambiar_datosmenos:
		li $t0, 2
		sw $t0, direcciony
		sw $zero, eramenosdos
		sw $zero, repetir
		b mover_bola
		
		
	
	rebotar_x: # cuando ocurre un choque con una pared
		lw $t8, direccionx
		neg $t8, $t8
		sw $t8, direccionx	
		beqz $a0, rebotar_y
		beq $a0, 31, rebotar_y
		b mover_bola
		
	rebotar_plataforma: # casos de choque con plataforma
		# cargamos direccion de plataforma en $t8
		#quitamos erados y repetir para que no se devuelva
		sw $zero, erados
		sw $zero, repetir
		
		lw $t8, posicion_plataforma
		
		addi $t8, $t8, -1
		beq $t0, $t8, reinicializar_pelota
		addi $t8, $t8, 1
		beq $t0, $t8, rebote1
		addi $t8, $t8, 1
		beq $t0, $t8, rebote2
		addi $t8, $t8, 1
		beq $t0, $t8, rebote3
		addi $t8, $t8, 1
		beq $t0, $t8, rebote4
		addi $t8, $t8, 1
		beq $t0, $t8, rebote5
		addi $t8, $t8, 1
		beq $t0, $t8, reinicializar_pelota
		b mover_bola
		
	reinicializar_pelota:
		# quitamos una vida
		lw $t8, vidas
		addi $t8, $t8, -1
		beqz $t8, terminar_juego
		sw $t8, vidas
		addi $sp, $sp, -4
		sw $t0, ($sp)
		jal borrar_bola
		lw $t0, ($sp)
		addi $sp, $sp, 4
		jal init_bola
		addi $sp, $sp, -4
		sw $t0, ($sp)
		jal draw_ball
		lw $t0, ($sp)
		addi $sp, $sp, 4
		b pausar
		b main_loop
		
		rebote1: # colocar noroeste
		li $t0, -1
		li $t1, -1
		sw $t0, direccionx
		sw $t1, direcciony
		b mover_bola
		
		rebote2: # nueva direccion
		li $t0, -1
		li $t1, -2
		sw $t0, direccionx
		sw $t1, direcciony
		b mover_bola
		
		rebote3: # otra direccion
		li $t0, 0
		li $t1, -2
		sw $t0, direccionx
		sw $t1, direcciony
		b mover_bola
		
		rebote4: # colocar noreste
		li $t0, 1
		li $t1, -2
		sw $t0, direccionx
		sw $t1, direcciony
		b mover_bola
		
		rebote5: # colocar noreste
		li $t0, 1
		li $t1, -1
		sw $t0, direccionx
		sw $t1, direcciony
		b mover_bola
		
dibujo_ganador:
	addi $sp, $sp, -4
	sw $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4
	sw $ra, ($sp)
	# guardando color blanco en $t0
	li $t0,0xFFFFFF
	
	#letra C
	li $a0, 1
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	li $a0, 3
	li $a1, 13
	jal get_pixel
	sw $t0,0($v0)
	
	li $a0, 1
	li $a1, 14
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	li $a0, 1
	li $a1, 15
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	li $a0, 1
	li $a1, 16
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 2
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 2
	li $a1, 16
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 3
	li $a1, 16
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	# letra O
	li $a0, 5
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 5
	li $a1, 14
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 5
	li $a1, 15
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 5
	li $a1, 16
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 6
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 7
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 7
	li $a1, 14
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 7
	li $a1, 15
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 7
	li $a1, 16
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 6
	li $a1, 16
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	# dibujando N
	
	li $a0, 9
	li $a1, 16
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 9
	li $a1, 15
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 9
	li $a1, 14
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 9
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 10
	li $a1, 14
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 11
	li $a1, 15
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 12
	li $a1, 15
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 12
	li $a1, 16
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 12
	li $a1, 15
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 12
	li $a1, 14
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 12
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	# dibujando G
	
	li $a0, 14
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 16
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 14
	li $a1, 14
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 14
	li $a1, 15
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 14
	li $a1, 16
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 15
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 15
	li $a1, 16
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 16
	li $a1, 16
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 16
	li $a1, 15
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	# dibujando R
	
	li $a0, 18
	li $a1, 16
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 18
	li $a1, 15
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 18
	li $a1, 14
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 18
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 19
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 20
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 20
	li $a1, 14
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 19
	li $a1, 15
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 20
	li $a1, 16
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	# dibujando A
	
	li $a0, 22
	li $a1, 16
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 22
	li $a1, 15
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 22
	li $a1, 14
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 22
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 23
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 24
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 24
	li $a1, 14
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 23
	li $a1, 15
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 24
	li $a1, 16
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 24
	li $a1, 15
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	# dibujando T
	
	li $a0, 27
	li $a1, 16
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 27
	li $a1, 15
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 27
	li $a1, 14
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 27
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 26
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 28
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	
	# signo de exclamacion
	
	li $a0, 30
	li $a1, 13
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 30
	li $a1, 14
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 30
	li $a1, 15
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	li $a0, 30
	li $a1, 17
	addi $sp, $sp, -4
	sw $a0, ($sp)
	addi $sp, $sp, -4
	sw $a1, ($sp)
	jal get_pixel
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	sw $t0,0($v0)
	
	
	
	
	
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	move $sp, $fp
	lw $fp, ($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
