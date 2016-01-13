	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56962.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, v+232
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$3=, 2
	i32.const	$4=, 3
	i32.mul 	$5=, $1, $4
	i32.const	$6=, 5
	i32.mul 	$7=, $2, $6
	i32.add 	$push5=, $7, $5
	i32.shl 	$push6=, $pop5, $4
	i32.add 	$push7=, $0, $pop6
	i64.load	$8=, 0($pop7)
	i32.shl 	$push8=, $1, $3
	i32.add 	$push9=, $7, $pop8
	i32.shl 	$push10=, $pop9, $4
	i32.add 	$push11=, $0, $pop10
	i64.load	$9=, 0($pop11)
	i32.shl 	$push12=, $1, $6
	i32.add 	$push13=, $0, $pop12
	i32.shl 	$push0=, $2, $3
	i32.add 	$push1=, $pop0, $5
	i32.shl 	$push2=, $pop1, $4
	i32.add 	$push3=, $0, $pop2
	i64.load	$push4=, 0($pop3)
	i64.store	$discard=, 0($pop13), $pop4
	i32.add 	$push14=, $7, $1
	i32.shl 	$push15=, $pop14, $4
	i32.add 	$push16=, $0, $pop15
	call    	bar@FUNCTION, $pop16
	i32.mul 	$push18=, $1, $6
	i32.add 	$push19=, $7, $pop18
	i32.shl 	$push20=, $pop19, $4
	i32.add 	$push21=, $0, $pop20
	i64.add 	$push17=, $9, $8
	i64.store	$discard=, 0($pop21), $pop17
	return
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, v
	i32.const	$push2=, 24
	i32.const	$push1=, 1
	call    	foo@FUNCTION, $pop0, $pop2, $pop1
	i32.const	$push3=, 0
	return  	$pop3
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
	.align	4
v:
	.skip	1152
	.size	v, 1152


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
