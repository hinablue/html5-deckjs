Requirements
============

1. git
2. ruby
3. sass
4. compass

One Step Install (Do you trust me?)
------------------------------------
command::

    $ wget --no-check-certificate https://github.com/hinablue/html5-deckjs/raw/master/install.sh -O - | sh

The manual way to install pct.vim
----------------------------------
1. clone to your home directory::

    $ git clone git://github.com/hinablue/html5-deckjs.git

2. update submodule in html5-deckjs::

    $ cd html5-deckjs; ./update.sh; cd -

How to update
-------------
::

    $ cd html5-deckjs
    $ git pull; ./update.sh

How to generator presentation layout
------------------------------------
::

    $ cd html5-deckjs
    $ ./html5-deckjs.sh
    To create a new project, enter a new directory name:
    _

Type your project name, and wait, and all done.

Where is the layout files
-------------------------
The parent directory of the html5-deckjs, named by your project name.
