	.text
	.file	"920501-8.c"
	.section	.text.va,"ax",@progbits
	.hidden	va                      # -- Begin function va
	.globl	va
	.type	va,@function
va:                                     # @va
	.param  	i32, f64, i32, i32
	.result 	i32
	.local  	i32, i64, i64, i64, i64, i64, i32
# %bb.0:                                # %entry
	i32.const	$push21=, 0
	i32.load	$push20=, __stack_pointer($pop21)
	i32.const	$push22=, 80
	i32.sub 	$10=, $pop20, $pop22
	i32.const	$push23=, 0
	i32.store	__stack_pointer($pop23), $10
	i32.store	76($10), $3
	i32.load	$4=, 48($3)
	i64.load	$5=, 8($3):p2align=2
	i64.load	$6=, 16($3):p2align=2
	i64.load	$7=, 24($3):p2align=2
	i64.load	$8=, 32($3):p2align=2
	i64.load	$9=, 40($3):p2align=2
	i32.const	$push1=, 20
	i32.add 	$push2=, $10, $pop1
	i64.load	$push0=, 0($3):p2align=2
	i64.store	0($pop2):p2align=2, $pop0
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
	i32.const	$push13=, 16
	i32.add 	$push14=, $10, $pop13
	i32.store	0($pop14), $2
	i32.const	$push15=, 68
	i32.add 	$push16=, $10, $pop15
	i32.store	0($pop16), $4
	f64.store	8($10), $1
	i32.store	0($10), $0
	i32.const	$push27=, 52
	i32.add 	$push17=, $3, $pop27
	i32.store	76($10), $pop17
	i32.const	$push19=, buf
	i32.const	$push18=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $pop19, $pop18, $10
	i32.const	$push26=, 0
	i32.const	$push24=, 80
	i32.add 	$push25=, $10, $pop24
	i32.store	__stack_pointer($pop26), $pop25
	copy_local	$push28=, $10
                                        # fallthrough-return: $pop28
	.endfunc
.Lfunc_end0:
	.size	va, .Lfunc_end0-va
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push25=, 0
	i32.load	$push24=, __stack_pointer($pop25)
	i32.const	$push26=, 64
	i32.sub 	$0=, $pop24, $pop26
	i32.const	$push27=, 0
	i32.store	__stack_pointer($pop27), $0
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
# %bb.1:                                # %if.end
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
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	sprintf, i32, i32, i32
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
