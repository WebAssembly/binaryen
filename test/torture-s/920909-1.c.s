	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/920909-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push0=, -1026
	i32.add 	$0=, $0, $pop0
	i32.const	$push1=, 5
	i32.gt_u	$push2=, $0, $pop1
	br_if   	$pop2, .LBB0_2
# BB#1:                                 # %switch.lookup
	i32.const	$push6=, switch.table
	i32.const	$push4=, 2
	i32.shl 	$push5=, $0, $pop4
	i32.add 	$push7=, $pop6, $pop5
	i32.load	$push8=, 0($pop7)
	return  	$pop8
.LBB0_2:                                  # %return
	i32.const	$push3=, 0
	return  	$pop3
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	switch.table,@object    # @switch.table
	.section	.rodata,"a",@progbits
	.align	4
switch.table:
	.int32	1027                    # 0x403
	.int32	1029                    # 0x405
	.int32	1031                    # 0x407
	.int32	1033                    # 0x409
	.int32	1                       # 0x1
	.int32	4                       # 0x4
	.size	switch.table, 24


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
