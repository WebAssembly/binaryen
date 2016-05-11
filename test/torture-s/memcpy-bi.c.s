	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memcpy-bi.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.call	$push0=, memcmp@FUNCTION, $0, $1, $2
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push251=, 26
	i32.rem_s	$push24=, $4, $pop251
	i32.const	$push250=, 97
	i32.add 	$push25=, $pop24, $pop250
	i32.store8	$discard=, src($4), $pop25
	i32.const	$push249=, 1
	i32.add 	$4=, $4, $pop249
	i32.const	$push248=, 80
	i32.ne  	$push26=, $4, $pop248
	br_if   	0, $pop26       # 0: up to label1
# BB#2:                                 # %check.exit
	end_loop                        # label2:
	i32.const	$push253=, 0
	i32.const	$push252=, 0
	i32.load16_u	$push27=, src($pop252)
	i32.store16	$discard=, dst($pop253), $pop27
	block
	i32.const	$push28=, 1
	i32.const	$push676=, 0
	i32.eq  	$push677=, $pop28, $pop676
	br_if   	0, $pop677      # 0: down to label3
# BB#3:                                 # %check.exit13
	i32.const	$push259=, 0
	i32.const	$push258=, 0
	i32.load8_u	$push29=, src+2($pop258)
	i32.store8	$discard=, dst+2($pop259), $pop29
	i32.const	$push257=, 0
	i32.const	$push256=, 0
	i32.load16_u	$push30=, src($pop256)
	i32.store16	$discard=, dst($pop257), $pop30
	i32.const	$push255=, dst
	i32.const	$push254=, src
	i32.const	$push31=, 3
	i32.call	$push32=, memcmp@FUNCTION, $pop255, $pop254, $pop31
	br_if   	0, $pop32       # 0: down to label3
# BB#4:                                 # %check.exit17
	i32.const	$push265=, 0
	i32.load	$4=, src($pop265)
	i32.const	$push264=, 0
	i32.const	$push263=, 0
	i32.load8_u	$push33=, src+4($pop263)
	i32.store8	$discard=, dst+4($pop264), $pop33
	i32.const	$push262=, 0
	i32.store	$discard=, dst($pop262), $4
	i32.const	$push261=, dst
	i32.const	$push260=, src
	i32.const	$push34=, 5
	i32.call	$push35=, memcmp@FUNCTION, $pop261, $pop260, $pop34
	br_if   	0, $pop35       # 0: down to label3
# BB#5:                                 # %check.exit25
	i32.const	$push271=, 0
	i32.const	$push270=, 0
	i32.load16_u	$push36=, src+4($pop270)
	i32.store16	$discard=, dst+4($pop271), $pop36
	i32.const	$push269=, 0
	i32.const	$push268=, 0
	i32.load	$push37=, src($pop268)
	i32.store	$discard=, dst($pop269), $pop37
	i32.const	$push267=, dst
	i32.const	$push266=, src
	i32.const	$push38=, 6
	i32.call	$push39=, memcmp@FUNCTION, $pop267, $pop266, $pop38
	br_if   	0, $pop39       # 0: down to label3
# BB#6:                                 # %check.exit29
	i32.const	$push279=, 0
	i32.load16_u	$4=, src+4($pop279)
	i32.const	$push278=, 0
	i32.load	$0=, src($pop278)
	i32.const	$push277=, 0
	i32.const	$push276=, 0
	i32.load8_u	$push40=, src+6($pop276)
	i32.store8	$discard=, dst+6($pop277), $pop40
	i32.const	$push275=, 0
	i32.store16	$discard=, dst+4($pop275), $4
	i32.const	$push274=, 0
	i32.store	$discard=, dst($pop274), $0
	i32.const	$push273=, dst
	i32.const	$push272=, src
	i32.const	$push41=, 7
	i32.call	$push42=, memcmp@FUNCTION, $pop273, $pop272, $pop41
	br_if   	0, $pop42       # 0: down to label3
# BB#7:                                 # %check.exit33
	i32.const	$push285=, 0
	i32.const	$push284=, 0
	i32.load8_u	$push43=, src+8($pop284)
	i32.store8	$discard=, dst+8($pop285), $pop43
	i32.const	$push283=, 0
	i32.const	$push282=, 0
	i64.load	$push44=, src($pop282)
	i64.store	$discard=, dst($pop283), $pop44
	i32.const	$push281=, dst
	i32.const	$push280=, src
	i32.const	$push45=, 9
	i32.call	$push46=, memcmp@FUNCTION, $pop281, $pop280, $pop45
	br_if   	0, $pop46       # 0: down to label3
# BB#8:                                 # %check.exit41
	i32.const	$push291=, 0
	i64.load	$1=, src($pop291)
	i32.const	$push290=, 0
	i32.const	$push289=, 0
	i32.load16_u	$push47=, src+8($pop289)
	i32.store16	$discard=, dst+8($pop290), $pop47
	i32.const	$push288=, 0
	i64.store	$discard=, dst($pop288), $1
	i32.const	$push287=, dst
	i32.const	$push286=, src
	i32.const	$push48=, 10
	i32.call	$push49=, memcmp@FUNCTION, $pop287, $pop286, $pop48
	br_if   	0, $pop49       # 0: down to label3
# BB#9:                                 # %check.exit45
	i32.const	$push299=, 0
	i32.load16_u	$4=, src+8($pop299)
	i32.const	$push298=, 0
	i32.const	$push297=, 0
	i32.load8_u	$push50=, src+10($pop297)
	i32.store8	$discard=, dst+10($pop298), $pop50
	i32.const	$push296=, 0
	i32.store16	$discard=, dst+8($pop296), $4
	i32.const	$push295=, 0
	i32.const	$push294=, 0
	i64.load	$push51=, src($pop294)
	i64.store	$discard=, dst($pop295), $pop51
	i32.const	$push293=, dst
	i32.const	$push292=, src
	i32.const	$push52=, 11
	i32.call	$push53=, memcmp@FUNCTION, $pop293, $pop292, $pop52
	br_if   	0, $pop53       # 0: down to label3
# BB#10:                                # %check.exit49
	i32.const	$push305=, 0
	i64.load	$1=, src($pop305)
	i32.const	$push304=, 0
	i32.const	$push303=, 0
	i32.load	$push54=, src+8($pop303)
	i32.store	$discard=, dst+8($pop304), $pop54
	i32.const	$push302=, 0
	i64.store	$discard=, dst($pop302), $1
	i32.const	$push301=, dst
	i32.const	$push300=, src
	i32.const	$push55=, 12
	i32.call	$push56=, memcmp@FUNCTION, $pop301, $pop300, $pop55
	br_if   	0, $pop56       # 0: down to label3
# BB#11:                                # %check.exit53
	i32.const	$push313=, 0
	i32.load	$4=, src+8($pop313)
	i32.const	$push312=, 0
	i32.const	$push311=, 0
	i32.load8_u	$push57=, src+12($pop311)
	i32.store8	$discard=, dst+12($pop312), $pop57
	i32.const	$push310=, 0
	i32.store	$discard=, dst+8($pop310), $4
	i32.const	$push309=, 0
	i32.const	$push308=, 0
	i64.load	$push58=, src($pop308)
	i64.store	$discard=, dst($pop309), $pop58
	i32.const	$push307=, dst
	i32.const	$push306=, src
	i32.const	$push59=, 13
	i32.call	$push60=, memcmp@FUNCTION, $pop307, $pop306, $pop59
	br_if   	0, $pop60       # 0: down to label3
# BB#12:                                # %check.exit57
	i32.const	$push321=, 0
	i32.load	$4=, src+8($pop321)
	i32.const	$push320=, 0
	i64.load	$1=, src($pop320)
	i32.const	$push319=, 0
	i32.const	$push318=, 0
	i32.load16_u	$push61=, src+12($pop318)
	i32.store16	$discard=, dst+12($pop319), $pop61
	i32.const	$push317=, 0
	i32.store	$discard=, dst+8($pop317), $4
	i32.const	$push316=, 0
	i64.store	$discard=, dst($pop316), $1
	i32.const	$push315=, dst
	i32.const	$push314=, src
	i32.const	$push62=, 14
	i32.call	$push63=, memcmp@FUNCTION, $pop315, $pop314, $pop62
	br_if   	0, $pop63       # 0: down to label3
# BB#13:                                # %check.exit61
	i32.const	$push331=, 0
	i32.load16_u	$4=, src+12($pop331)
	i32.const	$push330=, 0
	i32.load	$0=, src+8($pop330)
	i32.const	$push329=, 0
	i32.const	$push328=, 0
	i32.load8_u	$push64=, src+14($pop328)
	i32.store8	$discard=, dst+14($pop329), $pop64
	i32.const	$push327=, 0
	i32.store16	$discard=, dst+12($pop327), $4
	i32.const	$push326=, 0
	i32.store	$discard=, dst+8($pop326), $0
	i32.const	$push325=, 0
	i32.const	$push324=, 0
	i64.load	$push65=, src($pop324)
	i64.store	$discard=, dst($pop325), $pop65
	i32.const	$push323=, dst
	i32.const	$push322=, src
	i32.const	$push66=, 15
	i32.call	$push67=, memcmp@FUNCTION, $pop323, $pop322, $pop66
	br_if   	0, $pop67       # 0: down to label3
# BB#14:                                # %check.exit65
	i32.const	$push337=, 0
	i64.load	$1=, src($pop337)
	i32.const	$push336=, 0
	i32.const	$push335=, 0
	i64.load	$push68=, src+8($pop335)
	i64.store	$discard=, dst+8($pop336), $pop68
	i32.const	$push334=, 0
	i64.store	$discard=, dst($pop334), $1
	i32.const	$push333=, dst
	i32.const	$push332=, src
	i32.const	$push69=, 16
	i32.call	$push70=, memcmp@FUNCTION, $pop333, $pop332, $pop69
	br_if   	0, $pop70       # 0: down to label3
# BB#15:                                # %check.exit69
	i32.const	$push345=, 0
	i64.load	$1=, src+8($pop345)
	i32.const	$push344=, 0
	i32.const	$push343=, 0
	i32.load8_u	$push71=, src+16($pop343)
	i32.store8	$discard=, dst+16($pop344), $pop71
	i32.const	$push342=, 0
	i64.store	$discard=, dst+8($pop342), $1
	i32.const	$push341=, 0
	i32.const	$push340=, 0
	i64.load	$push72=, src($pop340)
	i64.store	$discard=, dst($pop341), $pop72
	i32.const	$push339=, dst
	i32.const	$push338=, src
	i32.const	$push73=, 17
	i32.call	$push74=, memcmp@FUNCTION, $pop339, $pop338, $pop73
	br_if   	0, $pop74       # 0: down to label3
# BB#16:                                # %check.exit73
	i32.const	$push353=, 0
	i64.load	$1=, src+8($pop353)
	i32.const	$push352=, 0
	i64.load	$2=, src($pop352)
	i32.const	$push351=, 0
	i32.const	$push350=, 0
	i32.load16_u	$push75=, src+16($pop350)
	i32.store16	$discard=, dst+16($pop351), $pop75
	i32.const	$push349=, 0
	i64.store	$discard=, dst+8($pop349), $1
	i32.const	$push348=, 0
	i64.store	$discard=, dst($pop348), $2
	i32.const	$push347=, dst
	i32.const	$push346=, src
	i32.const	$push76=, 18
	i32.call	$push77=, memcmp@FUNCTION, $pop347, $pop346, $pop76
	br_if   	0, $pop77       # 0: down to label3
# BB#17:                                # %check.exit77
	i32.const	$push363=, 0
	i32.load16_u	$4=, src+16($pop363)
	i32.const	$push362=, 0
	i64.load	$1=, src+8($pop362)
	i32.const	$push361=, 0
	i32.const	$push360=, 0
	i32.load8_u	$push78=, src+18($pop360)
	i32.store8	$discard=, dst+18($pop361), $pop78
	i32.const	$push359=, 0
	i32.store16	$discard=, dst+16($pop359), $4
	i32.const	$push358=, 0
	i64.store	$discard=, dst+8($pop358), $1
	i32.const	$push357=, 0
	i32.const	$push356=, 0
	i64.load	$push79=, src($pop356)
	i64.store	$discard=, dst($pop357), $pop79
	i32.const	$push355=, dst
	i32.const	$push354=, src
	i32.const	$push80=, 19
	i32.call	$push81=, memcmp@FUNCTION, $pop355, $pop354, $pop80
	br_if   	0, $pop81       # 0: down to label3
# BB#18:                                # %check.exit81
	i32.const	$push371=, 0
	i64.load	$1=, src+8($pop371)
	i32.const	$push370=, 0
	i64.load	$2=, src($pop370)
	i32.const	$push369=, 0
	i32.const	$push368=, 0
	i32.load	$push82=, src+16($pop368)
	i32.store	$discard=, dst+16($pop369), $pop82
	i32.const	$push367=, 0
	i64.store	$discard=, dst+8($pop367), $1
	i32.const	$push366=, 0
	i64.store	$discard=, dst($pop366), $2
	i32.const	$push365=, dst
	i32.const	$push364=, src
	i32.const	$push83=, 20
	i32.call	$push84=, memcmp@FUNCTION, $pop365, $pop364, $pop83
	br_if   	0, $pop84       # 0: down to label3
# BB#19:                                # %check.exit85
	i32.const	$push381=, 0
	i32.load	$4=, src+16($pop381)
	i32.const	$push380=, 0
	i64.load	$1=, src+8($pop380)
	i32.const	$push379=, 0
	i32.const	$push378=, 0
	i32.load8_u	$push85=, src+20($pop378)
	i32.store8	$discard=, dst+20($pop379), $pop85
	i32.const	$push377=, 0
	i32.store	$discard=, dst+16($pop377), $4
	i32.const	$push376=, 0
	i64.store	$discard=, dst+8($pop376), $1
	i32.const	$push375=, 0
	i32.const	$push374=, 0
	i64.load	$push86=, src($pop374)
	i64.store	$discard=, dst($pop375), $pop86
	i32.const	$push373=, dst
	i32.const	$push372=, src
	i32.const	$push87=, 21
	i32.call	$push88=, memcmp@FUNCTION, $pop373, $pop372, $pop87
	br_if   	0, $pop88       # 0: down to label3
# BB#20:                                # %check.exit89
	i32.const	$push391=, 0
	i32.load	$4=, src+16($pop391)
	i32.const	$push390=, 0
	i64.load	$1=, src+8($pop390)
	i32.const	$push389=, 0
	i32.const	$push388=, 0
	i32.load16_u	$push89=, src+20($pop388)
	i32.store16	$discard=, dst+20($pop389), $pop89
	i32.const	$push387=, 0
	i64.load	$2=, src($pop387)
	i32.const	$push386=, 0
	i32.store	$discard=, dst+16($pop386), $4
	i32.const	$push385=, 0
	i64.store	$discard=, dst+8($pop385), $1
	i32.const	$push384=, 0
	i64.store	$discard=, dst($pop384), $2
	i32.const	$push383=, dst
	i32.const	$push382=, src
	i32.const	$push90=, 22
	i32.call	$push91=, memcmp@FUNCTION, $pop383, $pop382, $pop90
	br_if   	0, $pop91       # 0: down to label3
# BB#21:                                # %check.exit93
	i32.const	$push403=, 0
	i32.load16_u	$4=, src+20($pop403)
	i32.const	$push402=, 0
	i32.load	$0=, src+16($pop402)
	i32.const	$push401=, 0
	i64.load	$1=, src+8($pop401)
	i32.const	$push400=, 0
	i32.const	$push399=, 0
	i32.load8_u	$push92=, src+22($pop399)
	i32.store8	$discard=, dst+22($pop400), $pop92
	i32.const	$push398=, 0
	i32.store16	$discard=, dst+20($pop398), $4
	i32.const	$push397=, 0
	i32.store	$discard=, dst+16($pop397), $0
	i32.const	$push396=, 0
	i64.store	$discard=, dst+8($pop396), $1
	i32.const	$push395=, 0
	i32.const	$push394=, 0
	i64.load	$push93=, src($pop394)
	i64.store	$discard=, dst($pop395), $pop93
	i32.const	$push393=, dst
	i32.const	$push392=, src
	i32.const	$push94=, 23
	i32.call	$push95=, memcmp@FUNCTION, $pop393, $pop392, $pop94
	br_if   	0, $pop95       # 0: down to label3
# BB#22:                                # %check.exit97
	i32.const	$push411=, 0
	i64.load	$1=, src+8($pop411)
	i32.const	$push410=, 0
	i64.load	$2=, src($pop410)
	i32.const	$push409=, 0
	i32.const	$push408=, 0
	i64.load	$push96=, src+16($pop408)
	i64.store	$discard=, dst+16($pop409), $pop96
	i32.const	$push407=, 0
	i64.store	$discard=, dst+8($pop407), $1
	i32.const	$push406=, 0
	i64.store	$discard=, dst($pop406), $2
	i32.const	$push405=, dst
	i32.const	$push404=, src
	i32.const	$push97=, 24
	i32.call	$push98=, memcmp@FUNCTION, $pop405, $pop404, $pop97
	br_if   	0, $pop98       # 0: down to label3
# BB#23:                                # %check.exit101
	i32.const	$push421=, 0
	i64.load	$1=, src+16($pop421)
	i32.const	$push420=, 0
	i64.load	$2=, src+8($pop420)
	i32.const	$push419=, 0
	i32.const	$push418=, 0
	i32.load8_u	$push99=, src+24($pop418)
	i32.store8	$discard=, dst+24($pop419), $pop99
	i32.const	$push417=, 0
	i64.store	$discard=, dst+16($pop417), $1
	i32.const	$push416=, 0
	i64.store	$discard=, dst+8($pop416), $2
	i32.const	$push415=, 0
	i32.const	$push414=, 0
	i64.load	$push100=, src($pop414)
	i64.store	$discard=, dst($pop415), $pop100
	i32.const	$push413=, dst
	i32.const	$push412=, src
	i32.const	$push101=, 25
	i32.call	$push102=, memcmp@FUNCTION, $pop413, $pop412, $pop101
	br_if   	0, $pop102      # 0: down to label3
# BB#24:                                # %check.exit105
	i32.const	$push431=, 0
	i64.load	$1=, src+16($pop431)
	i32.const	$push430=, 0
	i64.load	$2=, src+8($pop430)
	i32.const	$push429=, 0
	i32.const	$push428=, 0
	i32.load16_u	$push103=, src+24($pop428)
	i32.store16	$discard=, dst+24($pop429), $pop103
	i32.const	$push427=, 0
	i64.load	$3=, src($pop427)
	i32.const	$push426=, 0
	i64.store	$discard=, dst+16($pop426), $1
	i32.const	$push425=, 0
	i64.store	$discard=, dst+8($pop425), $2
	i32.const	$push424=, 0
	i64.store	$discard=, dst($pop424), $3
	i32.const	$push423=, dst
	i32.const	$push422=, src
	i32.const	$push104=, 26
	i32.call	$push105=, memcmp@FUNCTION, $pop423, $pop422, $pop104
	br_if   	0, $pop105      # 0: down to label3
# BB#25:                                # %check.exit109
	i32.const	$push443=, 0
	i32.load16_u	$4=, src+24($pop443)
	i32.const	$push442=, 0
	i64.load	$1=, src+16($pop442)
	i32.const	$push441=, 0
	i64.load	$2=, src+8($pop441)
	i32.const	$push440=, 0
	i32.const	$push439=, 0
	i32.load8_u	$push106=, src+26($pop439)
	i32.store8	$discard=, dst+26($pop440), $pop106
	i32.const	$push438=, 0
	i32.store16	$discard=, dst+24($pop438), $4
	i32.const	$push437=, 0
	i64.store	$discard=, dst+16($pop437), $1
	i32.const	$push436=, 0
	i64.store	$discard=, dst+8($pop436), $2
	i32.const	$push435=, 0
	i32.const	$push434=, 0
	i64.load	$push107=, src($pop434)
	i64.store	$discard=, dst($pop435), $pop107
	i32.const	$push433=, dst
	i32.const	$push432=, src
	i32.const	$push108=, 27
	i32.call	$push109=, memcmp@FUNCTION, $pop433, $pop432, $pop108
	br_if   	0, $pop109      # 0: down to label3
# BB#26:                                # %check.exit113
	i32.const	$push453=, 0
	i64.load	$1=, src+16($pop453)
	i32.const	$push452=, 0
	i64.load	$2=, src+8($pop452)
	i32.const	$push451=, 0
	i32.const	$push450=, 0
	i32.load	$push110=, src+24($pop450)
	i32.store	$discard=, dst+24($pop451), $pop110
	i32.const	$push449=, 0
	i64.load	$3=, src($pop449)
	i32.const	$push448=, 0
	i64.store	$discard=, dst+16($pop448), $1
	i32.const	$push447=, 0
	i64.store	$discard=, dst+8($pop447), $2
	i32.const	$push446=, 0
	i64.store	$discard=, dst($pop446), $3
	i32.const	$push445=, dst
	i32.const	$push444=, src
	i32.const	$push111=, 28
	i32.call	$push112=, memcmp@FUNCTION, $pop445, $pop444, $pop111
	br_if   	0, $pop112      # 0: down to label3
# BB#27:                                # %check.exit117
	i32.const	$push465=, 0
	i32.load	$4=, src+24($pop465)
	i32.const	$push464=, 0
	i64.load	$1=, src+16($pop464)
	i32.const	$push463=, 0
	i64.load	$2=, src+8($pop463)
	i32.const	$push462=, 0
	i32.const	$push461=, 0
	i32.load8_u	$push113=, src+28($pop461)
	i32.store8	$discard=, dst+28($pop462), $pop113
	i32.const	$push460=, 0
	i32.store	$discard=, dst+24($pop460), $4
	i32.const	$push459=, 0
	i64.store	$discard=, dst+16($pop459), $1
	i32.const	$push458=, 0
	i64.store	$discard=, dst+8($pop458), $2
	i32.const	$push457=, 0
	i32.const	$push456=, 0
	i64.load	$push114=, src($pop456)
	i64.store	$discard=, dst($pop457), $pop114
	i32.const	$push455=, dst
	i32.const	$push454=, src
	i32.const	$push115=, 29
	i32.call	$push116=, memcmp@FUNCTION, $pop455, $pop454, $pop115
	br_if   	0, $pop116      # 0: down to label3
# BB#28:                                # %check.exit121
	i32.const	$push117=, 0
	i32.load	$4=, src+24($pop117)
	i32.const	$push476=, 0
	i32.const	$push475=, 0
	i32.load16_u	$push118=, src+28($pop475)
	i32.store16	$discard=, dst+28($pop476), $pop118
	i32.const	$push474=, 0
	i64.load	$1=, src+16($pop474)
	i32.const	$push473=, 0
	i64.load	$2=, src+8($pop473)
	i32.const	$push472=, 0
	i32.store	$discard=, dst+24($pop472), $4
	i32.const	$push471=, 0
	i64.load	$3=, src($pop471)
	i32.const	$push470=, 0
	i64.store	$discard=, dst+16($pop470), $1
	i32.const	$push469=, 0
	i64.store	$discard=, dst+8($pop469), $2
	i32.const	$push468=, 0
	i64.store	$discard=, dst($pop468), $3
	i32.const	$push467=, dst
	i32.const	$push466=, src
	i32.const	$push119=, 30
	i32.call	$push120=, memcmp@FUNCTION, $pop467, $pop466, $pop119
	br_if   	0, $pop120      # 0: down to label3
# BB#29:                                # %check.exit125
	i32.const	$push121=, dst
	i32.const	$push481=, src
	i32.const	$push122=, 31
	i32.call	$push480=, memcpy@FUNCTION, $pop121, $pop481, $pop122
	tee_local	$push479=, $4=, $pop480
	i32.const	$push478=, src
	i32.const	$push477=, 31
	i32.call	$push123=, memcmp@FUNCTION, $pop479, $pop478, $pop477
	br_if   	0, $pop123      # 0: down to label3
# BB#30:                                # %check.exit129
	i32.const	$push124=, 0
	i64.load	$1=, src+16($pop124)
	i32.const	$push489=, 0
	i64.load	$2=, src+8($pop489)
	i32.const	$push488=, 0
	i32.const	$push487=, 0
	i64.load	$push125=, src+24($pop487)
	i64.store	$discard=, dst+24($pop488), $pop125
	i32.const	$push486=, 0
	i64.load	$3=, src($pop486)
	i32.const	$push485=, 0
	i64.store	$discard=, dst+16($pop485), $1
	i32.const	$push484=, 0
	i64.store	$discard=, dst+8($pop484), $2
	i32.const	$push483=, 0
	i64.store	$discard=, dst($pop483), $3
	i32.const	$push482=, src
	i32.const	$push126=, 32
	i32.call	$push127=, memcmp@FUNCTION, $4, $pop482, $pop126
	br_if   	0, $pop127      # 0: down to label3
# BB#31:                                # %check.exit133
	i32.const	$push128=, dst
	i32.const	$push494=, src
	i32.const	$push129=, 33
	i32.call	$push493=, memcpy@FUNCTION, $pop128, $pop494, $pop129
	tee_local	$push492=, $4=, $pop493
	i32.const	$push491=, src
	i32.const	$push490=, 33
	i32.call	$push130=, memcmp@FUNCTION, $pop492, $pop491, $pop490
	br_if   	0, $pop130      # 0: down to label3
# BB#32:                                # %check.exit137
	i32.const	$push497=, src
	i32.const	$push131=, 34
	i32.call	$push0=, memcpy@FUNCTION, $4, $pop497, $pop131
	i32.const	$push496=, src
	i32.const	$push495=, 34
	i32.call	$push132=, memcmp@FUNCTION, $pop0, $pop496, $pop495
	br_if   	0, $pop132      # 0: down to label3
# BB#33:                                # %check.exit141
	i32.const	$push133=, dst
	i32.const	$push502=, src
	i32.const	$push134=, 35
	i32.call	$push501=, memcpy@FUNCTION, $pop133, $pop502, $pop134
	tee_local	$push500=, $4=, $pop501
	i32.const	$push499=, src
	i32.const	$push498=, 35
	i32.call	$push135=, memcmp@FUNCTION, $pop500, $pop499, $pop498
	br_if   	0, $pop135      # 0: down to label3
# BB#34:                                # %check.exit145
	i32.const	$push505=, src
	i32.const	$push136=, 36
	i32.call	$push1=, memcpy@FUNCTION, $4, $pop505, $pop136
	i32.const	$push504=, src
	i32.const	$push503=, 36
	i32.call	$push137=, memcmp@FUNCTION, $pop1, $pop504, $pop503
	br_if   	0, $pop137      # 0: down to label3
# BB#35:                                # %check.exit149
	i32.const	$push138=, dst
	i32.const	$push510=, src
	i32.const	$push139=, 37
	i32.call	$push509=, memcpy@FUNCTION, $pop138, $pop510, $pop139
	tee_local	$push508=, $4=, $pop509
	i32.const	$push507=, src
	i32.const	$push506=, 37
	i32.call	$push140=, memcmp@FUNCTION, $pop508, $pop507, $pop506
	br_if   	0, $pop140      # 0: down to label3
# BB#36:                                # %check.exit153
	i32.const	$push513=, src
	i32.const	$push141=, 38
	i32.call	$push2=, memcpy@FUNCTION, $4, $pop513, $pop141
	i32.const	$push512=, src
	i32.const	$push511=, 38
	i32.call	$push142=, memcmp@FUNCTION, $pop2, $pop512, $pop511
	br_if   	0, $pop142      # 0: down to label3
# BB#37:                                # %check.exit157
	i32.const	$push143=, dst
	i32.const	$push518=, src
	i32.const	$push144=, 39
	i32.call	$push517=, memcpy@FUNCTION, $pop143, $pop518, $pop144
	tee_local	$push516=, $4=, $pop517
	i32.const	$push515=, src
	i32.const	$push514=, 39
	i32.call	$push145=, memcmp@FUNCTION, $pop516, $pop515, $pop514
	br_if   	0, $pop145      # 0: down to label3
# BB#38:                                # %check.exit161
	i32.const	$push521=, src
	i32.const	$push146=, 40
	i32.call	$push3=, memcpy@FUNCTION, $4, $pop521, $pop146
	i32.const	$push520=, src
	i32.const	$push519=, 40
	i32.call	$push147=, memcmp@FUNCTION, $pop3, $pop520, $pop519
	br_if   	0, $pop147      # 0: down to label3
# BB#39:                                # %check.exit165
	i32.const	$push148=, dst
	i32.const	$push526=, src
	i32.const	$push149=, 41
	i32.call	$push525=, memcpy@FUNCTION, $pop148, $pop526, $pop149
	tee_local	$push524=, $4=, $pop525
	i32.const	$push523=, src
	i32.const	$push522=, 41
	i32.call	$push150=, memcmp@FUNCTION, $pop524, $pop523, $pop522
	br_if   	0, $pop150      # 0: down to label3
# BB#40:                                # %check.exit169
	i32.const	$push529=, src
	i32.const	$push151=, 42
	i32.call	$push4=, memcpy@FUNCTION, $4, $pop529, $pop151
	i32.const	$push528=, src
	i32.const	$push527=, 42
	i32.call	$push152=, memcmp@FUNCTION, $pop4, $pop528, $pop527
	br_if   	0, $pop152      # 0: down to label3
# BB#41:                                # %check.exit173
	i32.const	$push153=, dst
	i32.const	$push534=, src
	i32.const	$push154=, 43
	i32.call	$push533=, memcpy@FUNCTION, $pop153, $pop534, $pop154
	tee_local	$push532=, $4=, $pop533
	i32.const	$push531=, src
	i32.const	$push530=, 43
	i32.call	$push155=, memcmp@FUNCTION, $pop532, $pop531, $pop530
	br_if   	0, $pop155      # 0: down to label3
# BB#42:                                # %check.exit177
	i32.const	$push537=, src
	i32.const	$push156=, 44
	i32.call	$push5=, memcpy@FUNCTION, $4, $pop537, $pop156
	i32.const	$push536=, src
	i32.const	$push535=, 44
	i32.call	$push157=, memcmp@FUNCTION, $pop5, $pop536, $pop535
	br_if   	0, $pop157      # 0: down to label3
# BB#43:                                # %check.exit181
	i32.const	$push158=, dst
	i32.const	$push542=, src
	i32.const	$push159=, 45
	i32.call	$push541=, memcpy@FUNCTION, $pop158, $pop542, $pop159
	tee_local	$push540=, $4=, $pop541
	i32.const	$push539=, src
	i32.const	$push538=, 45
	i32.call	$push160=, memcmp@FUNCTION, $pop540, $pop539, $pop538
	br_if   	0, $pop160      # 0: down to label3
# BB#44:                                # %check.exit185
	i32.const	$push545=, src
	i32.const	$push161=, 46
	i32.call	$push6=, memcpy@FUNCTION, $4, $pop545, $pop161
	i32.const	$push544=, src
	i32.const	$push543=, 46
	i32.call	$push162=, memcmp@FUNCTION, $pop6, $pop544, $pop543
	br_if   	0, $pop162      # 0: down to label3
# BB#45:                                # %check.exit189
	i32.const	$push163=, dst
	i32.const	$push550=, src
	i32.const	$push164=, 47
	i32.call	$push549=, memcpy@FUNCTION, $pop163, $pop550, $pop164
	tee_local	$push548=, $4=, $pop549
	i32.const	$push547=, src
	i32.const	$push546=, 47
	i32.call	$push165=, memcmp@FUNCTION, $pop548, $pop547, $pop546
	br_if   	0, $pop165      # 0: down to label3
# BB#46:                                # %check.exit193
	i32.const	$push553=, src
	i32.const	$push166=, 48
	i32.call	$push7=, memcpy@FUNCTION, $4, $pop553, $pop166
	i32.const	$push552=, src
	i32.const	$push551=, 48
	i32.call	$push167=, memcmp@FUNCTION, $pop7, $pop552, $pop551
	br_if   	0, $pop167      # 0: down to label3
# BB#47:                                # %check.exit197
	i32.const	$push168=, dst
	i32.const	$push558=, src
	i32.const	$push169=, 49
	i32.call	$push557=, memcpy@FUNCTION, $pop168, $pop558, $pop169
	tee_local	$push556=, $4=, $pop557
	i32.const	$push555=, src
	i32.const	$push554=, 49
	i32.call	$push170=, memcmp@FUNCTION, $pop556, $pop555, $pop554
	br_if   	0, $pop170      # 0: down to label3
# BB#48:                                # %check.exit201
	i32.const	$push561=, src
	i32.const	$push171=, 50
	i32.call	$push8=, memcpy@FUNCTION, $4, $pop561, $pop171
	i32.const	$push560=, src
	i32.const	$push559=, 50
	i32.call	$push172=, memcmp@FUNCTION, $pop8, $pop560, $pop559
	br_if   	0, $pop172      # 0: down to label3
# BB#49:                                # %check.exit205
	i32.const	$push173=, dst
	i32.const	$push566=, src
	i32.const	$push174=, 51
	i32.call	$push565=, memcpy@FUNCTION, $pop173, $pop566, $pop174
	tee_local	$push564=, $4=, $pop565
	i32.const	$push563=, src
	i32.const	$push562=, 51
	i32.call	$push175=, memcmp@FUNCTION, $pop564, $pop563, $pop562
	br_if   	0, $pop175      # 0: down to label3
# BB#50:                                # %check.exit209
	i32.const	$push569=, src
	i32.const	$push176=, 52
	i32.call	$push9=, memcpy@FUNCTION, $4, $pop569, $pop176
	i32.const	$push568=, src
	i32.const	$push567=, 52
	i32.call	$push177=, memcmp@FUNCTION, $pop9, $pop568, $pop567
	br_if   	0, $pop177      # 0: down to label3
# BB#51:                                # %check.exit213
	i32.const	$push178=, dst
	i32.const	$push574=, src
	i32.const	$push179=, 53
	i32.call	$push573=, memcpy@FUNCTION, $pop178, $pop574, $pop179
	tee_local	$push572=, $4=, $pop573
	i32.const	$push571=, src
	i32.const	$push570=, 53
	i32.call	$push180=, memcmp@FUNCTION, $pop572, $pop571, $pop570
	br_if   	0, $pop180      # 0: down to label3
# BB#52:                                # %check.exit217
	i32.const	$push577=, src
	i32.const	$push181=, 54
	i32.call	$push10=, memcpy@FUNCTION, $4, $pop577, $pop181
	i32.const	$push576=, src
	i32.const	$push575=, 54
	i32.call	$push182=, memcmp@FUNCTION, $pop10, $pop576, $pop575
	br_if   	0, $pop182      # 0: down to label3
# BB#53:                                # %check.exit221
	i32.const	$push183=, dst
	i32.const	$push582=, src
	i32.const	$push184=, 55
	i32.call	$push581=, memcpy@FUNCTION, $pop183, $pop582, $pop184
	tee_local	$push580=, $4=, $pop581
	i32.const	$push579=, src
	i32.const	$push578=, 55
	i32.call	$push185=, memcmp@FUNCTION, $pop580, $pop579, $pop578
	br_if   	0, $pop185      # 0: down to label3
# BB#54:                                # %check.exit225
	i32.const	$push585=, src
	i32.const	$push186=, 56
	i32.call	$push11=, memcpy@FUNCTION, $4, $pop585, $pop186
	i32.const	$push584=, src
	i32.const	$push583=, 56
	i32.call	$push187=, memcmp@FUNCTION, $pop11, $pop584, $pop583
	br_if   	0, $pop187      # 0: down to label3
# BB#55:                                # %check.exit229
	i32.const	$push188=, dst
	i32.const	$push590=, src
	i32.const	$push189=, 57
	i32.call	$push589=, memcpy@FUNCTION, $pop188, $pop590, $pop189
	tee_local	$push588=, $4=, $pop589
	i32.const	$push587=, src
	i32.const	$push586=, 57
	i32.call	$push190=, memcmp@FUNCTION, $pop588, $pop587, $pop586
	br_if   	0, $pop190      # 0: down to label3
# BB#56:                                # %check.exit233
	i32.const	$push593=, src
	i32.const	$push191=, 58
	i32.call	$push12=, memcpy@FUNCTION, $4, $pop593, $pop191
	i32.const	$push592=, src
	i32.const	$push591=, 58
	i32.call	$push192=, memcmp@FUNCTION, $pop12, $pop592, $pop591
	br_if   	0, $pop192      # 0: down to label3
# BB#57:                                # %check.exit237
	i32.const	$push193=, dst
	i32.const	$push598=, src
	i32.const	$push194=, 59
	i32.call	$push597=, memcpy@FUNCTION, $pop193, $pop598, $pop194
	tee_local	$push596=, $4=, $pop597
	i32.const	$push595=, src
	i32.const	$push594=, 59
	i32.call	$push195=, memcmp@FUNCTION, $pop596, $pop595, $pop594
	br_if   	0, $pop195      # 0: down to label3
# BB#58:                                # %check.exit241
	i32.const	$push601=, src
	i32.const	$push196=, 60
	i32.call	$push13=, memcpy@FUNCTION, $4, $pop601, $pop196
	i32.const	$push600=, src
	i32.const	$push599=, 60
	i32.call	$push197=, memcmp@FUNCTION, $pop13, $pop600, $pop599
	br_if   	0, $pop197      # 0: down to label3
# BB#59:                                # %check.exit245
	i32.const	$push198=, dst
	i32.const	$push606=, src
	i32.const	$push199=, 61
	i32.call	$push605=, memcpy@FUNCTION, $pop198, $pop606, $pop199
	tee_local	$push604=, $4=, $pop605
	i32.const	$push603=, src
	i32.const	$push602=, 61
	i32.call	$push200=, memcmp@FUNCTION, $pop604, $pop603, $pop602
	br_if   	0, $pop200      # 0: down to label3
# BB#60:                                # %check.exit249
	i32.const	$push609=, src
	i32.const	$push201=, 62
	i32.call	$push14=, memcpy@FUNCTION, $4, $pop609, $pop201
	i32.const	$push608=, src
	i32.const	$push607=, 62
	i32.call	$push202=, memcmp@FUNCTION, $pop14, $pop608, $pop607
	br_if   	0, $pop202      # 0: down to label3
# BB#61:                                # %check.exit253
	i32.const	$push203=, dst
	i32.const	$push614=, src
	i32.const	$push204=, 63
	i32.call	$push613=, memcpy@FUNCTION, $pop203, $pop614, $pop204
	tee_local	$push612=, $4=, $pop613
	i32.const	$push611=, src
	i32.const	$push610=, 63
	i32.call	$push205=, memcmp@FUNCTION, $pop612, $pop611, $pop610
	br_if   	0, $pop205      # 0: down to label3
# BB#62:                                # %check.exit257
	i32.const	$push617=, src
	i32.const	$push206=, 64
	i32.call	$push15=, memcpy@FUNCTION, $4, $pop617, $pop206
	i32.const	$push616=, src
	i32.const	$push615=, 64
	i32.call	$push207=, memcmp@FUNCTION, $pop15, $pop616, $pop615
	br_if   	0, $pop207      # 0: down to label3
# BB#63:                                # %check.exit261
	i32.const	$push208=, dst
	i32.const	$push622=, src
	i32.const	$push209=, 65
	i32.call	$push621=, memcpy@FUNCTION, $pop208, $pop622, $pop209
	tee_local	$push620=, $4=, $pop621
	i32.const	$push619=, src
	i32.const	$push618=, 65
	i32.call	$push210=, memcmp@FUNCTION, $pop620, $pop619, $pop618
	br_if   	0, $pop210      # 0: down to label3
# BB#64:                                # %check.exit265
	i32.const	$push625=, src
	i32.const	$push211=, 66
	i32.call	$push16=, memcpy@FUNCTION, $4, $pop625, $pop211
	i32.const	$push624=, src
	i32.const	$push623=, 66
	i32.call	$push212=, memcmp@FUNCTION, $pop16, $pop624, $pop623
	br_if   	0, $pop212      # 0: down to label3
# BB#65:                                # %check.exit269
	i32.const	$push213=, dst
	i32.const	$push630=, src
	i32.const	$push214=, 67
	i32.call	$push629=, memcpy@FUNCTION, $pop213, $pop630, $pop214
	tee_local	$push628=, $4=, $pop629
	i32.const	$push627=, src
	i32.const	$push626=, 67
	i32.call	$push215=, memcmp@FUNCTION, $pop628, $pop627, $pop626
	br_if   	0, $pop215      # 0: down to label3
# BB#66:                                # %check.exit273
	i32.const	$push633=, src
	i32.const	$push216=, 68
	i32.call	$push17=, memcpy@FUNCTION, $4, $pop633, $pop216
	i32.const	$push632=, src
	i32.const	$push631=, 68
	i32.call	$push217=, memcmp@FUNCTION, $pop17, $pop632, $pop631
	br_if   	0, $pop217      # 0: down to label3
# BB#67:                                # %check.exit277
	i32.const	$push218=, dst
	i32.const	$push638=, src
	i32.const	$push219=, 69
	i32.call	$push637=, memcpy@FUNCTION, $pop218, $pop638, $pop219
	tee_local	$push636=, $4=, $pop637
	i32.const	$push635=, src
	i32.const	$push634=, 69
	i32.call	$push220=, memcmp@FUNCTION, $pop636, $pop635, $pop634
	br_if   	0, $pop220      # 0: down to label3
# BB#68:                                # %check.exit281
	i32.const	$push641=, src
	i32.const	$push221=, 70
	i32.call	$push18=, memcpy@FUNCTION, $4, $pop641, $pop221
	i32.const	$push640=, src
	i32.const	$push639=, 70
	i32.call	$push222=, memcmp@FUNCTION, $pop18, $pop640, $pop639
	br_if   	0, $pop222      # 0: down to label3
# BB#69:                                # %check.exit285
	i32.const	$push223=, dst
	i32.const	$push646=, src
	i32.const	$push224=, 71
	i32.call	$push645=, memcpy@FUNCTION, $pop223, $pop646, $pop224
	tee_local	$push644=, $4=, $pop645
	i32.const	$push643=, src
	i32.const	$push642=, 71
	i32.call	$push225=, memcmp@FUNCTION, $pop644, $pop643, $pop642
	br_if   	0, $pop225      # 0: down to label3
# BB#70:                                # %check.exit289
	i32.const	$push649=, src
	i32.const	$push226=, 72
	i32.call	$push19=, memcpy@FUNCTION, $4, $pop649, $pop226
	i32.const	$push648=, src
	i32.const	$push647=, 72
	i32.call	$push227=, memcmp@FUNCTION, $pop19, $pop648, $pop647
	br_if   	0, $pop227      # 0: down to label3
# BB#71:                                # %check.exit293
	i32.const	$push228=, dst
	i32.const	$push654=, src
	i32.const	$push229=, 73
	i32.call	$push653=, memcpy@FUNCTION, $pop228, $pop654, $pop229
	tee_local	$push652=, $4=, $pop653
	i32.const	$push651=, src
	i32.const	$push650=, 73
	i32.call	$push230=, memcmp@FUNCTION, $pop652, $pop651, $pop650
	br_if   	0, $pop230      # 0: down to label3
# BB#72:                                # %check.exit297
	i32.const	$push657=, src
	i32.const	$push231=, 74
	i32.call	$push20=, memcpy@FUNCTION, $4, $pop657, $pop231
	i32.const	$push656=, src
	i32.const	$push655=, 74
	i32.call	$push232=, memcmp@FUNCTION, $pop20, $pop656, $pop655
	br_if   	0, $pop232      # 0: down to label3
# BB#73:                                # %check.exit301
	i32.const	$push233=, dst
	i32.const	$push662=, src
	i32.const	$push234=, 75
	i32.call	$push661=, memcpy@FUNCTION, $pop233, $pop662, $pop234
	tee_local	$push660=, $4=, $pop661
	i32.const	$push659=, src
	i32.const	$push658=, 75
	i32.call	$push235=, memcmp@FUNCTION, $pop660, $pop659, $pop658
	br_if   	0, $pop235      # 0: down to label3
# BB#74:                                # %check.exit305
	i32.const	$push665=, src
	i32.const	$push236=, 76
	i32.call	$push21=, memcpy@FUNCTION, $4, $pop665, $pop236
	i32.const	$push664=, src
	i32.const	$push663=, 76
	i32.call	$push237=, memcmp@FUNCTION, $pop21, $pop664, $pop663
	br_if   	0, $pop237      # 0: down to label3
# BB#75:                                # %check.exit309
	i32.const	$push238=, dst
	i32.const	$push670=, src
	i32.const	$push239=, 77
	i32.call	$push669=, memcpy@FUNCTION, $pop238, $pop670, $pop239
	tee_local	$push668=, $4=, $pop669
	i32.const	$push667=, src
	i32.const	$push666=, 77
	i32.call	$push240=, memcmp@FUNCTION, $pop668, $pop667, $pop666
	br_if   	0, $pop240      # 0: down to label3
# BB#76:                                # %check.exit313
	i32.const	$push673=, src
	i32.const	$push241=, 78
	i32.call	$push22=, memcpy@FUNCTION, $4, $pop673, $pop241
	i32.const	$push672=, src
	i32.const	$push671=, 78
	i32.call	$push242=, memcmp@FUNCTION, $pop22, $pop672, $pop671
	br_if   	0, $pop242      # 0: down to label3
# BB#77:                                # %check.exit317
	i32.const	$push244=, dst
	i32.const	$push243=, src
	i32.const	$push245=, 79
	i32.call	$push23=, memcpy@FUNCTION, $pop244, $pop243, $pop245
	i32.const	$push675=, src
	i32.const	$push674=, 79
	i32.call	$push246=, memcmp@FUNCTION, $pop23, $pop675, $pop674
	br_if   	0, $pop246      # 0: down to label3
# BB#78:                                # %check.exit321
	i32.const	$push247=, 0
	return  	$pop247
.LBB1_79:                               # %if.then.i320
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	src                     # @src
	.type	src,@object
	.section	.bss.src,"aw",@nobits
	.globl	src
	.p2align	4
src:
	.skip	80
	.size	src, 80

	.hidden	dst                     # @dst
	.type	dst,@object
	.section	.bss.dst,"aw",@nobits
	.globl	dst
	.p2align	4
dst:
	.skip	80
	.size	dst, 80


	.ident	"clang version 3.9.0 "
