# Create various image sizes from originals.
#
# Usage:
#   make [<size_name>]
# where size_name is one of icons, thumbs, article, medium, large, slideshow or all. 
# If size_name is omitted, the default size set by variables _width and _height is used.
#
# The resize option passed to the convert command is currently the best option for the intended purpose. This preserves the original proportions of the original and ensures that the resized image fits entirely within a frame of the requested size. A web site design that uses frames the same size as these preset sizes will allow the browser to render the images without it having to calculate any image scaling. This can be an advantage on bandwidth- or power-limited platforms.
# Where an original is an SVG, there is no real need to rescale, though it may help with some aspects of programming if there is a file of the required name and path.
# There are some aspects of browser rendering that do not play nicely (if at all) with SVG so there still needs to be a scaled PNG of that original vector image. This will lead to conflict if there are two different images with the same base name but different extensions.
#
# We don't know ahead of time what all the image names will be.
# We will use the same image name in each folder. This may lead to some confusion but it can also be easier for selecting image sizes.
#
# These make rules will determine the names of the targets by looking at the names of the sources (prerequisites).
#
# It could be better to use the batch processing power of ImageMagick as that could save on overheads but my make skills are very basic.
# Also, is it actually a problem right now that can not be fixed later without great expense, and is there evidence to prove that in these circumstances there is a tangible benefit to batching? 
#
# This makefile was originally written for a Windows platform. That turned out to be a lot of pain despite the efforts of Cygwin and GnuWin32.
# Even so, the Windows path is here just in case the need arises. There is some merit in having the makefile determine the platform automatically but, as I am a lone coder, there is only a small chance of conflict.
# Besides this path, change the slash substitution in the "convert" command line.
#CONVERT=C:\Program Files\ImageMagick-6.8.0-Q16\convert
CONVERT=convert
CONVERT_COMMONFLAGS= 
CONVERT_SIZEFLAGS=-resize
CONVERT_COLOURFLAGS=-background transparent

_width=70
_height=50
icons_width=18
icons_height=18
thumbs_width=83
thumbs_height=55
article_width=320
article_height=240
medium_width=640
medium_height=480
large_width=1600
large_height=1200
slideshow_width=760
slideshow_height=280

image_size=icons thumbs article medium large slideshow

.PHONY : all $(image_size)

.SECONDEXPANSION:

all:$(image_size)

# The filter at the end of the pre-requisites construction could do with being more generic.
# This would mean the targets for the conversion are extension-specific and a catch-all rule at the end will be required.
# Images of type JPG and PNG are scaled to the same format.
# Images of type SVG in theory need no scaling but browser limitations noted above make a bitmap necessary. Here we provide only the PNG format of scaled SVG images.
$(image_size):$$(patsubst originals/%,$$@/%,$$(wildcard originals/*.jpg))
$(image_size):$$(patsubst originals/%,$$@/%,$$(wildcard originals/*.png))
$(image_size):$$(patsubst originals/%,$$@/%,$$(wildcard originals/*.svg))

#Definitely can not generate originals from anything else so make this bit a final rule (double colon).
#There is the potential for programmatically generated images but that's not today's requirement.
%.jpg %.png:: originals/$$(@F)
	$(CONVERT) $< $(CONVERT_COMMONFLAGS) $(CONVERT_SIZEFLAGS) $($(@D)_width)x$($(@D)_height) $@
#	$(CONVERT) $(subst /,\\,$^) $(CONVERT_COMMONFLAGS) $(CONVERT_SIZEFLAGS) $($(@D)_width)x$($(@D)_height) $(subst /,\\,$@)

# The next rule may cause problems when auto-generated SVG's are required, but for now it seems like a handy way to distinguish between target PNG's derived from PNG's and target PNGs derived from SVG's. Auto-generated SVG's are probably better dealt with in a separate makefile.
# There will be an SVG file in each of the image_size directories but it is of zero size and used only for dependency checks. 
# By making this a double-colon rule, the other %.png rule is not triggered.
%.svg:: originals/$$(@F)
	$(CONVERT) $(CONVERT_COMMONFLAGS) $(CONVERT_SIZEFLAGS) $($(@D)_width)x$($(@D)_height) $(CONVERT_COLOURFLAGS) $< $(addsuffix .png,$(basename $@))
	touch $@


# Need a catch-all rule to catch files whose extansion doesn't match any of the above targets.
# For now, the filter that creates the pre-requisites of the image_size rule has been narrowed.
