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
	i32.const	$push4=, 4
	i32.add 	$push0=, $1, $pop4
	copy_local	$1=, $pop0
	i32.const	$push3=, 10
	i32.gt_s	$push1=, $2, $pop3
	br_if   	0, $pop1        # 0: up to label0
# BB#2:                                 # %do.end
	end_loop                        # label1:
	i32.add 	$push2=, $2, $0
                                        # fallthrough-return: $pop2
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
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push6=, $pop4, $pop5
	i32.store	$drop=, 12($pop6), $1
.LBB1_1:                                # %do.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.load	$2=, 0($1)
	i32.const	$push8=, 4
	i32.add 	$push0=, $1, $pop8
	copy_local	$1=, $pop0
	i32.const	$push7=, 10
	i32.gt_s	$push1=, $2, $pop7
	br_if   	0, $pop1        # 0: up to label2
# BB#2:                                 # %bar.exit
	end_loop                        # label3:
	i32.add 	$push2=, $2, $0
                                        # fallthrough-return: $pop2
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
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push13=, $pop7, $pop8
	i32.store	$push15=, __stack_pointer($pop9), $pop13
	tee_local	$push14=, $0=, $pop15
	i64.const	$push0=, 12884901890
	i64.store	$drop=, 0($pop14), $pop0
	block
	i32.const	$push1=, 1
	i32.call	$push2=, foo@FUNCTION, $pop1, $0
	i32.const	$push3=, 3
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label4
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $0, $pop10
	i32.store	$drop=, __stack_pointer($pop12), $pop11
	i32.const	$push5=, 0
	return  	$pop5
.LBB2_2:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
