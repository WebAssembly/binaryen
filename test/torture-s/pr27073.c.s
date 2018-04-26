	.text
	.file	"pr27073.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	block   	
	i32.eqz 	$push11=, $4
	br_if   	0, $pop11       # 0: down to label0
# %bb.1:                                # %while.body.lr.ph
	i32.const	$push0=, 0
	i32.sub 	$4=, $pop0, $4
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.store	0($0), $5
	i32.const	$push10=, 4
	i32.add 	$push1=, $0, $pop10
	i32.store	0($pop1), $6
	i32.const	$push9=, 8
	i32.add 	$push2=, $0, $pop9
	i32.store	0($pop2), $7
	i32.const	$push8=, 12
	i32.add 	$push3=, $0, $pop8
	i32.store	0($pop3), $8
	i32.const	$push7=, 16
	i32.add 	$push4=, $0, $pop7
	i32.store	0($pop4), $9
	i32.const	$push6=, 20
	i32.add 	$0=, $0, $pop6
	i32.const	$push5=, 1
	i32.add 	$4=, $4, $pop5
	br_if   	0, $4           # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
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
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push35=, 0
	i32.load	$push34=, __stack_pointer($pop35)
	i32.const	$push36=, 48
	i32.sub 	$0=, $pop34, $pop36
	i32.const	$push37=, 0
	i32.store	__stack_pointer($pop37), $0
	i32.const	$push4=, 2
	i32.const	$push3=, 100
	i32.const	$push39=, 200
	i32.const	$push2=, 300
	i32.const	$push1=, 400
	i32.const	$push0=, 500
	call    	foo@FUNCTION, $0, $0, $0, $0, $pop4, $pop3, $pop39, $pop2, $pop1, $pop0
	block   	
	i32.load	$push5=, 0($0)
	i32.const	$push38=, 100
	i32.ne  	$push6=, $pop5, $pop38
	br_if   	0, $pop6        # 0: down to label2
# %bb.1:                                # %for.cond
	i32.load	$push7=, 4($0)
	i32.const	$push40=, 200
	i32.ne  	$push8=, $pop7, $pop40
	br_if   	0, $pop8        # 0: down to label2
# %bb.2:                                # %for.cond.1
	i32.load	$push10=, 8($0)
	i32.const	$push9=, 300
	i32.ne  	$push11=, $pop10, $pop9
	br_if   	0, $pop11       # 0: down to label2
# %bb.3:                                # %for.cond.2
	i32.load	$push13=, 12($0)
	i32.const	$push12=, 400
	i32.ne  	$push14=, $pop13, $pop12
	br_if   	0, $pop14       # 0: down to label2
# %bb.4:                                # %for.cond.3
	i32.load	$push16=, 16($0)
	i32.const	$push15=, 500
	i32.ne  	$push17=, $pop16, $pop15
	br_if   	0, $pop17       # 0: down to label2
# %bb.5:                                # %for.cond.4
	i32.load	$push19=, 20($0)
	i32.const	$push18=, 100
	i32.ne  	$push20=, $pop19, $pop18
	br_if   	0, $pop20       # 0: down to label2
# %bb.6:                                # %for.cond.5
	i32.load	$push22=, 24($0)
	i32.const	$push21=, 200
	i32.ne  	$push23=, $pop22, $pop21
	br_if   	0, $pop23       # 0: down to label2
# %bb.7:                                # %for.cond.6
	i32.load	$push25=, 28($0)
	i32.const	$push24=, 300
	i32.ne  	$push26=, $pop25, $pop24
	br_if   	0, $pop26       # 0: down to label2
# %bb.8:                                # %for.cond.7
	i32.load	$push28=, 32($0)
	i32.const	$push27=, 400
	i32.ne  	$push29=, $pop28, $pop27
	br_if   	0, $pop29       # 0: down to label2
# %bb.9:                                # %for.cond.8
	i32.load	$push31=, 36($0)
	i32.const	$push30=, 500
	i32.ne  	$push32=, $pop31, $pop30
	br_if   	0, $pop32       # 0: down to label2
# %bb.10:                               # %for.cond.9
	i32.const	$push33=, 0
	call    	exit@FUNCTION, $pop33
	unreachable
.LBB1_11:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
