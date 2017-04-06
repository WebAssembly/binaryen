	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920501-8.c"
	.section	.text.va,"ax",@progbits
	.hidden	va
	.globl	va
	.type	va,@function
va:                                     # @va
	.param  	i32, f64, i32, i32
	.result 	i32
	.local  	i64, i64, i64, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push25=, 0
	i32.const	$push23=, 0
	i32.load	$push22=, __stack_pointer($pop23)
	i32.const	$push24=, 80
	i32.sub 	$push31=, $pop22, $pop24
	tee_local	$push30=, $10=, $pop31
	i32.store	__stack_pointer($pop25), $pop30
	i32.store	76($10), $3
	i64.load	$4=, 0($3):p2align=2
	i64.load	$5=, 8($3):p2align=2
	i64.load	$6=, 16($3):p2align=2
	i64.load	$7=, 24($3):p2align=2
	i64.load	$8=, 32($3):p2align=2
	i64.load	$9=, 40($3):p2align=2
	i32.const	$push1=, 68
	i32.add 	$push2=, $10, $pop1
	i32.load	$push0=, 48($3)
	i32.store	0($pop2), $pop0
	i32.const	$push3=, 60
	i32.add 	$push4=, $10, $pop3
	i64.store	0($pop4):p2align=2, $9
	i32.const	$push5=, 52
	i32.add 	$push6=, $10, $pop5
	i64.store	0($pop6):p2align=2, $8
	i32.const	$push7=, 44
	i32.add 	$push8=, $10, $pop7
	i64.store	0($pop8):p2align=2, $7
	i32.const	$push9=, 36
	i32.add 	$push10=, $10, $pop9
	i64.store	0($pop10):p2align=2, $6
	i32.const	$push11=, 28
	i32.add 	$push12=, $10, $pop11
	i64.store	0($pop12):p2align=2, $5
	i32.const	$push13=, 20
	i32.add 	$push14=, $10, $pop13
	i64.store	0($pop14):p2align=2, $4
	i32.const	$push15=, 16
	i32.add 	$push16=, $10, $pop15
	i32.store	0($pop16), $2
	i32.const	$push17=, 4
	i32.add 	$push18=, $3, $pop17
	i32.store	76($10), $pop18
	i32.const	$push29=, 52
	i32.add 	$push19=, $3, $pop29
	i32.store	76($10), $pop19
	f64.store	8($10), $1
	i32.store	0($10), $0
	i32.const	$push21=, buf
	i32.const	$push20=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $pop21, $pop20, $10
	i32.const	$push28=, 0
	i32.const	$push26=, 80
	i32.add 	$push27=, $10, $pop26
	i32.store	__stack_pointer($pop28), $pop27
	copy_local	$push32=, $10
                                        # fallthrough-return: $pop32
	.endfunc
.Lfunc_end0:
	.size	va, .Lfunc_end0-va

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push27=, 0
	i32.const	$push25=, 0
	i32.load	$push24=, __stack_pointer($pop25)
	i32.const	$push26=, 64
	i32.sub 	$push29=, $pop24, $pop26
	tee_local	$push28=, $0=, $pop29
	i32.store	__stack_pointer($pop27), $pop28
	i32.const	$push0=, 48
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 15
	i32.store	0($pop1), $pop2
	i32.const	$push3=, 40
	i32.add 	$push4=, $0, $pop3
	i64.const	$push5=, 60129542157
	i64.store	0($pop4), $pop5
	i32.const	$push6=, 32
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 51539607563
	i64.store	0($pop7), $pop8
	i32.const	$push9=, 24
	i32.add 	$push10=, $0, $pop9
	i64.const	$push11=, 42949672969
	i64.store	0($pop10), $pop11
	i32.const	$push12=, 16
	i32.add 	$push13=, $0, $pop12
	i64.const	$push14=, 34359738375
	i64.store	0($pop13), $pop14
	i64.const	$push15=, 25769803781
	i64.store	8($0), $pop15
	i64.const	$push16=, 17179869187
	i64.store	0($0), $pop16
	i32.const	$push19=, 1
	f64.const	$push18=, 0x1p0
	i32.const	$push17=, 2
	i32.call	$drop=, va@FUNCTION, $pop19, $pop18, $pop17, $0
	block   	
	i32.const	$push21=, .L.str.1
	i32.const	$push20=, buf
	i32.call	$push22=, strcmp@FUNCTION, $pop21, $pop20
	br_if   	0, $pop22       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push23=, 0
	call    	exit@FUNCTION, $pop23
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.p2align	4
buf:
	.skip	50
	.size	buf, 50

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d,%f,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d"
	.size	.L.str, 48

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"1,1.000000,2,3,4,5,6,7,8,9,10,11,12,13,14,15"
	.size	.L.str.1, 45


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	sprintf, i32, i32, i32
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
