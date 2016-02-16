	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930719-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	block
	block
	br_if   	0, $0           # 0: down to label2
# BB#1:                                 # %while.body.preheader
	i32.const	$push0=, 1
	i32.ne  	$push1=, $1, $pop0
	br_if   	1, $pop1        # 1: down to label1
# BB#2:                                 # %sw.bb.split
	i32.const	$push3=, 0
	i32.eq  	$push4=, $2, $pop3
	br_if   	2, $pop4        # 2: down to label0
.LBB0_3:                                # %cleanup
	end_block                       # label2:
	i32.const	$push2=, 0
	return  	$pop2
.LBB0_4:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	end_block                       # label1:
	loop                            # label3:
	br      	0               # 0: up to label3
.LBB0_5:                                # %if.end2
	end_loop                        # label4:
	end_block                       # label0:
	unreachable
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
