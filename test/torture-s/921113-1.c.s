	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/921113-1.c"
	.section	.text.w,"ax",@progbits
	.hidden	w
	.globl	w
	.type	w,@function
w:                                      # @w
	.param  	f32, f32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$2
	.endfunc
.Lfunc_end0:
	.size	w, .Lfunc_end0-w

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	f32, f32
	.result 	i32
	.local  	f32, i32
# BB#0:                                 # %entry
	f32.const	$2=, 0x0p0
	block
	f32.ne  	$push0=, $0, $2
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %entry
	f32.ne  	$push1=, $1, $2
	br_if   	$pop1, 0        # 0: down to label0
# BB#2:                                 # %if.end
	return  	$3
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	f32, f32
	.result 	i32
	.local  	f32, i32
# BB#0:                                 # %entry
	f32.const	$2=, 0x1p0
	block
	f32.ne  	$push0=, $0, $2
	br_if   	$pop0, 0        # 0: down to label1
# BB#1:                                 # %entry
	f32.ne  	$push1=, $1, $2
	br_if   	$pop1, 0        # 0: down to label1
# BB#2:                                 # %if.end
	return  	$3
.LBB2_3:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f2, .Lfunc_end2-f2

	.section	.text.gitter,"ax",@progbits
	.hidden	gitter
	.globl	gitter
	.type	gitter,@function
gitter:                                 # @gitter
	.param  	i32, i32, i32, i32, i32, f32
	.result 	i32
	.local  	f32, f32, f64, f64
# BB#0:                                 # %entry
	f32.const	$7=, 0x0p0
	block
	f32.load	$push1=, 0($4)
	f32.ne  	$push2=, $pop1, $7
	br_if   	$pop2, 0        # 0: down to label2
# BB#1:                                 # %entry
	f32.load	$push0=, 4($4)
	f32.ne  	$push3=, $pop0, $7
	br_if   	$pop3, 0        # 0: down to label2
# BB#2:                                 # %f1.exit
	f32.const	$6=, 0x1p0
	block
	f32.load	$push5=, 8($4)
	f32.ne  	$push8=, $pop5, $6
	br_if   	$pop8, 0        # 0: down to label3
# BB#3:                                 # %f1.exit
	i32.const	$push6=, 12
	i32.add 	$push7=, $4, $pop6
	f32.load	$push4=, 0($pop7)
	f32.ne  	$push9=, $pop4, $6
	br_if   	$pop9, 0        # 0: down to label3
# BB#4:                                 # %f2.exit
	i32.const	$push10=, 0
	i32.store	$discard=, 0($3), $pop10
	f32.load	$6=, 0($1)
	block
	f32.gt  	$push11=, $6, $7
	f32.ne  	$push12=, $6, $6
	i32.or  	$push13=, $pop11, $pop12
	br_if   	$pop13, 0       # 0: down to label4
# BB#5:                                 # %if.then
	f64.promote/f32	$push14=, $5
	f64.const	$push15=, 0x1p-1
	f64.mul 	$9=, $pop14, $pop15
	f64.promote/f32	$8=, $6
	f64.gt  	$push16=, $8, $9
	f64.ne  	$push18=, $8, $8
	f64.ne  	$push17=, $9, $9
	i32.or  	$push19=, $pop18, $pop17
	i32.or  	$push20=, $pop16, $pop19
	br_if   	$pop20, 0       # 0: down to label4
# BB#6:                                 # %if.then15
	i32.const	$push21=, 1065353216
	i32.store	$discard=, 0($2), $pop21
.LBB3_7:                                # %if.end18
	end_block                       # label4:
	return  	$4
.LBB3_8:                                # %if.then.i32
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB3_9:                                # %if.then.i
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	gitter, .Lfunc_end3-gitter

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	f32.const	$1=, 0x0p0
	block
	f32.load	$push1=, limit($0)
	f32.ne  	$push2=, $pop1, $1
	br_if   	$pop2, 0        # 0: down to label5
# BB#1:                                 # %entry
	f32.load	$push0=, limit+4($0)
	f32.ne  	$push3=, $pop0, $1
	br_if   	$pop3, 0        # 0: down to label5
# BB#2:                                 # %f1.exit.i
	f32.const	$1=, 0x1p0
	block
	f32.load	$push5=, limit+8($0)
	f32.ne  	$push6=, $pop5, $1
	br_if   	$pop6, 0        # 0: down to label6
# BB#3:                                 # %f1.exit.i
	f32.load	$push4=, limit+12($0)
	f32.ne  	$push7=, $pop4, $1
	br_if   	$pop7, 0        # 0: down to label6
# BB#4:                                 # %f2.exit.i
	call    	exit@FUNCTION, $0
	unreachable
.LBB4_5:                                # %if.then.i32.i
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB4_6:                                # %if.then.i.i
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.hidden	pos                     # @pos
	.type	pos,@object
	.section	.bss.pos,"aw",@nobits
	.globl	pos
	.align	2
pos:
	.skip	8
	.size	pos, 8

	.hidden	limit                   # @limit
	.type	limit,@object
	.section	.data.limit,"aw",@progbits
	.globl	limit
	.align	4
limit:
	.skip	8
	.int32	1065353216              # float 1
	.int32	1065353216              # float 1
	.size	limit, 16


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
