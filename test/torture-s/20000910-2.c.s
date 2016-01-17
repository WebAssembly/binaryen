	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000910-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, 42
	block
	i32.load	$push0=, list($0)
	i32.call	$push1=, strchr@FUNCTION, $pop0, $1
	i32.const	$push4=, 0
	i32.eq  	$push5=, $pop1, $pop4
	br_if   	$pop5, 0        # 0: down to label0
# BB#1:                                 # %if.then.i
	block
	i32.load	$push2=, list+4($0)
	i32.call	$push3=, strchr@FUNCTION, $pop2, $1
	i32.const	$push6=, 0
	i32.eq  	$push7=, $pop3, $pop6
	br_if   	$pop7, 0        # 0: down to label1
# BB#2:                                 # %foo.exit
	return  	$0
.LBB0_3:                                # %if.else.i
	end_block                       # label1:
	call    	exit@FUNCTION, $0
	unreachable
.LBB0_4:                                # %if.then2.i
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"*"
	.size	.L.str, 2

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"e"
	.size	.L.str.1, 2

	.hidden	list                    # @list
	.type	list,@object
	.section	.data.list,"aw",@progbits
	.globl	list
	.align	2
list:
	.int32	.L.str
	.int32	.L.str.1
	.size	list, 8


	.ident	"clang version 3.9.0 "
