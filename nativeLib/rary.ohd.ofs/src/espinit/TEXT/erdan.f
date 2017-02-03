C MEMBER ERDAN
C  (from old member EERDAN)
C
      SUBROUTINE ERDAN(PESP,MPESP,IER)
C
C   THIS SUBROUTINE READS THE ANALYSIS SECTION INPUT AND
C   WRITES PESP()
C
C   THIS SUBROUTINE WAS WRITTEN BY GERALD N DAY.
C
      INCLUDE 'common/espseg'
      INCLUDE 'common/where'
      INCLUDE 'common/ionum'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/elimit'
C
cmgm 1/9/02
c    CHANGED DIMENSION OF VARTYPE TO 10 TO BE CONSISTENT WITH BLOCK DATA
c
      DIMENSION SBNAME(2),OLDOPN(2),PESP(1),VARTYP(10),VNAME(2),
     1 HEAD(5),TSID(2),DISP(2),DISPTP(6),TSNAME(2),SMNAME(2,5),
     2 RONAME(2,7)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/espinit/RCS/erdan.f,v $
     . $',                                                             '
     .$Id: erdan.f,v 1.2 2002/02/11 20:19:17 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA SBNAME/4HERDA,4HN   /
cmgm  1/9/02
c     FILLED LAST TWO POSITIONS OF VARTYP WITH BLANKS.
c
      DATA VARTYP/4HMXMD,4HMNMD,4HMD  ,4HSUM ,4HMXIN,4HMNIN,
     1 4HNDTO,4HNDIS,4H    ,4H    /,END/4HEND /
      DATA BLANK/4H    /,DISPTP/4HSUMM,4HARY ,
     1 4HFREQ,4HUENC,4HFREQ,4HPLOT/
      DATA DEBUG/4HEARY/
      DATA SMNAME/4HUZTD,4HEF  ,4HUZFW,4HC   ,4HLZTD,4HEF  ,
     1 4HLZFS,4HC   ,4HLZFP,4HC   /
      DATA RONAME/4HTCHA,4HNINF,4HIMP-,4HRO  ,4HDIR-,4HRO  ,
     1 4HSUR-,4HRO  ,4HINTE,4HRFLO,4HSUPB,4HASE ,4HPRIM,4HBASE/
      DATA SMZC,ROCL/4HSMZC,4HROCL/
C
      IOLDOP=IOPNUM
      IOPNUM=0
      DO 10 I=1,2
      OLDOPN(I)=OPNAME(I)
   10 OPNAME(I)=SBNAME(I)
C
      IF(ITRACE.GE.1) WRITE(IODBUG,900)
  900 FORMAT(1H0,17H ** ERDAN ENTERED)
C
      LPESP=0
      LP=0
      IER=0
   50 READ(IN,500)VTYPE,VNAME,NTS,NDS,HEAD,KODE,VALUE
  500 FORMAT(A4,6X,2A4,2X,I5,I5,5A4,I5,F10.0)
C
C   FIND VARIABLE NUMBER
C
      DO 100 I=1,MAXVAR
      IF(VTYPE.NE.VARTYP(I)) GO TO 100
      NVAR=I
      GO TO 120
  100 CONTINUE
      IF(VTYPE.EQ.END) GO TO 999
      WRITE(IPR,600) VTYPE
  600 FORMAT(1H0,10X,10H**ERROR** ,A4,2X,
     1 28HIS NOT A VALID VARIABLE TYPE)
      IER=1
      CALL ERROR
      GO TO 999
C
C   START FILLING PESP ARRAY
C
  120 LPESP=LP+30
      IF(LPESP.LE.MPESP) GO TO 140
      WRITE(IPR,610) MPESP
  610 FORMAT(1H0,10X,44H**ERROR** THE MAXIMUM SIZE OF THE PESP ARRAY,
     1 28H HAS BEEN EXCEEDED, MPESP = ,I5)
C
  140 PESP(LP+1)=NVAR+.01
      PESP(LP+3)=VNAME(1)
      PESP(LP+4)=VNAME(2)
      PESP(LP+5)=KODE+.01
      PESP(LP+6)=VALUE
      DO 150 I=1,5
      PESP(LP+I+7)=HEAD(I)
  150 CONTINUE
C
C   READ TIME SERIES INFO
C
      DO 180 I=1,NTS
      READ(IN,510) TSID,DTYPE,IDT,OSIND,TSNAME
  510 FORMAT(2A4,3X,A4,3X,I2,1X,A4,2X,2A4)
C
      ITSNUM=1
      IF(TSNAME(1).EQ.BLANK.AND.TSNAME(2).EQ.BLANK) GO TO 170
      IF(DTYPE.NE.SMZC) GO TO 160
      DO 155 J=1,5
      ITSNUM=J
      IF(TSNAME(1).EQ.SMNAME(1,J).AND.TSNAME(2).EQ.SMNAME(2,J))
     1 GO TO 170
  155 CONTINUE
      GO TO 165
  160 IF(DTYPE.NE.ROCL) GO TO 165
      DO 162 J=1,7
      ITSNUM=J
      IF(TSNAME(1).EQ.RONAME(1,J).AND.TSNAME(2).EQ.RONAME(2,J))
     1 GO TO 170
  162 CONTINUE
C
  165 WRITE(IPR,612) TSID,DTYPE,IDT,TSNAME
  612 FORMAT(1H0,10X,22H**ERROR** TIME SERIES ,2A4,1X,A4,I5,2X,
     1 1H-,2X,2A4,21H IS NOT A VALID NAME.)
      IER=1
      CALL ERROR
      GO TO 999
C
C
C   FIND LOCATION IN D ARRAY
C
  170 CALL EFINTS(TSID,DTYPE,IDT,LD,LTS)
      IF(LD.GT.0) GO TO 175
      WRITE(IPR,615) TSID,DTYPE,IDT
  615 FORMAT(1H0,10X,22H**ERROR** TIME SERIES ,2A4,1X,A4,I5,2X,
     1 14HWAS NOT FOUND.)
      IER=1
      CALL ERROR
      GO TO 999
C
C   WRITE TS INFO TO PESP ARRAY
C
175   LP1=LP+(9*I)+3
      PESP(LP1+1)=TSID(1)
      PESP(LP1+2)=TSID(2)
      PESP(LP1+3)=DTYPE
      PESP(LP1+4)=IDT+.01
      PESP(LP1+5)=OSIND
      PESP(LP1+6)=LD+ITSNUM/100.
      PESP(LP1+7)=0.01
      PESP(LP1+8)=0.01
      PESP(LP1+9)=0.01
  180 CONTINUE
C
      IF(NTS.EQ.2) GO TO 190
C
C   BLANKOUT TS 2 INFO
C
      PESP(LP+22)=BLANK
      PESP(LP+23)=BLANK
      PESP(LP+24)=BLANK
      PESP(LP+25)=.01
      PESP(LP+26)=BLANK
      PESP(LP+27)=.01
      PESP(LP+28)=.01
      PESP(LP+29)=.01
      PESP(LP+30)=.01
C
C GET UNITS AND WHETHER KODE(PESP(LP+5)) SHOULD BE NEGATIVE FOR
C THIS OUTPUT VARIABLE AND DATA TYPES. DO THIS BY CALLING EDSUNT.
C CHECK ERROR CODE IER LATER IN.
C
190   CALL EDSUNT(PESP,LP,UNITS,VARTYP,IER)
      IF(IER.GT.0) GO TO 999
      PESP(LP+31)=UNITS
      PESP(LP+32)=.01
      PESP(LP+33)=.01
      PESP(LP+34)=.01
      PESP(LP+35)=.01
C
      LPESP=LP+35
C
      DO 300 I=1,NDS
      READ(IN,520) DISP
  520 FORMAT(2A4)
      DO 200 J=1,MAXDSP
      II=2*J-1
      IF(DISP(1).NE.DISPTP(II).OR.DISP(2).NE.DISPTP(II+1)) GO TO 200
      NDSP=J
      GO TO 205
  200 CONTINUE
      WRITE(IPR,620) DISP
  620 FORMAT(1H0,10X,10H**ERROR** ,2A4,2X,
     1 27HIS NOT A VALID DISPLAY TYPE)
      IER=1
      CALL ERROR
      GO TO 999
C
C   CALL PROPER DISPLAY INPUT SUBROUTINE
C
  205 LEFT=MPESP-LPESP
      GO TO (210,220,230),NDSP
C
  210 CALL EDIN01(PESP(LPESP+1),LEFT,NVAR,IERR)
      IF(IERR.NE.0) GO TO 300
      IUSE=PESP(LPESP+2)
      LPESP=LPESP+IUSE
      GO TO 300
  220 CALL EDIN02(PESP(LPESP+1),LEFT,NVAR,IERR)
      IF(IERR.NE.0) GO TO 300
      IUSE=PESP(LPESP+2)
      LPESP=LPESP+IUSE
      GO TO 300
  230 CONTINUE
C 230 CALL EDIN03(PESP(LPESP+1),LEFT,IERR)
C     IF(IERR.NE.0) GO TO 300
C     IUSE=PESP(LPESP+2)
C     LPESP=LPESP+IUSE
C
  300 CONTINUE
C
      PESP(LP+2)=LPESP+1.01
      LP=LPESP
      GO TO 50
C
  999 NEXT=LPESP+1
      IF(NEXT.GT.MPESP) GO TO 1000
      PESP(NEXT)=0.01
      LPESP=NEXT
 1000 IF(IER.NE.0) LPESP=0
      IBUG=IFBUG(DEBUG)
      IF(IBUG.EQ.0) GO TO 1010
      WRITE(IODBUG,910) LPESP
  910 FORMAT(1H0,10X,8HLPESP = ,I5)
      WRITE(IODBUG,920)
  920 FORMAT(1H0,10X,10HPESP ARRAY)
      WRITE(IODBUG,930) (PESP(I),I=1,MPESP)
  930 FORMAT(11X,10F10.0)
 1010 CONTINUE
      IOPNUM=IOLDOP
      OPNAME(1)=OLDOPN(1)
      OPNAME(2)=OLDOPN(2)
      RETURN
      END