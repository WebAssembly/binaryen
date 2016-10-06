	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56962.c"
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
	.local  	i32, i64, i32, i64
# BB#0:                                 # %entry
	i32.const	$push2=, 5
	i32.mul 	$push36=, $2, $pop2
	tee_local	$push35=, $3=, $pop36
	i32.const	$push0=, 2
	i32.shl 	$push1=, $1, $pop0
	i32.add 	$push3=, $pop35, $pop1
	i32.const	$push4=, 3
	i32.shl 	$push5=, $pop3, $pop4
	i32.add 	$push6=, $0, $pop5
	i64.load	$4=, 0($pop6)
	i32.const	$push34=, 3
	i32.mul 	$push33=, $1, $pop34
	tee_local	$push32=, $5=, $pop33
	i32.add 	$push7=, $3, $pop32
	i32.const	$push31=, 3
	i32.shl 	$push8=, $pop7, $pop31
	i32.add 	$push9=, $0, $pop8
	i64.load	$6=, 0($pop9)
	i32.const	$push30=, 5
	i32.shl 	$push15=, $1, $pop30
	i32.add 	$push16=, $0, $pop15
	i32.const	$push29=, 2
	i32.shl 	$push10=, $2, $pop29
	i32.add 	$push11=, $pop10, $5
	i32.const	$push28=, 3
	i32.shl 	$push12=, $pop11, $pop28
	i32.add 	$push13=, $0, $pop12
	i64.load	$push14=, 0($pop13)
	i64.store	0($pop16), $pop14
	i32.add 	$push17=, $3, $1
	i32.const	$push27=, 3
	i32.shl 	$push18=, $pop17, $pop27
	i32.add 	$push19=, $0, $pop18
	call    	bar@FUNCTION, $pop19
	i32.const	$push26=, 5
	i32.mul 	$push21=, $1, $pop26
	i32.add 	$push22=, $3, $pop21
	i32.const	$push25=, 3
	i32.shl 	$push23=, $pop22, $pop25
	i32.add 	$push24=, $0, $pop23
	i64.add 	$push20=, $4, $6
	i64.store	0($pop24), $pop20
                                        # fallthrough-return
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
	i32.const	$push2=, v
	i32.const	$push1=, 24
	i32.const	$push0=, 1
	call    	foo@FUNCTION, $pop2, $pop1, $pop0
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
