	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-4.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push23=, 0
	i32.const	$push20=, 0
	i32.load	$push21=, __stack_pointer($pop20)
	i32.const	$push22=, 16
	i32.sub 	$push28=, $pop21, $pop22
	tee_local	$push27=, $4=, $pop28
	i32.store	__stack_pointer($pop23), $pop27
	block   	
	i32.load8_u	$push0=, 0($0)
	i32.const	$push1=, 97
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load8_u	$push3=, 1($0)
	i32.const	$push4=, 98
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %lor.lhs.false7
	i32.load8_u	$push6=, 2($0)
	i32.const	$push7=, 99
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end
	i32.store	12($4), $2
	i32.const	$push9=, 4
	i32.add 	$push30=, $2, $pop9
	tee_local	$push29=, $0=, $pop30
	i32.store	12($4), $pop29
	i32.load	$push10=, 0($2)
	i32.const	$push11=, 42
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#4:                                 # %if.end17
	i32.const	$push13=, 8
	i32.add 	$push32=, $2, $pop13
	tee_local	$push31=, $3=, $pop32
	i32.store	12($4), $pop31
	i32.load	$push14=, 0($0)
	i32.const	$push15=, 120
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#5:                                 # %if.end23
	i32.const	$push17=, 12
	i32.add 	$push18=, $2, $pop17
	i32.store	12($4), $pop18
	i32.load	$push19=, 0($3)
	br_if   	0, $pop19       # 0: down to label0
# BB#6:                                 # %if.end29
	i32.const	$push26=, 0
	i32.const	$push24=, 16
	i32.add 	$push25=, $4, $pop24
	i32.store	__stack_pointer($pop26), $pop25
	return
.LBB0_7:                                # %if.then28
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.const	$push12=, 0
	i32.load	$push13=, __stack_pointer($pop12)
	i32.const	$push14=, 48
	i32.sub 	$push24=, $pop13, $pop14
	tee_local	$push23=, $0=, $pop24
	i32.store	__stack_pointer($pop15), $pop23
	i32.const	$push2=, 40
	i32.add 	$push3=, $0, $pop2
	i32.const	$push0=, 0
	i64.load	$push1=, main.x+24($pop0):p2align=0
	i64.store	0($pop3):p2align=2, $pop1
	i32.const	$push5=, 32
	i32.add 	$push6=, $0, $pop5
	i32.const	$push22=, 0
	i64.load	$push4=, main.x+16($pop22):p2align=0
	i64.store	0($pop6):p2align=2, $pop4
	i32.const	$push8=, 24
	i32.add 	$push9=, $0, $pop8
	i32.const	$push21=, 0
	i64.load	$push7=, main.x+8($pop21):p2align=0
	i64.store	0($pop9):p2align=2, $pop7
	i32.const	$push20=, 0
	i64.load	$push10=, main.x($pop20):p2align=0
	i64.store	16($0):p2align=2, $pop10
	i64.const	$push11=, 515396075562
	i64.store	0($0), $pop11
	i32.const	$push19=, 0
	i32.store	8($0), $pop19
	i32.const	$push16=, 16
	i32.add 	$push17=, $0, $pop16
	call    	f@FUNCTION, $pop17, $0, $0
	i32.const	$push18=, 0
	call    	exit@FUNCTION, $pop18
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	main.x,@object          # @main.x
	.section	.data.main.x,"aw",@progbits
main.x:
	.asciz	"abc\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.size	main.x, 32


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
