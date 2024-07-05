# Jekyll::Cover

👋 Howdy! Welcome to the `v 0.1.0` of `Jekyll::Cover`, a custom command to build `og:image` for new posts through the command line.

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

## Disclaimer

⚠️ I built this gem is for my personal use and on my personal time, hence it's **very crude, untested**, and **only works for the quirks of my own website**. 

I'll probably make it more usable for others in the future, but for now, it's mostly a personal proof of concept.

## Shout out

The idea for building a gem was born from my own itch ("How can I generate posts' cover images with a Jekyll command?") and from reading [Rebuilding Rails](https://rebuilding-rails.com/) by Noah Gibbs.
