	.text
	.file	"960209-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.const	$push7=, 0
	i32.select	$1=, $pop0, $pop7, $1
	block   	
	i32.const	$push6=, 0
	i32.load	$push1=, yabba($pop6)
	i32.eqz 	$push9=, $pop1
	br_if   	0, $pop9        # 0: down to label0
# BB#1:                                 # %cleanup
	return  	$1
.LBB0_2:                                # %if.end24
	end_block                       # label0:
	i32.const	$push8=, 0
	i32.const	$push2=, 255
	i32.and 	$push3=, $0, $pop2
	i32.const	$push4=, an_array
	i32.add 	$push5=, $pop3, $pop4
	i32.store	a_ptr($pop8), $pop5
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
# BB#0:                                 # %entry
	block   	
	i32.const	$push2=, 0
	i32.load	$push0=, yabba($pop2)
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %if.end24.i
	i32.const	$push3=, 0
	i32.const	$push1=, an_array+1
	i32.store	a_ptr($pop3), $pop1
.LBB1_2:                                # %if.end
	end_block                       # label1:
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	yabba                   # @yabba
	.type	yabba,@object
	.section	.data.yabba,"aw",@progbits
	.globl	yabba
	.p2align	2
yabba:
	.int32	1                       # 0x1
	.size	yabba, 4

	.hidden	an_array                # @an_array
	.type	an_array,@object
	.section	.bss.an_array,"aw",@nobits
	.globl	an_array
an_array:
	.skip	5
	.size	an_array, 5

	.hidden	a_ptr                   # @a_ptr
	.type	a_ptr,@object
	.section	.bss.a_ptr,"aw",@nobits
	.globl	a_ptr
	.p2align	2
a_ptr:
	.int32	0
	.size	a_ptr, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
