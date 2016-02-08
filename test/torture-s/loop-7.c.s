	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-7.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -1
	i32.const	$2=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push8=, 1
	i32.shl 	$push0=, $pop8, $2
	i32.eq  	$push1=, $pop0, $0
	i32.select	$1=, $2, $1, $pop1
	i32.const	$push7=, 1
	i32.add 	$2=, $2, $pop7
	i32.const	$push6=, 9
	i32.gt_s	$push2=, $2, $pop6
	br_if   	1, $pop2        # 1: down to label1
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push9=, 0
	i32.lt_s	$push3=, $1, $pop9
	br_if   	0, $pop3        # 0: up to label0
.LBB0_3:                                # %for.end
	end_loop                        # label1:
	block
	i32.const	$push4=, -1
	i32.le_s	$push5=, $1, $pop4
	br_if   	0, $pop5        # 0: down to label2
# BB#4:                                 # %if.end5
	return
.LBB0_5:                                # %if.then4
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
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
	i32.const	$push0=, 64
	call    	foo@FUNCTION, $pop0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
