# Hyde

## Transform Your Wiki into a Jykell site


## About

Hyde will transform your Gollum wiki into a Jykell site.


## Usage

You should first layout your Jekyll site according to its documentation.
When that is in place then you can initialize Hyde with the URL of
your wiki's git repository. First `cd` into you site directory, then:

    $ hyde init git@github.com:rubyworks/smeagol.wiki.git

This will clone the repository to the `_wiki` directory and will
also add `_wiki/` to your `.gitignore` file if one exists.

With the wiki cloned you can now transfor it into a Jykell site with:

    $ hyde trans

By default Hyde uses whatever branch, tag or reference point the wiki
repository happens to have checked out. If you wish to use a specific
branch, tag or reference point, add it to the command. E.g.

    $ hyde trans v1308

Note, the current repo needs to be in a clean state for this to work.

If you you are using your wiki as the main source of content for your
site you can use the `--sync` opition to ensure correspondance between
the site and the wiki. This will prevent any possibility of duplication
when a wiki file is renamed. But you must be careful with it b/c it
will delete any site file that has not been specifically configured to
be preserved via `.hydeignore`.


## Caveats

Hyde is *very* simplistic at this point. If simply copies the files
to the appropriate places in the Jykell's site according to some basic
critera. That's it. This means if you have renamed a file in the wiki
you also need to delete that file from the site directory.

In the future we hope to make it a bit more intelligent. For instance, 
it would be nice if can look at the changes made to the wiki and ascertain
when files have been renamed.


## Copyrights

Copyright (c) 2013 Rubyworks

Hyde is open-source software distributed under the BSD-2-Clause license.

See LICENSE.txt for details.





