	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000412-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_s	$push1=, i($pop0)
	i32.const	$push2=, 2
	i32.shl 	$push3=, $pop1, $pop2
	i32.const	$push4=, wordlist
	i32.add 	$push5=, $pop3, $pop4
	i32.const	$push6=, 828
	i32.add 	$push7=, $pop5, $pop6
	return  	$pop7
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB1_2
	i32.load16_u	$push0=, i($0)
	i32.const	$push1=, 65535
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB1_2
# BB#1:                                 # %if.end
	call    	exit, $0
	unreachable
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	i,@object               # @i
	.data
	.globl	i
	.align	1
i:
	.int16	65535                   # 0xffff
	.size	i, 2

	.type	wordlist,@object        # @wordlist
	.section	.rodata,"a",@progbits
	.globl	wordlist
	.align	4
wordlist:
	.zero	828
	.size	wordlist, 828


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
