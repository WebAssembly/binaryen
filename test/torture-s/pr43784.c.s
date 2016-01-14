	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43784.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 256
	i32.sub 	$9=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$9=, 0($5), $9
	i32.const	$3=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$0=, v
	i32.add 	$push0=, $0, $3
	i32.store8	$discard=, 0($pop0), $3
	i32.const	$1=, 1
	i32.add 	$3=, $3, $1
	i32.const	$2=, 256
	i32.ne  	$push1=, $3, $2
	br_if   	$pop1, 0        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	i32.const	$7=, 0
	i32.add 	$7=, $9, $7
	call    	rp@FUNCTION, $7
	i32.const	$push2=, v+4
	i32.const	$8=, 0
	i32.add 	$8=, $9, $8
	call    	memcpy@FUNCTION, $pop2, $8, $2
	i32.const	$3=, 0
.LBB0_3:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.add 	$push3=, $0, $3
	i32.const	$push4=, 4
	i32.add 	$push5=, $pop3, $pop4
	i32.load8_u	$push6=, 0($pop5)
	i32.ne  	$push7=, $3, $pop6
	br_if   	$pop7, 2        # 2: down to label2
# BB#4:                                 # %for.cond1
                                        #   in Loop: Header=BB0_3 Depth=1
	i32.add 	$3=, $3, $1
	i32.const	$push8=, 255
	i32.le_s	$push9=, $3, $pop8
	br_if   	$pop9, 0        # 0: up to label3
# BB#5:                                 # %for.end12
	end_loop                        # label4:
	i32.const	$push10=, 0
	i32.const	$6=, 256
	i32.add 	$9=, $9, $6
	i32.const	$6=, __stack_pointer
	i32.store	$9=, 0($6), $9
	return  	$pop10
.LBB0_6:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.rp,"ax",@progbits
	.type	rp,@function
rp:                                     # @rp
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, v
	i32.const	$push1=, 256
	call    	memcpy@FUNCTION, $0, $pop0, $pop1
	return
	.endfunc
.Lfunc_end1:
	.size	rp, .Lfunc_end1-rp

	.type	v,@object               # @v
	.lcomm	v,260,2

	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
