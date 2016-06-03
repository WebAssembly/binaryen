	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20080506-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push7=, 0($0)
	tee_local	$push6=, $0=, $pop7
	i32.const	$push1=, 1
	i32.store	$drop=, 0($pop6), $pop1
	block
	i32.load	$push2=, 0($1)
	i32.const	$push3=, 2
	i32.store	$push0=, 0($pop2), $pop3
	i32.load	$push4=, 0($0)
	i32.ne  	$push5=, $pop0, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push1=, 0
	i32.load	$push2=, __stack_pointer($pop1)
	i32.const	$push3=, 16
	i32.sub 	$push16=, $pop2, $pop3
	i32.store	$push18=, __stack_pointer($pop4), $pop16
	tee_local	$push17=, $0=, $pop18
	i32.const	$push8=, 12
	i32.add 	$push9=, $0, $pop8
	i32.store	$drop=, 8($pop17), $pop9
	i32.const	$push10=, 12
	i32.add 	$push11=, $0, $pop10
	i32.store	$drop=, 4($0), $pop11
	i32.const	$push12=, 8
	i32.add 	$push13=, $0, $pop12
	i32.const	$push14=, 4
	i32.add 	$push15=, $0, $pop14
	call    	foo@FUNCTION, $pop13, $pop15
	i32.const	$push7=, 0
	i32.const	$push5=, 16
	i32.add 	$push6=, $0, $pop5
	i32.store	$drop=, __stack_pointer($pop7), $pop6
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
