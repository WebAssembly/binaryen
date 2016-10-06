	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/941014-2.c"
	.section	.text.a1,"ax",@progbits
	.hidden	a1
	.globl	a1
	.type	a1,@function
a1:                                     # @a1
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	a1, .Lfunc_end0-a1

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push17=, $pop8, $pop9
	tee_local	$push16=, $1=, $pop17
	i32.store	__stack_pointer($pop10), $pop16
	block   	
	i32.const	$push0=, 4
	i32.call	$push15=, malloc@FUNCTION, $pop0
	tee_local	$push14=, $0=, $pop15
	i32.load16_u	$push1=, 0($pop14)
	i32.const	$push2=, 4096
	i32.lt_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.then
	i32.load16_u	$push4=, 0($0)
	i32.store	0($1), $pop4
	i32.const	$push5=, .L.str
	i32.call	$drop=, printf@FUNCTION, $pop5, $1
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push6=, 256
	i32.store16	2($0), $pop6
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $1, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	copy_local	$push18=, $0
                                        # fallthrough-return: $pop18
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 16
	i32.sub 	$push17=, $pop11, $pop12
	tee_local	$push16=, $1=, $pop17
	i32.store	__stack_pointer($pop13), $pop16
	block   	
	i32.const	$push0=, 4
	i32.call	$push15=, malloc@FUNCTION, $pop0
	tee_local	$push14=, $0=, $pop15
	i32.load16_u	$push1=, 0($pop14)
	i32.const	$push2=, 4096
	i32.lt_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %if.then.i
	i32.load16_u	$push4=, 0($0)
	i32.store	0($1), $pop4
	i32.const	$push5=, .L.str
	i32.call	$drop=, printf@FUNCTION, $pop5, $1
.LBB2_2:                                # %f.exit
	end_block                       # label1:
	i32.const	$push6=, 256
	i32.store16	2($0), $pop6
	block   	
	i32.load16_u	$push7=, 2($0)
	i32.const	$push18=, 256
	i32.ne  	$push8=, $pop7, $pop18
	br_if   	0, $pop8        # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
.LBB2_4:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d\n"
	.size	.L.str, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	malloc, i32, i32
	.functype	printf, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
