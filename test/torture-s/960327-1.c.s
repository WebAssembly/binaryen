	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960327-1.c"
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
	i32.const	$push20=, 0
	i32.const	$push17=, 0
	i32.load	$push18=, __stack_pointer($pop17)
	i32.const	$push19=, 16
	i32.sub 	$push24=, $pop18, $pop19
	i32.store	$push28=, __stack_pointer($pop20), $pop24
	tee_local	$push27=, $0=, $pop28
	i32.const	$push3=, 12
	i32.add 	$push4=, $pop27, $pop3
	i32.const	$push1=, 0
	i32.load16_u	$push2=, .Lf.s+12($pop1):p2align=0
	i32.store16	$drop=, 0($pop4), $pop2
	i32.const	$push6=, 8
	i32.add 	$push7=, $0, $pop6
	i32.const	$push26=, 0
	i32.load	$push5=, .Lf.s+8($pop26):p2align=0
	i32.store	$drop=, 0($pop7), $pop5
	i32.const	$push25=, 0
	i64.load	$push8=, .Lf.s($pop25):p2align=0
	i64.store	$drop=, 0($0):p2align=2, $pop8
	i32.const	$push9=, 13
	i32.add 	$3=, $0, $pop9
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push33=, -2
	i32.add 	$2=, $3, $pop33
	i32.const	$push32=, -1
	i32.add 	$push31=, $3, $pop32
	tee_local	$push30=, $1=, $pop31
	copy_local	$3=, $pop30
	i32.load8_u	$push10=, 0($2)
	i32.const	$push29=, 48
	i32.eq  	$push11=, $pop10, $pop29
	br_if   	0, $pop11       # 0: up to label0
# BB#2:                                 # %while.end
	end_loop                        # label1:
	block
	i32.const	$push12=, 88
	i32.store16	$push0=, 0($1):p2align=0, $pop12
	i32.const	$push13=, 12
	i32.add 	$push14=, $0, $pop13
	i32.load8_u	$push15=, 0($pop14)
	i32.ne  	$push16=, $pop0, $pop15
	br_if   	0, $pop16       # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$push23=, 0
	i32.const	$push21=, 16
	i32.add 	$push22=, $0, $pop21
	i32.store	$drop=, __stack_pointer($pop23), $pop22
	return  	$3
.LBB1_4:                                # %if.then
	end_block                       # label2:
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
