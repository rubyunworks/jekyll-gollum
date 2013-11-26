# Jekyll Gollum

**Transform your Gollum Wiki into a Jekyll Website!**

## About

Jekyll Gollum allows Jekyll to use a Gollum Wiki as a source for markup
documents in the construction of a website. The documents within the
wiki **do not need YAML front matter**, but can still provide it via
an HTML bottom-comment.


## Usage

Jekyll Gollum works as a Jekyll plugin.

You first need to have a Jekyll setup in accordance with Jekyll's specification.
With a Jekyll site in place you simply need to add a `gollum.rb` file (or other
such file) to your site's `_plugins` directory containing:

    require `jekyll-gollum'

Then in your `_config.yml` file add:

    gollum:
      folder: '_wiki'
      page_yaml:
        layout: page
      post_yaml:
        layout: post

Change the confgiuration to meet your needs. The `folder` settings
tells it where to find the wiki files to be transformed. By default this
is `_wiki`. You Gollum wiki should be cloned to this directory, and
`_wiki/` added to your `.gitignore`. The `page_yaml` and `post_yaml`
entries specify the default YAML front-matter to add to pages and
posts respectively. If not given the defaults are as shown as above,
`page` and `post`.

Jekyll-Gollum distinguishes posts from pages simply and soley by the
name of the wiki file starting with a date. It does not matter where the
file are located in the directory. Post will be placed in the accordance
to the post slug, while pages will keep their relative paths.

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

### How does Jekyll Gollum compare to Smeagol?

Smeagol is, first and foremost, a Rack-based service for serving up a Gollum
wiki as a customize website. New versions of Smeagol do include a static
site generator, but its generation features aren't as polished as
Jekyll's. On the other hand, Smeagol does supports all markup languages
that Gollum supports and more faithly renders them in the same manner as
Gollum (because in most cases it passes the chore off to Gollum).
Bottom line? Use Jekyll Gollum to gain all the benefits of Jekyll. If you
don't need those, Smeagol may be a better choice.

## Copyrights

Copyright (c) 2013 Rubyworks

Hyde is open-source software distributed under the BSD-2-Clause license.

See LICENSE.txt for details.

