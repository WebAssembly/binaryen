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
	i32.store	$drop=, 0($1), $pop1
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push23=, 0
	i32.const	$push20=, 0
	i32.load	$push21=, __stack_pointer($pop20)
	i32.const	$push22=, 16
	i32.sub 	$push35=, $pop21, $pop22
	i32.store	$1=, __stack_pointer($pop23), $pop35
	i32.const	$2=, 0
	block
	i32.eqz 	$push56=, $0
	br_if   	0, $pop56       # 0: down to label2
# BB#1:                                 # %if.end9
	i32.const	$push27=, 12
	i32.add 	$push28=, $1, $pop27
	i32.call	$push0=, strtoul1@FUNCTION, $0, $pop28, $1
	i32.const	$push41=, 8
	i32.shl 	$push3=, $pop0, $pop41
	i32.const	$push4=, 65280
	i32.and 	$0=, $pop3, $pop4
	block
	block
	i32.load	$push40=, 12($1)
	tee_local	$push39=, $2=, $pop40
	i32.const	$push38=, 1
	i32.add 	$push1=, $pop39, $pop38
	i32.load8_u	$push2=, 0($2)
	i32.select	$push37=, $pop1, $2, $pop2
	tee_local	$push36=, $2=, $pop37
	i32.eqz 	$push57=, $pop36
	br_if   	0, $pop57       # 0: down to label4
# BB#2:                                 # %if.end9.1
	i32.const	$push29=, 12
	i32.add 	$push30=, $1, $pop29
	i32.call	$push5=, strtoul1@FUNCTION, $2, $pop30, $1
	i32.const	$push47=, 255
	i32.and 	$push8=, $pop5, $pop47
	i32.or  	$0=, $pop8, $0
	i32.load	$push46=, 12($1)
	tee_local	$push45=, $2=, $pop46
	i32.const	$push44=, 1
	i32.add 	$push6=, $pop45, $pop44
	i32.load8_u	$push7=, 0($2)
	i32.select	$push43=, $pop6, $2, $pop7
	tee_local	$push42=, $2=, $pop43
	i32.eqz 	$push58=, $pop42
	br_if   	0, $pop58       # 0: down to label4
# BB#3:                                 # %if.end9.2
	i32.const	$push31=, 12
	i32.add 	$push32=, $1, $pop31
	i32.call	$push10=, strtoul1@FUNCTION, $2, $pop32, $1
	i32.const	$push53=, 255
	i32.and 	$push11=, $pop10, $pop53
	i32.const	$push52=, 8
	i32.shl 	$push9=, $0, $pop52
	i32.or  	$0=, $pop11, $pop9
	i32.load	$push51=, 12($1)
	tee_local	$push50=, $2=, $pop51
	i32.const	$push12=, 1
	i32.add 	$push13=, $pop50, $pop12
	i32.load8_u	$push14=, 0($2)
	i32.select	$push49=, $pop13, $2, $pop14
	tee_local	$push48=, $2=, $pop49
	i32.eqz 	$push59=, $pop48
	br_if   	1, $pop59       # 1: down to label3
# BB#4:                                 # %if.then3.3
	i32.const	$push33=, 12
	i32.add 	$push34=, $1, $pop33
	i32.call	$push16=, strtoul1@FUNCTION, $2, $pop34, $1
	i32.const	$push17=, 255
	i32.and 	$push18=, $pop16, $pop17
	i32.const	$push54=, 8
	i32.shl 	$push15=, $0, $pop54
	i32.or  	$2=, $pop18, $pop15
	br      	2               # 2: down to label2
.LBB1_5:                                # %if.end9.2.thread
	end_block                       # label4:
	i32.const	$push55=, 8
	i32.shl 	$0=, $0, $pop55
.LBB1_6:                                # %cond.end.3
	end_block                       # label3:
	i32.const	$push19=, 8
	i32.shl 	$2=, $0, $pop19
.LBB1_7:                                # %cleanup
	end_block                       # label2:
	i32.const	$push26=, 0
	i32.const	$push24=, 16
	i32.add 	$push25=, $1, $pop24
	i32.store	$drop=, __stack_pointer($pop26), $pop25
	copy_local	$push60=, $2
                                        # fallthrough-return: $pop60
	.endfunc
.Lfunc_end1:
	.size	string_to_ip, .Lfunc_end1-string_to_ip

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 32
	i32.sub 	$push16=, $pop8, $pop9
	i32.store	$push21=, __stack_pointer($pop10), $pop16
	tee_local	$push20=, $1=, $pop21
	i32.const	$push0=, temp
	i32.call	$push1=, string_to_ip@FUNCTION, $pop0
	i32.store	$0=, 16($pop20), $pop1
	i32.const	$push2=, .L.str
	i32.const	$push14=, 16
	i32.add 	$push15=, $1, $pop14
	i32.call	$drop=, printf@FUNCTION, $pop2, $pop15
	i32.const	$push19=, 0
	i32.load	$push3=, result($pop19)
	i32.store	$drop=, 0($1), $pop3
	i32.const	$push18=, .L.str
	i32.call	$drop=, printf@FUNCTION, $pop18, $1
	block
	i32.const	$push17=, 0
	i32.load	$push4=, result($pop17)
	i32.ne  	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label5
# BB#1:                                 # %if.end
	i32.const	$push6=, .Lstr
	i32.call	$drop=, puts@FUNCTION, $pop6
	i32.const	$push13=, 0
	i32.const	$push11=, 32
	i32.add 	$push12=, $1, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	i32.const	$push22=, 0
	return  	$pop22
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
	.functype	abort, void
	.functype	printf, i32, i32
	.functype	puts, i32, i32
