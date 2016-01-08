	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr29006.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.store8	$1=, 1($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i64.store8	$discard=, 0($pop2), $1
	i32.const	$push3=, 7
	i32.add 	$push4=, $0, $pop3
	i64.store8	$discard=, 0($pop4), $1
	i32.const	$push5=, 6
	i32.add 	$push6=, $0, $pop5
	i64.store8	$discard=, 0($pop6), $1
	i32.const	$push7=, 5
	i32.add 	$push8=, $0, $pop7
	i64.store8	$discard=, 0($pop8), $1
	i32.const	$push9=, 4
	i32.add 	$push10=, $0, $pop9
	i64.store8	$discard=, 0($pop10), $1
	i32.const	$push11=, 3
	i32.add 	$push12=, $0, $pop11
	i64.store8	$discard=, 0($pop12), $1
	i32.const	$push13=, 2
	i32.add 	$push14=, $0, $pop13
	i64.store8	$discard=, 0($pop14), $1
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i64, i32, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 16
	i32.sub 	$18=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$18=, 0($10), $18
	i32.const	$0=, 0
	i32.const	$push1=, 8
	i32.const	$12=, 0
	i32.add 	$12=, $18, $12
	i32.add 	$push2=, $12, $pop1
	i32.load8_u	$push0=, .Lmain.s+8($0)
	i32.store8	$discard=, 0($pop2), $pop0
	i32.const	$1=, .Lmain.s
	i32.const	$2=, 5
	i32.const	$4=, 7
	i32.const	$7=, 3
	i32.const	$8=, 1
	i64.const	$3=, 8
	i64.const	$5=, 16
	i64.const	$6=, 32
	i32.add 	$push10=, $1, $4
	i64.load8_u	$push11=, 0($pop10)
	i64.shl 	$push12=, $pop11, $3
	i32.const	$push13=, 6
	i32.add 	$push14=, $1, $pop13
	i64.load8_u	$push15=, 0($pop14)
	i64.or  	$push16=, $pop12, $pop15
	i64.shl 	$push17=, $pop16, $5
	i32.add 	$push3=, $1, $2
	i64.load8_u	$push4=, 0($pop3)
	i64.shl 	$push5=, $pop4, $3
	i32.const	$push6=, 4
	i32.add 	$push7=, $1, $pop6
	i64.load8_u	$push8=, 0($pop7)
	i64.or  	$push9=, $pop5, $pop8
	i64.or  	$push18=, $pop17, $pop9
	i64.shl 	$push19=, $pop18, $6
	i32.add 	$push20=, $1, $7
	i64.load8_u	$push21=, 0($pop20)
	i64.shl 	$push22=, $pop21, $3
	i32.const	$push23=, 2
	i32.add 	$push24=, $1, $pop23
	i64.load8_u	$push25=, 0($pop24)
	i64.or  	$push26=, $pop22, $pop25
	i64.shl 	$push27=, $pop26, $5
	i32.add 	$push28=, $1, $8
	i64.load8_u	$push29=, 0($pop28)
	i64.shl 	$push30=, $pop29, $3
	i64.load8_u	$push31=, .Lmain.s($0)
	i64.or  	$push32=, $pop30, $pop31
	i64.or  	$push33=, $pop27, $pop32
	i64.or  	$push34=, $pop19, $pop33
	i64.store	$discard=, 0($18), $pop34
	i32.const	$13=, 0
	i32.add 	$13=, $18, $13
	call    	foo, $13
	i32.const	$14=, 0
	i32.add 	$14=, $18, $14
	i32.or  	$1=, $14, $8
	i32.add 	$push54=, $1, $4
	i64.load8_u	$push55=, 0($pop54)
	i64.shl 	$push56=, $pop55, $3
	i32.const	$15=, 0
	i32.add 	$15=, $18, $15
	i32.or  	$push57=, $15, $4
	i64.load8_u	$push58=, 0($pop57)
	i64.or  	$push59=, $pop56, $pop58
	i64.shl 	$push60=, $pop59, $5
	i32.add 	$push48=, $1, $2
	i64.load8_u	$push49=, 0($pop48)
	i64.shl 	$push50=, $pop49, $3
	i32.const	$16=, 0
	i32.add 	$16=, $18, $16
	i32.or  	$push51=, $16, $2
	i64.load8_u	$push52=, 0($pop51)
	i64.or  	$push53=, $pop50, $pop52
	i64.or  	$push61=, $pop60, $pop53
	i64.shl 	$push62=, $pop61, $6
	i32.add 	$push40=, $1, $7
	i64.load8_u	$push41=, 0($pop40)
	i64.shl 	$push42=, $pop41, $3
	i32.const	$17=, 0
	i32.add 	$17=, $18, $17
	i32.or  	$push43=, $17, $7
	i64.load8_u	$push44=, 0($pop43)
	i64.or  	$push45=, $pop42, $pop44
	i64.shl 	$push46=, $pop45, $5
	i32.add 	$push35=, $1, $8
	i64.load8_u	$push36=, 0($pop35)
	i64.shl 	$push37=, $pop36, $3
	i64.load8_u	$push38=, 0($1)
	i64.or  	$push39=, $pop37, $pop38
	i64.or  	$push47=, $pop46, $pop39
	i64.or  	$push63=, $pop62, $pop47
	i64.const	$push64=, 0
	i64.ne  	$push65=, $pop63, $pop64
	i32.const	$11=, 16
	i32.add 	$18=, $18, $11
	i32.const	$11=, __stack_pointer
	i32.store	$18=, 0($11), $18
	return  	$pop65
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.s,@object        # @main.s
	.section	.rodata..Lmain.s,"a",@progbits
.Lmain.s:
	.int8	1                       # 0x1
	.int64	-1                      # 0xffffffffffffffff
	.size	.Lmain.s, 9


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
