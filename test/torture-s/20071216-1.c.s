	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071216-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, x($pop0)
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.call	$push9=, bar@FUNCTION
	tee_local	$push8=, $0=, $pop9
	i32.const	$push3=, -37
	i32.const	$push2=, -1
	i32.const	$push0=, -38
	i32.eq  	$push1=, $0, $pop0
	i32.select	$push4=, $pop3, $pop2, $pop1
	i32.const	$push5=, -4095
	i32.lt_u	$push6=, $0, $pop5
	i32.select	$push7=, $pop8, $pop4, $pop6
                                        # fallthrough-return: $pop7
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
	i32.const	$push28=, 0
	i32.const	$push0=, 26
	i32.store	x($pop28), $pop0
	block   	
	i32.call	$push27=, bar@FUNCTION
	tee_local	$push26=, $0=, $pop27
	i32.const	$push25=, -37
	i32.const	$push24=, -1
	i32.const	$push23=, -38
	i32.eq  	$push1=, $0, $pop23
	i32.select	$push2=, $pop25, $pop24, $pop1
	i32.const	$push22=, -4095
	i32.lt_u	$push3=, $0, $pop22
	i32.select	$push4=, $pop26, $pop2, $pop3
	i32.const	$push21=, 26
	i32.ne  	$push5=, $pop4, $pop21
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push36=, 0
	i32.const	$push6=, -39
	i32.store	x($pop36), $pop6
	i32.call	$push35=, bar@FUNCTION
	tee_local	$push34=, $0=, $pop35
	i32.const	$push33=, -37
	i32.const	$push32=, -1
	i32.const	$push31=, -38
	i32.eq  	$push7=, $0, $pop31
	i32.select	$push8=, $pop33, $pop32, $pop7
	i32.const	$push30=, -4095
	i32.lt_u	$push9=, $0, $pop30
	i32.select	$push10=, $pop34, $pop8, $pop9
	i32.const	$push29=, -1
	i32.ne  	$push11=, $pop10, $pop29
	br_if   	0, $pop11       # 0: down to label0
# BB#2:                                 # %if.end4
	i32.const	$push41=, 0
	i32.const	$push12=, -38
	i32.store	x($pop41), $pop12
	i32.call	$push40=, bar@FUNCTION
	tee_local	$push39=, $0=, $pop40
	i32.const	$push15=, -37
	i32.const	$push14=, -1
	i32.const	$push38=, -38
	i32.eq  	$push13=, $0, $pop38
	i32.select	$push16=, $pop15, $pop14, $pop13
	i32.const	$push17=, -4095
	i32.lt_u	$push18=, $0, $pop17
	i32.select	$push19=, $pop39, $pop16, $pop18
	i32.const	$push37=, -37
	i32.ne  	$push20=, $pop19, $pop37
	br_if   	0, $pop20       # 0: down to label0
# BB#3:                                 # %if.end8
	i32.const	$push42=, 0
	return  	$pop42
.LBB2_4:                                # %if.then7
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	x,@object               # @x
	.section	.bss.x,"aw",@nobits
	.p2align	2
x:
	.int32	0                       # 0x0
	.size	x, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
