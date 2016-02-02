	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr47337.c"
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
	loop                            # label0:
	i32.const	$push32=, 1
	i32.store	$discard=, a+1024($1), $pop32
	i32.const	$push31=, 4
	i32.add 	$1=, $1, $pop31
	br_if   	$1, 0           # 0: up to label0
# BB#2:                                 # %for.cond7.preheader
	end_loop                        # label1:
	i32.const	$push3=, 0
	i32.const	$push33=, 0
	i32.store	$1=, d($pop3), $pop33
	block
	i32.const	$push48=, 0
	i32.eq  	$push49=, $0, $pop48
	br_if   	$pop49, 0       # 0: down to label2
# BB#3:                                 # %fnx.exit
	i32.load	$push4=, b($1)
	i32.const	$push5=, 1
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 2
	i32.shl 	$push8=, $pop6, $pop7
	i32.load	$push9=, a($pop8)
	i32.const	$push47=, 1
	i32.and 	$push10=, $pop9, $pop47
	i32.const	$push46=, 2
	i32.shl 	$push11=, $pop10, $pop46
	i32.load	$push12=, a($pop11)
	i32.const	$push45=, 1
	i32.and 	$push13=, $pop12, $pop45
	i32.const	$push44=, 2
	i32.shl 	$push14=, $pop13, $pop44
	i32.load	$push15=, a($pop14)
	i32.const	$push43=, 1
	i32.and 	$push16=, $pop15, $pop43
	i32.const	$push42=, 2
	i32.shl 	$push17=, $pop16, $pop42
	i32.load	$push18=, a($pop17)
	i32.const	$push41=, 1
	i32.and 	$push19=, $pop18, $pop41
	i32.const	$push40=, 2
	i32.shl 	$push20=, $pop19, $pop40
	i32.load	$push21=, a($pop20)
	i32.const	$push39=, 1
	i32.and 	$push22=, $pop21, $pop39
	i32.const	$push38=, 2
	i32.shl 	$push23=, $pop22, $pop38
	i32.load	$push24=, a($pop23)
	i32.const	$push37=, 1
	i32.and 	$push25=, $pop24, $pop37
	i32.const	$push36=, 2
	i32.shl 	$push26=, $pop25, $pop36
	i32.load	$push27=, a($pop26)
	i32.const	$push35=, 1
	i32.and 	$push28=, $pop27, $pop35
	i32.const	$push34=, 2
	i32.shl 	$push29=, $pop28, $pop34
	i32.load	$push30=, a($pop29)
	i32.store	$discard=, b($1), $pop30
.LBB0_4:                                # %if.end25
	end_block                       # label2:
	return  	$1
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
	.lcomm	a,1024,4
	.type	d,@object               # @d
	.lcomm	d,4,2
	.type	b,@object               # @b
	.lcomm	b,4,2

	.ident	"clang version 3.9.0 "
