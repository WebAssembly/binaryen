	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000412-6.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.const	$push1=, 512
	i32.load16_u	$push0=, buf($0)
	i32.sub 	$push2=, $pop1, $pop0
	i32.load16_u	$push3=, buf+2($0)
	i32.sub 	$push4=, $pop2, $pop3
	i32.load16_u	$push5=, buf+4($0)
	i32.sub 	$push6=, $pop4, $pop5
	i32.const	$push7=, 65535
	i32.and 	$push8=, $pop6, $pop7
	i32.const	$push9=, 491
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	$pop10, .LBB0_2
# BB#1:                                 # %if.end
	call    	exit, $0
	unreachable
.LBB0_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.globl	bug
	.type	bug,@function
bug:                                    # @bug
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB1_2
	i32.ge_u	$push0=, $1, $2
	br_if   	$pop0, .LBB1_2
.LBB1_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_2
	i32.const	$push2=, 65535
	i32.and 	$push3=, $0, $pop2
	i32.load16_u	$push1=, 0($1)
	i32.sub 	$0=, $pop3, $pop1
	i32.const	$push4=, 2
	i32.add 	$1=, $1, $pop4
	i32.lt_u	$push5=, $1, $2
	br_if   	$pop5, .LBB1_1
.LBB1_2:                                  # %for.end
	i32.const	$push6=, 65535
	i32.and 	$push7=, $0, $pop6
	return  	$pop7
.Lfunc_end1:
	.size	bug, .Lfunc_end1-bug

	.type	buf,@object             # @buf
	.data
	.globl	buf
	.align	1
buf:
	.int16	1                       # 0x1
	.int16	4                       # 0x4
	.int16	16                      # 0x10
	.int16	64                      # 0x40
	.int16	256                     # 0x100
	.size	buf, 10


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
