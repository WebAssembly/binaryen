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
	copy_local	$5=, $3
	block
	i32.le_s	$push0=, $1, $3
	br_if   	$pop0, 0        # 0: down to label0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	copy_local	$2=, $4
	i32.load	$4=, 0($0)
	i32.const	$push4=, 0
	i32.eq  	$push5=, $4, $pop4
	br_if   	$pop5, 1        # 1: down to label2
# BB#2:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	block
	i32.const	$push6=, 0
	i32.eq  	$push7=, $5, $pop6
	br_if   	$pop7, 0        # 0: down to label3
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.gt_s	$push1=, $4, $2
	br_if   	$pop1, 0        # 0: down to label3
# BB#4:                                 # %if.then3
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push2=, 4
	i32.add 	$0=, $0, $pop2
	i32.const	$5=, 1
	i32.add 	$3=, $3, $5
	i32.lt_s	$push3=, $3, $1
	br_if   	$pop3, 0        # 0: up to label1
.LBB0_6:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return
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
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
