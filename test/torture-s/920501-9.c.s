	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920501-9.c"
	.section	.text.proc1,"ax",@progbits
	.hidden	proc1
	.globl	proc1
	.type	proc1,@function
proc1:                                  # @proc1
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	proc1, .Lfunc_end0-proc1

	.section	.text.proc2,"ax",@progbits
	.hidden	proc2
	.globl	proc2
	.type	proc2,@function
proc2:                                  # @proc2
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 305419896
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	proc2, .Lfunc_end1-proc2

	.section	.text.proc3,"ax",@progbits
	.hidden	proc3
	.globl	proc3
	.type	proc3,@function
proc3:                                  # @proc3
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, -6144092016751651208
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	proc3, .Lfunc_end2-proc3

	.section	.text.proc4,"ax",@progbits
	.hidden	proc4
	.globl	proc4
	.type	proc4,@function
proc4:                                  # @proc4
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, -1
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	proc4, .Lfunc_end3-proc4

	.section	.text.proc5,"ax",@progbits
	.hidden	proc5
	.globl	proc5
	.type	proc5,@function
proc5:                                  # @proc5
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 2864434397
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	proc5, .Lfunc_end4-proc5

	.section	.text.print_longlong,"ax",@progbits
	.hidden	print_longlong
	.globl	print_longlong
	.type	print_longlong,@function
print_longlong:                         # @print_longlong
	.param  	i64, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$12=, __stack_pointer
	i32.load	$12=, 0($12)
	i32.const	$13=, 16
	i32.sub 	$15=, $12, $13
	i32.const	$13=, __stack_pointer
	i32.store	$15=, 0($13), $15
	i32.wrap/i64	$2=, $0
	block
	block
	i64.const	$push1=, 32
	i64.shr_u	$push2=, $0, $pop1
	i32.wrap/i64	$push0=, $pop2
	tee_local	$push6=, $3=, $pop0
	i32.const	$push7=, 0
	i32.eq  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label1
# BB#1:                                 # %if.then
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 8
	i32.sub 	$15=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$15=, 0($5), $15
	i32.store	$discard=, 0($15), $3
	i32.const	$push3=, 4
	i32.add 	$3=, $15, $pop3
	i32.store	$discard=, 0($3), $2
	i32.const	$push4=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $1, $pop4
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 8
	i32.add 	$15=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$15=, 0($7), $15
	br      	1               # 1: down to label0
.LBB5_2:                                # %if.else
	end_block                       # label1:
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 4
	i32.sub 	$15=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$15=, 0($9), $15
	i32.store	$discard=, 0($15), $2
	i32.const	$push5=, .L.str.1
	i32.call	$discard=, sprintf@FUNCTION, $1, $pop5
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 4
	i32.add 	$15=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$15=, 0($11), $15
.LBB5_3:                                # %if.end
	end_block                       # label0:
	i32.const	$14=, 16
	i32.add 	$15=, $15, $14
	i32.const	$14=, __stack_pointer
	i32.store	$15=, 0($14), $15
	return  	$1
	.endfunc
.Lfunc_end5:
	.size	print_longlong, .Lfunc_end5-print_longlong

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$21=, __stack_pointer
	i32.load	$21=, 0($21)
	i32.const	$22=, 128
	i32.sub 	$33=, $21, $22
	i32.const	$22=, __stack_pointer
	i32.store	$33=, 0($22), $33
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 4
	i32.sub 	$33=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$33=, 0($2), $33
	i32.const	$push0=, 1
	i32.store	$discard=, 0($33), $pop0
	i32.const	$push12=, .L.str.1
	i32.const	$23=, 16
	i32.add 	$23=, $33, $23
	i32.call	$discard=, sprintf@FUNCTION, $23, $pop12
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 4
	i32.add 	$33=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$33=, 0($4), $33
	i32.const	$push1=, .L.str.2
	i32.const	$24=, 16
	i32.add 	$24=, $33, $24
	i32.call	$0=, strcmp@FUNCTION, $pop1, $24
	block
	br_if   	0, $0           # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 4
	i32.sub 	$33=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$33=, 0($6), $33
	i32.const	$push2=, 305419896
	i32.store	$discard=, 0($33), $pop2
	i32.const	$push13=, .L.str.1
	i32.const	$25=, 16
	i32.add 	$25=, $33, $25
	i32.call	$discard=, sprintf@FUNCTION, $25, $pop13
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 4
	i32.add 	$33=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$33=, 0($8), $33
	i32.const	$push3=, .L.str.3
	i32.const	$26=, 16
	i32.add 	$26=, $33, $26
	i32.call	$0=, strcmp@FUNCTION, $pop3, $26
	block
	br_if   	0, $0           # 0: down to label3
# BB#2:                                 # %if.end11
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 8
	i32.sub 	$33=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$33=, 0($10), $33
	i64.const	$push4=, 1311768467732155613
	i64.store	$discard=, 0($33):p2align=2, $pop4
	i32.const	$push14=, .L.str
	i32.const	$27=, 16
	i32.add 	$27=, $33, $27
	i32.call	$discard=, sprintf@FUNCTION, $27, $pop14
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 8
	i32.add 	$33=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$33=, 0($12), $33
	i32.const	$push5=, .L.str.4
	i32.const	$28=, 16
	i32.add 	$28=, $33, $28
	i32.call	$0=, strcmp@FUNCTION, $pop5, $28
	block
	br_if   	0, $0           # 0: down to label4
# BB#3:                                 # %if.end19
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 8
	i32.sub 	$33=, $13, $14
	i32.const	$14=, __stack_pointer
	i32.store	$33=, 0($14), $33
	i64.const	$push6=, -1
	i64.store	$discard=, 0($33):p2align=2, $pop6
	i32.const	$push15=, .L.str
	i32.const	$29=, 16
	i32.add 	$29=, $33, $29
	i32.call	$discard=, sprintf@FUNCTION, $29, $pop15
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 8
	i32.add 	$33=, $15, $16
	i32.const	$16=, __stack_pointer
	i32.store	$33=, 0($16), $33
	i32.const	$push7=, .L.str.5
	i32.const	$30=, 16
	i32.add 	$30=, $33, $30
	i32.call	$0=, strcmp@FUNCTION, $pop7, $30
	block
	br_if   	0, $0           # 0: down to label5
# BB#4:                                 # %if.end27
	i32.const	$17=, __stack_pointer
	i32.load	$17=, 0($17)
	i32.const	$18=, 4
	i32.sub 	$33=, $17, $18
	i32.const	$18=, __stack_pointer
	i32.store	$33=, 0($18), $33
	i32.const	$push8=, -1430532899
	i32.store	$discard=, 0($33), $pop8
	i32.const	$push9=, .L.str.1
	i32.const	$31=, 16
	i32.add 	$31=, $33, $31
	i32.call	$discard=, sprintf@FUNCTION, $31, $pop9
	i32.const	$19=, __stack_pointer
	i32.load	$19=, 0($19)
	i32.const	$20=, 4
	i32.add 	$33=, $19, $20
	i32.const	$20=, __stack_pointer
	i32.store	$33=, 0($20), $33
	i32.const	$push10=, .L.str.6
	i32.const	$32=, 16
	i32.add 	$32=, $33, $32
	i32.call	$0=, strcmp@FUNCTION, $pop10, $32
	block
	br_if   	0, $0           # 0: down to label6
# BB#5:                                 # %if.end35
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
.LBB6_6:                                # %if.then34
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB6_7:                                # %if.then26
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB6_8:                                # %if.then18
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB6_9:                                # %if.then10
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB6_10:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	main, .Lfunc_end6-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%lx%08.lx"
	.size	.L.str, 10

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"%lx"
	.size	.L.str.1, 4

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"1"
	.size	.L.str.2, 2

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"12345678"
	.size	.L.str.3, 9

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"aabbccdd12345678"
	.size	.L.str.4, 17

	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"ffffffffffffffff"
	.size	.L.str.5, 17

	.type	.L.str.6,@object        # @.str.6
.L.str.6:
	.asciz	"aabbccdd"
	.size	.L.str.6, 9


	.ident	"clang version 3.9.0 "
