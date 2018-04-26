	.text
	.file	"20121108-1.c"
	.section	.text.strtoul1,"ax",@progbits
	.hidden	strtoul1                # -- Begin function strtoul1
	.globl	strtoul1
	.type	strtoul1,@function
strtoul1:                               # @strtoul1
	.param  	i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
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
# %bb.1:                                # %if.else
	i32.const	$push4=, temp+4
	i32.eq  	$push5=, $0, $pop4
	br_if   	1, $pop5        # 1: down to label2
# %bb.2:                                # %if.else3
	i32.const	$push6=, temp+8
	i32.eq  	$push7=, $0, $pop6
	br_if   	2, $pop7        # 2: down to label1
# %bb.3:                                # %if.else6
	i32.const	$push8=, temp+12
	i32.ne  	$push9=, $0, $pop8
	br_if   	3, $pop9        # 3: down to label0
# %bb.4:                                # %return
	i32.const	$push13=, 160
	return  	$pop13
.LBB0_5:
	end_block                       # label3:
	i32.const	$push12=, 192
	return  	$pop12
.LBB0_6:
	end_block                       # label2:
	i32.const	$push11=, 168
	return  	$pop11
.LBB0_7:
	end_block                       # label1:
	i32.const	$push10=, 190
	return  	$pop10
.LBB0_8:                                # %if.end11
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	strtoul1, .Lfunc_end0-strtoul1
                                        # -- End function
	.section	.text.string_to_ip,"ax",@progbits
	.hidden	string_to_ip            # -- Begin function string_to_ip
	.globl	string_to_ip
	.type	string_to_ip,@function
string_to_ip:                           # @string_to_ip
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push17=, 0
	i32.load	$push16=, __stack_pointer($pop17)
	i32.const	$push18=, 16
	i32.sub 	$3=, $pop16, $pop18
	i32.const	$push19=, 0
	i32.store	__stack_pointer($pop19), $3
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	i32.eqz 	$push39=, $0
	br_if   	0, $pop39       # 0: down to label11
# %bb.1:                                # %if.end9
	i32.const	$push23=, 12
	i32.add 	$push24=, $3, $pop23
	i32.call	$1=, strtoul1@FUNCTION, $0, $pop24, $3
	i32.load	$0=, 12($3)
	i32.const	$push32=, 1
	i32.add 	$push0=, $0, $pop32
	i32.load8_u	$push1=, 0($0)
	i32.select	$2=, $pop0, $0, $pop1
	i32.const	$push31=, 8
	i32.shl 	$push2=, $1, $pop31
	i32.const	$push3=, 65280
	i32.and 	$0=, $pop2, $pop3
	i32.eqz 	$push40=, $2
	br_if   	3, $pop40       # 3: down to label8
# %bb.2:                                # %if.then3.1
	i32.const	$push25=, 12
	i32.add 	$push26=, $3, $pop25
	i32.call	$1=, strtoul1@FUNCTION, $2, $pop26, $3
	i32.load	$2=, 12($3)
	i32.const	$push33=, 255
	i32.and 	$push4=, $1, $pop33
	i32.or  	$0=, $pop4, $0
	i32.load8_u	$push5=, 0($2)
	i32.eqz 	$push41=, $pop5
	br_if   	1, $pop41       # 1: down to label10
# %bb.3:
	i32.const	$push34=, 1
	i32.add 	$2=, $2, $pop34
	br      	2               # 2: down to label9
.LBB1_4:
	end_block                       # label11:
	i32.const	$0=, 0
	br      	6               # 6: down to label4
.LBB1_5:                                # %if.end9.1
	end_block                       # label10:
	i32.eqz 	$push42=, $2
	br_if   	1, $pop42       # 1: down to label8
.LBB1_6:                                # %if.then3.2
	end_block                       # label9:
	i32.const	$push27=, 12
	i32.add 	$push28=, $3, $pop27
	i32.call	$push7=, strtoul1@FUNCTION, $2, $pop28, $3
	i32.const	$push36=, 255
	i32.and 	$push8=, $pop7, $pop36
	i32.const	$push35=, 8
	i32.shl 	$push6=, $0, $pop35
	i32.or  	$2=, $pop8, $pop6
	i32.load	$0=, 12($3)
	i32.load8_u	$push10=, 0($0)
	i32.eqz 	$push43=, $pop10
	br_if   	1, $pop43       # 1: down to label7
# %bb.7:
	i32.const	$push9=, 1
	i32.add 	$0=, $0, $pop9
	br      	2               # 2: down to label6
.LBB1_8:                                # %if.end9.2.thread
	end_block                       # label8:
	i32.const	$push37=, 8
	i32.shl 	$2=, $0, $pop37
	br      	2               # 2: down to label5
.LBB1_9:                                # %if.end9.2
	end_block                       # label7:
	i32.eqz 	$push44=, $0
	br_if   	1, $pop44       # 1: down to label5
.LBB1_10:                               # %if.then3.3
	end_block                       # label6:
	i32.const	$push29=, 12
	i32.add 	$push30=, $3, $pop29
	i32.call	$push12=, strtoul1@FUNCTION, $0, $pop30, $3
	i32.const	$push13=, 255
	i32.and 	$push14=, $pop12, $pop13
	i32.const	$push38=, 8
	i32.shl 	$push11=, $2, $pop38
	i32.or  	$0=, $pop14, $pop11
	br      	1               # 1: down to label4
.LBB1_11:                               # %cond.end.3
	end_block                       # label5:
	i32.const	$push15=, 8
	i32.shl 	$0=, $2, $pop15
.LBB1_12:                               # %cleanup
	end_block                       # label4:
	i32.const	$push22=, 0
	i32.const	$push20=, 16
	i32.add 	$push21=, $3, $pop20
	i32.store	__stack_pointer($pop22), $pop21
	copy_local	$push45=, $0
                                        # fallthrough-return: $pop45
	.endfunc
.Lfunc_end1:
	.size	string_to_ip, .Lfunc_end1-string_to_ip
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 32
	i32.sub 	$1=, $pop6, $pop8
	i32.const	$push9=, 0
	i32.store	__stack_pointer($pop9), $1
	i32.const	$push0=, temp
	i32.call	$0=, string_to_ip@FUNCTION, $pop0
	i32.store	16($1), $0
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
	br_if   	0, $pop4        # 0: down to label12
# %bb.1:                                # %if.end
	i32.const	$push5=, .Lstr
	i32.call	$drop=, puts@FUNCTION, $pop5
	i32.const	$push12=, 0
	i32.const	$push10=, 32
	i32.add 	$push11=, $1, $pop10
	i32.store	__stack_pointer($pop12), $pop11
	i32.const	$push18=, 0
	return  	$pop18
.LBB2_2:                                # %if.then
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	printf, i32, i32
	.functype	puts, i32, i32
