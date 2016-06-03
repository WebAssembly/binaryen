	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pta-field-2.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -4
	i32.add 	$push1=, $0, $pop0
	i32.load	$push2=, 0($pop1)
	i32.const	$push3=, 0
	i32.store	$drop=, 0($pop2), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push15=, $pop5, $pop6
	i32.store	$push19=, __stack_pointer($pop7), $pop15
	tee_local	$push18=, $0=, $pop19
	i32.const	$push0=, 1
	i32.store	$drop=, 4($pop18), $pop0
	i32.const	$push1=, 2
	i32.store	$drop=, 0($0), $pop1
	i32.store	$push17=, 12($0), $0
	tee_local	$push16=, $0=, $pop17
	i32.const	$push11=, 4
	i32.add 	$push12=, $0, $pop11
	i32.store	$drop=, 8($pop16), $pop12
	i32.const	$push13=, 8
	i32.add 	$push14=, $0, $pop13
	i32.const	$push2=, 4
	i32.or  	$push3=, $pop14, $pop2
	call    	bar@FUNCTION, $pop3
	i32.load	$1=, 4($0)
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	$drop=, __stack_pointer($pop10), $pop9
	copy_local	$push20=, $1
                                        # fallthrough-return: $pop20
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
	i32.sub 	$push17=, $pop7, $pop8
	i32.store	$push21=, __stack_pointer($pop9), $pop17
	tee_local	$push20=, $0=, $pop21
	i32.const	$push0=, 1
	i32.store	$drop=, 4($pop20), $pop0
	i32.const	$push1=, 2
	i32.store	$drop=, 0($0), $pop1
	i32.store	$push19=, 12($0), $0
	tee_local	$push18=, $0=, $pop19
	i32.const	$push13=, 4
	i32.add 	$push14=, $0, $pop13
	i32.store	$drop=, 8($pop18), $pop14
	i32.const	$push15=, 8
	i32.add 	$push16=, $0, $pop15
	i32.const	$push2=, 4
	i32.or  	$push3=, $pop16, $pop2
	call    	bar@FUNCTION, $pop3
	block
	i32.load	$push4=, 4($0)
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $0, $pop10
	i32.store	$drop=, __stack_pointer($pop12), $pop11
	i32.const	$push5=, 0
	return  	$pop5
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
