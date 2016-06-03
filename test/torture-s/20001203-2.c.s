	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001203-2.c"
	.section	.text.create_array_type,"ax",@progbits
	.hidden	create_array_type
	.globl	create_array_type
	.type	create_array_type,@function
create_array_type:                      # @create_array_type
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	block
	i32.eqz 	$push53=, $0
	br_if   	0, $pop53       # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push2=, 1
	i32.store16	$drop=, 8($0), $pop2
	i32.load	$push3=, 0($1)
	i32.const	$push4=, 3
	i32.mul 	$push5=, $pop3, $pop4
	i32.store	$drop=, 0($0), $pop5
	i32.const	$7=, 0
	block
	i32.load	$push30=, 4($0)
	tee_local	$push29=, $1=, $pop30
	i32.eqz 	$push54=, $pop29
	br_if   	0, $pop54       # 0: down to label2
# BB#2:                                 # %cond.true
	i32.const	$push6=, 20
	i32.add 	$push7=, $1, $pop6
	i32.load	$push37=, 0($pop7)
	tee_local	$push36=, $2=, $pop37
	i32.const	$push35=, 16
	i32.add 	$push34=, $1, $pop35
	tee_local	$push33=, $7=, $pop34
	i32.load	$push32=, 0($pop33)
	tee_local	$push31=, $3=, $pop32
	i32.sub 	$push8=, $pop36, $pop31
	i32.const	$push9=, 15
	i32.le_s	$push10=, $pop8, $pop9
	br_if   	2, $pop10       # 2: down to label0
# BB#3:                                 # %if.end9
	block
	i32.const	$push44=, 16
	i32.add 	$push1=, $3, $pop44
	i32.store	$push43=, 0($7), $pop1
	tee_local	$push42=, $3=, $pop43
	i32.const	$push11=, 12
	i32.add 	$push41=, $1, $pop11
	tee_local	$push40=, $4=, $pop41
	i32.load	$push39=, 0($pop40)
	tee_local	$push38=, $7=, $pop39
	i32.ne  	$push12=, $pop42, $pop38
	br_if   	0, $pop12       # 0: down to label3
# BB#4:                                 # %if.then16
	i32.const	$push13=, 28
	i32.add 	$push14=, $1, $pop13
	i32.const	$push15=, 1
	i32.store	$drop=, 0($pop14), $pop15
.LBB0_5:                                # %if.end17
	end_block                       # label3:
	i32.const	$push22=, 16
	i32.add 	$push52=, $1, $pop22
	tee_local	$push51=, $6=, $pop52
	i32.const	$push16=, 24
	i32.add 	$push17=, $1, $pop16
	i32.load	$push50=, 0($pop17)
	tee_local	$push49=, $5=, $pop50
	i32.add 	$push20=, $pop49, $3
	i32.const	$push18=, -1
	i32.xor 	$push19=, $5, $pop18
	i32.and 	$push21=, $pop20, $pop19
	i32.store	$push48=, 0($6), $pop21
	tee_local	$push47=, $3=, $pop48
	i32.const	$push23=, 8
	i32.add 	$push24=, $1, $pop23
	i32.load	$push46=, 0($pop24)
	tee_local	$push45=, $1=, $pop46
	i32.sub 	$push25=, $3, $pop45
	i32.sub 	$push26=, $2, $1
	i32.gt_s	$push27=, $pop25, $pop26
	i32.select	$push28=, $2, $pop47, $pop27
	i32.store	$push0=, 0($pop51), $pop28
	i32.store	$drop=, 0($4), $pop0
.LBB0_6:                                # %cond.end
	end_block                       # label2:
	i32.store	$drop=, 12($0), $7
	return  	$0
.LBB0_7:                                # %if.then
	end_block                       # label1:
	i32.call	$drop=, alloc_type@FUNCTION
	unreachable
.LBB0_8:                                # %if.then8
	end_block                       # label0:
	call    	_obstack_newchunk@FUNCTION, $0, $0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	create_array_type, .Lfunc_end0-create_array_type

	.section	.text.alloc_type,"ax",@progbits
	.hidden	alloc_type
	.globl	alloc_type
	.type	alloc_type,@function
alloc_type:                             # @alloc_type
	.result 	i32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	alloc_type, .Lfunc_end1-alloc_type

	.section	.text.get_discrete_bounds,"ax",@progbits
	.hidden	get_discrete_bounds
	.globl	get_discrete_bounds
	.type	get_discrete_bounds,@function
get_discrete_bounds:                    # @get_discrete_bounds
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.store	$drop=, 0($0), $pop0
	i64.const	$push1=, 2
	i64.store	$drop=, 0($1), $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	get_discrete_bounds, .Lfunc_end2-get_discrete_bounds

	.section	.text._obstack_newchunk,"ax",@progbits
	.hidden	_obstack_newchunk
	.globl	_obstack_newchunk
	.type	_obstack_newchunk,@function
_obstack_newchunk:                      # @_obstack_newchunk
	.param  	i32, i32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	_obstack_newchunk, .Lfunc_end3-_obstack_newchunk

	.section	.text.xmalloc,"ax",@progbits
	.hidden	xmalloc
	.globl	xmalloc
	.type	xmalloc,@function
xmalloc:                                # @xmalloc
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	xmalloc, .Lfunc_end4-xmalloc

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end5:
	.size	main, .Lfunc_end5-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
