	.text
	.file	"pr40022.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, __stack_pointer($pop1)
	i32.const	$push2=, 16
	i32.sub 	$1=, $pop0, $pop2
	i32.store	12($1), $0
	#APP
	#NO_APP
	copy_local	$push3=, $0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.call	$1=, foo@FUNCTION, $1
	i32.store	0($0), $1
	block   	
	i32.eqz 	$push1=, $1
	br_if   	0, $pop1        # 0: down to label0
.LBB1_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	copy_local	$0=, $1
	i32.load	$1=, 0($0)
	br_if   	0, $1           # 0: up to label1
.LBB1_2:                                # %while.end
	end_loop
	end_block                       # label0:
	i32.call	$1=, foo@FUNCTION, $2
	i32.store	0($0), $1
	block   	
	i32.eqz 	$push2=, $1
	br_if   	0, $pop2        # 0: down to label2
.LBB1_3:                                # %while.body4
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	copy_local	$0=, $1
	i32.load	$1=, 0($0)
	br_if   	0, $1           # 0: up to label3
.LBB1_4:                                # %while.end6
	end_loop
	end_block                       # label2:
	i32.call	$push0=, foo@FUNCTION, $3
	i32.store	0($0), $pop0
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
	i32.const	$push1=, 0
	i32.const	$push0=, g
	i32.store	f($pop1), $pop0
	i32.const	$push4=, d
	i32.const	$push3=, e
	i32.const	$push2=, f
	i32.const	$push8=, 0
	call    	bar@FUNCTION, $pop4, $pop3, $pop2, $pop8
	i32.const	$push7=, 0
	i32.load	$0=, d($pop7)
	block   	
	i32.eqz 	$push9=, $0
	br_if   	0, $pop9        # 0: down to label4
# %bb.1:                                # %lor.lhs.false
	i32.load	$0=, 0($0)
	i32.eqz 	$push10=, $0
	br_if   	0, $pop10       # 0: down to label4
# %bb.2:                                # %lor.lhs.false2
	i32.load	$0=, 0($0)
	i32.eqz 	$push11=, $0
	br_if   	0, $pop11       # 0: down to label4
# %bb.3:                                # %lor.lhs.false6
	i32.load	$push5=, 0($0)
	br_if   	0, $pop5        # 0: down to label4
# %bb.4:                                # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB2_5:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	2
g:
	.skip	4
	.size	g, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.skip	4
	.size	f, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.skip	4
	.size	d, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.skip	4
	.size	e, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
