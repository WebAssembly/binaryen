	.text
	.file	"20060905-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 128
	i32.const	$1=, 0
.LBB0_1:                                # %for.body.outer.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push17=, 0
	i32.const	$push16=, 128
	i32.const	$push15=, 128
	i32.gt_u	$push0=, $1, $pop15
	i32.select	$push14=, $1, $pop16, $pop0
	tee_local	$push13=, $1=, $pop14
	i32.const	$push12=, 3
	i32.mul 	$push1=, $pop13, $pop12
	i32.const	$push11=, s-384
	i32.add 	$push2=, $pop1, $pop11
	i32.load8_u	$push3=, 0($pop2)
	i32.store8	g($pop17), $pop3
	i32.const	$push10=, -1
	i32.add 	$0=, $0, $pop10
	i32.const	$push9=, 1
	i32.add 	$push8=, $1, $pop9
	tee_local	$push7=, $1=, $pop8
	i32.const	$push6=, 256
	i32.ne  	$push4=, $pop7, $pop6
	br_if   	0, $pop4        # 0: up to label0
# BB#2:                                 # %foo.exit
	end_loop
	block   	
	br_if   	0, $0           # 0: down to label1
# BB#3:                                 # %if.end
	i32.const	$push5=, 0
	return  	$pop5
.LBB0_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	4
s:
	.skip	768
	.size	s, 768

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
g:
	.int8	0                       # 0x0
	.size	g, 1


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
