	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920501-8.c"
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
	i32.sub 	$push41=, $pop35, $pop36
	i32.store	$push46=, __stack_pointer($pop37), $pop41
	tee_local	$push45=, $4=, $pop46
	i32.store	$push44=, 76($4), $3
	tee_local	$push43=, $3=, $pop44
	i32.const	$push0=, 4
	i32.add 	$push1=, $pop43, $pop0
	i32.store	$drop=, 76($pop45), $pop1
	i32.load	$5=, 0($3)
	i32.load	$6=, 4($3)
	i32.load	$7=, 8($3)
	i32.load	$8=, 12($3)
	i32.load	$9=, 16($3)
	i32.load	$10=, 20($3)
	i32.load	$11=, 24($3)
	i32.load	$12=, 28($3)
	i32.load	$13=, 32($3)
	i32.load	$14=, 36($3)
	i32.load	$15=, 40($3)
	i32.load	$16=, 44($3)
	i32.const	$push2=, 52
	i32.add 	$push3=, $3, $pop2
	i32.store	$drop=, 76($4), $pop3
	i32.const	$push4=, 68
	i32.add 	$push5=, $4, $pop4
	i32.load	$push6=, 48($3)
	i32.store	$drop=, 0($pop5), $pop6
	i32.const	$push7=, 64
	i32.add 	$push8=, $4, $pop7
	i32.store	$drop=, 0($pop8), $16
	i32.const	$push9=, 60
	i32.add 	$push10=, $4, $pop9
	i32.store	$drop=, 0($pop10), $15
	i32.const	$push11=, 56
	i32.add 	$push12=, $4, $pop11
	i32.store	$drop=, 0($pop12), $14
	i32.const	$push42=, 52
	i32.add 	$push13=, $4, $pop42
	i32.store	$drop=, 0($pop13), $13
	i32.const	$push14=, 48
	i32.add 	$push15=, $4, $pop14
	i32.store	$drop=, 0($pop15), $12
	i32.const	$push16=, 44
	i32.add 	$push17=, $4, $pop16
	i32.store	$drop=, 0($pop17), $11
	i32.const	$push18=, 40
	i32.add 	$push19=, $4, $pop18
	i32.store	$drop=, 0($pop19), $10
	i32.const	$push20=, 36
	i32.add 	$push21=, $4, $pop20
	i32.store	$drop=, 0($pop21), $9
	i32.const	$push22=, 32
	i32.add 	$push23=, $4, $pop22
	i32.store	$drop=, 0($pop23), $8
	i32.const	$push24=, 28
	i32.add 	$push25=, $4, $pop24
	i32.store	$drop=, 0($pop25), $7
	i32.const	$push26=, 24
	i32.add 	$push27=, $4, $pop26
	i32.store	$drop=, 0($pop27), $6
	i32.const	$push28=, 20
	i32.add 	$push29=, $4, $pop28
	i32.store	$drop=, 0($pop29), $5
	i32.const	$push30=, 16
	i32.add 	$push31=, $4, $pop30
	i32.store	$drop=, 0($pop31), $2
	f64.store	$drop=, 8($4), $1
	i32.store	$drop=, 0($4), $0
	i32.const	$push33=, buf
	i32.const	$push32=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $pop33, $pop32, $4
	i32.const	$push40=, 0
	i32.const	$push38=, 80
	i32.add 	$push39=, $4, $pop38
	i32.store	$drop=, __stack_pointer($pop40), $pop39
	copy_local	$push47=, $4
                                        # fallthrough-return: $pop47
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
	i32.sub 	$push28=, $pop25, $pop26
	i32.store	$push30=, __stack_pointer($pop27), $pop28
	tee_local	$push29=, $0=, $pop30
	i32.const	$push0=, 48
	i32.add 	$push1=, $pop29, $pop0
	i32.const	$push2=, 15
	i32.store	$drop=, 0($pop1), $pop2
	i32.const	$push3=, 40
	i32.add 	$push4=, $0, $pop3
	i64.const	$push5=, 60129542157
	i64.store	$drop=, 0($pop4), $pop5
	i32.const	$push6=, 32
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 51539607563
	i64.store	$drop=, 0($pop7), $pop8
	i32.const	$push9=, 24
	i32.add 	$push10=, $0, $pop9
	i64.const	$push11=, 42949672969
	i64.store	$drop=, 0($pop10), $pop11
	i32.const	$push12=, 16
	i32.add 	$push13=, $0, $pop12
	i64.const	$push14=, 34359738375
	i64.store	$drop=, 0($pop13), $pop14
	i64.const	$push15=, 25769803781
	i64.store	$drop=, 8($0), $pop15
	i64.const	$push16=, 17179869187
	i64.store	$drop=, 0($0), $pop16
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


	.ident	"clang version 3.9.0 "
	.functype	sprintf, i32, i32, i32
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
