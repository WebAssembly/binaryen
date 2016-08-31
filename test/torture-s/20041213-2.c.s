	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041213-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	block
	i32.eqz 	$push12=, $0
	br_if   	0, $pop12       # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$1=, 0
	i32.const	$2=, 1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	block
	block
	i32.ge_s	$push0=, $1, $2
	br_if   	0, $pop0        # 0: down to label5
# BB#3:                                 # %for.body3.lr.ph
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push8=, 1
	i32.add 	$push7=, $1, $pop8
	tee_local	$push6=, $4=, $pop7
	i32.gt_s	$push1=, $2, $4
	i32.select	$push5=, $2, $pop6, $pop1
	tee_local	$push4=, $4=, $pop5
	i32.add 	$push2=, $2, $pop4
	i32.sub 	$3=, $pop2, $1
	br      	1               # 1: down to label4
.LBB0_4:                                #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	copy_local	$3=, $2
	copy_local	$4=, $1
.LBB0_5:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.ne  	$push3=, $4, $2
	br_if   	3, $pop3        # 3: down to label0
# BB#6:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	copy_local	$1=, $2
	copy_local	$2=, $3
	i32.const	$push11=, -1
	i32.add 	$push10=, $0, $pop11
	tee_local	$push9=, $0=, $pop10
	br_if   	0, $pop9        # 0: up to label2
.LBB0_7:                                # %for.end7
	end_loop                        # label3:
	end_block                       # label1:
	return
.LBB0_8:                                # %if.then
	end_block                       # label0:
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
	i32.const	$push0=, 2
	call    	foo@FUNCTION, $pop0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
