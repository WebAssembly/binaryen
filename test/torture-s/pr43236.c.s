	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43236.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 96
	i32.sub 	$42=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$42=, 0($8), $42
	i32.const	$0=, 28
	i32.const	$10=, 64
	i32.add 	$10=, $42, $10
	i32.add 	$push0=, $10, $0
	i32.const	$push1=, 257
	i32.store16	$1=, 0($pop0), $pop1
	i32.const	$2=, 24
	i32.const	$11=, 64
	i32.add 	$11=, $42, $11
	i32.add 	$push2=, $11, $2
	i32.const	$push3=, 16843009
	i32.store	$3=, 0($pop2), $pop3
	i32.const	$4=, 16
	i32.const	$12=, 64
	i32.add 	$12=, $42, $12
	i32.add 	$push4=, $12, $4
	i64.const	$push5=, 72340172838076673
	i64.store	$5=, 0($pop4), $pop5
	i32.const	$6=, 8
	i32.const	$13=, 64
	i32.add 	$13=, $42, $13
	i32.or  	$push6=, $13, $6
	i64.store	$discard=, 0($pop6), $5
	i32.const	$14=, 32
	i32.add 	$14=, $42, $14
	i32.add 	$push7=, $14, $0
	i32.store16	$discard=, 0($pop7), $1
	i32.const	$15=, 32
	i32.add 	$15=, $42, $15
	i32.add 	$push8=, $15, $2
	i32.store	$discard=, 0($pop8), $3
	i64.store	$discard=, 64($42), $5
	i32.const	$16=, 32
	i32.add 	$16=, $42, $16
	i32.add 	$push9=, $16, $4
	i64.store	$discard=, 0($pop9), $5
	i32.const	$17=, 32
	i32.add 	$17=, $42, $17
	i32.or  	$push10=, $17, $6
	i64.store	$push11=, 0($pop10), $5
	i64.store	$5=, 32($42), $pop11
	i32.const	$18=, 0
	i32.add 	$18=, $42, $18
	i32.or  	$push32=, $18, $6
	i64.store	$discard=, 0($pop32), $5
	i32.const	$19=, 0
	i32.add 	$19=, $42, $19
	i32.add 	$push33=, $19, $0
	i32.store16	$discard=, 0($pop33), $1
	i32.const	$20=, 0
	i32.add 	$20=, $42, $20
	i32.add 	$push34=, $20, $2
	i32.store	$discard=, 0($pop34), $3
	i32.const	$push12=, 0
	i32.store8	$push13=, 83($42), $pop12
	i32.store8	$push14=, 51($42), $pop13
	i32.store8	$push15=, 82($42), $pop14
	i32.store8	$push16=, 50($42), $pop15
	i32.store8	$push17=, 81($42), $pop16
	i32.store8	$push18=, 49($42), $pop17
	i32.store8	$push19=, 80($42), $pop18
	i32.store8	$2=, 48($42), $pop19
	i32.const	$0=, 15
	i32.const	$21=, 64
	i32.add 	$21=, $42, $21
	i32.or  	$push20=, $21, $0
	i32.store8	$discard=, 0($pop20), $2
	i32.const	$22=, 32
	i32.add 	$22=, $42, $22
	i32.or  	$push21=, $22, $0
	i32.store8	$discard=, 0($pop21), $2
	i32.const	$0=, 14
	i32.const	$23=, 64
	i32.add 	$23=, $42, $23
	i32.or  	$push22=, $23, $0
	i32.store8	$discard=, 0($pop22), $2
	i32.const	$24=, 32
	i32.add 	$24=, $42, $24
	i32.or  	$push23=, $24, $0
	i32.store8	$6=, 0($pop23), $2
	i32.const	$2=, 13
	i32.const	$25=, 64
	i32.add 	$25=, $42, $25
	i32.or  	$push24=, $25, $2
	i32.store8	$discard=, 0($pop24), $6
	i32.const	$26=, 32
	i32.add 	$26=, $42, $26
	i32.or  	$push25=, $26, $2
	i32.store8	$discard=, 0($pop25), $6
	i32.const	$2=, 12
	i32.const	$27=, 64
	i32.add 	$27=, $42, $27
	i32.or  	$push26=, $27, $2
	i32.store8	$discard=, 0($pop26), $6
	i32.const	$28=, 32
	i32.add 	$28=, $42, $28
	i32.or  	$push27=, $28, $2
	i32.store8	$1=, 0($pop27), $6
	i32.const	$6=, 11
	i32.const	$29=, 64
	i32.add 	$29=, $42, $29
	i32.or  	$push28=, $29, $6
	i32.store8	$discard=, 0($pop28), $1
	i32.const	$30=, 32
	i32.add 	$30=, $42, $30
	i32.or  	$push29=, $30, $6
	i32.store8	$discard=, 0($pop29), $1
	i32.const	$6=, 10
	i32.const	$31=, 64
	i32.add 	$31=, $42, $31
	i32.or  	$push30=, $31, $6
	i32.store8	$discard=, 0($pop30), $1
	i32.const	$32=, 32
	i32.add 	$32=, $42, $32
	i32.or  	$push31=, $32, $6
	i32.store8	$discard=, 0($pop31), $1
	i32.const	$33=, 0
	i32.add 	$33=, $42, $33
	i32.add 	$4=, $33, $4
	i64.store	$discard=, 0($4), $5
	i32.const	$34=, 0
	i32.add 	$34=, $42, $34
	i32.or  	$push35=, $34, $6
	i32.store16	$6=, 0($pop35), $1
	i32.const	$push36=, 18
	i32.const	$35=, 0
	i32.add 	$35=, $42, $35
	i32.add 	$push37=, $35, $pop36
	i32.store16	$push38=, 0($pop37), $6
	i32.store16	$4=, 0($4), $pop38
	i32.const	$36=, 0
	i32.add 	$36=, $42, $36
	i32.or  	$push39=, $36, $0
	i32.store16	$0=, 0($pop39), $4
	i32.const	$37=, 0
	i32.add 	$37=, $42, $37
	i32.or  	$push40=, $37, $2
	i32.store16	$2=, 0($pop40), $0
	i32.const	$0=, 30
	i64.store	$discard=, 0($42), $5
	i32.const	$38=, 64
	i32.add 	$38=, $42, $38
	i32.const	$39=, 0
	i32.add 	$39=, $42, $39
	block   	.LBB0_3
	i32.call	$push41=, memcmp, $38, $39, $0
	br_if   	$pop41, .LBB0_3
# BB#1:                                 # %lor.lhs.false
	i32.const	$40=, 32
	i32.add 	$40=, $42, $40
	i32.const	$41=, 0
	i32.add 	$41=, $42, $41
	i32.call	$push42=, memcmp, $40, $41, $0
	br_if   	$pop42, .LBB0_3
# BB#2:                                 # %if.end
	i32.const	$9=, 96
	i32.add 	$42=, $42, $9
	i32.const	$9=, __stack_pointer
	i32.store	$42=, 0($9), $42
	return  	$2
.LBB0_3:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
