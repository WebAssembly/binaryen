	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000703-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$push0=, 19
	i32.add 	$push1=, $0, $pop0
	i32.load8_u	$push2=, .str+2($3)
	i32.store8	$discard=, 0($pop1), $pop2
	i32.const	$push3=, 18
	i32.add 	$push4=, $0, $pop3
	i32.load8_u	$push5=, .str+1($3)
	i32.store8	$discard=, 0($pop4), $pop5
	i32.load8_u	$push6=, .str($3)
	i32.store8	$discard=, 17($0), $pop6
	i32.store	$discard=, 20($0), $1
	i32.store	$discard=, 24($0), $2
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$push0=, 24
	call    	memset, $0, $3, $pop0
	i32.const	$push1=, .str.1
	i32.const	$push2=, 17
	call    	memcpy, $0, $pop1, $pop2
	i32.const	$push3=, 19
	i32.add 	$push4=, $0, $pop3
	i32.load8_u	$push5=, .str+2($3)
	i32.store8	$discard=, 0($pop4), $pop5
	i32.const	$push6=, 18
	i32.add 	$push7=, $0, $pop6
	i32.load8_u	$push8=, .str+1($3)
	i32.store8	$discard=, 0($pop7), $pop8
	i32.load8_u	$push9=, .str($3)
	i32.store8	$discard=, 17($0), $pop9
	i32.store	$discard=, 20($0), $1
	i32.store	$discard=, 24($0), $2
	return
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end8
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"abc"
	.size	.str, 4

	.type	.str.1,@object          # @.str.1
.str.1:
	.asciz	"01234567890123456"
	.size	.str.1, 18


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
