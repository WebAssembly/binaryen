	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20100827-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	block
	i32.load8_u	$push0=, 0($0)
	i32.const	$push3=, 0
	i32.eq  	$push4=, $pop0, $pop3
	br_if   	$pop4, 0        # 0: down to label0
.LBB0_1:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.add 	$1=, $0, $3
	i32.const	$push5=, 0
	i32.eq  	$push6=, $1, $pop5
	br_if   	$pop6, 1        # 1: down to label2
# BB#2:                                 # %if.end5
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$2=, 1
	i32.add 	$3=, $3, $2
	i32.add 	$push1=, $1, $2
	i32.load8_u	$push2=, 0($pop1)
	br_if   	$pop2, 0        # 0: up to label1
	br      	2               # 2: down to label0
.LBB0_3:                                # %if.then4
	end_loop                        # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %do.end
	end_block                       # label0:
	return  	$3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, .L.str
	i32.call	$push1=, foo@FUNCTION, $pop0
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"a"
	.size	.L.str, 2


	.ident	"clang version 3.9.0 "
