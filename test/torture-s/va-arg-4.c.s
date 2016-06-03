	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-4.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push25=, 0
	i32.const	$push22=, 0
	i32.load	$push23=, __stack_pointer($pop22)
	i32.const	$push24=, 16
	i32.sub 	$push29=, $pop23, $pop24
	i32.store	$4=, __stack_pointer($pop25), $pop29
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
	i32.store	$push31=, 12($4), $2
	tee_local	$push30=, $0=, $pop31
	i32.const	$push9=, 4
	i32.add 	$push10=, $pop30, $pop9
	i32.store	$2=, 12($4), $pop10
	i32.load	$push11=, 0($0)
	i32.const	$push12=, 42
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label0
# BB#4:                                 # %if.end17
	i32.const	$push14=, 8
	i32.add 	$push15=, $0, $pop14
	i32.store	$3=, 12($4), $pop15
	i32.load	$push16=, 0($2)
	i32.const	$push17=, 120
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label0
# BB#5:                                 # %if.end23
	i32.const	$push19=, 12
	i32.add 	$push20=, $0, $pop19
	i32.store	$drop=, 12($4), $pop20
	i32.load	$push21=, 0($3)
	br_if   	0, $pop21       # 0: down to label0
# BB#6:                                 # %if.end29
	i32.const	$push28=, 0
	i32.const	$push26=, 16
	i32.add 	$push27=, $4, $pop26
	i32.store	$drop=, __stack_pointer($pop28), $pop27
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.const	$push12=, 0
	i32.load	$push13=, __stack_pointer($pop12)
	i32.const	$push14=, 48
	i32.sub 	$push18=, $pop13, $pop14
	i32.store	$push24=, __stack_pointer($pop15), $pop18
	tee_local	$push23=, $1=, $pop24
	i32.const	$push2=, 40
	i32.add 	$push3=, $pop23, $pop2
	i32.const	$push0=, 0
	i64.load	$push1=, main.x+24($pop0):p2align=0
	i64.store	$drop=, 0($pop3):p2align=2, $pop1
	i32.const	$push5=, 32
	i32.add 	$push6=, $1, $pop5
	i32.const	$push22=, 0
	i64.load	$push4=, main.x+16($pop22):p2align=0
	i64.store	$drop=, 0($pop6):p2align=2, $pop4
	i32.const	$push8=, 24
	i32.add 	$push9=, $1, $pop8
	i32.const	$push21=, 0
	i64.load	$push7=, main.x+8($pop21):p2align=0
	i64.store	$drop=, 0($pop9):p2align=2, $pop7
	i32.const	$push20=, 0
	i64.load	$push10=, main.x($pop20):p2align=0
	i64.store	$drop=, 16($1):p2align=2, $pop10
	i64.const	$push11=, 515396075562
	i64.store	$drop=, 0($1), $pop11
	i32.const	$push19=, 0
	i32.store	$0=, 8($1), $pop19
	i32.const	$push16=, 16
	i32.add 	$push17=, $1, $pop16
	call    	f@FUNCTION, $pop17, $1, $1
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	main.x,@object          # @main.x
	.section	.data.main.x,"aw",@progbits
main.x:
	.asciz	"abc\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.size	main.x, 32


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
