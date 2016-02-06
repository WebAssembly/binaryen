	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960513-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i64, i64, i32
	.local  	i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 192
	i32.sub 	$31=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$31=, 0($7), $31
	i64.const	$push1=, 0
	i64.const	$push0=, -9223372036854775808
	i32.const	$9=, 176
	i32.add 	$9=, $31, $9
	call    	__subtf3@FUNCTION, $9, $pop1, $pop0, $1, $2
	i32.const	$push2=, 8
	i32.const	$10=, 176
	i32.add 	$10=, $31, $10
	i32.add 	$push3=, $10, $pop2
	i64.load	$4=, 0($pop3)
	i64.load	$5=, 176($31)
	i64.const	$push65=, 0
	i64.const	$push6=, -4611686018427387904
	i32.const	$11=, 160
	i32.add 	$11=, $31, $11
	call    	__multf3@FUNCTION, $11, $1, $2, $pop65, $pop6
	i64.load	$push9=, 160($31)
	i32.const	$push4=, 1
	i32.eq  	$push5=, $3, $pop4
	tee_local	$push64=, $3=, $pop5
	i64.select	$push11=, $pop9, $5, $pop64
	tee_local	$push63=, $5=, $pop11
	i32.const	$push62=, 8
	i32.const	$12=, 160
	i32.add 	$12=, $31, $12
	i32.add 	$push7=, $12, $pop62
	i64.load	$push8=, 0($pop7)
	i64.select	$push10=, $pop8, $4, $3
	tee_local	$push61=, $4=, $pop10
	i32.const	$13=, 144
	i32.add 	$13=, $31, $13
	call    	__multf3@FUNCTION, $13, $pop63, $pop61, $1, $2
	i64.load	$push14=, 144($31)
	i32.const	$push60=, 8
	i32.const	$14=, 144
	i32.add 	$14=, $31, $14
	i32.add 	$push12=, $14, $pop60
	i64.load	$push13=, 0($pop12)
	i32.const	$15=, 128
	i32.add 	$15=, $31, $15
	call    	__addtf3@FUNCTION, $15, $5, $4, $pop14, $pop13
	i64.load	$push17=, 128($31)
	tee_local	$push59=, $4=, $pop17
	i32.const	$push58=, 8
	i32.const	$16=, 128
	i32.add 	$16=, $31, $16
	i32.add 	$push15=, $16, $pop58
	i64.load	$push16=, 0($pop15)
	tee_local	$push57=, $5=, $pop16
	i32.const	$17=, 112
	i32.add 	$17=, $31, $17
	call    	__multf3@FUNCTION, $17, $pop59, $pop57, $1, $2
	i64.load	$push20=, 112($31)
	i32.const	$push56=, 8
	i32.const	$18=, 112
	i32.add 	$18=, $31, $18
	i32.add 	$push18=, $18, $pop56
	i64.load	$push19=, 0($pop18)
	i32.const	$19=, 96
	i32.add 	$19=, $31, $19
	call    	__addtf3@FUNCTION, $19, $4, $5, $pop20, $pop19
	i64.load	$push23=, 96($31)
	tee_local	$push55=, $4=, $pop23
	i32.const	$push54=, 8
	i32.const	$20=, 96
	i32.add 	$20=, $31, $20
	i32.add 	$push21=, $20, $pop54
	i64.load	$push22=, 0($pop21)
	tee_local	$push53=, $5=, $pop22
	i32.const	$21=, 80
	i32.add 	$21=, $31, $21
	call    	__multf3@FUNCTION, $21, $pop55, $pop53, $1, $2
	i64.load	$push26=, 80($31)
	i32.const	$push52=, 8
	i32.const	$22=, 80
	i32.add 	$22=, $31, $22
	i32.add 	$push24=, $22, $pop52
	i64.load	$push25=, 0($pop24)
	i32.const	$23=, 64
	i32.add 	$23=, $31, $23
	call    	__addtf3@FUNCTION, $23, $4, $5, $pop26, $pop25
	i64.load	$push29=, 64($31)
	tee_local	$push51=, $4=, $pop29
	i32.const	$push50=, 8
	i32.const	$24=, 64
	i32.add 	$24=, $31, $24
	i32.add 	$push27=, $24, $pop50
	i64.load	$push28=, 0($pop27)
	tee_local	$push49=, $5=, $pop28
	i32.const	$25=, 48
	i32.add 	$25=, $31, $25
	call    	__multf3@FUNCTION, $25, $pop51, $pop49, $1, $2
	i64.load	$push32=, 48($31)
	i32.const	$push48=, 8
	i32.const	$26=, 48
	i32.add 	$26=, $31, $26
	i32.add 	$push30=, $26, $pop48
	i64.load	$push31=, 0($pop30)
	i32.const	$27=, 32
	i32.add 	$27=, $31, $27
	call    	__addtf3@FUNCTION, $27, $4, $5, $pop32, $pop31
	i64.load	$push35=, 32($31)
	tee_local	$push47=, $4=, $pop35
	i32.const	$push46=, 8
	i32.const	$28=, 32
	i32.add 	$28=, $31, $28
	i32.add 	$push33=, $28, $pop46
	i64.load	$push34=, 0($pop33)
	tee_local	$push45=, $5=, $pop34
	i32.const	$29=, 16
	i32.add 	$29=, $31, $29
	call    	__multf3@FUNCTION, $29, $pop47, $pop45, $1, $2
	i64.load	$push38=, 16($31)
	i32.const	$push44=, 8
	i32.const	$30=, 16
	i32.add 	$30=, $31, $30
	i32.add 	$push36=, $30, $pop44
	i64.load	$push37=, 0($pop36)
	call    	__addtf3@FUNCTION, $31, $4, $5, $pop38, $pop37
	i64.load	$2=, 0($31)
	i32.const	$push43=, 8
	i32.add 	$push41=, $0, $pop43
	i32.const	$push42=, 8
	i32.add 	$push39=, $31, $pop42
	i64.load	$push40=, 0($pop39)
	i64.store	$discard=, 0($pop41), $pop40
	i64.store	$discard=, 0($0):p2align=4, $2
	i32.const	$8=, 192
	i32.add 	$31=, $31, $8
	i32.const	$8=, __stack_pointer
	i32.store	$31=, 0($8), $31
	return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
