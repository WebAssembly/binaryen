	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000412-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
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
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load16_u	$push0=, i($0)
	i32.const	$push1=, 65535
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %if.end
	call    	exit@FUNCTION, $0
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.data.i,"aw",@progbits
	.globl	i
	.align	1
i:
	.int16	65535                   # 0xffff
	.size	i, 2

	.hidden	wordlist                # @wordlist
	.type	wordlist,@object
	.section	.rodata.wordlist,"a",@progbits
	.globl	wordlist
	.align	4
wordlist:
	.skip	828
	.size	wordlist, 828


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
