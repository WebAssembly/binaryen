	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960416-1.c"
	.section	.text.f_le,"ax",@progbits
	.hidden	f_le
	.globl	f_le
	.type	f_le,@function
f_le:                                   # @f_le
	.param  	i32, i32
	.result 	i32
	.local  	i64, i64, i32, i32, i64, i64, i64
# BB#0:                                 # %entry
	i64.load	$push51=, 0($1)
	tee_local	$push50=, $2=, $pop51
	i64.const	$push12=, 4294967295
	i64.and 	$push13=, $pop50, $pop12
	i32.load	$push49=, 0($0)
	tee_local	$push48=, $1=, $pop49
	i64.extend_u/i32	$push14=, $pop48
	i64.mul 	$push47=, $pop13, $pop14
	tee_local	$push46=, $6=, $pop47
	i64.const	$push0=, 32
	i64.shr_u	$push45=, $pop46, $pop0
	tee_local	$push44=, $8=, $pop45
	i64.const	$push43=, 32
	i64.shr_u	$push42=, $2, $pop43
	tee_local	$push41=, $3=, $pop42
	i32.load	$push40=, 4($0)
	tee_local	$push39=, $5=, $pop40
	i64.extend_u/i32	$push15=, $pop39
	i64.mul 	$push38=, $pop41, $pop15
	tee_local	$push37=, $7=, $pop38
	i64.add 	$push21=, $pop44, $pop37
	i64.const	$push36=, 32
	i64.shr_u	$push22=, $7, $pop36
	i64.add 	$push23=, $pop21, $pop22
	i32.const	$push2=, 0
	i32.wrap/i64	$push35=, $2
	tee_local	$push34=, $4=, $pop35
	i32.wrap/i64	$push1=, $3
	i32.sub 	$push33=, $pop34, $pop1
	tee_local	$push32=, $0=, $pop33
	i32.sub 	$push3=, $pop2, $pop32
	i32.gt_u	$push31=, $0, $4
	tee_local	$push30=, $4=, $pop31
	i32.select	$push4=, $pop3, $0, $pop30
	i64.extend_u/i32	$push5=, $pop4
	i32.sub 	$push6=, $5, $1
	i64.extend_u/i32	$push7=, $pop6
	i64.mul 	$push8=, $pop5, $pop7
	i64.const	$push10=, -1
	i64.const	$push9=, 0
	i64.select	$push11=, $pop10, $pop9, $4
	i64.xor 	$push29=, $pop8, $pop11
	tee_local	$push28=, $2=, $pop29
	i64.const	$push27=, 32
	i64.shr_u	$push20=, $pop28, $pop27
	i64.add 	$push24=, $pop23, $pop20
	i32.wrap/i64	$push25=, $pop24
	i64.add 	$push16=, $7, $6
	i64.add 	$push17=, $pop16, $8
	i64.add 	$push18=, $pop17, $2
	i32.wrap/i64	$push19=, $pop18
	i32.add 	$push26=, $pop25, $pop19
                                        # fallthrough-return: $pop26
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
	.local  	i32, i64, i64, i64, i64, i64
# BB#0:                                 # %entry
	i32.load	$push59=, 4($1)
	tee_local	$push58=, $2=, $pop59
	i64.extend_u/i32	$push13=, $pop58
	i64.load	$push57=, 0($0)
	tee_local	$push56=, $3=, $pop57
	i64.const	$push4=, 32
	i64.shr_u	$push55=, $pop56, $pop4
	tee_local	$push54=, $4=, $pop55
	i64.mul 	$push53=, $pop13, $pop54
	tee_local	$push52=, $5=, $pop53
	i64.const	$push6=, 4294967295
	i64.and 	$push51=, $pop52, $pop6
	tee_local	$push50=, $6=, $pop51
	i32.load	$push49=, 0($1)
	tee_local	$push48=, $1=, $pop49
	i64.extend_u/i32	$push17=, $pop48
	i64.const	$push47=, 4294967295
	i64.and 	$push16=, $3, $pop47
	i64.mul 	$push46=, $pop17, $pop16
	tee_local	$push45=, $7=, $pop46
	i64.add 	$push24=, $pop50, $pop45
	i64.const	$push44=, 4294967295
	i64.and 	$push25=, $7, $pop44
	i64.add 	$push26=, $pop24, $pop25
	i32.const	$push0=, 0
	i32.sub 	$push43=, $2, $1
	tee_local	$push42=, $1=, $pop43
	i32.sub 	$push1=, $pop0, $pop42
	i32.gt_u	$push41=, $1, $2
	tee_local	$push40=, $2=, $pop41
	i32.select	$push2=, $pop1, $1, $pop40
	i64.extend_u/i32	$push3=, $pop2
	i64.sub 	$push5=, $3, $4
	i64.const	$push39=, 4294967295
	i64.and 	$push7=, $pop5, $pop39
	i64.mul 	$push8=, $pop3, $pop7
	i64.const	$push10=, -1
	i64.const	$push9=, 0
	i64.select	$push11=, $pop10, $pop9, $2
	i64.xor 	$push38=, $pop8, $pop11
	tee_local	$push37=, $3=, $pop38
	i64.const	$push36=, 4294967295
	i64.and 	$push23=, $pop37, $pop36
	i64.add 	$push27=, $pop26, $pop23
	i64.const	$push35=, 32
	i64.shr_u	$push28=, $pop27, $pop35
	i32.wrap/i64	$push29=, $pop28
	i64.const	$push34=, 32
	i64.shr_u	$push14=, $5, $pop34
	i64.add 	$push15=, $pop14, $6
	i64.const	$push33=, 32
	i64.shr_u	$push18=, $7, $pop33
	i64.add 	$push19=, $pop15, $pop18
	i64.const	$push32=, 32
	i64.shr_u	$push12=, $3, $pop32
	i64.add 	$push20=, $pop19, $pop12
	i64.const	$push31=, 32
	i64.shr_u	$push21=, $pop20, $pop31
	i32.wrap/i64	$push22=, $pop21
	i32.add 	$push30=, $pop29, $pop22
                                        # fallthrough-return: $pop30
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
	.functype	exit, void, i32
