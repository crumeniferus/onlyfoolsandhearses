# Makefile to keep track of which files need processing.
# Designed to work with GnuMake.
# Processing is done in distinct steps.
# Each step has its own sub-directory, numbered to indicate order and named for clarity.
# There is one virtual step which has no real directory: 00-none, which denotes the very begiinning.
# There is one fixed and real step which must always be the last step: 99-complete.
# Each sub-directory has its own list of what needs doing, based on what's missing compared to the previous step. This means that there is not a huge list of every single job that will need doing, just a list of what needs doing to progress to the next step.
# Numbering the directories means a lexical sort can be used to indicate order, which means simple list indexing can automatically derive dependencies.
# Cases where this may produce spurious results are when the original has been processed once and subsequently updated while the previous set of processing is still in place.

# There are some nifty ways to get a makefile to build itself, or at least build an included makefile but here I'm going for an older method where the dependencies are built in a discreet step.

# Variable $(steplist) is ordered ascending so a copy shifted by one will allow join() to produce al list of adjacent steps.
# The list of previous steps must start with the virtual step '00-none' and the final step '99-complete' can not, by definition, be a previous step.
steplist:=$(patsubst %/,%,$(sort $(dir $(wildcard */))))
prev-steplist:= 00-none $(filter-out 99-complete, $(steplist))
dep-steplist:=$(join $(addsuffix :, $(steplist)),$(prev-steplist))

# For the actual rules with real recipies, we don't want anything to rely on '00-none' or its derived files.
# Any items that didn't form a rule should be removed.
stepfile-rulelist:=$(filter-out %:, $(filter-out %00-none, $(dep-steplist)))
stepfile-rulelist:=$(addsuffix .filelist, $(stepfile-rulelist))

all: $(steplist)
	@echo Steps are: $(steplist)
	@echo Prior steps are: $(prev-steplist)
	@echo Inter-step dependencies are: $(dep-steplist)
	@echo Dependencies to be made into actual rules are: $(stepfile-rulelist)

# Use $(dep-stepfilelist) as makefile rules. However, we don't want anything to rely on '00-none.filelist'.
$(foreach filedep, $(stepfile-rulelist), $(eval $(filedep)))

# Make sure no recipes are invoked for the vurtual step "00-none".
00-none:

00-none.%:

$(steplist): %: %.depend
	@echo "$@: $<"

%.depend:
	@echo "Building $@"

%.filelist: %.filelistnew
	# If the filelist did not alrady exist, create it.
	# If the existing and new file lists differ, take the new one.
	@# If the file list did not previously exist and the directory is currently empty, diff will be equal.
	@# For our needs, a non-existant .filelist is the same as an out of date one.
	@# Diff returns:
	@# 	0 no diffs
	@# 	1 some diffs
	@# 	2 error
	@if test ! -f $@ ;\
		then mv $< $@ && echo "Filelist $@ did not exist, creating new." ;\
	elif diff --brief --new-file $@ $< ;\
		then echo "Filelist $@ up to date." ;\
	else mv $< $@ && echo "Filelist $@ outdated, updating.";\
	fi

%.filelistnew: %
	@# Make accepts only a return status of 0 as success.
	@# For us, an empty directory is not a cause for error but ls will return 2 in this case.
	@# Make seems inconsolable over this return status.
	@touch $@
	@-ls -1 $</* > $@ || touch $@
	
	@# Determine the preceding step, and use its file listing. 
	@#@echo Need a listing of $(patsubst $(basename $@):%, %, $(dep-steplist))

