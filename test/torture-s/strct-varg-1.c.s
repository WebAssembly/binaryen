	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strct-varg-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push27=, __stack_pointer
	i32.load	$push28=, 0($pop27)
	i32.const	$push29=, 16
	i32.sub 	$2=, $pop28, $pop29
	i32.const	$push30=, __stack_pointer
	i32.store	$discard=, 0($pop30), $2
	i32.store	$discard=, 12($2), $1
	block
	i32.const	$push0=, 2
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load	$push26=, 12($2)
	tee_local	$push25=, $1=, $pop26
	i32.const	$push2=, 8
	i32.add 	$push3=, $pop25, $pop2
	i32.store	$discard=, 12($2), $pop3
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 43690
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#2:                                 # %lor.lhs.false
	i32.load	$push7=, 4($1)
	i32.const	$push8=, 21845
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#3:                                 # %if.end5
	i32.const	$push10=, 12
	i32.add 	$push11=, $1, $pop10
	i32.store	$0=, 12($2), $pop11
	i32.const	$push12=, 8
	i32.add 	$push13=, $1, $pop12
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 3
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#4:                                 # %if.end10
	i32.const	$push17=, 20
	i32.add 	$push18=, $1, $pop17
	i32.store	$discard=, 12($2), $pop18
	i32.load	$push19=, 0($0)
	i32.const	$push20=, 65535
	i32.ne  	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label0
# BB#5:                                 # %lor.lhs.false15
	i32.load	$push22=, 16($1)
	i32.const	$push23=, 4369
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label0
# BB#6:                                 # %if.end19
	i32.const	$push33=, __stack_pointer
	i32.const	$push31=, 16
	i32.add 	$push32=, $2, $pop31
	i32.store	$discard=, 0($pop33), $pop32
	return  	$1
.LBB0_7:                                # %if.then18
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
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 48
	i32.sub 	$0=, $pop8, $pop9
	i32.const	$push10=, __stack_pointer
	i32.store	$discard=, 0($pop10), $0
	i64.const	$push0=, 93823560624810
	i64.store	$discard=, 40($0), $pop0
	i64.const	$push1=, 18764712181759
	i64.store	$discard=, 32($0), $pop1
	i64.load	$push2=, 40($0)
	i64.store	$discard=, 24($0):p2align=2, $pop2
	i64.load	$push3=, 32($0)
	i64.store	$discard=, 16($0):p2align=2, $pop3
	i32.const	$push4=, 3
	i32.store	$discard=, 4($0), $pop4
	i32.const	$push11=, 16
	i32.add 	$push12=, $0, $pop11
	i32.store	$discard=, 8($0):p2align=3, $pop12
	i32.const	$push13=, 24
	i32.add 	$push14=, $0, $pop13
	i32.store	$discard=, 0($0):p2align=4, $pop14
	i32.const	$push5=, 2
	i32.call	$discard=, f@FUNCTION, $pop5, $0
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
