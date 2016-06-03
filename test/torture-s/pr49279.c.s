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
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
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
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push12=, $pop4, $pop5
	i32.store	$push16=, __stack_pointer($pop6), $pop12
	tee_local	$push15=, $2=, $pop16
	i32.store	$drop=, 12($pop15), $0
	i32.const	$push0=, 1
	i32.store	$0=, 8($2), $pop0
	i32.const	$push10=, 8
	i32.add 	$push11=, $2, $pop10
	i32.call	$push1=, bar@FUNCTION, $pop11
	i32.store	$drop=, 4($pop1), $1
	i32.load	$push14=, 12($2)
	tee_local	$push13=, $3=, $pop14
	i32.const	$push2=, 0
	i32.store	$drop=, 0($pop13), $pop2
	i32.store	$drop=, 0($1), $0
	i32.load	$1=, 0($3)
	i32.const	$push9=, 0
	i32.const	$push7=, 16
	i32.add 	$push8=, $2, $pop7
	i32.store	$drop=, __stack_pointer($pop9), $pop8
	copy_local	$push17=, $1
                                        # fallthrough-return: $pop17
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
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push15=, $pop5, $pop6
	i32.store	$push17=, __stack_pointer($pop7), $pop15
	tee_local	$push16=, $0=, $pop17
	i32.const	$push11=, 12
	i32.add 	$push12=, $pop16, $pop11
	i32.const	$push13=, 8
	i32.add 	$push14=, $0, $pop13
	i32.call	$push1=, foo@FUNCTION, $pop12, $pop14
	i32.const	$push0=, 1
	i32.ne  	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	$drop=, __stack_pointer($pop10), $pop9
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
	.functype	abort, void
