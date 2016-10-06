	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021219-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.load	$push14=, __stack_pointer($pop13)
	i32.const	$push15=, 16
	i32.sub 	$push19=, $pop14, $pop15
	tee_local	$push18=, $0=, $pop19
	i32.const	$push3=, 14
	i32.add 	$push4=, $pop18, $pop3
	i32.const	$push1=, 0
	i32.load8_u	$push2=, .Lmain.str+10($pop1)
	i32.store8	0($pop4), $pop2
	i32.const	$push6=, 12
	i32.add 	$push7=, $0, $pop6
	i32.const	$push17=, 0
	i32.load16_u	$push5=, .Lmain.str+8($pop17):p2align=0
	i32.store16	0($pop7), $pop5
	i32.const	$push16=, 0
	i64.load	$push8=, .Lmain.str($pop16):p2align=0
	i64.store	4($0):p2align=2, $pop8
	i32.const	$push9=, 10
	i32.add 	$0=, $0, $pop9
	i32.const	$1=, 32
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	block   	
	i32.const	$push24=, 255
	i32.and 	$push23=, $1, $pop24
	tee_local	$push22=, $1=, $pop23
	i32.const	$push21=, 32
	i32.eq  	$push10=, $pop22, $pop21
	br_if   	0, $pop10       # 0: down to label2
# BB#2:                                 # %while.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push25=, 13
	i32.ne  	$push11=, $1, $pop25
	br_if   	2, $pop11       # 2: down to label0
.LBB1_3:                                # %while.body
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.load8_u	$1=, 0($0)
	i32.const	$push20=, 1
	i32.add 	$push0=, $0, $pop20
	copy_local	$0=, $pop0
	br      	0               # 0: up to label1
.LBB1_4:                                # %while.end
	end_loop
	end_block                       # label0:
	i32.const	$push12=, 0
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.str,@object      # @main.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lmain.str:
	.asciz	"foo { xx }"
	.size	.Lmain.str, 11


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
