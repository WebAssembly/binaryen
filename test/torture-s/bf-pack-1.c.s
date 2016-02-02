	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/bf-pack-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	block
	i64.load	$push0=, 0($0):p2align=2
	tee_local	$push9=, $1=, $pop0
	i64.const	$push1=, 65535
	i64.and 	$push2=, $pop9, $pop1
	i64.const	$push3=, 4660
	i64.ne  	$push4=, $pop2, $pop3
	br_if   	$pop4, 0        # 0: down to label0
# BB#1:                                 # %if.end
	block
	i64.const	$push5=, 281474976645120
	i64.and 	$push6=, $1, $pop5
	i64.const	$push7=, 95075992076288
	i64.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, 0        # 0: down to label1
# BB#2:                                 # %if.end6
	return  	$0
.LBB0_3:                                # %if.then5
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.then
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i64.const	$push0=, 95075992080948
	i64.store	$discard=, 8($3), $pop0
	i32.const	$2=, 8
	i32.add 	$2=, $3, $2
	i32.call	$discard=, f@FUNCTION, $2
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
