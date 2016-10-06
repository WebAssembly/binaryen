	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-2f.c"
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
	i32.add 	$push4=, $1, $0
	i32.const	$push5=, 254
	i32.const	$push2=, 40
	i32.sub 	$push3=, $pop2, $0
	i32.call	$drop=, memset@FUNCTION, $pop4, $pop5, $pop3
.LBB0_2:                                # %for.end
	end_block                       # label0:
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
	block   	
	i32.const	$push6=, 2147450880
	i32.const	$push5=, 65536
	i32.const	$push4=, 3
	i32.const	$push3=, 50
	i32.const	$push0=, .L.str
	i32.const	$push16=, 0
	i32.const	$push15=, 0
	i32.call	$push1=, open@FUNCTION, $pop0, $pop16, $pop15
	i64.const	$push2=, 0
	i32.call	$push14=, mmap@FUNCTION, $pop6, $pop5, $pop4, $pop3, $pop1, $pop2
	tee_local	$push13=, $0=, $pop14
	i32.const	$push7=, -1
	i32.eq  	$push8=, $pop13, $pop7
	br_if   	0, $pop8        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push9=, 32766
	i32.add 	$push10=, $0, $pop9
	i32.const	$push12=, 254
	i32.const	$push11=, 39
	i32.call	$drop=, memset@FUNCTION, $pop10, $pop12, $pop11
	i32.const	$push17=, 0
	i32.store8	32805($0), $pop17
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	open, i32, i32, i32
	.functype	mmap, i32, i32, i32, i32, i32, i32, i64
	.functype	exit, void, i32
