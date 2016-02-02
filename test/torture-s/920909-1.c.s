	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920909-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push1=, -1026
	i32.add 	$push0=, $0, $pop1
	tee_local	$push8=, $0=, $pop0
	i32.const	$push2=, 5
	i32.gt_u	$push3=, $pop8, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %switch.lookup
	i32.const	$push5=, 2
	i32.shl 	$push6=, $0, $pop5
	i32.load	$push7=, .Lswitch.table($pop6)
	return  	$pop7
.LBB0_2:                                # %return
	end_block                       # label0:
	i32.const	$push4=, 0
	return  	$pop4
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
	.int32	1027                    # 0x403
	.int32	1029                    # 0x405
	.int32	1031                    # 0x407
	.int32	1033                    # 0x409
	.int32	1                       # 0x1
	.int32	4                       # 0x4
	.size	.Lswitch.table, 24


	.ident	"clang version 3.9.0 "
