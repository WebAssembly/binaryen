	.text
	.file	"990524-1.c"
	.section	.text.loop,"ax",@progbits
	.hidden	loop                    # -- Begin function loop
	.globl	loop
	.type	loop,@function
loop:                                   # @loop
	.param  	i32, i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	copy_local	$2=, $1
	i32.load8_u	$4=, 0($2)
	i32.store8	0($0), $4
	i32.const	$push18=, 1
	i32.add 	$1=, $2, $pop18
	i32.const	$push17=, 24
	i32.shl 	$push0=, $4, $pop17
	i32.const	$push16=, 24
	i32.shr_s	$3=, $pop0, $pop16
	block   	
	block   	
	i32.const	$push15=, 34
	i32.eq  	$push1=, $4, $pop15
	br_if   	0, $pop1        # 0: down to label2
# %bb.2:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push19=, 92
	i32.ne  	$push2=, $3, $pop19
	br_if   	1, $pop2        # 1: down to label1
.LBB0_3:                                # %sw.bb2
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push14=, 92
	i32.store8	0($0), $pop14
	i32.const	$push13=, 1
	i32.add 	$push3=, $0, $pop13
	i32.load8_u	$push4=, 0($2)
	i32.store8	0($pop3), $pop4
	i32.const	$push12=, 2
	i32.add 	$0=, $0, $pop12
	br      	1               # 1: up to label0
.LBB0_4:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label1:
	i32.const	$push20=, 1
	i32.add 	$0=, $0, $pop20
	br_if   	0, $3           # 0: up to label0
# %bb.5:                                # %loopDone2
	end_loop
	block   	
	i32.const	$push5=, a
	i32.sub 	$push6=, $pop5, $0
	i32.const	$push9=, b
	i32.const	$push7=, 1
	i32.add 	$push8=, $2, $pop7
	i32.sub 	$push10=, $pop9, $pop8
	i32.ne  	$push11=, $pop6, $pop10
	br_if   	0, $pop11       # 0: down to label3
# %bb.6:                                # %if.end
	return
.LBB0_7:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	loop, .Lfunc_end0-loop
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push1=, a
	i32.const	$push0=, b
	call    	loop@FUNCTION, $pop1, $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
a:
	.asciz	"12345"
	.size	a, 6

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
b:
	.asciz	"12345"
	.size	b, 6


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
