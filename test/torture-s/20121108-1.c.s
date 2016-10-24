	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20121108-1.c"
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
	i32.store	0($1), $pop1
	block   	
	block   	
	block   	
	block   	
	i32.const	$push2=, temp
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label3
# BB#1:                                 # %if.else
	i32.const	$push4=, temp+4
	i32.eq  	$push5=, $0, $pop4
	br_if   	2, $pop5        # 2: down to label1
# BB#2:                                 # %if.else3
	i32.const	$push6=, temp+8
	i32.eq  	$push7=, $0, $pop6
	br_if   	3, $pop7        # 3: down to label0
# BB#3:                                 # %if.else6
	i32.const	$1=, 160
	i32.const	$push8=, temp+12
	i32.eq  	$push9=, $0, $pop8
	br_if   	1, $pop9        # 1: down to label2
# BB#4:                                 # %if.end11
	call    	abort@FUNCTION
	unreachable
.LBB0_5:
	end_block                       # label3:
	i32.const	$1=, 192
.LBB0_6:                                # %return
	end_block                       # label2:
	return  	$1
.LBB0_7:
	end_block                       # label1:
	i32.const	$push11=, 168
	return  	$pop11
.LBB0_8:
	end_block                       # label0:
	i32.const	$push10=, 190
                                        # fallthrough-return: $pop10
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
	i32.sub 	$push36=, $pop21, $pop22
	tee_local	$push35=, $2=, $pop36
	i32.store	__stack_pointer($pop23), $pop35
	block   	
	block   	
	block   	
	block   	
	i32.eqz 	$push57=, $0
	br_if   	0, $pop57       # 0: down to label7
# BB#1:                                 # %if.end9
	i32.const	$push27=, 12
	i32.add 	$push28=, $2, $pop27
	i32.call	$push0=, strtoul1@FUNCTION, $0, $pop28, $2
	i32.const	$push42=, 8
	i32.shl 	$push3=, $pop0, $pop42
	i32.const	$push4=, 65280
	i32.and 	$0=, $pop3, $pop4
	i32.load	$push41=, 12($2)
	tee_local	$push40=, $1=, $pop41
	i32.const	$push39=, 1
	i32.add 	$push1=, $pop40, $pop39
	i32.load8_u	$push2=, 0($1)
	i32.select	$push38=, $pop1, $1, $pop2
	tee_local	$push37=, $1=, $pop38
	i32.eqz 	$push58=, $pop37
	br_if   	1, $pop58       # 1: down to label6
# BB#2:                                 # %if.end9.1
	i32.const	$push29=, 12
	i32.add 	$push30=, $2, $pop29
	i32.call	$push5=, strtoul1@FUNCTION, $1, $pop30, $2
	i32.const	$push48=, 255
	i32.and 	$push8=, $pop5, $pop48
	i32.or  	$0=, $pop8, $0
	i32.load	$push47=, 12($2)
	tee_local	$push46=, $1=, $pop47
	i32.const	$push45=, 1
	i32.add 	$push6=, $pop46, $pop45
	i32.load8_u	$push7=, 0($1)
	i32.select	$push44=, $pop6, $1, $pop7
	tee_local	$push43=, $1=, $pop44
	i32.eqz 	$push59=, $pop43
	br_if   	1, $pop59       # 1: down to label6
# BB#3:                                 # %if.end9.2
	i32.const	$push31=, 12
	i32.add 	$push32=, $2, $pop31
	i32.call	$push10=, strtoul1@FUNCTION, $1, $pop32, $2
	i32.const	$push54=, 255
	i32.and 	$push11=, $pop10, $pop54
	i32.const	$push53=, 8
	i32.shl 	$push9=, $0, $pop53
	i32.or  	$0=, $pop11, $pop9
	i32.load	$push52=, 12($2)
	tee_local	$push51=, $1=, $pop52
	i32.const	$push12=, 1
	i32.add 	$push13=, $pop51, $pop12
	i32.load8_u	$push14=, 0($1)
	i32.select	$push50=, $pop13, $1, $pop14
	tee_local	$push49=, $1=, $pop50
	i32.eqz 	$push60=, $pop49
	br_if   	2, $pop60       # 2: down to label5
# BB#4:                                 # %if.then3.3
	i32.const	$push33=, 12
	i32.add 	$push34=, $2, $pop33
	i32.call	$push16=, strtoul1@FUNCTION, $1, $pop34, $2
	i32.const	$push17=, 255
	i32.and 	$push18=, $pop16, $pop17
	i32.const	$push55=, 8
	i32.shl 	$push15=, $0, $pop55
	i32.or  	$0=, $pop18, $pop15
	br      	3               # 3: down to label4
.LBB1_5:
	end_block                       # label7:
	i32.const	$0=, 0
	br      	2               # 2: down to label4
.LBB1_6:                                # %if.end9.2.thread
	end_block                       # label6:
	i32.const	$push56=, 8
	i32.shl 	$0=, $0, $pop56
.LBB1_7:                                # %cond.end.3
	end_block                       # label5:
	i32.const	$push19=, 8
	i32.shl 	$0=, $0, $pop19
.LBB1_8:                                # %cleanup
	end_block                       # label4:
	i32.const	$push26=, 0
	i32.const	$push24=, 16
	i32.add 	$push25=, $2, $pop24
	i32.store	__stack_pointer($pop26), $pop25
	copy_local	$push61=, $0
                                        # fallthrough-return: $pop61
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
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 32
	i32.sub 	$push21=, $pop7, $pop8
	tee_local	$push20=, $1=, $pop21
	i32.store	__stack_pointer($pop9), $pop20
	i32.const	$push0=, temp
	i32.call	$push19=, string_to_ip@FUNCTION, $pop0
	tee_local	$push18=, $0=, $pop19
	i32.store	16($1), $pop18
	i32.const	$push1=, .L.str
	i32.const	$push13=, 16
	i32.add 	$push14=, $1, $pop13
	i32.call	$drop=, printf@FUNCTION, $pop1, $pop14
	i32.const	$push17=, 0
	i32.load	$push2=, result($pop17)
	i32.store	0($1), $pop2
	i32.const	$push16=, .L.str
	i32.call	$drop=, printf@FUNCTION, $pop16, $1
	block   	
	i32.const	$push15=, 0
	i32.load	$push3=, result($pop15)
	i32.ne  	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label8
# BB#1:                                 # %if.end
	i32.const	$push5=, .Lstr
	i32.call	$drop=, puts@FUNCTION, $pop5
	i32.const	$push12=, 0
	i32.const	$push10=, 32
	i32.add 	$push11=, $1, $pop10
	i32.store	__stack_pointer($pop12), $pop11
	i32.const	$push22=, 0
	return  	$pop22
.LBB2_2:                                # %if.then
	end_block                       # label8:
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	printf, i32, i32
	.functype	puts, i32, i32
