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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push6=, __stack_pointer
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 16
	i32.sub 	$4=, $pop7, $pop8
	i32.const	$push9=, __stack_pointer
	i32.store	$discard=, 0($pop9), $4
	i32.store	$discard=, 12($4), $0
	i32.const	$push0=, 1
	i32.store	$0=, 8($4):p2align=3, $pop0
	i32.const	$3=, 8
	i32.add 	$3=, $4, $3
	i32.call	$push1=, bar@FUNCTION, $3
	i32.store	$discard=, 4($pop1), $1
	i32.load	$push5=, 12($4)
	tee_local	$push4=, $2=, $pop5
	i32.const	$push2=, 0
	i32.store	$discard=, 0($pop4), $pop2
	i32.store	$discard=, 0($1), $0
	i32.load	$push3=, 0($2)
	i32.const	$push10=, 16
	i32.add 	$4=, $4, $pop10
	i32.const	$push11=, __stack_pointer
	i32.store	$discard=, 0($pop11), $4
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 16
	i32.sub 	$2=, $pop5, $pop6
	i32.const	$push7=, __stack_pointer
	i32.store	$discard=, 0($pop7), $2
	i32.const	$0=, 12
	i32.add 	$0=, $2, $0
	i32.const	$1=, 8
	i32.add 	$1=, $2, $1
	block
	i32.call	$push0=, foo@FUNCTION, $0, $1
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push3=, 0
	i32.const	$push8=, 16
	i32.add 	$2=, $2, $pop8
	i32.const	$push9=, __stack_pointer
	i32.store	$discard=, 0($pop9), $2
	return  	$pop3
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
