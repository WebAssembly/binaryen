	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960513-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i64, i64, i32
	.local  	i64, i32, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 192
	i32.sub 	$31=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$31=, 0($9), $31
	i64.const	$4=, 0
	i64.const	$push0=, -9223372036854775808
	i32.const	$11=, 176
	i32.add 	$11=, $31, $11
	call    	__subtf3@FUNCTION, $11, $4, $pop0, $1, $2
	i32.const	$5=, 8
	i32.const	$12=, 176
	i32.add 	$12=, $31, $12
	i32.add 	$push1=, $12, $5
	i64.load	$7=, 0($pop1)
	i64.load	$6=, 176($31)
	i32.const	$push2=, 1
	i32.eq  	$3=, $3, $pop2
	i64.const	$push3=, -4611686018427387904
	i32.const	$13=, 160
	i32.add 	$13=, $31, $13
	call    	__multf3@FUNCTION, $13, $1, $2, $4, $pop3
	i32.const	$14=, 160
	i32.add 	$14=, $31, $14
	i32.add 	$push4=, $14, $5
	i64.load	$push5=, 0($pop4)
	i64.select	$4=, $3, $pop5, $7
	i64.load	$push6=, 160($31)
	i64.select	$7=, $3, $pop6, $6
	i32.const	$15=, 144
	i32.add 	$15=, $31, $15
	call    	__multf3@FUNCTION, $15, $7, $4, $1, $2
	i64.load	$push9=, 144($31)
	i32.const	$16=, 144
	i32.add 	$16=, $31, $16
	i32.add 	$push7=, $16, $5
	i64.load	$push8=, 0($pop7)
	i32.const	$17=, 128
	i32.add 	$17=, $31, $17
	call    	__addtf3@FUNCTION, $17, $7, $4, $pop9, $pop8
	i32.const	$18=, 128
	i32.add 	$18=, $31, $18
	i32.add 	$push10=, $18, $5
	i64.load	$4=, 0($pop10)
	i64.load	$7=, 128($31)
	i32.const	$19=, 112
	i32.add 	$19=, $31, $19
	call    	__multf3@FUNCTION, $19, $7, $4, $1, $2
	i64.load	$push13=, 112($31)
	i32.const	$20=, 112
	i32.add 	$20=, $31, $20
	i32.add 	$push11=, $20, $5
	i64.load	$push12=, 0($pop11)
	i32.const	$21=, 96
	i32.add 	$21=, $31, $21
	call    	__addtf3@FUNCTION, $21, $7, $4, $pop13, $pop12
	i32.const	$22=, 96
	i32.add 	$22=, $31, $22
	i32.add 	$push14=, $22, $5
	i64.load	$4=, 0($pop14)
	i64.load	$7=, 96($31)
	i32.const	$23=, 80
	i32.add 	$23=, $31, $23
	call    	__multf3@FUNCTION, $23, $7, $4, $1, $2
	i64.load	$push17=, 80($31)
	i32.const	$24=, 80
	i32.add 	$24=, $31, $24
	i32.add 	$push15=, $24, $5
	i64.load	$push16=, 0($pop15)
	i32.const	$25=, 64
	i32.add 	$25=, $31, $25
	call    	__addtf3@FUNCTION, $25, $7, $4, $pop17, $pop16
	i32.const	$26=, 64
	i32.add 	$26=, $31, $26
	i32.add 	$push18=, $26, $5
	i64.load	$4=, 0($pop18)
	i64.load	$7=, 64($31)
	i32.const	$27=, 48
	i32.add 	$27=, $31, $27
	call    	__multf3@FUNCTION, $27, $7, $4, $1, $2
	i64.load	$push21=, 48($31)
	i32.const	$28=, 48
	i32.add 	$28=, $31, $28
	i32.add 	$push19=, $28, $5
	i64.load	$push20=, 0($pop19)
	i32.const	$29=, 32
	i32.add 	$29=, $31, $29
	call    	__addtf3@FUNCTION, $29, $7, $4, $pop21, $pop20
	i32.const	$30=, 32
	i32.add 	$30=, $31, $30
	i32.add 	$push22=, $30, $5
	i64.load	$4=, 0($pop22)
	i64.load	$7=, 32($31)
	i32.const	$31=, 16
	i32.add 	$31=, $31, $31
	call    	__multf3@FUNCTION, $31, $7, $4, $1, $2
	i64.load	$push25=, 16($31)
	i32.const	$32=, 16
	i32.add 	$32=, $31, $32
	i32.add 	$push23=, $32, $5
	i64.load	$push24=, 0($pop23)
	i32.const	$33=, 0
	i32.add 	$33=, $31, $33
	call    	__addtf3@FUNCTION, $33, $7, $4, $pop25, $pop24
	i64.load	$2=, 0($31)
	i32.add 	$push28=, $0, $5
	i32.const	$34=, 0
	i32.add 	$34=, $31, $34
	i32.add 	$push26=, $34, $5
	i64.load	$push27=, 0($pop26)
	i64.store	$discard=, 0($pop28), $pop27
	i64.store	$discard=, 0($0), $2
	i32.const	$10=, 192
	i32.add 	$31=, $31, $10
	i32.const	$10=, __stack_pointer
	i32.store	$31=, 0($10), $31
	return
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
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
