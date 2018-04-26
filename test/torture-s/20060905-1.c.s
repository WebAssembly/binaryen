	.text
	.file	"20060905-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$0=, s-384
	i32.const	$1=, 0
	i32.const	$2=, 0
.LBB0_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	block   	
	i32.const	$push6=, 128
	i32.lt_u	$push0=, $2, $pop6
	br_if   	0, $pop0        # 0: down to label1
# %bb.2:                                # %if.then.i
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push8=, 0
	i32.load8_u	$push1=, 0($0)
	i32.store8	g($pop8), $pop1
	i32.const	$push7=, 1
	i32.add 	$1=, $1, $pop7
.LBB0_3:                                # %for.inc.i
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label1:
	i32.const	$push11=, 3
	i32.add 	$0=, $0, $pop11
	i32.const	$push10=, 1
	i32.add 	$2=, $2, $pop10
	i32.const	$push9=, 256
	i32.ne  	$push2=, $2, $pop9
	br_if   	0, $pop2        # 0: up to label0
# %bb.4:                                # %foo.exit
	end_loop
	block   	
	i32.const	$push3=, 128
	i32.ne  	$push4=, $1, $pop3
	br_if   	0, $pop4        # 0: down to label2
# %bb.5:                                # %if.end
	i32.const	$push5=, 0
	return  	$pop5
.LBB0_6:                                # %if.then
	end_block                       # label2:
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
