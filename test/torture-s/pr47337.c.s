	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr47337.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$push0=, w($1)
	i32.const	$push1=, .str.1
	i32.call	$0=, strcmp, $pop0, $pop1
	i32.const	$4=, -1024
BB0_1:                                  # %for.cond2.preheader
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_2
	i32.const	$2=, a
	i32.add 	$push2=, $2, $4
	i32.const	$push3=, 1024
	i32.add 	$push4=, $pop2, $pop3
	i32.const	$push5=, 1
	i32.store	$3=, 0($pop4), $pop5
	i32.const	$push6=, 4
	i32.add 	$4=, $4, $pop6
	br_if   	$4, BB0_1
BB0_2:                                  # %for.cond7.preheader
	i32.store	$discard=, d($1), $1
	block   	BB0_4
	i32.const	$push40=, 0
	i32.eq  	$push41=, $0, $pop40
	br_if   	$pop41, BB0_4
# BB#3:                                 # %fnx.exit
	i32.const	$4=, 2
	i32.load	$push7=, b($1)
	i32.and 	$push8=, $pop7, $3
	i32.shl 	$push9=, $pop8, $4
	i32.add 	$push10=, $2, $pop9
	i32.load	$push11=, 0($pop10)
	i32.and 	$push12=, $pop11, $3
	i32.shl 	$push13=, $pop12, $4
	i32.add 	$push14=, $2, $pop13
	i32.load	$push15=, 0($pop14)
	i32.and 	$push16=, $pop15, $3
	i32.shl 	$push17=, $pop16, $4
	i32.add 	$push18=, $2, $pop17
	i32.load	$push19=, 0($pop18)
	i32.and 	$push20=, $pop19, $3
	i32.shl 	$push21=, $pop20, $4
	i32.add 	$push22=, $2, $pop21
	i32.load	$push23=, 0($pop22)
	i32.and 	$push24=, $pop23, $3
	i32.shl 	$push25=, $pop24, $4
	i32.add 	$push26=, $2, $pop25
	i32.load	$push27=, 0($pop26)
	i32.and 	$push28=, $pop27, $3
	i32.shl 	$push29=, $pop28, $4
	i32.add 	$push30=, $2, $pop29
	i32.load	$push31=, 0($pop30)
	i32.and 	$push32=, $pop31, $3
	i32.shl 	$push33=, $pop32, $4
	i32.add 	$push34=, $2, $pop33
	i32.load	$push35=, 0($pop34)
	i32.and 	$push36=, $pop35, $3
	i32.shl 	$push37=, $pop36, $4
	i32.add 	$push38=, $2, $pop37
	i32.load	$push39=, 0($pop38)
	i32.store	$discard=, b($1), $pop39
BB0_4:                                  # %if.end25
	return  	$1
func_end0:
	.size	main, func_end0-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"2"
	.size	.str, 2

	.type	w,@object               # @w
	.data
	.globl	w
	.align	2
w:
	.int32	.str
	.size	w, 4

	.type	.str.1,@object          # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.str.1:
	.asciz	"1"
	.size	.str.1, 2

	.type	a,@object               # @a
	.lcomm	a,1024,4
	.type	d,@object               # @d
	.lcomm	d,4,2
	.type	b,@object               # @b
	.lcomm	b,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
