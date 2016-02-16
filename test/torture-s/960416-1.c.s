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
	i64.load	$push51=, 0($1)
	tee_local	$push50=, $8=, $pop51
	i64.const	$push10=, 4294967295
	i64.and 	$push11=, $pop50, $pop10
	i32.load	$push49=, 0($0):p2align=3
	tee_local	$push48=, $1=, $pop49
	i64.extend_u/i32	$push9=, $pop48
	i64.mul 	$push47=, $pop11, $pop9
	tee_local	$push46=, $7=, $pop47
	i64.const	$push1=, 32
	i64.shr_u	$push45=, $pop46, $pop1
	tee_local	$push44=, $6=, $pop45
	i64.const	$push43=, 32
	i64.shr_u	$push42=, $8, $pop43
	tee_local	$push41=, $5=, $pop42
	i32.load	$push40=, 4($0)
	tee_local	$push39=, $4=, $pop40
	i64.extend_u/i32	$push12=, $pop39
	i64.mul 	$push38=, $pop41, $pop12
	tee_local	$push37=, $3=, $pop38
	i64.add 	$push18=, $pop44, $pop37
	i64.const	$push36=, 32
	i64.shr_u	$push13=, $3, $pop36
	i64.add 	$push19=, $pop18, $pop13
	i32.const	$push3=, 0
	i32.wrap/i64	$push35=, $8
	tee_local	$push34=, $2=, $pop35
	i32.wrap/i64	$push2=, $5
	i32.sub 	$push33=, $pop34, $pop2
	tee_local	$push32=, $0=, $pop33
	i32.sub 	$push4=, $pop3, $pop32
	i32.gt_u	$push31=, $0, $2
	tee_local	$push30=, $2=, $pop31
	i32.select	$push5=, $pop4, $0, $pop30
	i64.extend_u/i32	$push15=, $pop5
	i32.sub 	$push0=, $4, $1
	i64.extend_u/i32	$push14=, $pop0
	i64.mul 	$push16=, $pop15, $pop14
	i64.const	$push7=, -1
	i64.const	$push6=, 0
	i64.select	$push8=, $pop7, $pop6, $2
	i64.xor 	$push29=, $pop16, $pop8
	tee_local	$push28=, $8=, $pop29
	i64.const	$push27=, 32
	i64.shr_u	$push17=, $pop28, $pop27
	i64.add 	$push20=, $pop19, $pop17
	i32.wrap/i64	$push21=, $pop20
	i64.add 	$push22=, $3, $7
	i64.add 	$push23=, $pop22, $6
	i64.add 	$push24=, $pop23, $8
	i32.wrap/i64	$push25=, $pop24
	i32.add 	$push26=, $pop21, $pop25
	return  	$pop26
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
	i32.load	$push59=, 4($1)
	tee_local	$push58=, $7=, $pop59
	i64.extend_u/i32	$push8=, $pop58
	i64.load	$push57=, 0($0)
	tee_local	$push56=, $6=, $pop57
	i64.const	$push0=, 32
	i64.shr_u	$push55=, $pop56, $pop0
	tee_local	$push54=, $5=, $pop55
	i64.mul 	$push53=, $pop8, $pop54
	tee_local	$push52=, $4=, $pop53
	i64.const	$push10=, 4294967295
	i64.and 	$push51=, $pop52, $pop10
	tee_local	$push50=, $3=, $pop51
	i32.load	$push49=, 0($1):p2align=3
	tee_local	$push48=, $1=, $pop49
	i64.extend_u/i32	$push12=, $pop48
	i64.const	$push47=, 4294967295
	i64.and 	$push11=, $6, $pop47
	i64.mul 	$push46=, $pop12, $pop11
	tee_local	$push45=, $2=, $pop46
	i64.add 	$push20=, $pop50, $pop45
	i64.const	$push44=, 4294967295
	i64.and 	$push18=, $2, $pop44
	i64.add 	$push21=, $pop20, $pop18
	i32.const	$push2=, 0
	i32.sub 	$push43=, $7, $1
	tee_local	$push42=, $1=, $pop43
	i32.sub 	$push3=, $pop2, $pop42
	i32.gt_u	$push41=, $1, $7
	tee_local	$push40=, $7=, $pop41
	i32.select	$push4=, $pop3, $1, $pop40
	i64.extend_u/i32	$push15=, $pop4
	i64.sub 	$push1=, $6, $5
	i64.const	$push39=, 4294967295
	i64.and 	$push14=, $pop1, $pop39
	i64.mul 	$push16=, $pop15, $pop14
	i64.const	$push6=, -1
	i64.const	$push5=, 0
	i64.select	$push7=, $pop6, $pop5, $7
	i64.xor 	$push38=, $pop16, $pop7
	tee_local	$push37=, $6=, $pop38
	i64.const	$push36=, 4294967295
	i64.and 	$push19=, $pop37, $pop36
	i64.add 	$push22=, $pop21, $pop19
	i64.const	$push35=, 32
	i64.shr_u	$push23=, $pop22, $pop35
	i32.wrap/i64	$push24=, $pop23
	i64.const	$push34=, 32
	i64.shr_u	$push9=, $4, $pop34
	i64.add 	$push25=, $pop9, $3
	i64.const	$push33=, 32
	i64.shr_u	$push13=, $2, $pop33
	i64.add 	$push26=, $pop25, $pop13
	i64.const	$push32=, 32
	i64.shr_u	$push17=, $6, $pop32
	i64.add 	$push27=, $pop26, $pop17
	i64.const	$push31=, 32
	i64.shr_u	$push28=, $pop27, $pop31
	i32.wrap/i64	$push29=, $pop28
	i32.add 	$push30=, $pop24, $pop29
	return  	$pop30
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
