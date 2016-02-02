	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000605-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %for.body.lr.ph.i
	i32.const	$0=, 0
.LBB0_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push5=, 1
	i32.add 	$0=, $0, $pop5
	i32.const	$push4=, 256
	i32.ne  	$push0=, $0, $pop4
	br_if   	$pop0, 0        # 0: up to label0
# BB#2:                                 # %render_image_rgb_a.exit
	end_loop                        # label1:
	block
	i32.const	$push1=, 256
	i32.ne  	$push2=, $0, $pop1
	br_if   	$pop2, 0        # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
.LBB0_4:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
