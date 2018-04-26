	.text
	.file	"20030307-1.c"
	.section	.text.vfswrap_lock,"ax",@progbits
	.hidden	vfswrap_lock            # -- Begin function vfswrap_lock
	.globl	vfswrap_lock
	.type	vfswrap_lock,@function
vfswrap_lock:                           # @vfswrap_lock
	.param  	i32, i32, i32, i64, i64, i32
	.result 	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $5
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	vfswrap_lock, .Lfunc_end0-vfswrap_lock
                                        # -- End function
	.section	.text.fcntl_lock,"ax",@progbits
	.hidden	fcntl_lock              # -- Begin function fcntl_lock
	.globl	fcntl_lock
	.type	fcntl_lock,@function
fcntl_lock:                             # @fcntl_lock
	.param  	i32, i32, i64, i64, i32
	.result 	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $4
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	fcntl_lock, .Lfunc_end1-fcntl_lock
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
