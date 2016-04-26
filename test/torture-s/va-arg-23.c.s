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
	i32.const	$push9=, __stack_pointer
	i32.load	$push10=, 0($pop9)
	i32.const	$push11=, 16
	i32.sub 	$8=, $pop10, $pop11
	i32.const	$push12=, __stack_pointer
	i32.store	$discard=, 0($pop12), $8
	i32.store	$push8=, 12($8), $7
	tee_local	$push7=, $7=, $pop8
	i32.const	$push1=, 4
	i32.add 	$push2=, $pop7, $pop1
	i32.store	$discard=, 12($8), $pop2
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
	i32.const	$push15=, __stack_pointer
	i32.const	$push13=, 16
	i32.add 	$push14=, $8, $pop13
	i32.store	$discard=, 0($pop15), $pop14
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 32
	i32.sub 	$1=, $pop5, $pop6
	i32.const	$push7=, __stack_pointer
	i32.store	$discard=, 0($pop7), $1
	i64.load	$push0=, 24($1)
	i64.store	$discard=, 16($1):p2align=2, $pop0
	i32.const	$push1=, 2
	i32.store	$discard=, 0($1), $pop1
	i32.const	$push11=, 16
	i32.add 	$push12=, $1, $pop11
	i32.const	$push2=, 1
	call    	foo@FUNCTION, $0, $0, $0, $0, $0, $pop12, $pop2, $1
	i32.const	$push3=, 0
	i32.const	$push10=, __stack_pointer
	i32.const	$push8=, 32
	i32.add 	$push9=, $1, $pop8
	i32.store	$discard=, 0($pop10), $pop9
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
