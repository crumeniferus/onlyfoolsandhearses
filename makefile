#Makefile to perform software releases.

###
#
# Note that this is in transition from an old scheme that used different directories to reperesent the progression of a project.
# The new scheme is in progress: it makes much more sense to use the branching facilities of Git or different release stages.
# New plan is that there is a "site" folder which contains only the deliverables and not all the macros and text files. 
# For now, the build directory also contains all of those, just because of a lack of mental clarity.
#
###

#Progression is:
#  test->beta->live
#Each stage must be obtained using checkout from Git.
#So far, the automation simply copies deliverables from "build" to the correct place in the "site" directory.
#Later, this makefile will do the whole lot: checkout, call the build makefile, copy from build to site, and finally upload to server.

STAGE_NAMES:=test beta release
BETA_URL:
LIVE_URL:

#Limit what we're interested in. 
SUB_PATHS:=css images js
FILE_TYPES:=html css jpg  js
FILE_SPECS:=*.html css/*.css images/*.jpg js/*.js
file_filter=find $< \( -name *.jpg -o -name *.html -o -name *.js -o -name *.css \) -printf "%P\n"
RSYNCFLAGS:=--verbose --progress --stats  --files-from=-

#local_upstage=$(file_filter) | rsync $(RSYNCFLAGS) $< $@
#remote_upstage=$(file_filter) | rsync $(RSYNCFLAGS) $< $@


# Ready made line for quick copy to command line:
#find release \( -name *.jpg -o -name *.html -o -name *.js -o -name *.css \) -printf "%P\n" | rsync --verbose --progress --stats  --files-from=- release eting_12012984@ftp.etingi.com: 

build :
	@echo Need to call sub-make here.

site : build
	$(file_filter) | rsync $(RSYNCFLAGS) ./$< ./$@
	#$(file_filter) | rsync --progress --stats --files-from=- ./build ./site

release : test

$(filter-out build, $(DEV_STAGE_NAMES)):
	$(local_upstage)
	
