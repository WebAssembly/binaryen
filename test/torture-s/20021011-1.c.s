	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021011-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, .L.str
	i32.const	$1=, buf
	i32.const	$2=, 9
	call    	memcpy@FUNCTION, $1, $0, $2
	block
	i32.call	$push0=, strcmp@FUNCTION, $1, $0
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	call    	memcpy@FUNCTION, $1, $0, $2
	block
	i32.call	$push1=, strcmp@FUNCTION, $1, $0
	br_if   	$pop1, 0        # 0: down to label1
# BB#2:                                 # %for.cond
	i32.const	$1=, buf+1
	call    	memcpy@FUNCTION, $1, $0, $2
	i32.call	$push2=, strcmp@FUNCTION, $1, $0
	br_if   	$pop2, 0        # 0: down to label1
# BB#3:                                 # %for.cond.1
	i32.const	$1=, buf+2
	call    	memcpy@FUNCTION, $1, $0, $2
	i32.call	$push3=, strcmp@FUNCTION, $1, $0
	br_if   	$pop3, 0        # 0: down to label1
# BB#4:                                 # %for.cond.2
	i32.const	$1=, buf+3
	call    	memcpy@FUNCTION, $1, $0, $2
	i32.call	$push4=, strcmp@FUNCTION, $1, $0
	br_if   	$pop4, 0        # 0: down to label1
# BB#5:                                 # %for.cond.3
	i32.const	$1=, buf+4
	call    	memcpy@FUNCTION, $1, $0, $2
	i32.call	$push5=, strcmp@FUNCTION, $1, $0
	br_if   	$pop5, 0        # 0: down to label1
# BB#6:                                 # %for.cond.4
	i32.const	$1=, buf+5
	call    	memcpy@FUNCTION, $1, $0, $2
	i32.call	$push6=, strcmp@FUNCTION, $1, $0
	br_if   	$pop6, 0        # 0: down to label1
# BB#7:                                 # %for.cond.5
	i32.const	$1=, buf+6
	call    	memcpy@FUNCTION, $1, $0, $2
	i32.call	$push7=, strcmp@FUNCTION, $1, $0
	br_if   	$pop7, 0        # 0: down to label1
# BB#8:                                 # %for.cond.6
	i32.const	$1=, buf+7
	call    	memcpy@FUNCTION, $1, $0, $2
	i32.call	$push8=, strcmp@FUNCTION, $1, $0
	br_if   	$pop8, 0        # 0: down to label1
# BB#9:                                 # %for.cond.7
	i32.const	$1=, buf+8
	call    	memcpy@FUNCTION, $1, $0, $2
	i32.call	$push9=, strcmp@FUNCTION, $1, $0
	br_if   	$pop9, 0        # 0: down to label1
# BB#10:                                # %for.cond.8
	i32.const	$1=, buf+9
	call    	memcpy@FUNCTION, $1, $0, $2
	i32.call	$push10=, strcmp@FUNCTION, $1, $0
	br_if   	$pop10, 0       # 0: down to label1
# BB#11:                                # %for.cond.9
	i32.const	$1=, buf+10
	call    	memcpy@FUNCTION, $1, $0, $2
	i32.call	$push11=, strcmp@FUNCTION, $1, $0
	br_if   	$pop11, 0       # 0: down to label1
# BB#12:                                # %for.cond.10
	i32.const	$1=, buf+11
	call    	memcpy@FUNCTION, $1, $0, $2
	i32.call	$push12=, strcmp@FUNCTION, $1, $0
	br_if   	$pop12, 0       # 0: down to label1
# BB#13:                                # %for.cond.11
	i32.const	$1=, buf+12
	call    	memcpy@FUNCTION, $1, $0, $2
	i32.call	$push13=, strcmp@FUNCTION, $1, $0
	br_if   	$pop13, 0       # 0: down to label1
# BB#14:                                # %for.cond.12
	i32.const	$1=, buf+13
	call    	memcpy@FUNCTION, $1, $0, $2
	i32.call	$push14=, strcmp@FUNCTION, $1, $0
	br_if   	$pop14, 0       # 0: down to label1
# BB#15:                                # %for.cond.13
	i32.const	$1=, buf+14
	call    	memcpy@FUNCTION, $1, $0, $2
	i32.call	$push15=, strcmp@FUNCTION, $1, $0
	br_if   	$pop15, 0       # 0: down to label1
# BB#16:                                # %for.cond.14
	i32.const	$1=, buf+15
	call    	memcpy@FUNCTION, $1, $0, $2
	i32.call	$push16=, strcmp@FUNCTION, $1, $0
	br_if   	$pop16, 0       # 0: down to label1
# BB#17:                                # %for.cond.15
	i32.const	$push17=, 0
	return  	$pop17
.LBB0_18:                               # %if.then7
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_19:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.align	4
buf:
	.skip	64
	.size	buf, 64

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"mystring"
	.size	.L.str, 9


	.ident	"clang version 3.9.0 "
