	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr55875.c"
	.section	.text.t,"ax",@progbits
	.hidden	t
	.globl	t
	.type	t,@function
t:                                      # @t
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block
	block
	i32.const	$push3=, 0
	i32.eq  	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push0=, 256
	i32.ge_s	$push1=, $0, $pop0
	br_if   	1, $pop1        # 1: down to label0
# BB#2:                                 # %if.end3
	return  	$0
.LBB0_3:                                # %if.then
	end_block                       # label1:
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB0_4:                                # %if.then2
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	t, .Lfunc_end0-t

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 5
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push2=, 255
	i32.and 	$push0=, $0, $pop2
	i32.call	$discard=, t@FUNCTION, $pop0
	i32.const	$push1=, 1
	i32.add 	$0=, $0, $pop1
	br      	0               # 0: up to label2
.LBB1_2:
	end_loop                        # label3:
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	1004
	.size	a, 1004


	.ident	"clang version 3.9.0 "
