REM #using ace:submods/mui/MUI.o

#include <submods/MUI.h>

{ Libraries needed by main program (muimaster opened by submod) }
LIBRARY "intuition.library"
LIBRARY "utility.library"

ADDRESS app, win, grp, txt

{ Initialize MUI }
MUIInit

{ Create a centered text object }
txt = MUITextCentered("Hello from MUI!")
txt2 = MUITextCentered("MUI and more!")

{ Wrap in a group - MUI windows need a group as root }
MUIBeginHGroup
  MUIBeginVGroup
    MUIGroupFrameT("Welcome")
    MUIChild(txt)
    MUIChild(MUIRectangle)
  MUIChild(MUIEndGroup)
  MUIChild(MUIBalance)
  MUIBeginVGroup
    MUIGroupFrameT("Welcome2")
    MUIChild(txt2)
    MUIChild(MUIRectangle)
  MUIChild(MUIEndGroup)
grp = MUIEndGroup

{ Create window with group as root }
win = MUIWindow("Hello MUI - vert sizable balance", grp)

{ Create application with the window }
app = MUIApp("HelloMUI", "$VER: HelloMUI  1.0", win)

IF app <> 0& THEN
    { Set up window close notification }
    MUINotifyClose(win, app, MUIV_Application_ReturnID_Quit)

    { Open the window }
    MUIWindowOpen(win)

    { Event loop - wait until quit }
    WHILE MUIWaitEvent(app) <> MUIV_Application_ReturnID_Quit
    WEND

    { Dispose the application (frees all objects) }
    MUIDispose(app)
END IF

{ Cleanup MUI }
MUICleanup

{ Close libraries }
LIBRARY CLOSE "utility.library"
LIBRARY CLOSE "intuition.library"

END
