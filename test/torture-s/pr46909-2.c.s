	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr46909-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push3=, 1
	i32.const	$push14=, 1
	i32.const	$push13=, 1
	i32.const	$push2=, -1
	i32.const	$push0=, 13
	i32.ne  	$push1=, $0, $pop0
	i32.select	$push4=, $pop13, $pop2, $pop1
	i32.const	$push12=, -1
	i32.select	$push5=, $pop4, $pop12, $0
	i32.const	$push6=, 5
	i32.eq  	$push7=, $0, $pop6
	i32.select	$push8=, $pop14, $pop5, $pop7
	i32.const	$push9=, 20
	i32.eq  	$push10=, $0, $pop9
	i32.select	$push11=, $pop3, $pop8, $pop10
                                        # fallthrough-return: $pop11
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
	loop                            # label1:
	i32.call	$push6=, foo@FUNCTION, $0
	i32.const	$push13=, 1
	i32.eqz 	$push2=, $0
	i32.const	$push12=, 1
	i32.shl 	$push3=, $pop2, $pop12
	i32.sub 	$push4=, $pop13, $pop3
	i32.const	$push11=, 13
	i32.eq  	$push0=, $0, $pop11
	i32.const	$push10=, 1
	i32.shl 	$push1=, $pop0, $pop10
	i32.sub 	$push5=, $pop4, $pop1
	i32.ne  	$push7=, $pop6, $pop5
	br_if   	2, $pop7        # 2: down to label0
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push17=, 1
	i32.add 	$push16=, $0, $pop17
	tee_local	$push15=, $0=, $pop16
	i32.const	$push14=, 29
	i32.le_s	$push8=, $pop15, $pop14
	br_if   	0, $pop8        # 0: up to label1
# BB#3:                                 # %for.end
	end_loop                        # label2:
	i32.const	$push9=, 0
	return  	$pop9
.LBB1_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
