	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-7.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$2=, -1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$1=, 1
	i32.shl 	$push0=, $1, $3
	i32.eq  	$push1=, $pop0, $0
	i32.select	$2=, $pop1, $3, $2
	i32.add 	$3=, $3, $1
	i32.const	$push2=, 9
	i32.gt_s	$push3=, $3, $pop2
	br_if   	$pop3, 1        # 1: down to label1
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push4=, 0
	i32.lt_s	$push5=, $2, $pop4
	br_if   	$pop5, 0        # 0: up to label0
.LBB0_3:                                # %for.end
	end_loop                        # label1:
	block
	i32.const	$push6=, -1
	i32.le_s	$push7=, $2, $pop6
	br_if   	$pop7, 0        # 0: down to label2
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 1
	i32.const	$2=, -1
	copy_local	$1=, $0
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push0=, 7
	i32.eq  	$push1=, $1, $pop0
	i32.const	$push2=, 6
	i32.select	$2=, $pop1, $pop2, $2
	i32.const	$push3=, 9
	i32.gt_s	$push4=, $1, $pop3
	br_if   	$pop4, 1        # 1: down to label4
# BB#2:                                 # %for.body.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$1=, $1, $0
	i32.const	$push5=, 0
	i32.lt_s	$push6=, $2, $pop5
	br_if   	$pop6, 0        # 0: up to label3
.LBB1_3:                                # %for.end.i
	end_loop                        # label4:
	block
	i32.const	$push7=, -1
	i32.gt_s	$push8=, $2, $pop7
	br_if   	$pop8, 0        # 0: down to label5
# BB#4:                                 # %if.then4.i
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %foo.exit
	end_block                       # label5:
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
