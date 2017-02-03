C MEMBER ETSRD
C  (from old member EETSRD)
C
      SUBROUTINE ETSRD(TSESP,MTSESP,D,IWKLOC,MD,IDLOOP,LJDCON,IHZERO,
C                             LAST UPDATE: 06/07/95.09:13:07 BY $WC30EW 0000004/

     1 KNTYR,NYRS,IERR)
C
C   THIS SUBROUTINE CALLS THE APPROPRIATE SUBROUTINE TO FILL THE D ARRAY
C   FOR INPUT/UPDATE TIME SERIES.
C
C
      LOGICAL LBUG
C
      INCLUDE 'common/fdbug'
      INCLUDE 'common/ionum'
      INCLUDE 'common/where'
      INCLUDE 'common/fctime'
      INCLUDE 'clbcommon/crwctl'
      INCLUDE 'common/esprun'
      INCLUDE 'common/espseg'
      INCLUDE 'common/eblend'
      INCLUDE 'common/etime'
C
      COMMON/BHTIME/IBHREC,CMONTH,CDAY,CYEAR,CHRMN,CSCNDS
C
      INTEGER CMONTH,CDAY,CYEAR,CHRMN,CSCNDS
      DIMENSION D(1),TSESP(1),SBNAME(2),TSID(2),OLDOPN(2)
CEW ADDED EXTLOC
      DIMENSION EXTLOC(50)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/shared_esp/RCS/etsrd.f,v $
     . $',                                                             '
     .$Id: etsrd.f,v 1.2 1997/06/25 11:28:56 page Exp $
     . $' /
C    ===================================================================
C
C
      DATA CALB/4HCALB/,RMSNG/4HMSNG/,GENR/4HGENR/,ESP/4HESP /,
     1 REPL/4HREPL/, CARD/4HCARD/
      DATA SBNAME/4HETSR,4HD   /,DEBUG/4HEARY/,DEBUG2/4HETSR/
C
      IOLDOP=IOPNUM
      IOPNUM=0
      DO 10 I=1,2
      OLDOPN(I)=OPNAME(I)
   10 OPNAME(I)=SBNAME(I)
C
      IF(ITRACE.GE.1) WRITE(IODBUG,900)
  900 FORMAT(1H0,16H** ETSRD ENTERED)
C
      LBUG=.FALSE.
      IF(IFBUG(DEBUG2).EQ.0) GO TO 12
      LBUG=.TRUE.
   12 CONTINUE
C
      IBUG=IFBUG(DEBUG)
      IERR=0
      IERROR=0
C
C   SET MISSING DATA CONTROLS
C
      MSGCK=1
C
      IF(IEPASS.EQ.4) MSGCK=0
C
C
      LOC=0
C
C   SET UP BLEND TIME SERIES FLAGS
C
      IF(IEPASS.NE.3) GO TO 15
      IF(IDA.GT.IDLOOP) GO TO 14
      ICONTB=1
   14 IJDB=IJDLST+IDA-IDLOOP+(IHLST/24)
      IHB=IHZERO
      ICALLB=ICONTB
      ICONTB=0
C
C
C   SEARCH TS ARRAY FOR INPUT AND UPDATE TIME SERIES
C
   15 ITYPE=TSESP(LOC+1)
      IF(ITYPE.EQ.0) GO TO 999
      NXLOC=TSESP(LOC+2)
C
      IF(IBUG.NE.1) GO TO 18
      I1=LOC+1
      I2=NXLOC
      WRITE(IODBUG,905)
  905 FORMAT(1H0,10X,30HLOC, NXLOC, TSESP(LOC+1,NXLOC))
      WRITE(IODBUG,910) LOC,NXLOC
  910 FORMAT(1H0,10X,2I10)
      WRITE(IODBUG,915) (TSESP(I),I=I1,I2)
  915 FORMAT(1H0,10X,10F10.2)
C
   18 CONTINUE
      IF(ITYPE.GT.2) GO TO 400
C
C   FOUND AN INPUT/UPDATE TIME SERIES, DETERMINE GENERAL TS INFO
C
      DTYPE=TSESP(LOC+5)
      CALL FDCODE(DTYPE,UNITS,DIM,MSG,NVPDT,TSCALE,NPADD,IER)
      FILEID=TSESP(LOC+10)
      LD=TSESP(LOC+8)
      IDT=TSESP(LOC+6)
      TSID(1)=TSESP(LOC+3)
      TSID(2)=TSESP(LOC+4)
C
      IF(LBUG) WRITE(IODBUG,920) TSID,DTYPE,IDT,FILEID
  920 FORMAT(1H0,10X,16HREAD TIME SERIES,5X,2A4,5X,A4,5X,I5,5X,A4)
C
C
C   GO TO APPROPRIATE SECTION FOR FILE
C
   20 IF(FILEID.NE.RMSNG) GO TO 100
C
C   MISSING FILE
C
      IF(IEPASS.NE.0) GO TO 400
      LENGTH=(24/IDT)*NVPDT*31
      DO 50 I=1,LENGTH
      D(LD+I-1)=-999.
   50 CONTINUE
      GO TO 400
C
  100 IF(FILEID.NE.CALB) GO TO 120
C
C   CALIBRATION FILE
C
      IF(IEPASS.NE.0.AND.IEPASS.NE.4) GO TO 400
C
      CALL ECALBF(D,LD,TSESP,LOC,NVPDT,IDLOOP,LJDCON,KNTYR,NYRS,IER)
      IF(IER.EQ.0) GO TO 300
      IERR=1
      GO TO 999
C
CEW ADDED CARD FILETYPE HERE
  120 IF(FILEID.NE.CARD) GO TO 150
CEW
CEW  NWS CARD FILE TYPE
C
       IF(IEPASS.NE.0.AND.IEPASS.NE.4) GO TO 400
C
       CALL ECARDF(D,LD,TSESP,LOC,NVPDT,IDLOOP,LJDCON,KNTYR,NYRS,IER)
C
       IF (IER.EQ.0) GO TO 300
       IERR=1
       GO TO 999
C
C
  150 IF(FILEID.NE.GENR) GO TO 200
C
C   GENERATE FILE
C
      CALL EPP(D,LD,IWKLOC,MD,TSESP,LOC,IDLOOP,LJDCON,IHZERO,
     1 KNTYR,NYRS,NVPDT,IER)
      IF(IER.EQ.0) GO TO 300
      IERR=1
      GO TO 999
  200 IF(FILEID.NE.ESP) GO TO 250
C
C   PERMANENT/SCRATCH ESP FILE
C
      IF(IEPASS.EQ.0.OR.IEPASS.EQ.4) GO TO 400
      CALL ERDDFL(D,LD,TSESP,LOC,TSID,DTYPE,IDT,NVPDT,IDLOOP,
     1 IHZERO,KNTYR,NYRS,IER)
      IF(IER.EQ.0) GO TO 300
      IERR=1
      GO TO 999
C
  250 IF(FILEID.NE.REPL) GO TO 280
C
C   REPLACE FILE
C
      NEXT=TSESP(LOC+12)
      NADD=TSESP(LOC+NEXT+13)
      FILEID=TSESP(LOC+NEXT+NADD+15)
      IF(FILEID.NE.REPL) GO TO 260
      WRITE(IPR,610)
  610 FORMAT(1H0,10X,47H**ERROR** TIME SERIES HAS ALREADY BEEN REPLACED)
      IERR=1
      CALL ERROR
      GO TO 999
C
  260 IF(IEPASS.NE.0) GO TO 275
      LENGTH=(24/IDT)*NVPDT*31
      DO 270 I=1,LENGTH
      D(LD+I-1)=-999.0
  270 CONTINUE
  275 TSID(1)=TSESP(LOC+NEXT+NADD+16)
      TSID(2)=TSESP(LOC+NEXT+NADD+17)
      DTYPE=TSESP(LOC+NEXT+NADD+18)
      CALL FDCODE(DTYPE,UNITS,DIM,MSG,NVPDT,TSCALE,NPADD,IER)
      IDT=TSESP(LOC+NEXT+NADD+19)
      GO TO 20
C
  280 WRITE(IPR,620) FILEID
  620 FORMAT(1H0,10X,10H**ERROR** ,A4,2X,23HIS AN ILLEGAL FILE TYPE)
      IERR=1
      CALL ERROR
      GO TO 999
C
  300 IF(MSGCK.EQ.0) GO TO 400
      IF(MSG.EQ.1) GO TO 400
C
C   CHECK FOR MISSING VALUES
C
      J=LD-1
      IHR1=IHZERO+IDT
      IF(IHR1.GT.24) IHR1=24
      L1=J+((IDA-IDADAT)*24/IDT+(IHR1-1)/IDT)*NVPDT+1
      L2=J+((LDA-IDADAT)*24/IDT+(LHR/IDT))*NVPDT
      DO 320 I=L1,L2
      KI=I
      IF(IFMSNG(D(I)).EQ.1) GO TO 350
  320 CONTINUE
C
C   NO MISSING DATA FOUND
C
      GO TO 400
C
C   MISSING DATA FOUND
C
  350 CALL MDYH1(IDA,IHR1,MMO,IDUM1,MYEAR,IDUM2,100,0,TZC)
      WRITE(IPR,630)TSID,DTYPE,IDT,MMO,MYEAR
  630 FORMAT(1H0,10X,22H**ERROR** TIME SERIES ,2A4,2X,A4,I5,
     1 2X,26HCONTAINS MISSING DATA FOR ,I3,1H/,I4,8H AND TS:)

cew must select the right part of the tsesp array 
cew depending on the datatype

      if(fileid.eq.card) then
       write(ipr,601) (tsesp(loc+i), i = 41, 48)
      elseif(fileid.eq.genr) then
       write(ipr,601) (tsesp(loc+i), i = 54, 61)
      elseif(fileid.eq.esp) then
       write(ipr,602) (tsesp(loc+i), i = 13, 14)
      endif

601   format(10X,8a4)
602   format(10X,2a4)

      IERR=1
      CALL ERROR
      GO TO 999
C
  400 CONTINUE
      IF(NXLOC.GT.LTSESP) GO TO 999
      LOC=NXLOC-1
      GO TO 15
C
  999 CONTINUE
      IOPNUM=IOLDOP
      OPNAME(1)=OLDOPN(1)
      OPNAME(2)=OLDOPN(2)
      RETURN
      END

