	.text
	.file	"980605-1.c"
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	f64
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$1=, x($pop0)
	i32.const	$push12=, 0
	i32.const	$push1=, 10
	i32.add 	$push2=, $1, $pop1
	i32.store	x($pop12), $pop2
	i32.const	$push11=, 10
	i32.mul 	$1=, $1, $pop11
	block   	
	block   	
	f64.const	$push6=, 0x1p32
	f64.lt  	$push7=, $0, $pop6
	f64.const	$push8=, 0x0p0
	f64.ge  	$push9=, $0, $pop8
	i32.and 	$push10=, $pop7, $pop9
	br_if   	0, $pop10       # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$2=, 0
	br      	1               # 1: down to label0
.LBB0_2:                                # %entry
	end_block                       # label1:
	i32.trunc_u/f64	$2=, $0
.LBB0_3:                                # %entry
	end_block                       # label0:
	i32.add 	$push3=, $2, $1
	i32.const	$push4=, 45
	i32.add 	$push5=, $pop3, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	f2, .Lfunc_end0-f2
                                        # -- End function
	.section	.text.getval,"ax",@progbits
	.hidden	getval                  # -- Begin function getval
	.globl	getval
	.type	getval,@function
getval:                                 # @getval
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$0=, x($pop0)
	i32.const	$push3=, 0
	i32.const	$push1=, 1
	i32.add 	$push2=, $0, $pop1
	i32.store	x($pop3), $pop2
	copy_local	$push4=, $0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end1:
	.size	getval, .Lfunc_end1-getval
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push10=, 0
	i32.load	$push9=, __stack_pointer($pop10)
	i32.const	$push11=, 16
	i32.sub 	$1=, $pop9, $pop11
	i32.const	$push12=, 0
	i32.store	__stack_pointer($pop12), $1
	i32.const	$push0=, 0
	i32.load	$0=, x($pop0)
	i32.const	$push17=, 0
	i32.const	$push1=, 20
	i32.add 	$push2=, $0, $pop1
	i32.store	x($pop17), $pop2
	i32.const	$push16=, 20
	i32.mul 	$push3=, $0, $pop16
	i32.const	$push4=, 207
	i32.add 	$0=, $pop3, $pop4
	i32.store	0($1), $0
	i32.const	$push6=, buf
	i32.const	$push5=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $pop6, $pop5, $1
	block   	
	i32.const	$push7=, 227
	i32.ne  	$push8=, $0, $pop7
	br_if   	0, $pop8        # 0: down to label2
# %bb.1:                                # %if.end
	i32.const	$push15=, 0
	i32.const	$push13=, 16
	i32.add 	$push14=, $1, $pop13
	i32.store	__stack_pointer($pop15), $pop14
	return
.LBB2_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f, .Lfunc_end2-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	call    	f@FUNCTION
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	2
x:
	.int32	1                       # 0x1
	.size	x, 4

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
buf:
	.skip	10
	.size	buf, 10

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d\n"
	.size	.L.str, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	sprintf, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
