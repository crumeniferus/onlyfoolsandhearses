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
# Important caveats:
#  The image editing tool is GIMP and the undo history is preserved in the XCF file.If another image editing tool is used, these features must be considered.
#  If an image has to be, for example, re-cropped, the file is moved to the necessary directory and the operator uses their personal skill and judgement to re-crop while preserving as much as appropriate and possible of the other edits.
#
# End goals of this makefile are:
#  A single to-do list of what has to be done to advance each case to the next queue.
#

QUEUES:=$(shell find . -path "./[0-9][0-9]*" -type d -printf "%P\n")

.PHONY: to-do clean FORCE
to-do: process.todo

FORCE:

process.todo: $(QUEUES)
	$(info Queues found are $(QUEUES))
	@find . -path "./[0-9][0-9]*" ! -name ".*" -type f -printf "%T+ %P\n" | sort | cut -d\  -f2 > $@

clean:
	rm -f process.todo
