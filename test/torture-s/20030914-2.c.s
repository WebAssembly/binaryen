	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030914-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	return  	$1
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 80
	i32.sub 	$11=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$11=, 0($1), $11
	i32.const	$push1=, 64
	i32.const	$2=, 8
	i32.add 	$2=, $11, $2
	i32.add 	$push2=, $2, $pop1
	i32.const	$push37=, 0
	i64.load	$push0=, gs+64($pop37):p2align=2
	i64.store	$discard=, 0($pop2):p2align=2, $pop0
	i32.const	$push4=, 56
	i32.const	$3=, 8
	i32.add 	$3=, $11, $3
	i32.add 	$push5=, $3, $pop4
	i32.const	$push36=, 0
	i64.load	$push3=, gs+56($pop36):p2align=2
	i64.store	$discard=, 0($pop5):p2align=2, $pop3
	i32.const	$push7=, 48
	i32.const	$4=, 8
	i32.add 	$4=, $11, $4
	i32.add 	$push8=, $4, $pop7
	i32.const	$push35=, 0
	i64.load	$push6=, gs+48($pop35):p2align=2
	i64.store	$discard=, 0($pop8):p2align=2, $pop6
	i32.const	$push10=, 40
	i32.const	$5=, 8
	i32.add 	$5=, $11, $5
	i32.add 	$push11=, $5, $pop10
	i32.const	$push34=, 0
	i64.load	$push9=, gs+40($pop34):p2align=2
	i64.store	$discard=, 0($pop11):p2align=2, $pop9
	i32.const	$push13=, 32
	i32.const	$6=, 8
	i32.add 	$6=, $11, $6
	i32.add 	$push14=, $6, $pop13
	i32.const	$push33=, 0
	i64.load	$push12=, gs+32($pop33):p2align=2
	i64.store	$discard=, 0($pop14):p2align=2, $pop12
	i32.const	$push16=, 24
	i32.const	$7=, 8
	i32.add 	$7=, $11, $7
	i32.add 	$push17=, $7, $pop16
	i32.const	$push32=, 0
	i64.load	$push15=, gs+24($pop32):p2align=2
	i64.store	$discard=, 0($pop17):p2align=2, $pop15
	i32.const	$push19=, 16
	i32.const	$8=, 8
	i32.add 	$8=, $11, $8
	i32.add 	$push20=, $8, $pop19
	i32.const	$push31=, 0
	i64.load	$push18=, gs+16($pop31):p2align=2
	i64.store	$discard=, 0($pop20):p2align=2, $pop18
	i32.const	$push22=, 8
	i32.const	$9=, 8
	i32.add 	$9=, $11, $9
	i32.add 	$push23=, $9, $pop22
	i32.const	$push30=, 0
	i64.load	$push21=, gs+8($pop30):p2align=2
	i64.store	$discard=, 0($pop23):p2align=2, $pop21
	i32.const	$push29=, 0
	i64.load	$push24=, gs($pop29):p2align=2
	i64.store	$discard=, 8($11):p2align=2, $pop24
	i32.const	$push25=, 4660
	i32.const	$10=, 8
	i32.add 	$10=, $11, $10
	block
	i32.call	$push26=, f@FUNCTION, $10, $pop25
	i32.const	$push28=, 4660
	i32.ne  	$push27=, $pop26, $pop28
	br_if   	$pop27, 0       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push38=, 0
	call    	exit@FUNCTION, $pop38
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	gs                      # @gs
	.type	gs,@object
	.section	.bss.gs,"aw",@nobits
	.globl	gs
	.p2align	2
gs:
	.skip	72
	.size	gs, 72


	.ident	"clang version 3.9.0 "
