C MODULE SFMAT
C-----------------------------------------------------------------------
C
C  ROUTINE TO DEFINE MAT AREA PARAMETERS.
C
      SUBROUTINE SFMAT (LARRAY,ARRAY,DISP,PRPARM,PLOT,NFLD,
     *   IRUNCK,ISTAT)
C
      CHARACTER*4 TUNITS
      CHARACTER*8 TYPERR,STRING,FTID
C
      REAL XMAT/4HMAT /,XOLD/4HOLD /,XNEW/4HNEW /,BLNK/4H    /
      REAL PRE/4HPRE /,DP/4HDP  /,GRID/4HGRID/
      REAL XNO/4HNO  /
      REAL ENGL/4HENGL/
C
      DIMENSION ARRAY(LARRAY)
      PARAMETER (LCHAR=10,LUCHAR=10,LCHK=5)
      DIMENSION CHAR(LCHAR),UCHAR(LUCHAR),CHK(LCHK)
      DIMENSION TID(2),DESC(5),FLTLN(2)
      DIMENSION BASNID(2)
      PARAMETER (LWKBUF=500)
      DIMENSION IWKBUF(LWKBUF)
      PARAMETER (LXBUF=1)
      DIMENSION XBUF(LXBUF)
      DIMENSION BDESC(5),CENTRD(2)
      DIMENSION STAID(2),STACOR(2)
      DIMENSION TIDX(2),PID(2),PXID(2)
      DIMENSION BASOLD(2),CENOLD(2)
C
      INCLUDE 'uio'
      INCLUDE 'ufielx'
      INCLUDE 'ufreex'
      INCLUDE 'scommon/sudbgx'
      INCLUDE 'scommon/suerrx'
      INCLUDE 'scommon/sworkx'
      INCLUDE 'scommon/suoptx'
      INCLUDE 'scommon/sugnlx'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/ppinit_define/RCS/sfmat.f,v $
     . $',                                                             '
     .$Id: sfmat.f,v 1.3 1998/07/06 12:36:02 page Exp $
     . $' /
C    ===================================================================
C
C
C
      IF (ISTRCE.GT.0) THEN
         WRITE (IOSDBG,960)
         CALL SULINE (IOSDBG,1)
         ENDIF
C
C  SET DEBUG LEVEL
      LDEBUG=ISBUG('MAT ')
C
C  INITIALIZE POINTERS
      IDIV=15
      IDIM=LSWORK/IDIV
C  STATION WEIGHT ID'S:
      ID1=1
C  STATION WEIGHTS:
      ID2=IDIM*2+1
C  ARRAY POINTERS:
      ID3=IDIM*3+1
C  STATION COORDINATES:
      ID4=IDIM*4+1
C  LATITUDES:
      ID5=IDIM*6+1
C  LONGITUDES:
      ID6=IDIM*7+1
C  IY:
      ID7=IDIM*8+1
C  IXB:
      ID8=IDIM*9+1
C  IXE:
      ID9=IDIM*10+1
C 
      MBPTS=IDIM
      MSEGS=IDIM
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,*) 'IN SFMAT -',
     *      ' LSWORK=',LSWORK,
     *      ' IDIV=',IDIV,
     *      ' MBPTS=',MBPTS,
     *      ' MSEGS=',MSEGS,
     *      ' '
         CALL SULINE (IOSDBG,1)
         ENDIF    
C
      ISTAT=0
C      
      MINFLD=4
      UNSD=-999.
      NMAT=0
      NUMNEW=0
      NUMOLD=0
      NUMERR=0
      NUMWRN=0
      IZERO=0
      NERR=0
      IBERR=0
      IPERR=0
      UNUSED(1)=UNSD
      UNUSED(2)=UNSD
      ISTRT=-1
      IDT=6
C
C  PRINT CARD
      CALL SUPCRD
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  READ USER DEFINED DEFAULTS
      CALL SUGTUG (LARRAY,ARRAY,IERR)
      IF (IERR.NE.0) THEN
         WRITE (LP,980)
         CALL SUERRS (LP,2,NUMERR)
         ELSE
            IF (LDEBUG.GT.0) THEN
C           PRINT UGNL PARAMETERS
               UNITS=ENGL
               INCLUDE 'scommon/callspugnl'
               ENDIF
         ENDIF
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF SUFFICIENT CPU TIME AVAILABLE
20    ICKRGN=0
      ICKCPU=1
      MINCPU=5
      IPRERR=1
      IPUNIT=LP
      TYPERR='ERROR'
      INCLUDE 'clugtres'
      IF (IERR.NE.0) THEN
         CALL SUFATL
         CALL SUEND
         ENDIF
C
      NUMFLD=0
      IENDIN=0
      MATFLG=0
      IREWT=0
      IUBASN=0
      CENOLD(1)=0.
      CENOLD(2)=0.
      IWTOLD=0
      IBSNID=0
      POWER=-997.
      IFLD=0
      ISTWT=0
      JWT=1
      JID=1
      IWTFLD=0
      IPERR=NERR
      NTEMP=0
      MTEMP=0
      TDISP=DISP
      CALL UREPET ('?',TID,8)
      CALL UREPET (' ',BASNID,8)
      FLTLN(1)=0.
      FLTLN(2)=0.
      NUMSTA=1
C
40    IFLD=IFLD+1
      IF (IFLD.EQ.1.AND.NMAT.GT.0) GO TO 120
      NULL=1
C
C  GET INPUT FIELD
50    CALL UFLDRD (NFLD,CHAR,LCHAR,LDEBUG,IERR)
C
C  CHECK FOR ERRORS
      IF (IERR.EQ.2.OR.IERR.EQ.4) THEN
         CALL UFLDST (NFLD,ISTRT,LENGTH,ITYPE,NREP,INTEGR,REAL,
     *      LCHAR,CHAR,LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,IERR,
     *      NUMERR,NUMWRN)
         ENDIF
C
C  CHECK FOR NULL FIELD
      IF (IERR.NE.1) NULL=0
C
C  CHECK FOR END OF FILE
      IF (IERR.NE.3) GO TO 60
         NFLD=-1
         GO TO 130
C
C  CHECK FOR DEBUG
60    CALL SUIDCK ('CMDS',CHAR,NFLD,0,ICMD,IRETRN)
      IF (ICMD.NE.1) GO TO 70
         CALL SBDBUG (NFLD,ISTRT,IERR)
         LDEBUG=ISBUG('MAT ')
         GO TO 50
C
C  CHECK FOR COMMAND
70    IF (LATSGN.EQ.1) GO TO 130
C
C  CHECK FOR PARENTHESES IN FIELD
      IF (LLPAR.GT.0) CALL UFPACK (LCHK,CHK,ISTRT,1,LLPAR-1,IERR)
      IF (LLPAR.EQ.0) CALL UFPACK (LCHK,CHK,ISTRT,1,LENGTH,IERR)
C
      IF (NFLD.NE.1) GO TO 80
      IF (LATSGN.NE.0) GO TO 80
      IF (CHK(1).EQ.XMAT.AND.NUMFLD.EQ.0) GO TO 80
      CALL SUIDCK ('DEFN',CHK,NFLD,0,IREF,IRETRN)
      IF (IRETRN.EQ.2) GO TO 80
      CALL SUPCRD
C
C  CHECK FOR NULL FIELD
80    IF (NULL.EQ.0) GO TO 100
      IF (DISP.EQ.XOLD.AND.TDISP.NE.XNEW) GO TO 90
      IF (IFLD.EQ.5.AND.IBSNID.EQ.1) GO TO 100
         IF (IFLD.EQ.6) GO TO 100
            WRITE (LP,1140) IFLD
            CALL SUERRS (LP,2,NUMERR)
            GO TO 40
C
90    IF (IFLD.LT.4) GO TO 40
C
100   IF (NUMFLD.EQ.0) GO TO 120
C
C  CHECK FOR KEYWORD
      CALL SUIDCK ('DEFN',CHK,NFLD,0,IREF,IRETRN)
      IF (IRETRN.EQ.2) GO TO 730
      IF (ISTWT.EQ.1) GO TO 600
      IF (IBSNID.EQ.1) GO TO 110
         IF (IFLD.EQ.5) GO TO 410
         IF (IFLD.EQ.6) GO TO 460
110   IF (IFLD.EQ.5) GO TO 460
C
120   NUMFLD=NUMFLD+1
      GO TO (140,160,260,320),IFLD
         WRITE (LP,970) IFLD
         CALL SUERRS (LP,2,NUMERR)
         NUMFLD=NUMFLD-1
         GO TO 40
C
C  CHECK IF ALL FIELDS INPUT
130   IF (IBSNID.EQ.0) NBSFLD=6
      IF (IBSNID.EQ.1) NBSFLD=5
      IF (IFLD-1.GE.NBSFLD) GO TO 730
         IENDIN=1
         IF (IBSNID.EQ.0) GO TO 560
         GO TO 730
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  FIRST FIELD - AREA TYPE 'MAT' INDICATOR
C
140   IF (ITYPE.NE.2) THEN
         WRITE (LP,990) IFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 40
         ENDIF
C
      IF (CHK(1).NE.XMAT) THEN
         WRITE (LP,990) IFLD
         CALL SUERRS (LP,2,NUMERR)
         ENDIF
C
C  CHECK IF UNITS CODE SPECIFIED
      IF (LLPAR.GT.0) THEN
         IEND=LRPAR-1
         IF (LRPAR.EQ.0) IEND=LENGTH
         LSTRING=LEN(STRING)/4
         CALL UFPACK (LSTRING,STRING,ISTRT,LLPAR+1,IEND,IERR)
         IF (STRING.EQ.'ENGL'.OR.STRING.EQ.'METR') THEN
            WRITE (LP,995) 'UNITS CODE',
     *         NFLD,STRING(1:LENSTR(STRING)), 'WILL BE IGNORED.'
            CALL SUWRNS (LP,2,NUMWRN)
            ELSE
               WRITE (LP,995) 'UNRECOGNIZED CHARACTERS',
     *            NFLD,STRING(1:LENSTR(STRING)),'.'
               CALL SUWRNS (LP,2,NUMWRN)
            ENDIF
         ENDIF
C         
      GO TO 40
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  SECOND FIELD - AREA IDENTIFIER
C
C  CHECK LENGTH OF IDENTIFIER
160   MAXCHR=8
      IF (LENGTH.LE.MAXCHR) GO TO 170
         WRITE (LP,1240) LENGTH,MAXCHR,MAXCHR
         CALL SUWRNS (LP,2,NUMWRN)
170   CALL SUBSTR (CHAR,1,MAXCHR,TID,1)
      NMAT=NMAT+1
C
C  CHECK FOR BLANK IDENTIFIER
      IF (TID(1).NE.BLNK.OR.TID(2).NE.BLNK) GO TO 180
         WRITE (LP,1250)
         CALL SUERRS (LP,2,NUMERR)
         GO TO 190
180   CALL SUIDCK ('ID  ',TID,NFLD,0,IREF,IRETRN)
      IF (IRETRN.NE.2) GO TO 190
         WRITE (LP,1260) TID
         CALL SUERRS (LP,2,NUMERR)
C
C  READ MAT AREA PARAMETERS
190   IPTR=0
      IPRERR=0
      CALL SRMAT (IVMAT,TID,DESC,FLTLN,BASNID,IWT,POWER,
     *   IDIM,NTEMP,SWORK(ID1),SWORK(ID3),SWORK(ID2),
     *   UNUSED,LARRAY,ARRAY,IPTR,IZERO,IPTRNX,ISMAT)
C
C  SAVE OLD VALUES
      MTEMP=NTEMP
      CALL SUBSTR (BASNID,1,8,BASOLD,1)
      IWTOLD=IWT
      POWOLD=POWER
      IF (ISMAT.EQ.0) THEN
         CALL SBLLGD (FLTLN(2),FLTLN(1),1,CENOLD(1),CENOLD(2),1,IERR)
         ENDIF
C
C  CHECK FOR SYSTEM ERROR ACCESSING FILE
      IF (ISMAT.NE.1) GO TO 200
         WRITE (LP,1010)
         CALL SUERRS (LP,2,NUMERR)
         GO TO 250
C
C  CHECK IF PARAMETER ARRAY TOO SMALL
200   IF (ISMAT.NE.3) GO TO 210
         WRITE (LP,1020) LARRAY
         CALL SUERRS (LP,2,NUMERR)
         GO TO 250
C
C  CHECK IF PARAMETER ARRAY EXISTS AND DISP IS NEW
210   IF (ISMAT.EQ.0.AND.DISP.EQ.XNEW) GO TO 220
         GO TO 230
220   WRITE (LP,1030) TID
      CALL SUERRS (LP,2,NUMERR)
      GO TO 250
C
C  CHECK IF PARAMETER ARRAY DOES NOT EXISTS AND DISP IS OLD
230   IF (ISMAT.EQ.2.AND.DISP.EQ.XOLD) GO TO 240
         GO TO 250
240   WRITE (LP,1050) TID
      TDISP=XNEW
      CALL SUWRNS (LP,2,NUMWRN)
C
C  CHECK TO SEE IF TIME SERIES EXISTS
250   INDPM=0
      IF (ISMAT.EQ.0) INDPM=1
      CALL SFTSCK (TID,'MAT ',LXBUF,INDPM,IPMWRT,ITSWRT,IDT,
     *   TDISP,NUMERR,NUMWRN,IERR)
      GO TO 40
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  THIRD FIELD - AREA DESCRIPTION
C
260   IF (NULL.EQ.0) GO TO 270
         IF (DISP.EQ.XNEW.OR.TDISP.EQ.XNEW) GO TO 300
C
C  CHECK LENGTH OF IDENTIFIER
270   MAXCHR=20
      IF (LENGTH.LE.MAXCHR) GO TO 280
         WRITE (LP,1060) LENGTH,MAXCHR,MAXCHR
         CALL SUWRNS (LP,2,NUMWRN)
280   CALL SUBSTR (CHAR,1,MAXCHR,DESC,1)
C
C  CHECK FOR BLANK DESCRIPTION
      DO 290 I=1,5
         IF (DESC(I).NE.BLNK) GO TO 310
290      CONTINUE
300   WRITE (LP,1070)
      CALL SUERRS (LP,2,NUMERR)
310   GO TO 40
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  FOURTH FIELD - BASIN BOUNDARY IDENTIFIER OR LATITUDE OF CENTRIOD
C
320   IF (DISP.EQ.XNEW.OR.TDISP.EQ.XNEW) GO TO 340
      IF (BASNID(1).EQ.BLNK.AND.BASNID(2).EQ.BLNK) GO TO 330
         IBSNID=1
         IF (NULL.EQ.1) GO TO 40
            GO TO 340
330   IBSNID=0
      IF (NULL.EQ.0) GO TO 340
         IFLD=IFLD+1
         GO TO 40
C
C  CHECK IF PARENTHESES FOUND IN FIELD
340   IF (LLPAR.GT.0.OR.LRPAR.GT.0) GO TO 400
C
C  NO PARENTHESES FOUND - BASIN ID SPECIFIED
      IBSNID=1
      CALL SUBSTR (CHAR,1,8,BASNID,1)
C
      IF (BASNID(1).NE.BLNK.OR.BASNID(2).NE.BLNK) GO TO 350
         WRITE (LP,1140) IFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 190
C
C  CHECK IF BASIN PARAMETERS DEFINED
350   IPTR=0
      IPRERR=0  
      CALL SRBASN (ARRAY,LARRAY,IVBASN,BASNID,BDESC,SWORK(ID5),
     *   SWORK(ID6),IDIM,NBPTS,AREA,CAREA,ELEV,CENTRD(1),CENTRD(2),
     *   MAPFLG,MATFLG,PID,TIDX,PXID,IDIM,NSEGS,SWORK(ID7),SWORK(ID8),
     *   SWORK(ID9),LFACTR,IPTR,IPTRNX,IPRERR,IERR)
      IF (IERR.EQ.0) GO TO 380
         IF (IERR.NE.2) GO TO 360
            WRITE (LP,1270) BASNID
            CALL SUERRS (LP,2,NUMERR)
            GO TO 390
360      IF (IERR.NE.1) GO TO 370
            WRITE (LP,1010)
            CALL SUERRS (LP,2,NUMERR)
            GO TO 390
370      WRITE (LP,1020) LARRAY
         CALL SUERRS (LP,2,NUMERR)
         GO TO 390
380   CALL SUBSTR (CENTRD,1,8,CENOLD,1)
C
C  SET STATION WEIGHT TYPE
      IWT=2
C
C  CONVERT FROM LAT/LON TO GRID COORDINATES
      CALL SBLLGD (FLTLN(2),FLTLN(1),1,CENTRD(1),CENTRD(2),0,IERR)
C
C  CHECK BASIN ID AGAINST MAT AREA ID
      IF ((TIDX(1).EQ.BLNK.AND.TIDX(2).EQ.BLNK).OR.
     *    (TIDX(1).EQ.TID(1).AND.TIDX(2).EQ.TID(2))) GO TO 390
         WRITE (LP,1180) BASNID,TIDX
         CALL SUERRS (LP,2,NUMERR)
C
C  CHECK FOR REDEFINE
390   IF (BASNID(1).EQ.BASOLD(1).AND.BASNID(2).EQ.BASOLD(2)) GO TO 40
      IREWT=1
      IUBASN=1
      GO TO 40
C
C
C   SET LATITUDE OF CENTRIOD
400   IBSNID=0
C
410   IB=LLPAR+1
      IE=LENGTH
      IF (LRPAR.GT.0) IE=LRPAR-1
      CALL UFRLFX (VALUE,ISTRT,IB,IE,IZERO,IERR)
      IF (IERR.EQ.0) GO TO 420
         WRITE (LP,1090) IFLD
         CALL SUERRS (LP,2,NUMERR)
C
420   IF (IFLD.NE.4) GO TO 440
      IF (VALUE.GE.ULLMTS(2).AND.VALUE.LE.ULLMTS(1)) GO TO 430
         WRITE (LP,1160) VALUE,ULLMTS(2),ULLMTS(1)
         CALL SUERRS (LP,2,NUMERR)
         GO TO 40
430   FLTLN(1)=VALUE
      GO TO 40
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  FIFTH FIELD - LONG OF CENTRIOD IF NO BASIN BOUNDARY
C
440   IF (VALUE.GE.ULLMTS(3).AND.VALUE.LE.ULLMTS(4)) GO TO 450
      WRITE (LP,1150) VALUE,ULLMTS(3),ULLMTS(4)
      CALL SUERRS (LP,2,NUMERR)
      GO TO 40
C
450   FLTLN(2)=VALUE
      IF (FLTLN(1).GT.0.AND.FLTLN(2).GT.0)
     *   CALL SBLLGD (FLTLN(2),FLTLN(1),1,CENTRD(1),CENTRD(2),1,IERR)
      CALL UREPET (' ',BASNID,8)
C
C  CHECK FOR REDEFINE
      IF (CENTRD(1).LT.CENOLD(1)-0.001.OR.CENTRD(1).GT.CENOLD(1)+0.001)
     *   IREWT=1
      IF (CENTRD(2).LT.CENOLD(2)-0.001.OR.CENTRD(2).GT.CENOLD(2)+0.001)
     *   IREWT=1
      GO TO 40
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  SIXTH FIELD IF NO BASIN ID (FIFTH IF BASIN ID USED) - TYPE OF STATION
C  WEIGHTS
C
460   IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,1190) NFLD,NULL,IBSNID
         CALL SULINE (IOSDBG,1)
         ENDIF
      IWT=0
      IF (NULL.EQ.1.AND.IBSNID.EQ.1.AND.(DISP.EQ.XNEW.OR.TDISP.EQ.XNEW))
     *   GO TO 540
      IF (NULL.EQ.1.AND.IBSNID.EQ.0.AND.(DISP.EQ.XNEW.OR.TDISP.EQ.XNEW))
     *   GO TO 560
      IF (NULL.EQ.1) GO TO 40
      IF (LLPAR.EQ.0) GO TO 470
         CALL UFPACK (LUCHAR,UCHAR,ISTRT,1,LLPAR-1,IERR)
         GO TO 480
470   CALL UFPACK (LUCHAR,UCHAR,ISTRT,1,LENGTH,IERR)
480   IF (IERR.EQ.0) GO TO 490
         WRITE (LP,1200) UCHAR
         CALL SUERRS (LP,2,NUMERR)
C
490   IF (UCHAR(1).EQ.PRE) GO TO 500
      IF (UCHAR(1).EQ.GRID) GO TO 540
      IF (UCHAR(1).EQ.DP) GO TO 560
         WRITE (LP,1200) UCHAR
         CALL SUERRS (LP,2,NUMERR)
         IF (LLPAR.EQ.0) GO TO 40
C
C  PREDETERMINED WEIGHTS
500   IF (LLPAR.GT.0) GO TO 510
         WRITE (LP,1080) IFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 40
510   IB=LLPAR+1
      IE=LENGTH
      CALL UFPACK (LUCHAR,UCHAR,ISTRT,IB,IE,IERR)
      IF (IERR.EQ.0) GO TO 520
         WRITE (LP,1220) UCHAR(1),UCHAR(2)
         CALL SUERRS (LP,2,NUMERR)
         GO TO 40
C
520   IWT=1
      ISTWT=1
      IWTFLD=1
      IF (JID.LE.IDIM*2) GO TO 530
         WRITE (LP,1170) LSWORK
         CALL SUERRS (LP,2,NUMERR)
         GO TO 40
530   SWORK(ID1+JID-1)=UCHAR(1)
      SWORK(ID1+JID)=UCHAR(2)
      JID=JID+2
      GO TO 680
C
C  GRID POINT WEIGHTS
540   IWT=2
      IF (IBSNID.EQ.1) GO TO 550
         WRITE (LP,1310)
         CALL SUERRS (LP,2,NUMERR)
550   IF (IENDIN.EQ.1) GO TO 730
      GO TO 40
C
C  1/D**POWER WEIGHTS
560   IWT=3
      POWER=DPOWER(2)
      IF (LLPAR.EQ.0) GO TO 590
         IB=LLPAR+1
         IE=LENGTH
         IF (LRPAR.GT.0) IE=LRPAR-1
         CALL UFRLFX (VALUE,ISTRT,IB,IE,IZERO,IERR)
         IF (IERR.GT.0) GO TO 570
            IF (VALUE.LT.0) GO TO 570
            GO TO 580
570      WRITE (LP,1090) IFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 40
580   POWER=VALUE
      GO TO 40
C
590   WRITE (LP,1230) POWER
      CALL SULINE (LP,2)
      IF (IENDIN.EQ.1) GO TO 730
      GO TO 40
C
C  PREDETERMINED STATION WEIGHT FIELDS
600   IF (LLPAR.EQ.0) GO TO 605
         WRITE (LP,990) IFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 40
605   IF ((LRPAR.LE.0).OR.(LENGTH.NE.1)) GOTO 610
         ISTWT=0
         GOTO 40
610   IWTFLD=IWTFLD+1
      IF ((IWTFLD/2)*2.NE.IWTFLD) GO TO 650
      IF (ITYPE.EQ.2) GO TO 620
         VALUE=REAL
         GO TO 630
620   IB=1
      IE=LENGTH
      IF (LRPAR.GT.0) IE=LRPAR-1
      CALL UFRLFX (VALUE,ISTRT,IB,IE,IZERO,IERR)
C
630   IF (JWT.LE.IDIM) GO TO 640
         WRITE (LP,1170) LSWORK
         CALL SUERRS (LP,2,NUMERR)
         GO TO 40
640   SWORK(ID2+JWT-1)=VALUE
      JWT=JWT+1
      IF (LRPAR.GT.0) ISTWT=0
      GO TO 40
C
650   IF (LLPAR.EQ.0.AND.LRPAR.EQ.0) GO TO 660
         WRITE (LP,990) IFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 40
660   IF (JID.LE.IDIM*2) GO TO 670
         WRITE (LP,1170) LSWORK
         CALL SUERRS (LP,2,NUMERR)
         GO TO 40
670   SWORK(ID1+JID-1)=CHAR(1)
      SWORK(ID1+JID)=CHAR(2)
      JID=JID+2
C
C  MAKE PREDETERMINED STATION CHECKS
C
C  CHECK IF STATION EXISTS
680   STAID(1)=SWORK(ID1+JID-3)
      STAID(2)=SWORK(ID1+JID-2)
      CALL SFSCHK (LARRAY,ARRAY,STAID,'TEMP',STACOR,IPPP24,IPPPVR,
     *   IPEA24,IPTM24,NUMERR,IERR)
      IF (IERR.GT.0) GO TO 690
         IF (IPTM24.GT.0) GO TO 690
            WRITE (LP,1290) IPTM24,STAID
            CALL SUERRS (LP,2,NUMERR)
C
C  CHECK FOR DUPLICATE NAMES
690   IF (NUMSTA.EQ.1) GO TO 720
      NUM=NUMSTA-1
      DO 700 I=1,NUM
         IF (STAID(1).EQ.SWORK(ID1+I*2-2).AND.STAID(2).EQ.
     *      SWORK(ID1+I*2-1)) GO TO 710
700      CONTINUE
         GO TO 720
710   WRITE (LP,1300) STAID
      CALL SUERRS (LP,2,NUMERR)
720   NUMSTA=NUMSTA+1
      SWORK(ID4+JID-3)=STACOR(1)
      SWORK(ID4+JID-2)=STACOR(2)
      CALL SFCONV (SWORK(ID3+NUMSTA-2),IPTM24,1)
      GO TO 40
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK NUMBER OF FIELDS PROCESSED
730   IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,1110) NUMFLD,MINFLD
         CALL SULINE (IOSDBG,1)
         ENDIF
      IF (NUMFLD.GE.MINFLD) GO TO 740
         WRITE (LP,1120)
         CALL SUERRS (LP,2,NUMERR)
C
C  MAKE PREDETERMINED WEIGHT CHECKS
740   IF (IWT.NE.1) GO TO 770
      WTSUM=0.0
      NTEMP=IWTFLD/2
      IF (NTEMP.EQ.0) NTEMP=MTEMP
      IF (NTEMP.LE.IDIM) GO TO 750
         WRITE (LP,1000) NTEMP
         CALL SUERRS (LP,2,NUMERR)
750   DO 760 I=1,NTEMP
         WTSUM=SWORK(ID2+I-1)+WTSUM
760      CONTINUE
      IF (WTSUM.GT.0.99999.AND.WTSUM.LT.1.00001) GO TO 770
         WRITE (LP,1100) WTSUM
         CALL SUWRNS (LP,2,NUMWRN)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF ERRORS ENCOUNTERED
770   IBERR=NERR-IPERR
      IF (IBERR.EQ.0) GO TO 780
         WRITE (LP,1130) TID,IBERR
         CALL SULINE (LP,2)
         GO TO 930
C
780   IF (IPMWRT.NE.1) GO TO 930
      IF (IWT.NE.3) GO TO 790
         IF (POWER.LT.POWOLD-0.001.OR.POWER.GT.POWOLD+0.001) IREWT=1
790   IF (MATFLG.EQ.0) IREWT=1
C
C  COMPUTE MAT STATION WEIGHTS
      IF (IWT.EQ.1) GO TO 800
      IF (IWT.EQ.IWTOLD.AND.IREWT.EQ.0) GO TO 800
      IPARM=3
      JTYPE=IWT
      IF (IWT.EQ.2) JTYPE=1
      CALL SFADRV (TID,ARRAY,LARRAY,IPARM,JTYPE,POWER,STMNWT,NSEGS,
     *   LFACTR,SWORK(ID7),SWORK(ID8),SWORK(ID9),CENTRD(1),CENTRD(2),
     *   IDIM,NTEMP,SWORK(ID1),SWORK(ID2),SWORK(ID3),SWORK(ID4),IERR)
      IF (IERR.NE.0) GO TO 770
C
C  CHECK SIZE OF TIME SERIES WORK ARRAY
800   NPDT=1
      NXBUF=0
      CALL SUPRDW ('MAT ',LWKBUF,IDT,NPDT,NXBUF,1,LENBUF,NUMERR,IERR)
      IF (IERR.EQ.0) GO TO 810
         WRITE (LP,1040)
         CALL SULINE (LP,2)
         GO TO 770
C
C  CHECK IF RUNCHECK OPTION SPECIFIED
810   IF (IRUNCK.EQ.1) GO TO 930
C
C  OPEN PROCESSED DATA BASE
      CALL SUDOPN (1,'PRD ',IERR)
      IF (IERR.GT.0) GO TO 770
C
C  SET MAT STATUS INDICATOR TO INCOMPLETE
      ICUGNL(2)=1
      WDISP=XOLD
      INCLUDE 'scommon/callswugnl'
      CALL SUPCLS (1,'USER',IERR)
C      
      INDERR=0
      NVALX=0
      FTID=' '
C      
      IF (ITSWRT.NE.1) GO TO 830
C
C  WRITE TIME SERIES HEADERS
      CALL WPRDH (TID,'MAT ',IDT,'DEGC',NVALX,FLTLN,FTID,DESC,
     *   NXBUF,XBUF,LWKBUF,IWKBUF,IREC,IERR)
      IF (IERR.NE.0) THEN
         CALL SWPRST ('WPRDH   ',TID,'MAT ',IDT,'DEGC',FTID,
     *      LWKBUF,NVALX,IERR)
         IF (IERR.NE.8) THEN
            INDERR=1
            GO TO 860
            ENDIF
         GO TO 850
         ENDIF
      WRITE (LP,1370) 'WRITTEN',TID
      CALL SULINE (LP,2)
      CALL SUDWRT (1,'PRD ',IERR)
      GO TO 850
C
830   IF (ITSWRT.NE.2) GO TO 850
C
C  UPDATE TIME SERIES HEADER
      TUNITS=' '
      CALL WPRDC (TID,'MAT ',TUNITS,FLTLN,DESC,FTID,NXBUF,XBUF,
     *   LWKBUF,IWKBUF,IREC,IERR)
      IF (IERR.NE.0) THEN
         CALL SWPRST ('WPRDC   ',TID,'MAT ',IDT,'DEGC',FTID,
     *      LWKBUF,NVALX,IERR)
         IF (IERR.NE.8) THEN
            INDERR=1
            GO TO 860
            ENDIF
         GO TO 850
         ENDIF
      WRITE (LP,1370) 'UPDATED',TID
      CALL SULINE (LP,2)
      CALL SUDWRT (1,'PRD ',IERR)
C
C  WRITE MAT PARAMETERS
850   IVMAT=1
      NSPACE=1
      CALL SWMAT (IVMAT,TID,DESC,FLTLN,BASNID,IWT,POWER,
     *   NTEMP,SWORK(ID1),SWORK(ID3),SWORK(ID2),UNUSED,LARRAY,ARRAY,
     *   IPTR,TDISP,NSPACE,IERR)
      IF (IERR.NE.0) INDERR=1
C
C  SET MAT STATUS INDICATOR TO COMPLETE
860   ICUGNL(2)=0
      WDISP=XOLD
      INCLUDE 'scommon/callswugnl'
C
C  CHECK FOR ERRORS OCCUR FROM PREVIOUS STEPS
      IF (INDERR.EQ.1) GO TO 770
C
C  CHECK IF BASIN BOUNDAY USED
      IF (IBSNID.NE.1) GO TO 890
C
C  CHECK IF BASIN BOUNDAY PARAMETERS NEED TO BE UPDATED
      IF (IUBASN.EQ.0.AND.MATFLG.EQ.1) GO TO 890
C
C  WRITE MAT IDENTIFIER IN BASIN PARAMETER RECORD
      IPTR=0
      CALL RPPREC (BASNID,'BASN',IPTR,LARRAY,ARRAY,NFILL,IPTRNX,IERR)
      IF (IERR.NE.0) THEN
         CALL SRPPST (BASNID,'BASN',IPTR,LARRAY,NFILL,IPTRNX,IERR)
         GO TO 770
         ENDIF
      ARRAY(16)=TID(1)
      ARRAY(17)=TID(2)
      MATFLG=1
      ARRAY(19)=MATFLG+.01
      IPTR=0
      CALL WPPREC (BASNID,'BASN',NFILL,ARRAY,IPTR,IERR)
      IF (IERR.NE.0) THEN
         CALL SWPPST (BASNID,'BASN',NFILL,IPTR,IERR)
         GO TO 770
         ENDIF
      WRITE (LP,1390) BASNID
      CALL SULINE (LP,2)
C
C  CHECK IF OLD BASIN BOUNDARY PARAMETERS NEED TO BE UPDATED
890   IF (TDISP.EQ.XNEW) CALL SUBSTR (BASNID,1,8,BASOLD,1)
      IF (BASOLD(1).EQ.BLNK.AND.BASOLD(2).EQ.BLNK) GO TO 920
      IF (BASNID(1).EQ.BASOLD(1).AND.BASNID(2).EQ.BASOLD(2)) GO TO 920
C
C  UPDATE OLD BASIN BOUNDARY PARAMETERS
      IPTR=0
      CALL RPPREC (BASOLD,'BASN',IPTR,LARRAY,ARRAY,NFILL,IPTRNX,IERR)
      IF (IERR.NE.0) THEN
         CALL SRPPST (BASOLD,'BASN',IPTR,LARRAY,NFILL,IPTRNX,IERR)
         GO TO 770
         ENDIF
      ARRAY(16)=BLNK
      ARRAY(17)=BLNK
      MATFLG=0
      ARRAY(19)=MATFLG+.01
      CALL WPPREC (BASOLD,'BASN',NFILL,ARRAY,IPTR,IERR)
      IF (IERR.NE.0) THEN
         CALL SWPPST (BASOLD,'BASN',NFILL,IPTR,IERR)
         GO TO 770
         ENDIF
      WRITE (LP,1390) BASOLD
      CALL SULINE (LP,2)
C
C  READ MAT PARAMETERS
920   IPTR=0
      IPRERR=1
      CALL SRMAT (IVMAT,TID,DESC,FLTLN,BASNID,IWT,POWER,
     *   IDIM,NTEMP,SWORK(ID1),SWORK(ID3),SWORK(ID2),UNUSED,
     *   LARRAY,ARRAY,IPTR,IPRERR,IPTRNX,IERR)
      IF (IERR.NE.0) GO TO 770
C
      IF (TDISP.EQ.XNEW) NUMNEW=NUMNEW+1
      IF (TDISP.EQ.XOLD) NUMOLD=NUMOLD+1
C
      IF (PRPARM.EQ.XNO) GO TO 930
C
C  FUTURE ENHANCEMENT:
C  INCLUDE ARGUMENTS IN CALL TO SPMAT TO PLOT BASIN BOUNDARY.
      IPRNT=1
      UNITS=ENGL
      CALL SPMAT (IPRNT,UNITS,IVMAT,TID,DESC,FLTLN,BASNID,IWT,POWER,
     *   NTEMP,SWORK(ID1),SWORK(ID3),SWORK(ID2),
     *   UNUSED,LARRAY,ARRAY,IERR)
      IF (IERR.NE.0) GO TO 770
C
930   IF (NFLD.EQ.-1) GO TO 940
      IF (CHK(1).NE.XMAT) GO TO 940
         CALL SUPCRD
         GO TO 20
C
940   WRITE (LP,1330) NMAT
      CALL SULINE (LP,2)
      IF (NUMNEW.GT.0) THEN
         WRITE (LP,1340) NUMNEW
         CALL SULINE (LP,2)
         ENDIF
      IF (NUMOLD.GT.0) THEN
         WRITE (LP,1350) NUMOLD
         CALL SULINE (LP,2)
         ENDIF
      IF (NUMNEW.EQ.0.AND.NUMOLD.EQ.0) THEN
         WRITE (LP,1360)
         CALL SULINE (LP,2)
         ENDIF
      IF (NERR.GT.0) ISTAT=1
C
      IF (ISTRCE.LT.1) GO TO 950
         WRITE (IOSDBG,1400) ISTAT
         CALL SULINE (IOSDBG,1)
C
950   RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
960   FORMAT (' *** ENTER SFMAT')
970   FORMAT ('0*** ERROR - PROCESSING FIELD ',I2,'.')
980   FORMAT ('0*** ERROR - MAT AREA CANNOT BE DEFINED BECAUSE ',
     *   'GENERAL USER PARAMETERS NOT DEFINED.')
990   FORMAT ('0*** ERROR - INVALID CHARACTER IN FIELD ',I2,'.')
995   FORMAT ('0*** WARNING - ',A,' ',
     *   'FOUND IN PARENTHESES IN FIELD ',I2,' (',A,')',A)
1000  FORMAT ('0*** ERROR - IN SFMAT - THE NUMBER OF PREDETERMINED ',
     *   'STATION WEIGHTS (',I3,') EXCEEDS THE ARRAY DIMENSION (',
     *   I3,').')
1010  FORMAT ('0*** ERROR - SYSTEM ERROR ACCESSING FILE.')
1020  FORMAT ('0*** ERROR - PARAMETER ARRAY DIMENSION (',I4,
     *   ') IS TOO SMALL.')
1030  FORMAT ('0*** ERROR - MAT PARAMETER EXIST FOR AREA ',2A4,'.')
1040  FORMAT ('0*** NOTE - NO MAT TIME SERIES CANNOT BE CREATED ',
     *   'OR CHANGED DUE TO THE ABOVE ERROR.')
1050  FORMAT ('0*** WARNING - MAT PARAMETER RECORD FOR AREA ',2A4,
     *   ' DOES NOT EXIST. DISP ASSUMED TO BE NEW.')
1060  FORMAT ('0*** WARNING - NUMBER OF CHARACTERS IN AREA ',
     *   'DESCRIPTION (',I2,') EXCEEDS ',I2,'. THE FIRST ',I2,
     *   ' CHARACTERS WILL BE USED.')
1070  FORMAT ('0*** ERROR - BLANK DESCRIPTION NOT ALLOWED.')
1080  FORMAT ('0*** WARNING - MISSING PARENTHESIS IN FIELD ',I2,'.')
1090  FORMAT ('0*** ERROR - INVALID REAL NUMBER IN FIELD ',I2,'.')
1100  FORMAT ('0*** WARNING - PREDETERMINED STATION WEIGHTS DO NOT ',
     *   'SUM TO 1.0. ACTUAL SUM =',F5.2)
1110  FORMAT (' NUMFLD=',I3,3X,'MINFLD=',I3)
1120  FORMAT ('0*** ERROR - NOT ENOUGH INPUT FIELDS PROCESSED.')
1130  FORMAT ('0*** NOTE - MAT AREA ',2A4,' NOT DEFINED OR ',
     *   'REDEFINED BECAUSE ',I2,' ERRORS ENCOUNTERED.')
1140  FORMAT ('0*** ERROR - NULL FIELD NOT ALLOWED IN FIELD ',I3,'.')
1150  FORMAT ('0*** ERROR - THE LONGITUDE (',F10.2,') DOES NOT FALL ',
     *   'WITHIN THE USER DEFINED LIMITS OF ',F8.2,' AND ',F8.2,'.')
1160  FORMAT ('0*** ERROR - THE LATITUDE (',F10.2,') DOES NOT FALL ',
     *   'WITHIN THE USER DEFINED LIMITS OF ',F8.2,' AND ',F8.2,'.')
1170  FORMAT ('0*** ERROR - IN SFMAT - DIMENSION (',I5,') OF WORK ',
     *   'ARRAY HAS BEEN EXCEEDED.')
1180  FORMAT ('0*** ERROR - BASIN BOUNDARY ',2A4,' ALREADY USED BY ',
     *   'MAT AREA ',2A4,'.')
1190  FORMAT (' NFLD=',I2,3X,'NULL=',I2,3X,'IBSNID=',I2)
1200  FORMAT ('0*** ERROR - INVALID STATION WEIGHT TYPE : ',5A4)
1220  FORMAT ('0*** ERROR - INVALID MAT STATION ID : ',2A4)
1230  FORMAT ('0*** NOTE - USER SPECIFIED DEFAULT POWER (',F5.2,
     *   ') WILL BE USED FOR 1/D**POWER WEIGHTING.')
1240  FORMAT ('0*** WARNING - NUMBER OF CHARACTERS IN AREA ',
     *   'IDENTIFIER (',I2,') EXCEEDS ',I2,'. THE FIRST ',I2,
     *   ' CHARACTERS WILL BE USED.')
1250  FORMAT ('0*** ERROR - BLANK MAT IDENTIFIER IS NOT ALLOWED.')
1260  FORMAT ('0*** ERROR - THE MAT ID (',2A4,') CONTAINS A SET OF ',
     *   'RESERVED CHARACTERS.')
1270  FORMAT ('0*** ERROR - BASIN ',2A4,' IS NOT DEFINED.')
1290  FORMAT ('0*** ERROR - TM24 POINTER (',I3,') INVALID FOR ',
     *   'STATION ',2A4,'.')
1300  FORMAT ('0*** ERROR - STATION ',2A4,' ALREADY HAS BEEN ',
     *   'SPECIFIED.')
1310  FORMAT ('0*** ERROR - GRID POINT WEIGHTING CANNOT BE USED ',
     *   'BECAUSE NO BASIN WAS DEFINED FOR THIS AREA.')
1330  FORMAT ('0*** NOTE - ',I4,' MAT AREAS PROCESSED.')
1340  FORMAT ('0*** NOTE - ',I4,' MAT AREAS SUCCESSFULLY DEFINED.')
1350  FORMAT ('0*** NOTE - ',I4,' MAT AREAS SUCCESSFULLY REDEFINED.')
1360  FORMAT ('0*** NOTE - NO MAT AREAS SUCCESSFULLY DEFINED OR ',
     *   'REDEFINED.')
1370  FORMAT ('0*** NOTE - MAT  TIME SERIES SUCCESSFULLY ',A,' ',
     *   'FOR AREA ',2A4,'.')
1390  FORMAT ('0*** NOTE - BASN PARAMETERS SUCCESSFULLY UPDATED ',
     *   'FOR BASIN ',2A4,'.')
1400  FORMAT (' *** EXIT SFMAT - STATUS CODE=',I2)
C
      END
