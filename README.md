# Jekyll Transform

**Transform your documents into a Jekyll site!**

## About

Jekyll Transform allows Jekyll to use any directory as a source for markup
documents in the construction of a website. The documents within the
directory **do not need YAML front matter**. A good example how this can be
useful is taking a Gollum wiki and using its contents for the creation of
a custom website.


## Usage

Jekyll Transform works as a Jekyll plugin.

You first need to have a Jekyll setup in accordance with Jekyll's specification.
With a Jekyll site in place you simply need to add a `transform.rb` file to
your site's `_plugins` directory containing:

    require `jekyll-transform'

Then in your `_config.yml` file add:

    transform:
      folder: '_wiki'
      page_yaml:
        layout: page
      post_yaml:
        layout: post

Change the confgiuration to meet your needs. The `folder` settings
tells it where to find the files to be transformed. In our example
we use `_wiki` because we want to it to contain a cloned Gollum wiki
repository. If no entry is given the default is `_trans`. The `page_yaml`
and `post_yaml` entries specify the YAML front matter to add to pages
and posts respecively. If not given the defaults are as shown above,
`page` and `post`.

Jekyll transform distinguishes posts from pages simply soley by the name
of the file starting with a date. It does not matter where they are located
in the directory. And pages will keep their relative paths.

Drafts are not yet supported, but that will be added in future release.
In the mean time you can still set `future: false` and date your drafts
far in the future.


## Tips

### Is it possible to customize files individually?

If your documents can contain HTML style comments then you can add YAML
matter to the bottom of the document. For instance, perhaps specfic
documents require a `speical` layout. Adding the following to the bottom
of the document will allow Jekyll to use it as the documents YAML front
matter.

```html
    <!--- ---
    layout: special
    --->
```

In the future we might allow YAML front matter to be set via glob matches
in the _config.yml, if there are requests for the feature.

### How does Jekyll Transfrom compare to Smeagol?

Smeagol is a little different in that it is specifcally designed for use
with Gollum wikis. It is also, first and foremost, a Rack-based service
for serving up a Gollum wiki as a customize website. New versions do include 
a static site generator, but its generation features aren't as polished as
Jekyll's. On the other hand, Smeagol does supports all markup languages
that Gollum supports and more faithly renders them in the same manner as
Gollum (because it in most cases it passes the chore off to Gollum).


## Copyrights

Copyright (c) 2013 Rubyworks

Hyde is open-source software distributed under the BSD-2-Clause license.

See LICENSE.txt for details.





