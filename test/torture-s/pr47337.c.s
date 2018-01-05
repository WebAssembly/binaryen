	.text
	.file	"pr47337.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, w($pop0)
	i32.const	$push2=, .L.str.1
	i32.call	$0=, strcmp@FUNCTION, $pop1, $pop2
	i32.const	$1=, -1024
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push44=, a+1024
	i32.add 	$push3=, $1, $pop44
	i32.const	$push43=, 1
	i32.store	0($pop3), $pop43
	i32.const	$push42=, 4
	i32.add 	$1=, $1, $pop42
	br_if   	0, $1           # 0: up to label0
# %bb.2:                                # %for.end6
	end_loop
	block   	
	i32.eqz 	$push67=, $0
	br_if   	0, $pop67       # 0: down to label1
# %bb.3:                                # %if.then.i
	i32.const	$push4=, 0
	i32.const	$push66=, 0
	i32.load	$push5=, b($pop66)
	i32.const	$push6=, 1
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push8=, 2
	i32.shl 	$push9=, $pop7, $pop8
	i32.const	$push10=, a
	i32.add 	$push11=, $pop9, $pop10
	i32.load	$push12=, 0($pop11)
	i32.const	$push65=, 1
	i32.and 	$push13=, $pop12, $pop65
	i32.const	$push64=, 2
	i32.shl 	$push14=, $pop13, $pop64
	i32.const	$push63=, a
	i32.add 	$push15=, $pop14, $pop63
	i32.load	$push16=, 0($pop15)
	i32.const	$push62=, 1
	i32.and 	$push17=, $pop16, $pop62
	i32.const	$push61=, 2
	i32.shl 	$push18=, $pop17, $pop61
	i32.const	$push60=, a
	i32.add 	$push19=, $pop18, $pop60
	i32.load	$push20=, 0($pop19)
	i32.const	$push59=, 1
	i32.and 	$push21=, $pop20, $pop59
	i32.const	$push58=, 2
	i32.shl 	$push22=, $pop21, $pop58
	i32.const	$push57=, a
	i32.add 	$push23=, $pop22, $pop57
	i32.load	$push24=, 0($pop23)
	i32.const	$push56=, 1
	i32.and 	$push25=, $pop24, $pop56
	i32.const	$push55=, 2
	i32.shl 	$push26=, $pop25, $pop55
	i32.const	$push54=, a
	i32.add 	$push27=, $pop26, $pop54
	i32.load	$push28=, 0($pop27)
	i32.const	$push53=, 1
	i32.and 	$push29=, $pop28, $pop53
	i32.const	$push52=, 2
	i32.shl 	$push30=, $pop29, $pop52
	i32.const	$push51=, a
	i32.add 	$push31=, $pop30, $pop51
	i32.load	$push32=, 0($pop31)
	i32.const	$push50=, 1
	i32.and 	$push33=, $pop32, $pop50
	i32.const	$push49=, 2
	i32.shl 	$push34=, $pop33, $pop49
	i32.const	$push48=, a
	i32.add 	$push35=, $pop34, $pop48
	i32.load	$push36=, 0($pop35)
	i32.const	$push47=, 1
	i32.and 	$push37=, $pop36, $pop47
	i32.const	$push46=, 2
	i32.shl 	$push38=, $pop37, $pop46
	i32.const	$push45=, a
	i32.add 	$push39=, $pop38, $pop45
	i32.load	$push40=, 0($pop39)
	i32.store	b($pop4), $pop40
.LBB0_4:                                # %if.end25
	end_block                       # label1:
	i32.const	$push41=, 0
                                        # fallthrough-return: $pop41
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"2"
	.size	.L.str, 2

	.hidden	w                       # @w
	.type	w,@object
	.section	.data.w,"aw",@progbits
	.globl	w
	.p2align	2
w:
	.int32	.L.str
	.size	w, 4

	.type	.L.str.1,@object        # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.1:
	.asciz	"1"
	.size	.L.str.1, 2

	.type	a,@object               # @a
	.section	.bss.a,"aw",@nobits
	.p2align	4
a:
	.skip	1024
	.size	a, 1024

	.type	b,@object               # @b
	.section	.bss.b,"aw",@nobits
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	strcmp, i32, i32, i32
