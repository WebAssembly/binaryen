	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960327-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 10
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, 0
	i32.const	$push16=, 0
	i32.load	$push17=, __stack_pointer($pop16)
	i32.const	$push18=, 16
	i32.sub 	$push26=, $pop17, $pop18
	tee_local	$push25=, $3=, $pop26
	i32.store	__stack_pointer($pop19), $pop25
	i32.const	$push2=, 12
	i32.add 	$push3=, $3, $pop2
	i32.const	$push0=, 0
	i32.load16_u	$push1=, .Lf.s+12($pop0):p2align=0
	i32.store16	0($pop3), $pop1
	i32.const	$push5=, 8
	i32.add 	$push6=, $3, $pop5
	i32.const	$push24=, 0
	i32.load	$push4=, .Lf.s+8($pop24):p2align=0
	i32.store	0($pop6), $pop4
	i32.const	$push23=, 0
	i64.load	$push7=, .Lf.s($pop23):p2align=0
	i64.store	0($3):p2align=2, $pop7
	i32.const	$push8=, 13
	i32.add 	$2=, $3, $pop8
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push31=, -2
	i32.add 	$1=, $2, $pop31
	i32.const	$push30=, -1
	i32.add 	$push29=, $2, $pop30
	tee_local	$push28=, $0=, $pop29
	copy_local	$2=, $pop28
	i32.load8_u	$push9=, 0($1)
	i32.const	$push27=, 48
	i32.eq  	$push10=, $pop9, $pop27
	br_if   	0, $pop10       # 0: up to label0
# BB#2:                                 # %while.end
	end_loop
	i32.const	$push11=, 88
	i32.store16	0($0):p2align=0, $pop11
	block   	
	i32.const	$push12=, 12
	i32.add 	$push13=, $3, $pop12
	i32.load8_u	$push14=, 0($pop13)
	i32.const	$push32=, 88
	i32.ne  	$push15=, $pop14, $pop32
	br_if   	0, $pop15       # 0: down to label1
# BB#3:                                 # %if.end
	i32.const	$push22=, 0
	i32.const	$push20=, 16
	i32.add 	$push21=, $3, $pop20
	i32.store	__stack_pointer($pop22), $pop21
	return  	$2
.LBB1_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.call	$drop=, f@FUNCTION
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.Lf.s,@object           # @f.s
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lf.s:
	.asciz	"abcedfg012345"
	.size	.Lf.s, 14


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
