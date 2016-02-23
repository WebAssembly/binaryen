	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/bitfld-5.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i64, i64
# BB#0:                                 # %entry
	#APP
	#NO_APP
	block
	i64.ne  	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i64
# BB#0:                                 # %entry
	#APP
	#NO_APP
	i64.load	$push0=, 0($0)
	i64.const	$push1=, 2
	i64.shr_u	$push2=, $pop0, $pop1
	i64.const	$push3=, 1099511627775
	i64.and 	$push4=, $pop2, $pop3
	call    	g@FUNCTION, $pop4, $1
	return
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
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 16
	i32.sub 	$1=, $pop8, $pop9
	i32.const	$push10=, __stack_pointer
	i32.store	$discard=, 0($pop10), $1
	i32.const	$push0=, 0
	i64.load	$push1=, .Lmain.s($pop0)
	i64.store	$discard=, 8($1), $pop1
	i64.const	$push2=, 10
	i32.const	$0=, 8
	i32.add 	$0=, $1, $0
	call    	f@FUNCTION, $0, $pop2
	i32.const	$push6=, 0
	i64.load	$push3=, .Lmain.t($pop6)
	i64.store	$discard=, 0($1), $pop3
	i64.const	$push4=, 1099511627778
	call    	f@FUNCTION, $1, $pop4
	i32.const	$push5=, 0
	i32.const	$push11=, 16
	i32.add 	$1=, $1, $pop11
	i32.const	$push12=, __stack_pointer
	i32.store	$discard=, 0($pop12), $1
	return  	$pop5
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.Lmain.s,@object        # @main.s
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.Lmain.s:
	.int8	41                      # 0x29
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	12                      # 0xc
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.size	.Lmain.s, 8

	.type	.Lmain.t,@object        # @main.t
	.p2align	3
.Lmain.t:
	.int8	9                       # 0x9
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	12                      # 0xc
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.size	.Lmain.t, 8


	.ident	"clang version 3.9.0 "
