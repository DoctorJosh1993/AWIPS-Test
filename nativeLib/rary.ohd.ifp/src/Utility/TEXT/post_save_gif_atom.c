#include "libXifp.h"
#include "ifp_atoms.h"

void post_save_gif_atom(Widget w, int value)
{
   /* post the IFPA_save_gif_file atom - 
      set to value
    */

       XChangeProperty(
         XtDisplay(w),
         DefaultRootWindow(XtDisplay(w)),
         IFPA_save_gif_file,
         IFPA_save_gif_file_type,
         8,
         PropModeReplace,
         (unsigned char *)&value,
         sizeof(int)
         );

/*  ==============  Statements containing RCS keywords:  */
{static char rcs_id1[] = "$Source: /fs/hseb/ob72/rfc/ifp/src/Utility/RCS/post_save_gif_atom.c,v $";
 static char rcs_id2[] = "$Id: post_save_gif_atom.c,v 1.2 2006/04/07 17:00:00 aivo Exp $";}
/*  ===================================================  */

}