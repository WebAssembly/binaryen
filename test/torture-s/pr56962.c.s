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
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.local  	i64, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, 5
	i32.mul 	$push9=, $2, $pop8
	tee_local	$push36=, $6=, $pop9
	i32.const	$push2=, 3
	i32.mul 	$push3=, $1, $pop2
	tee_local	$push35=, $5=, $pop3
	i32.add 	$push10=, $pop36, $pop35
	i32.const	$push34=, 3
	i32.shl 	$push11=, $pop10, $pop34
	i32.add 	$push12=, $0, $pop11
	i64.load	$3=, 0($pop12)
	i32.const	$push0=, 2
	i32.shl 	$push13=, $1, $pop0
	i32.add 	$push14=, $6, $pop13
	i32.const	$push33=, 3
	i32.shl 	$push15=, $pop14, $pop33
	i32.add 	$push16=, $0, $pop15
	i64.load	$4=, 0($pop16)
	i32.const	$push32=, 5
	i32.shl 	$push17=, $1, $pop32
	i32.add 	$push18=, $0, $pop17
	i32.const	$push31=, 2
	i32.shl 	$push1=, $2, $pop31
	i32.add 	$push4=, $pop1, $5
	i32.const	$push30=, 3
	i32.shl 	$push5=, $pop4, $pop30
	i32.add 	$push6=, $0, $pop5
	i64.load	$push7=, 0($pop6)
	i64.store	$discard=, 0($pop18), $pop7
	i32.add 	$push19=, $6, $1
	i32.const	$push29=, 3
	i32.shl 	$push20=, $pop19, $pop29
	i32.add 	$push21=, $0, $pop20
	call    	bar@FUNCTION, $pop21
	i32.const	$push28=, 5
	i32.mul 	$push23=, $1, $pop28
	i32.add 	$push24=, $6, $pop23
	i32.const	$push27=, 3
	i32.shl 	$push25=, $pop24, $pop27
	i32.add 	$push26=, $0, $pop25
	i64.add 	$push22=, $4, $3
	i64.store	$discard=, 0($pop26), $pop22
	return
	.endfunc
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
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
	.p2align	4
v:
	.skip	1152
	.size	v, 1152


	.ident	"clang version 3.9.0 "
