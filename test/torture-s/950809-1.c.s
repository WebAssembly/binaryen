	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/950809-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 16
	i32.add 	$push5=, $0, $pop0
	tee_local	$push4=, $1=, $pop5
	i32.load	$2=, 0($pop4)
	i32.load	$3=, 12($0)
	i32.load	$push3=, 8($0)
	tee_local	$push2=, $4=, $pop3
	i32.load	$5=, 8($pop2)
	i32.load	$push1=, 0($4)
	i32.store	$drop=, 8($4), $pop1
	i32.store	$drop=, 0($4), $2
	i32.load	$2=, 4($4)
	i32.store	$drop=, 12($0), $5
	i32.store	$drop=, 0($1), $3
	i32.store	$drop=, 4($0), $2
	i32.store	$drop=, 0($0), $4
	copy_local	$push6=, $0
                                        # fallthrough-return: $pop6
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
	i32.const	$push5=, 0
	i32.load	$push0=, main.sc($pop5)
	i32.store	$0=, main.sc+8($pop6), $pop0
	i32.const	$push4=, 0
	i32.const	$push1=, 11
	i32.store	$drop=, main.sc($pop4), $pop1
	block
	i32.const	$push2=, 2
	i32.ne  	$push3=, $0, $pop2
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
