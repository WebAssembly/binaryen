	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/floatunsisf-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load	$push0=, u($0)
	f32.convert_u/i32	$push1=, $pop0
	f32.store	$discard=, f1($0), $pop1
	i32.const	$push2=, 1325400065
	i32.store	$discard=, f2($0), $pop2
	f32.load	$push3=, f1($0)
	f32.load	$push4=, f2($0)
	f32.eq  	$push5=, $pop3, $pop4
	br_if   	$pop5, 0        # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	u                       # @u
	.type	u,@object
	.section	.data.u,"aw",@progbits
	.globl	u
	.align	2
u:
	.int32	2147483777              # 0x80000081
	.size	u, 4

	.hidden	f1                      # @f1
	.type	f1,@object
	.section	.bss.f1,"aw",@nobits
	.globl	f1
	.align	2
f1:
	.int32	0                       # float 0
	.size	f1, 4

	.hidden	f2                      # @f2
	.type	f2,@object
	.section	.bss.f2,"aw",@nobits
	.globl	f2
	.align	2
f2:
	.int32	0                       # float 0
	.size	f2, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
