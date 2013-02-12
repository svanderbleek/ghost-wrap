# Lil GhostWrap Lib

Wraps PDF data in Tempfiles and can join with other GhostWraps or split
GhostWrap into image page files using GhostScript behind the scenes. 
You must call the clean method to remove the temporary files. Not 
designed to be operated on after a clean but does allow for clean 
to be called multiple times.

## Examples

```ruby
ghost_wrap = GhostWrap.new(pdf_data)

joined_data = ghost_wrap.join(other_ghost_wrap).data

image_page_files = ghost_wrap.page_files

ghost_wrap.clean
```

## Configuration

GhostWrap::TEMPDIR is the location of you temporary directory.
