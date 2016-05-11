	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr60960.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 255
	i32.and 	$push3=, $2, $pop0
	i32.const	$push8=, 0
	i32.div_u	$2=, $pop3, $pop8
	i32.const	$push19=, 255
	i32.and 	$push2=, $3, $pop19
	i32.const	$push18=, 0
	i32.div_u	$3=, $pop2, $pop18
	i32.const	$push10=, 3
	i32.add 	$push11=, $0, $pop10
	i32.const	$push17=, 255
	i32.and 	$push1=, $4, $pop17
	i32.const	$push16=, 0
	i32.div_u	$push9=, $pop1, $pop16
	i32.store8	$discard=, 0($pop11), $pop9
	i32.const	$push12=, 2
	i32.add 	$push13=, $0, $pop12
	i32.store8	$discard=, 0($pop13), $3
	i32.const	$push6=, 1
	i32.add 	$push14=, $0, $pop6
	i32.store8	$discard=, 0($pop14), $2
	i32.const	$push4=, 254
	i32.and 	$push5=, $1, $pop4
	i32.const	$push15=, 1
	i32.shr_u	$push7=, $pop5, $pop15
	i32.store8	$discard=, 0($0), $pop7
	return
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
	i32.const	$push10=, 3
	i32.add 	$push11=, $0, $pop10
	i32.const	$push0=, 254
	i32.and 	$push1=, $4, $pop0
	i32.const	$push5=, 1
	i32.shr_u	$push9=, $pop1, $pop5
	i32.store8	$discard=, 0($pop11), $pop9
	i32.const	$push12=, 2
	i32.add 	$push13=, $0, $pop12
	i32.const	$push21=, 254
	i32.and 	$push2=, $3, $pop21
	i32.const	$push20=, 1
	i32.shr_u	$push8=, $pop2, $pop20
	i32.store8	$discard=, 0($pop13), $pop8
	i32.const	$push19=, 1
	i32.add 	$push14=, $0, $pop19
	i32.const	$push18=, 254
	i32.and 	$push3=, $2, $pop18
	i32.const	$push17=, 1
	i32.shr_u	$push7=, $pop3, $pop17
	i32.store8	$discard=, 0($pop14), $pop7
	i32.const	$push16=, 254
	i32.and 	$push4=, $1, $pop16
	i32.const	$push15=, 1
	i32.shr_u	$push6=, $pop4, $pop15
	i32.store8	$discard=, 0($0), $pop6
	return
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
	i32.const	$push0=, 255
	i32.and 	$push8=, $1, $pop0
	i32.const	$push22=, 255
	i32.and 	$push7=, $5, $pop22
	i32.div_u	$1=, $pop8, $pop7
	i32.const	$push21=, 255
	i32.and 	$push6=, $2, $pop21
	i32.const	$push20=, 255
	i32.and 	$push5=, $6, $pop20
	i32.div_u	$5=, $pop6, $pop5
	i32.const	$push19=, 255
	i32.and 	$push4=, $3, $pop19
	i32.const	$push18=, 255
	i32.and 	$push3=, $7, $pop18
	i32.div_u	$2=, $pop4, $pop3
	i32.const	$push10=, 3
	i32.add 	$push11=, $0, $pop10
	i32.const	$push17=, 255
	i32.and 	$push2=, $4, $pop17
	i32.const	$push16=, 255
	i32.and 	$push1=, $8, $pop16
	i32.div_u	$push9=, $pop2, $pop1
	i32.store8	$discard=, 0($pop11), $pop9
	i32.const	$push12=, 2
	i32.add 	$push13=, $0, $pop12
	i32.store8	$discard=, 0($pop13), $2
	i32.const	$push14=, 1
	i32.add 	$push15=, $0, $pop14
	i32.store8	$discard=, 0($pop15), $5
	i32.store8	$discard=, 0($0), $1
	return
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
	i32.const	$push13=, __stack_pointer
	i32.const	$push10=, __stack_pointer
	i32.load	$push11=, 0($pop10)
	i32.const	$push12=, 16
	i32.sub 	$push23=, $pop11, $pop12
	i32.store	$push30=, 0($pop13), $pop23
	tee_local	$push29=, $0=, $pop30
	i32.const	$push17=, 12
	i32.add 	$push18=, $pop29, $pop17
	i32.const	$push28=, 5
	i32.const	$push27=, 5
	i32.const	$push26=, 5
	i32.const	$push25=, 5
	call    	f1@FUNCTION, $pop18, $pop28, $pop27, $pop26, $pop25
	block
	i32.load	$push0=, 12($0)
	i32.const	$push24=, 33686018
	i32.ne  	$push1=, $pop0, $pop24
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push19=, 8
	i32.add 	$push20=, $0, $pop19
	i32.const	$push35=, 5
	i32.const	$push34=, 5
	i32.const	$push33=, 5
	i32.const	$push32=, 5
	call    	f2@FUNCTION, $pop20, $pop35, $pop34, $pop33, $pop32
	i32.load	$push2=, 8($0)
	i32.const	$push31=, 33686018
	i32.ne  	$push3=, $pop2, $pop31
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push21=, 4
	i32.add 	$push22=, $0, $pop21
	i32.const	$push5=, 5
	i32.const	$push41=, 5
	i32.const	$push40=, 5
	i32.const	$push39=, 5
	i32.const	$push4=, 2
	i32.const	$push38=, 2
	i32.const	$push37=, 2
	i32.const	$push36=, 2
	call    	f3@FUNCTION, $pop22, $pop5, $pop41, $pop40, $pop39, $pop4, $pop38, $pop37, $pop36
	i32.load	$push6=, 4($0)
	i32.const	$push7=, 33686018
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push16=, __stack_pointer
	i32.const	$push14=, 16
	i32.add 	$push15=, $0, $pop14
	i32.store	$discard=, 0($pop16), $pop15
	i32.const	$push9=, 0
	return  	$pop9
.LBB3_4:                                # %if.then10
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.9.0 "
