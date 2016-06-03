	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20051215-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
	block
	i32.const	$push6=, 1
	i32.lt_s	$push0=, $1, $pop6
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i32.const	$3=, 0
	i32.const	$4=, 0
	i32.const	$5=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	block
	i32.eqz 	$push12=, $2
	br_if   	0, $pop12       # 0: down to label3
# BB#3:                                 # %if.then
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$push1=, 0($2)
	i32.mul 	$4=, $pop1, $3
.LBB0_4:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.mul 	$push3=, $4, $0
	i32.const	$push11=, 0
	i32.const	$push10=, 0
	i32.gt_s	$push2=, $0, $pop10
	i32.select	$push4=, $pop3, $pop11, $pop2
	i32.add 	$5=, $5, $pop4
	i32.const	$push9=, 1
	i32.add 	$push8=, $3, $pop9
	tee_local	$push7=, $3=, $pop8
	i32.ne  	$push5=, $1, $pop7
	br_if   	0, $pop5        # 0: up to label1
.LBB0_5:                                # %for.end6
	end_loop                        # label2:
	end_block                       # label0:
	copy_local	$push13=, $5
                                        # fallthrough-return: $pop13
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
	i32.const	$push1=, 3
	i32.const	$push0=, 2
	i32.const	$push3=, 0
	i32.call	$push2=, foo@FUNCTION, $pop1, $pop0, $pop3
	br_if   	0, $pop2        # 0: down to label4
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
