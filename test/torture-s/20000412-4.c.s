	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000412-4.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.sub 	$5=, $0, $2
	block
	block
	i32.const	$push0=, 0
	i32.const	$push13=, 0
	i32.gt_s	$push1=, $5, $pop13
	i32.select	$push12=, $5, $pop0, $pop1
	tee_local	$push11=, $5=, $pop12
	i32.const	$push2=, 3
	i32.ge_s	$push3=, $pop11, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %for.body.lr.ph
	i32.add 	$push4=, $2, $5
	i32.const	$push14=, -1
	i32.add 	$push5=, $pop4, $pop14
	i32.sub 	$push6=, $pop5, $0
	i32.mul 	$push7=, $3, $pop6
	i32.add 	$push8=, $2, $pop7
	i32.sub 	$2=, $pop8, $1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.add 	$2=, $2, $3
	i32.const	$push17=, -1
	i32.le_s	$push9=, $2, $pop17
	br_if   	3, $pop9        # 3: down to label0
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push16=, 1
	i32.add 	$5=, $5, $pop16
	i32.const	$push15=, 2
	i32.le_s	$push10=, $5, $pop15
	br_if   	0, $pop10       # 0: up to label2
.LBB0_4:                                # %for.cond6.preheader
	end_loop                        # label3:
	end_block                       # label1:
	return
.LBB0_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %for.cond.i.2.1
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
