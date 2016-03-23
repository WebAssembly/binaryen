	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr46909-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 1
	i32.const	$push12=, 1
	i32.const	$push7=, -1
	i32.const	$push0=, 2
	i32.or  	$push1=, $0, $pop0
	i32.const	$push2=, 6
	i32.ne  	$push3=, $pop1, $pop2
	i32.select	$push9=, $pop12, $pop7, $pop3
	i32.const	$push4=, 4
	i32.or  	$push5=, $0, $pop4
	i32.const	$push11=, 6
	i32.eq  	$push6=, $pop5, $pop11
	i32.select	$push10=, $pop8, $pop9, $pop6
	return  	$pop10
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -14
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	i32.const	$push13=, 4
	i32.add 	$push0=, $1, $pop13
	i32.call	$push1=, foo@FUNCTION, $pop0
	i32.const	$push12=, 1
	i32.eqz 	$push2=, $1
	i32.const	$push11=, 1
	i32.shl 	$push3=, $pop2, $pop11
	i32.sub 	$push4=, $pop12, $pop3
	i32.ne  	$push5=, $pop1, $pop4
	br_if   	2, $pop5        # 2: down to label0
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push10=, 5
	i32.add 	$0=, $1, $pop10
	i32.const	$push9=, 1
	i32.add 	$1=, $1, $pop9
	i32.const	$push8=, 9
	i32.le_s	$push6=, $0, $pop8
	br_if   	0, $pop6        # 0: up to label1
# BB#3:                                 # %for.end
	end_loop                        # label2:
	i32.const	$push7=, 0
	return  	$pop7
.LBB1_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
