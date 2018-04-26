	.text
	.file	"20021024-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 511
	i32.and 	$2=, $0, $pop0
	i32.const	$push1=, 20
	i32.shr_u	$push2=, $0, $pop1
	i32.const	$push3=, 4088
	i32.and 	$push4=, $pop2, $pop3
	i32.add 	$4=, $1, $pop4
	i32.const	$push5=, 6
	i32.shr_u	$push6=, $0, $pop5
	i32.const	$push16=, 4088
	i32.and 	$push7=, $pop6, $pop16
	i32.add 	$3=, $1, $pop7
	i32.const	$push15=, 0
	i32.load	$0=, cp($pop15)
.LBB1_1:                                # %top
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i64.const	$push19=, 1
	i64.store	0($0), $pop19
	i32.const	$push18=, 0
	i64.load	$push9=, 0($4)
	i64.load	$push8=, 0($3)
	i64.add 	$push10=, $pop9, $pop8
	i64.store	m($pop18), $pop10
	i64.const	$push17=, 2
	i64.store	0($0), $pop17
	i32.eqz 	$push20=, $2
	br_if   	0, $pop20       # 0: up to label0
# %bb.2:                                # %if.end
	end_loop
	i32.const	$push11=, 3
	i32.shl 	$push12=, $2, $pop11
	i32.add 	$push13=, $1, $pop12
	i64.const	$push14=, 1
	i64.store	0($pop13), $pop14
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$0=, $pop3, $pop5
	i32.const	$push6=, 0
	i32.store	__stack_pointer($pop6), $0
	i32.const	$push1=, 0
	i64.const	$push0=, 58
	i64.store	m($pop1), $pop0
	i32.const	$push10=, 0
	i32.const	$push7=, 8
	i32.add 	$push8=, $0, $pop7
	i32.store	cp($pop10), $pop8
	i64.const	$push2=, 2
	i64.store	8($0), $pop2
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	cp                      # @cp
	.type	cp,@object
	.section	.bss.cp,"aw",@nobits
	.globl	cp
	.p2align	2
cp:
	.int32	0
	.size	cp, 4

	.hidden	m                       # @m
	.type	m,@object
	.section	.bss.m,"aw",@nobits
	.globl	m
	.p2align	3
m:
	.int64	0                       # 0x0
	.size	m, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
