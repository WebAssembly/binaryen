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
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.const	$push2=, 12
	i32.add 	$push3=, $5, $pop2
	i32.const	$push0=, 0
	i32.load16_u	$push1=, .Lf.s+12($pop0):p2align=0
	i32.store16	$discard=, 0($pop3):p2align=2, $pop1
	i32.const	$push5=, 8
	i32.add 	$push6=, $5, $pop5
	i32.const	$push18=, 0
	i32.load	$push4=, .Lf.s+8($pop18):p2align=0
	i32.store	$discard=, 0($pop6), $pop4
	i32.const	$push17=, 0
	i64.load	$push7=, .Lf.s($pop17):p2align=0
	i64.store	$discard=, 0($5):p2align=2, $pop7
	i32.const	$push8=, 13
	i32.add 	$1=, $5, $pop8
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push21=, -2
	i32.add 	$0=, $1, $pop21
	i32.const	$push20=, -1
	i32.add 	$1=, $1, $pop20
	i32.load8_u	$push9=, 0($0)
	i32.const	$push19=, 48
	i32.eq  	$push10=, $pop9, $pop19
	br_if   	0, $pop10       # 0: up to label0
# BB#2:                                 # %while.end
	end_loop                        # label1:
	block
	i32.const	$push11=, 88
	i32.store16	$push12=, 0($1):p2align=0, $pop11
	i32.const	$push13=, 12
	i32.add 	$push14=, $5, $pop13
	i32.load8_u	$push15=, 0($pop14):p2align=2
	i32.ne  	$push16=, $pop12, $pop15
	br_if   	0, $pop16       # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return  	$1
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
	i32.call	$discard=, f@FUNCTION
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
