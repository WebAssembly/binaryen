	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20080117-1.c"
	.section	.text.gstate_path_memory,"ax",@progbits
	.hidden	gstate_path_memory
	.globl	gstate_path_memory
	.type	gstate_path_memory,@function
gstate_path_memory:                     # @gstate_path_memory
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i32.load	$push2=, gstate_initial+8($1)
	i32.store	$discard=, 0($pop1), $pop2
	i32.const	$push3=, 4
	i32.add 	$push4=, $0, $pop3
	i32.load	$push5=, gstate_initial+4($1)
	i32.store	$discard=, 0($pop4), $pop5
	i32.load	$push6=, gstate_initial($1)
	i32.store	$discard=, 0($0), $pop6
	return
	.endfunc
.Lfunc_end0:
	.size	gstate_path_memory, .Lfunc_end0-gstate_path_memory

	.section	.text.gs_state_update_overprint,"ax",@progbits
	.hidden	gs_state_update_overprint
	.globl	gs_state_update_overprint
	.type	gs_state_update_overprint,@function
gs_state_update_overprint:              # @gs_state_update_overprint
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	gs_state_update_overprint, .Lfunc_end1-gs_state_update_overprint

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	gstate_initial,@object  # @gstate_initial
	.section	.rodata.gstate_initial,"a",@progbits
	.align	2
gstate_initial:
	.int32	1                       # 0x1
	.int32	0                       # 0x0
	.int32	0                       # float 0
	.size	gstate_initial, 12


	.ident	"clang version 3.9.0 "
