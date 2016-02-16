	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-4.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	block
	block
	block
	block
	i32.load8_u	$push0=, 0($0)
	i32.const	$push1=, 97
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label3
# BB#1:                                 # %lor.lhs.false
	i32.load8_u	$push3=, 1($0)
	i32.const	$push4=, 98
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label3
# BB#2:                                 # %lor.lhs.false7
	i32.load8_u	$push6=, 2($0)
	i32.const	$push7=, 99
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label3
# BB#3:                                 # %if.end
	i32.store	$push9=, 12($6), $2
	i32.const	$push32=, 3
	i32.add 	$push10=, $pop9, $pop32
	i32.const	$push31=, -4
	i32.and 	$push30=, $pop10, $pop31
	tee_local	$push29=, $0=, $pop30
	i32.const	$push28=, 4
	i32.add 	$push11=, $pop29, $pop28
	i32.store	$discard=, 12($6), $pop11
	i32.load	$push12=, 0($0)
	i32.const	$push13=, 42
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	1, $pop14       # 1: down to label2
# BB#4:                                 # %if.end17
	i32.load	$push15=, 12($6)
	i32.const	$push37=, 3
	i32.add 	$push16=, $pop15, $pop37
	i32.const	$push36=, -4
	i32.and 	$push35=, $pop16, $pop36
	tee_local	$push34=, $0=, $pop35
	i32.const	$push33=, 4
	i32.add 	$push17=, $pop34, $pop33
	i32.store	$discard=, 12($6), $pop17
	i32.load	$push18=, 0($0)
	i32.const	$push19=, 120
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	2, $pop20       # 2: down to label1
# BB#5:                                 # %if.end21
	i32.load	$push21=, 12($6)
	i32.const	$push22=, 3
	i32.add 	$push23=, $pop21, $pop22
	i32.const	$push24=, -4
	i32.and 	$push39=, $pop23, $pop24
	tee_local	$push38=, $0=, $pop39
	i32.const	$push25=, 4
	i32.add 	$push26=, $pop38, $pop25
	i32.store	$discard=, 12($6), $pop26
	i32.load	$push27=, 0($0)
	br_if   	3, $pop27       # 3: down to label0
# BB#6:                                 # %if.end25
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return
.LBB0_7:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.then16
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_9:                                # %if.then20
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %if.then24
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 48
	i32.sub 	$7=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$7=, 0($2), $7
	i32.const	$push2=, 24
	i32.const	$3=, 16
	i32.add 	$3=, $7, $3
	i32.add 	$push3=, $3, $pop2
	i32.const	$push0=, 0
	i64.load	$push1=, main.x+24($pop0):p2align=0
	i64.store	$discard=, 0($pop3):p2align=2, $pop1
	i32.const	$push5=, 16
	i32.const	$4=, 16
	i32.add 	$4=, $7, $4
	i32.add 	$push6=, $4, $pop5
	i32.const	$push17=, 0
	i64.load	$push4=, main.x+16($pop17):p2align=0
	i64.store	$discard=, 0($pop6):p2align=2, $pop4
	i32.const	$push8=, 8
	i32.const	$5=, 16
	i32.add 	$5=, $7, $5
	i32.add 	$push9=, $5, $pop8
	i32.const	$push16=, 0
	i64.load	$push7=, main.x+8($pop16):p2align=0
	i64.store	$discard=, 0($pop9):p2align=2, $pop7
	i32.const	$push15=, 0
	i64.load	$push10=, main.x($pop15):p2align=0
	i64.store	$discard=, 16($7):p2align=2, $pop10
	i32.const	$push14=, 8
	i32.or  	$push11=, $7, $pop14
	i32.const	$push13=, 0
	i32.store	$0=, 0($pop11):p2align=3, $pop13
	i64.const	$push12=, 515396075562
	i64.store	$discard=, 0($7):p2align=4, $pop12
	i32.const	$6=, 16
	i32.add 	$6=, $7, $6
	call    	f@FUNCTION, $6, $0, $7
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
