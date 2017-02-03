C MEMBER XU1726
C  (from old member FCXU1726)
C
C @PROCESS LVL(77)
      SUBROUTINE XU1726(PO,CO,W,D,LOCWS,LOCOWS,IDPT)
C---------------------------------------------------------------------
C                             LAST UPDATE: 01/12/95.08:24:55 BY $WC30KH
C
C  SUBROUTINE TO CREATE ADJUSTED POOL ELEVATIONS (AND STORAGES) AND
C  DISCHARGES. INPUT FOR THE PROCEDURE CAN BE EITHER AN OBSERVED
C  ELEVATION TS OR OBSERVED DISCHARGE TS OR BOTH. DIFFERENT STRATEGIES
C  ARE USED FOR THE DIFFERENT COMBINATIONS OF TIME SERIES AND THEIR
C  TIME INTERVALS. THESE STRATEGIES ARE DESCRIBED IN THE BODY OF THE
C  ROUTINE.
C---------------------------------------------------------------------
C  WRITTEN BY JOE OSTROWSKI - HRL - OCTOBER 1983
C  UPDATED BY KUANG HSU - HRL - FEBRUARY 1989
C---------------------------------------------------------------------
C
C  NRUN -- NO. OF PERIODS WITH OBSERVED DATA
C  NLOBS -- NO. OF PERIOD WITH NON-MISSING OBSERVED DATA WITHIN NRUN
C
      INCLUDE 'common/resv26'
      INCLUDE 'common/exg26'
      INCLUDE 'common/xre26'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/fctime'
      INCLUDE 'common/fprog'
      INCLUDE 'common/ionum'
      COMMON/ADJ26/NTS17
C
      DIMENSION PO(*),CO(*),D(*),W(*),LOCOWS(*),LOCWS(*),IDPT(*),
     .          QMD(31),LOCTSI(7),QWORK(31),IERD(31)
      DIMENSION IERPDI(200),IERPDM(200)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_res/RCS/xu1726.f,v $
     . $',                                                             '
     .$Id: xu1726.f,v 1.7 2006/10/16 12:42:49 hsu Exp $
     . $' /
C    ===================================================================
C
C
      DATA BLANK/4H    /
C
C  DEFINE FUNCTION FOR COMPUTING JULIAN HOUR
C
      JULI(I) = I*MINODT + (IDA-1)*24
C
      IF (IBUG.GE.1) WRITE(IODBUG,6600)
 6600 FORMAT('   *** ENTER XU1726 ***')
C
C  SET NRUN TO NUM TEMPORARILY TO ALLOW FOR TREATING PROPOSED DATA
C  IN THE FUTURE AS OBSERVED FOR ADJUSTMENT PURPOSE
      NRUNS = NRUN
      NRUN = NUM
C
C  SET VALUES FOR IGNORETS MOD USE CHECK
C
      IITYPE = 1
      IMTYPE = 2
      IETYPE = 4
      ISUTYP = 2
C
C---------------------------------------------------------------------
C  GET POINTER INFO FOR THIS UTILITY
C
      SUNUM = 1541.01
      CALL XPTR26(SUNUM,PO,IORD,IBASE,LEVEL,LOCPM,LOCTS,LOCCO)
C
C  FIRST THING IS TO DETERMINE THE COMBINATION OF OBSERVED TIME-SERIES
C  THAT WE HAVE. THE POSSIBILITIES ARE:
C
C     1) OBSERVED INSTANTANEOUS DISCHARGES ONLY
C     2) OBSERVED MEAN DISCHARGES ONLY
C     3) BOTH OBSERVED INSTANTANEOUS DISCHARGES AND MEAN DISCHARGES
C     4) OBSERVED ELEVATIONS ONLY
C     5) BOTH OBSERVED INSTANTANEOUS DISCHARGES AND ELEVATIONS
C     6) BOTH OBSERVED ELEVATIONS AND MEAN DISCHARGES
C     7) ALL THREE TYPES OF OBSERVED TIME-SERIES
C
C  THE COMBINATION IS DETERMINED BY THE EXISTENCE OF ANY POINTERS FOR
C  THE OBSERVED TIME-SERIES IN THE D (TIME SERIES DATA) ARRAY POINTER
C  ARRAY (IDPT).
C
C  THE OBSERVED INSTANTANEOUS DISCHARGE IS THE FIRST POINTER, THE
C  OBSERVED MEAN DISCHARGE IS THE SECOND POINTER, AND THE OBSERVED
C  ELEVATION IS THE THIRD POINTER.
C
      LFIRST = IORD*3 - 1
      LOCPT1 = W(LFIRST)
C
      ICOMB = 0
      IDTQO = MINODT
      LOBSQO = 0
      LOBSQM = 0
      LOBSEL = 0
C  THE FOLLOWING CHANGES MADE ON 2/13/90
C      NLOBS=NRUN
      NLOBS=0
C  END OF CHANGE OF 2/13/90
      IF (IDPT(LOCPT1) .NE. 0) ICOMB = ICOMB + 1
      IF (IDPT(LOCPT1+1) .NE. 0) ICOMB = ICOMB + 2
      IF (IDPT(LOCPT1+2) .NE. 0) ICOMB = ICOMB + 4
C
C  NOW COMPUTE LOCATION OF ID INFO IN PO ARRAY FOR EACH TIME-SERIES
C  AND ALSO SET THE 'WRITE ADJUST' FLAGS FOR USE BY THE CONTROLLER
C  ROUTINE.
C
      LOCBTS = LOCTS
      DO 90 I=1,7
   90 LOCTSI(I) = 0
      DO 100 I=1,NTS17
C
C  TIME-SERIES NOT USED IF ALL BLANKS ARE THERE FOR ID. ALSO, ONLY TWO
C  WORDS OF PO ARRAY USED. FIVE WORDS USED IF TIME-SERIES IS USED.
C
      IADD = 2
      IF (PO(LOCBTS).EQ.BLANK .AND. PO(LOCBTS+1).EQ.BLANK) GO TO 50
C
      IADD = 5
      LOCTSI(I) = LOCBTS
C
   50 CONTINUE
      LOCBTS = LOCBTS + IADD
  100 CONTINUE
      IF (IBUG.GE.2) WRITE(IODBUG,1613) LOCTSI
 1613 FORMAT(' LOCTSI ARRAY = ',7I5)
C
C  SET NEED FOR, LOCATION OF, AND TIME INTERVAL OF ADJUSTED OUTPUT FOR
C  USE LATER IN TRANSFERRING MODEL RESULTS TO TIME-SERIES.
C
      WRAJQI = .FALSE.
      WRAJQM = .FALSE.
      WRAJEL = .FALSE.
      WRAJST = .FALSE.
C
      IF (LOCTSI(4).NE.0) WRAJQI = .TRUE.
      IF (LOCTSI(5).NE.0) WRAJQM = .TRUE.
      IF (LOCTSI(6).NE.0) WRAJEL = .TRUE.
      IF (LOCTSI(7).NE.0) WRAJST = .TRUE.
C
      IF (WRAJQI) IDTAJI = PO(LOCTSI(4)+3)
      IF (WRAJQM) IDTAJM = PO(LOCTSI(5)+3)
      IF (WRAJEL) IDTAJE = PO(LOCTSI(6)+3)
      IF (WRAJST) IDTAJS = PO(LOCTSI(7)+3)
C
      IF (WRAJQI) LADJQI = IDPT(LOCPT1+3) + IDOFST * 24/IDTAJI
      IF (WRAJQM) LADJQM = IDPT(LOCPT1+4) + IDOFST * 24/IDTAJM
      IF (WRAJEL) LADJEL = IDPT(LOCPT1+5) + IDOFST * 24/IDTAJE
      IF (WRAJST) LADJST = IDPT(LOCPT1+6) + IDOFST * 24/IDTAJE
      IF (IBUG.GE.2) WRITE(IODBUG,1615) WRAJQI,IDTAJI,LADJQI,WRAJQM,
     .               IDTAJM,LADJQM,WRAJEL,IDTAJE,LADJEL,
     .               WRAJST,IDTAJS,LADJST
 1615 FORMAT('   WRAJQI, IDTAJI, LADJQI',/6X,L1,7X,I2,5X,I5,/
     .       '   WRAJQM, IDTAJM, LADJQM',/6X,L1,7X,I2,5X,I5,/
     .       '   WRAJEL, IDTAJE, LADJEL',/6X,L1,7X,I2,5X,I5,/
     .       '   WRAJST, IDTAJS, LADJST',/6X,L1,7X,I2,5X,I5)
C
C  NOTHING NEEDS TO BE DONE IF WE HAVE NO OBSERVED PERIODS TO PICK DATA
C  FROM.
C
      IF (NRUN .EQ. 0) GO TO 9009
C
C * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
C
C  FIRST WE MUST PULL INFLOW FROM PROPER SOURCE DEPENDING ON WHETHER
C  WE USED 'RAINEVAP' OR 'BACKFLOW' OR BOTH.
C
      LOCWK = LOCOWS(4)
      IF (DOBACK) GO TO 250
C
C  PULL MEAN INFLOW FROM TIME-SERIES. MUST BE CONVERTED FROM CMSD TO
C  TIMD.
C
      LOCQIM = IDPT(2) + IDOFST*NTIM24
      DO 230 I=1,NRUN
      W(LOCWK+I-1) = D(LOCQIM+I-1) * NTIM24
 230  CONTINUE
      GO TO 300
C
C  'BACKFLOW' WAS EXECUTED. PULL MEAN INFLOW FROM WORK SPACE.
C
 250  CONTINUE
C
      IF (DORAIN) GO TO 280
C
      LOCAQM = LOCOWS(1) + NDD*NTIM24
      DO 270 I=1,NRUN
      W(LOCWK+I-1) = W(LOCAQM+I-1)
 270  CONTINUE
      GO TO 400
C
C  RAINEVAP WAS USED IN CONJUNCTION WITH BACKFLOW. WE NEED TO PULL BASE
C  FLOW FROM ANOTHER WORK SPACE LOCATION.
C
 280  CONTINUE
      LOCBQ = LOCOWS(1)
      DO 290 I=1,NRUN
      W(LOCWK+I-1) = W(LOCBQ+I-1)
 290  CONTINUE
C
C  NOW ADD ADD'L FLOW TO BASE OR TIME-SERIES IF 'RAINEVAP' WAS USED.
C
 300  CONTINUE
      IF (.NOT.DORAIN) GO TO 400
C
      DO 350 I=1,NRUN
      W(LOCWK+I-1) = W(LOCWK+I-1) + W(LPTADL+I-1)
 350  CONTINUE
C
  400 CONTINUE
C
C  SET LOCATIONS OF OUTPUT VARIABLE TRACES IN THE WORK ARRAY.
C
      LOCQO = LOCWS(2)
      LOCQOM = LOCQO + NDD*NTIM24
      LOCEL = LOCQOM + NDD*NTIM24
      LOCSTO = LOCEL + NDD*NTIM24
C
      LAINST = 0
C
C  NOW SEND CONTROL TO PROPER ROUTINE LOCATION FOR THE FOUND COMBINATION
C  OF OBSERVED TIME-SERIES.
C
C  THE STRATEGY USED WHENEVER INSTANTANEOUS DISCHARGES ARE USED
C  FOR ADJUSTMENT IS TO USE THOSE OBSERVED VALUES TO ADJUST THE
C  SIMULATED INSTANTANEOUS DISCHARGES. THIS UPDATE IS DONE IN PLACE.
C  AFTER THIS ADJUSTMENT IS MADE, THE COMBINATION OF OBSERVED TIME-
C  SERIES IS CHECKED TO SEE IF ADDITIONAL ADJUSTMENTS ARE TO BE MADE.
C  THE STRATEGY USED FOR THESE SUBSEQUENT ADJUSTMENTS REMAINS THE SAME
C  BUT THE INSTANTANEOUS VALUES WILL BE THE ADJUSTED ONES INSTEAD OF THE
C  SIMULATED ONES.
C
      GO TO (1000,2000,1000,4000,1000,6000,1000) , ICOMB
C
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  HERE WE HAVE INSTANTANEOUS OBSERVED DISCHARGES. THIS CAN OCCUR
C  WITH OR WITHOUT ANY ADDITIONAL OBSERVED TIME-SERIES. REGARDLESS
C  OF THE COMBINATION, THE STRATEGY FOR ADJUSTMENT REMAINS THE SAME -
C  ADJUST THE SIMULATED INSTANTANEOUS USING THE OBSERVED INSTANTANEOUS.
C
 1000 CONTINUE
C
C  GET TIME INTERVAL OF INST. DISCHARGE TIME SERIES
C
      IDTQO = PO(LOCTSI(1) + 3)
C
C  ADJUST THE SIMULATED INSTANTANEOUS USING THE OBSERVED INSTANTANEOUS.
C
 1010 CONTINUE
cccc      CALL X17I26(PO,W,LOCWS,D,IDPT,IDTQO,LOCPM,LOCCO,LOCPT1,LAINST)
      NLOBS = LAINST
      IF (NLOBS .GE. 0) 
     .  CALL X17I26(PO,W,LOCWS,D,IDPT,IDTQO,LOCPM,LOCCO,LOCPT1,LAINST)
      LOBSQO = IDPT(LOCPT1) + IDOFST*24/IDTQO
C
C  TRUNCATE RUN TO LAST FULL DAY OF OBSERVED DATA.
C
C      NDAY = LAINST/NTIM24
C      LAINST = NDAY * NTIM24
C
C  HERE WE SEE WHAT COMBINATION OF OBSERVED TIME-SERIES HAVE
C  BEEN USED TO DECIDE WHAT FURTHER ACTION MUST BE TAKEN
C
C  INSTANTANEOUS DATA IS ONLY USED FOR COMBINATIONS 1, 3, 5, AND
C  7, SO TRANSFORM THESE TO 1 THRU 4
C
C  THE FOLLOWING CHANGE MADE ON 5/10/90 #601
      IGOTO = (ICOMB/2) + 1
      GO TO (1100,2000,4000,6000) , IGOTO
C  END OF CHANGE OF 5/10/90 #601
C
C  HERE WE ONLY HAVE INSTANTANEOUS OBSERVED DISCHARGE DATA. WE MUST
C  COMPUTE THE MEAN DISCHARGES, THE POOL ELEVATIONS, AND THE STORAGES
C  BASED ON THE INSTANTANEOUS DATA (BUT ONLY IF ANY DATA HAS BEEN FOUND)
C
 1100 CONTINUE
C
C  SEE IF WE FOUND ANY DATA
C
C  THE FOLLOWING CHANGE MADE ON 9/5/89
C      NRUN = LAINST
C      IF (NRUN .EQ. 0) GO TO 9101
      NLOBS = LAINST
C  THE FOLLOWING CHANGE MADE ON 5/31/90 #604
      IF (NLOBS .EQ. 0) GO TO 9101
CC      IF (NLOBS .EQ. 0) GO TO 1101
      LOBSQO = IDPT(LOCPT1) + IDOFST*24/IDTQO
C  END OF CHANGE OF 5/31/90
C  END OF CHANGE OF 9/5/89
C
C  COMPUTE MEANS FROM INSTANTANEOUS
C
      CALL X17M26(W,LOCQOM,LOCQO,CO(3),1,NLOBS)
C
C  COMPUTE ELEVATIONS AND STORAGES
C
C  THE FOLLOWING CHANGE MADE ON 5/23/91 -- MAINT. #656
C      CALL X17E26(W,PO,LOCSTO,LOCEL,LOCQOM,LOCWK,CO(6),1,NLOBS)
      PRESTO=CO(6)
      CALL X17E26(W,PO,LOCSTO,LOCEL,LOCQOM,LOCWK,PRESTO,1,NLOBS)
C  END OF CHANGE OF 5/23/91
C
C  WE'RE DONE WITH ADJUSTMENTS USING ONLY INSTANTANEOUS DATA.
C
C  THE FOLLOWING CHANGE MADE ON 5/10/90 #601
C  THE FOLLOWING CHANGE MADE ON 5/31/90 #604
C      IGOTO = (ICOMB/2) + 1
CC 1101 IGOTO = (ICOMB/2) + 1
C  END OF CHANGE OF 5/31/90 #601
CC      GO TO (9000,2000,4000,6000) , IGOTO
      GO TO 9000
C  END OF CHANGE OF 5/10/90 #601
C
C-----------------------------------------------------------------------
C  IN THIS SITUATION, WE HAVE OBSERVED MEAN DISCHARGES, ALONE OR IN
C  COMBINATION WITH INSTANTANEOUS OBSERVED DISCHARGES. FIRST CHECK
C  THE TIME INTERVAL. IF IT IS NOT EQUAL TO THE OPERATION TIME INTERVAL,
C  THEN SUM VALUES TO GET THE DAILY VOLUMES AND COMPUTE THE INSTANTAN-
C  EOUS DISCHARGES, COMPUTE THE MEANS FROM THE INSTANTANEOUS, AND
C  COMPUTE THE STORAGE/ELEVATION FROM THE PERIOD MEANS AND THE MEAN
C  INFLOWS.
C
C  IF THE TS TIME INTERVAL EQUALS THE OPERATION TIME INTERVAL, THEN WE
C  MARCH FORWARD FROM CARRYOVER TO COMPUTE THE STORAGE/ELEVATION VALUES
C  UNTIL WE ENCOUNTER A MISSING DISCHARGE. THEN WE SUM UP THE DISCHARGES
C  AND CALL XADJ26 TO GET ADJUSTED INSTANTANEOUS. WE THEN COMPUTE THE
C  MEANS WHEREVER MISSING TIME SERIES VALUES ARE FOUND. THEN FROM THE
C  POINT OF THE LAST COMPUTED STORAGE/ELEVATION, WE COMPUTE THE S/E
C  VALUES FOR THE REST OF THE RUN PERIOD.
C
 2000 CONTINUE
C
C  GET THE TIME SERIES TIME INTERVAL
C
      IDTQ = PO(LOCTSI(2)+3)
      LOBSQM = IDPT(LOCPT1+1) + IDOFST*24/IDTQ
      IF (IDTQ .EQ. MINODT) GO TO 2500
C
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  HERE WE HAVE DISCHARGES AT A GREATER TIME INTERVAL THAN THE OPERATION
C  TIME INTERVAL.
C
      NTIMOB = 24/IDTQ
      NDAY = NRUN/NTIM24
      NOBS = NDAY*NTIMOB
      IF (IBUG.GE.2) WRITE(IODBUG,1620)
 1620 FORMAT(/10X,'** OBSERVED MEAN DISCHARGES **')
      IF (IBUG.GE.2) WRITE(IODBUG,1650) (D(LOBSQM+I-1),I=1,NOBS)
C
C
C  SUM ALL THE PERIOD MEANS TO GET THE DAILY MEANS
C
      CALL X17S26(D,LOBSQM,QMD,1,1,NOBS,NTIMOB,IQMD,IMTYPE)
C
C  MUST TRUNCATE THE RUN PERIOD TO THE LAST FULL DAY
C
C  THE FOLLOWING CHANGE MADE ON 9/5/89
C      NRUN = IQMD * NTIM24
C      NRUN = MAX0(NRUN,LAINST)
C      IF (NRUN .EQ. 0) GO TO 9101
C  THE FOLLOWING CHANGE MADE ON 2/13/90
C      NLOBS = IQMD * NTIM24
C      NLOBS = MAX0(NLOBS,LAINST)
      LAQOM = IQMD * NTIM24
      NLOBS = MAX0(LAQOM,LAINST)
      NDAY=NLOBS/NTIM24
      NLOBS=NDAY*NTIM24
C  END OF CHANGE OF 2/13/90
      IF (NLOBS .EQ. 0) GO TO 9101
C  END OF CHANGE OF 9/5/89
C
C  NOW COMPUTE THE INSTANTANEOUS BASED ON THE 'OBSERVED' DAILY VOLUMES.
C
      TOLRNS = 0.025
      CALL XADJ26(W(LOCQO),QWORK,QMD,1,IQMD,1,NLOBS,TOLRNS,CO(3),IORDN,
     .            MINODT,MINODT,24,D,LOBSQO,IDTQO,IERD)
C
C  COMPUTE THE 'ADJUSTED' PERIOD MEANS NOW.
C
      CALL X17M26(W,LOCQOM,LOCQO,CO(3),1,NLOBS)
C
C  NOW COMPUTE STORAGES AND ELEVATIONS FROM PERIOD MEAN DISCHARGES AND
C  MEAN INFLOWS
C
C  THE FOLLOWING CHANGE MADE ON 5/23/91 -- MAINT. #656
C      CALL X17E26(W,PO,LOCSTO,LOCEL,LOCQOM,LOCWK,CO(6),1,NLOBS)
      PRESTO=CO(6)
      CALL X17E26(W,PO,LOCSTO,LOCEL,LOCQOM,LOCWK,PRESTO,1,NLOBS)
C  END OF CHANGE OF 5/23/91
C
C  WE'RE DONE FOR THIS COMBINATION WITH TIME-SERIES TIME INTERVALS NOT
C  EQUAL TO THE OPERATION TIME INTERVAL
C
      GO TO 9000
C
C----------------------------------------------------------------------
C  HERE WE HAVE THE TIME-SERIES INTERVAL EQUAL TO THE OPERATION TIME
C  INTERVAL. WE MARCH FORWARD FROM THE CARRYOVER, COMPUTING THE
C  STORAGE/ELEVATION VALUES UNTIL WE FIND A MISSING DISCHARGE.
C
 2500 CONTINUE
      IF (IBUG.GE.2) WRITE(IODBUG,1620)
      IF (IBUG.GE.2) WRITE(IODBUG,1650) (D(LOBSQM+I-1),I=1,NRUN)
      LAOBS = 0
      PRESTO = CO(6)
C
      DO 2600 I=1,NRUN
      OBAR = D(LOBSQM+I-1)
      JULX = JULI(I)
      IF (IFMSNG(OBAR).EQ.1 .OR. IFGNOR(IMTYPE,JULX,ISUTYP).EQ.1)
     .  GO TO 2650
C
C  CONVERT TO UNITS OF MEAN INTERVAL DISCHARGES (STANDARD UNITS OF
C  INCOMING MEAN DISCHARGES IS CMSD.)
C
      W(LOCQOM+I-1) = OBAR*NTIM24
      LAOBS = I
      DELS = W(LOCWK+I-1) - OBAR
      W(LOCSTO+I-1) = PRESTO + OBAR
      PRESTO = W(LOCSTO+I-1)
      CALL NTER26(PRESTO,W(LOCEL+I-1),PO(LESSTO),PO(LESELV),NSE,IFLAG,
     .            NTERP,IBUG)
 2600 CONTINUE
C
C  NOW SUM UP THE PERIOD MEANS TO GET DAILY MEANS FOR USE IN XADJ26 FOR
C  COMPUTING INSTANTANEOUS ADJUSTED DISCHARGE.
C
 2650 CONTINUE
C
      CALL X17S26(D,LOBSQM,QMD,1,1,NRUN,NTIM24,IQMD,IMTYPE)
C
C  TRUNCATE THE RUN TO THE LAST FULL DAY.
C
C  THE FOLLOWING CHANGE MADE ON 9/5/89
C      NRUN = IQMD * NTIM24
C      NRUN = MAX0(NRUN,LAINST)
C      IF (NRUN .EQ. 0) GO TO 9101
C      NLOBS = IQMD * NTIM24
C      NLOBS = MAX0(NLOBS,LAINST)
      LAQOM = IQMD * NTIM24
      NLOBS = MAX0(LAQOM,LAINST)
      NDAY=NLOBS/NTIM24
      NLOBS=NDAY*NTIM24
C  END OF CHANGE OF 2/13/90
      IF (NLOBS .EQ. 0) GO TO 9101
C  END OF CHANGE OF 9/5/89
C
C  COMPUTE THE INSTANTANEOUS ADJUSTED DISCHARGES
C
      TOLRNS = 0.025
      CALL XADJ26(W(LOCQO),QWORK,QMD,1,IQMD,1,NLOBS,TOLRNS,CO(3),IORDN,
     .            MINODT,MINODT,24,D,LOBSQO,IDTQO,IERD)
C
C  NOW COMPUTE THE MEANS WHEREVER ANY ARE MISSING
C
C      IF (LAOBS.GE.NRUN) GO TO 2950
      IF (LAOBS.GE.NLOBS) GO TO 2950
C
      W(LOCQOM) = D(LOBSQM) * NTIM24
      JULX = JULI(1)
      IF (IFMSNG(D(LOBSQM)).EQ.1 .OR. IFGNOR(IMTYPE,JULX,ISUTYP).EQ.1)
     .    W(LOCQOM) = (CO(3) + W(LOCQO))/2.0
C
C      DO 2800 I=2,NRUN
      DO 2800 I=2,NLOBS
      JULX = JULI(I)
      W(LOCQOM+I-1) = D(LOBSQM+I-1) * NTIM24
      IF (IFMSNG(D(LOBSQM+I-1)).EQ.1.OR.IFGNOR(IMTYPE,JULX,ISUTYP).EQ.1)
     . W(LOCQOM+I-1) = (W(LOCQO+I-2) + W(LOCQO+I-1))/2.0
 2800 CONTINUE
C
C  NOW START FROM LAST OBSERVED VALUE AND FILL IN STORAGES/ELEVATIONS
C  UP TO END OF RUN PERIOD
C
      IST = LAOBS + 1
      PRESTO = W(LOCSTO+LAOBS-1)
      IF (LAOBS .EQ. 0) PRESTO = CO(6)
C
C      CALL X17E26(W,PO,LOCSTO,LOCEL,LOCQOM,LOCWK,PRESTO,IST,NRUN)
      CALL X17E26(W,PO,LOCSTO,LOCEL,LOCQOM,LOCWK,PRESTO,IST,NLOBS)
 2950 CONTINUE
C
C  WE'RE DONE WITH THIS COMBINATION WITH TIME SERIES AT SAME TIME
C  INTERVAL AS OPERATION TIME INTERVAL
C
      GO TO 9000
C
C---------------------------------------------------------------------
C  THE OBSERVED ELEVATION TIME-SERIES IS USED FOR ADJUSTMENT.
C  THIS TIME-SERIES CAN BE USED ALONE OR IN CONJUNCTION WITH AN OBSERVED
C  INSTANTANEOUS DISCHARGE TIME-SERIES OR ALONE. IF USED WITH THE INST.
C  TIME-SERIES, THE INST. ADJUSTMENT HAS BEEN DONE PRIOR TO REACHING
C  THIS SECTION. THE ADJUSTMENT STRATEGY USED HERE STAYS THE SAME.
C
 4000 CONTINUE
C
C  FIRST GET THE TIME INTERVAL OF THE OBSERVED ELEVATION TIME-SERIES
C
      IDTEL = PO(LOCTSI(3)+3)
      NTIMOB = 24/IDTEL
      NINT = NTIM24/NTIMOB
C
C  SET COUNTERS AND FLAGS TO INITIAL VALUES.
C
      NMISS = 0
C  THE FOLLOWING CHANGES MADE ON 2/13/90
C      LAOBS = 0
      LAEL = 0
C  END OF CHANGE OF 2/13/90
      STSSTO = CO(6)
      STOSTO = STSSTO
C
C  NOW GO THROUGH OBSERVED PERIOD LOOKING FOR AND FILLING ANY MISSING
C  GAPS OF ELEVATION. THE MISSING VALUES ARE FILLED BY DISTRIBUTING THE
C  DIFFERENCE BETWEEN THE SIMULATED AND OBSERVED STORAGES AT THE END
C  POINTS. (THIS TECHNIQUE COURTESY OF ED FOX.)
C
      LOBSEL = IDPT(LOCPT1+2) + IDOFST*24/IDTEL
      NPVAL = NRUN/NINT
      IF (IBUG.GE.2) WRITE(IODBUG,1610)
      IF (IBUG.GE.2) WRITE(IODBUG,1651) (D(LOBSEL+I-1),I=1,NPVAL)
 1610 FORMAT(/10X,'** OBSERVED POOL ELEVATIONS **')
      DO 4200 I=1,NRUN
C
C  WE CAN ONLY GET ELEVATION VALUES FOR TIME INTERVALS MATCHING THE
C  DELTA-T OF THE ELEVATION TIME SERIES.
C
      IF (MOD(I,NINT).NE.0) GO TO 4010
C
C  SEE IF VALUE OF TIME SERIES IS MISSING
C
      VAL = D(LOBSEL+I-1)
      JULX = JULI(I)
      IF (IFMSNG(VAL).EQ.0 .AND. IFGNOR(IETYPE,JULX,ISUTYP).EQ.0)
     .  GO TO 4100
C
C  INCREMENT THE NO. OF MISSING
C
 4010 CONTINUE
      NMISS = NMISS + 1
      GO TO 4200
C
C  WE'VE FOUND A DATA VALUE. IF WE HAVE NO MISSING JUST SET THE PERIOD
C  OF LAST OBSERVED, COMPUTE THE STORAGES FOR THE OBSERVED ELEVATION,
C  AND SET THE BEGINNING POINTS FOR POSSIBLE LATER USE IN INTERPOLATION.
C  ALSO SET THE VALUES IN THE TRACE AREA OF THE WORK ARRAY.
C
 4100 CONTINUE
      IF (NMISS.GT.0) GO TO 4150
C
C  THE FOLLOWING CHANGES MADE ON 2/13/90
C      LAOBS = I
      LAEL = I
C  END OF CHANGE OF 2/13/90
      STSSTO = W(LOCSTO+I-1)
      CALL NTER26(VAL,STOSTO,PO(LESELV),PO(LESSTO),NSE,IFLAG,NTERP,IBUG)
      W(LOCSTO+I-1) = STOSTO
      W(LOCEL+I-1)  = VAL
      GO TO 4200
C
C  HERE WE'VE FOUND AN OBSERVED VALUE AND NEED TO FILL IN MISSING GAPS.
C
 4150 CONTINUE
      ENDSST = W(LOCSTO+I-1)
      W(LOCEL+I-1) = VAL
      CALL NTER26(VAL,ENDOST,PO(LESELV),PO(LESSTO),NSE,IFLAG,NTERP,IBUG)
      W(LOCSTO+I-1) = ENDOST
C
      DIF1 = STOSTO - STSSTO
      DIF2 = ENDOST - ENDSST
      PDDIFF = (DIF2-DIF1)/(NMISS+1)
C
C  DISTRIBUTE THE PERIOD DIFFERENCE BY ADDING TO THE SIMULATED AT EACH
C  MISSING INTERVAL
C
      CALL X17N26(1,W,PO,LOCSTO,LOCEL,DIF1,DIF2,I,NMISS,0,1)
C
C  SET INITIAL POINTS FOR LATER USE.
C
      STOSTO = ENDOST
      STSSTO = ENDSST
C  THE FOLLOWING CHANGES MADE ON 2/13/9H
C      LAOBS = I
      LAEL = I
C  END OF CHANGE OF 2/13/90
      NMISS = 0
 4200 CONTINUE
C
C  NOW HAVE STORAGES AND ELEVATIONS. NOW COMPUTE MEAN DISCHARGES.
C
C  MUST TRUNCATE THE RUN PERIOD TO FULL DAYS
C
C  THE FOLLOWING CHANGE MADE ON 9/5/89
C      LAOBS = MAX0(LAOBS,LAINST)
C      NDAY = LAOBS/NTIM24
C      NRUN = NDAY*NTIM24
C  THE FOLLOWING CHANGE MADE ON 2/13/90
C      NLOBS = MAX0(NLOBS,LAINST)
C  THE FOLLOWING CHNAGE MADE ON 5/10/90 #601
C      NLOBS = MAX0(LAEL,LAINST)
      NLOBS = LAEL
      NDAY=NLOBS/NTIM24
      NLOBS=NDAY*NTIM24
      IF(NLOBS.LE.0) NLOBS=LAINST
C  END OF CHANGE OF 5/10/90
C
C  IF NO OBSERVED DATA, JUST EXIT
C
C      IF (NRUN .EQ. 0) GO TO 9101
      IF (NLOBS .EQ. 0) GO TO 9101
C  END OF CHANGE OF 9/5/89
C
C  NOW HAVE MEAN INFLOWS. COMPUTE PERIOD MEAN DISCHARGES.
C
      PRESTO = CO(6)
C
C      DO 4500 I=1,NRUN
      DO 4500 I=1,NLOBS
      DELS = W(LOCSTO+I-1) - PRESTO
      PRESTO = W(LOCSTO+I-1)
      OBAR = W(LOCWK+I-1) - DELS
C  THE FOLLOWING CHANGES MADE ON 3/5/90
      IF(OBAR.LE.0.0) OBAR=0.0
C  END OF CHANGE OF 3/5/90
      W(LOCQOM+I-1) = OBAR
 4500 CONTINUE
C
C  NOW COMPUTE THE INSTANTANEOUS DISCHARGES. FIRST WE MUST SUM UP THE
C  PERIOD MEANS TO GET THE DAILY MEANS
C
      CALL X17S26(W,LOCQOM,QMD,NTIM24,1,NLOBS,NTIM24,IQMD,IETYPE)
C
C  CALL THE ADJUSTMENT ROUTINE TO ADJUST THE SIMULATED INST. TO MATCH
C  DAILY VOLUMES WITH THE 'OBSERVED' DAILY VOLUMES.
C
      TOLRNS = 0.025
      CALL XADJ26(W(LOCQO),QWORK,QMD,1,IQMD,1,NLOBS,TOLRNS,CO(3),
     .            IORDN,MINODT,MINODT,24,D,LOBSQO,IDTQO,IERD)
C
C  NOW COMPUTE THE MEANS WHEREVER TWO CONSECUTIVE INSTANTANEOUS
C  ARE NOT MISSING
C
      IF (LOBSQO.EQ.0) GO TO 9000
C
      JULX = JULI(1)
      IF(IERD(1).EQ.1) GO TO 4700
      QO = D(LOBSQO)
      IF (IFMSNG(QO).EQ.1 .OR.
     & IFGNOR(IITYPE,JULX,ISUTYP).EQ.1)GO TO 4700
      QO = W(LOCQO)
      W(LOCQOM) = (CO(3) + QO)/2.0
C
 4700 DO 4800 I=2,NLOBS
      IDAY = (I-1)/NTIM24 + 1
      IF(IERD(IDAY).EQ.1) GO TO 4800
      JULX = JULI(I-1)
      QO = D(LOBSQO+I-2)
      IF (IFMSNG(QO).EQ.1 .OR.
     & IFGNOR(IITYPE,JULX,ISUTYP).EQ.1)GO TO 4800
      JULX= JULI(I)
      QO = D(LOBSQO+I-1)
      IF (IFMSNG(QO).EQ.1 .OR.
     & IFGNOR(IITYPE,JULX,ISUTYP).EQ.1)GO TO 4800
      QOP = W(LOCQO+I-2)
      QO = W(LOCQO+I-1)
      W(LOCQOM+I-1) = (QOP+QO)/2.0
 4800 CONTINUE
C
C  THAT'S IT FOR THIS COMBINATION OF OBSERVED ELEVATIONS AND DISCHARGES.
C
      GO TO 9000
C
C---------------------------------------------------------------------
C  IN THIS SITUATION WE HAVE TIME SERIES FOR MEAN DISCHARGE AND POOL
C  ELEVATIONS, EITHER BY THEMSELVES OR WITH AN OBSERVED INSTANTANEOUS
C  DISCHARGE TIME-SERIES. IF THE INST. DATA WAS USED, THE INST.
C  ADJUSTMENTS WERE DONE PREVIOUSLY AND DO NOT ALTER THE STRATEGY USED
C  HERE. DIFFERENT STRATEGIES ARE USED FOR DIFFERENT TIME INTERVALS.
C  IF THE TIME INTERVAL OF THE DISCHARGE TIME SERIES IS NOT THE SAME AS
C  THAT OF THE OPERATION, PROCESS CONTROL GOES TO STATEMENT 6500 (THE
C  STRATEGY IS DISCUSSED THERE.)
C
C  IF THE DISCHARGE TIME SERIES IS THE SAME AS THE OPERATION TIME
C  INTERVAL, WE FIRST FILL ANY MISSING STORAGES. THIS IS DONE BY
C  MARCHING FORWARD FROM THE BEGINNING OF THE RUN AND
C   1) USING THE CONTINUITY EQUATION WE FILL MISSING STORAGES AS LONG AS
C      THE DISCHARGES ARE CONTINUOUS,
C   2) BACK-STEPPING FROM AN OBSERVED ELEVATION/STORAGE WHEN DISCHARGES
C      ARE CONTINUOUS, AND
C   3) DISTRIBUTING DIFFERENCES OVER THE MISSING PERIOD AND ADDING IT
C      TO THE SIMULATED STORAGES.
C
C  MISSING DISCHARGES ARE THEN FILLED USING THE CONTINUITY EQUATION.
C
C  FIRST GET THE TIME INTERVALS OF BOTH TIME-SERIES.
C
 6000 CONTINUE
      IDTEL = PO(LOCTSI(3)+3)
      IDTQ = PO(LOCTSI(2)+3)
      LOBSEL = IDPT(LOCPT1+2) + IDOFST*24/IDTEL
      LOBSQM = IDPT(LOCPT1+1) + IDOFST*24/IDTQ
C
C  USE DIFFERENT STRATEGY IF DT OF DISCHARGE IS NOT = DT OF OPERATION
C
      INTEL = IDTEL/MINODT
      IF (IDTQ.NE.MINODT) GO TO 6500
      NPVAL = NRUN*MINODT/IDTEL
      IF (IBUG.LE.1) GO TO 6002
      WRITE(IODBUG,1610)
      WRITE(IODBUG,1651) (D(LOBSEL+I-1),I=1,NPVAL)
      WRITE(IODBUG,1620)
      WRITE(IODBUG,1650) (D(LOBSQM+I-1),I=1,NRUN)
 6002 CONTINUE
C
C  HERE THE DISCHARGE TIME-SERIES IS EQUAL THE OPERATION TIME INTERVAL.
C  FIRST INITIALIZE TEMPORARY STORAGE HOLDING SPACE TO MISSING.
C
      MRLOC(1) = 0
      LOCTMP = LOCOWS(2)
      DO 6005 I=1,NUM
      W(LOCTMP+I-1) = -999.0
 6005 CONTINUE
C
C  NOW STEP THROUGH THE RUN PERIOD FILLING ANY MISSING STORAGES USING
C  VARIOUS STRATEGIES.
C
      ISKIP = 0
      SS1 = CO(6)
      LASTFL = 0
      DO 6100 I=1,NRUN
      IF (ISKIP.GT.0) GO TO 6090
C
      SS2 = -999.0
      QQIM = W(LOCWK+I-1)
C
C  NOT HAVING A TS VALUE AT THIS TIME INTERVAL FOR THE ELEVATION TS IS
C  THE SAME AS THE VALUE BEING MISSING.
C
      IF (MOD(I,INTEL) .NE. 0) GO TO 6010
      JULX = JULI(I)
      IF (IFMSNG(D(LOBSEL+I-1)).EQ.1.OR.IFGNOR(IETYPE,JULX,ISUTYP).EQ.1)
     .  GO TO 6010
C
C  SET THE ELEVATION IN THE TRACE AREA AND COMPUTE THE STORAGE.
C
      W(LOCEL+I-1) = D(LOBSEL+I-1)
      CALL NTER26(W(LOCEL+I-1),SS2,PO(LESELV),PO(LESSTO),NSE,IFLAG,
     .            NTERP,IBUG)
      W(LOCTMP+I-1) = SS2
      LASTFL = I
      GO TO 6090
C
C--------------------------------
C  IF ELEVATION IS MISSING SEE IF WE CAN COMPUTE THE STORAGE FROM THE
C  OBSERVED DISCHARGE
C
 6010 CONTINUE
      IF (IFMSNG(D(LOBSQM+I-1)).EQ.1.OR.IFGNOR(IMTYPE,JULX,ISUTYP).EQ.1)
     .  GO TO 6090
C
C  COMPUTE THE STORAGE USING THE CONTINUITY EQUATION.
C  FIRST CONVERT THE DISCHARGE VOLUME FROM CMSD TO TIME-INTERVAL-MEAN-
C  DISCHARGE
C
      QQOM = D(LOBSQM+I-1) * NTIM24
C
C  CAN ONLY COMPUTE ENDING STORAGE IF BEGINNING STORAGE IS PRESENT.
C
      IF (IFMSNG(SS1) .EQ. 1) GO TO 6020
C
      SS2 = SS1 + QQIM - QQOM
      W(LOCTMP+I-1) = SS2
      LASTFL = I
      GO TO 6090
C
C-------------------------------
C  HERE WE LOOK OUT INTO THE FUTURE TO FIND THE NEXT OBSERVED ELEVATION
C  TO BACK COMPUTE THE STORAGES, BUT THIS CAN ONLY BE DONE IF THERE ARE
C  NO MISSING DISCHARGES.
C
 6020 CONTINUE
      IF (I.EQ.NRUN) GO TO 6090
      JB = I + 1
      DO 6030 J=JB,NRUN
C
C  IF WE FIND A MISSING DISCHARGE BEFORE WE FIND THE NEXT ELEVATION
C  WE CAN'T USE THIS METHOD.
C
      JULZ = JULI(J)
      IF (IFMSNG(D(LOBSQM+J-1)).EQ.1.OR.IFGNOR(IMTYPE,JULZ,ISUTYP).EQ.1)
     .  GO TO 6090
C
C  START FILLING IN MISSING STORAGES WHEN WE FIND THE NEXT ELEVATION.
C
      IF (MOD(J,INTEL) .NE. 0) GO TO 6030
      IF (IFMSNG(D(LOBSEL+I-1)).EQ.1.OR.IFGNOR(IETYPE,JULZ,ISUTYP).EQ.1)
     .  GO TO 6030
C
C  SET THE END OF THE FILLING PERIOD
C
      JE = J
      LASTFL = JE
C
      W(LOCEL+J-1) = D(LOBSEL+J-1)
      CALL NTER26(W(LOCEL+J-1),W(LOCTMP+J-1),PO(LESELV),PO(LESSTO),NSE,
     .            IFLAG,NTERP,IBUG)
C
      GO TO 6040
 6030 CONTINUE
C
C  CAN'T FILL IF WE DON'T FIND ANOTHER ELEVATION
C
      GO TO 6090
C
C  FILL IN MISSING STORAGES FROM THE FOUND STORAGE USING THIS FROM OF
C  THE CONTINUITY EQUATION:
C
C               SS1 = SS2 - QQIM + QQOM
C
 6040 CONTINUE
      DO 6050 J = JB,JE
      JJ = JE - J + JB - 1
C
      W(LOCTMP+JJ-1) = W(LOCTMP+JJ) - W(LOCWK+JJ) + (D(LOBSQM+JJ)*NTIM24
     . )
C
C  SET ELEVATION FOR THIS STORAGE
C
      CALL NTER26(W(LOCTMP+JJ-1),W(LOCEL+JJ-1),PO(LESSTO),PO(LESELV),
     .            NSE,IFLAG,NTERP,IBUG)
 6050 CONTINUE
C
C  SINCE WE'VE STEPPED FORWARD WITHIN THE LOOP, WE MUST SET THE NO. OF
C  INCREMENTS TO SKIP.
C
      ISKIP = JE - JB + 2
C
 6090 CONTINUE
      ISKIP = ISKIP - 1
      SS1 = W(LOCTMP+I-1)
 6100 CONTINUE
C
C--------------------------------------
C  NOW WE FILL IN ANY MISSING STORAGES BY DISTRIBUTING DIFFERENCES
C  BETWEEN END POINT STORAGE VALUES AND ADDING THIS DIFF TO THE
C  SIMULATED STORAGES.
C
C
C  SET COUNTERS AND FLAGS TO INITIAL VALUES.
C
      NMISS = 0
      LAOBS = 0
      STSSTO = CO(6)
      STOSTO = STSSTO
C
C  NOW GO THROUGH OBSERVED PERIOD LOOKING FOR AND FILLING ANY MISSING
C  GAPS OF ELEVATION. THE MISSING VALUES ARE FILLED BY DISTRIBUTING THE
C  DIFFERENCE BETWEEN THE SIMULATED AND OBSERVED STORAGES AT THE END
C  POINTS. (THIS TECHNIQUE COURTESY OF ED FOX.)
C
      DO 6300 I=1,NRUN
C
C  WE CAN ONLY GET ELEVATION VALUES FOR TIME INTERVALS MATCHING THE
C  DELTA-T OF THE ELEVATION TIME SERIES.
C
      IF (MOD(I,INTEL).NE.0) GO TO 6110
C
C  SEE IF VALUE OF TIME SERIES IS MISSING
C
      VAL = W(LOCTMP+I-1)
      JULX = JULI(I)
      IF (IFMSNG(VAL).EQ.0 .AND. IFGNOR(IETYPE,JULX,ISUTYP).EQ.0)
     .  GO TO 6200
C
C  INCREMENT THE NO. OF MISSING
C
 6110 CONTINUE
      NMISS = NMISS + 1
C  THE FOLLOWING CHANGES MADE ON 9/5/89
C  ADJUSTMENT MADE ONLY TO THE LAST OBSERVED DATA
C  THEN THE LAST OBSERVED/ADJUSTED DATA WILL BE USED
C  AS INITIAL CONDITION TO FORECAST THE REST OF THE RUN
C  OK TO HAVE MISSING DATA AT END OF RUN
C **EJV MOD** MAINTENANCE ITEM 292 8/14/86
C PROBLEM IS THAT MISSING DATA AT END OF OBSERVED PERIOD ARE NOT
C HANDLED SO THE FIX IS THE FOLLOWING CODE WHICH ASSUMES THAT
C THE ADJUSTED STORAGE AT NRUN = SIMULATED STORAGE + ADJUSTMENT
C WHERE ADJUSTMENT IS THE DIFFERENCE BETWEEN ADJSUTED AND SIMULATED
C STORAGE AT LAST OBS WEIGHTED ACCORDING TO HOW FAR FROM LAST
C OBS IT IS (THE WEIGHT IS ASSISNED BASE ON ASSUMPTION THAT
C ADJ AND SIM COME TOGETHER 24 TIME PERIODS FROM LAST OBS)
C      IF (I.NE.NRUN) GO TO 6115
C      NMISS=NMISS-1
C      PERODS=24.
C      DIF1=STOSTO-STSSTO
C      PCTDIF=(PERODS-NMISS)/PERODS
C      SIMSTR=W(LOCSTO+I-1)
C      ADJSTR=SIMSTR+DIF1*PCTDIF
C      W(LOCTMP+I-1)=ADJSTR
C      IF (IBUG.GE.2) WRITE(IODBUG,8383) STOSTO,STSSTO,DIF1,ADJSTR,
C     1 SIMSTR,IEJV,I
C8383  FORMAT(//1X,'EV MOD STMT 8383',5F7.0,2I5)
C      GO TO 6200
C6115  CONTINUE
C ** END EJV MOD **
      GO TO 6300
C
C  WE'VE FOUND A DATA VALUE. IF WE HAVE NO MISSING JUST SET THE PERIOD
C  OF LAST OBSERVED, COMPUTE THE STORAGES FOR THE OBSERVED ELEVATION,
C  AND SET THE BEGINNING POINTS FOR POSSIBLE LATER USE IN INTERPOLATION.
C  ALSO SET THE VALUES IN THE TRACE AREA OF THE WORK ARRAY.
C
 6200 CONTINUE
      IF (NMISS.GT.0) GO TO 6250
C
      LAOBS = I
      STSSTO = W(LOCSTO+I-1)
      STOSTO = W(LOCTMP+I-1)
      CALL NTER26(STOSTO,VAL,PO(LESSTO),PO(LESELV),NSE,IFLAG,NTERP,IBUG)
      W(LOCEL+I-1)  = VAL
      GO TO 6300
C
C  HERE WE'VE FOUND AN OBSERVED VALUE AND NEED TO FILL IN MISSING GAPS.
C
 6250 CONTINUE
      ENDSST = W(LOCSTO+I-1)
      ENDOST = W(LOCTMP+I-1)
      CALL NTER26(ENDOST,VAL,PO(LESSTO),PO(LESELV),NSE,IFLAG,NTERP,IBUG)
      W(LOCEL+I-1) = VAL
C
      DIF1 = STOSTO - STSSTO
      DIF2 = ENDOST - ENDSST
      CALL X17N26(1,W,PO,LOCSTO,LOCEL,DIF1,DIF2,I,NMISS,0,1)
C
C  NEED TO TRANSFER INTO THE TEMPORARY HOLDING SPACE
C
      CALL UMEMOV(W(LOCSTO+I-NMISS-1),W(LOCTMP+I-NMISS-1),NMISS)
C
C  SET INITIAL POINTS FOR LATER USE.
C
      STOSTO = ENDOST
      STSSTO = ENDSST
      LAOBS = I
      NMISS = 0
 6300 CONTINUE
C
C  NOW RESET THE LENGTH OF THE OBSERVED PERIOD TO FULL DAY.
C
C  THE FOLLOWING CHANGES MADE ON 9/5/89
C      NRUN = MAX0(LASTFL,LAOBS,LAINST)
C      NDAY = NRUN/NTIM24
C      NRUN = NDAY * NTIM24
C      IF (NRUN .EQ. 0) GO TO 9101
C  THE FOLLOWING CHANGE MADE ON 5/10/90 #601
C      NLOBS = MAX0(LASTFL,LAOBS,LAINST)
      NLOBS = MAX0(LASTFL,LAOBS)
      NDAY = NLOBS/NTIM24
      NLOBS = NDAY * NTIM24
      IF(NLOBS.LE.0) NLOBS=LAINST
C  END OF CHANGE OF 5/10/90 #601
      IF (NLOBS .EQ. 0) GO TO 9101
C  END OF CHANGE OF 9/5/89
C
C-----------------------------------------
C  NOW WE FILL IN ANY MISSING DISCHARGES ADVANCING FROM THE START OF
C  THE RUN
C
      SS1 = CO(6)
      DO 6400 I=1,NLOBS
      JULX = JULI(I)
      IF (IFMSNG(D(LOBSQM+I-1)).EQ.1.OR.IFGNOR(IMTYPE,JULX,ISUTYP).EQ.1)
     .  GO TO 6350
C
      W(LOCQOM+I-1) = D(LOBSQM+I-1) * NTIM24
      SS1 = W(LOCTMP+I-1)
      GO TO 6400
C
C  USE THE CONTINUITY EQUATION HERE. (OBAR = IBAR - (S2 - S1))
C
 6350 CONTINUE
C  THE FOLLOWING CHANGE MADE ON 5/10/90 #601
      IF(SS1.LT.0.0 .OR. SS2.LT.0.0) GO TO 6351
C  END OF CHANGE OF 5/10/90 #601
      SS2 = W(LOCTMP+I-1)
      QQIM = W(LOCWK+I-1)
C
      QQOM = QQIM - (SS2-SS1)
C  THE FOLLOWING CHANGES MADE ON 3/5/90
      IF(QQOM.LE.0.0) QQOM=0.0
C  END OF CHANGE OF 3/5/90
      W(LOCQOM+I-1) = QQOM
C  THE FOLLOWING CHANGE MADE ON 5/10/90 #601
C      SS1 = SS2
 6351 SS1=SS2
C  END OF CHANGE OF 5/10/90 #601
C
 6400 CONTINUE
C
C-------------------------------------
C  NOW COMPUTE THE INSTANTANEOUS DISCHARGES. FIRST WE MUST SUM UP THE
C  PERIOD MEANS TO GET THE DAILY MEANS
C
      CALL X17S26(W,LOCQOM,QMD,NTIM24,1,NLOBS,NTIM24,IQMD,0)
C
C  CALL THE ADJUSTMENT ROUTINE TO ADJUST THE SIMULATED INST. TO MATCH
C  DAILY VOLUMES WITH THE 'OBSERVED' DAILY VOLUMES.
C
      TOLRNS = 0.025
      CALL XADJ26(W(LOCQO),QWORK,QMD,1,IQMD,1,NLOBS,TOLRNS,CO(3),
     .            IORDN,MINODT,MINODT,24,D,LOBSQO,IDTQO,IERD)
C
C  TRANSFER STORAGES FROM TEMPORARY HOLDING SPACE TO STORAGE TRACE AREA
C  IN WORK ARRAY
C
      CALL UMEMOV(W(LOCTMP),W(LOCSTO),NUM)
C
C-------------------------------------------------------
C  FINALLY, WE'RE ALL DONE WITH THIS SITUATION.
C
      GO TO 9000
C
C--------------------------------------------------------------
C  HERE WE HAVE DISCHARGES AT A GREATER TIME INTERVAL THAN THE OPERATION
C  TIME INTERVAL.
C  SUM VALUES TO GET THE DAILY VOLUMES AND COMPUTE THE INSTANTAN-
C  EOUS DISCHARGES, COMPUTE THE MEANS FROM THE INSTANTANEOUS, AND
C  COMPUTE THE STORAGE/ELEVATION FROM THE PERIOD MEANS AND THE MEAN
C  INFLOWS (WHERE MISSING).
C
 6500 CONTINUE
      NTIMOB = 24/IDTQ
      NDAY = NRUN/NTIM24
      NOBS = NDAY*NTIMOB
      NPVAL = NRUN*MINODT/IDTEL
      IF (IBUG.LE.1) GO TO 6502
      WRITE(IODBUG,1610)
      WRITE(IODBUG,1651) (D(LOBSEL+I-1),I=1,NPVAL)
      WRITE(IODBUG,1620)
      WRITE(IODBUG,1650) (D(LOBSQM+I-1),I=1,NOBS)
 6502 CONTINUE
C
C
C  SUM UP OBSERVED PERIOD MEANS TO GET DAILY MEANS.
C
      CALL X17S26(D,LOBSQM,QMD,1,1,NOBS,NTIMOB,IQMD,IMTYPE)
C
C  MUST TRUNCATE THE RUN PERIOD TO THE LAST FULL DAY
C
C  THE FOLLOWING CHANGE MADE ON 9/5/89
C      NRUN = IQMD * NTIM24
C      NRUN = MAX0(NRUN,LAINST)
C      IF (NRUN .EQ. 0) GO TO 9101
C  THE FOLLOWING CHANGE MADE ON 2/13/90
C      NLOBS = IQMD * NTIM24
C      NLOBS = MAX0(NLOBS,LAINST)
      NLOBS = IQMD * NTIM24
      NLOBS = MAX0(NLOBS,LAINST)
      NDAY=NLOBS/NTIM24
      NLOBS=NDAY*NTIM24
C  END OF CHANGE OF 2/13/90
      IF (NLOBS .EQ. 0) GO TO 9101
C  END OF CHANGE OF 9/5/89
C
C  NOW COMPUTE THE INSTANTANEOUS BASED ON THE 'OBSERVED' DAILY VOLUMES.
C
      TOLRNS = 0.025
      CALL XADJ26(W(LOCQO),QWORK,QMD,1,IQMD,1,NLOBS,TOLRNS,CO(3),IORDN,
     .            MINODT,MINODT,24,D,LOBSQO,IDTQO,IERD)
C
C  COMPUTE THE 'ADJUSTED' PERIOD MEANS NOW.
C
      CALL X17M26(W,LOCQOM,LOCQO,CO(3),1,NLOBS)
C
C  NOW COMPUTE STORAGES AND ELEVATIONS FROM PERIOD MEAN DISCHARGES AND
C  MEAN INFLOWS
C
      PRESTO = CO(6)
C
      DO 6800 I=1,NLOBS
C
C  ONLY FILL STORAGES IF THERE IS NO VALUE AT THE TIME INTERVAL, OR THE
C  VALUE IS MISSING.
C
      IF (MOD(I,INTEL) .NE. 0) GO TO 6770
      JULX = JULI(I)
      IF (IFMSNG(D(LOBSEL+I-1)).EQ.1.OR.IFGNOR(IETYPE,JULX,ISUTYP).EQ.1)
     .  GO TO 6770
C
      W(LOCEL+I-1) = D(LOBSEL+I-1)
      CALL NTER26(W(LOCEL+I-1),W(LOCSTO+I-1),PO(LESELV),PO(LESSTO),NSE,
     .            IFLAG,NTERP,IBUG)
      PRESTO = W(LOCSTO+I-1)
      GO TO 6800
C
 6770 CONTINUE
      CALL X17E26(W,PO,LOCSTO,LOCEL,LOCQOM,LOCWK,PRESTO,I,I)
 6800 CONTINUE
C
C ---------------------------------------------------------
C  THAT'S THE END OF THE ADJUSTMENT
C
 9000 CONTINUE
C
C  LAST CHECK IS TO LOOK FOR ANY NEGATIVE DISCHARGES AND RESET TO
C  ZERO IF FOUND.
C
CC *** EV CHANGE **
CC SO THAT WARNINGS FROM FORMATS 675 680 DONT PRINT OVER AND OVER.
CC CHANGE WAS TO ADD COUNTERS OF NUMBER OF ERRORS FOR INST AND
CC MEAN (IERNVI,IERNVM) AND ARRAYS CONTAINING PERIOD NUMBERS
CC OF THE WARNINGS FOR BOTH INST AND MEAN (IERPDI,IERPDM).
CC
      IERNVI=0
      IERNVM=0
C      DO 9100 I=1,NRUN
      DO 9100 I=1,NLOBS
C
C  INST. DISCHARGES FIRST.
C
      IF (W(LOCQO+I-1) .GE. 0.00) GO TO 9050
      IF (IFMSNG(W(LOCQO+I-1)) .EQ. 1) GO TO 9050
C
      IERNVI=IERNVI+1
      IERPDI(IERNVI)=I
      W(LOCQO+I-1) = 0.00
C
C  MEAN DISCHARGES NEXT.
C
 9050 CONTINUE
      IF (W(LOCQOM+I-1) .GE. 0.00) GO TO 9100
      IF (IFMSNG(W(LOCQOM+I-1)) .EQ. 1) GO TO 9100
C
      IERNVM=IERNVM+1
      IERPDM(IERNVM)=I
      W(LOCQOM+I-1) = 0.00
 9100 CONTINUE
      IF (.NOT. WRAJQI) GO TO 9110
      IF (IERNVI.GT.200) IERNVI=200
      IF (IERNVI.NE.0) WRITE(IPR,675) (IERPDI(I),I=1,IERNVI)
      IF (IERNVI.NE.0) CALL WARN
  675 FORMAT(11X,'** WARNING ** A NEGATIVE INSTANTANEOUS ADJUSTED ',
     . 'DISCHARGE WAS COMPUTED AND THUS RESET TO 0 FOR PERIODS'
     . /10X,(40I3))
 9110 IF (.NOT. WRAJQM) GO TO 9101
      IF (IERNVM.GT.200) IERNVM=200
      IF (IERNVM.NE.0) WRITE(IPR,680) (IERPDM(I),I=1,IERNVM)
      IF (IERNVM.NE.0) CALL WARN
  680 FORMAT(11X,'** WARNING ** A NEGATIVE MEAN ADJUSTED ',
     . 'DISCHARGE WAS COMPUTED AND THUS RESET TO 0 FOR PERIODS'
     . /10X,(40I3))
 9101 CONTINUE
C
C  SET LAST OBSERVED STORAGE POSITION
C
      IF(NLOBS.LE.LOBSTO) LOBSTO = NLOBS
C
      IF (IBUG.LT.2) GO TO 9009
C
C  WRITE INST. ADJ. DISCHARGES
C
      WRITE(IODBUG,1690)
 1690 FORMAT(/10X,'** INST. ADJ. DISCHARGES **')
      WRITE(IODBUG,1650) (W(LOCQO+I-1),I=1,NUM)
 1650 FORMAT(1X,8F10.0)
 1651 FORMAT(1X,8F10.3)
C
C  WRITE MEAN ADJ. DISCHARGES
C
      WRITE(IODBUG,1692)
 1692 FORMAT(/10X,'** MEAN ADJ. DISCHARGES **')
      WRITE(IODBUG,1650) (W(LOCQOM+I-1),I=1,NUM)
C
C  WRITE ADJ. POOL ELEVATIONS
C
      WRITE(IODBUG,1694)
 1694 FORMAT(/10X,'** ADJ. POOL ELEVATIONS **')
      WRITE(IODBUG,1651) (W(LOCEL+I-1),I=1,NUM)
C
C  WRITE ADJ. STORAGES
C
      WRITE(IODBUG,1696)
 1696 FORMAT(/10X,'** ADJ. STORAGES **')
      WRITE(IODBUG,1650) (W(LOCSTO+I-1),I=1,NUM)
C
      WRITE(IODBUG,1680) NRUNS,LOBSTO,ICOMB
 1680 FORMAT(' NO. OF PERIODS IN OBSERVED PORTION = ',I3/
     . '  LAST OBSERVED PERIOD = ',I3,'  ADJ COMB CODE ICOMB = ',I3)
C
 9009 CONTINUE
      NRUN = NRUNS
      IF (IBUG.GE.1) WRITE(IODBUG,1699)
 1699 FORMAT('    *** EXIT XU1726 ***')
C
      RETURN
      END