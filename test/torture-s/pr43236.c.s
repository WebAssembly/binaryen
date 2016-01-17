	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43236.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 96
	i32.sub 	$44=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$44=, 0($10), $44
	i32.const	$0=, 28
	i32.const	$12=, 64
	i32.add 	$12=, $44, $12
	i32.add 	$push0=, $12, $0
	i32.const	$push1=, 257
	i32.store16	$8=, 0($pop0), $pop1
	i32.const	$1=, 24
	i32.const	$13=, 64
	i32.add 	$13=, $44, $13
	i32.add 	$push2=, $13, $1
	i32.const	$push3=, 16843009
	i32.store	$2=, 0($pop2), $pop3
	i32.const	$3=, 16
	i32.const	$14=, 64
	i32.add 	$14=, $44, $14
	i32.add 	$4=, $14, $3
	i64.const	$push4=, 72340172838076673
	i64.store	$5=, 0($4), $pop4
	i32.const	$6=, 8
	i32.const	$15=, 64
	i32.add 	$15=, $44, $15
	i32.or  	$push5=, $15, $6
	i64.store	$discard=, 0($pop5), $5
	i32.const	$16=, 32
	i32.add 	$16=, $44, $16
	i32.add 	$push6=, $16, $0
	i32.store16	$7=, 0($pop6), $8
	i32.const	$17=, 32
	i32.add 	$17=, $44, $17
	i32.add 	$push7=, $17, $1
	i32.store	$discard=, 0($pop7), $2
	i64.store	$discard=, 64($44), $5
	i32.const	$18=, 32
	i32.add 	$18=, $44, $18
	i32.add 	$8=, $18, $3
	i64.store	$discard=, 0($8), $5
	i32.const	$19=, 32
	i32.add 	$19=, $44, $19
	i32.or  	$push8=, $19, $6
	i64.store	$push9=, 0($pop8), $5
	i64.store	$5=, 32($44), $pop9
	i32.const	$20=, 0
	i32.add 	$20=, $44, $20
	i32.or  	$push30=, $20, $6
	i64.store	$discard=, 0($pop30), $5
	i32.const	$21=, 0
	i32.add 	$21=, $44, $21
	i32.add 	$push31=, $21, $0
	i32.store16	$discard=, 0($pop31), $7
	i32.const	$22=, 0
	i32.add 	$22=, $44, $22
	i32.add 	$push32=, $22, $1
	i32.store	$discard=, 0($pop32), $2
	i32.const	$push10=, 0
	i32.store8	$push11=, 83($44), $pop10
	i32.store8	$push12=, 51($44), $pop11
	i32.store8	$push13=, 82($44), $pop12
	i32.store8	$push14=, 50($44), $pop13
	i32.store8	$push15=, 81($44), $pop14
	i32.store8	$push16=, 49($44), $pop15
	i32.store8	$push17=, 0($4), $pop16
	i32.store8	$1=, 0($8), $pop17
	i32.const	$0=, 15
	i32.const	$23=, 64
	i32.add 	$23=, $44, $23
	i32.or  	$push18=, $23, $0
	i32.store8	$discard=, 0($pop18), $1
	i32.const	$24=, 32
	i32.add 	$24=, $44, $24
	i32.or  	$push19=, $24, $0
	i32.store8	$discard=, 0($pop19), $1
	i32.const	$0=, 14
	i32.const	$25=, 64
	i32.add 	$25=, $44, $25
	i32.or  	$push20=, $25, $0
	i32.store8	$discard=, 0($pop20), $1
	i32.const	$26=, 32
	i32.add 	$26=, $44, $26
	i32.or  	$push21=, $26, $0
	i32.store8	$6=, 0($pop21), $1
	i32.const	$1=, 13
	i32.const	$27=, 64
	i32.add 	$27=, $44, $27
	i32.or  	$push22=, $27, $1
	i32.store8	$discard=, 0($pop22), $6
	i32.const	$28=, 32
	i32.add 	$28=, $44, $28
	i32.or  	$push23=, $28, $1
	i32.store8	$discard=, 0($pop23), $6
	i32.const	$1=, 12
	i32.const	$29=, 64
	i32.add 	$29=, $44, $29
	i32.or  	$push24=, $29, $1
	i32.store8	$discard=, 0($pop24), $6
	i32.const	$30=, 32
	i32.add 	$30=, $44, $30
	i32.or  	$push25=, $30, $1
	i32.store8	$4=, 0($pop25), $6
	i32.const	$6=, 11
	i32.const	$31=, 64
	i32.add 	$31=, $44, $31
	i32.or  	$push26=, $31, $6
	i32.store8	$discard=, 0($pop26), $4
	i32.const	$32=, 32
	i32.add 	$32=, $44, $32
	i32.or  	$push27=, $32, $6
	i32.store8	$discard=, 0($pop27), $4
	i32.const	$6=, 10
	i32.const	$33=, 64
	i32.add 	$33=, $44, $33
	i32.or  	$push28=, $33, $6
	i32.store8	$discard=, 0($pop28), $4
	i32.const	$34=, 32
	i32.add 	$34=, $44, $34
	i32.or  	$push29=, $34, $6
	i32.store8	$discard=, 0($pop29), $4
	i32.const	$35=, 0
	i32.add 	$35=, $44, $35
	i32.add 	$3=, $35, $3
	i64.store	$discard=, 0($3), $5
	i32.const	$36=, 0
	i32.add 	$36=, $44, $36
	i32.or  	$push33=, $36, $6
	i32.store16	$6=, 0($pop33), $4
	i32.const	$push34=, 18
	i32.const	$37=, 0
	i32.add 	$37=, $44, $37
	i32.add 	$push35=, $37, $pop34
	i32.store16	$push36=, 0($pop35), $6
	i32.store16	$3=, 0($3), $pop36
	i32.const	$38=, 0
	i32.add 	$38=, $44, $38
	i32.or  	$push37=, $38, $0
	i32.store16	$0=, 0($pop37), $3
	i32.const	$39=, 0
	i32.add 	$39=, $44, $39
	i32.or  	$push38=, $39, $1
	i32.store16	$1=, 0($pop38), $0
	i32.const	$0=, 30
	i64.store	$discard=, 0($44), $5
	i32.const	$40=, 64
	i32.add 	$40=, $44, $40
	i32.const	$41=, 0
	i32.add 	$41=, $44, $41
	block
	i32.call	$push39=, memcmp@FUNCTION, $40, $41, $0
	br_if   	$pop39, 0       # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$42=, 32
	i32.add 	$42=, $44, $42
	i32.const	$43=, 0
	i32.add 	$43=, $44, $43
	i32.call	$push40=, memcmp@FUNCTION, $42, $43, $0
	br_if   	$pop40, 0       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$11=, 96
	i32.add 	$44=, $44, $11
	i32.const	$11=, __stack_pointer
	i32.store	$44=, 0($11), $44
	return  	$1
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
