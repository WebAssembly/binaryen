	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pta-field-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.load	$push0=, 4($0)
	i32.const	$push1=, 0
	i32.store	$drop=, 0($pop0), $pop1
	return
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
	i32.const	$push5=, __stack_pointer
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push13=, $pop3, $pop4
	i32.store	$push17=, 0($pop5), $pop13
	tee_local	$push16=, $1=, $pop17
	i32.const	$push0=, 1
	i32.store	$drop=, 4($pop16), $pop0
	i32.const	$push1=, 2
	i32.store	$drop=, 0($1), $pop1
	i32.const	$push9=, 4
	i32.add 	$push10=, $1, $pop9
	i32.store	$drop=, 8($1), $pop10
	i32.store	$push15=, 12($1), $1
	tee_local	$push14=, $1=, $pop15
	i32.const	$push11=, 8
	i32.add 	$push12=, $pop14, $pop11
	call    	bar@FUNCTION, $pop12
	i32.load	$0=, 0($1)
	i32.const	$push8=, __stack_pointer
	i32.const	$push6=, 16
	i32.add 	$push7=, $1, $pop6
	i32.store	$drop=, 0($pop8), $pop7
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
	i32.const	$push7=, __stack_pointer
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push15=, $pop5, $pop6
	i32.store	$push19=, 0($pop7), $pop15
	tee_local	$push18=, $0=, $pop19
	i32.const	$push0=, 1
	i32.store	$drop=, 4($pop18), $pop0
	i32.const	$push1=, 2
	i32.store	$drop=, 0($0), $pop1
	i32.const	$push11=, 4
	i32.add 	$push12=, $0, $pop11
	i32.store	$drop=, 8($0), $pop12
	i32.store	$push17=, 12($0), $0
	tee_local	$push16=, $0=, $pop17
	i32.const	$push13=, 8
	i32.add 	$push14=, $pop16, $pop13
	call    	bar@FUNCTION, $pop14
	block
	i32.load	$push2=, 0($0)
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
