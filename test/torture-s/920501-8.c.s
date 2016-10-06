	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920501-8.c"
	.section	.text.va,"ax",@progbits
	.hidden	va
	.globl	va
	.type	va,@function
va:                                     # @va
	.param  	i32, f64, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push37=, 0
	i32.const	$push34=, 0
	i32.load	$push35=, __stack_pointer($pop34)
	i32.const	$push36=, 80
	i32.sub 	$push43=, $pop35, $pop36
	tee_local	$push42=, $16=, $pop43
	i32.store	__stack_pointer($pop37), $pop42
	i32.store	76($16), $3
	i32.const	$push0=, 4
	i32.add 	$push1=, $3, $pop0
	i32.store	76($16), $pop1
	i32.load	$4=, 0($3)
	i32.load	$5=, 4($3)
	i32.load	$6=, 8($3)
	i32.load	$7=, 12($3)
	i32.load	$8=, 16($3)
	i32.load	$9=, 20($3)
	i32.load	$10=, 24($3)
	i32.load	$11=, 28($3)
	i32.load	$12=, 32($3)
	i32.load	$13=, 36($3)
	i32.load	$14=, 40($3)
	i32.load	$15=, 44($3)
	i32.const	$push2=, 52
	i32.add 	$push3=, $3, $pop2
	i32.store	76($16), $pop3
	i32.const	$push4=, 68
	i32.add 	$push5=, $16, $pop4
	i32.load	$push6=, 48($3)
	i32.store	0($pop5), $pop6
	i32.const	$push7=, 64
	i32.add 	$push8=, $16, $pop7
	i32.store	0($pop8), $15
	i32.const	$push9=, 60
	i32.add 	$push10=, $16, $pop9
	i32.store	0($pop10), $14
	i32.const	$push11=, 56
	i32.add 	$push12=, $16, $pop11
	i32.store	0($pop12), $13
	i32.const	$push41=, 52
	i32.add 	$push13=, $16, $pop41
	i32.store	0($pop13), $12
	i32.const	$push14=, 48
	i32.add 	$push15=, $16, $pop14
	i32.store	0($pop15), $11
	i32.const	$push16=, 44
	i32.add 	$push17=, $16, $pop16
	i32.store	0($pop17), $10
	i32.const	$push18=, 40
	i32.add 	$push19=, $16, $pop18
	i32.store	0($pop19), $9
	i32.const	$push20=, 36
	i32.add 	$push21=, $16, $pop20
	i32.store	0($pop21), $8
	i32.const	$push22=, 32
	i32.add 	$push23=, $16, $pop22
	i32.store	0($pop23), $7
	i32.const	$push24=, 28
	i32.add 	$push25=, $16, $pop24
	i32.store	0($pop25), $6
	i32.const	$push26=, 24
	i32.add 	$push27=, $16, $pop26
	i32.store	0($pop27), $5
	i32.const	$push28=, 20
	i32.add 	$push29=, $16, $pop28
	i32.store	0($pop29), $4
	i32.const	$push30=, 16
	i32.add 	$push31=, $16, $pop30
	i32.store	0($pop31), $2
	f64.store	8($16), $1
	i32.store	0($16), $0
	i32.const	$push33=, buf
	i32.const	$push32=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $pop33, $pop32, $16
	i32.const	$push40=, 0
	i32.const	$push38=, 80
	i32.add 	$push39=, $16, $pop38
	i32.store	__stack_pointer($pop40), $pop39
	copy_local	$push44=, $16
                                        # fallthrough-return: $pop44
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
	i32.const	$push24=, 0
	i32.load	$push25=, __stack_pointer($pop24)
	i32.const	$push26=, 64
	i32.sub 	$push29=, $pop25, $pop26
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	sprintf, i32, i32, i32
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
