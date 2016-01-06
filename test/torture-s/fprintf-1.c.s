	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/fprintf-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$47=, __stack_pointer
	i32.load	$47=, 0($47)
	i32.const	$48=, 16
	i32.sub 	$50=, $47, $48
	i32.const	$48=, __stack_pointer
	i32.store	$50=, 0($48), $50
	i32.const	$0=, 0
	i32.const	$1=, .str
	i32.const	$2=, 1
	i32.const	$3=, 5
	block   	BB0_22
	i32.load	$push0=, stdout($0)
	i32.call	$discard=, fwrite, $1, $3, $2, $pop0
	i32.load	$push1=, stdout($0)
	i32.call	$4=, fiprintf, $pop1, $1
	i32.ne  	$push2=, $4, $3
	br_if   	$pop2, BB0_22
# BB#1:                                 # %if.end
	i32.const	$4=, .str.1
	i32.const	$5=, 6
	block   	BB0_21
	i32.load	$push3=, stdout($0)
	i32.call	$discard=, fwrite, $4, $5, $2, $pop3
	i32.load	$push4=, stdout($0)
	i32.call	$10=, fiprintf, $pop4, $4
	i32.ne  	$push5=, $10, $5
	br_if   	$pop5, BB0_21
# BB#2:                                 # %if.end6
	i32.const	$6=, 97
	i32.load	$push6=, stdout($0)
	i32.call	$discard=, fputc, $6, $pop6
	i32.const	$7=, .str.2
	block   	BB0_20
	i32.load	$push7=, stdout($0)
	i32.call	$10=, fiprintf, $pop7, $7
	i32.ne  	$push8=, $10, $2
	br_if   	$pop8, BB0_20
# BB#3:                                 # %if.end11
	i32.const	$8=, .str.3
	block   	BB0_19
	i32.load	$push9=, stdout($0)
	i32.call	$10=, fiprintf, $pop9, $8
	br_if   	$10, BB0_19
# BB#4:                                 # %if.end16
	i32.load	$push10=, stdout($0)
	i32.call	$discard=, fwrite, $1, $3, $2, $pop10
	i32.load	$9=, stdout($0)
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 4
	i32.sub 	$50=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$50=, 0($12), $50
	i32.const	$10=, .str.4
	i32.store	$discard=, 0($50), $1
	i32.call	$1=, fiprintf, $9, $10
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 4
	i32.add 	$50=, $13, $14
	i32.const	$14=, __stack_pointer
	i32.store	$50=, 0($14), $50
	block   	BB0_18
	i32.ne  	$push11=, $1, $3
	br_if   	$pop11, BB0_18
# BB#5:                                 # %if.end21
	i32.load	$push12=, stdout($0)
	i32.call	$discard=, fwrite, $4, $5, $2, $pop12
	i32.load	$1=, stdout($0)
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 4
	i32.sub 	$50=, $15, $16
	i32.const	$16=, __stack_pointer
	i32.store	$50=, 0($16), $50
	i32.store	$3=, 0($50), $4
	i32.call	$1=, fiprintf, $1, $10
	i32.const	$17=, __stack_pointer
	i32.load	$17=, 0($17)
	i32.const	$18=, 4
	i32.add 	$50=, $17, $18
	i32.const	$18=, __stack_pointer
	i32.store	$50=, 0($18), $50
	block   	BB0_17
	i32.ne  	$push13=, $1, $5
	br_if   	$pop13, BB0_17
# BB#6:                                 # %if.end26
	i32.load	$push14=, stdout($0)
	i32.call	$discard=, fputc, $6, $pop14
	i32.load	$1=, stdout($0)
	i32.const	$19=, __stack_pointer
	i32.load	$19=, 0($19)
	i32.const	$20=, 4
	i32.sub 	$50=, $19, $20
	i32.const	$20=, __stack_pointer
	i32.store	$50=, 0($20), $50
	i32.store	$discard=, 0($50), $7
	i32.call	$1=, fiprintf, $1, $10
	i32.const	$21=, __stack_pointer
	i32.load	$21=, 0($21)
	i32.const	$22=, 4
	i32.add 	$50=, $21, $22
	i32.const	$22=, __stack_pointer
	i32.store	$50=, 0($22), $50
	block   	BB0_16
	i32.ne  	$push15=, $1, $2
	br_if   	$pop15, BB0_16
# BB#7:                                 # %if.end31
	i32.load	$1=, stdout($0)
	i32.const	$23=, __stack_pointer
	i32.load	$23=, 0($23)
	i32.const	$24=, 4
	i32.sub 	$50=, $23, $24
	i32.const	$24=, __stack_pointer
	i32.store	$50=, 0($24), $50
	i32.store	$discard=, 0($50), $8
	i32.call	$1=, fiprintf, $1, $10
	i32.const	$25=, __stack_pointer
	i32.load	$25=, 0($25)
	i32.const	$26=, 4
	i32.add 	$50=, $25, $26
	i32.const	$26=, __stack_pointer
	i32.store	$50=, 0($26), $50
	block   	BB0_15
	br_if   	$1, BB0_15
# BB#8:                                 # %if.end36
	i32.const	$1=, 120
	i32.load	$push16=, stdout($0)
	i32.call	$discard=, fputc, $1, $pop16
	i32.load	$4=, stdout($0)
	i32.const	$27=, __stack_pointer
	i32.load	$27=, 0($27)
	i32.const	$28=, 4
	i32.sub 	$50=, $27, $28
	i32.const	$28=, __stack_pointer
	i32.store	$50=, 0($28), $50
	i32.store	$discard=, 0($50), $1
	i32.const	$push17=, .str.5
	i32.call	$1=, fiprintf, $4, $pop17
	i32.const	$29=, __stack_pointer
	i32.load	$29=, 0($29)
	i32.const	$30=, 4
	i32.add 	$50=, $29, $30
	i32.const	$30=, __stack_pointer
	i32.store	$50=, 0($30), $50
	block   	BB0_14
	i32.ne  	$push18=, $1, $2
	br_if   	$pop18, BB0_14
# BB#9:                                 # %if.end41
	i32.load	$1=, stdout($0)
	i32.const	$31=, __stack_pointer
	i32.load	$31=, 0($31)
	i32.const	$32=, 4
	i32.sub 	$50=, $31, $32
	i32.const	$32=, __stack_pointer
	i32.store	$50=, 0($32), $50
	i32.const	$2=, .str.6
	i32.store	$discard=, 0($50), $3
	i32.call	$discard=, fiprintf, $1, $2
	i32.const	$33=, __stack_pointer
	i32.load	$33=, 0($33)
	i32.const	$34=, 4
	i32.add 	$50=, $33, $34
	i32.const	$34=, __stack_pointer
	i32.store	$50=, 0($34), $50
	i32.load	$1=, stdout($0)
	i32.const	$35=, __stack_pointer
	i32.load	$35=, 0($35)
	i32.const	$36=, 4
	i32.sub 	$50=, $35, $36
	i32.const	$36=, __stack_pointer
	i32.store	$50=, 0($36), $50
	i32.store	$discard=, 0($50), $3
	i32.call	$2=, fiprintf, $1, $2
	i32.const	$37=, __stack_pointer
	i32.load	$37=, 0($37)
	i32.const	$38=, 4
	i32.add 	$50=, $37, $38
	i32.const	$38=, __stack_pointer
	i32.store	$50=, 0($38), $50
	block   	BB0_13
	i32.const	$push19=, 7
	i32.ne  	$push20=, $2, $pop19
	br_if   	$pop20, BB0_13
# BB#10:                                # %if.end46
	i32.load	$1=, stdout($0)
	i32.const	$39=, __stack_pointer
	i32.load	$39=, 0($39)
	i32.const	$40=, 4
	i32.sub 	$50=, $39, $40
	i32.const	$40=, __stack_pointer
	i32.store	$50=, 0($40), $50
	i32.const	$2=, .str.7
	i32.store	$discard=, 0($50), $0
	i32.call	$discard=, fiprintf, $1, $2
	i32.const	$41=, __stack_pointer
	i32.load	$41=, 0($41)
	i32.const	$42=, 4
	i32.add 	$50=, $41, $42
	i32.const	$42=, __stack_pointer
	i32.store	$50=, 0($42), $50
	i32.load	$1=, stdout($0)
	i32.const	$43=, __stack_pointer
	i32.load	$43=, 0($43)
	i32.const	$44=, 4
	i32.sub 	$50=, $43, $44
	i32.const	$44=, __stack_pointer
	i32.store	$50=, 0($44), $50
	i32.store	$3=, 0($50), $0
	i32.call	$0=, fiprintf, $1, $2
	i32.const	$45=, __stack_pointer
	i32.load	$45=, 0($45)
	i32.const	$46=, 4
	i32.add 	$50=, $45, $46
	i32.const	$46=, __stack_pointer
	i32.store	$50=, 0($46), $50
	block   	BB0_12
	i32.const	$push21=, 2
	i32.ne  	$push22=, $0, $pop21
	br_if   	$pop22, BB0_12
# BB#11:                                # %if.end51
	i32.const	$49=, 16
	i32.add 	$50=, $50, $49
	i32.const	$49=, __stack_pointer
	i32.store	$50=, 0($49), $50
	return  	$3
BB0_12:                                 # %if.then50
	call    	abort
	unreachable
BB0_13:                                 # %if.then45
	call    	abort
	unreachable
BB0_14:                                 # %if.then40
	call    	abort
	unreachable
BB0_15:                                 # %if.then35
	call    	abort
	unreachable
BB0_16:                                 # %if.then30
	call    	abort
	unreachable
BB0_17:                                 # %if.then25
	call    	abort
	unreachable
BB0_18:                                 # %if.then20
	call    	abort
	unreachable
BB0_19:                                 # %if.then15
	call    	abort
	unreachable
BB0_20:                                 # %if.then10
	call    	abort
	unreachable
BB0_21:                                 # %if.then5
	call    	abort
	unreachable
BB0_22:                                 # %if.then
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"hello"
	.size	.str, 6

	.type	.str.1,@object          # @.str.1
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


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
