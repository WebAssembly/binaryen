	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr60960.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 255
	i32.const	$6=, 0
	i32.and 	$push2=, $2, $5
	i32.div_u	$2=, $pop2, $6
	i32.and 	$push1=, $3, $5
	i32.div_u	$3=, $pop1, $6
	i32.and 	$push0=, $4, $5
	i32.div_u	$5=, $pop0, $6
	i32.const	$push6=, 3
	i32.add 	$push7=, $0, $pop6
	i32.store8	$discard=, 0($pop7), $5
	i32.const	$push8=, 2
	i32.add 	$push9=, $0, $pop8
	i32.store8	$discard=, 0($pop9), $3
	i32.const	$5=, 1
	i32.add 	$push10=, $0, $5
	i32.store8	$discard=, 0($pop10), $2
	i32.const	$push3=, 254
	i32.and 	$push4=, $1, $pop3
	i32.shr_u	$push5=, $pop4, $5
	i32.store8	$discard=, 0($0), $pop5
	return
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 254
	i32.const	$6=, 1
	i32.const	$push8=, 3
	i32.add 	$push9=, $0, $pop8
	i32.and 	$push0=, $4, $5
	i32.shr_u	$push7=, $pop0, $6
	i32.store8	$discard=, 0($pop9), $pop7
	i32.const	$push10=, 2
	i32.add 	$push11=, $0, $pop10
	i32.and 	$push1=, $3, $5
	i32.shr_u	$push6=, $pop1, $6
	i32.store8	$discard=, 0($pop11), $pop6
	i32.add 	$push12=, $0, $6
	i32.and 	$push2=, $2, $5
	i32.shr_u	$push5=, $pop2, $6
	i32.store8	$discard=, 0($pop12), $pop5
	i32.and 	$push3=, $1, $5
	i32.shr_u	$push4=, $pop3, $6
	i32.store8	$discard=, 0($0), $pop4
	return
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$9=, 255
	i32.and 	$push7=, $1, $9
	i32.and 	$push6=, $5, $9
	i32.div_u	$5=, $pop7, $pop6
	i32.and 	$push5=, $2, $9
	i32.and 	$push4=, $6, $9
	i32.div_u	$6=, $pop5, $pop4
	i32.and 	$push3=, $3, $9
	i32.and 	$push2=, $7, $9
	i32.div_u	$7=, $pop3, $pop2
	i32.and 	$push1=, $4, $9
	i32.and 	$push0=, $8, $9
	i32.div_u	$9=, $pop1, $pop0
	i32.const	$push8=, 3
	i32.add 	$push9=, $0, $pop8
	i32.store8	$discard=, 0($pop9), $9
	i32.const	$push10=, 2
	i32.add 	$push11=, $0, $pop10
	i32.store8	$discard=, 0($pop11), $7
	i32.const	$push12=, 1
	i32.add 	$push13=, $0, $pop12
	i32.store8	$discard=, 0($pop13), $6
	i32.store8	$discard=, 0($0), $5
	return
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 16
	i32.sub 	$23=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$23=, 0($9), $23
	i32.const	$0=, 5
	i32.const	$11=, 12
	i32.add 	$11=, $23, $11
	call    	f1@FUNCTION, $11, $0, $0, $0, $0
	i32.const	$1=, 3
	i32.const	$3=, 2
	i32.const	$5=, 1
	i32.const	$2=, 8
	i32.const	$4=, 16
	i32.const	$6=, 65535
	i32.const	$7=, 33686018
	i32.load8_u	$push10=, 12($23)
	i32.const	$12=, 12
	i32.add 	$12=, $23, $12
	i32.or  	$push7=, $12, $5
	i32.load8_u	$push8=, 0($pop7)
	i32.shl 	$push9=, $pop8, $2
	i32.or  	$push11=, $pop10, $pop9
	i32.and 	$push12=, $pop11, $6
	i32.const	$13=, 12
	i32.add 	$13=, $23, $13
	i32.or  	$push3=, $13, $3
	i32.load8_u	$push4=, 0($pop3)
	i32.const	$14=, 12
	i32.add 	$14=, $23, $14
	block   	.LBB3_6
	i32.or  	$push0=, $14, $1
	i32.load8_u	$push1=, 0($pop0)
	i32.shl 	$push2=, $pop1, $2
	i32.or  	$push5=, $pop4, $pop2
	i32.shl 	$push6=, $pop5, $4
	i32.or  	$push13=, $pop12, $pop6
	i32.ne  	$push14=, $pop13, $7
	br_if   	$pop14, .LBB3_6
# BB#1:                                 # %if.end
	i32.const	$15=, 8
	i32.add 	$15=, $23, $15
	call    	f2@FUNCTION, $15, $0, $0, $0, $0
	i32.load8_u	$push25=, 8($23)
	i32.const	$16=, 8
	i32.add 	$16=, $23, $16
	i32.or  	$push22=, $16, $5
	i32.load8_u	$push23=, 0($pop22)
	i32.shl 	$push24=, $pop23, $2
	i32.or  	$push26=, $pop25, $pop24
	i32.and 	$push27=, $pop26, $6
	i32.const	$17=, 8
	i32.add 	$17=, $23, $17
	i32.or  	$push18=, $17, $3
	i32.load8_u	$push19=, 0($pop18)
	i32.const	$18=, 8
	i32.add 	$18=, $23, $18
	block   	.LBB3_5
	i32.or  	$push15=, $18, $1
	i32.load8_u	$push16=, 0($pop15)
	i32.shl 	$push17=, $pop16, $2
	i32.or  	$push20=, $pop19, $pop17
	i32.shl 	$push21=, $pop20, $4
	i32.or  	$push28=, $pop27, $pop21
	i32.ne  	$push29=, $pop28, $7
	br_if   	$pop29, .LBB3_5
# BB#2:                                 # %if.end6
	i32.const	$19=, 4
	i32.add 	$19=, $23, $19
	call    	f3@FUNCTION, $19, $0, $0, $0, $0, $3, $3, $3, $3
	i32.load8_u	$push40=, 4($23)
	i32.const	$20=, 4
	i32.add 	$20=, $23, $20
	i32.or  	$push37=, $20, $5
	i32.load8_u	$push38=, 0($pop37)
	i32.shl 	$push39=, $pop38, $2
	i32.or  	$push41=, $pop40, $pop39
	i32.and 	$push42=, $pop41, $6
	i32.const	$21=, 4
	i32.add 	$21=, $23, $21
	i32.or  	$push33=, $21, $3
	i32.load8_u	$push34=, 0($pop33)
	i32.const	$22=, 4
	i32.add 	$22=, $23, $22
	block   	.LBB3_4
	i32.or  	$push30=, $22, $1
	i32.load8_u	$push31=, 0($pop30)
	i32.shl 	$push32=, $pop31, $2
	i32.or  	$push35=, $pop34, $pop32
	i32.shl 	$push36=, $pop35, $4
	i32.or  	$push43=, $pop42, $pop36
	i32.ne  	$push44=, $pop43, $7
	br_if   	$pop44, .LBB3_4
# BB#3:                                 # %if.end11
	i32.const	$push45=, 0
	i32.const	$10=, 16
	i32.add 	$23=, $23, $10
	i32.const	$10=, __stack_pointer
	i32.store	$23=, 0($10), $23
	return  	$pop45
.LBB3_4:                                # %if.then10
	call    	abort@FUNCTION
	unreachable
.LBB3_5:                                # %if.then5
	call    	abort@FUNCTION
	unreachable
.LBB3_6:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
