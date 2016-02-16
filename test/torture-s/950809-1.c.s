	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/950809-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$push5=, 8($0)
	tee_local	$push4=, $6=, $pop5
	i32.load	$2=, 8($pop4)
	i32.const	$push1=, 16
	i32.add 	$push3=, $0, $pop1
	tee_local	$push2=, $5=, $pop3
	i32.load	$4=, 0($pop2)
	i32.load	$3=, 12($0)
	i32.load	$push0=, 0($6)
	i32.store	$discard=, 8($6), $pop0
	i32.load	$1=, 4($6)
	i32.store	$discard=, 0($6), $4
	i32.store	$discard=, 0($5), $3
	i32.store	$discard=, 12($0), $2
	i32.store	$discard=, 4($0), $1
	i32.store	$discard=, 0($0), $6
	return  	$0
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
	i32.const	$push6=, 0
	i32.load	$0=, main.sc($pop6)
	i32.const	$push5=, 0
	i32.const	$push1=, 11
	i32.store	$discard=, main.sc($pop5), $pop1
	block
	i32.const	$push4=, 0
	i32.store	$push0=, main.sc+8($pop4), $0
	i32.const	$push2=, 2
	i32.ne  	$push3=, $pop0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	main.sc,@object         # @main.sc
	.section	.data.main.sc,"aw",@progbits
	.p2align	2
main.sc:
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.size	main.sc, 12


	.ident	"clang version 3.9.0 "
