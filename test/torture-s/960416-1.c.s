	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960416-1.c"
	.section	.text.f_le,"ax",@progbits
	.hidden	f_le
	.globl	f_le
	.type	f_le,@function
f_le:                                   # @f_le
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i64, i64, i64, i64
# BB#0:                                 # %entry
	i32.load	$push47=, 0($1)
	tee_local	$push46=, $2=, $pop47
	i64.extend_u/i32	$push11=, $pop46
	i32.load	$push45=, 0($0)
	tee_local	$push44=, $3=, $pop45
	i64.extend_u/i32	$push10=, $pop44
	i64.mul 	$push43=, $pop11, $pop10
	tee_local	$push42=, $6=, $pop43
	i64.const	$push15=, 32
	i64.shr_u	$push41=, $pop42, $pop15
	tee_local	$push40=, $8=, $pop41
	i32.load	$push39=, 4($1)
	tee_local	$push38=, $1=, $pop39
	i64.extend_u/i32	$push13=, $pop38
	i32.load	$push37=, 4($0)
	tee_local	$push36=, $4=, $pop37
	i64.extend_u/i32	$push12=, $pop36
	i64.mul 	$push35=, $pop13, $pop12
	tee_local	$push34=, $7=, $pop35
	i64.add 	$push20=, $pop40, $pop34
	i64.const	$push33=, 32
	i64.shr_u	$push21=, $7, $pop33
	i64.add 	$push22=, $pop20, $pop21
	i32.const	$push0=, 0
	i32.sub 	$push32=, $2, $1
	tee_local	$push31=, $0=, $pop32
	i32.sub 	$push1=, $pop0, $pop31
	i32.gt_u	$push30=, $0, $2
	tee_local	$push29=, $1=, $pop30
	i32.select	$push2=, $pop1, $0, $pop29
	i64.extend_u/i32	$push3=, $pop2
	i32.sub 	$push4=, $4, $3
	i64.extend_u/i32	$push5=, $pop4
	i64.mul 	$push6=, $pop3, $pop5
	i64.const	$push8=, -1
	i64.const	$push7=, 0
	i64.select	$push9=, $pop8, $pop7, $1
	i64.xor 	$push28=, $pop6, $pop9
	tee_local	$push27=, $5=, $pop28
	i64.const	$push26=, 32
	i64.shr_u	$push19=, $pop27, $pop26
	i64.add 	$push23=, $pop22, $pop19
	i32.wrap/i64	$push24=, $pop23
	i64.add 	$push14=, $7, $6
	i64.add 	$push16=, $pop14, $8
	i64.add 	$push17=, $pop16, $5
	i32.wrap/i64	$push18=, $pop17
	i32.add 	$push25=, $pop24, $pop18
                                        # fallthrough-return: $pop25
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
	.local  	i32, i32, i32, i64, i64, i64, i64
# BB#0:                                 # %entry
	i32.load	$push57=, 4($1)
	tee_local	$push56=, $2=, $pop57
	i64.extend_u/i32	$push13=, $pop56
	i32.load	$push55=, 4($0)
	tee_local	$push54=, $3=, $pop55
	i64.extend_u/i32	$push12=, $pop54
	i64.mul 	$push53=, $pop13, $pop12
	tee_local	$push52=, $6=, $pop53
	i64.const	$push14=, 4294967295
	i64.and 	$push51=, $pop52, $pop14
	tee_local	$push50=, $7=, $pop51
	i32.load	$push49=, 0($1)
	tee_local	$push48=, $1=, $pop49
	i64.extend_u/i32	$push18=, $pop48
	i32.load	$push47=, 0($0)
	tee_local	$push46=, $4=, $pop47
	i64.extend_u/i32	$push17=, $pop46
	i64.mul 	$push45=, $pop18, $pop17
	tee_local	$push44=, $8=, $pop45
	i64.add 	$push25=, $pop50, $pop44
	i64.const	$push43=, 4294967295
	i64.and 	$push26=, $8, $pop43
	i64.add 	$push27=, $pop25, $pop26
	i32.const	$push0=, 0
	i32.sub 	$push42=, $2, $1
	tee_local	$push41=, $0=, $pop42
	i32.sub 	$push1=, $pop0, $pop41
	i32.gt_u	$push40=, $0, $2
	tee_local	$push39=, $1=, $pop40
	i32.select	$push2=, $pop1, $0, $pop39
	i64.extend_u/i32	$push3=, $pop2
	i32.sub 	$push4=, $4, $3
	i64.extend_u/i32	$push5=, $pop4
	i64.mul 	$push6=, $pop3, $pop5
	i64.const	$push8=, -1
	i64.const	$push7=, 0
	i64.select	$push9=, $pop8, $pop7, $1
	i64.xor 	$push38=, $pop6, $pop9
	tee_local	$push37=, $5=, $pop38
	i64.const	$push36=, 4294967295
	i64.and 	$push24=, $pop37, $pop36
	i64.add 	$push28=, $pop27, $pop24
	i64.const	$push10=, 32
	i64.shr_u	$push29=, $pop28, $pop10
	i32.wrap/i64	$push30=, $pop29
	i64.const	$push35=, 32
	i64.shr_u	$push15=, $6, $pop35
	i64.add 	$push16=, $pop15, $7
	i64.const	$push34=, 32
	i64.shr_u	$push19=, $8, $pop34
	i64.add 	$push20=, $pop16, $pop19
	i64.const	$push33=, 32
	i64.shr_u	$push11=, $5, $pop33
	i64.add 	$push21=, $pop20, $pop11
	i64.const	$push32=, 32
	i64.shr_u	$push22=, $pop21, $pop32
	i32.wrap/i64	$push23=, $pop22
	i32.add 	$push31=, $pop30, $pop23
                                        # fallthrough-return: $pop31
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
