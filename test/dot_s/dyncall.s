	.text
	.file	"src/work/binaryen/test/dot_s/dyncall.c"
	.section	.text.i,"ax",@progbits
	.hidden	i
	.globl	i
	.type	i,@function
i:                                      # @i
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	i, .Lfunc_end0-i

	.section	.text.jf,"ax",@progbits
	.hidden	jf
	.globl	jf
	.type	jf,@function
jf:                                     # @jf
	.param  	f32
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	jf, .Lfunc_end1-jf

	.section	.text.vd,"ax",@progbits
	.hidden	vd
	.globl	vd
	.type	vd,@function
vd:                                     # @vd
	.param  	f64
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end2:
	.size	vd, .Lfunc_end2-vd

	.section	.text.ffjjdi,"ax",@progbits
	.hidden	ffjjdi
	.globl	ffjjdi
	.type	ffjjdi,@function
ffjjdi:                                 # @ffjjdi
	.param  	f32, i64, i64, f64, i32
	.result 	f32
# BB#0:                                 # %entry
	f32.const	$push0=, 0x0p0
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	ffjjdi, .Lfunc_end3-ffjjdi

	.section	.text.vd2,"ax",@progbits
	.hidden	vd2
	.globl	vd2
	.type	vd2,@function
vd2:                                    # @vd2
	.param  	f64
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end4:
	.size	vd2, .Lfunc_end4-vd2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	#APP
	 i32.const       $discard=, i@FUNCTION
	#NO_APP
	#APP
	 i32.const       $discard=, jf@FUNCTION
	#NO_APP
	#APP
	 i32.const       $discard=, vd@FUNCTION
	#NO_APP
	#APP
	 i32.const       $discard=, ffjjdi@FUNCTION
	#NO_APP
	#APP
	 i32.const       $discard=, vd2@FUNCTION
	#NO_APP
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end5:
	.size	main, .Lfunc_end5-main


	.ident	"clang version 3.9.0 "
