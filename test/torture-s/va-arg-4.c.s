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
	i32.const	$push24=, __stack_pointer
	i32.load	$push25=, 0($pop24)
	i32.const	$push26=, 16
	i32.sub 	$4=, $pop25, $pop26
	i32.const	$push27=, __stack_pointer
	i32.store	$discard=, 0($pop27), $4
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
	i32.store	$push23=, 12($4), $2
	tee_local	$push22=, $0=, $pop23
	i32.const	$push9=, 4
	i32.add 	$push10=, $pop22, $pop9
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
	i32.store	$discard=, 12($4), $pop20
	i32.load	$push21=, 0($3)
	br_if   	0, $pop21       # 0: down to label0
# BB#6:                                 # %if.end29
	i32.const	$push28=, 16
	i32.add 	$4=, $4, $pop28
	i32.const	$push29=, __stack_pointer
	i32.store	$discard=, 0($pop29), $4
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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 48
	i32.sub 	$5=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $5
	i32.const	$push2=, 24
	i32.const	$1=, 16
	i32.add 	$1=, $5, $1
	i32.add 	$push3=, $1, $pop2
	i32.const	$push0=, 0
	i64.load	$push1=, main.x+24($pop0):p2align=0
	i64.store	$discard=, 0($pop3):p2align=2, $pop1
	i32.const	$push5=, 16
	i32.const	$2=, 16
	i32.add 	$2=, $5, $2
	i32.add 	$push6=, $2, $pop5
	i32.const	$push15=, 0
	i64.load	$push4=, main.x+16($pop15):p2align=0
	i64.store	$discard=, 0($pop6):p2align=2, $pop4
	i32.const	$push8=, 8
	i32.const	$3=, 16
	i32.add 	$3=, $5, $3
	i32.add 	$push9=, $3, $pop8
	i32.const	$push14=, 0
	i64.load	$push7=, main.x+8($pop14):p2align=0
	i64.store	$discard=, 0($pop9):p2align=2, $pop7
	i32.const	$push13=, 0
	i64.load	$push10=, main.x($pop13):p2align=0
	i64.store	$discard=, 16($5):p2align=2, $pop10
	i32.const	$push12=, 0
	i32.store	$0=, 8($5):p2align=3, $pop12
	i64.const	$push11=, 515396075562
	i64.store	$discard=, 0($5):p2align=4, $pop11
	i32.const	$4=, 16
	i32.add 	$4=, $5, $4
	call    	f@FUNCTION, $4, $0, $5
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
