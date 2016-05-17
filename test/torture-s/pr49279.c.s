	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49279.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	return  	$0
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
	i32.const	$push6=, __stack_pointer
	i32.const	$push3=, __stack_pointer
	i32.load	$push4=, 0($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push12=, $pop4, $pop5
	i32.store	$push16=, 0($pop6), $pop12
	tee_local	$push15=, $3=, $pop16
	i32.store	$drop=, 12($pop15), $0
	i32.const	$push0=, 1
	i32.store	$0=, 8($3), $pop0
	i32.const	$push10=, 8
	i32.add 	$push11=, $3, $pop10
	i32.call	$push1=, bar@FUNCTION, $pop11
	i32.store	$drop=, 4($pop1), $1
	i32.load	$push14=, 12($3)
	tee_local	$push13=, $2=, $pop14
	i32.const	$push2=, 0
	i32.store	$drop=, 0($pop13), $pop2
	i32.store	$drop=, 0($1), $0
	i32.load	$0=, 0($2)
	i32.const	$push9=, __stack_pointer
	i32.const	$push7=, 16
	i32.add 	$push8=, $3, $pop7
	i32.store	$drop=, 0($pop9), $pop8
	return  	$0
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
	block
	i32.const	$push7=, __stack_pointer
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push15=, $pop5, $pop6
	i32.store	$push17=, 0($pop7), $pop15
	tee_local	$push16=, $0=, $pop17
	i32.const	$push11=, 12
	i32.add 	$push12=, $pop16, $pop11
	i32.const	$push13=, 8
	i32.add 	$push14=, $0, $pop13
	i32.call	$push0=, foo@FUNCTION, $pop12, $pop14
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push10=, __stack_pointer
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	$drop=, 0($pop10), $pop9
	i32.const	$push3=, 0
	return  	$pop3
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
