	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920501-8.c"
	.section	.text.va,"ax",@progbits
	.hidden	va
	.globl	va
	.type	va,@function
va:                                     # @va
	.param  	i32, f64, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push50=, __stack_pointer
	i32.const	$push47=, __stack_pointer
	i32.load	$push48=, 0($pop47)
	i32.const	$push49=, 80
	i32.sub 	$push54=, $pop48, $pop49
	i32.store	$4=, 0($pop50), $pop54
	i32.store	$push66=, 76($4), $3
	tee_local	$push65=, $3=, $pop66
	i32.const	$push0=, 4
	i32.add 	$push1=, $pop65, $pop0
	i32.store	$drop=, 76($4), $pop1
	i32.load	$5=, 0($3)
	i32.const	$push2=, 8
	i32.add 	$push3=, $3, $pop2
	i32.store	$drop=, 76($4), $pop3
	i32.load	$6=, 4($3)
	i32.const	$push4=, 12
	i32.add 	$push5=, $3, $pop4
	i32.store	$drop=, 76($4), $pop5
	i32.load	$7=, 8($3)
	i32.const	$push6=, 16
	i32.add 	$push7=, $3, $pop6
	i32.store	$drop=, 76($4), $pop7
	i32.load	$8=, 12($3)
	i32.const	$push8=, 20
	i32.add 	$push9=, $3, $pop8
	i32.store	$drop=, 76($4), $pop9
	i32.load	$9=, 16($3)
	i32.const	$push10=, 24
	i32.add 	$push11=, $3, $pop10
	i32.store	$drop=, 76($4), $pop11
	i32.load	$10=, 20($3)
	i32.const	$push12=, 28
	i32.add 	$push13=, $3, $pop12
	i32.store	$drop=, 76($4), $pop13
	i32.load	$11=, 24($3)
	i32.const	$push14=, 32
	i32.add 	$push15=, $3, $pop14
	i32.store	$drop=, 76($4), $pop15
	i32.load	$12=, 28($3)
	i32.const	$push16=, 36
	i32.add 	$push17=, $3, $pop16
	i32.store	$drop=, 76($4), $pop17
	i32.load	$13=, 32($3)
	i32.const	$push18=, 40
	i32.add 	$push19=, $3, $pop18
	i32.store	$drop=, 76($4), $pop19
	i32.load	$14=, 36($3)
	i32.const	$push20=, 44
	i32.add 	$push21=, $3, $pop20
	i32.store	$drop=, 76($4), $pop21
	i32.load	$15=, 40($3)
	i32.const	$push22=, 48
	i32.add 	$push23=, $3, $pop22
	i32.store	$drop=, 76($4), $pop23
	i32.load	$16=, 44($3)
	i32.const	$push24=, 52
	i32.add 	$push25=, $3, $pop24
	i32.store	$drop=, 76($4), $pop25
	i32.const	$push27=, 68
	i32.add 	$push28=, $4, $pop27
	i32.load	$push26=, 48($3)
	i32.store	$drop=, 0($pop28), $pop26
	i32.const	$push29=, 64
	i32.add 	$push30=, $4, $pop29
	i32.store	$drop=, 0($pop30), $16
	i32.const	$push31=, 60
	i32.add 	$push32=, $4, $pop31
	i32.store	$drop=, 0($pop32), $15
	i32.const	$push33=, 56
	i32.add 	$push34=, $4, $pop33
	i32.store	$drop=, 0($pop34), $14
	i32.const	$push64=, 52
	i32.add 	$push35=, $4, $pop64
	i32.store	$drop=, 0($pop35), $13
	i32.const	$push63=, 48
	i32.add 	$push36=, $4, $pop63
	i32.store	$drop=, 0($pop36), $12
	i32.const	$push62=, 44
	i32.add 	$push37=, $4, $pop62
	i32.store	$drop=, 0($pop37), $11
	i32.const	$push61=, 40
	i32.add 	$push38=, $4, $pop61
	i32.store	$drop=, 0($pop38), $10
	i32.const	$push60=, 36
	i32.add 	$push39=, $4, $pop60
	i32.store	$drop=, 0($pop39), $9
	i32.const	$push59=, 32
	i32.add 	$push40=, $4, $pop59
	i32.store	$drop=, 0($pop40), $8
	i32.const	$push58=, 28
	i32.add 	$push41=, $4, $pop58
	i32.store	$drop=, 0($pop41), $7
	i32.const	$push57=, 24
	i32.add 	$push42=, $4, $pop57
	i32.store	$drop=, 0($pop42), $6
	i32.const	$push56=, 20
	i32.add 	$push43=, $4, $pop56
	i32.store	$drop=, 0($pop43), $5
	i32.const	$push55=, 16
	i32.add 	$push44=, $4, $pop55
	i32.store	$drop=, 0($pop44), $2
	f64.store	$drop=, 8($4), $1
	i32.store	$drop=, 0($4), $0
	i32.const	$push46=, buf
	i32.const	$push45=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $pop46, $pop45, $4
	i32.const	$push53=, __stack_pointer
	i32.const	$push51=, 80
	i32.add 	$push52=, $4, $pop51
	i32.store	$drop=, 0($pop53), $pop52
	return  	$4
	.endfunc
.Lfunc_end0:
	.size	va, .Lfunc_end0-va

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push27=, __stack_pointer
	i32.const	$push24=, __stack_pointer
	i32.load	$push25=, 0($pop24)
	i32.const	$push26=, 64
	i32.sub 	$push28=, $pop25, $pop26
	i32.store	$push30=, 0($pop27), $pop28
	tee_local	$push29=, $0=, $pop30
	i32.const	$push0=, 48
	i32.add 	$push1=, $pop29, $pop0
	i32.const	$push2=, 15
	i32.store	$drop=, 0($pop1), $pop2
	i32.const	$push3=, 40
	i32.add 	$push4=, $0, $pop3
	i64.const	$push5=, 60129542157
	i64.store	$drop=, 0($pop4), $pop5
	i32.const	$push6=, 32
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 51539607563
	i64.store	$drop=, 0($pop7), $pop8
	i32.const	$push9=, 24
	i32.add 	$push10=, $0, $pop9
	i64.const	$push11=, 42949672969
	i64.store	$drop=, 0($pop10), $pop11
	i32.const	$push12=, 16
	i32.add 	$push13=, $0, $pop12
	i64.const	$push14=, 34359738375
	i64.store	$drop=, 0($pop13), $pop14
	i64.const	$push15=, 25769803781
	i64.store	$drop=, 8($0), $pop15
	i64.const	$push16=, 17179869187
	i64.store	$drop=, 0($0), $pop16
	i32.const	$push19=, 1
	f64.const	$push18=, 0x1p0
	i32.const	$push17=, 2
	i32.call	$drop=, va@FUNCTION, $pop19, $pop18, $pop17, $0
	block
	i32.const	$push21=, .L.str.1
	i32.const	$push20=, buf
	i32.call	$push22=, strcmp@FUNCTION, $pop21, $pop20
	br_if   	0, $pop22       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push23=, 0
	call    	exit@FUNCTION, $pop23
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.p2align	4
buf:
	.skip	50
	.size	buf, 50

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d,%f,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d"
	.size	.L.str, 48

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"1,1.000000,2,3,4,5,6,7,8,9,10,11,12,13,14,15"
	.size	.L.str.1, 45


	.ident	"clang version 3.9.0 "
