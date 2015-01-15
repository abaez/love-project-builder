Love2D Project Builder
======================
A [Love2D](http://love2d.org/) project builder by [Alejandro Baez](https://twitter.com/a_baez)

## DESCRIPTION
[Love2D](http://love2d.org/) is a great game engine for prototyping and making
games. While there are many IDE and texteditors that have tools for Love2D,
there aren't any project builders that I am aware of.

The purpose of this project builder is to automatically have a set of
configurations for rapid prototyping. Doing more work with less set up.

## DEPENDENCIES

*   [Mercurial](http://mercurial.selenic.com/)

Optional:
*   [LDoc](http://stevedonovan.github.io/ldoc/index.html)
*   [Git](http://www.git-scm.com/)

## INSTALLATION
First make sure you have the [Love2D Project Builder](#) in a local copy.
    hg clone <love-project-builder> <your location>
Next link or copy `love_init` to your `$PATH` like so:
    ln -s <love-builder literal location>/love_init ~/bin/love_init
Next, when you run `love_init` for the first time, it will ask you to use the
`-s` argument parameter if not given. You need to give the source location of
`love-project-builder` like so:
    love_init -s <love-project-builder>
After running the first time, the `-s <src>` argument is optional.
Finally, edit `~/.love.init.conf` key `src` to where you have your src:
    inside (~/.love.init.conf)
    src = "/your/location/for/love-project-builder"

## USAGE
You can run with only the name of the project:
    love_init <name>
You can run with project path destination:
    love_init <name> -p <path>
You can also use your own location for source of `love-project-builder`:
    love_init <name> -s <src>
Note that `love_init` automatically defaults to mercurial. If you want to use
git simply use the `-g` argument.
    love_init <name> -g
Lastly, you can combine commands:
    love_init <name> -p <path> -s <src>
If you have ldoc installed, then when you already have a project you can run
`ldoc .` to build api documentation.

