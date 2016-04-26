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
	i32.const	$push59=, __stack_pointer
	i32.load	$push60=, 0($pop59)
	i32.const	$push61=, 80
	i32.sub 	$16=, $pop60, $pop61
	i32.const	$push62=, __stack_pointer
	i32.store	$discard=, 0($pop62), $16
	i32.store	$push58=, 76($16), $3
	tee_local	$push57=, $3=, $pop58
	i32.const	$push0=, 4
	i32.add 	$push1=, $pop57, $pop0
	i32.store	$discard=, 76($16), $pop1
	i32.load	$4=, 0($3)
	i32.const	$push2=, 8
	i32.add 	$push3=, $3, $pop2
	i32.store	$discard=, 76($16), $pop3
	i32.load	$5=, 4($3)
	i32.const	$push4=, 12
	i32.add 	$push5=, $3, $pop4
	i32.store	$discard=, 76($16), $pop5
	i32.load	$6=, 8($3)
	i32.const	$push6=, 16
	i32.add 	$push7=, $3, $pop6
	i32.store	$discard=, 76($16), $pop7
	i32.load	$7=, 12($3)
	i32.const	$push8=, 20
	i32.add 	$push9=, $3, $pop8
	i32.store	$discard=, 76($16), $pop9
	i32.load	$8=, 16($3)
	i32.const	$push10=, 24
	i32.add 	$push11=, $3, $pop10
	i32.store	$discard=, 76($16), $pop11
	i32.load	$9=, 20($3)
	i32.const	$push12=, 28
	i32.add 	$push13=, $3, $pop12
	i32.store	$discard=, 76($16), $pop13
	i32.load	$10=, 24($3)
	i32.const	$push14=, 32
	i32.add 	$push15=, $3, $pop14
	i32.store	$discard=, 76($16), $pop15
	i32.load	$11=, 28($3)
	i32.const	$push16=, 36
	i32.add 	$push17=, $3, $pop16
	i32.store	$discard=, 76($16), $pop17
	i32.load	$12=, 32($3)
	i32.const	$push18=, 40
	i32.add 	$push19=, $3, $pop18
	i32.store	$discard=, 76($16), $pop19
	i32.load	$13=, 36($3)
	i32.const	$push20=, 44
	i32.add 	$push21=, $3, $pop20
	i32.store	$discard=, 76($16), $pop21
	i32.load	$14=, 40($3)
	i32.const	$push22=, 48
	i32.add 	$push23=, $3, $pop22
	i32.store	$discard=, 76($16), $pop23
	i32.load	$15=, 44($3)
	i32.const	$push24=, 52
	i32.add 	$push25=, $3, $pop24
	i32.store	$discard=, 76($16), $pop25
	i32.const	$push27=, 68
	i32.add 	$push28=, $16, $pop27
	i32.load	$push26=, 48($3)
	i32.store	$discard=, 0($pop28), $pop26
	i32.const	$push29=, 64
	i32.add 	$push30=, $16, $pop29
	i32.store	$discard=, 0($pop30), $15
	i32.const	$push31=, 60
	i32.add 	$push32=, $16, $pop31
	i32.store	$discard=, 0($pop32), $14
	i32.const	$push33=, 56
	i32.add 	$push34=, $16, $pop33
	i32.store	$discard=, 0($pop34), $13
	i32.const	$push56=, 52
	i32.add 	$push35=, $16, $pop56
	i32.store	$discard=, 0($pop35), $12
	i32.const	$push55=, 48
	i32.add 	$push36=, $16, $pop55
	i32.store	$discard=, 0($pop36), $11
	i32.const	$push54=, 44
	i32.add 	$push37=, $16, $pop54
	i32.store	$discard=, 0($pop37), $10
	i32.const	$push53=, 40
	i32.add 	$push38=, $16, $pop53
	i32.store	$discard=, 0($pop38), $9
	i32.const	$push52=, 36
	i32.add 	$push39=, $16, $pop52
	i32.store	$discard=, 0($pop39), $8
	i32.const	$push51=, 32
	i32.add 	$push40=, $16, $pop51
	i32.store	$discard=, 0($pop40), $7
	i32.const	$push50=, 28
	i32.add 	$push41=, $16, $pop50
	i32.store	$discard=, 0($pop41), $6
	i32.const	$push49=, 24
	i32.add 	$push42=, $16, $pop49
	i32.store	$discard=, 0($pop42), $5
	i32.const	$push48=, 20
	i32.add 	$push43=, $16, $pop48
	i32.store	$discard=, 0($pop43), $4
	i32.const	$push47=, 16
	i32.add 	$push44=, $16, $pop47
	i32.store	$discard=, 0($pop44), $2
	f64.store	$discard=, 8($16), $1
	i32.store	$discard=, 0($16), $0
	i32.const	$push46=, buf
	i32.const	$push45=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $pop46, $pop45, $16
	i32.const	$push65=, __stack_pointer
	i32.const	$push63=, 80
	i32.add 	$push64=, $16, $pop63
	i32.store	$discard=, 0($pop65), $pop64
	return  	$3
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
	i32.const	$push24=, __stack_pointer
	i32.load	$push25=, 0($pop24)
	i32.const	$push26=, 64
	i32.sub 	$0=, $pop25, $pop26
	i32.const	$push27=, __stack_pointer
	i32.store	$discard=, 0($pop27), $0
	i32.const	$push0=, 48
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 15
	i32.store	$discard=, 0($pop1), $pop2
	i32.const	$push3=, 40
	i32.add 	$push4=, $0, $pop3
	i64.const	$push5=, 60129542157
	i64.store	$discard=, 0($pop4), $pop5
	i32.const	$push6=, 32
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 51539607563
	i64.store	$discard=, 0($pop7), $pop8
	i32.const	$push9=, 24
	i32.add 	$push10=, $0, $pop9
	i64.const	$push11=, 42949672969
	i64.store	$discard=, 0($pop10), $pop11
	i32.const	$push12=, 16
	i32.add 	$push13=, $0, $pop12
	i64.const	$push14=, 34359738375
	i64.store	$discard=, 0($pop13), $pop14
	i64.const	$push15=, 25769803781
	i64.store	$discard=, 8($0), $pop15
	i64.const	$push16=, 17179869187
	i64.store	$discard=, 0($0), $pop16
	i32.const	$push19=, 1
	f64.const	$push18=, 0x1p0
	i32.const	$push17=, 2
	i32.call	$discard=, va@FUNCTION, $pop19, $pop18, $pop17, $0
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
