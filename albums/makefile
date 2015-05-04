# Makefile to keep track of which files need processing.
# Designed to work with GnuMake.
# Processing is done in distinct steps.
# Each step has its own sub-directory, numbered to indicate order and named for clarity.
# There are two virtual steps which have no real directory: 00-none and 99-complete, which denote the very begiinning and very end, respectively.
# Each sub-directory has its own list of what needs doing, based on what's missing compared to the previous step. This means that there is not a huge list of every single job that will need doing, just a list of what needs doing to progress to the next step.
# Numbering the directories means a lexical sort can be used to indicate order, which means simple list indexing can automatically derive dependencies.
# Cases where this may produce spurious results are when the original has been processed once and subsequently updated while the previous set of processing is still in place.

# There are some nifty ways to get a makefile to build itself, or at least build an included makefile but here I'm going for an older method where the dependencies are built in a discreet step.

# Variable $(steplist) is ordered ascending so a copy shifted by one will allow join() to produce al list of adjacent steps.
# Create pre-requisite step list by shifting $(steplist) right, inserting null at the beginning.
steplist:=$(patsubst %/,%,$(sort $(dir $(wildcard */))))
prev-steplist:= 00-none $(steplist)
dep-steplist:=$(join $(addsuffix :, $(steplist) 99-complete),$(prev-steplist))
dep-stepfilelist:=$(addsuffix .filelist, $(dep-steplist))

all: $(steplist)
	@echo Steps are: $(steplist)
	@echo Prior steps are: $(prev-steplist)
	@echo Inter-step dependencies are: $(dep-steplist)
	@echo Step file dependencies are: $(dep-stepfilelist)

00-none:

$(steplist): %: %.depend
	@echo "$@: $<"

%.depend:
	@echo "Building $@"

%.filelist: %.filelistnew
	# If the existing and new file lists differ, take the new one.
	@# For our needs, a non-existant .filelist is the same as an out of date one.
	@# Diff returns:
	@# 	0 no diffs
	@# 	1 some diffs
	@# 	2 error
	@diff --brief --new-file $@ $< || mv $< $@

%.filelistnew: %
	@ls -1 $</* > $@
	
	@# Determine the preceding step, and use its file listing. 
	@#@echo Need a listing of $(patsubst $(basename $@):%, %, $(dep-steplist))

