	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011219-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32
# BB#0:                                 # %entry
                                        # fallthrough-return
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
                                        # implicit-def: %vreg18
	block
	i32.const	$push0=, -10
	i32.add 	$push4=, $0, $pop0
	tee_local	$push3=, $0=, $pop4
	i32.const	$push1=, 4
	i32.gt_u	$push2=, $pop3, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %entry
	block
	br_table 	$0, 0, 0, 0, 0, 0, 0 # 0: down to label1
.LBB1_2:                                # %sw.bb4
	end_block                       # label1:
	i32.load	$2=, 0($1)
.LBB1_3:                                # %sw.epilog
	end_block                       # label0:
	copy_local	$push5=, $2
                                        # fallthrough-return: $pop5
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
	.functype	exit, void, i32
