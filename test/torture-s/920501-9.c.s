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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 32
	i32.sub 	$9=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$9=, 0($5), $9
	i32.wrap/i64	$2=, $0
	block
	block
	i64.const	$push0=, 32
	i64.shr_u	$push1=, $0, $pop0
	i32.wrap/i64	$push7=, $pop1
	tee_local	$push6=, $3=, $pop7
	i32.const	$push8=, 0
	i32.eq  	$push9=, $pop6, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#1:                                 # %if.then
	i32.const	$push2=, 4
	i32.const	$7=, 16
	i32.add 	$7=, $9, $7
	i32.or  	$push3=, $7, $pop2
	i32.store	$discard=, 0($pop3), $2
	i32.store	$discard=, 16($9):p2align=4, $3
	i32.const	$push4=, .L.str
	i32.const	$8=, 16
	i32.add 	$8=, $9, $8
	i32.call	$discard=, sprintf@FUNCTION, $1, $pop4, $8
	br      	1               # 1: down to label0
.LBB5_2:                                # %if.else
	end_block                       # label1:
	i32.store	$discard=, 0($9):p2align=4, $2
	i32.const	$push5=, .L.str.1
	i32.call	$discard=, sprintf@FUNCTION, $1, $pop5, $9
.LBB5_3:                                # %if.end
	end_block                       # label0:
	i32.const	$6=, 32
	i32.add 	$9=, $9, $6
	i32.const	$6=, __stack_pointer
	i32.store	$9=, 0($6), $9
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 192
	i32.sub 	$16=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$16=, 0($1), $16
	i32.const	$push0=, 1
	i32.store	$discard=, 64($16):p2align=4, $pop0
	i32.const	$push17=, .L.str.1
	i32.const	$2=, 80
	i32.add 	$2=, $16, $2
	i32.const	$3=, 64
	i32.add 	$3=, $16, $3
	i32.call	$discard=, sprintf@FUNCTION, $2, $pop17, $3
	i32.const	$push1=, .L.str.2
	i32.const	$4=, 80
	i32.add 	$4=, $16, $4
	block
	block
	block
	block
	block
	i32.call	$push2=, strcmp@FUNCTION, $pop1, $4
	br_if   	0, $pop2        # 0: down to label6
# BB#1:                                 # %if.end
	i32.const	$push3=, 305419896
	i32.store	$discard=, 48($16):p2align=4, $pop3
	i32.const	$push18=, .L.str.1
	i32.const	$5=, 80
	i32.add 	$5=, $16, $5
	i32.const	$6=, 48
	i32.add 	$6=, $16, $6
	i32.call	$discard=, sprintf@FUNCTION, $5, $pop18, $6
	i32.const	$push4=, .L.str.3
	i32.const	$7=, 80
	i32.add 	$7=, $16, $7
	i32.call	$push5=, strcmp@FUNCTION, $pop4, $7
	br_if   	1, $pop5        # 1: down to label5
# BB#2:                                 # %if.end11
	i64.const	$push6=, 1311768467732155613
	i64.store	$discard=, 32($16):p2align=4, $pop6
	i32.const	$push19=, .L.str
	i32.const	$8=, 80
	i32.add 	$8=, $16, $8
	i32.const	$9=, 32
	i32.add 	$9=, $16, $9
	i32.call	$discard=, sprintf@FUNCTION, $8, $pop19, $9
	i32.const	$push7=, .L.str.4
	i32.const	$10=, 80
	i32.add 	$10=, $16, $10
	i32.call	$push8=, strcmp@FUNCTION, $pop7, $10
	br_if   	2, $pop8        # 2: down to label4
# BB#3:                                 # %if.end19
	i64.const	$push9=, -1
	i64.store	$discard=, 16($16):p2align=4, $pop9
	i32.const	$push20=, .L.str
	i32.const	$11=, 80
	i32.add 	$11=, $16, $11
	i32.const	$12=, 16
	i32.add 	$12=, $16, $12
	i32.call	$discard=, sprintf@FUNCTION, $11, $pop20, $12
	i32.const	$push10=, .L.str.5
	i32.const	$13=, 80
	i32.add 	$13=, $16, $13
	i32.call	$push11=, strcmp@FUNCTION, $pop10, $13
	br_if   	3, $pop11       # 3: down to label3
# BB#4:                                 # %if.end27
	i32.const	$push12=, -1430532899
	i32.store	$discard=, 0($16):p2align=4, $pop12
	i32.const	$push13=, .L.str.1
	i32.const	$14=, 80
	i32.add 	$14=, $16, $14
	i32.call	$discard=, sprintf@FUNCTION, $14, $pop13, $16
	i32.const	$push14=, .L.str.6
	i32.const	$15=, 80
	i32.add 	$15=, $16, $15
	i32.call	$push15=, strcmp@FUNCTION, $pop14, $15
	br_if   	4, $pop15       # 4: down to label2
# BB#5:                                 # %if.end35
	i32.const	$push16=, 0
	call    	exit@FUNCTION, $pop16
	unreachable
.LBB6_6:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB6_7:                                # %if.then10
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB6_8:                                # %if.then18
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB6_9:                                # %if.then26
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB6_10:                               # %if.then34
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
