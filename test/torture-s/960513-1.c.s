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
	i64.const	$push5=, -4611686018427387904
	i32.const	$11=, 160
	i32.add 	$11=, $31, $11
	call    	__multf3@FUNCTION, $11, $1, $2, $pop65, $pop5
	i64.load	$push8=, 160($31)
	i32.const	$push4=, 1
	i32.eq  	$push64=, $3, $pop4
	tee_local	$push63=, $3=, $pop64
	i64.select	$push62=, $pop8, $5, $pop63
	tee_local	$push61=, $5=, $pop62
	i32.const	$push60=, 8
	i32.const	$12=, 160
	i32.add 	$12=, $31, $12
	i32.add 	$push6=, $12, $pop60
	i64.load	$push7=, 0($pop6)
	i64.select	$push59=, $pop7, $4, $3
	tee_local	$push58=, $4=, $pop59
	i32.const	$13=, 144
	i32.add 	$13=, $31, $13
	call    	__multf3@FUNCTION, $13, $pop61, $pop58, $1, $2
	i64.load	$push11=, 144($31)
	i32.const	$push57=, 8
	i32.const	$14=, 144
	i32.add 	$14=, $31, $14
	i32.add 	$push9=, $14, $pop57
	i64.load	$push10=, 0($pop9)
	i32.const	$15=, 128
	i32.add 	$15=, $31, $15
	call    	__addtf3@FUNCTION, $15, $5, $4, $pop11, $pop10
	i64.load	$push56=, 128($31)
	tee_local	$push55=, $4=, $pop56
	i32.const	$push54=, 8
	i32.const	$16=, 128
	i32.add 	$16=, $31, $16
	i32.add 	$push12=, $16, $pop54
	i64.load	$push53=, 0($pop12)
	tee_local	$push52=, $5=, $pop53
	i32.const	$17=, 112
	i32.add 	$17=, $31, $17
	call    	__multf3@FUNCTION, $17, $pop55, $pop52, $1, $2
	i64.load	$push15=, 112($31)
	i32.const	$push51=, 8
	i32.const	$18=, 112
	i32.add 	$18=, $31, $18
	i32.add 	$push13=, $18, $pop51
	i64.load	$push14=, 0($pop13)
	i32.const	$19=, 96
	i32.add 	$19=, $31, $19
	call    	__addtf3@FUNCTION, $19, $4, $5, $pop15, $pop14
	i64.load	$push50=, 96($31)
	tee_local	$push49=, $4=, $pop50
	i32.const	$push48=, 8
	i32.const	$20=, 96
	i32.add 	$20=, $31, $20
	i32.add 	$push16=, $20, $pop48
	i64.load	$push47=, 0($pop16)
	tee_local	$push46=, $5=, $pop47
	i32.const	$21=, 80
	i32.add 	$21=, $31, $21
	call    	__multf3@FUNCTION, $21, $pop49, $pop46, $1, $2
	i64.load	$push19=, 80($31)
	i32.const	$push45=, 8
	i32.const	$22=, 80
	i32.add 	$22=, $31, $22
	i32.add 	$push17=, $22, $pop45
	i64.load	$push18=, 0($pop17)
	i32.const	$23=, 64
	i32.add 	$23=, $31, $23
	call    	__addtf3@FUNCTION, $23, $4, $5, $pop19, $pop18
	i64.load	$push44=, 64($31)
	tee_local	$push43=, $4=, $pop44
	i32.const	$push42=, 8
	i32.const	$24=, 64
	i32.add 	$24=, $31, $24
	i32.add 	$push20=, $24, $pop42
	i64.load	$push41=, 0($pop20)
	tee_local	$push40=, $5=, $pop41
	i32.const	$25=, 48
	i32.add 	$25=, $31, $25
	call    	__multf3@FUNCTION, $25, $pop43, $pop40, $1, $2
	i64.load	$push23=, 48($31)
	i32.const	$push39=, 8
	i32.const	$26=, 48
	i32.add 	$26=, $31, $26
	i32.add 	$push21=, $26, $pop39
	i64.load	$push22=, 0($pop21)
	i32.const	$27=, 32
	i32.add 	$27=, $31, $27
	call    	__addtf3@FUNCTION, $27, $4, $5, $pop23, $pop22
	i64.load	$push38=, 32($31)
	tee_local	$push37=, $4=, $pop38
	i32.const	$push36=, 8
	i32.const	$28=, 32
	i32.add 	$28=, $31, $28
	i32.add 	$push24=, $28, $pop36
	i64.load	$push35=, 0($pop24)
	tee_local	$push34=, $5=, $pop35
	i32.const	$29=, 16
	i32.add 	$29=, $31, $29
	call    	__multf3@FUNCTION, $29, $pop37, $pop34, $1, $2
	i64.load	$push27=, 16($31)
	i32.const	$push33=, 8
	i32.const	$30=, 16
	i32.add 	$30=, $31, $30
	i32.add 	$push25=, $30, $pop33
	i64.load	$push26=, 0($pop25)
	call    	__addtf3@FUNCTION, $31, $4, $5, $pop27, $pop26
	i64.load	$2=, 0($31)
	i32.const	$push32=, 8
	i32.add 	$push30=, $0, $pop32
	i32.const	$push31=, 8
	i32.add 	$push28=, $31, $pop31
	i64.load	$push29=, 0($pop28)
	i64.store	$discard=, 0($pop30), $pop29
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
