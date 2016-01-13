	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20121108-1.c"
	.section	.text.strtoul1,"ax",@progbits
	.hidden	strtoul1
	.globl	strtoul1
	.type	strtoul1,@function
strtoul1:                               # @strtoul1
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 3
	i32.add 	$push1=, $0, $pop0
	i32.store	$discard=, 0($1), $pop1
	i32.const	$1=, 192
	block
	i32.const	$push2=, temp
	i32.eq  	$push3=, $0, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.else
	i32.const	$1=, 168
	i32.const	$push4=, temp+4
	i32.eq  	$push5=, $0, $pop4
	br_if   	$pop5, 0        # 0: down to label0
# BB#2:                                 # %if.else3
	i32.const	$1=, 190
	i32.const	$push6=, temp+8
	i32.eq  	$push7=, $0, $pop6
	br_if   	$pop7, 0        # 0: down to label0
# BB#3:                                 # %if.else6
	i32.const	$1=, 160
	i32.const	$push8=, temp+12
	i32.eq  	$push9=, $0, $pop8
	br_if   	$pop9, 0        # 0: down to label0
# BB#4:                                 # %if.end11
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %return
	end_block                       # label0:
	return  	$1
.Lfunc_end0:
	.size	strtoul1, .Lfunc_end0-strtoul1

	.section	.text.string_to_ip,"ax",@progbits
	.hidden	string_to_ip
	.globl	string_to_ip
	.type	string_to_ip,@function
string_to_ip:                           # @string_to_ip
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 16
	i32.sub 	$12=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$12=, 0($7), $12
	i32.const	$5=, 0
	block
	i32.const	$push14=, 0
	i32.eq  	$push15=, $0, $pop14
	br_if   	$pop15, 0       # 0: down to label1
# BB#1:                                 # %if.end9
	i32.const	$9=, 12
	i32.add 	$9=, $12, $9
	i32.call	$5=, strtoul1@FUNCTION, $0, $9, $0
	i32.load	$0=, 12($12)
	i32.const	$3=, 1
	i32.load8_u	$push0=, 0($0)
	i32.add 	$push1=, $0, $3
	i32.select	$1=, $pop0, $pop1, $0
	i32.const	$0=, 8
	block
	block
	i32.shl 	$push2=, $5, $0
	i32.const	$push3=, 65280
	i32.and 	$5=, $pop2, $pop3
	i32.const	$push16=, 0
	i32.eq  	$push17=, $1, $pop16
	br_if   	$pop17, 0       # 0: down to label3
# BB#2:                                 # %if.end9.1
	i32.const	$10=, 12
	i32.add 	$10=, $12, $10
	i32.call	$4=, strtoul1@FUNCTION, $1, $10, $0
	i32.load	$1=, 12($12)
	i32.load8_u	$push5=, 0($1)
	i32.add 	$push6=, $1, $3
	i32.select	$2=, $pop5, $pop6, $1
	i32.const	$1=, 255
	i32.and 	$push4=, $4, $1
	i32.or  	$5=, $pop4, $5
	i32.const	$push18=, 0
	i32.eq  	$push19=, $2, $pop18
	br_if   	$pop19, 0       # 0: down to label3
# BB#3:                                 # %if.end9.2
	i32.const	$11=, 12
	i32.add 	$11=, $12, $11
	i32.call	$4=, strtoul1@FUNCTION, $2, $11, $0
	i32.load	$2=, 12($12)
	i32.load8_u	$push9=, 0($2)
	i32.add 	$push10=, $2, $3
	i32.select	$3=, $pop9, $pop10, $2
	i32.and 	$push8=, $4, $1
	i32.shl 	$push7=, $5, $0
	i32.or  	$5=, $pop8, $pop7
	i32.const	$push20=, 0
	i32.eq  	$push21=, $3, $pop20
	br_if   	$pop21, 1       # 1: down to label2
# BB#4:                                 # %if.then3.3
	i32.const	$12=, 12
	i32.add 	$12=, $12, $12
	i32.call	$push11=, strtoul1@FUNCTION, $3, $12, $0
	i32.and 	$push13=, $pop11, $1
	i32.shl 	$push12=, $5, $0
	i32.or  	$5=, $pop13, $pop12
	br      	2               # 2: down to label1
.LBB1_5:                                # %if.end9.2.thread
	end_block                       # label3:
	i32.shl 	$5=, $5, $0
.LBB1_6:                                # %cond.end.3
	end_block                       # label2:
	i32.shl 	$5=, $5, $0
.LBB1_7:                                # %cleanup
	end_block                       # label1:
	i32.const	$8=, 16
	i32.add 	$12=, $12, $8
	i32.const	$8=, __stack_pointer
	i32.store	$12=, 0($8), $12
	return  	$5
.Lfunc_end1:
	.size	string_to_ip, .Lfunc_end1-string_to_ip

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 16
	i32.sub 	$14=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$14=, 0($12), $14
	i32.const	$push0=, temp
	i32.call	$2=, string_to_ip@FUNCTION, $pop0
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 4
	i32.sub 	$14=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$14=, 0($4), $14
	i32.const	$1=, .L.str
	i32.store	$0=, 0($14), $2
	i32.call	$discard=, iprintf@FUNCTION, $1
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 4
	i32.add 	$14=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$14=, 0($6), $14
	i32.const	$2=, 0
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 4
	i32.sub 	$14=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$14=, 0($8), $14
	i32.load	$push1=, result($2)
	i32.store	$discard=, 0($14), $pop1
	i32.call	$discard=, iprintf@FUNCTION, $1
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 4
	i32.add 	$14=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$14=, 0($10), $14
	block
	i32.load	$push2=, result($2)
	i32.ne  	$push3=, $0, $pop2
	br_if   	$pop3, 0        # 0: down to label4
# BB#1:                                 # %if.end
	i32.const	$push4=, .Lstr
	i32.call	$discard=, puts@FUNCTION, $pop4
	i32.const	$13=, 16
	i32.add 	$14=, $14, $13
	i32.const	$13=, __stack_pointer
	i32.store	$14=, 0($13), $14
	return  	$2
.LBB2_2:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	temp                    # @temp
	.type	temp,@object
	.section	.data.temp,"aw",@progbits
	.globl	temp
	.align	4
temp:
	.asciz	"192.168.190.160"
	.size	temp, 16

	.hidden	result                  # @result
	.type	result,@object
	.section	.data.result,"aw",@progbits
	.globl	result
	.align	2
result:
	.int32	3232284320              # 0xc0a8bea0
	.size	result, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%x\n"
	.size	.L.str, 4

	.type	.Lstr,@object           # @str
.Lstr:
	.asciz	"WORKS."
	.size	.Lstr, 7


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
