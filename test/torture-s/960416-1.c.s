	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960416-1.c"
	.section	.text.f_le,"ax",@progbits
	.hidden	f_le
	.globl	f_le
	.type	f_le,@function
f_le:                                   # @f_le
	.param  	i32, i32
	.result 	i32
	.local  	i32, i64, i32, i64, i64, i64, i64
# BB#0:                                 # %entry
	i64.load	$push3=, 0($1)
	tee_local	$push51=, $8=, $pop3
	i64.const	$push17=, 4294967295
	i64.and 	$push18=, $pop51, $pop17
	i32.load	$push1=, 0($0):p2align=3
	tee_local	$push50=, $1=, $pop1
	i64.extend_u/i32	$push16=, $pop50
	i64.mul 	$push19=, $pop18, $pop16
	tee_local	$push49=, $7=, $pop19
	i64.const	$push5=, 32
	i64.shr_u	$push20=, $pop49, $pop5
	tee_local	$push48=, $6=, $pop20
	i64.const	$push47=, 32
	i64.shr_u	$push6=, $8, $pop47
	tee_local	$push46=, $5=, $pop6
	i32.load	$push0=, 4($0)
	tee_local	$push45=, $4=, $pop0
	i64.extend_u/i32	$push21=, $pop45
	i64.mul 	$push22=, $pop46, $pop21
	tee_local	$push44=, $3=, $pop22
	i64.add 	$push29=, $pop48, $pop44
	i64.const	$push43=, 32
	i64.shr_u	$push23=, $3, $pop43
	i64.add 	$push30=, $pop29, $pop23
	i32.wrap/i64	$push4=, $8
	tee_local	$push42=, $2=, $pop4
	i32.wrap/i64	$push7=, $5
	i32.sub 	$push8=, $pop42, $pop7
	tee_local	$push41=, $0=, $pop8
	i32.gt_u	$push11=, $pop41, $2
	tee_local	$push40=, $2=, $pop11
	i32.const	$push9=, 0
	i32.sub 	$push10=, $pop9, $0
	i32.select	$push12=, $pop40, $pop10, $0
	i64.extend_u/i32	$push25=, $pop12
	i32.sub 	$push2=, $4, $1
	i64.extend_u/i32	$push24=, $pop2
	i64.mul 	$push26=, $pop25, $pop24
	i64.const	$push14=, -1
	i64.const	$push13=, 0
	i64.select	$push15=, $2, $pop14, $pop13
	i64.xor 	$push27=, $pop26, $pop15
	tee_local	$push39=, $8=, $pop27
	i64.const	$push38=, 32
	i64.shr_u	$push28=, $pop39, $pop38
	i64.add 	$push31=, $pop30, $pop28
	i32.wrap/i64	$push32=, $pop31
	i64.add 	$push33=, $3, $7
	i64.add 	$push34=, $pop33, $6
	i64.add 	$push35=, $pop34, $8
	i32.wrap/i64	$push36=, $pop35
	i32.add 	$push37=, $pop32, $pop36
	return  	$pop37
	.endfunc
.Lfunc_end0:
	.size	f_le, .Lfunc_end0-f_le

	.section	.text.f_be,"ax",@progbits
	.hidden	f_be
	.globl	f_be
	.type	f_be,@function
f_be:                                   # @f_be
	.param  	i32, i32
	.result 	i32
	.local  	i64, i64, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.load	$push4=, 4($1)
	tee_local	$push59=, $7=, $pop4
	i64.extend_u/i32	$push14=, $pop59
	i64.load	$push0=, 0($0)
	tee_local	$push58=, $6=, $pop0
	i64.const	$push1=, 32
	i64.shr_u	$push2=, $pop58, $pop1
	tee_local	$push57=, $5=, $pop2
	i64.mul 	$push15=, $pop14, $pop57
	tee_local	$push56=, $4=, $pop15
	i64.const	$push17=, 4294967295
	i64.and 	$push28=, $pop56, $pop17
	tee_local	$push55=, $3=, $pop28
	i32.load	$push5=, 0($1):p2align=3
	tee_local	$push54=, $1=, $pop5
	i64.extend_u/i32	$push19=, $pop54
	i64.const	$push53=, 4294967295
	i64.and 	$push18=, $6, $pop53
	i64.mul 	$push20=, $pop19, $pop18
	tee_local	$push52=, $2=, $pop20
	i64.add 	$push30=, $pop55, $pop52
	i64.const	$push51=, 4294967295
	i64.and 	$push27=, $2, $pop51
	i64.add 	$push31=, $pop30, $pop27
	i32.sub 	$push6=, $7, $1
	tee_local	$push50=, $1=, $pop6
	i32.gt_u	$push9=, $pop50, $7
	tee_local	$push49=, $7=, $pop9
	i32.const	$push7=, 0
	i32.sub 	$push8=, $pop7, $1
	i32.select	$push10=, $pop49, $pop8, $1
	i64.extend_u/i32	$push23=, $pop10
	i64.sub 	$push3=, $6, $5
	i64.const	$push48=, 4294967295
	i64.and 	$push22=, $pop3, $pop48
	i64.mul 	$push24=, $pop23, $pop22
	i64.const	$push12=, -1
	i64.const	$push11=, 0
	i64.select	$push13=, $7, $pop12, $pop11
	i64.xor 	$push25=, $pop24, $pop13
	tee_local	$push47=, $6=, $pop25
	i64.const	$push46=, 4294967295
	i64.and 	$push29=, $pop47, $pop46
	i64.add 	$push32=, $pop31, $pop29
	i64.const	$push45=, 32
	i64.shr_u	$push33=, $pop32, $pop45
	i32.wrap/i64	$push34=, $pop33
	i64.const	$push44=, 32
	i64.shr_u	$push16=, $4, $pop44
	i64.add 	$push35=, $pop16, $3
	i64.const	$push43=, 32
	i64.shr_u	$push21=, $2, $pop43
	i64.add 	$push36=, $pop35, $pop21
	i64.const	$push42=, 32
	i64.shr_u	$push26=, $6, $pop42
	i64.add 	$push37=, $pop36, $pop26
	i64.const	$push41=, 32
	i64.shr_u	$push38=, $pop37, $pop41
	i32.wrap/i64	$push39=, $pop38
	i32.add 	$push40=, $pop34, $pop39
	return  	$pop40
	.endfunc
.Lfunc_end1:
	.size	f_be, .Lfunc_end1-f_be

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end12
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
