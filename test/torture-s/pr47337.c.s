	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr47337.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, w($pop0)
	i32.const	$push2=, .L.str.1
	i32.call	$0=, strcmp@FUNCTION, $pop1, $pop2
	i32.const	$1=, -1024
.LBB0_1:                                # %for.cond2.preheader
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push44=, a+1024
	i32.add 	$push3=, $1, $pop44
	i32.const	$push43=, 1
	i32.store	0($pop3), $pop43
	i32.const	$push42=, 4
	i32.add 	$push41=, $1, $pop42
	tee_local	$push40=, $1=, $pop41
	br_if   	0, $pop40       # 0: up to label0
# BB#2:                                 # %for.body9.preheader
	end_loop
	i32.const	$push46=, 0
	i32.const	$push45=, 0
	i32.store	d($pop46), $pop45
	block   	
	i32.eqz 	$push71=, $0
	br_if   	0, $pop71       # 0: down to label1
# BB#3:                                 # %fnx.exit
	i32.const	$push69=, 0
	i32.const	$push68=, 0
	i32.load	$push4=, b($pop68)
	i32.const	$push5=, 1
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 2
	i32.shl 	$push8=, $pop6, $pop7
	i32.const	$push9=, a
	i32.add 	$push10=, $pop8, $pop9
	i32.load	$push11=, 0($pop10)
	i32.const	$push67=, 1
	i32.and 	$push12=, $pop11, $pop67
	i32.const	$push66=, 2
	i32.shl 	$push13=, $pop12, $pop66
	i32.const	$push65=, a
	i32.add 	$push14=, $pop13, $pop65
	i32.load	$push15=, 0($pop14)
	i32.const	$push64=, 1
	i32.and 	$push16=, $pop15, $pop64
	i32.const	$push63=, 2
	i32.shl 	$push17=, $pop16, $pop63
	i32.const	$push62=, a
	i32.add 	$push18=, $pop17, $pop62
	i32.load	$push19=, 0($pop18)
	i32.const	$push61=, 1
	i32.and 	$push20=, $pop19, $pop61
	i32.const	$push60=, 2
	i32.shl 	$push21=, $pop20, $pop60
	i32.const	$push59=, a
	i32.add 	$push22=, $pop21, $pop59
	i32.load	$push23=, 0($pop22)
	i32.const	$push58=, 1
	i32.and 	$push24=, $pop23, $pop58
	i32.const	$push57=, 2
	i32.shl 	$push25=, $pop24, $pop57
	i32.const	$push56=, a
	i32.add 	$push26=, $pop25, $pop56
	i32.load	$push27=, 0($pop26)
	i32.const	$push55=, 1
	i32.and 	$push28=, $pop27, $pop55
	i32.const	$push54=, 2
	i32.shl 	$push29=, $pop28, $pop54
	i32.const	$push53=, a
	i32.add 	$push30=, $pop29, $pop53
	i32.load	$push31=, 0($pop30)
	i32.const	$push52=, 1
	i32.and 	$push32=, $pop31, $pop52
	i32.const	$push51=, 2
	i32.shl 	$push33=, $pop32, $pop51
	i32.const	$push50=, a
	i32.add 	$push34=, $pop33, $pop50
	i32.load	$push35=, 0($pop34)
	i32.const	$push49=, 1
	i32.and 	$push36=, $pop35, $pop49
	i32.const	$push48=, 2
	i32.shl 	$push37=, $pop36, $pop48
	i32.const	$push47=, a
	i32.add 	$push38=, $pop37, $pop47
	i32.load	$push39=, 0($pop38)
	i32.store	b($pop69), $pop39
.LBB0_4:                                # %if.end25
	end_block                       # label1:
	i32.const	$push70=, 0
                                        # fallthrough-return: $pop70
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

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

	.type	d,@object               # @d
	.section	.bss.d,"aw",@nobits
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.type	b,@object               # @b
	.section	.bss.b,"aw",@nobits
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	strcmp, i32, i32, i32
