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
	i32.const	$push45=, 0
	i32.eq  	$push46=, $0, $pop45
	br_if   	0, $pop46       # 0: down to label1
# BB#1:                                 # %if.end
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 3
	i32.mul 	$push3=, $pop1, $pop2
	i32.store	$discard=, 0($0), $pop3
	i32.load	$1=, 4($0)
	i32.const	$push4=, 1
	i32.store16	$discard=, 8($0):p2align=2, $pop4
	i32.const	$3=, 0
	block
	i32.const	$push47=, 0
	i32.eq  	$push48=, $1, $pop47
	br_if   	0, $pop48       # 0: down to label2
# BB#2:                                 # %cond.true
	i32.const	$push5=, 20
	i32.add 	$push6=, $1, $pop5
	i32.load	$push35=, 0($pop6)
	tee_local	$push34=, $5=, $pop35
	i32.const	$push33=, 16
	i32.add 	$push32=, $1, $pop33
	tee_local	$push31=, $2=, $pop32
	i32.load	$push30=, 0($pop31)
	tee_local	$push29=, $4=, $pop30
	i32.sub 	$push7=, $pop34, $pop29
	i32.const	$push8=, 15
	i32.le_s	$push9=, $pop7, $pop8
	br_if   	2, $pop9        # 2: down to label0
# BB#3:                                 # %if.end9
	i32.const	$push10=, 12
	i32.add 	$push40=, $1, $pop10
	tee_local	$push39=, $6=, $pop40
	i32.load	$3=, 0($pop39)
	block
	i32.const	$push38=, 16
	i32.add 	$push0=, $4, $pop38
	i32.store	$push37=, 0($2), $pop0
	tee_local	$push36=, $4=, $pop37
	i32.ne  	$push11=, $3, $pop36
	br_if   	0, $pop11       # 0: down to label3
# BB#4:                                 # %if.then16
	i32.const	$push12=, 28
	i32.add 	$push13=, $1, $pop12
	i32.const	$push14=, 1
	i32.store	$discard=, 0($pop13), $pop14
.LBB0_5:                                # %if.end17
	end_block                       # label3:
	i32.const	$push22=, 8
	i32.add 	$push23=, $1, $pop22
	i32.load	$2=, 0($pop23)
	i32.const	$push21=, 16
	i32.add 	$push44=, $1, $pop21
	tee_local	$push43=, $7=, $pop44
	i32.const	$push15=, 24
	i32.add 	$push16=, $1, $pop15
	i32.load	$push42=, 0($pop16)
	tee_local	$push41=, $1=, $pop42
	i32.add 	$push17=, $pop41, $4
	i32.const	$push18=, -1
	i32.xor 	$push19=, $1, $pop18
	i32.and 	$push20=, $pop17, $pop19
	i32.store	$1=, 0($pop43), $pop20
	i32.sub 	$push24=, $1, $2
	i32.sub 	$push25=, $5, $2
	i32.gt_s	$push26=, $pop24, $pop25
	i32.select	$push27=, $5, $1, $pop26
	i32.store	$push28=, 0($7), $pop27
	i32.store	$discard=, 0($6), $pop28
.LBB0_6:                                # %cond.end
	end_block                       # label2:
	i32.store	$discard=, 12($0), $3
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
