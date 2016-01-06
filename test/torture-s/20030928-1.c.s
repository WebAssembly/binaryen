	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030928-1.c"
	.globl	get_addrs
	.type	get_addrs,@function
get_addrs:                              # @get_addrs
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 1
	i32.load	$push0=, 0($1)
	i32.shl 	$push1=, $pop0, $2
	i32.const	$push2=, .str
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -131072
	i32.add 	$push5=, $pop3, $pop4
	i32.store	$discard=, 0($0), $pop5
	i32.load	$push6=, 4($1)
	i32.shl 	$push7=, $pop6, $2
	i32.const	$push8=, .str.1
	i32.add 	$push9=, $pop7, $pop8
	i32.const	$push10=, -262144
	i32.add 	$push11=, $pop9, $pop10
	i32.store	$discard=, 4($0), $pop11
	i32.load	$push12=, 8($1)
	i32.shl 	$push13=, $pop12, $2
	i32.const	$push14=, .str.2
	i32.add 	$push15=, $pop13, $pop14
	i32.const	$push16=, -393216
	i32.add 	$push17=, $pop15, $pop16
	i32.store	$discard=, 8($0), $pop17
	i32.load	$push18=, 12($1)
	i32.shl 	$push19=, $pop18, $2
	i32.const	$push20=, .str.3
	i32.add 	$push21=, $pop19, $pop20
	i32.const	$push22=, -524288
	i32.add 	$push23=, $pop21, $pop22
	i32.store	$discard=, 12($0), $pop23
	i32.load	$push24=, 16($1)
	i32.shl 	$push25=, $pop24, $2
	i32.const	$push26=, .str.4
	i32.add 	$push27=, $pop25, $pop26
	i32.const	$push28=, -655360
	i32.add 	$push29=, $pop27, $pop28
	i32.store	$discard=, 16($0), $pop29
	i32.load	$push30=, 20($1)
	i32.shl 	$push31=, $pop30, $2
	i32.const	$push32=, .str.5
	i32.add 	$push33=, $pop31, $pop32
	i32.const	$push34=, -786432
	i32.add 	$push35=, $pop33, $pop34
	i32.store	$discard=, 20($0), $pop35
	i32.load	$push36=, 24($1)
	i32.shl 	$push37=, $pop36, $2
	i32.const	$push38=, .str.6
	i32.add 	$push39=, $pop37, $pop38
	i32.const	$push40=, -917504
	i32.add 	$push41=, $pop39, $pop40
	i32.store	$discard=, 24($0), $pop41
	i32.load	$push42=, 28($1)
	i32.shl 	$push43=, $pop42, $2
	i32.const	$push44=, .str.7
	i32.add 	$push45=, $pop43, $pop44
	i32.const	$push46=, -1048576
	i32.add 	$push47=, $pop45, $pop46
	i32.store	$discard=, 28($0), $pop47
	return
func_end0:
	.size	get_addrs, func_end0-get_addrs

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %for.cond2.7
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"a1111"
	.size	.str, 6

	.type	.str.1,@object          # @.str.1
.str.1:
	.asciz	"a1112"
	.size	.str.1, 6

	.type	.str.2,@object          # @.str.2
.str.2:
	.asciz	"a1113"
	.size	.str.2, 6

	.type	.str.3,@object          # @.str.3
.str.3:
	.asciz	"a1114"
	.size	.str.3, 6

	.type	.str.4,@object          # @.str.4
.str.4:
	.asciz	"a1115"
	.size	.str.4, 6

	.type	.str.5,@object          # @.str.5
.str.5:
	.asciz	"a1116"
	.size	.str.5, 6

	.type	.str.6,@object          # @.str.6
.str.6:
	.asciz	"a1117"
	.size	.str.6, 6

	.type	.str.7,@object          # @.str.7
.str.7:
	.asciz	"a1118"
	.size	.str.7, 6


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
