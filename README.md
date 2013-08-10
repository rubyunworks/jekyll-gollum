# Jekyll Transform

**Transform your documents into a Jekyll site!**

## About

Jekyll Transform allows Jekyll to use any directory as a source of markup
documents in the construction of a Jekyll site. The documents with the
directory do not need YAML front matter. A good example how this can be
useful is in taking a Gollum wiki and using its contants for create a Jekyll
web-site.


## Usage

Jekyll Transform works as a Jekyll plugin.

You first need to have a Jekyll setup in accordance with Jekyll's specification.
With a Jekyll site in place you simply need to add a `transform.rb` file to
your site's `_plugins` directory containing:

    require `jekyll-transform'

Then in you `_config.yml` file add:

    transform:
      folder: '_wiki'
      page_yaml:
        layout: page
      post_yaml:
        layout: post

Change the confgiuration to meet your needs. The `folder` settings
tells it where to find the files to be transformed. In our example
we use `_wiki` because we want to it to contain a cloned Gollum wiki
repository. If not given the default is `_trans`. The `page_yaml`
and `post_yaml` entries specify the YAML front matter to add to pages
and posts respecively. If not given the default is `layout: default`.

Jekyll transform distinguishes posts from pages simply the the name of
the file starting with a date. It does not matter where they are located
in the directory. Pages will keep their relative paths.


## Copyrights

Copyright (c) 2013 Rubyworks

Hyde is open-source software distributed under the BSD-2-Clause license.

See LICENSE.txt for details.





