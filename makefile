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
#  devel->beta->live
#Each stage must be obtained using checkout from Git.
#The user must know which stage is currently checked out and use the correct input to make, otherwise you end up with the wrong deliverables.
#Ideally, the makefile will determine the current stage for itself. A later development.
#Here are the steps that this makefile will take to get a stage out into the wild.
# Step				Progress
# Checkout
# Call the build makefile
# Copy from build to site	Done
# Upload to server		Done

STAGE_NAMES:=devel beta live
BETA_URL=ftp://b6_14967648:C43353M315T3R@ftp.byethost6.com/ofah.byethost6.com/htdocs/
LIVE_URL:

#Limit what we're interested in. 
SUB_PATHS:=css images js
FILE_TYPES:=html css jpg js
FILE_SPECS:=*.html css/*.css images/*.jpg js/*.js
file_filter=find $< \( -name *.jpg -o -name *.html -o -name *.js -o -name *.css \) -printf "%P\n"
RSYNCFLAGS:=--verbose --progress --stats  --files-from=-

#local_upstage=$(file_filter) | rsync $(RSYNCFLAGS) $< $@
#remote_upstage=$(file_filter) | rsync $(RSYNCFLAGS) $< $@


# Ready made line for quick copy to command line:
#find release \( -name *.jpg -o -name *.html -o -name *.js -o -name *.css \) -printf "%P\n" | rsync --verbose --progress --stats  --files-from=- release eting_12012984@ftp.etingi.com: 

build :
	@echo Need to call sub-make here.
	#cd build && $(MAKE)

site : build
	$(file_filter) | rsync $(RSYNCFLAGS) ./$< ./$@

upload-beta : upload
	UPLOAD_DEST=$(BETA_URL)

upload-live : upload
	UPLOAD_DEST=$(LIVE_URL)

upload : site
	#We only have beta right now so assume beta. Really must find a way to check for the right stage.
	#wput returns a few different status values:
	# 0 - All okay or nothing to do.
	# 1 - Some files skipped due to size or timestamp checks that decided no trasnamission was required.
	# 2 - Error at the remote end.
	# 3 - Combination of 1 and 2.
	# 4 - Local error.
	#For our purposes, exit values 0 and 1 are a success but make considers only 0 to be a success.
	#No additional warning messages are needed on top of those already supplied by wput.
	wput --basename=./site/ ./site $(BETA_URL) || (if [ $$? = 1 ]; then exit 0; fi)

$(filter-out build, $(DEV_STAGE_NAMES)):
	$(local_upstage)
	
