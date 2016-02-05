	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030928-1.c"
	.section	.text.get_addrs,"ax",@progbits
	.hidden	get_addrs
	.globl	get_addrs
	.type	get_addrs,@function
get_addrs:                              # @get_addrs
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.load	$2=, 4($1)
	i32.load	$push0=, 0($1)
	i32.const	$push1=, 1
	i32.shl 	$push2=, $pop0, $pop1
	i32.const	$push3=, .L.str-131072
	i32.add 	$push4=, $pop2, $pop3
	i32.store	$discard=, 0($0), $pop4
	i32.load	$3=, 8($1)
	i32.const	$push32=, 1
	i32.shl 	$push5=, $2, $pop32
	i32.const	$push6=, .L.str.1-262144
	i32.add 	$push7=, $pop5, $pop6
	i32.store	$discard=, 4($0), $pop7
	i32.load	$2=, 12($1)
	i32.const	$push31=, 1
	i32.shl 	$push8=, $3, $pop31
	i32.const	$push9=, .L.str.2-393216
	i32.add 	$push10=, $pop8, $pop9
	i32.store	$discard=, 8($0), $pop10
	i32.load	$3=, 16($1)
	i32.const	$push30=, 1
	i32.shl 	$push11=, $2, $pop30
	i32.const	$push12=, .L.str.3-524288
	i32.add 	$push13=, $pop11, $pop12
	i32.store	$discard=, 12($0), $pop13
	i32.load	$2=, 20($1)
	i32.const	$push29=, 1
	i32.shl 	$push14=, $3, $pop29
	i32.const	$push15=, .L.str.4-655360
	i32.add 	$push16=, $pop14, $pop15
	i32.store	$discard=, 16($0), $pop16
	i32.load	$3=, 24($1)
	i32.const	$push28=, 1
	i32.shl 	$push17=, $2, $pop28
	i32.const	$push18=, .L.str.5-786432
	i32.add 	$push19=, $pop17, $pop18
	i32.store	$discard=, 20($0), $pop19
	i32.load	$1=, 28($1)
	i32.const	$push27=, 1
	i32.shl 	$push20=, $3, $pop27
	i32.const	$push21=, .L.str.6-917504
	i32.add 	$push22=, $pop20, $pop21
	i32.store	$discard=, 24($0), $pop22
	i32.const	$push26=, 1
	i32.shl 	$push23=, $1, $pop26
	i32.const	$push24=, .L.str.7-1048576
	i32.add 	$push25=, $pop23, $pop24
	i32.store	$discard=, 28($0), $pop25
	return
	.endfunc
.Lfunc_end0:
	.size	get_addrs, .Lfunc_end0-get_addrs

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %for.cond2.7
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"a1111"
	.size	.L.str, 6

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"a1112"
	.size	.L.str.1, 6

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"a1113"
	.size	.L.str.2, 6

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"a1114"
	.size	.L.str.3, 6

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"a1115"
	.size	.L.str.4, 6

	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"a1116"
	.size	.L.str.5, 6

	.type	.L.str.6,@object        # @.str.6
.L.str.6:
	.asciz	"a1117"
	.size	.L.str.6, 6

	.type	.L.str.7,@object        # @.str.7
.L.str.7:
	.asciz	"a1118"
	.size	.L.str.7, 6


	.ident	"clang version 3.9.0 "
