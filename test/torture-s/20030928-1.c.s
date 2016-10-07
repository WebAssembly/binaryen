	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030928-1.c"
	.section	.text.get_addrs,"ax",@progbits
	.hidden	get_addrs
	.globl	get_addrs
	.type	get_addrs,@function
get_addrs:                              # @get_addrs
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1)
	i32.const	$push1=, 1
	i32.shl 	$push2=, $pop0, $pop1
	i32.const	$push3=, .L.str-131072
	i32.add 	$push4=, $pop2, $pop3
	i32.store	0($0), $pop4
	i32.load	$push5=, 4($1)
	i32.const	$push39=, 1
	i32.shl 	$push6=, $pop5, $pop39
	i32.const	$push7=, .L.str.1-262144
	i32.add 	$push8=, $pop6, $pop7
	i32.store	4($0), $pop8
	i32.load	$push9=, 8($1)
	i32.const	$push38=, 1
	i32.shl 	$push10=, $pop9, $pop38
	i32.const	$push11=, .L.str.2-393216
	i32.add 	$push12=, $pop10, $pop11
	i32.store	8($0), $pop12
	i32.load	$push13=, 12($1)
	i32.const	$push37=, 1
	i32.shl 	$push14=, $pop13, $pop37
	i32.const	$push15=, .L.str.3-524288
	i32.add 	$push16=, $pop14, $pop15
	i32.store	12($0), $pop16
	i32.load	$push17=, 16($1)
	i32.const	$push36=, 1
	i32.shl 	$push18=, $pop17, $pop36
	i32.const	$push19=, .L.str.4-655360
	i32.add 	$push20=, $pop18, $pop19
	i32.store	16($0), $pop20
	i32.load	$push21=, 20($1)
	i32.const	$push35=, 1
	i32.shl 	$push22=, $pop21, $pop35
	i32.const	$push23=, .L.str.5-786432
	i32.add 	$push24=, $pop22, $pop23
	i32.store	20($0), $pop24
	i32.load	$push25=, 24($1)
	i32.const	$push34=, 1
	i32.shl 	$push26=, $pop25, $pop34
	i32.const	$push27=, .L.str.6-917504
	i32.add 	$push28=, $pop26, $pop27
	i32.store	24($0), $pop28
	i32.load	$push29=, 28($1)
	i32.const	$push33=, 1
	i32.shl 	$push30=, $pop29, $pop33
	i32.const	$push31=, .L.str.7-1048576
	i32.add 	$push32=, $pop30, $pop31
	i32.store	28($0), $pop32
                                        # fallthrough-return
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
