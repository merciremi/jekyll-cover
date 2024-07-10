# Jekyll::Cover

👋 Howdy! Welcome to the `v 0.2.0` of `Jekyll::Cover`, a custom command to build `og:image` for new posts through the command line.

## Why?

I did not want to open Figma anymore, and decided that running something like `jekyll cover --path /path/to/my/post/` would be faster! And building the gem would be more fun.

## What?

Here's a sample of an image built with `Jekyll::Cover`. 

![remi-mercier-add-comments-to-your-tables-columns](https://github.com/merciremi/jekyll-cover/assets/15021685/8e8ccde3-1ead-4bbe-a7fb-2ecf684d8099)

This picture is a mix of `rmagick` canvas and image manipulation, a couple of `.png`s stored on my website (namely the picture of my face, and the hand-drawn mountain), and the text is extracted from the post's front matter.

## How?

This gem does a few things: 
- takes a path as argument,
- parse the relevant post for necessary information such as a title, a date, etc...
- build an image from scratch through a mix of instructions and images w/ `rmagick`,
- build the folder structure if need be to store the image,
- add the path of the new image to the post.

## Usage

Want to use `Jekyll::Cover` with your Jekyll blog? Here how to do it:

1) Read the Disclaimers section below: the gem is as of now, only a proof-of-concept. Be aware of its shortcomings.
2) Fork the gem and clone the gem on your local machine.
3) Add the gem to your gemfile

```
group :jekyll_plugins do
  gem 'jekyll-cover', git: 'https://github.com/your_username/jekyll-cover.git', branch: 'main'
end
```

4) Run `bundle install`
5) You can use the `jekyll cover` command! ✨

```
  bundle exec jekyll cover -p _posts/path-to-your-new-post.md
```

6) Check your setup or change the gem's code accordingly

- Your posts front matter should have a `cover_image` variable.
- Your images should be stored in a `/media` folder.
- Check the `Jekyll::Cover::CoverImage::CATEGORIES_DECORS` constant: those are files I use to decorate my cover image based on the post category. You should change those.
- Check the `Jekyll::Cover::FrontMatter::DEFAULT_VARIABLES` constant. You might want to change its content.

## Disclaimers

⚠️ I built this gem is for my personal use and on my personal time, hence it's **very crude, untested**, and **only works for the quirks of my own website**.

I'll probably make it more usable for others in the future, but for now, it's mostly a personal proof of concept.

**Update 10 Jul 2024: `V 0.2.0` is out!**

`V 0.2.0` does exactly the same thing as v0.1.0, but better 😜: 
- cleaner abstractions w/ cleaner APIs
- better validations and return errors: Is your command valid? Do you already have an image linked to your post? etc...
- less resource intensive for generating the image.

Still a lot of rough edges, but I'm happy to move toward a more flexible command that'll eventually allow other people to use the gem off the shelf.

## Shout out

The idea for building a gem was born from my own itch ("How can I generate posts' cover images with a Jekyll command?") and from reading [Rebuilding Rails](https://rebuilding-rails.com/) by Noah Gibbs.
