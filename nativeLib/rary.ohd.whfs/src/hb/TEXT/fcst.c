/*
** Generated by X-Designer
*/
/*
**LIBS: -lXm -lXt -lX11
*/

#include <stdlib.h>
#include <X11/Xatom.h>
#include <X11/Intrinsic.h>
#include <X11/Shell.h>

#include <Xm/Xm.h>
#include <Xm/DialogS.h>
#include <Xm/Form.h>
#include <Xm/Label.h>
#include <Xm/PushB.h>
#include <Xm/RowColumn.h>
#include <Xm/Separator.h>
#include <Xm/Text.h>
#include <Xm/CascadeBG.h>
#include <Xm/LabelG.h>


Widget fcstDS = (Widget) NULL;
Widget fcstFM = (Widget) NULL;
Widget fcstWR = (Widget) NULL;
Widget fpproxOM = (Widget) NULL;
Widget fpproxLbl = (Widget) NULL;
Widget fpproxCB = (Widget) NULL;
Widget fpproxPDM = (Widget) NULL;
Widget fpbedLbl = (Widget) NULL;
Widget fpbedTxt = (Widget) NULL;
Widget fpdivertLbl = (Widget) NULL;
Widget fpdivertTxt = (Widget) NULL;
Widget fprmkLbl = (Widget) NULL;
Widget fprmkTxt = (Widget) NULL;
Widget fpiceLbl = (Widget) NULL;
Widget fpiceTxt = (Widget) NULL;
Widget fpreachLbl = (Widget) NULL;
Widget fpreachTxt = (Widget) NULL;
Widget fpresLbl = (Widget) NULL;
Widget fpresTxt = (Widget) NULL;
Widget fptopoLbl = (Widget) NULL;
Widget fptopoTxt = (Widget) NULL;
Widget fpokPB = (Widget) NULL;
Widget fpdelPB = (Widget) NULL;
Widget fpsepSE = (Widget) NULL;
Widget fpareaLbl = (Widget) NULL;
Widget fpareaTxt = (Widget) NULL;
Widget fpareaokPB = (Widget) NULL;
Widget fpareadelPB = (Widget) NULL;
Widget fpcancelPB = (Widget) NULL;



void create_fcstDS (Widget parent)
{
	Widget children[17];      /* Children to manage */
	Arg al[64];                    /* Arg List */
	register int ac = 0;           /* Arg Count */

	XmString xmstrings[16];    /* temporary storage for XmStrings */
	Widget separator3 = (Widget)NULL;

	XtSetArg(al[ac], XmNallowShellResize, TRUE); ac++;
	XtSetArg(al[ac], XmNminWidth, 940); ac++;
	XtSetArg(al[ac], XmNminHeight, 730); ac++;
	XtSetArg(al[ac], XmNmaxWidth, 940); ac++;
	XtSetArg(al[ac], XmNmaxHeight, 730); ac++;
	fcstDS = XmCreateDialogShell ( parent, (char *) "fcstDS", al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNwidth, 940); ac++;
	XtSetArg(al[ac], XmNheight, 730); ac++;
	XtSetArg(al[ac], XmNautoUnmanage, FALSE); ac++;
	fcstFM = XmCreateForm ( fcstDS, (char *) "fcstFM", al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNwidth, 875); ac++;
	fcstWR = XmCreateForm ( fcstFM, (char *) "fcstWR", al, ac );
	ac = 0;
#if       ((XmVERSION > 1) && (XmREVISION == 1) && (XmUPDATE_LEVEL < 20))
	xmstrings[0] = XmStringGenerate((XtPointer) "Proximity:", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL);
#else  /* ((XmVERSION > 1) && (XmREVISION == 1) && (XmUPDATE_LEVEL < 20)) */
	xmstrings[0] = XmStringCreateLtoR("Proximity:", (XmStringCharSet) XmFONTLIST_DEFAULT_TAG);
#endif /* ((XmVERSION > 1) && (XmREVISION == 1) && (XmUPDATE_LEVEL < 20)) */
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fpproxOM = XmCreateOptionMenu ( fcstWR, (char *) "fpproxOM", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	fpproxLbl = XmOptionLabelGadget ( fpproxOM );
	fpproxCB = XmOptionButtonGadget ( fpproxOM );
	fpproxPDM = XmCreatePulldownMenu ( fpproxOM, (char *) "fpproxPDM", al, ac );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Stream Bed:", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_END); ac++;
	fpbedLbl = XmCreateLabel ( fcstWR, (char *) "fpbedLbl", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNmaxLength, 60); ac++;
	XtSetArg(al[ac], XmNcolumns, 104); ac++;
	XtSetArg(al[ac], XmNrows, 1); ac++;
	fpbedTxt = XmCreateText ( fcstWR, (char *) "fpbedTxt", al, ac );
	ac = 0;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Divert:", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_END); ac++;
	fpdivertLbl = XmCreateLabel ( fcstWR, (char *) "fpdivertLbl", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNmaxLength, 60); ac++;
	XtSetArg(al[ac], XmNcolumns, 104); ac++;
	fpdivertTxt = XmCreateText ( fcstWR, (char *) "fpdivertTxt", al, ac );
	ac = 0;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Remarks:", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_END); ac++;
	fprmkLbl = XmCreateLabel ( fcstWR, (char *) "fprmkLbl", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNmaxLength, 255); ac++;
	XtSetArg(al[ac], XmNcolumns, 104); ac++;
	XtSetArg(al[ac], XmNeditMode, XmMULTI_LINE_EDIT); ac++;
	XtSetArg(al[ac], XmNrows, 4); ac++;
	XtSetArg(al[ac], XmNwordWrap, TRUE); ac++;
	fprmkTxt = XmCreateText ( fcstWR, (char *) "fprmkTxt", al, ac );
	ac = 0;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Freezing:", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_END); ac++;
	fpiceLbl = XmCreateLabel ( fcstWR, (char *) "fpiceLbl", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNmaxLength, 160); ac++;
	XtSetArg(al[ac], XmNcolumns, 104); ac++;
	XtSetArg(al[ac], XmNeditMode, XmMULTI_LINE_EDIT); ac++;
	XtSetArg(al[ac], XmNrows, 4); ac++;
	XtSetArg(al[ac], XmNwordWrap, TRUE); ac++;
	fpiceTxt = XmCreateText ( fcstWR, (char *) "fpiceTxt", al, ac );
	ac = 0;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Reach:", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_END); ac++;
	fpreachLbl = XmCreateLabel ( fcstWR, (char *) "fpreachLbl", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNmaxLength, 80); ac++;
	XtSetArg(al[ac], XmNcolumns, 104); ac++;
	XtSetArg(al[ac], XmNeditMode, XmMULTI_LINE_EDIT); ac++;
	XtSetArg(al[ac], XmNrows, 3); ac++;
	XtSetArg(al[ac], XmNwordWrap, TRUE); ac++;
	fpreachTxt = XmCreateText ( fcstWR, (char *) "fpreachTxt", al, ac );
	ac = 0;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Regulation:", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_END); ac++;
	fpresLbl = XmCreateLabel ( fcstWR, (char *) "fpresLbl", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNmaxLength, 255); ac++;
	XtSetArg(al[ac], XmNcolumns, 104); ac++;
	XtSetArg(al[ac], XmNeditMode, XmMULTI_LINE_EDIT); ac++;
	XtSetArg(al[ac], XmNrows, 4); ac++;
	XtSetArg(al[ac], XmNwordWrap, TRUE); ac++;
	fpresTxt = XmCreateText ( fcstWR, (char *) "fpresTxt", al, ac );
	ac = 0;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Topography:", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_END); ac++;
	fptopoLbl = XmCreateLabel ( fcstWR, (char *) "fptopoLbl", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNmaxLength, 255); ac++;
	XtSetArg(al[ac], XmNcolumns, 104); ac++;
	XtSetArg(al[ac], XmNeditMode, XmMULTI_LINE_EDIT); ac++;
	XtSetArg(al[ac], XmNrows, 4); ac++;
	XtSetArg(al[ac], XmNwordWrap, TRUE); ac++;
	fptopoTxt = XmCreateText ( fcstWR, (char *) "fptopoTxt", al, ac );
	ac = 0;
	fpokPB = XmCreatePushButton ( fcstWR, (char *) "fpokPB", al, ac );
	fpdelPB = XmCreatePushButton ( fcstWR, (char *) "fpdelPB", al, ac );
	fpsepSE = XmCreateSeparator ( fcstFM, (char *) "fpsepSE", al, ac );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Affected Area:", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_END); ac++;
	fpareaLbl = XmCreateLabel ( fcstFM, (char *) "fpareaLbl", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNmaxLength, 80); ac++;
	XtSetArg(al[ac], XmNeditMode, XmMULTI_LINE_EDIT); ac++;
	XtSetArg(al[ac], XmNrows, 3); ac++;
	XtSetArg(al[ac], XmNwordWrap, TRUE); ac++;
	fpareaTxt = XmCreateText ( fcstFM, (char *) "fpareaTxt", al, ac );
	ac = 0;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Save", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fpareaokPB = XmCreatePushButton ( fcstFM, (char *) "fpareaokPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Delete", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fpareadelPB = XmCreatePushButton ( fcstFM, (char *) "fpareadelPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	separator3 = XmCreateSeparator ( fcstFM, (char *) "separator3", al, ac );
	fpcancelPB = XmCreatePushButton ( fcstFM, (char *) "fpcancelPB", al, ac );


	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 5); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -555); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -930); ac++;
	XtSetValues ( fcstWR, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 560); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -570); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 5); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -935); ac++;
	XtSetValues ( fpsepSE, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 590); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -625); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 5); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -125); ac++;
	XtSetValues ( fpareaLbl, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 575); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -640); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 130); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -875); ac++;
	XtSetValues ( fpareaTxt, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 645); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -675); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 720); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -805); ac++;
	XtSetValues ( fpareaokPB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 645); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -675); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 180); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -265); ac++;
	XtSetValues ( fpareadelPB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 680); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -690); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 5); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -935); ac++;
	XtSetValues ( separator3, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 695); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -725); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 430); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -515); ac++;
	XtSetValues ( fpcancelPB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 0); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 25); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_NONE); ac++;
	XtSetValues ( fpproxOM, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 45); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -70); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 5); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -115); ac++;
	XtSetValues ( fpbedLbl, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 40); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -75); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 120); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -865); ac++;
	XtSetValues ( fpbedTxt, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 85); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -110); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 5); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -115); ac++;
	XtSetValues ( fpdivertLbl, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 80); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -115); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 120); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -865); ac++;
	XtSetValues ( fpdivertTxt, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 145); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -170); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 5); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -115); ac++;
	XtSetValues ( fprmkLbl, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 120); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -195); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 120); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -865); ac++;
	XtSetValues ( fprmkTxt, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 220); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -250); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 5); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -115); ac++;
	XtSetValues ( fpiceLbl, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 200); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -275); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 120); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -865); ac++;
	XtSetValues ( fpiceTxt, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 295); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -325); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 5); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -115); ac++;
	XtSetValues ( fpreachLbl, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 280); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -340); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 120); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -865); ac++;
	XtSetValues ( fpreachTxt, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 370); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -395); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 5); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -115); ac++;
	XtSetValues ( fpresLbl, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 345); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -420); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 120); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -865); ac++;
	XtSetValues ( fpresTxt, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 450); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -480); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 5); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -115); ac++;
	XtSetValues ( fptopoLbl, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 425); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -505); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 120); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -865); ac++;
	XtSetValues ( fptopoTxt, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 510); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -545); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 710); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -795); ac++;
	XtSetValues ( fpokPB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 510); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 170); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_NONE); ac++;
	XtSetValues ( fpdelPB, al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNsubMenuId, fpproxPDM); ac++;
	XtSetValues(fpproxCB, al, ac );
	ac = 0;
	if ((children[ac] = fpproxOM) != (Widget) 0) { ac++; }
	if ((children[ac] = fpbedLbl) != (Widget) 0) { ac++; }
	if ((children[ac] = fpbedTxt) != (Widget) 0) { ac++; }
	if ((children[ac] = fpdivertLbl) != (Widget) 0) { ac++; }
	if ((children[ac] = fpdivertTxt) != (Widget) 0) { ac++; }
	if ((children[ac] = fprmkLbl) != (Widget) 0) { ac++; }
	if ((children[ac] = fprmkTxt) != (Widget) 0) { ac++; }
	if ((children[ac] = fpiceLbl) != (Widget) 0) { ac++; }
	if ((children[ac] = fpiceTxt) != (Widget) 0) { ac++; }
	if ((children[ac] = fpreachLbl) != (Widget) 0) { ac++; }
	if ((children[ac] = fpreachTxt) != (Widget) 0) { ac++; }
	if ((children[ac] = fpresLbl) != (Widget) 0) { ac++; }
	if ((children[ac] = fpresTxt) != (Widget) 0) { ac++; }
	if ((children[ac] = fptopoLbl) != (Widget) 0) { ac++; }
	if ((children[ac] = fptopoTxt) != (Widget) 0) { ac++; }
	if ((children[ac] = fpokPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fpdelPB) != (Widget) 0) { ac++; }
	if (ac > 0) { XtManageChildren(children, ac); }
	ac = 0;
	if ((children[ac] = fcstWR) != (Widget) 0) { ac++; }
	if ((children[ac] = fpsepSE) != (Widget) 0) { ac++; }
	if ((children[ac] = fpareaLbl) != (Widget) 0) { ac++; }
	if ((children[ac] = fpareaTxt) != (Widget) 0) { ac++; }
	if ((children[ac] = fpareaokPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fpareadelPB) != (Widget) 0) { ac++; }
	if ((children[ac] = separator3) != (Widget) 0) { ac++; }
	if ((children[ac] = fpcancelPB) != (Widget) 0) { ac++; }
	if (ac > 0) { XtManageChildren(children, ac); }
	ac = 0;
}
