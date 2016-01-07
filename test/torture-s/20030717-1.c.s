	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030717-1.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$2=, 24($0)
	i32.const	$6=, 20
	i32.load	$4=, 4($1)
	i32.load16_u	$3=, 0($1)
	i32.mul 	$push0=, $2, $6
	i32.add 	$push1=, $0, $pop0
	i32.load	$push2=, 12($pop1)
	i32.sub 	$1=, $4, $pop2
	i32.const	$7=, 31
	i32.shr_s	$8=, $1, $7
	i32.add 	$push3=, $1, $8
	i32.xor 	$5=, $pop3, $8
	copy_local	$1=, $2
	copy_local	$10=, $2
.LBB0_1:                                  # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_4
	block   	.LBB0_3
	i32.const	$push4=, 0
	i32.gt_s	$push5=, $1, $pop4
	br_if   	$pop5, .LBB0_3
# BB#2:                                 # %if.then
                                        #   in Loop: Header=.LBB0_1 Depth=1
	i32.add 	$push6=, $0, $6
	i32.load	$1=, 0($pop6)
.LBB0_3:                                  # %if.end
                                        #   in Loop: Header=.LBB0_1 Depth=1
	i32.const	$push7=, -1
	i32.add 	$1=, $1, $pop7
	i32.mul 	$push8=, $1, $6
	i32.add 	$push9=, $0, $pop8
	i32.load	$push10=, 12($pop9)
	i32.sub 	$8=, $4, $pop10
	i32.shr_s	$9=, $8, $7
	i32.add 	$push11=, $8, $9
	i32.xor 	$push12=, $pop11, $9
	i32.lt_u	$push13=, $pop12, $5
	i32.select	$10=, $pop13, $1, $10
	i32.ne  	$push14=, $1, $2
	br_if   	$pop14, .LBB0_1
.LBB0_4:                                  # %do.end
	i32.mul 	$push18=, $10, $6
	i32.add 	$push19=, $0, $pop18
	i32.const	$push15=, 9
	i32.shr_u	$push16=, $3, $pop15
	i32.add 	$push17=, $pop16, $4
	i32.store	$discard=, 12($pop19), $pop17
	return  	$10
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %bar.exit
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
