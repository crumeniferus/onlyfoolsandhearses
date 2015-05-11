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
dependfile-list:=$(addsuffix .depend,$(wordlist 2,$(words $(steplist)),$(steplist)))
prev-filelist:=$(addsuffix .filelist, $(filter-out 99-complete,$(steplist)))
stepfile-rulelist:=$(join $(addsuffix :,$(dependfile-list)),$(prev-filelist))

target-step=$(basename $@)
pre-req-step=$(basename $<)

target-part=$(firstword $(subst :, ,$(1)))
prereq-part=$(lastword $(subst :, ,$(1)))

# The to-do recipe is to be copied verbatim, no expansions into the dependency file so that it becomes the actual recipe used after 'include'.
todo-recipe := echo $$@ to be made from $$< >> $$(@D).todo

define depend-template =
$(1):$(2)
	@# Translate initial contents of dependency list into 'make' dependencies.
	@# Extract basename of first parameter to know target directory.
	@# Split each line on the directory separator and re-assemble to create a rule of the form:
	@#	target_step/file_name_at_previous_step:previous_step/file_name_at_previous_step
	$(warning Target is $(1), Pre-requisite is $(2))
	@cp $$< $$@
	sed --in-place 's/^\(.*\)\/\(.*\)/$(basename $(1))\/\2:\1\/\2/' $(1)
	sed --in-place 'a\\	$$(todo-recipe)\n' $(1)
	@#cp $(1) $(addsuffix .goallist, $(basename $(1)))
	sed -e 's/\(^[^:]*\):.*/\1/' -e '/^\t.*/ d' -e '/^$$$$/ d' < $(1) >> $(addsuffix .goallist, $(basename $(1)))

GOALLISTFILE=$(basename $(1)).goallist
$(info GOALLISTFILE is $(GOALLISTFILE))
$(info Checking existence of $(GOALLISTFILE) using wildcard macro:$(wildcard $(basename $(1)).goallist))

$$(info Checking $(basename $(1)).goallist)
ifneq ($(wildcard $(basename $(1)).goallist),)
TODO_DEPEND_FINE=$(basename $(1)).todo: $(shell cat $(basename $(1)).goallist)
endif
$$(warning About to evaluate '$(TODO_DEPEND_FINE)'.)
ifdef TODO_DEPEND_FINE
$$(eval $(TODO_DEPEND_FINE))
else
$$(info Didn't eval an empty string.)
endif

#include $(1)

endef

all: $(steplist).todo
	@echo Steps are: $(steplist)
	@echo Prior steps are: $(prev-steplist)
	@echo Inter-step dependencies are: $(dep-steplist)
	@echo Depend files are: $(dependfile-list)
	@echo Pre-requisite filelists are: $(prev-filelist)
	@echo Dependencies to be made into actual rules are: $(stepfile-rulelist)

# Use $(stepfile-rulelist) as makefile rules.
$(foreach filedep, $(stepfile-rulelist), $(eval $(call depend-template,$(call target-part,$(filedep)) $(call prereq-part,$(filedep)))))

# Make sure no recipes are invoked for the virtual step "00-none".
00-none:

00-none.%:

#include *.depend

#$(filter-out 10-original, $(steplist)): %: %.todo
#	@echo "$@: $<"

%.todo: %/
	@echo "$@: $<"

%.filelist: %.filelistnew
	@# If the filelist did not already exist, create it.
	@# If the existing and new file lists differ, take the new one.
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

%.filelistnew:
	@# Make accepts only a return status of 0 as success.
	@# For us, an empty directory is not a cause for error but ls will return 2 in this case.
	@# Make seems inconsolable over this return status.
	@touch $@
	@-ls -1a $(*F)/* > $@ || touch $@
	
	@# Determine the preceding step, and use its file listing. 
	@#@echo Need a listing of $(patsubst $(basename $@):%, %, $(dep-steplist))

.PHONY: clean
clean:
	-rm -f *.filelist *.todo *.depend *.goallist
