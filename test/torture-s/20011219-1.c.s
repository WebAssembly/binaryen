	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011219-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
                                        # implicit-def: %vreg13
	block
	i32.const	$push0=, -10
	i32.add 	$push4=, $0, $pop0
	tee_local	$push3=, $0=, $pop4
	i32.const	$push1=, 4
	i32.gt_u	$push2=, $pop3, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %entry
	block
	block
	block
	block
	block
	tableswitch	$0, 0, 0, 1, 2, 3, 4 # 0: down to label5
                                        # 1: down to label4
                                        # 2: down to label3
                                        # 3: down to label2
                                        # 4: down to label1
.LBB1_2:                                # %sw.bb
	end_block                       # label5:
	i32.load	$2=, 0($1)
	br      	4               # 4: down to label0
.LBB1_3:                                # %sw.bb1
	end_block                       # label4:
	i32.load	$2=, 0($1)
	br      	3               # 3: down to label0
.LBB1_4:                                # %sw.bb2
	end_block                       # label3:
	i32.load	$2=, 0($1)
	br      	2               # 2: down to label0
.LBB1_5:                                # %sw.bb3
	end_block                       # label2:
	i32.load	$2=, 0($1)
	br      	1               # 1: down to label0
.LBB1_6:                                # %sw.bb4
	end_block                       # label1:
	i32.load	$2=, 0($1)
.LBB1_7:                                # %sw.epilog
	end_block                       # label0:
	return  	$2
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
