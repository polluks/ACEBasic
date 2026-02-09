Short:        CubicIDE ACE Plugin
Author:       Manfred Bergmann
Uploader:     manfred bergmann me com
Type:         dev/basic
Version:      0.2
Architecture: generic
Distribution: Aminet
Requires:     CubicIDE, ace-basic
Replaces:

Installation of the ACE CubicIDE plugin.

The plugin offers the following functionality:
- syntax highlighting based on the standard "generic.parser" provided by
  Cubic-IDE
- quick navigation of ACE sources files ('.b' or '.bas') in the right
  sidebar
- toolbar commands for 'compile', 'compile&run', 'compile submod' and
  only 'run'

To install the plugin, copy the folders (etc, add-ons) in thew archive to
your CubicIDE installation into the assign 'golded:'.
This folder should already contain those folders.
The folder 'etc' and 'add-ons' in this archive only contain files related
to the AmigaE plugin and should not clash with any existing files.
But to make sure you should make backups of those folders.

When this is done you should start, or re-start CubicIDE.

When you open a ACE source file (.b) you should see the explorer in the
right sidebar and the toolbar buttons.
Also the source code should be syntax highlighted.
If it is not, make sure the syntax highlighting setting is attached to the
ACE plugin settings.
To check this:
- open the Cubic configuration (main menu "Extras"->"Customize...")
- there, open the "Filetypes" tab
- select and open the "ACE" type
- select "Settings" ("Einstellungen")

If there is no entry for "Colorcoding" ("Farbkodierung") you have to add
it:
- select "Settings" entry and click the "+" sign at the bottom toolbar
- in the next window select and open the entry for "Colorcoding"
  ("Farbkodierung")
- there choose the "amigae.syntax" entry
- comfirm by pressing "OK"
- back in the previous window, select "Save" ("Speichern")

Syntax highlighting should work now.


Some notes about compiling and a ACE installation.
The compiling script (ace:bin/bas), which is called from the toolbar
buttons, expects an ACE installation and ACE assigns.

More notes about the compilation process using the ace_wrapper script.
The script extracts the output name from the source file.
A source file named "foobar.b" produces an executable called "foobar".
This is a predefined process in order to allow to "run" the binary without
having specified the name of the executable.
However, it is possible to change the executable name if desired.

The plugin allows to develop with linking submod.
In order to know which submod .o files to link with one can specify:
REM #using <path-to-submod.o>

If installation went well it looks like in the screenshot.



Cheers


Versions:

- 0.1.0:
   + initial version

- 0.1.1:
   + don't run if compile failed

- 0.2:
   + use ace-basic's bas script for the heavy lifting
