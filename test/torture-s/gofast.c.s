	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/gofast.c"
	.globl	fp_add
	.type	fp_add,@function
fp_add:                                 # @fp_add
	.param  	f32, f32
	.result 	f32
# BB#0:                                 # %entry
	f32.add 	$push0=, $0, $1
	return  	$pop0
func_end0:
	.size	fp_add, func_end0-fp_add

	.globl	fp_sub
	.type	fp_sub,@function
fp_sub:                                 # @fp_sub
	.param  	f32, f32
	.result 	f32
# BB#0:                                 # %entry
	f32.sub 	$push0=, $0, $1
	return  	$pop0
func_end1:
	.size	fp_sub, func_end1-fp_sub

	.globl	fp_mul
	.type	fp_mul,@function
fp_mul:                                 # @fp_mul
	.param  	f32, f32
	.result 	f32
# BB#0:                                 # %entry
	f32.mul 	$push0=, $0, $1
	return  	$pop0
func_end2:
	.size	fp_mul, func_end2-fp_mul

	.globl	fp_div
	.type	fp_div,@function
fp_div:                                 # @fp_div
	.param  	f32, f32
	.result 	f32
# BB#0:                                 # %entry
	f32.div 	$push0=, $0, $1
	return  	$pop0
func_end3:
	.size	fp_div, func_end3-fp_div

	.globl	fp_neg
	.type	fp_neg,@function
fp_neg:                                 # @fp_neg
	.param  	f32
	.result 	f32
# BB#0:                                 # %entry
	f32.neg 	$push0=, $0
	return  	$pop0
func_end4:
	.size	fp_neg, func_end4-fp_neg

	.globl	dp_add
	.type	dp_add,@function
dp_add:                                 # @dp_add
	.param  	f64, f64
	.result 	f64
# BB#0:                                 # %entry
	f64.add 	$push0=, $0, $1
	return  	$pop0
func_end5:
	.size	dp_add, func_end5-dp_add

	.globl	dp_sub
	.type	dp_sub,@function
dp_sub:                                 # @dp_sub
	.param  	f64, f64
	.result 	f64
# BB#0:                                 # %entry
	f64.sub 	$push0=, $0, $1
	return  	$pop0
func_end6:
	.size	dp_sub, func_end6-dp_sub

	.globl	dp_mul
	.type	dp_mul,@function
dp_mul:                                 # @dp_mul
	.param  	f64, f64
	.result 	f64
# BB#0:                                 # %entry
	f64.mul 	$push0=, $0, $1
	return  	$pop0
func_end7:
	.size	dp_mul, func_end7-dp_mul

	.globl	dp_div
	.type	dp_div,@function
dp_div:                                 # @dp_div
	.param  	f64, f64
	.result 	f64
# BB#0:                                 # %entry
	f64.div 	$push0=, $0, $1
	return  	$pop0
func_end8:
	.size	dp_div, func_end8-dp_div

	.globl	dp_neg
	.type	dp_neg,@function
dp_neg:                                 # @dp_neg
	.param  	f64
	.result 	f64
# BB#0:                                 # %entry
	f64.neg 	$push0=, $0
	return  	$pop0
func_end9:
	.size	dp_neg, func_end9-dp_neg

	.globl	fp_to_dp
	.type	fp_to_dp,@function
fp_to_dp:                               # @fp_to_dp
	.param  	f32
	.result 	f64
# BB#0:                                 # %entry
	f64.promote/f32	$push0=, $0
	return  	$pop0
func_end10:
	.size	fp_to_dp, func_end10-fp_to_dp

	.globl	dp_to_fp
	.type	dp_to_fp,@function
dp_to_fp:                               # @dp_to_fp
	.param  	f64
	.result 	f32
# BB#0:                                 # %entry
	f32.demote/f64	$push0=, $0
	return  	$pop0
func_end11:
	.size	dp_to_fp, func_end11-dp_to_fp

	.globl	eqsf2
	.type	eqsf2,@function
eqsf2:                                  # @eqsf2
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.eq  	$push0=, $0, $1
	return  	$pop0
func_end12:
	.size	eqsf2, func_end12-eqsf2

	.globl	nesf2
	.type	nesf2,@function
nesf2:                                  # @nesf2
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.ne  	$push0=, $0, $1
	return  	$pop0
func_end13:
	.size	nesf2, func_end13-nesf2

	.globl	gtsf2
	.type	gtsf2,@function
gtsf2:                                  # @gtsf2
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.gt  	$push0=, $0, $1
	return  	$pop0
func_end14:
	.size	gtsf2, func_end14-gtsf2

	.globl	gesf2
	.type	gesf2,@function
gesf2:                                  # @gesf2
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.ge  	$push0=, $0, $1
	return  	$pop0
func_end15:
	.size	gesf2, func_end15-gesf2

	.globl	ltsf2
	.type	ltsf2,@function
ltsf2:                                  # @ltsf2
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.lt  	$push0=, $0, $1
	return  	$pop0
func_end16:
	.size	ltsf2, func_end16-ltsf2

	.globl	lesf2
	.type	lesf2,@function
lesf2:                                  # @lesf2
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.le  	$push0=, $0, $1
	return  	$pop0
func_end17:
	.size	lesf2, func_end17-lesf2

	.globl	eqdf2
	.type	eqdf2,@function
eqdf2:                                  # @eqdf2
	.param  	f64, f64
	.result 	i32
# BB#0:                                 # %entry
	f64.eq  	$push0=, $0, $1
	return  	$pop0
func_end18:
	.size	eqdf2, func_end18-eqdf2

	.globl	nedf2
	.type	nedf2,@function
nedf2:                                  # @nedf2
	.param  	f64, f64
	.result 	i32
# BB#0:                                 # %entry
	f64.ne  	$push0=, $0, $1
	return  	$pop0
func_end19:
	.size	nedf2, func_end19-nedf2

	.globl	gtdf2
	.type	gtdf2,@function
gtdf2:                                  # @gtdf2
	.param  	f64, f64
	.result 	i32
# BB#0:                                 # %entry
	f64.gt  	$push0=, $0, $1
	return  	$pop0
func_end20:
	.size	gtdf2, func_end20-gtdf2

	.globl	gedf2
	.type	gedf2,@function
gedf2:                                  # @gedf2
	.param  	f64, f64
	.result 	i32
# BB#0:                                 # %entry
	f64.ge  	$push0=, $0, $1
	return  	$pop0
func_end21:
	.size	gedf2, func_end21-gedf2

	.globl	ltdf2
	.type	ltdf2,@function
ltdf2:                                  # @ltdf2
	.param  	f64, f64
	.result 	i32
# BB#0:                                 # %entry
	f64.lt  	$push0=, $0, $1
	return  	$pop0
func_end22:
	.size	ltdf2, func_end22-ltdf2

	.globl	ledf2
	.type	ledf2,@function
ledf2:                                  # @ledf2
	.param  	f64, f64
	.result 	i32
# BB#0:                                 # %entry
	f64.le  	$push0=, $0, $1
	return  	$pop0
func_end23:
	.size	ledf2, func_end23-ledf2

	.globl	floatsisf
	.type	floatsisf,@function
floatsisf:                              # @floatsisf
	.param  	i32
	.result 	f32
# BB#0:                                 # %entry
	f32.convert_s/i32	$push0=, $0
	return  	$pop0
func_end24:
	.size	floatsisf, func_end24-floatsisf

	.globl	floatsidf
	.type	floatsidf,@function
floatsidf:                              # @floatsidf
	.param  	i32
	.result 	f64
# BB#0:                                 # %entry
	f64.convert_s/i32	$push0=, $0
	return  	$pop0
func_end25:
	.size	floatsidf, func_end25-floatsidf

	.globl	fixsfsi
	.type	fixsfsi,@function
fixsfsi:                                # @fixsfsi
	.param  	f32
	.result 	i32
# BB#0:                                 # %entry
	i32.trunc_s/f32	$push0=, $0
	return  	$pop0
func_end26:
	.size	fixsfsi, func_end26-fixsfsi

	.globl	fixdfsi
	.type	fixdfsi,@function
fixdfsi:                                # @fixdfsi
	.param  	f64
	.result 	i32
# BB#0:                                 # %entry
	i32.trunc_s/f64	$push0=, $0
	return  	$pop0
func_end27:
	.size	fixdfsi, func_end27-fixdfsi

	.globl	fixunssfsi
	.type	fixunssfsi,@function
fixunssfsi:                             # @fixunssfsi
	.param  	f32
	.result 	i32
# BB#0:                                 # %entry
	i32.trunc_u/f32	$push0=, $0
	return  	$pop0
func_end28:
	.size	fixunssfsi, func_end28-fixunssfsi

	.globl	fixunsdfsi
	.type	fixunsdfsi,@function
fixunsdfsi:                             # @fixunsdfsi
	.param  	f64
	.result 	i32
# BB#0:                                 # %entry
	i32.trunc_u/f64	$push0=, $0
	return  	$pop0
func_end29:
	.size	fixunsdfsi, func_end29-fixunsdfsi

	.globl	fail
	.type	fail,@function
fail:                                   # @fail
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 16
	i32.sub 	$9=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$9=, 0($8), $9
	i32.const	$1=, 0
	i32.load	$2=, stderr($1)
	i32.load	$push0=, fail_count($1)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, fail_count($1), $pop2
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 4
	i32.sub 	$9=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$9=, 0($4), $9
	i32.store	$discard=, 0($9), $0
	i32.const	$push3=, .str
	i32.call	$discard=, fiprintf, $2, $pop3
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 4
	i32.add 	$9=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$9=, 0($6), $9
	i32.const	$9=, 16
	i32.add 	$9=, $9, $9
	i32.const	$9=, __stack_pointer
	i32.store	$9=, 0($9), $9
	return  	$1
func_end30:
	.size	fail, func_end30-fail

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end11
	i32.const	$0=, 0
	block   	BB31_2
	i32.load	$push0=, fail_count($0)
	br_if   	$pop0, BB31_2
# BB#1:                                 # %if.end202
	call    	exit, $0
	unreachable
BB31_2:                                 # %if.then201
	call    	abort
	unreachable
func_end31:
	.size	main, func_end31-main

	.type	fail_count,@object      # @fail_count
	.bss
	.globl	fail_count
	.align	2
fail_count:
	.int32	0                       # 0x0
	.size	fail_count, 4

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"Test failed: %s\n"
	.size	.str, 17


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
