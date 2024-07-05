# Jekyll::Cover

👋 Howdy! Welcome to the `v 0.1.0` of `Jekyll::Cover`, a custom command to build `og:image` for new posts through the command line.

## Why?

I did not want to open Figma anymore, and decided that runing something like `jekyll cover --path /path/to/my/post/` would be faster! And building the gem would be more fun.

## How

This gem does a few things: 
- takes a path as argument,
- parse the relevant post for necessary information such as a title, a date, etc...
- build an image from scratch through a mix of instructions and images w/ `rmagick`,
- build the folder structure if need be to store the image,
- add the path of the new image to the post.

## Disclaimer

⚠️ I built this gem is for my personal use and on my personal time, hence it's **very crude, untested**, and **only works for the quirks of my own website**. 

I'll probably make it more usable for others in the future, but for now, it's mostly a personal proof of concept.
