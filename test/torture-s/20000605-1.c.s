	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000605-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %for.body.lr.ph.i
	i32.const	$1=, 0
.LBB0_1:                                  # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_2
	i32.const	$push0=, 1
	i32.add 	$1=, $1, $pop0
	i32.const	$0=, 256
	i32.ne  	$push1=, $1, $0
	br_if   	$pop1, .LBB0_1
.LBB0_2:                                  # %render_image_rgb_a.exit
	block   	.LBB0_4
	i32.ne  	$push2=, $1, $0
	br_if   	$pop2, .LBB0_4
# BB#3:                                 # %if.end
	i32.const	$push3=, 0
	call    	exit, $pop3
	unreachable
.LBB0_4:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
