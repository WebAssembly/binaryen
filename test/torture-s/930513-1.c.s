	.text
	.file	"930513-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$1=, $pop3, $pop5
	i32.const	$push6=, 0
	i32.store	__stack_pointer($pop6), $1
	i64.const	$push0=, 4617315517961601024
	i64.store	0($1), $pop0
	i32.const	$push2=, buf
	i32.const	$push1=, .L.str
	i32.call_indirect	$drop=, $pop2, $pop1, $1, $0
	i32.const	$push9=, 0
	i32.const	$push7=, 16
	i32.add 	$push8=, $1, $pop7
	i32.store	__stack_pointer($pop9), $pop8
	copy_local	$push10=, $1
                                        # fallthrough-return: $pop10
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
# %bb.0:                                # %entry
	i32.const	$push11=, 0
	i32.load	$push10=, __stack_pointer($pop11)
	i32.const	$push12=, 16
	i32.sub 	$0=, $pop10, $pop12
	i32.const	$push13=, 0
	i32.store	__stack_pointer($pop13), $0
	i64.const	$push1=, 4617315517961601024
	i64.store	0($0), $pop1
	i32.const	$push3=, buf
	i32.const	$push2=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $pop3, $pop2, $0
	block   	
	i32.const	$push14=, 0
	i32.load8_u	$push4=, buf($pop14)
	i32.const	$push5=, 53
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.1:                                # %entry
	i32.const	$push15=, 0
	i32.load8_u	$push0=, buf+1($pop15)
	i32.const	$push7=, 255
	i32.and 	$push8=, $pop0, $pop7
	br_if   	0, $pop8        # 0: down to label0
# %bb.2:                                # %if.end
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
buf:
	.skip	2
	.size	buf, 2

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%.0f"
	.size	.L.str, 5


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	sprintf, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
