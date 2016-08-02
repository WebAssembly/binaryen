	.text
	.file	"cfi-wasm.bs.bc"
	.type	a,@function
a:                                      # @a
	.indidx  	4
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	a, .Lfunc_end0-a

	.type	b,@function
b:                                      # @b
	.indidx  	2
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	b, .Lfunc_end1-b

	.type	c,@function
c:                                      # @c
	.indidx  	1
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	c, .Lfunc_end2-c

	.type	d,@function
d:                                      # @d
	.indidx  	3
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 3
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	d, .Lfunc_end3-d

	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.call	$push1=, getchar@FUNCTION
	i32.const	$push0=, 2
	i32.shl 	$push2=, $pop1, $pop0
	i32.const	$push3=, .Lmain.fp-192
	i32.add 	$push4=, $pop2, $pop3
	i32.load	$push9=, 0($pop4)
	tee_local	$push8=, $2=, $pop9
	i32.const	$push5=, 4
	i32.ge_u	$push6=, $pop8, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %cont
	i32.call_indirect	$push7=, $2
	return  	$pop7
.LBB4_2:                                # %trap
	end_block                       # label0:
	unreachable
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.type	.Lmain.fp,@object       # @main.fp
	.section	.data.rel.ro,"aw",@progbits
	.p2align	4
.Lmain.fp:
	.int32	a@FUNCTION
	.int32	b@FUNCTION
	.int32	c@FUNCTION
	.int32	d@FUNCTION
	.size	.Lmain.fp, 16

	.type	.L__unnamed_1,@object   # @0
	.section	.rodata,"a",@progbits
.L__unnamed_1:
	.size	.L__unnamed_1, 0


	.ident	"clang version 3.9.0 (trunk 271314) (llvm/trunk 271322)"
