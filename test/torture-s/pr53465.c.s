	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr53465.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
                                        # implicit-def: %vreg19
	i32.const	$5=, 0
	block
	i32.const	$push4=, 0
	i32.le_s	$push0=, $1, $pop4
	br_if   	0, $pop0        # 0: down to label0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	copy_local	$2=, $4
	i32.load	$4=, 0($0)
	i32.const	$push6=, 0
	i32.eq  	$push7=, $4, $pop6
	br_if   	1, $pop7        # 1: down to label2
# BB#2:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	block
	i32.const	$push8=, 0
	i32.eq  	$push9=, $5, $pop8
	br_if   	0, $pop9        # 0: down to label3
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.gt_s	$push1=, $4, $2
	br_if   	0, $pop1        # 0: down to label3
# BB#4:                                 # %if.then3
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push2=, 4
	i32.add 	$0=, $0, $pop2
	i32.const	$5=, 1
	i32.const	$push5=, 1
	i32.add 	$3=, $3, $pop5
	i32.lt_s	$push3=, $3, $1
	br_if   	0, $pop3        # 0: up to label1
.LBB0_6:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %for.cond.i.1
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
