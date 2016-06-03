	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr38212.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $1, $pop0
	i32.sub 	$push2=, $0, $pop1
	i32.const	$push3=, 4
	i32.add 	$push8=, $pop2, $pop3
	tee_local	$push7=, $1=, $pop8
	i32.load	$2=, 0($pop7)
	i32.const	$push4=, 1
	i32.store	$drop=, 0($0), $pop4
	i32.load	$push5=, 0($1)
	i32.add 	$push6=, $2, $pop5
                                        # fallthrough-return: $pop6
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
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push13=, $pop5, $pop6
	i32.store	$push16=, __stack_pointer($pop7), $pop13
	tee_local	$push15=, $1=, $pop16
	i32.const	$push0=, 0
	i32.store	$0=, 12($pop15), $pop0
	block
	i32.const	$push11=, 12
	i32.add 	$push12=, $1, $pop11
	i32.const	$push1=, 1
	i32.call	$push2=, foo@FUNCTION, $pop12, $pop1
	i32.const	$push14=, 1
	i32.ne  	$push3=, $pop2, $pop14
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $1, $pop8
	i32.store	$drop=, __stack_pointer($pop10), $pop9
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
