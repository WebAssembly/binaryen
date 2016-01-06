	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr53688.c"
	.globl	init
	.type	init,@function
init:                                   # @init
	.local  	i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$push1=, p
	i32.const	$push0=, .str
	i32.const	$push2=, 9
	call    	memcpy, $pop1, $pop0, $pop2
	i32.const	$0=, p+9
	i32.const	$push3=, 7
	i32.add 	$push4=, $0, $pop3
	i64.const	$push5=, 85
	i64.store8	$discard=, 0($pop4), $pop5
	i32.const	$push6=, 6
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 80
	i64.store8	$1=, 0($pop7), $pop8
	i32.const	$push9=, 5
	i32.add 	$push10=, $0, $pop9
	i64.const	$push11=, 67
	i64.store8	$2=, 0($pop10), $pop11
	i32.const	$push12=, 4
	i32.add 	$push13=, $0, $pop12
	i64.const	$push14=, 32
	i64.store8	$discard=, 0($pop13), $pop14
	i32.const	$push15=, 3
	i32.add 	$push16=, $0, $pop15
	i64.store8	$discard=, 0($pop16), $2
	i32.const	$push17=, 2
	i32.add 	$push18=, $0, $pop17
	i64.const	$push19=, 69
	i64.store8	$discard=, 0($pop18), $pop19
	i32.const	$push20=, 1
	i32.add 	$push21=, $0, $pop20
	i64.store8	$discard=, 0($pop21), $1
	i32.const	$push22=, 0
	i64.const	$push23=, 83
	i64.store8	$discard=, p+9($pop22), $pop23
	return
func_end0:
	.size	init, func_end0-init

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i64, i64, i32, i64, i64, i32, i64, i32, i64, i32
# BB#0:                                 # %entry
	call    	init
	i32.const	$1=, 9
	i32.const	$push1=, headline
	i32.const	$push0=, p
	call    	memcpy, $pop1, $pop0, $1
	i32.const	$0=, 32
	i32.const	$push2=, headline+9
	call    	memset, $pop2, $0, $1
	i32.const	$1=, p+9
	i32.const	$push3=, 3
	i32.add 	$push4=, $1, $pop3
	i64.load8_u	$2=, 0($pop4)
	i32.const	$4=, 2
	i32.add 	$push6=, $1, $4
	i64.load8_u	$5=, 0($pop6)
	i32.const	$push8=, 5
	i32.add 	$push9=, $1, $pop8
	i64.load8_u	$6=, 0($pop9)
	i32.const	$7=, 4
	i32.add 	$push11=, $1, $7
	i64.load8_u	$8=, 0($pop11)
	i32.const	$9=, 6
	i64.const	$3=, 8
	i32.const	$11=, headline+10
	i32.add 	$push24=, $11, $9
	i32.const	$push13=, 7
	i32.add 	$push14=, $1, $pop13
	i64.load8_u	$push15=, 0($pop14)
	i64.shl 	$push16=, $pop15, $3
	i32.add 	$push17=, $1, $9
	i64.load8_u	$push18=, 0($pop17)
	i64.or  	$push19=, $pop16, $pop18
	i64.store16	$discard=, 0($pop24), $pop19
	i32.const	$push20=, 1
	i32.add 	$push21=, $1, $pop20
	i64.load8_u	$10=, 0($pop21)
	i32.add 	$push25=, $11, $7
	i64.shl 	$push10=, $6, $3
	i64.or  	$push12=, $pop10, $8
	i64.store16	$discard=, 0($pop25), $pop12
	i32.const	$1=, 0
	i64.load8_u	$6=, p+9($1)
	block   	BB1_2
	i32.add 	$push26=, $11, $4
	i64.shl 	$push5=, $2, $3
	i64.or  	$push7=, $pop5, $5
	i64.store16	$discard=, 0($pop26), $pop7
	i32.const	$push29=, headline+18
	i32.const	$push28=, 238
	call    	memset, $pop29, $0, $pop28
	i64.shl 	$push22=, $10, $3
	i64.or  	$push23=, $pop22, $6
	i64.store16	$push27=, headline+10($1), $pop23
	i32.wrap/i64	$push30=, $pop27
	i32.const	$push31=, 255
	i32.and 	$push32=, $pop30, $pop31
	i32.const	$push33=, 83
	i32.ne  	$push34=, $pop32, $pop33
	br_if   	$pop34, BB1_2
# BB#1:                                 # %if.end
	return  	$1
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	p,@object               # @p
	.bss
	.globl	p
p:
	.zero	17
	.size	p, 17

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"FOOBARFOO"
	.size	.str, 10

	.type	headline,@object        # @headline
	.bss
	.globl	headline
	.align	4
headline:
	.zero	256
	.size	headline, 256


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
