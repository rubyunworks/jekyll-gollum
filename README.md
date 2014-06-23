# [Jekyll Gollum](http://rubyworks.github.com/jekyll-gollum)

**Transform your Gollum Wiki into a Jekyll Website!**

## [About](#about)

Jekyll Gollum allows Jekyll to use a Gollum Wiki as a source for markup
documents in the construction of a website. The documents within the
wiki **do not need YAML front matter**, but can still provide it via
an HTML bottom-comment.

Jekyll Gollum is essentially the same program as [Jekyll Transform](http://github.com/rubyworks/jekyll-transform).
However Jekyll Gollum is begin designed as a superset of it's parent
focused specifically on improved support for transforming Gollum wiki.
Whereas Jekyll Transform is focused on being a vanilla generic tool. 
Ultimately Jekyll Gollum should be but a thin veneer over Jekyll Tranform,
but for now it copies the code whole cloth.


## [Notes](#notes)

I was very hopeful that Jykell 2.0 would make this project all but obsolete.
Unfortunately, no such luck. While Jekyll 2 has added front matter defaults
to the configuration, there still doesn't appear to be any means
of allowing posts and pages to coexist in the same folder. Nor am I sure
that a file without any frontmatter will be processed by Jekyll at all.


## [Usage](#usage)

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


## [Tips](#tips)

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

## Future Plans

There are couple of issues left to address to make Jekyll and truly good
means of generating static sites from Gollum wikis. First and foremost is
support for the markup formats that Gollum supports. There are already a 
few Jekyll plugins that exist to help in this regard. We should just be 
able to add them as a depenedncies and (except for configuration) we should
be good to go.

Another pressing issue is support for drafts. Jekyll expects drafts to be 
int the `_drafts` directly. But obviously, coming from a Gollum site we 
don't have the option.


## [Copyrights](#copyrights)

Copyright (c) 2013 Rubyworks

Jekyll-Gollum is open-source software distributed under the [BSD-2-Clause license](LICENSE.txt).

See LICENSE.txt for details.

