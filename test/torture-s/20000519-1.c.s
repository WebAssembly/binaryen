	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000519-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.load	$2=, 0($1)
	i32.const	$push3=, 4
	i32.add 	$1=, $1, $pop3
	i32.const	$push2=, 10
	i32.gt_s	$push0=, $2, $pop2
	br_if   	0, $pop0        # 0: up to label0
# BB#2:                                 # %do.end
	end_loop                        # label1:
	i32.add 	$push1=, $2, $0
	return  	$pop1
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 16
	i32.sub 	$3=, $pop5, $pop6
	i32.store	$discard=, 12($3), $1
.LBB1_1:                                # %do.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.load	$2=, 0($1)
	i32.const	$push3=, 4
	i32.add 	$1=, $1, $pop3
	i32.const	$push2=, 10
	i32.gt_s	$push0=, $2, $pop2
	br_if   	0, $pop0        # 0: up to label2
# BB#2:                                 # %bar.exit
	end_loop                        # label3:
	i32.add 	$push1=, $2, $0
	return  	$pop1
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, __stack_pointer
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 16
	i32.sub 	$0=, $pop7, $pop8
	i32.const	$push9=, __stack_pointer
	i32.store	$discard=, 0($pop9), $0
	i64.const	$push0=, 12884901890
	i64.store	$discard=, 0($0):p2align=4, $pop0
	block
	i32.const	$push1=, 1
	i32.call	$push2=, foo@FUNCTION, $pop1, $0
	i32.const	$push3=, 3
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label4
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	i32.const	$push10=, 16
	i32.add 	$0=, $0, $pop10
	i32.const	$push11=, __stack_pointer
	i32.store	$discard=, 0($pop11), $0
	return  	$pop5
.LBB2_2:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
