# Makefile to keep track of which files need processing.
# Processing is done in distinct steps.
# Each step has its own sub-directory, numbered to indicate order and named for clarity.
# Each sub-directory has its own list of what needs doing, based on what's missing compared to the previous step. This means that there is not a huge list of every single job that will need doing, just a list of what needs doing to prgress to the next step.
# Numbering the directories means a lexical sort can be used to indicate order, which means simple list indexing can automatically derive dependencies.
# Cases where this may produce spurious results are when the original has been processed once and subsequently updated while the previous set of processing is still in place.

# There are some nifty ways to get a makefile to build itself, or at least build an included amkefile but here I'm going for an older method where the dependencies are built in a discreet step.

steplist:=$(patsubst %/,%,$(sort $(dir $(wildcard */))))
prev-steplist:= 00-none $(steplist)
dep-steplist:=$(join $(steplist),$(prev-steplist))

all: $(steplist)
	@echo $(steplist)
	@echo $(prev-steplist)
	@echo $(dep-steplist)

$(steplist): %: %.depend
	@echo "$@: $<"

%.depend:
	@echo "Building $@"
	# Variable $(steplist) is ordered ascending so a copy shifted by one will allow join() to produce the two adjacent steps.
	# Create pre-requisite step list by shifting $(steplist) right, inserting null at the beginning.
