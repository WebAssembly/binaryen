	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr60960.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 3
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 255
	i32.and 	$push3=, $4, $pop2
	i32.const	$push4=, 0
	i32.div_u	$push5=, $pop3, $pop4
	i32.store8	0($pop1), $pop5
	i32.const	$push6=, 2
	i32.add 	$push7=, $0, $pop6
	i32.const	$push21=, 255
	i32.and 	$push8=, $3, $pop21
	i32.const	$push20=, 0
	i32.div_u	$push9=, $pop8, $pop20
	i32.store8	0($pop7), $pop9
	i32.const	$push10=, 1
	i32.add 	$push11=, $0, $pop10
	i32.const	$push19=, 255
	i32.and 	$push12=, $2, $pop19
	i32.const	$push18=, 0
	i32.div_u	$push13=, $pop12, $pop18
	i32.store8	0($pop11), $pop13
	i32.const	$push14=, 254
	i32.and 	$push15=, $1, $pop14
	i32.const	$push17=, 1
	i32.shr_u	$push16=, $pop15, $pop17
	i32.store8	0($0), $pop16
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 3
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 254
	i32.and 	$push3=, $4, $pop2
	i32.const	$push4=, 1
	i32.shr_u	$push5=, $pop3, $pop4
	i32.store8	0($pop1), $pop5
	i32.const	$push6=, 2
	i32.add 	$push7=, $0, $pop6
	i32.const	$push21=, 254
	i32.and 	$push8=, $3, $pop21
	i32.const	$push20=, 1
	i32.shr_u	$push9=, $pop8, $pop20
	i32.store8	0($pop7), $pop9
	i32.const	$push19=, 1
	i32.add 	$push10=, $0, $pop19
	i32.const	$push18=, 254
	i32.and 	$push11=, $2, $pop18
	i32.const	$push17=, 1
	i32.shr_u	$push12=, $pop11, $pop17
	i32.store8	0($pop10), $pop12
	i32.const	$push16=, 254
	i32.and 	$push13=, $1, $pop16
	i32.const	$push15=, 1
	i32.shr_u	$push14=, $pop13, $pop15
	i32.store8	0($0), $pop14
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push4=, 3
	i32.add 	$push5=, $0, $pop4
	i32.const	$push0=, 255
	i32.and 	$push2=, $4, $pop0
	i32.const	$push25=, 255
	i32.and 	$push1=, $8, $pop25
	i32.div_u	$push3=, $pop2, $pop1
	i32.store8	0($pop5), $pop3
	i32.const	$push9=, 2
	i32.add 	$push10=, $0, $pop9
	i32.const	$push24=, 255
	i32.and 	$push7=, $3, $pop24
	i32.const	$push23=, 255
	i32.and 	$push6=, $7, $pop23
	i32.div_u	$push8=, $pop7, $pop6
	i32.store8	0($pop10), $pop8
	i32.const	$push14=, 1
	i32.add 	$push15=, $0, $pop14
	i32.const	$push22=, 255
	i32.and 	$push12=, $2, $pop22
	i32.const	$push21=, 255
	i32.and 	$push11=, $6, $pop21
	i32.div_u	$push13=, $pop12, $pop11
	i32.store8	0($pop15), $pop13
	i32.const	$push20=, 255
	i32.and 	$push17=, $1, $pop20
	i32.const	$push19=, 255
	i32.and 	$push16=, $5, $pop19
	i32.div_u	$push18=, $pop17, $pop16
	i32.store8	0($0), $pop18
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 16
	i32.sub 	$push29=, $pop11, $pop12
	tee_local	$push28=, $0=, $pop29
	i32.store	__stack_pointer($pop13), $pop28
	i32.const	$push17=, 12
	i32.add 	$push18=, $0, $pop17
	i32.const	$push27=, 5
	i32.const	$push26=, 5
	i32.const	$push25=, 5
	i32.const	$push24=, 5
	call    	f1@FUNCTION, $pop18, $pop27, $pop26, $pop25, $pop24
	block   	
	i32.load	$push0=, 12($0)
	i32.const	$push23=, 33686018
	i32.ne  	$push1=, $pop0, $pop23
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push19=, 8
	i32.add 	$push20=, $0, $pop19
	i32.const	$push34=, 5
	i32.const	$push33=, 5
	i32.const	$push32=, 5
	i32.const	$push31=, 5
	call    	f2@FUNCTION, $pop20, $pop34, $pop33, $pop32, $pop31
	i32.load	$push2=, 8($0)
	i32.const	$push30=, 33686018
	i32.ne  	$push3=, $pop2, $pop30
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push21=, 4
	i32.add 	$push22=, $0, $pop21
	i32.const	$push5=, 5
	i32.const	$push40=, 5
	i32.const	$push39=, 5
	i32.const	$push38=, 5
	i32.const	$push4=, 2
	i32.const	$push37=, 2
	i32.const	$push36=, 2
	i32.const	$push35=, 2
	call    	f3@FUNCTION, $pop22, $pop5, $pop40, $pop39, $pop38, $pop4, $pop37, $pop36, $pop35
	i32.load	$push7=, 4($0)
	i32.const	$push6=, 33686018
	i32.ne  	$push8=, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push16=, 0
	i32.const	$push14=, 16
	i32.add 	$push15=, $0, $pop14
	i32.store	__stack_pointer($pop16), $pop15
	i32.const	$push9=, 0
	return  	$pop9
.LBB3_4:                                # %if.then10
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
