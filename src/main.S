.syntax unified
.global main

.type main, %function
main:
  @ initialisation
  bl init
  
  ldr r4, =0x7000 @counter / top of range

  ldr r5, =#48000 @sample rate
 
  ldr r6, =#440 @desired frequency

  udiv r7, r5, r6 @number of outputs needed for frequency per period

  mov r9, #2 

  udiv r7, r7, r9 @ number of outputs needed for frequency per half period
 
  ldr r6, =-0x7000 @bottom of range

  mul r8, r4, r9 @full range of numbers

  udiv r8, r8, r7 @number to increase/decrease by
 
  b subloop

@subtracts from the counter until lower limit is reached
subloop:
  @move the current counter value into r0 to produce the sound
  mov r0, r4
  bl BSP_AUDIO_OUT_Play_Sample

  @ calculate the next value in the triangle signal
  subs r4, r8

  @check if value has reached the lower limit, and if it has go to the add loop
  cmp r4, r6
  ble addloop
  beq addloop

  b subloop

@adds to the counter until upper limit is reached
addloop:
  @move the current counter value into r0 to produce the sound
  mov r0, r4
  bl BSP_AUDIO_OUT_Play_Sample

  @ calculate the next value in the triangle signal
  adds r4, r8

  @check if value has reached the uppper limit, and if it has go to the subtraction loop
  cmp r4, r5
  bgt subloop
  beq subloop

  b addloop