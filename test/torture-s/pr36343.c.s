	.text
	.file	"pr36343.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	f32
	.local  	i32, f32, i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$3=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $3
	i32.const	$push0=, 0
	i32.store	12($3), $pop0
	i32.const	$push1=, 1065353216
	i32.store	8($3), $pop1
	i32.const	$push11=, 12
	i32.add 	$push12=, $3, $pop11
	i32.const	$push13=, 8
	i32.add 	$push14=, $3, $pop13
	i32.select	$1=, $pop12, $pop14, $0
	call    	bar@FUNCTION, $1
	block   	
	block   	
	i32.eqz 	$push15=, $0
	br_if   	0, $pop15       # 0: down to label1
# %bb.1:                                # %if.then2
	i32.load	$push2=, 0($1)
	i32.load	$push3=, 0($pop2)
	f32.convert_s/i32	$2=, $pop3
	br      	1               # 1: down to label0
.LBB1_2:                                # %if.end3
	end_block                       # label1:
	f32.load	$2=, 8($3)
.LBB1_3:                                # %cleanup
	end_block                       # label0:
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $3, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	copy_local	$push16=, $2
                                        # fallthrough-return: $pop16
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push3=, 0
	f32.call	$push0=, foo@FUNCTION, $pop3
	f32.const	$push1=, 0x0p0
	f32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label2
# %bb.1:                                # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB2_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
