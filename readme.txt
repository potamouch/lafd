This package contains the data files of the quest Zelda: Link's Awakening: Forever in a Day.
This quest is a free, open-source game that works with Solarus,
an open-source Zelda-like 2D game engine.
To play this game, you need Solarus.
We assume in this readme that Solarus is already installed.

See our development blog (http://www.solarus-engine.org) to get more
information and documentation about Solarus and our games.


--------
Contents
--------

1  Play directly
2  Installation instructions
  2.1  Default settings
  2.2  Change the install directory


----------------
1  Play directly
----------------

You need to specify to the solarus binary the path of the quest data files to
use.
solarus accepts two forms of quest paths:
- a directory having a subdirectory named "data" with all data inside,
- a directory having an archive "data.solarus" with all data inside.

Thus, to run lafd, if the current directory is the one that
contains the "data" subdirectory (and this readme), you can type

$ solarus .

or without arguments:

$ solarus

if solarus was compiled with the default quest set to ".".


--------------------
2  Install the quest
--------------------


2.1  Default settings
----------------------

If you want to install lafd, cmake and zip are recommended.
Just type

$ cmake .
$ make

This generates the "data.solarus" archive that contains all data files
of the quest. You can then install it with

# make install

This installs the following files (assuming that the install directory
is /usr/local):
- the quest data archive ("data.solarus") in /usr/local/share/solarus/lafd/
- a script called "lafd" in /usr/local/bin/

The lafd script launches solarus with the appropriate command-line argument
to specify the quest path.
This means that you can launch the lafd quest with the command:

$ lafd

which is equivalent to:

$ solarus /usr/local/share/solarus/lafd


3.2  Change the install directory
---------------------------------

You may want to install lafd in another directory
(e.g. so that no root access is necessary). You can specify this directory
as a parameter of cmake:

$ cmake -D CMAKE_INSTALL_PREFIX=/home/your_directory .
$ make
$ make install

This installs the files described above, with the
/usr/local prefix replaced by the one you specified.
The script generated runs solarus with the appropriate quest path.


Step Quest

MAIN_QUEST_STEP

0 - Initial state
1 - Link is awake
2 - Link has his schield
3 - Link search his sword
4 - Link has his sword
5 - Tarin is saved
6 - Dungeon 1 key is retrieved
7 - Dungeon 1 is opened
8 - Dungeon 1 is resolved
9 - Bow wow is kidnapped
10 - Bow wow is saved
11 - Dungeon 2 is resolved
12 - Bow wow is returned to Mme miaou miaou
13 - Golden leaves quest is started
14 - Golden leaves quest are founded
15 - Dungeon 3 key is retrieved
16 - Dungeon 3 is opened
17 - Dungeon 3 is resolved
18 - Dream fish ballad is learned
19 - The walrus is revealed
20 - The Sand Snake is killed
21 - Dungeon 4 key is retrieved
22 - Dungeon 4 is opened
23 - Dungeon 4 is resolved


