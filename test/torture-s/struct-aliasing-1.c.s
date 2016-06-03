	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-aliasing-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$2=, 0($1)
	i32.const	$push0=, 0
	i32.store	$drop=, 0($0), $pop0
	i32.load	$push1=, 0($1)
	i32.add 	$push2=, $2, $pop1
                                        # fallthrough-return: $pop2
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
	block
	i32.const	$push8=, 0
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push16=, $pop6, $pop7
	i32.store	$push18=, __stack_pointer($pop8), $pop16
	tee_local	$push17=, $0=, $pop18
	i32.const	$push1=, 1
	i32.store	$push0=, 12($pop17), $pop1
	i32.const	$push12=, 12
	i32.add 	$push13=, $0, $pop12
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	i32.call	$push2=, foo@FUNCTION, $pop13, $pop15
	i32.ne  	$push3=, $pop0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $0, $pop9
	i32.store	$drop=, __stack_pointer($pop11), $pop10
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
