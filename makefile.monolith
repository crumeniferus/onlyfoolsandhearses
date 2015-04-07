#Makefile to perform software releases.

###
#
# Note that this is an old scheme that used different directories to reperesent the progression of a project.
# The new scheme s not even started yet but it makes much more sense to use the branching facilities of Git.
#
###

#Progression is:
#  build->test->release->[public-test | public-live]
#Each stage lives in a directory with that name.
#From here, "make build" moves nothing but runs the building makefile.
#All the other "make <stage>" commands move stuff from the previous stage to the named stage.
#Moving stuff from "test" to "release", for example, must not imply the need to move stuff to "test" first.

DEV_STAGE_NAMES:=build test release
PUBLIC_STAGE_NAMES:=public-test public-live
PUBLIC-TEST_URL:
PUBLIC-LIVE_URL:

#Limit what we're interested in. 
SUB_PATHS:=css images js
FILE_TYPES:=html css jpg  js
FILE_SPECS:=*.html css/*.css images/*.jpg js/*.js
file_filter=find $< \( -name *.jpg -o -name *.html -o -name *.js -o -name *.css \) -printf "%P\n"
RSYNCFLAGS:=--verbose --progress --stats  --files-from=-

local_upstage=$(file_filter) | rsync $(RSYNCFLAGS) $< $@
remote_upstage=$(file_filter) | rsync $(RSYNCFLAGS) $< $@

# Ready nade line for quick copy to command line:
#find release \( -name *.jpg -o -name *.html -o -name *.js -o -name *.css \) -printf "%P\n" | rsync --verbose --progress --stats  --files-from=- release eting_12012984@ftp.etingi.com: 

build :
	@echo Need to call sub-make here.

test : build
release : test
$(filter-out build, $(DEV_STAGE_NAMES)):
	$(local_upstage)
	
$(PUBLIC_STAGE_NAMES):release
