	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010118-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32, i32
	.local  	f64, f64, i32, i32
# BB#0:                                 # %entry
	block   	.LBB1_3
	block   	.LBB1_2
	i32.load	$push0=, 0($0)
	i32.ne  	$push1=, $pop0, $1
	br_if   	$pop1, .LBB1_2
# BB#1:                                 # %lor.lhs.false
	i32.const	$push2=, 4
	i32.add 	$push3=, $0, $pop2
	i32.load	$push4=, 0($pop3)
	i32.eq  	$push5=, $pop4, $2
	br_if   	$pop5, .LBB1_3
.LBB1_2:                                # %if.then
	f64.const	$5=, 0x0p0
	f64.const	$6=, 0x1p-1
	i32.load	$push6=, 16($0)
	f64.convert_s/i32	$push8=, $pop6
	f64.mul 	$push9=, $pop8, $5
	f64.mul 	$push10=, $pop9, $6
	i32.trunc_s/f64	$7=, $pop10
	i32.load	$push7=, 20($0)
	f64.convert_s/i32	$push11=, $pop7
	f64.mul 	$push12=, $pop11, $5
	f64.mul 	$push13=, $pop12, $6
	i32.trunc_s/f64	$8=, $pop13
	i32.add 	$push14=, $7, $1
	i32.store	$discard=, 0($0), $pop14
	i32.const	$push16=, 4
	i32.add 	$push17=, $0, $pop16
	i32.add 	$push15=, $8, $2
	i32.store	$discard=, 0($pop17), $pop15
	i32.store	$discard=, 8($0), $3
	i32.store	$discard=, 12($0), $4
.LBB1_3:                                # %if.end
	return
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
