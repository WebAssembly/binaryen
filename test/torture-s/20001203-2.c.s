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
	i32.const	$push48=, 0
	i32.eq  	$push49=, $0, $pop48
	br_if   	0, $pop49       # 0: down to label1
# BB#1:                                 # %if.end
	i32.load	$push2=, 0($1)
	i32.const	$push3=, 3
	i32.mul 	$push4=, $pop2, $pop3
	i32.store	$discard=, 0($0), $pop4
	i32.load	$1=, 4($0)
	i32.const	$push5=, 1
	i32.store16	$discard=, 8($0), $pop5
	i32.const	$5=, 0
	block
	i32.const	$push50=, 0
	i32.eq  	$push51=, $1, $pop50
	br_if   	0, $pop51       # 0: down to label2
# BB#2:                                 # %cond.true
	i32.const	$push6=, 20
	i32.add 	$push7=, $1, $pop6
	i32.load	$push34=, 0($pop7)
	tee_local	$push33=, $4=, $pop34
	i32.const	$push32=, 16
	i32.add 	$push31=, $1, $pop32
	tee_local	$push30=, $2=, $pop31
	i32.load	$push29=, 0($pop30)
	tee_local	$push28=, $3=, $pop29
	i32.sub 	$push8=, $pop33, $pop28
	i32.const	$push9=, 15
	i32.le_s	$push10=, $pop8, $pop9
	br_if   	2, $pop10       # 2: down to label0
# BB#3:                                 # %if.end9
	block
	i32.const	$push11=, 12
	i32.add 	$push41=, $1, $pop11
	tee_local	$push40=, $6=, $pop41
	i32.load	$push39=, 0($pop40)
	tee_local	$push38=, $5=, $pop39
	i32.const	$push37=, 16
	i32.add 	$push1=, $3, $pop37
	i32.store	$push36=, 0($2), $pop1
	tee_local	$push35=, $3=, $pop36
	i32.ne  	$push12=, $pop38, $pop35
	br_if   	0, $pop12       # 0: down to label3
# BB#4:                                 # %if.then16
	i32.const	$push13=, 28
	i32.add 	$push14=, $1, $pop13
	i32.const	$push15=, 1
	i32.store	$discard=, 0($pop14), $pop15
.LBB0_5:                                # %if.end17
	end_block                       # label3:
	i32.const	$push22=, 8
	i32.add 	$push23=, $1, $pop22
	i32.load	$2=, 0($pop23)
	i32.const	$push21=, 16
	i32.add 	$push47=, $1, $pop21
	tee_local	$push46=, $7=, $pop47
	i32.const	$push16=, 24
	i32.add 	$push17=, $1, $pop16
	i32.load	$push45=, 0($pop17)
	tee_local	$push44=, $1=, $pop45
	i32.add 	$push18=, $pop44, $3
	i32.const	$push19=, -1
	i32.xor 	$push20=, $1, $pop19
	i32.and 	$push43=, $pop18, $pop20
	tee_local	$push42=, $1=, $pop43
	i32.store	$discard=, 0($pop46), $pop42
	i32.sub 	$push24=, $1, $2
	i32.sub 	$push25=, $4, $2
	i32.gt_s	$push26=, $pop24, $pop25
	i32.select	$push27=, $4, $1, $pop26
	i32.store	$push0=, 0($7), $pop27
	i32.store	$discard=, 0($6), $pop0
.LBB0_6:                                # %cond.end
	end_block                       # label2:
	i32.store	$discard=, 12($0), $5
	return  	$0
.LBB0_7:                                # %if.then
	end_block                       # label1:
	i32.call	$discard=, alloc_type@FUNCTION
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
	i64.store	$discard=, 0($0), $pop0
	i64.const	$push1=, 2
	i64.store	$discard=, 0($1), $pop1
	return
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
	return  	$pop0
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
