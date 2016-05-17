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
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	block
	block
	i32.load	$push0=, 0($0)
	i32.ne  	$push1=, $pop0, $1
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %lor.lhs.false
	i32.const	$push2=, 4
	i32.add 	$push3=, $0, $pop2
	i32.load	$push4=, 0($pop3)
	i32.eq  	$push5=, $pop4, $2
	br_if   	1, $pop5        # 1: down to label0
.LBB1_2:                                # %if.then
	end_block                       # label1:
	i32.load	$5=, 16($0)
	i32.const	$push19=, 4
	i32.add 	$push20=, $0, $pop19
	i32.load	$push6=, 20($0)
	f64.convert_s/i32	$push13=, $pop6
	f64.const	$push8=, 0x0p0
	f64.mul 	$push14=, $pop13, $pop8
	f64.const	$push10=, 0x1p-1
	f64.mul 	$push15=, $pop14, $pop10
	i32.trunc_s/f64	$push16=, $pop15
	i32.add 	$push18=, $pop16, $2
	i32.store	$discard=, 0($pop20), $pop18
	f64.convert_s/i32	$push7=, $5
	f64.const	$push22=, 0x0p0
	f64.mul 	$push9=, $pop7, $pop22
	f64.const	$push21=, 0x1p-1
	f64.mul 	$push11=, $pop9, $pop21
	i32.trunc_s/f64	$push12=, $pop11
	i32.add 	$push17=, $pop12, $1
	i32.store	$discard=, 0($0), $pop17
	i32.store	$discard=, 8($0), $3
	i32.store	$discard=, 12($0), $4
.LBB1_3:                                # %if.end
	end_block                       # label0:
	return
	.endfunc
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
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
