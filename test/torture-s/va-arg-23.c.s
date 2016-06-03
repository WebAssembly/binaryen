	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-23.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push18=, __stack_pointer($pop10), $pop14
	tee_local	$push17=, $8=, $pop18
	i32.store	$push16=, 12($8), $7
	tee_local	$push15=, $7=, $pop16
	i32.const	$push1=, 4
	i32.add 	$push2=, $pop15, $pop1
	i32.store	$drop=, 12($pop17), $pop2
	block
	i32.const	$push3=, 1
	i32.ne  	$push4=, $6, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %entry
	i32.load	$push0=, 0($7)
	i32.const	$push5=, 2
	i32.ne  	$push6=, $pop0, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $8, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	return
.LBB0_3:                                # %if.then
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
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 32
	i32.sub 	$push13=, $pop5, $pop6
	i32.store	$push15=, __stack_pointer($pop7), $pop13
	tee_local	$push14=, $0=, $pop15
	i64.load	$push0=, 24($0)
	i64.store	$drop=, 16($pop14):p2align=2, $pop0
	i32.const	$push1=, 2
	i32.store	$drop=, 0($0), $pop1
	i32.const	$push11=, 16
	i32.add 	$push12=, $0, $pop11
	i32.const	$push2=, 1
	call    	foo@FUNCTION, $0, $0, $0, $0, $0, $pop12, $pop2, $0
	i32.const	$push10=, 0
	i32.const	$push8=, 32
	i32.add 	$push9=, $0, $pop8
	i32.store	$drop=, __stack_pointer($pop10), $pop9
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
