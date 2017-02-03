C MODULE SFBASN
C-----------------------------------------------------------------------
C
C  ROUTINE TO DEFINE BASIN PARAMETERS.
C
      SUBROUTINE SFBASN (LARRAY,ARRAY,DISP,PRPARM,PRNOTE,PLOT,NFLD,
     *   IRUNCK,ISTAT)
C
      CHARACTER*(*) DISP,PRPARM,PRNOTE,PLOT
      CHARACTER*4 TDISP,RDISP,WDISP
      CHARACTER*4 UNITS,XUNITS
      CHARACTER*8 BASNID,PID,PXID,TID
      CHARACTER*20 DESCRP
      CHARACTER*20 CHAR/' '/,CHK/' '/
C
      DIMENSION ARRAY(LARRAY)
      DIMENSION TELLMTS(2)
C
      INCLUDE 'uio'
      INCLUDE 'scommon/sudbgx'
      INCLUDE 'scommon/sworkx'
      INCLUDE 'ufreex'
      INCLUDE 'scommon/suerrx'
      INCLUDE 'scommon/suoptx'
      INCLUDE 'scommon/sugnlx'
      INCLUDE 'scommon/sntwfx'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/ppinit_define/RCS/sfbasn.f,v $
     . $',                                                             '
     .$Id: sfbasn.f,v 1.4 2003/03/14 18:56:10 dws Exp $
     . $' /
C    ===================================================================
C
C
C
      IF (ISTRCE.GT.0) THEN
         WRITE (IOSDBG,890)
         CALL SULINE (IOSDBG,1)
         ENDIF
C
C  SET DEBUG LEVEL
      LDEBUG=ISBUG('BASN')
C
      ISTAT=0
C      
      LCHAR=LEN(CHAR)/4     
      LCHK=LEN(CHK)/4
C
      UNUSD=-999.
      UNDEF=-997.
C
      NUMERR=0
      NUMWRN=0
C
      ISTRT=-1
C
      NERR=0
      IBERR=0
      IPERR=0
      ILAT=0
      IZERO=0
      IFLD=0
      IFIRST=1
      IENDIN=0
      NBSNEW=0
      NBSOLD=0
      NBSNCG=0
      IBSNCG=0
      LATFLD=0
      AREA=UNDEF
      UAREA=UNDEF
      ELEV=UNDEF
      ISTP=0
      NBPTS=0
      IFLAT=1
      IFLON=1
      NOPFLD=0
      ILPFND=0
      IRPFND=0
      TDISP=DISP
C
C  SET UP WORK SPACE POINTERS
      IDIV=15
      ID=LSWORK/IDIV
C  X:
      ID1=1
C  Y:
      ID2=ID+1
C  LATITUDE:
      ID3=ID*2+1
C  LONGITUDE:
      ID4=ID*3+1
C  JX:
      ID5=ID*4+1
C  JY:
      ID6=ID*5+1
C  IY:
      ID7=ID*6+1
C  IXB:
      ID8=ID*8+1
C  IXE:
      ID9=ID*10+1
C  OLD LAT:
      ID10=ID*12+1
C  OLD LONGITUDE:
      ID11=ID*13+1
C  JN:
      ID12=ID*14+1
C      
      MBPTS=ID
      MSEGS=ID
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,*) 'IN SFBASN -',
     *      ' LSWORK=',LSWORK,
     *      ' IDIV=',IDIV,
     *      ' MBPTS=',MBPTS,
     *      ' MSEGS=',MSEGS,
     *      ' '
         CALL SULINE (IOSDBG,1)
         ENDIF
C
C  PRINT CARD
      CALL SUPCRD
C
C  PRINT OPTIONS
      WRITE (LP,900) DISP,PLOT,PRNOTE,PRPARM
      CALL SULINE (LP,2)
C
C  SAVE CURRENT VALUE OF SPACING FACTOR FOR PRINTING CARD IMAGES
      ICDOLD=ICDSPC
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF SUGNLX COMMON BLOCK FILLED
      IF (IUGFIL.EQ.0) THEN
C     READ LIMITS FOR LAT/LON AND ELEVATION
         CALL SUGTUG (LARRAY,ARRAY,IERR)
         IF (IERR.NE.0) THEN
            WRITE (LP,920) 'UGNL'
            CALL SUERRS (LP,2,NUMERR)
            ENDIF
         ENDIF
C
C  READ COMPUTATIONAL ORDER GENERAL PARAMETERS
      INCLUDE 'scommon/callsugtor'
      IF (IERR.GT.0) THEN
         WRITE (LP,920) 'ORDR'
         CALL SUERRS (LP,2,NUMERR)
         ENDIF
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  GET NEXT INPUT FIELD
C
10    IFLD=IFLD+1
      NULL=1
C
20    CALL UFIELD (NFLD,ISTRT,LENGTH,ITYPE,NREP,INT,REAL,
     *   LCHAR,CHAR,LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,IERR)
      IF (LDEBUG.GT.0) THEN
         CALL UPRFLD (NFLD,ISTRT,LENGTH,ITYPE,NREP,INT,REAL,
     *      LCHAR,CHAR,LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,IERR)
         ENDIF
C
C  CHECK FOR END OF FILE
      IF (NFLD.NE.-1) GO TO 30
         IENDIN=1
         IF (IFIRST.EQ.1) GO TO 870
            GO TO 710
C
C  CHECK FOR NULL FIELD
30    IF (IERR.NE.1) NULL=0
C
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,910) NOPFLD,ILPFND,IRPFND
         CALL SULINE (IOSDBG,1)
         ENDIF
C
C  CHECK FOR PARENTHESES
      IF (LLPAR.GT.0) CALL UFPACK (LCHK,CHK,ISTRT,1,LLPAR-1,IERR)
      IF (LLPAR.EQ.0) CALL UFPACK (LCHK,CHK,ISTRT,1,LENGTH,IERR)
C
C  CHECK FOR DEBUG
      CALL SUIDCK ('CMDS',CHAR,NFLD,0,ICMD,IERR)
      IF (ICMD.EQ.1) THEN
         CALL SBDBUG (NFLD,ISTRT,IERR)
         LDEBUG=ISBUG('BASN')
         GO TO 20
         ENDIF
C
      IF (NFLD.NE.1) GO TO 50
      IF (LATSGN.NE.0) GO TO 50
      IF (CHK.EQ.'BASN'.AND.IFIRST.EQ.1) GO TO 50
      CALL SUIDCK ('DEFN',CHAR,NFLD,0,IREF,ICK)
      IF (ICK.EQ.2) GO TO 50
      IF (CHK.NE.'BASN') CALL SUPCRD
C
C  CHECK FOR COMMAND OR KEYWORD
50    IF (LATSGN.EQ.1) THEN
         IENDIN=1
         GO TO 710
         ENDIF
      IF (ICK.EQ.2) GO TO 710
C
C  CHECK FOR REPEAT FIELDS
      IF (NREP.NE.-1) THEN
         WRITE (LP,930) IFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 10
         ENDIF
C
C  CHECK FOR NULL FIELD
      IF (NULL.EQ.0) GO TO 90
      IF (DISP.EQ.'OLD') GO TO 80
         WRITE (LP,940) IFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 10
C
80    IF (IFLD.LT.4) GO TO 10
C
C  CHECK FOR APPROPRIATE FIELD
90    IF (IFLD.GT.3) GO TO 100
      GO TO (140,230,350),IFLD
C
C  CHECK FOR OPTIONAL KEYWORDS
100   IF (NOPFLD.GT.0) GO TO (110,410,410),NOPFLD
110   NOPFLD=0
      IF (CHK.EQ.'BASN') THEN
         NOPFLD=1
         INDOPT=1
         GO TO 130
         ENDIF
      IF (CHK.EQ.'AREA') THEN
         NOPFLD=2
         INDOPT=1
         GO TO 130
         ENDIF
      IF (CHK.EQ.'ELEV') THEN
         NOPFLD=3
         INDOPT=1
         GO TO 130
         ENDIF
      GO TO 550
C
C  SET SPACING FACTOR FOR PRINTING CARD IMAGES TO OLD VALUE
130   ICDSPC=ICDOLD
C
C  PROCESS OPTIONAL FIELDS
      GO TO (140,390,390),NOPFLD
      WRITE (LP,950) NFLD,CHAR(1:LENSTR(CHAR))
      CALL SUERRS (LP,2,NUMERR)
      GO TO 10
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  FIRST FIELD
C
140   IF (ITYPE.EQ.2) GO TO 150
         WRITE (LP,960) IFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 10
C
150   IF (CHK.NE.'BASN') THEN
         WRITE (LP,960) IFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 10
         ENDIF
C
      IF (ILAT.EQ.0) GO TO 180
         WRITE (LP,1160) IFLD
         CALL SUERRS (LP,2,NUMERR)
         IF (LATFLD.GE.6.AND.(LATFLD/2)*2.EQ.LATFLD) GO TO 170
            WRITE (LP,970)
            CALL SUERRS (LP,2,NUMERR)
170      NBPTS=LATFLD/2
         ILAT=0
         LATFLD=0
         GO TO 710
C
180   IF (ISTP.EQ.1) GO TO 710
      IF (IFIRST.EQ.0) GO TO 710
      UNITS='ENGL'
      IF (LLPAR.GT.0.AND.LRPAR.GT.0) GO TO 190
      IF (PRNOTE.EQ.'YES') THEN
         WRITE (LP,980)
         CALL SULINE (LP,2)
         ENDIF
      GO TO 210
C
190   CALL UFPACK (1,CHK,ISTRT,LLPAR+1,LRPAR-1,IERR)
      IF (IERR.LT.1.AND.
     *    (CHK.EQ.'ENGL'.OR.CHK.EQ.'METR')) GO TO 200
         WRITE (LP,990)
         CALL SUWRNS (LP,2,NUMWRN)
200   IF (CHK.EQ.'METR') UNITS='METR'
C
210   IF (IFIRST.EQ.1) GO TO 220
      GO TO 710
C
220   IFIRST=0
      GO TO 10
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  SECOND FIELD - BASIN IDENTIFIER
C
230   MAXCHR=LEN(BASNID)
      IF (LENGTH.GT.MAXCHR) THEN
         WRITE (LP,1000) 'IDENTIFIER',LENGTH,MAXCHR,MAXCHR
         CALL SUWRNS (LP,2,NUMWRN)
         ENDIF
      CALL SUBSTR (CHAR,1,MAXCHR,BASNID,1)
      IF (BASNID.EQ.' ') THEN
         WRITE (LP,1020) 'IDENTIFIER'
         CALL SUERRS (LP,2,NUMERR)
         GO TO 10
         ENDIF
      CALL SUIDCK ('ID  ',BASNID,NFLD,0,IREF,IERR)
      IF (IERR.EQ.2) THEN
         WRITE (LP,1030) BASNID
         CALL SUERRS (LP,2,NUMERR)
         ENDIF
C
C  READ BASN PARAMETERS
      IPTR=0
      IPRERR=0
      CALL SRBASN (ARRAY,LARRAY,IVBASN,BASNID,DESCRP,
     *   SWORK(ID3),SWORK(ID4),
     *   ID,NBPTS,AREA,CAREA,ELEV,XC,YC,MAPFLG,MATFLG,PID,TID,PXID,
     *   ID,NSEGS,SWORK(ID7),SWORK(ID8),SWORK(ID9),LFACTR,
     *   IPTR,IPTRNX,IPRERR,IERR)
      IEXIST=IERR
      IF (IERR.NE.0) THEN
         MAPFLG=0
         MATFLG=0
         PID=' ' 
         PXID=' '
         TID=' '
         ENDIF
      UAREA=AREA
      UELEV=ELEV
      IF (AREA.LT.-996.9.AND.AREA.GT.-997.1) THEN
         ELSE
            IF (UNITS.EQ.'ENGL') THEN
               CALL UDUCNV ('KM2 ' ,'MI2 ' ,1,1,UAREA,AREA,IERR)
               ENDIF
         ENDIF
      DO 290 I=1,NBPTS
         SWORK(ID10+I-1)=SWORK(ID3+I-1)
         SWORK(ID11+I-1)=SWORK(ID4+I-1)
290      CONTINUE
      NBPOLD=NBPTS
C
      IF (IEXIST.EQ.1) THEN
         WRITE (LP,1040)
         CALL SUERRS (LP,2,NUMERR)
         GO TO 10
         ENDIF
      IF (IEXIST.EQ.3) THEN
         WRITE (LP,1050) LARRAY
         CALL SUERRS (LP,2,NUMERR)
         GO TO 10
         ENDIF
      IF (IEXIST.EQ.0.AND.DISP.EQ.'NEW') THEN
         WRITE (LP,1060) BASNID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 10
         ENDIF
      IF (IEXIST.EQ.2.AND.DISP.EQ.'OLD') THEN
         TDISP='NEW'
         WRITE (LP,1070) BASNID,TDISP(1:LENSTR(TDISP))
         CALL SUWRNS (LP,2,NUMWRN)
         GO TO 10
         ENDIF                 
      GO TO 10
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  THIRD FIELD - BASIN DESCRIPTION
C
350   MAXCHR=LEN(DESCRP)
      IF (LENGTH.GT.MAXCHR) THEN
         WRITE (LP,1000) 'DESCRIPTION',LENGTH,MAXCHR,MAXCHR
         CALL SUWRNS (LP,2,NUMWRN)
         ENDIF
      CALL SUBSTR (CHAR,1,MAXCHR,DESCRP,1)
      IF (DESCRP.EQ.' ') THEN
         WRITE (LP,1020) 'DESCRIPTION'
         CALL SUERRS (LP,2,NUMERR)
         ENDIF
      GO TO 10
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  OPTIONAL FIELDS
C
C  GET REAL VALUE FOR OPTIONAL KEYWORD
390   IF (ILAT.EQ.0) GO TO 410
         WRITE (LP,1150) IFLD-1
         CALL SUWRNS (LP,2,NUMWRN)
         IF (LATFLD.GE.6.AND.(LATFLD/2)*2.EQ.LATFLD) GO TO 400
            WRITE (LP,970)
            CALL SUERRS (LP,2,NUMERR)
400      NBPTS=LATFLD/2
         ISTP=1
         ILAT=0
         LATFLD=0
      IF (NOPFLD.EQ.1) GO TO 10
410   IF (LLPAR.GT.0) ILPFND=1
      IF (ILPFND.GT.0) GO TO 420
         IF (LLPAR.EQ.0) GO TO 10
420   IF (LLPAR.EQ.LENGTH) GO TO 10
      IF (LRPAR.GT.0) IRPFND=1
      IF (LRPAR.EQ.0) GO TO 430
         INDOPT=0
         IF (LRPAR.EQ.1) GO TO 530
430   IBEG=LLPAR+1
      IEND=LRPAR-1
      IF (LLPAR.EQ.0) IBEG=1
      IF (LRPAR.EQ.0) IEND=LENGTH
      CALL UFRLFX (VALUE,ISTRT,IBEG,IEND,IZERO,IERR)
      IF (IERR.EQ.0) GO TO 440
         WRITE (LP,1090) IFLD,CHAR(1:LENSTR(CHAR))
         CALL SUWRNS (LP,2,NUMWRN)
         GO TO 530
C
440   IF (NOPFLD.EQ.2) GO TO 490
      IF (NOPFLD.EQ.3) GO TO 450
         WRITE(LP,1170)
         CALL SUERRS (LP,2,NUMERR)
         GO TO 10
C
C  BASIN ELEVATION
C
450   XUNITS='M'
      CALL UMEMOV (ELLMTS,TELLMTS,2)
      IF (UNITS.EQ.'ENGL') THEN
         CALL UDUCNV ('M   ','FT  ',1,2,ELLMTS,TELLMTS,IERR)
         XUNITS='FT'
         ENDIF
      IF (VALUE.GE.TELLMTS(2).AND.VALUE.LE.TELLMTS(1)) GO TO 470
         WRITE (LP,1100) VALUE,TELLMTS,XUNITS
         CALL SUERRS (LP,2,NUMERR)
         GO TO 530
470   ELEV=VALUE
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,1110) 'ELEVATION',ELEV
         CALL SULINE (IOSDBG,1)
         ENDIF
      UELEV=ELEV
      IF (ELEV.GT.-997.1.AND.ELEV.LT.-996.9) GO TO 480
      IF (UNITS.EQ.'ENGL') THEN
         CALL UDUCNV ('FT  ','M   ',1,1,ELEV,UELEV,IERR)
         IF (IERR.NE.0) THEN
            WRITE (LP,1130) IERR
            CALL SUERRS (LP,2,NUMERR)
            ENDIF
         ENDIF
480   GO TO 530
C
C  BASIN AREA
C
490   AREA=VALUE
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,1110) 'AREA',AREA
         CALL SULINE (IOSDBG,1)
         ENDIF
      IF (TDISP.EQ.'NEW') GO TO 530
      UAREA=AREA
      IF (UNITS.EQ.'ENGL') THEN
         CALL UDUCNV ('MI2 ' ,'KM2 ' ,1,1,AREA,UAREA,IERR)
         ENDIF
      IF (UAREA.EQ.0.0) DIF=.00001
      IF (UAREA.GT.0.0) DIF=ABS((UAREA-CAREA)/UAREA)
      IF (DIF.LT.0.05) GO TO 530
      IDIF=DIF*100+.99
      IF (UNITS.EQ.'ENGL') GO TO 510
         WRITE (LP,1140) UAREA,'KM2 ',CAREA,'KM2 ',IDIF
         CALL SULINE (LP,2)
         GO TO 530
510   CALL UDUCNV ('KM2 ' ,'MI2 ' ,1,1,CAREA,ECAREA,IERR)
      WRITE (LP,1140) AREA,'MI2 ',ECAREA,'MI2 ',IDIF
      CALL SULINE (LP,2)
C
530   IF (INDOPT.EQ.1) GO TO 10
      IF (ILPFND.EQ.1.AND.IRPFND.EQ.1) GO TO 540
         WRITE (LP,1080) IFLD,CHAR(1:LENSTR(CHAR))
         CALL SUWRNS (LP,2,NUMWRN)
540   ILPFND=0
      IRPFND=0
      NOPFLD=0
      GO TO 10
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  LAT/LON POINTS
C
C  SET INDICATOR TO PRINT CARD IMAGES SINGLE SPACED
550   ICDSPC=0
C
C  CHECK FOR NULL FIELD
      IF (NULL.EQ.1) GO TO 10
C      
      IF (ILAT.EQ.0.AND.LLPAR.EQ.0) THEN
         WRITE (LP,1150) IFLD
         CALL SUWRNS (LP,2,NUMWRN)
         ENDIF
      IF (ILAT.EQ.1.AND.LLPAR.GT.0) THEN
         WRITE (LP,960) IFLD
         CALL SUERRS (LP,2,NUMERR)
         ENDIF
C
      IF (LLPAR.GT.0.AND.LENGTH.EQ.1) GO TO 700
      IF (LRPAR.GT.0.AND.LENGTH.EQ.1) GO TO 600
      LATFLD=LATFLD+1
      IB=LLPAR+1
      IE=LENGTH
      IF (LRPAR.EQ.0) GO TO 620
      IE=LRPAR-1
600   IF (LATFLD.GE.6.AND.(LATFLD/2)*2.EQ.LATFLD) GO TO 610
         WRITE (LP,970)
         CALL SUERRS (LP,2,NUMERR)
         ILAT=0
         GO TO 10
610   ISTP=1
      NBPTS=LATFLD/2
      IF (LRPAR.GT.0.AND.LENGTH.EQ.1) GO TO 700
620   CALL UFRLFX (VALUE,ISTRT,IB,IE,IZERO,IERR)
      IF (IERR.EQ.0) THEN
         IF (VALUE.NE.0.0) GO TO 640
         ENDIF
      WRITE (LP,1180) IFLD
      CALL SUERRS (LP,2,NUMERR)
C
640   IF ((LATFLD/2)*2.NE.LATFLD) GO TO 670
C
      IF (IFLON.LE.ID) GO TO 650
         WRITE (LP,1210) LSWORK
         CALL SUERRS (LP,2,NUMERR)
650   IF (VALUE.GE.ULLMTS(3).AND.VALUE.LE.ULLMTS(4)) GO TO 660
         WRITE (LP,1220) VALUE,ULLMTS(3),ULLMTS(4)
         CALL SUERRS (LP,2,NUMERR)
         GO TO 700
660   SWORK(ID4+IFLON-1)=VALUE
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,1190) IFLON,VALUE
         CALL SULINE (IOSDBG,1)
         ENDIF
      IFLON=IFLON+1
      GO TO 700
C
670   IF (IFLAT.LE.ID) GO TO 680
         WRITE (LP,1210) LSWORK
         CALL SUERRS (LP,2,NUMERR)
680   IF (VALUE.GE.ULLMTS(2).AND.VALUE.LE.ULLMTS(1)) GO TO 690
         WRITE (LP,1230) VALUE,ULLMTS(2),ULLMTS(1)
         CALL SUERRS (LP,2,NUMERR)
         GO TO 700
690   SWORK(ID3+IFLAT-1)=VALUE
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,1200) IFLAT,VALUE
         CALL SULINE (IOSDBG,1)
         ENDIF
      IFLAT=IFLAT+1
C
700   ILAT=1
      IF (ISTP.EQ.1) ILAT=0
      GO TO 10
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF ANY PARAMETERS SPECIFIED
710   IF (BASNID.EQ.' ') THEN
         WRITE (LP,1240)
         CALL SUWRNS (LP,2,NUMWRN)
         GO TO 870
         ENDIF
C
C  CHECK IF ANY BASIN BOUNDARY POINTS SPECIFIED
      IF (NBPTS.EQ.0) THEN
         WRITE (LP,1250) BASNID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 870
         ENDIF
C
      IF (TDISP.EQ.'OLD') THEN
C     CHECK IF NUMBER OF LAT/LON POINTS CHANGED
         IF (NBPTS.NE.NBPOLD) GO TO 750
C     CHECK IF LAT/LON POINTS CHANGED
         DO 740 I=1,NBPTS
            IDX=ID3+I-1
            IDY=ID10+I-1
            IF (SWORK(IDX).GT.SWORK(IDY)-0.001.AND.
     *          SWORK(IDX).LT.SWORK(IDY)+0.001) THEN
                ELSE
                   GO TO 750
                ENDIF
            IDX=ID4+I-1
            IDY=ID11+I-1
            IF (SWORK(IDX).GT.SWORK(IDY)-0.001.AND.
     *          SWORK(IDX).LT.SWORK(IDY)+0.001) THEN
                ELSE
                   GO TO 750
                ENDIF
740         CONTINUE
         GO TO 760
         ENDIF
C
750   MAPFLG=0
      MATFLG=0
      IBSNCG=1
C
C  CHECK IF BASIN BEING REDEFINED AND IS USED BY AN MAPX AREA      
      IF (TDISP.EQ.'OLD'.AND.PXID.NE.' ') THEN
         NBSNCG=NBSNCG+1
         ENDIF
C
760   IBERR=NERR-IPERR
      IF (IBERR.NE.0) THEN
         IF (TDISP.EQ.'NEW') THEN
            WRITE (LP,1260) BASNID,IBERR
            CALL SULINE (LP,2)
            ENDIF
         IF (TDISP.EQ.'OLD') THEN
            WRITE (LP,1270) BASNID,IBERR
            CALL SULINE (LP,2)
            ENDIF
         GO TO 870
         ENDIF
C
      IF (ISTP.NE.1) GO TO 790
      IF (TDISP.NE.'OLD') GO TO 780
CCC      IF (IBSNCG.EQ.0) GO TO 790
C
C  COMPUTE GRID POINT DEFINITION AND BASIN CENTROID
780   IDIM=ID*2
      CALL SFBDRV (SWORK(ID1),SWORK(ID2),SWORK(ID3),SWORK(ID4),
     *   SWORK(ID7),SWORK(ID8),SWORK(ID9),IDIM,NBPTS,LFACTR,AREA,UAREA,
     *   CAREA,XC,YC,UNITS,NSEGS,IERR)
      IF (IERR.GT.0) GO TO 760
C
C  CHECK IF RUNCHECK OPTION SPECIFIED
790   IF (IRUNCK.EQ.1) GO TO 870
C
      IF (LDEBUG.EQ.0) GO TO 810
         WRITE (IOSDBG,1290) NSEGS
         CALL SULINE (IOSDBG,1)
         DO 800 I=1,NSEGS
            CALL SFCONV (IY,SWORK(ID7+I-1),1)
            CALL SFCONV (IXB,SWORK(ID8+I-1),1)
            CALL SFCONV (IXE,SWORK(ID9+I-1),1)
            WRITE (IOSDBG,1300) I,IY,IXB,IXE
            CALL SULINE (IOSDBG,1)
800         CONTINUE
C
C  WRITE BASN PARAMETERS
810   IVBASN=2
      NSPACE=1
      CALL SWBASN (ARRAY,LARRAY,IVBASN,BASNID,DESCRP,
     *   SWORK(ID3),SWORK(ID4),
     *   NBPTS,UAREA,CAREA,UELEV,XC,YC,MAPFLG,MATFLG,PID,TID,PXID,
     *   NSEGS,SWORK(ID7),SWORK(ID8),SWORK(ID9),LFACTR,
     *   TDISP,NSPACE,IERR)
      IF (IERR.NE.0) GO TO 760
C
C  READ NTWK PARAMETER ARRAY
      RDISP='OLD'
      CALL SUGTNF (LARRAY,ARRAY,RDISP,NUMERR,IERR)
      IF (IERR.NE.0) THEN
         WRITE (LP,1280)
         CALL SULINE (LP,2)
         GO TO 760
         ENDIF
C
      IF (TDISP.EQ.'OLD'.AND.IBSNCG.EQ.1) THEN
C     SET NETWORK INDICATORS IF USED BY AN MAP OR MAT AREA
         INTWK=0
         IF (PID.NE.' ') THEN
            INWFLG(9)=1
            INTWK=1
            ENDIF
         IF (TID.NE.' ') THEN
            INWFLG(10)=1
            INTWK=1
            ENDIF
         IF (INTWK.EQ.1) THEN
C        UPDATE NTWK PARAMETERS
            WDISP='OLD'
            CALL SWNTWK (IVNTWK,UNUSD,NNWFLG,INWFLG,INWDTE,
     *         LARRAY,ARRAY,WDISP,IERR)
            IF (IERR.GT.0) GO TO 760
            ENDIF
         ENDIF
C
C  READ BASN PARAMETERS
      IPTR=0
      IPRERR=1
      CALL SRBASN (ARRAY,LARRAY,IVBASN,BASNID,DESCRP,
     *   SWORK(ID3),SWORK(ID4),
     *   ID,NBPTS,UAREA,CAREA,UELEV,XC,YC,MAPFLG,MATFLG,PID,TID,PXID,
     *   ID,NSEGS,SWORK(ID7),SWORK(ID8),SWORK(ID9),LFACTR,
     *   IPTR,IPTRNX,IPRERR,IERR)
      IF (IERR.NE.0) GO TO 760
C
C  PRINT BASIN PARAMETERS
      IF (PRPARM.EQ.'YES') THEN
         IPLOT=0
         IF (PLOT.EQ.'YES') IPLOT=1
         IF (PLOT.EQ.' ') IPLOT=IOPPLT
         CALL SPBASN (BASNID,DESCRP,SWORK(ID3),SWORK(ID4),NBPTS,
     *      UAREA,UELEV,CAREA,
     *      SWORK(ID7),SWORK(ID8),SWORK(ID9),NSEGS,XC,YC,
     *      MAPFLG,MATFLG,
     *      PID,TID,PXID,UNITS,
     *      LFACTR,SWORK(ID1),SWORK(ID2),SWORK(ID5),SWORK(ID6),
     *      IVBASN,IPLOT,SWORK(ID12),IERR)
         ENDIF
C
      IF (TDISP.EQ.'NEW') THEN
         NBSNEW=NBSNEW+1
         ENDIF
      IF (TDISP.EQ.'OLD') THEN
         NBSOLD=NBSOLD+1
         IF (IBSNCG.EQ.1) ICBASN=1
         ENDIF
C
870   IF (IENDIN.EQ.1) GO TO 880
C
      IF (CHK.EQ.'BASN') THEN
         CALL SUPCRD
C     REINITIALIZE VARIABLES
         CALL UREPET (' ',BASNID,8)
         NBPTS=0
         ISTP=0
         ICK=0
         IPERR=NERR
         IFIRST=1
         IFLD=1
         LATFLD=0
         IFLAT=1
         IFLON=1
         AREA=-997.
         ELEV=-997.
         TDISP=DISP
         NOPFLD=0
         IBSNCG=0
         GO TO 180
         ENDIF
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
880   IF (NBSNEW.GT.0) THEN
         WRITE (LP,1310) NBSNEW
         CALL SULINE (LP,2)
         ENDIF
      IF (NBSOLD.GT.0) THEN
         WRITE (LP,1320) NBSOLD
         CALL SULINE (LP,2)
         ENDIF
C         
      IF (IRUNCK.EQ.0) THEN
         IF (NBSNCG.GT.0) THEN
C        UPDATE GENERAL COMPUTATIONAL ORDER PARAMETERS
            INCLUDE 'scommon/callsuwtor'
            ENDIF
         ENDIF
C
      IF (NERR.GT.0) ISTAT=1
C
C  RESET SPACING FACTOR FOR PRINTING CARD IMAGES TO OLD VALUE
      ICDSPC=ICDOLD
C
      IF (ISTRCE.GT.0) THEN
         WRITE (IOSDBG,1330)
         CALL SULINE (IOSDBG,1)
         ENDIF
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
890   FORMAT (' *** ENTER SFBASN')
900   FORMAT ('0DEFINE OPTIONS IN EFFECT :  ',
     *   'DISP=',A,3X,
     *   'PLOT=',A,3X,
     *   'PRNTNOTE=',A,3X,
     *   'PRNTPARM=',A,3X,
     *   ' ')
910   FORMAT (' NOPFLD=',I2,3X,'ILPFLD=',I2,3X,'LRPFND=',I2)
920   FORMAT ('0*** ERROR - ERROR ENCOUNTERED READING ',A,' ',
     *   'PARAMETERS.')
930   FORMAT ('0*** ERROR - A REPEAT FACTOR WAS FOUND IN FIELD ',I3,
     *   '.')
940   FORMAT ('0*** ERROR - NULL FIELD NOT ALLOWED IN FIELD ',I3,'.')
950   FORMAT ('0*** ERROR - INVALID OPTION FOUND IN FIELD ',I3,' : ',A)
960   FORMAT ('0*** ERROR - INVALID CHARACTERS IN FIELD ',I3,'.')
970   FORMAT ('0*** ERROR - INVALID NUMBER OF LAT/LON POINTS WERE ',
     *   'ENTERED.')
980   FORMAT ('0*** NOTE - NO UNITS WERE SPECIFIED FOR THIS BASIN. ',
     *   'ENGLISH UNITS ASSUMED.')
990   FORMAT ('0*** WARNING - UNITS MUST BE ''ENGL'' OR ''METR''. ',
     *   'ENGLISH UNITS ASSUMED.')
1000  FORMAT ('0*** WARNING - NUMBER OF CHARACTERS IN THE BASIN ',A,
     *   ' (',I2,') EXCEEDS ',I2,'. ',
     *   'THE FIRST ',I2,' CHARACTERS WILL BE USED.')
1020  FORMAT ('0*** ERROR - BLANK BASIN ',A,' IS NOT ALLOWED.')
1030  FORMAT ('0*** ERROR - THE BASIN ID (',A,') CONTAINS A SET ',
     *   'OF RESERVED CHARACTERS.')
1040  FORMAT ('0*** ERROR - SYSTEM ERROR ACCESSING FILE.')
1050  FORMAT ('0*** ERROR - PARAMETER ARRAY DIMENSION (',I4,
     *   ') IS NOT LARGE ENOUGH.')
1060  FORMAT ('0*** ERROR - PARAMETER RECORD FOR BASIN ',A,
     *   ' ALREADY EXISTS. SET DISP=OLD TO REDEFINE.')
1070  FORMAT ('0*** WARNING - PARAMETER RECORD FOR BASIN ',A,
     *   ' DOES NOT EXIST. DISP ASSUMED TO BE ',A,'.')
1080  FORMAT ('0*** WARNING - MISSING PARENTHESIS IN FIELD ',I3,'.')
1090  FORMAT ('0*** WARNING - INVALID NUMBER IN FIELD ',I3,
     *   '. ASSUME ',A,' UNDEFINED.')
1100  FORMAT ('0*** ERROR - THE BASIN ELEVATION (',F7.1,') DOES NOT ',
     *   'FALL WITHIN THE USER DEFINED LIMITS OF ',F7.1,' AND ',F7.1,
     *   1X,A2,'.')
1110  FORMAT (' USER SPECIFIED ',A,' SET TO ',F10.2)
1130  FORMAT ('0*** ERROR - UNIT CONVERSION FOR ELEVATION VALUE COULD ',
     *   'NOT BE PERFORMED. STATUS=',I3)
1140  FORMAT ('0*** NOTE - THE SPECIFIED AREA (',F7.1,1X,A3,')',
     *   ' DIFFERS ',
     *   'FROM THE PREVIOUSLY COMPUTED AREA (',F7.1,1X,A3,') BY ',I5,
     *   ' PERCENT.')
1150  FORMAT ('0*** WARNING - MISSING PARENTHESIS IN FIELD ',I3,'.')
1160  FORMAT ('0*** ERROR - MISSING PARENTHESIS IN FIELD ',I3,'.')
1170  FORMAT ('0*** ERROR - INVALID OPTIONAL FIELD. ')
1180  FORMAT ('0*** ERROR - INVALID REAL NUMBER IN FIELD ',I3,'.')
1190  FORMAT (' LONGITUDE POINT NUMBER ',I3,' SET TO ',F10.3)
1200  FORMAT (' LATITUDE POINT NUMBER ',I3,' SET TO ',F10.3)
1210  FORMAT ('0*** ERROR - IN SFBASN - DIMENSION (',I5,') OF WORK ',
     *   'SPACE ARRAY HAS BEEN EXCEEDED.')
1220  FORMAT ('0*** ERROR - THE LONGITUDE (',F7.2,') DOES NOT FALL ',
     *   'WITHIN THE USER DEFINED LIMITS OF ',F7.2,5H AND ,F7.2,'.')
1230  FORMAT ('0*** ERROR - THE LATITUDE  (',F7.2,') DOES NOT FALL ',
     *   'WITHIN THE USER DEFINED LIMITS OF ',F7.2,' AND ',F7.2,'.')
1240  FORMAT ('0*** WARNING - NO BASN PARAMETER VALUES SPECIFIED.')
1250  FORMAT ('0*** ERROR - NO LAT/LON POINTS WERE SPECIFIED FOR ',
     *   'BASIN ',A,'.')
1260  FORMAT ('0*** NOTE - BASIN ',A,' WAS NOT DEFINED BECAUSE ',I3,
     *   ' ERROR ENCOUNTERED.')
1270  FORMAT ('0*** NOTE - BASIN ',A,' WAS NOT REDEFINED BECAUSE ',I3,
     *   ' ERROR ENCOUNTERED.')
1280  FORMAT ('0*** NOTE - NTWK PARAMETERS NOT SUCCESSFULLY ',
     *   'READ. BASINS CANNOT BE DEFINED.')
1290  FORMAT (' NSEGS=',I4)
1300  FORMAT (' SEGMENT ',I4,' : IY=',I5,3X,'IXB=',I5,3X,
     *   'IXE=',I5)
1310  FORMAT ('0*** NOTE - ',I4,' BASINS SUCCESSFULLY DEFINED.')
1320  FORMAT ('0*** NOTE - ',I4,' BASINS SUCCESSFULLY REDEFINED.')
1330  FORMAT (' *** EXIT SFBASN')
C
      END
