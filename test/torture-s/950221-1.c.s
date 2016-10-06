	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/950221-1.c"
	.section	.text.g1,"ax",@progbits
	.hidden	g1
	.globl	g1
	.type	g1,@function
g1:                                     # @g1
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	copy_local	$push0=, $2
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	g1, .Lfunc_end0-g1

	.section	.text.g2,"ax",@progbits
	.hidden	g2
	.globl	g2
	.type	g2,@function
g2:                                     # @g2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, -559038737
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	g2, .Lfunc_end1-g2

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push4=, 0
	i32.load	$push1=, parsefile($pop4)
	i32.load	$push3=, 0($pop1)
	tee_local	$push2=, $0=, $pop3
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push5=, 0
	i32.load	$push0=, el($pop5)
	i32.eqz 	$push6=, $pop0
	br_if   	0, $pop6        # 0: down to label1
# BB#2:                                 # %if.end
	return  	$0
.LBB2_3:                                # %alabel
	end_block                       # label1:
	i32.call	$drop=, g2@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f, .Lfunc_end2-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %alabel.i
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.store	el($pop0), $pop5
	i32.const	$push4=, 0
	i32.load	$push1=, parsefile($pop4)
	i32.const	$push2=, -559038737
	i32.store	0($pop1), $pop2
	i32.const	$push3=, -559038737
	i32.call	$drop=, g2@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	basepf                  # @basepf
	.type	basepf,@object
	.section	.bss.basepf,"aw",@nobits
	.globl	basepf
	.p2align	2
basepf:
	.skip	8
	.size	basepf, 8

	.hidden	parsefile               # @parsefile
	.type	parsefile,@object
	.section	.data.parsefile,"aw",@progbits
	.globl	parsefile
	.p2align	2
parsefile:
	.int32	basepf
	.size	parsefile, 4

	.hidden	el                      # @el
	.type	el,@object
	.section	.bss.el,"aw",@nobits
	.globl	el
	.p2align	2
el:
	.int32	0                       # 0x0
	.size	el, 4

	.hidden	filler                  # @filler
	.type	filler,@object
	.section	.bss.filler,"aw",@nobits
	.globl	filler
	.p2align	4
filler:
	.skip	522240
	.size	filler, 522240


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
