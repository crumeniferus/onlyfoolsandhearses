# This workflow is represented by a simple category/strategy/queue approach.
# Each step in the process is represented by a queue.
# Each queue is a directory and the files within it represent the cases in that queue.
# Queues are sequential and a case can not be in two queues at once.
# When a case is in a queue, it is still waiting to be serviced.
# When a case has been processed in the queue, it is moved to the next queue.
# This particular process is a series of manual tasks: image editing.
# Moving a worked case to the next queue is a manual process performed when the image editor has finished the edits required in that queue.
# In most file systems, the timestamp of each queue directory will be equal to that of the newest case file.
#
# In addition to the strategy-specific queues are four standard silos: inputs, outputs, done and rejects.
# These are to help move cases from strategy to strategy so that there are some key fixed elements.
# Here is their intended use:
# inputs
#   Ordinarily, one can expect each strategy to move any files from the inputs silo to the first queue immediately.
# outputs
#   Files created by a queue that are not the case file itself.
# done
#   Case files that have run the complete set of queues without incident.
# rejects
#   Case files that failed a test in one of the queues.
#
# Important caveats:
#  Queue directories must be named with a 2-digit number at the beginning. The number indicates order of processing.
#  The image editing tool is GIMP and the undo history is preserved in the XCF file. If another image editing tool is used, these features must be considered.
#  If an image has to be, for example, re-cropped, the file is moved to the necessary directory and the operator uses their personal skill and judgement to re-crop while preserving as much as appropriate and possible of the other edits.
#  Case files can not begin with a dot. This is the name format conventionally used for hidden files and is used in this process for files that are part of the mechanism.
#
# End goals of this makefile are:
#  A single to-do list of what has to be done to advance each case to the next queue.
#  A special file in each silo to ensure that even empty ones remain in Git's repository.
#


QUEUES:=$(shell find . -path "./[0-9][0-9]*" -type d -printf "%P\n" | sort)
FIRST-QUEUE:=$(firstword $(QUEUES))
FIXED-SILOS:=inputs outputs done rejects
ALL-SILOS:=$(QUEUES) $(FIXED-SILOS)
TO-DO-FILE:=process.todo
GITSAFE-FILE:=.gitkeep

.PHONY: all bootstrap to-do clean gitsafe FORCE

all: bootstrap to-do gitsafe

bootstrap:
	$(info Moving all new input files to the first queue.)
	@find ./inputs ! -name $(GITSAFE-FILE) -type f -exec mv '{}' '$(FIRST-QUEUE)' ';'

to-do: $(TO-DO-FILE)

$(TO-DO-FILE): $(QUEUES)
	$(info Queues found are $(QUEUES))
	@echo "# Cases ordered oldest first" > $@
	@find . -path "./[0-9][0-9]*" ! -name ".*" -type f -printf "%T+ %P\n" | sort | cut -d\  -f2 >> $@

gitsafe: $(addsuffix /$(GITSAFE-FILE), $(ALL-SILOS))

%/$(GITSAFE-FILE):
	$(info Creating missing dummy file $@ to preserve empty queue in Git.)
	@touch $@

clean:
	rm -f $(TO-DO-FILE)

FORCE:

