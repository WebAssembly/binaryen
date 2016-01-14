	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/restrict-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$push1=, 0($2)
	i32.load	$push0=, 0($1)
	i32.add 	$push2=, $pop1, $pop0
	i32.store	$discard=, 0($0), $pop2
	i32.const	$push3=, 0
	i32.store	$discard=, 4($0), $pop3
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 1
	i32.shl 	$1=, $pop0, $pop1
	i32.const	$push3=, 4
	i32.add 	$push4=, $0, $pop3
	i64.const	$push5=, 0
	i64.store32	$discard=, 0($pop4), $pop5
	i64.extend_u/i32	$push2=, $1
	i64.store32	$discard=, 0($0), $pop2
	i32.const	$push6=, 2
	i32.ne  	$push7=, $1, $pop6
	br_if   	$pop7, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %bar.exit
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
