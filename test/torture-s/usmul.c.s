	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/usmul.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.mul 	$push0=, $1, $0
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.mul 	$push0=, $1, $0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 65535
	i32.const	$1=, -2
	i32.call	$2=, foo@FUNCTION, $1, $0
	i32.const	$3=, -131070
	block
	i32.ne  	$push0=, $2, $3
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$2=, 2
	i32.call	$4=, foo@FUNCTION, $2, $0
	i32.const	$5=, 131070
	block
	i32.ne  	$push1=, $4, $5
	br_if   	$pop1, 0        # 0: down to label1
# BB#2:                                 # %if.end4
	i32.const	$4=, 32768
	i32.const	$6=, -32768
	i32.call	$7=, foo@FUNCTION, $6, $4
	i32.const	$8=, -1073741824
	block
	i32.ne  	$push2=, $7, $8
	br_if   	$pop2, 0        # 0: down to label2
# BB#3:                                 # %if.end8
	i32.const	$7=, 32767
	i32.call	$9=, foo@FUNCTION, $7, $4
	i32.const	$10=, 1073709056
	block
	i32.ne  	$push3=, $9, $10
	br_if   	$pop3, 0        # 0: down to label3
# BB#4:                                 # %if.end12
	block
	i32.call	$push4=, bar@FUNCTION, $0, $1
	i32.ne  	$push5=, $pop4, $3
	br_if   	$pop5, 0        # 0: down to label4
# BB#5:                                 # %if.end16
	block
	i32.call	$push6=, bar@FUNCTION, $0, $2
	i32.ne  	$push7=, $pop6, $5
	br_if   	$pop7, 0        # 0: down to label5
# BB#6:                                 # %if.end20
	block
	i32.call	$push8=, bar@FUNCTION, $4, $6
	i32.ne  	$push9=, $pop8, $8
	br_if   	$pop9, 0        # 0: down to label6
# BB#7:                                 # %if.end24
	block
	i32.call	$push10=, bar@FUNCTION, $4, $7
	i32.ne  	$push11=, $pop10, $10
	br_if   	$pop11, 0       # 0: down to label7
# BB#8:                                 # %if.end28
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
	unreachable
.LBB2_9:                                # %if.then27
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB2_10:                               # %if.then23
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB2_11:                               # %if.then19
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB2_12:                               # %if.then15
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB2_13:                               # %if.then11
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB2_14:                               # %if.then7
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB2_15:                               # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB2_16:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
