	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-2f.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 39
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.add 	$push2=, $1, $0
	i32.const	$push5=, 254
	i32.const	$push3=, 40
	i32.sub 	$push4=, $pop3, $0
	i32.call	$discard=, memset@FUNCTION, $pop2, $pop5, $pop4
.LBB0_2:                                # %for.end
	end_block                       # label0:
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
	block
	i32.const	$push5=, 2147450880
	i32.const	$push4=, 65536
	i32.const	$push3=, 3
	i32.const	$push2=, 50
	i32.const	$push0=, .L.str
	i32.const	$push16=, 0
	i32.const	$push15=, 0
	i32.call	$push1=, open@FUNCTION, $pop0, $pop16, $pop15
	i32.const	$push14=, 0
	i32.call	$push13=, mmap@FUNCTION, $pop5, $pop4, $pop3, $pop2, $pop1, $pop14
	tee_local	$push12=, $0=, $pop13
	i32.const	$push6=, -1
	i32.eq  	$push7=, $pop12, $pop6
	br_if   	0, $pop7        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push8=, 32766
	i32.add 	$push9=, $0, $pop8
	i32.const	$push11=, 254
	i32.const	$push10=, 39
	i32.call	$discard=, memset@FUNCTION, $pop9, $pop11, $pop10
	i32.const	$push17=, 0
	i32.store8	$discard=, 32805($0), $pop17
.LBB1_2:                                # %if.end15
	end_block                       # label1:
	i32.const	$push18=, 0
	call    	exit@FUNCTION, $pop18
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"/dev/zero"
	.size	.L.str, 10


	.ident	"clang version 3.9.0 "
