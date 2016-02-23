	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960513-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i64, i64, i32
	.local  	i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push66=, __stack_pointer
	i32.load	$push67=, 0($pop66)
	i32.const	$push68=, 192
	i32.sub 	$28=, $pop67, $pop68
	i32.const	$push69=, __stack_pointer
	i32.store	$discard=, 0($pop69), $28
	i64.const	$push1=, 0
	i64.const	$push0=, -9223372036854775808
	i32.const	$6=, 176
	i32.add 	$6=, $28, $6
	call    	__subtf3@FUNCTION, $6, $pop1, $pop0, $1, $2
	i32.const	$push2=, 8
	i32.const	$7=, 176
	i32.add 	$7=, $28, $7
	i32.add 	$push3=, $7, $pop2
	i64.load	$4=, 0($pop3)
	i64.load	$5=, 176($28)
	i64.const	$push65=, 0
	i64.const	$push5=, -4611686018427387904
	i32.const	$8=, 160
	i32.add 	$8=, $28, $8
	call    	__multf3@FUNCTION, $8, $1, $2, $pop65, $pop5
	i64.load	$push8=, 160($28)
	i32.const	$push4=, 1
	i32.eq  	$push64=, $3, $pop4
	tee_local	$push63=, $3=, $pop64
	i64.select	$push62=, $pop8, $5, $pop63
	tee_local	$push61=, $5=, $pop62
	i32.const	$push60=, 8
	i32.const	$9=, 160
	i32.add 	$9=, $28, $9
	i32.add 	$push6=, $9, $pop60
	i64.load	$push7=, 0($pop6)
	i64.select	$push59=, $pop7, $4, $3
	tee_local	$push58=, $4=, $pop59
	i32.const	$10=, 144
	i32.add 	$10=, $28, $10
	call    	__multf3@FUNCTION, $10, $pop61, $pop58, $1, $2
	i64.load	$push11=, 144($28)
	i32.const	$push57=, 8
	i32.const	$11=, 144
	i32.add 	$11=, $28, $11
	i32.add 	$push9=, $11, $pop57
	i64.load	$push10=, 0($pop9)
	i32.const	$12=, 128
	i32.add 	$12=, $28, $12
	call    	__addtf3@FUNCTION, $12, $5, $4, $pop11, $pop10
	i64.load	$push56=, 128($28)
	tee_local	$push55=, $4=, $pop56
	i32.const	$push54=, 8
	i32.const	$13=, 128
	i32.add 	$13=, $28, $13
	i32.add 	$push12=, $13, $pop54
	i64.load	$push53=, 0($pop12)
	tee_local	$push52=, $5=, $pop53
	i32.const	$14=, 112
	i32.add 	$14=, $28, $14
	call    	__multf3@FUNCTION, $14, $pop55, $pop52, $1, $2
	i64.load	$push15=, 112($28)
	i32.const	$push51=, 8
	i32.const	$15=, 112
	i32.add 	$15=, $28, $15
	i32.add 	$push13=, $15, $pop51
	i64.load	$push14=, 0($pop13)
	i32.const	$16=, 96
	i32.add 	$16=, $28, $16
	call    	__addtf3@FUNCTION, $16, $4, $5, $pop15, $pop14
	i64.load	$push50=, 96($28)
	tee_local	$push49=, $4=, $pop50
	i32.const	$push48=, 8
	i32.const	$17=, 96
	i32.add 	$17=, $28, $17
	i32.add 	$push16=, $17, $pop48
	i64.load	$push47=, 0($pop16)
	tee_local	$push46=, $5=, $pop47
	i32.const	$18=, 80
	i32.add 	$18=, $28, $18
	call    	__multf3@FUNCTION, $18, $pop49, $pop46, $1, $2
	i64.load	$push19=, 80($28)
	i32.const	$push45=, 8
	i32.const	$19=, 80
	i32.add 	$19=, $28, $19
	i32.add 	$push17=, $19, $pop45
	i64.load	$push18=, 0($pop17)
	i32.const	$20=, 64
	i32.add 	$20=, $28, $20
	call    	__addtf3@FUNCTION, $20, $4, $5, $pop19, $pop18
	i64.load	$push44=, 64($28)
	tee_local	$push43=, $4=, $pop44
	i32.const	$push42=, 8
	i32.const	$21=, 64
	i32.add 	$21=, $28, $21
	i32.add 	$push20=, $21, $pop42
	i64.load	$push41=, 0($pop20)
	tee_local	$push40=, $5=, $pop41
	i32.const	$22=, 48
	i32.add 	$22=, $28, $22
	call    	__multf3@FUNCTION, $22, $pop43, $pop40, $1, $2
	i64.load	$push23=, 48($28)
	i32.const	$push39=, 8
	i32.const	$23=, 48
	i32.add 	$23=, $28, $23
	i32.add 	$push21=, $23, $pop39
	i64.load	$push22=, 0($pop21)
	i32.const	$24=, 32
	i32.add 	$24=, $28, $24
	call    	__addtf3@FUNCTION, $24, $4, $5, $pop23, $pop22
	i64.load	$push38=, 32($28)
	tee_local	$push37=, $4=, $pop38
	i32.const	$push36=, 8
	i32.const	$25=, 32
	i32.add 	$25=, $28, $25
	i32.add 	$push24=, $25, $pop36
	i64.load	$push35=, 0($pop24)
	tee_local	$push34=, $5=, $pop35
	i32.const	$26=, 16
	i32.add 	$26=, $28, $26
	call    	__multf3@FUNCTION, $26, $pop37, $pop34, $1, $2
	i64.load	$push27=, 16($28)
	i32.const	$push33=, 8
	i32.const	$27=, 16
	i32.add 	$27=, $28, $27
	i32.add 	$push25=, $27, $pop33
	i64.load	$push26=, 0($pop25)
	call    	__addtf3@FUNCTION, $28, $4, $5, $pop27, $pop26
	i64.load	$2=, 0($28)
	i32.const	$push32=, 8
	i32.add 	$push30=, $0, $pop32
	i32.const	$push31=, 8
	i32.add 	$push28=, $28, $pop31
	i64.load	$push29=, 0($pop28)
	i64.store	$discard=, 0($pop30), $pop29
	i64.store	$discard=, 0($0):p2align=4, $2
	i32.const	$push70=, 192
	i32.add 	$28=, $28, $pop70
	i32.const	$push71=, __stack_pointer
	i32.store	$discard=, 0($pop71), $28
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
