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
	br_if   	0, $pop1        # 0: down to label0
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
	i32.const	$push7=, 5
	i32.mul 	$push36=, $2, $pop7
	tee_local	$push35=, $6=, $pop36
	i32.const	$push2=, 3
	i32.mul 	$push34=, $1, $pop2
	tee_local	$push33=, $5=, $pop34
	i32.add 	$push8=, $pop35, $pop33
	i32.const	$push32=, 3
	i32.shl 	$push9=, $pop8, $pop32
	i32.add 	$push10=, $0, $pop9
	i64.load	$3=, 0($pop10)
	i32.const	$push0=, 2
	i32.shl 	$push11=, $1, $pop0
	i32.add 	$push12=, $6, $pop11
	i32.const	$push31=, 3
	i32.shl 	$push13=, $pop12, $pop31
	i32.add 	$push14=, $0, $pop13
	i64.load	$4=, 0($pop14)
	i32.const	$push30=, 5
	i32.shl 	$push15=, $1, $pop30
	i32.add 	$push16=, $0, $pop15
	i32.const	$push29=, 2
	i32.shl 	$push1=, $2, $pop29
	i32.add 	$push3=, $pop1, $5
	i32.const	$push28=, 3
	i32.shl 	$push4=, $pop3, $pop28
	i32.add 	$push5=, $0, $pop4
	i64.load	$push6=, 0($pop5)
	i64.store	$discard=, 0($pop16), $pop6
	i32.add 	$push17=, $6, $1
	i32.const	$push27=, 3
	i32.shl 	$push18=, $pop17, $pop27
	i32.add 	$push19=, $0, $pop18
	call    	bar@FUNCTION, $pop19
	i32.const	$push26=, 5
	i32.mul 	$push21=, $1, $pop26
	i32.add 	$push22=, $6, $pop21
	i32.const	$push25=, 3
	i32.shl 	$push23=, $pop22, $pop25
	i32.add 	$push24=, $0, $pop23
	i64.add 	$push20=, $4, $3
	i64.store	$discard=, 0($pop24), $pop20
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
