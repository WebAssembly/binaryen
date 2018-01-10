	.text
	.file	"gofast.c"
	.section	.text.fp_add,"ax",@progbits
	.hidden	fp_add                  # -- Begin function fp_add
	.globl	fp_add
	.type	fp_add,@function
fp_add:                                 # @fp_add
	.param  	f32, f32
	.result 	f32
# %bb.0:                                # %entry
	f32.add 	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	fp_add, .Lfunc_end0-fp_add
                                        # -- End function
	.section	.text.fp_sub,"ax",@progbits
	.hidden	fp_sub                  # -- Begin function fp_sub
	.globl	fp_sub
	.type	fp_sub,@function
fp_sub:                                 # @fp_sub
	.param  	f32, f32
	.result 	f32
# %bb.0:                                # %entry
	f32.sub 	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	fp_sub, .Lfunc_end1-fp_sub
                                        # -- End function
	.section	.text.fp_mul,"ax",@progbits
	.hidden	fp_mul                  # -- Begin function fp_mul
	.globl	fp_mul
	.type	fp_mul,@function
fp_mul:                                 # @fp_mul
	.param  	f32, f32
	.result 	f32
# %bb.0:                                # %entry
	f32.mul 	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	fp_mul, .Lfunc_end2-fp_mul
                                        # -- End function
	.section	.text.fp_div,"ax",@progbits
	.hidden	fp_div                  # -- Begin function fp_div
	.globl	fp_div
	.type	fp_div,@function
fp_div:                                 # @fp_div
	.param  	f32, f32
	.result 	f32
# %bb.0:                                # %entry
	f32.div 	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	fp_div, .Lfunc_end3-fp_div
                                        # -- End function
	.section	.text.fp_neg,"ax",@progbits
	.hidden	fp_neg                  # -- Begin function fp_neg
	.globl	fp_neg
	.type	fp_neg,@function
fp_neg:                                 # @fp_neg
	.param  	f32
	.result 	f32
# %bb.0:                                # %entry
	f32.neg 	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	fp_neg, .Lfunc_end4-fp_neg
                                        # -- End function
	.section	.text.dp_add,"ax",@progbits
	.hidden	dp_add                  # -- Begin function dp_add
	.globl	dp_add
	.type	dp_add,@function
dp_add:                                 # @dp_add
	.param  	f64, f64
	.result 	f64
# %bb.0:                                # %entry
	f64.add 	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end5:
	.size	dp_add, .Lfunc_end5-dp_add
                                        # -- End function
	.section	.text.dp_sub,"ax",@progbits
	.hidden	dp_sub                  # -- Begin function dp_sub
	.globl	dp_sub
	.type	dp_sub,@function
dp_sub:                                 # @dp_sub
	.param  	f64, f64
	.result 	f64
# %bb.0:                                # %entry
	f64.sub 	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end6:
	.size	dp_sub, .Lfunc_end6-dp_sub
                                        # -- End function
	.section	.text.dp_mul,"ax",@progbits
	.hidden	dp_mul                  # -- Begin function dp_mul
	.globl	dp_mul
	.type	dp_mul,@function
dp_mul:                                 # @dp_mul
	.param  	f64, f64
	.result 	f64
# %bb.0:                                # %entry
	f64.mul 	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end7:
	.size	dp_mul, .Lfunc_end7-dp_mul
                                        # -- End function
	.section	.text.dp_div,"ax",@progbits
	.hidden	dp_div                  # -- Begin function dp_div
	.globl	dp_div
	.type	dp_div,@function
dp_div:                                 # @dp_div
	.param  	f64, f64
	.result 	f64
# %bb.0:                                # %entry
	f64.div 	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end8:
	.size	dp_div, .Lfunc_end8-dp_div
                                        # -- End function
	.section	.text.dp_neg,"ax",@progbits
	.hidden	dp_neg                  # -- Begin function dp_neg
	.globl	dp_neg
	.type	dp_neg,@function
dp_neg:                                 # @dp_neg
	.param  	f64
	.result 	f64
# %bb.0:                                # %entry
	f64.neg 	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end9:
	.size	dp_neg, .Lfunc_end9-dp_neg
                                        # -- End function
	.section	.text.fp_to_dp,"ax",@progbits
	.hidden	fp_to_dp                # -- Begin function fp_to_dp
	.globl	fp_to_dp
	.type	fp_to_dp,@function
fp_to_dp:                               # @fp_to_dp
	.param  	f32
	.result 	f64
# %bb.0:                                # %entry
	f64.promote/f32	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end10:
	.size	fp_to_dp, .Lfunc_end10-fp_to_dp
                                        # -- End function
	.section	.text.dp_to_fp,"ax",@progbits
	.hidden	dp_to_fp                # -- Begin function dp_to_fp
	.globl	dp_to_fp
	.type	dp_to_fp,@function
dp_to_fp:                               # @dp_to_fp
	.param  	f64
	.result 	f32
# %bb.0:                                # %entry
	f32.demote/f64	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end11:
	.size	dp_to_fp, .Lfunc_end11-dp_to_fp
                                        # -- End function
	.section	.text.eqsf2,"ax",@progbits
	.hidden	eqsf2                   # -- Begin function eqsf2
	.globl	eqsf2
	.type	eqsf2,@function
eqsf2:                                  # @eqsf2
	.param  	f32, f32
	.result 	i32
# %bb.0:                                # %entry
	f32.eq  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end12:
	.size	eqsf2, .Lfunc_end12-eqsf2
                                        # -- End function
	.section	.text.nesf2,"ax",@progbits
	.hidden	nesf2                   # -- Begin function nesf2
	.globl	nesf2
	.type	nesf2,@function
nesf2:                                  # @nesf2
	.param  	f32, f32
	.result 	i32
# %bb.0:                                # %entry
	f32.ne  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end13:
	.size	nesf2, .Lfunc_end13-nesf2
                                        # -- End function
	.section	.text.gtsf2,"ax",@progbits
	.hidden	gtsf2                   # -- Begin function gtsf2
	.globl	gtsf2
	.type	gtsf2,@function
gtsf2:                                  # @gtsf2
	.param  	f32, f32
	.result 	i32
# %bb.0:                                # %entry
	f32.gt  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end14:
	.size	gtsf2, .Lfunc_end14-gtsf2
                                        # -- End function
	.section	.text.gesf2,"ax",@progbits
	.hidden	gesf2                   # -- Begin function gesf2
	.globl	gesf2
	.type	gesf2,@function
gesf2:                                  # @gesf2
	.param  	f32, f32
	.result 	i32
# %bb.0:                                # %entry
	f32.ge  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end15:
	.size	gesf2, .Lfunc_end15-gesf2
                                        # -- End function
	.section	.text.ltsf2,"ax",@progbits
	.hidden	ltsf2                   # -- Begin function ltsf2
	.globl	ltsf2
	.type	ltsf2,@function
ltsf2:                                  # @ltsf2
	.param  	f32, f32
	.result 	i32
# %bb.0:                                # %entry
	f32.lt  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end16:
	.size	ltsf2, .Lfunc_end16-ltsf2
                                        # -- End function
	.section	.text.lesf2,"ax",@progbits
	.hidden	lesf2                   # -- Begin function lesf2
	.globl	lesf2
	.type	lesf2,@function
lesf2:                                  # @lesf2
	.param  	f32, f32
	.result 	i32
# %bb.0:                                # %entry
	f32.le  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end17:
	.size	lesf2, .Lfunc_end17-lesf2
                                        # -- End function
	.section	.text.eqdf2,"ax",@progbits
	.hidden	eqdf2                   # -- Begin function eqdf2
	.globl	eqdf2
	.type	eqdf2,@function
eqdf2:                                  # @eqdf2
	.param  	f64, f64
	.result 	i32
# %bb.0:                                # %entry
	f64.eq  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end18:
	.size	eqdf2, .Lfunc_end18-eqdf2
                                        # -- End function
	.section	.text.nedf2,"ax",@progbits
	.hidden	nedf2                   # -- Begin function nedf2
	.globl	nedf2
	.type	nedf2,@function
nedf2:                                  # @nedf2
	.param  	f64, f64
	.result 	i32
# %bb.0:                                # %entry
	f64.ne  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end19:
	.size	nedf2, .Lfunc_end19-nedf2
                                        # -- End function
	.section	.text.gtdf2,"ax",@progbits
	.hidden	gtdf2                   # -- Begin function gtdf2
	.globl	gtdf2
	.type	gtdf2,@function
gtdf2:                                  # @gtdf2
	.param  	f64, f64
	.result 	i32
# %bb.0:                                # %entry
	f64.gt  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end20:
	.size	gtdf2, .Lfunc_end20-gtdf2
                                        # -- End function
	.section	.text.gedf2,"ax",@progbits
	.hidden	gedf2                   # -- Begin function gedf2
	.globl	gedf2
	.type	gedf2,@function
gedf2:                                  # @gedf2
	.param  	f64, f64
	.result 	i32
# %bb.0:                                # %entry
	f64.ge  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end21:
	.size	gedf2, .Lfunc_end21-gedf2
                                        # -- End function
	.section	.text.ltdf2,"ax",@progbits
	.hidden	ltdf2                   # -- Begin function ltdf2
	.globl	ltdf2
	.type	ltdf2,@function
ltdf2:                                  # @ltdf2
	.param  	f64, f64
	.result 	i32
# %bb.0:                                # %entry
	f64.lt  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end22:
	.size	ltdf2, .Lfunc_end22-ltdf2
                                        # -- End function
	.section	.text.ledf2,"ax",@progbits
	.hidden	ledf2                   # -- Begin function ledf2
	.globl	ledf2
	.type	ledf2,@function
ledf2:                                  # @ledf2
	.param  	f64, f64
	.result 	i32
# %bb.0:                                # %entry
	f64.le  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end23:
	.size	ledf2, .Lfunc_end23-ledf2
                                        # -- End function
	.section	.text.floatsisf,"ax",@progbits
	.hidden	floatsisf               # -- Begin function floatsisf
	.globl	floatsisf
	.type	floatsisf,@function
floatsisf:                              # @floatsisf
	.param  	i32
	.result 	f32
# %bb.0:                                # %entry
	f32.convert_s/i32	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end24:
	.size	floatsisf, .Lfunc_end24-floatsisf
                                        # -- End function
	.section	.text.floatsidf,"ax",@progbits
	.hidden	floatsidf               # -- Begin function floatsidf
	.globl	floatsidf
	.type	floatsidf,@function
floatsidf:                              # @floatsidf
	.param  	i32
	.result 	f64
# %bb.0:                                # %entry
	f64.convert_s/i32	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end25:
	.size	floatsidf, .Lfunc_end25-floatsidf
                                        # -- End function
	.section	.text.fixsfsi,"ax",@progbits
	.hidden	fixsfsi                 # -- Begin function fixsfsi
	.globl	fixsfsi
	.type	fixsfsi,@function
fixsfsi:                                # @fixsfsi
	.param  	f32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	f32.abs 	$push0=, $0
	f32.const	$push1=, 0x1p31
	f32.lt  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %entry
	i32.const	$push3=, -2147483648
	return  	$pop3
.LBB26_2:                               # %entry
	end_block                       # label0:
	i32.trunc_s/f32	$push4=, $0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end26:
	.size	fixsfsi, .Lfunc_end26-fixsfsi
                                        # -- End function
	.section	.text.fixdfsi,"ax",@progbits
	.hidden	fixdfsi                 # -- Begin function fixdfsi
	.globl	fixdfsi
	.type	fixdfsi,@function
fixdfsi:                                # @fixdfsi
	.param  	f64
	.result 	i32
# %bb.0:                                # %entry
	block   	
	f64.abs 	$push0=, $0
	f64.const	$push1=, 0x1p31
	f64.lt  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$push3=, -2147483648
	return  	$pop3
.LBB27_2:                               # %entry
	end_block                       # label1:
	i32.trunc_s/f64	$push4=, $0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end27:
	.size	fixdfsi, .Lfunc_end27-fixdfsi
                                        # -- End function
	.section	.text.fixunssfsi,"ax",@progbits
	.hidden	fixunssfsi              # -- Begin function fixunssfsi
	.globl	fixunssfsi
	.type	fixunssfsi,@function
fixunssfsi:                             # @fixunssfsi
	.param  	f32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	f32.const	$push0=, 0x1p32
	f32.lt  	$push1=, $0, $pop0
	f32.const	$push2=, 0x0p0
	f32.ge  	$push3=, $0, $pop2
	i32.and 	$push4=, $pop1, $pop3
	br_if   	0, $pop4        # 0: down to label2
# %bb.1:                                # %entry
	i32.const	$push5=, 0
	return  	$pop5
.LBB28_2:                               # %entry
	end_block                       # label2:
	i32.trunc_u/f32	$push6=, $0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end28:
	.size	fixunssfsi, .Lfunc_end28-fixunssfsi
                                        # -- End function
	.section	.text.fixunsdfsi,"ax",@progbits
	.hidden	fixunsdfsi              # -- Begin function fixunsdfsi
	.globl	fixunsdfsi
	.type	fixunsdfsi,@function
fixunsdfsi:                             # @fixunsdfsi
	.param  	f64
	.result 	i32
# %bb.0:                                # %entry
	block   	
	f64.const	$push0=, 0x1p32
	f64.lt  	$push1=, $0, $pop0
	f64.const	$push2=, 0x0p0
	f64.ge  	$push3=, $0, $pop2
	i32.and 	$push4=, $pop1, $pop3
	br_if   	0, $pop4        # 0: down to label3
# %bb.1:                                # %entry
	i32.const	$push5=, 0
	return  	$pop5
.LBB29_2:                               # %entry
	end_block                       # label3:
	i32.trunc_u/f64	$push6=, $0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end29:
	.size	fixunsdfsi, .Lfunc_end29-fixunsdfsi
                                        # -- End function
	.section	.text.fail,"ax",@progbits
	.hidden	fail                    # -- Begin function fail
	.globl	fail
	.type	fail,@function
fail:                                   # @fail
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 16
	i32.sub 	$1=, $pop6, $pop8
	i32.const	$push9=, 0
	i32.store	__stack_pointer($pop9), $1
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load	$push1=, fail_count($pop14)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	fail_count($pop0), $pop3
	i32.store	0($1), $0
	i32.const	$push13=, 0
	i32.load	$push4=, stderr($pop13)
	i32.const	$push5=, .L.str
	i32.call	$drop=, fprintf@FUNCTION, $pop4, $pop5, $1
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $1, $pop10
	i32.store	__stack_pointer($pop12), $pop11
	copy_local	$push15=, $1
                                        # fallthrough-return: $pop15
	.endfunc
.Lfunc_end30:
	.size	fail, .Lfunc_end30-fail
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end198
	block   	
	i32.const	$push1=, 0
	i32.load	$push0=, fail_count($pop1)
	br_if   	0, $pop0        # 0: down to label4
# %bb.1:                                # %if.end202
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB31_2:                               # %if.then201
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end31:
	.size	main, .Lfunc_end31-main
                                        # -- End function
	.hidden	fail_count              # @fail_count
	.type	fail_count,@object
	.section	.bss.fail_count,"aw",@nobits
	.globl	fail_count
	.p2align	2
fail_count:
	.int32	0                       # 0x0
	.size	fail_count, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Test failed: %s\n"
	.size	.L.str, 17


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	fprintf, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
	.import_global	stderr
	.size	stderr, 4
