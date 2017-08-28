	.text
	.file	"931004-9.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.load8_u	$push0=, 0($1)
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load8_u	$push3=, 1($1)
	i32.const	$push4=, 20
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.load8_u	$push6=, 0($2)
	i32.const	$push7=, 11
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end12
	i32.load8_u	$push9=, 1($2)
	i32.const	$push10=, 21
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %if.end18
	i32.load8_u	$push12=, 0($3)
	i32.const	$push13=, 12
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#5:                                 # %if.end24
	i32.load8_u	$push15=, 1($3)
	i32.const	$push16=, 22
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# BB#6:                                 # %if.end30
	i32.const	$push18=, 123
	i32.ne  	$push19=, $4, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#7:                                 # %if.end34
	return  	$2
.LBB0_8:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push8=, 0
	i32.load	$push7=, __stack_pointer($pop8)
	i32.const	$push9=, 16
	i32.sub 	$push18=, $pop7, $pop9
	tee_local	$push17=, $0=, $pop18
	i32.store	__stack_pointer($pop10), $pop17
	i32.const	$push0=, 5130
	i32.store16	8($0), $pop0
	i32.const	$push1=, 369890571
	i32.store	10($0):p2align=1, $pop1
	i32.load16_u	$push2=, 8($0)
	i32.store16	6($0), $pop2
	i32.load16_u	$push3=, 10($0)
	i32.store16	4($0), $pop3
	i32.load16_u	$push4=, 12($0)
	i32.store16	2($0), $pop4
	i32.const	$push11=, 6
	i32.add 	$push12=, $0, $pop11
	i32.const	$push13=, 4
	i32.add 	$push14=, $0, $pop13
	i32.const	$push15=, 2
	i32.add 	$push16=, $0, $pop15
	i32.const	$push5=, 123
	i32.call	$drop=, f@FUNCTION, $0, $pop12, $pop14, $pop16, $pop5
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
