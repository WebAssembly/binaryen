	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/printf-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$55=, __stack_pointer
	i32.load	$55=, 0($55)
	i32.const	$56=, 16
	i32.sub 	$58=, $55, $56
	i32.const	$56=, __stack_pointer
	i32.store	$58=, 0($56), $58
	i32.const	$0=, str
	i32.call	$discard=, iprintf, $0
	i32.call	$6=, iprintf, $0
	i32.const	$1=, 5
	block   	BB0_20
	i32.ne  	$push0=, $6, $1
	br_if   	$pop0, BB0_20
# BB#1:                                 # %if.end
	i32.call	$discard=, puts, $0
	i32.const	$2=, .str.1
	i32.call	$6=, iprintf, $2
	i32.const	$3=, 6
	block   	BB0_19
	i32.ne  	$push1=, $6, $3
	br_if   	$pop1, BB0_19
# BB#2:                                 # %if.end6
	i32.const	$push2=, 97
	i32.call	$discard=, putchar, $pop2
	i32.const	$4=, .str.2
	i32.call	$6=, iprintf, $4
	i32.const	$5=, 1
	block   	BB0_18
	i32.ne  	$push3=, $6, $5
	br_if   	$pop3, BB0_18
# BB#3:                                 # %if.end16
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 4
	i32.sub 	$58=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$58=, 0($8), $58
	i32.const	$6=, .str.4
	i32.store	$discard=, 0($58), $0
	i32.call	$discard=, iprintf, $6
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 4
	i32.add 	$58=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$58=, 0($10), $58
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 4
	i32.sub 	$58=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$58=, 0($12), $58
	i32.store	$discard=, 0($58), $0
	i32.call	$0=, iprintf, $6
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 4
	i32.add 	$58=, $13, $14
	i32.const	$14=, __stack_pointer
	i32.store	$58=, 0($14), $58
	block   	BB0_17
	i32.ne  	$push4=, $0, $1
	br_if   	$pop4, BB0_17
# BB#4:                                 # %if.end21
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 4
	i32.sub 	$58=, $15, $16
	i32.const	$16=, __stack_pointer
	i32.store	$58=, 0($16), $58
	i32.store	$0=, 0($58), $2
	i32.call	$discard=, iprintf, $6
	i32.const	$17=, __stack_pointer
	i32.load	$17=, 0($17)
	i32.const	$18=, 4
	i32.add 	$58=, $17, $18
	i32.const	$18=, __stack_pointer
	i32.store	$58=, 0($18), $58
	i32.const	$19=, __stack_pointer
	i32.load	$19=, 0($19)
	i32.const	$20=, 4
	i32.sub 	$58=, $19, $20
	i32.const	$20=, __stack_pointer
	i32.store	$58=, 0($20), $58
	i32.store	$discard=, 0($58), $0
	i32.call	$1=, iprintf, $6
	i32.const	$21=, __stack_pointer
	i32.load	$21=, 0($21)
	i32.const	$22=, 4
	i32.add 	$58=, $21, $22
	i32.const	$22=, __stack_pointer
	i32.store	$58=, 0($22), $58
	block   	BB0_16
	i32.ne  	$push5=, $1, $3
	br_if   	$pop5, BB0_16
# BB#5:                                 # %if.end26
	i32.const	$23=, __stack_pointer
	i32.load	$23=, 0($23)
	i32.const	$24=, 4
	i32.sub 	$58=, $23, $24
	i32.const	$24=, __stack_pointer
	i32.store	$58=, 0($24), $58
	i32.store	$1=, 0($58), $4
	i32.call	$discard=, iprintf, $6
	i32.const	$25=, __stack_pointer
	i32.load	$25=, 0($25)
	i32.const	$26=, 4
	i32.add 	$58=, $25, $26
	i32.const	$26=, __stack_pointer
	i32.store	$58=, 0($26), $58
	i32.const	$27=, __stack_pointer
	i32.load	$27=, 0($27)
	i32.const	$28=, 4
	i32.sub 	$58=, $27, $28
	i32.const	$28=, __stack_pointer
	i32.store	$58=, 0($28), $58
	i32.store	$discard=, 0($58), $1
	i32.call	$1=, iprintf, $6
	i32.const	$29=, __stack_pointer
	i32.load	$29=, 0($29)
	i32.const	$30=, 4
	i32.add 	$58=, $29, $30
	i32.const	$30=, __stack_pointer
	i32.store	$58=, 0($30), $58
	block   	BB0_15
	i32.ne  	$push6=, $1, $5
	br_if   	$pop6, BB0_15
# BB#6:                                 # %if.end31
	i32.const	$31=, __stack_pointer
	i32.load	$31=, 0($31)
	i32.const	$32=, 4
	i32.sub 	$58=, $31, $32
	i32.const	$32=, __stack_pointer
	i32.store	$58=, 0($32), $58
	i32.const	$push7=, .str.3
	i32.store	$1=, 0($58), $pop7
	i32.call	$discard=, iprintf, $6
	i32.const	$33=, __stack_pointer
	i32.load	$33=, 0($33)
	i32.const	$34=, 4
	i32.add 	$58=, $33, $34
	i32.const	$34=, __stack_pointer
	i32.store	$58=, 0($34), $58
	i32.const	$35=, __stack_pointer
	i32.load	$35=, 0($35)
	i32.const	$36=, 4
	i32.sub 	$58=, $35, $36
	i32.const	$36=, __stack_pointer
	i32.store	$58=, 0($36), $58
	i32.store	$discard=, 0($58), $1
	i32.call	$6=, iprintf, $6
	i32.const	$37=, __stack_pointer
	i32.load	$37=, 0($37)
	i32.const	$38=, 4
	i32.add 	$58=, $37, $38
	i32.const	$38=, __stack_pointer
	i32.store	$58=, 0($38), $58
	block   	BB0_14
	br_if   	$6, BB0_14
# BB#7:                                 # %if.end36
	i32.const	$6=, 120
	i32.call	$discard=, putchar, $6
	i32.const	$39=, __stack_pointer
	i32.load	$39=, 0($39)
	i32.const	$40=, 4
	i32.sub 	$58=, $39, $40
	i32.const	$40=, __stack_pointer
	i32.store	$58=, 0($40), $58
	i32.store	$discard=, 0($58), $6
	i32.const	$push8=, .str.5
	i32.call	$6=, iprintf, $pop8
	i32.const	$41=, __stack_pointer
	i32.load	$41=, 0($41)
	i32.const	$42=, 4
	i32.add 	$58=, $41, $42
	i32.const	$42=, __stack_pointer
	i32.store	$58=, 0($42), $58
	block   	BB0_13
	i32.ne  	$push9=, $6, $5
	br_if   	$pop9, BB0_13
# BB#8:                                 # %if.end41
	i32.call	$discard=, puts, $0
	i32.const	$43=, __stack_pointer
	i32.load	$43=, 0($43)
	i32.const	$44=, 4
	i32.sub 	$58=, $43, $44
	i32.const	$44=, __stack_pointer
	i32.store	$58=, 0($44), $58
	i32.store	$discard=, 0($58), $0
	i32.const	$push10=, .str.6
	i32.call	$6=, iprintf, $pop10
	i32.const	$45=, __stack_pointer
	i32.load	$45=, 0($45)
	i32.const	$46=, 4
	i32.add 	$58=, $45, $46
	i32.const	$46=, __stack_pointer
	i32.store	$58=, 0($46), $58
	block   	BB0_12
	i32.const	$push11=, 7
	i32.ne  	$push12=, $6, $pop11
	br_if   	$pop12, BB0_12
# BB#9:                                 # %if.end46
	i32.const	$47=, __stack_pointer
	i32.load	$47=, 0($47)
	i32.const	$48=, 4
	i32.sub 	$58=, $47, $48
	i32.const	$48=, __stack_pointer
	i32.store	$58=, 0($48), $58
	i32.const	$6=, .str.7
	i32.const	$push13=, 0
	i32.store	$0=, 0($58), $pop13
	i32.call	$discard=, iprintf, $6
	i32.const	$49=, __stack_pointer
	i32.load	$49=, 0($49)
	i32.const	$50=, 4
	i32.add 	$58=, $49, $50
	i32.const	$50=, __stack_pointer
	i32.store	$58=, 0($50), $58
	i32.const	$51=, __stack_pointer
	i32.load	$51=, 0($51)
	i32.const	$52=, 4
	i32.sub 	$58=, $51, $52
	i32.const	$52=, __stack_pointer
	i32.store	$58=, 0($52), $58
	i32.store	$discard=, 0($58), $0
	i32.call	$6=, iprintf, $6
	i32.const	$53=, __stack_pointer
	i32.load	$53=, 0($53)
	i32.const	$54=, 4
	i32.add 	$58=, $53, $54
	i32.const	$54=, __stack_pointer
	i32.store	$58=, 0($54), $58
	block   	BB0_11
	i32.const	$push14=, 2
	i32.ne  	$push15=, $6, $pop14
	br_if   	$pop15, BB0_11
# BB#10:                                # %if.end51
	i32.const	$57=, 16
	i32.add 	$58=, $58, $57
	i32.const	$57=, __stack_pointer
	i32.store	$58=, 0($57), $58
	return  	$0
BB0_11:                                 # %if.then50
	call    	abort
	unreachable
BB0_12:                                 # %if.then45
	call    	abort
	unreachable
BB0_13:                                 # %if.then40
	call    	abort
	unreachable
BB0_14:                                 # %if.then35
	call    	abort
	unreachable
BB0_15:                                 # %if.then30
	call    	abort
	unreachable
BB0_16:                                 # %if.then25
	call    	abort
	unreachable
BB0_17:                                 # %if.then20
	call    	abort
	unreachable
BB0_18:                                 # %if.then10
	call    	abort
	unreachable
BB0_19:                                 # %if.then5
	call    	abort
	unreachable
BB0_20:                                 # %if.then
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	.str.1,@object          # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.str.1:
	.asciz	"hello\n"
	.size	.str.1, 7

	.type	.str.2,@object          # @.str.2
.str.2:
	.asciz	"a"
	.size	.str.2, 2

	.type	.str.3,@object          # @.str.3
.str.3:
	.zero	1
	.size	.str.3, 1

	.type	.str.4,@object          # @.str.4
.str.4:
	.asciz	"%s"
	.size	.str.4, 3

	.type	.str.5,@object          # @.str.5
.str.5:
	.asciz	"%c"
	.size	.str.5, 3

	.type	.str.6,@object          # @.str.6
.str.6:
	.asciz	"%s\n"
	.size	.str.6, 4

	.type	.str.7,@object          # @.str.7
.str.7:
	.asciz	"%d\n"
	.size	.str.7, 4

	.type	str,@object             # @str
str:
	.asciz	"hello"
	.size	str, 6


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
