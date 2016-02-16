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
	block
	i32.const	$push2=, temp
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %if.else
	i32.const	$1=, 168
	i32.const	$push4=, temp+4
	i32.eq  	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label1
# BB#2:                                 # %if.else3
	i32.const	$1=, 190
	i32.const	$push6=, temp+8
	i32.eq  	$push7=, $0, $pop6
	br_if   	0, $pop7        # 0: down to label1
# BB#3:                                 # %if.else6
	i32.const	$1=, 160
	i32.const	$push8=, temp+12
	i32.ne  	$push9=, $0, $pop8
	br_if   	1, $pop9        # 1: down to label0
.LBB0_4:                                # %return
	end_block                       # label1:
	return  	$1
.LBB0_5:                                # %if.end11
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	strtoul1, .Lfunc_end0-strtoul1

	.section	.text.string_to_ip,"ax",@progbits
	.hidden	string_to_ip
	.globl	string_to_ip
	.type	string_to_ip,@function
string_to_ip:                           # @string_to_ip
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$9=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$9=, 0($3), $9
	i32.const	$1=, 0
	block
	i32.const	$push40=, 0
	i32.eq  	$push41=, $0, $pop40
	br_if   	0, $pop41       # 0: down to label2
# BB#1:                                 # %if.end9
	i32.const	$5=, 12
	i32.add 	$5=, $9, $5
	i32.call	$push0=, strtoul1@FUNCTION, $0, $5, $0
	i32.const	$push25=, 8
	i32.shl 	$push3=, $pop0, $pop25
	i32.const	$push4=, 65280
	i32.and 	$0=, $pop3, $pop4
	block
	block
	i32.load	$push24=, 12($9)
	tee_local	$push23=, $1=, $pop24
	i32.const	$push22=, 1
	i32.add 	$push2=, $pop23, $pop22
	i32.load8_u	$push1=, 0($1)
	i32.select	$push21=, $pop2, $1, $pop1
	tee_local	$push20=, $1=, $pop21
	i32.const	$push42=, 0
	i32.eq  	$push43=, $pop20, $pop42
	br_if   	0, $pop43       # 0: down to label4
# BB#2:                                 # %if.end9.1
	i32.const	$6=, 12
	i32.add 	$6=, $9, $6
	i32.call	$push5=, strtoul1@FUNCTION, $1, $6, $0
	i32.const	$push31=, 255
	i32.and 	$push6=, $pop5, $pop31
	i32.or  	$0=, $pop6, $0
	i32.load	$push30=, 12($9)
	tee_local	$push29=, $1=, $pop30
	i32.const	$push28=, 1
	i32.add 	$push8=, $pop29, $pop28
	i32.load8_u	$push7=, 0($1)
	i32.select	$push27=, $pop8, $1, $pop7
	tee_local	$push26=, $1=, $pop27
	i32.const	$push44=, 0
	i32.eq  	$push45=, $pop26, $pop44
	br_if   	0, $pop45       # 0: down to label4
# BB#3:                                 # %if.end9.2
	i32.const	$7=, 12
	i32.add 	$7=, $9, $7
	i32.call	$push9=, strtoul1@FUNCTION, $1, $7, $0
	i32.const	$push38=, 255
	i32.and 	$push11=, $pop9, $pop38
	i32.const	$push37=, 8
	i32.shl 	$push10=, $0, $pop37
	i32.or  	$0=, $pop11, $pop10
	i32.load	$push36=, 12($9)
	tee_local	$push35=, $1=, $pop36
	i32.const	$push13=, 1
	i32.add 	$push14=, $pop35, $pop13
	i32.load8_u	$push12=, 0($1)
	i32.select	$push34=, $pop14, $1, $pop12
	tee_local	$push33=, $1=, $pop34
	i32.const	$push46=, 0
	i32.eq  	$push47=, $pop33, $pop46
	br_if   	1, $pop47       # 1: down to label3
# BB#4:                                 # %if.then3.3
	i32.const	$8=, 12
	i32.add 	$8=, $9, $8
	i32.call	$push15=, strtoul1@FUNCTION, $1, $8, $0
	i32.const	$push17=, 255
	i32.and 	$push18=, $pop15, $pop17
	i32.const	$push39=, 8
	i32.shl 	$push16=, $0, $pop39
	i32.or  	$1=, $pop18, $pop16
	br      	2               # 2: down to label2
.LBB1_5:                                # %if.end9.2.thread
	end_block                       # label4:
	i32.const	$push32=, 8
	i32.shl 	$0=, $0, $pop32
.LBB1_6:                                # %cond.end.3
	end_block                       # label3:
	i32.const	$push19=, 8
	i32.shl 	$1=, $0, $pop19
.LBB1_7:                                # %cleanup
	end_block                       # label2:
	i32.const	$4=, 16
	i32.add 	$9=, $9, $4
	i32.const	$4=, __stack_pointer
	i32.store	$9=, 0($4), $9
	return  	$1
	.endfunc
.Lfunc_end1:
	.size	string_to_ip, .Lfunc_end1-string_to_ip

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 32
	i32.sub 	$5=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	i32.const	$push0=, temp
	i32.call	$push1=, string_to_ip@FUNCTION, $pop0
	i32.store	$0=, 16($5):p2align=4, $pop1
	i32.const	$push2=, .L.str
	i32.const	$4=, 16
	i32.add 	$4=, $5, $4
	i32.call	$discard=, printf@FUNCTION, $pop2, $4
	i32.const	$push9=, 0
	i32.load	$push3=, result($pop9)
	i32.store	$discard=, 0($5):p2align=4, $pop3
	i32.const	$push8=, .L.str
	i32.call	$discard=, printf@FUNCTION, $pop8, $5
	block
	i32.const	$push7=, 0
	i32.load	$push4=, result($pop7)
	i32.ne  	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label5
# BB#1:                                 # %if.end
	i32.const	$push6=, .Lstr
	i32.call	$discard=, puts@FUNCTION, $pop6
	i32.const	$push10=, 0
	i32.const	$3=, 32
	i32.add 	$5=, $5, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	return  	$pop10
.LBB2_2:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	temp                    # @temp
	.type	temp,@object
	.section	.data.temp,"aw",@progbits
	.globl	temp
	.p2align	4
temp:
	.asciz	"192.168.190.160"
	.size	temp, 16

	.hidden	result                  # @result
	.type	result,@object
	.section	.data.result,"aw",@progbits
	.globl	result
	.p2align	2
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


	.ident	"clang version 3.9.0 "
