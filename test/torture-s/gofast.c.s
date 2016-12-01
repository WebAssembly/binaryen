	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/gofast.c"
	.section	.text.fp_add,"ax",@progbits
	.hidden	fp_add
	.globl	fp_add
	.type	fp_add,@function
fp_add:                                 # @fp_add
	.param  	f32, f32
	.result 	f32
# BB#0:                                 # %entry
	f32.add 	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	fp_add, .Lfunc_end0-fp_add

	.section	.text.fp_sub,"ax",@progbits
	.hidden	fp_sub
	.globl	fp_sub
	.type	fp_sub,@function
fp_sub:                                 # @fp_sub
	.param  	f32, f32
	.result 	f32
# BB#0:                                 # %entry
	f32.sub 	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	fp_sub, .Lfunc_end1-fp_sub

	.section	.text.fp_mul,"ax",@progbits
	.hidden	fp_mul
	.globl	fp_mul
	.type	fp_mul,@function
fp_mul:                                 # @fp_mul
	.param  	f32, f32
	.result 	f32
# BB#0:                                 # %entry
	f32.mul 	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	fp_mul, .Lfunc_end2-fp_mul

	.section	.text.fp_div,"ax",@progbits
	.hidden	fp_div
	.globl	fp_div
	.type	fp_div,@function
fp_div:                                 # @fp_div
	.param  	f32, f32
	.result 	f32
# BB#0:                                 # %entry
	f32.div 	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	fp_div, .Lfunc_end3-fp_div

	.section	.text.fp_neg,"ax",@progbits
	.hidden	fp_neg
	.globl	fp_neg
	.type	fp_neg,@function
fp_neg:                                 # @fp_neg
	.param  	f32
	.result 	f32
# BB#0:                                 # %entry
	f32.neg 	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	fp_neg, .Lfunc_end4-fp_neg

	.section	.text.dp_add,"ax",@progbits
	.hidden	dp_add
	.globl	dp_add
	.type	dp_add,@function
dp_add:                                 # @dp_add
	.param  	f64, f64
	.result 	f64
# BB#0:                                 # %entry
	f64.add 	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end5:
	.size	dp_add, .Lfunc_end5-dp_add

	.section	.text.dp_sub,"ax",@progbits
	.hidden	dp_sub
	.globl	dp_sub
	.type	dp_sub,@function
dp_sub:                                 # @dp_sub
	.param  	f64, f64
	.result 	f64
# BB#0:                                 # %entry
	f64.sub 	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end6:
	.size	dp_sub, .Lfunc_end6-dp_sub

	.section	.text.dp_mul,"ax",@progbits
	.hidden	dp_mul
	.globl	dp_mul
	.type	dp_mul,@function
dp_mul:                                 # @dp_mul
	.param  	f64, f64
	.result 	f64
# BB#0:                                 # %entry
	f64.mul 	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end7:
	.size	dp_mul, .Lfunc_end7-dp_mul

	.section	.text.dp_div,"ax",@progbits
	.hidden	dp_div
	.globl	dp_div
	.type	dp_div,@function
dp_div:                                 # @dp_div
	.param  	f64, f64
	.result 	f64
# BB#0:                                 # %entry
	f64.div 	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end8:
	.size	dp_div, .Lfunc_end8-dp_div

	.section	.text.dp_neg,"ax",@progbits
	.hidden	dp_neg
	.globl	dp_neg
	.type	dp_neg,@function
dp_neg:                                 # @dp_neg
	.param  	f64
	.result 	f64
# BB#0:                                 # %entry
	f64.neg 	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end9:
	.size	dp_neg, .Lfunc_end9-dp_neg

	.section	.text.fp_to_dp,"ax",@progbits
	.hidden	fp_to_dp
	.globl	fp_to_dp
	.type	fp_to_dp,@function
fp_to_dp:                               # @fp_to_dp
	.param  	f32
	.result 	f64
# BB#0:                                 # %entry
	f64.promote/f32	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end10:
	.size	fp_to_dp, .Lfunc_end10-fp_to_dp

	.section	.text.dp_to_fp,"ax",@progbits
	.hidden	dp_to_fp
	.globl	dp_to_fp
	.type	dp_to_fp,@function
dp_to_fp:                               # @dp_to_fp
	.param  	f64
	.result 	f32
# BB#0:                                 # %entry
	f32.demote/f64	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end11:
	.size	dp_to_fp, .Lfunc_end11-dp_to_fp

	.section	.text.eqsf2,"ax",@progbits
	.hidden	eqsf2
	.globl	eqsf2
	.type	eqsf2,@function
eqsf2:                                  # @eqsf2
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.eq  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end12:
	.size	eqsf2, .Lfunc_end12-eqsf2

	.section	.text.nesf2,"ax",@progbits
	.hidden	nesf2
	.globl	nesf2
	.type	nesf2,@function
nesf2:                                  # @nesf2
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.ne  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end13:
	.size	nesf2, .Lfunc_end13-nesf2

	.section	.text.gtsf2,"ax",@progbits
	.hidden	gtsf2
	.globl	gtsf2
	.type	gtsf2,@function
gtsf2:                                  # @gtsf2
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.gt  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end14:
	.size	gtsf2, .Lfunc_end14-gtsf2

	.section	.text.gesf2,"ax",@progbits
	.hidden	gesf2
	.globl	gesf2
	.type	gesf2,@function
gesf2:                                  # @gesf2
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.ge  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end15:
	.size	gesf2, .Lfunc_end15-gesf2

	.section	.text.ltsf2,"ax",@progbits
	.hidden	ltsf2
	.globl	ltsf2
	.type	ltsf2,@function
ltsf2:                                  # @ltsf2
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.lt  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end16:
	.size	ltsf2, .Lfunc_end16-ltsf2

	.section	.text.lesf2,"ax",@progbits
	.hidden	lesf2
	.globl	lesf2
	.type	lesf2,@function
lesf2:                                  # @lesf2
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.le  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end17:
	.size	lesf2, .Lfunc_end17-lesf2

	.section	.text.eqdf2,"ax",@progbits
	.hidden	eqdf2
	.globl	eqdf2
	.type	eqdf2,@function
eqdf2:                                  # @eqdf2
	.param  	f64, f64
	.result 	i32
# BB#0:                                 # %entry
	f64.eq  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end18:
	.size	eqdf2, .Lfunc_end18-eqdf2

	.section	.text.nedf2,"ax",@progbits
	.hidden	nedf2
	.globl	nedf2
	.type	nedf2,@function
nedf2:                                  # @nedf2
	.param  	f64, f64
	.result 	i32
# BB#0:                                 # %entry
	f64.ne  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end19:
	.size	nedf2, .Lfunc_end19-nedf2

	.section	.text.gtdf2,"ax",@progbits
	.hidden	gtdf2
	.globl	gtdf2
	.type	gtdf2,@function
gtdf2:                                  # @gtdf2
	.param  	f64, f64
	.result 	i32
# BB#0:                                 # %entry
	f64.gt  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end20:
	.size	gtdf2, .Lfunc_end20-gtdf2

	.section	.text.gedf2,"ax",@progbits
	.hidden	gedf2
	.globl	gedf2
	.type	gedf2,@function
gedf2:                                  # @gedf2
	.param  	f64, f64
	.result 	i32
# BB#0:                                 # %entry
	f64.ge  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end21:
	.size	gedf2, .Lfunc_end21-gedf2

	.section	.text.ltdf2,"ax",@progbits
	.hidden	ltdf2
	.globl	ltdf2
	.type	ltdf2,@function
ltdf2:                                  # @ltdf2
	.param  	f64, f64
	.result 	i32
# BB#0:                                 # %entry
	f64.lt  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end22:
	.size	ltdf2, .Lfunc_end22-ltdf2

	.section	.text.ledf2,"ax",@progbits
	.hidden	ledf2
	.globl	ledf2
	.type	ledf2,@function
ledf2:                                  # @ledf2
	.param  	f64, f64
	.result 	i32
# BB#0:                                 # %entry
	f64.le  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end23:
	.size	ledf2, .Lfunc_end23-ledf2

	.section	.text.floatsisf,"ax",@progbits
	.hidden	floatsisf
	.globl	floatsisf
	.type	floatsisf,@function
floatsisf:                              # @floatsisf
	.param  	i32
	.result 	f32
# BB#0:                                 # %entry
	f32.convert_s/i32	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end24:
	.size	floatsisf, .Lfunc_end24-floatsisf

	.section	.text.floatsidf,"ax",@progbits
	.hidden	floatsidf
	.globl	floatsidf
	.type	floatsidf,@function
floatsidf:                              # @floatsidf
	.param  	i32
	.result 	f64
# BB#0:                                 # %entry
	f64.convert_s/i32	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end25:
	.size	floatsidf, .Lfunc_end25-floatsidf

	.section	.text.fixsfsi,"ax",@progbits
	.hidden	fixsfsi
	.globl	fixsfsi
	.type	fixsfsi,@function
fixsfsi:                                # @fixsfsi
	.param  	f32
	.result 	i32
# BB#0:                                 # %entry
	i32.trunc_s/f32	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end26:
	.size	fixsfsi, .Lfunc_end26-fixsfsi

	.section	.text.fixdfsi,"ax",@progbits
	.hidden	fixdfsi
	.globl	fixdfsi
	.type	fixdfsi,@function
fixdfsi:                                # @fixdfsi
	.param  	f64
	.result 	i32
# BB#0:                                 # %entry
	i32.trunc_s/f64	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end27:
	.size	fixdfsi, .Lfunc_end27-fixdfsi

	.section	.text.fixunssfsi,"ax",@progbits
	.hidden	fixunssfsi
	.globl	fixunssfsi
	.type	fixunssfsi,@function
fixunssfsi:                             # @fixunssfsi
	.param  	f32
	.result 	i32
# BB#0:                                 # %entry
	i32.trunc_u/f32	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end28:
	.size	fixunssfsi, .Lfunc_end28-fixunssfsi

	.section	.text.fixunsdfsi,"ax",@progbits
	.hidden	fixunsdfsi
	.globl	fixunsdfsi
	.type	fixunsdfsi,@function
fixunsdfsi:                             # @fixunsdfsi
	.param  	f64
	.result 	i32
# BB#0:                                 # %entry
	i32.trunc_u/f64	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end29:
	.size	fixunsdfsi, .Lfunc_end29-fixunsdfsi

	.section	.text.fail,"ax",@progbits
	.hidden	fail
	.globl	fail
	.type	fail,@function
fail:                                   # @fail
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push16=, $pop7, $pop8
	tee_local	$push15=, $1=, $pop16
	i32.store	__stack_pointer($pop9), $pop15
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
	copy_local	$push17=, $1
                                        # fallthrough-return: $pop17
	.endfunc
.Lfunc_end30:
	.size	fail, .Lfunc_end30-fail

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end11
	block   	
	i32.const	$push1=, 0
	i32.load	$push0=, fail_count($pop1)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end202
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB31_2:                               # %if.then201
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end31:
	.size	main, .Lfunc_end31-main

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


	.ident	"clang version 4.0.0 "
	.functype	fprintf, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
	.import_global	stderr
