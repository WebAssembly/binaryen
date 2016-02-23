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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push40=, __stack_pointer
	i32.load	$push41=, 0($pop40)
	i32.const	$push42=, 16
	i32.sub 	$6=, $pop41, $pop42
	i32.const	$push43=, __stack_pointer
	i32.store	$discard=, 0($pop43), $6
	i32.const	$1=, 0
	block
	i32.const	$push46=, 0
	i32.eq  	$push47=, $0, $pop46
	br_if   	0, $pop47       # 0: down to label2
# BB#1:                                 # %if.end9
	i32.const	$2=, 12
	i32.add 	$2=, $6, $2
	i32.call	$push0=, strtoul1@FUNCTION, $0, $2, $0
	i32.const	$push25=, 8
	i32.shl 	$push3=, $pop0, $pop25
	i32.const	$push4=, 65280
	i32.and 	$0=, $pop3, $pop4
	block
	block
	i32.load	$push24=, 12($6)
	tee_local	$push23=, $1=, $pop24
	i32.const	$push22=, 1
	i32.add 	$push2=, $pop23, $pop22
	i32.load8_u	$push1=, 0($1)
	i32.select	$push21=, $pop2, $1, $pop1
	tee_local	$push20=, $1=, $pop21
	i32.const	$push48=, 0
	i32.eq  	$push49=, $pop20, $pop48
	br_if   	0, $pop49       # 0: down to label4
# BB#2:                                 # %if.end9.1
	i32.const	$3=, 12
	i32.add 	$3=, $6, $3
	i32.call	$push5=, strtoul1@FUNCTION, $1, $3, $0
	i32.const	$push31=, 255
	i32.and 	$push6=, $pop5, $pop31
	i32.or  	$0=, $pop6, $0
	i32.load	$push30=, 12($6)
	tee_local	$push29=, $1=, $pop30
	i32.const	$push28=, 1
	i32.add 	$push8=, $pop29, $pop28
	i32.load8_u	$push7=, 0($1)
	i32.select	$push27=, $pop8, $1, $pop7
	tee_local	$push26=, $1=, $pop27
	i32.const	$push50=, 0
	i32.eq  	$push51=, $pop26, $pop50
	br_if   	0, $pop51       # 0: down to label4
# BB#3:                                 # %if.end9.2
	i32.const	$4=, 12
	i32.add 	$4=, $6, $4
	i32.call	$push9=, strtoul1@FUNCTION, $1, $4, $0
	i32.const	$push38=, 255
	i32.and 	$push11=, $pop9, $pop38
	i32.const	$push37=, 8
	i32.shl 	$push10=, $0, $pop37
	i32.or  	$0=, $pop11, $pop10
	i32.load	$push36=, 12($6)
	tee_local	$push35=, $1=, $pop36
	i32.const	$push13=, 1
	i32.add 	$push14=, $pop35, $pop13
	i32.load8_u	$push12=, 0($1)
	i32.select	$push34=, $pop14, $1, $pop12
	tee_local	$push33=, $1=, $pop34
	i32.const	$push52=, 0
	i32.eq  	$push53=, $pop33, $pop52
	br_if   	1, $pop53       # 1: down to label3
# BB#4:                                 # %if.then3.3
	i32.const	$5=, 12
	i32.add 	$5=, $6, $5
	i32.call	$push15=, strtoul1@FUNCTION, $1, $5, $0
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
	i32.const	$push44=, 16
	i32.add 	$6=, $6, $pop44
	i32.const	$push45=, __stack_pointer
	i32.store	$discard=, 0($pop45), $6
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push11=, __stack_pointer
	i32.load	$push12=, 0($pop11)
	i32.const	$push13=, 32
	i32.sub 	$2=, $pop12, $pop13
	i32.const	$push14=, __stack_pointer
	i32.store	$discard=, 0($pop14), $2
	i32.const	$push0=, temp
	i32.call	$push1=, string_to_ip@FUNCTION, $pop0
	i32.store	$0=, 16($2):p2align=4, $pop1
	i32.const	$push2=, .L.str
	i32.const	$1=, 16
	i32.add 	$1=, $2, $1
	i32.call	$discard=, printf@FUNCTION, $pop2, $1
	i32.const	$push9=, 0
	i32.load	$push3=, result($pop9)
	i32.store	$discard=, 0($2):p2align=4, $pop3
	i32.const	$push8=, .L.str
	i32.call	$discard=, printf@FUNCTION, $pop8, $2
	block
	i32.const	$push7=, 0
	i32.load	$push4=, result($pop7)
	i32.ne  	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label5
# BB#1:                                 # %if.end
	i32.const	$push6=, .Lstr
	i32.call	$discard=, puts@FUNCTION, $pop6
	i32.const	$push10=, 0
	i32.const	$push15=, 32
	i32.add 	$2=, $2, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $2
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
