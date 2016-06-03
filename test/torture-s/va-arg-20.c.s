	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-20.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 7
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, -8
	i32.and 	$push3=, $pop1, $pop2
	i64.load	$push4=, 0($pop3)
	i64.const	$push5=, 16
	i64.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push15=, $pop9, $pop10
	i32.store	$push17=, __stack_pointer($pop11), $pop15
	tee_local	$push16=, $3=, $pop17
	i32.store	$push0=, 12($pop16), $2
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push4=, $pop2, $pop3
	i64.load	$push5=, 0($pop4)
	i64.const	$push6=, 16
	i64.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label1
# BB#1:                                 # %foo.exit
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $3, $pop12
	i32.store	$drop=, __stack_pointer($pop14), $pop13
	return
.LBB1_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push6=, $pop3, $pop4
	i32.store	$push10=, __stack_pointer($pop5), $pop6
	tee_local	$push9=, $0=, $pop10
	i64.const	$push0=, 16
	i64.store	$drop=, 0($pop9), $pop0
	i32.const	$push1=, 0
	i32.const	$push8=, 0
	call    	bar@FUNCTION, $pop1, $pop8, $0
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
