#Makefile to perform software releases.

###
#
# The scheme is to use the branching facilities of Git for different release stages.
# There is a "site" folder which contains only the deliverables, excluding the macros and text files. 
# For now, the "build" directory contains everything mingled, just because of a lack of mental clarity.
#
###

#Progression of release is:
#  devel->beta->live
#Each stage must be obtained using checkout from Git.
#The user must know which stage is currently checked out and use the correct input to make, otherwise you end up with the wrong deliverables.
#Ideally, the makefile will determine the current stage for itself. A later development.
#Here are the steps that this makefile will take to get a stage out into the wild.
# Step				Progress
# Checkout
# Call the build makefile	Done
# Copy from build to site	Done
# Upload to server		Done

# Process within each stage is:
#   make build - derive HTML files from sources.
#   make site  - filter out the deliverables into one place.
# Usually, once 'make build' and 'make site' are run for devel, there is no need to run them again on downstream stages.
# Also, the target "build" is a pre-requisite of target "site", which in turn is a pre-requisite of all the uploading targets. This should ensure that the uploaded files really are the result of the present source files.

# Uploading to beta could be better but uploading to live depends on having an approved SSH key on the server.

STAGE_NAMES:=devel beta live
BETA_URL=ftp://b6_14967648:C43353M315T3R@ftp.byethost6.com/ofah.byethost6.com/htdocs/
LIVE_URL=crumeniferus@crumeniferus.co.uk:public_html/onlyfoolsandhearsesdorset.co.uk/

#Limit what we're interested in. 
SUB_PATHS:=css images js
FILE_TYPES:=html css jpg js png svg
FILE_SPECS:=*.html css/*.css images/*.jpg images/*.png images/*.svg js/*.js
file_filter=find $< \( -name *.jpg -o -name *.png -o -name *.svg -o -name *.html -o -name *.js -o -name *.css \) -printf "%P\n"

RSYNCFLAGS_GENERAL:=--recursive --verbose --times --progress --stats
RSYNCFLAGS_MIRROR:=--ignore-times --delete
RSYNCFLAGS_SELECTIVE:=--files-from=-
#RSYNCFLAGS_DEBUG:=--dry-run
RSYNCFLAGS_DEBUG:=

#WPUTDEBUGFLAGS:=--verbose --verbose --output-file=wput-log
WPUTDEBUGFLAGS:=
WPUTFLAGS:=--reupload --dont-continue

# Ready made line for quick copy to command line:
#find release \( -name *.jpg -o -name *.html -o -name *.js -o -name *.css \) -printf "%P\n" | rsync --verbose --progress --stats  --files-from=- release eting_12012984@ftp.etingi.com: 

FORCE :

build : FORCE
	# There is a directory called build so using that name as a phony wouldn't work.
	# Deciding whether to do any actual building or not is the purpose of the sub-make so we must always call it if we need to check the build is up to date.
	@echo Need to call sub-make here.
	cd build && $(MAKE)

site : build
	$(file_filter) | rsync $(RSYNCFLAGS_DEBUG) $(RSYNCFLAGS_GENERAL) $(RSYNCFLAGS_MIRROR) $(RSYNCFLAGS_SELECTIVE) ./$< ./$@

upload-beta : UPLOAD_DEST=$(BETA_URL)
upload-beta : wput-upload

upload-live : UPLOAD_DEST=$(LIVE_URL)
upload-live : RSYNCFLAGS=$(RSYNCFLAGS_GENERAL) $(RSYNCFLAGS_MIRROR)
upload-live : rsync-upload

wput-upload : site
	@#wput returns a few different status values:
	@# 0 - All okay or nothing to do.
	@# 1 - Some files skipped due to size or timestamp checks that decided no transmission was required.
	@# 2 - Error at the remote end.
	@# 3 - Combination of 1 and 2.
	@# 4 - Local error.
	@#For our purposes, exit values 0 and 1 are a success but make considers only 0 to be a success.
	@#No additional warning messages are needed on top of those already supplied by wput.
	wput $(WPUTDEBUGFLAGS) $(WPUTFLAGS) --basename=./site/ ./site $(UPLOAD_DEST) || (if [ $$? = 1 ]; then exit 0; fi)

rsync-upload : site
	rsync $(RSYNCFLAGS_DEBUG) $(RSYNCFLAGS) ./site/ $(UPLOAD_DEST)
