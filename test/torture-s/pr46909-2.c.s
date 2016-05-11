	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr46909-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	block
	i32.const	$push0=, 13
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$1=, 1
	br_if   	1, $0           # 1: down to label0
.LBB0_2:                                # %if.end
	end_block                       # label1:
	i32.const	$1=, -1
.LBB0_3:                                # %return
	end_block                       # label0:
	return  	$1
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
	i32.const	$0=, -10
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.call	$push0=, foo@FUNCTION, $0
	i32.const	$push13=, 1
	i32.eqz 	$push1=, $0
	i32.const	$push12=, 1
	i32.shl 	$push2=, $pop1, $pop12
	i32.sub 	$push3=, $pop13, $pop2
	i32.const	$push11=, 13
	i32.eq  	$push4=, $0, $pop11
	i32.const	$push10=, 1
	i32.shl 	$push5=, $pop4, $pop10
	i32.sub 	$push6=, $pop3, $pop5
	i32.ne  	$push7=, $pop0, $pop6
	br_if   	2, $pop7        # 2: down to label2
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$0=, $0, $pop15
	i32.const	$push14=, 29
	i32.le_s	$push8=, $0, $pop14
	br_if   	0, $pop8        # 0: up to label3
# BB#3:                                 # %for.end
	end_loop                        # label4:
	i32.const	$push9=, 0
	return  	$pop9
.LBB1_4:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
