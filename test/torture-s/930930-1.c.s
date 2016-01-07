	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/930930-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	copy_local	$6=, $0
	block   	.LBB0_7
	i32.lt_u	$push0=, $3, $4
	br_if   	$pop0, .LBB0_7
.LBB0_1:                                  # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_5
	i32.load	$5=, 0($3)
	block   	.LBB0_4
	i32.ge_u	$push1=, $5, $2
	br_if   	$pop1, .LBB0_4
# BB#2:                                 # %if.end
                                        #   in Loop: Header=.LBB0_1 Depth=1
	i32.lt_u	$push2=, $5, $1
	br_if   	$pop2, .LBB0_4
# BB#3:                                 # %if.then3
                                        #   in Loop: Header=.LBB0_1 Depth=1
	i32.const	$push3=, -4
	i32.add 	$6=, $6, $pop3
	i32.store	$discard=, 0($6), $5
.LBB0_4:                                  # %if.end4
                                        #   in Loop: Header=.LBB0_1 Depth=1
	i32.const	$push4=, -4
	i32.add 	$3=, $3, $pop4
	i32.ge_u	$push5=, $3, $4
	br_if   	$pop5, .LBB0_1
.LBB0_5:                                  # %out
	i32.eq  	$push6=, $6, $0
	br_if   	$pop6, .LBB0_7
# BB#6:                                 # %if.then7
	call    	abort
	unreachable
.LBB0_7:                                  # %if.end8
	return  	$3
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %f.exit
	i32.const	$0=, 0
	i32.const	$push0=, mem
	i32.store	$discard=, mem+396($0), $pop0
	call    	exit, $0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	mem,@object             # @mem
	.bss
	.globl	mem
	.align	4
mem:
	.zero	400
	.size	mem, 400

	.type	wm_TR,@object           # @wm_TR
	.globl	wm_TR
	.align	2
wm_TR:
	.int32	0
	.size	wm_TR, 4

	.type	wm_HB,@object           # @wm_HB
	.globl	wm_HB
	.align	2
wm_HB:
	.int32	0
	.size	wm_HB, 4

	.type	wm_SPB,@object          # @wm_SPB
	.globl	wm_SPB
	.align	2
wm_SPB:
	.int32	0
	.size	wm_SPB, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
