	.text
	.file	"20020129-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.load	$2=, 28($1)
	block   	
	block   	
	block   	
	i32.load	$push0=, 28($0)
	i32.eqz 	$push18=, $pop0
	br_if   	0, $pop18       # 0: down to label2
# %bb.1:                                # %if.end
	i32.eqz 	$push19=, $2
	br_if   	1, $pop19       # 1: down to label1
	br      	2               # 2: down to label0
.LBB0_2:                                # %if.then
	end_block                       # label2:
	i32.const	$push1=, 28
	i32.add 	$push2=, $0, $pop1
	i32.store	0($pop2), $2
	i32.const	$push13=, 28
	i32.add 	$push3=, $1, $pop13
	i32.const	$push4=, 0
	i32.store	0($pop3), $pop4
	i32.eqz 	$push20=, $2
	br_if   	0, $pop20       # 0: down to label1
.LBB0_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.store	4($2), $0
	i32.load	$2=, 0($2)
	br_if   	0, $2           # 0: up to label3
.LBB0_4:                                # %if.end7
	end_loop
	end_block                       # label1:
	i32.load	$2=, 12($1)
	block   	
	i32.load	$push5=, 12($0)
	i32.const	$push14=, -1
	i32.eq  	$push6=, $pop5, $pop14
	br_if   	0, $pop6        # 0: down to label4
# %bb.5:                                # %if.end22
	i32.const	$push15=, -1
	i32.ne  	$push7=, $2, $pop15
	br_if   	1, $pop7        # 1: down to label0
# %bb.6:                                # %if.end27
	return
.LBB0_7:                                # %if.end22.thread
	end_block                       # label4:
	i32.load	$push8=, 16($1)
	i32.store	16($0), $pop8
	i32.const	$push9=, 12
	i32.add 	$push10=, $0, $pop9
	i32.store	0($pop10), $2
	i32.const	$push11=, 0
	i32.store	16($1), $pop11
	i32.const	$push17=, 12
	i32.add 	$push12=, $1, $pop17
	i32.const	$push16=, -1
	i32.store	0($pop12), $pop16
	return
.LBB0_8:                                # %if.then6
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 6
	i32.store	y($pop1), $pop0
	i32.const	$push8=, 0
	i64.const	$push2=, 10514079940753
	i64.store	y+12($pop8):p2align=2, $pop2
	i32.const	$push7=, 0
	i32.const	$push3=, -1
	i32.store	x+12($pop7), $pop3
	i32.const	$push5=, x
	i32.const	$push4=, y
	call    	foo@FUNCTION, $pop5, $pop4
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	y                       # @y
	.type	y,@object
	.section	.bss.y,"aw",@nobits
	.globl	y
	.p2align	2
y:
	.skip	32
	.size	y, 32

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.skip	32
	.size	x, 32


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
