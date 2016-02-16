	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010106-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push6=, 2
	i32.add 	$push5=, $0, $pop6
	tee_local	$push4=, $0=, $pop5
	i32.const	$push0=, 7
	i32.ge_u	$push1=, $pop4, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %switch.lookup
	i32.const	$push7=, 2
	i32.shl 	$push2=, $0, $pop7
	i32.load	$push3=, .Lswitch.table($pop2)
	return  	$pop3
.LBB0_2:                                # %sw.default
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lswitch.table,@object  # @switch.table
	.section	.rodata..Lswitch.table,"a",@progbits
	.p2align	4
.Lswitch.table:
	.int32	33                      # 0x21
	.int32	0                       # 0x0
	.int32	7                       # 0x7
	.int32	4                       # 0x4
	.int32	3                       # 0x3
	.int32	15                      # 0xf
	.int32	9                       # 0x9
	.size	.Lswitch.table, 28


	.ident	"clang version 3.9.0 "
