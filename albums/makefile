# Makefile to manage strategies. Each strategy has its own makefile, which includes a generic makefile at the same level as this one.
# Targets to be used from the command line are: new-strategy
#
# Target 'new-strategy' requires the variable NEWSTRAT to be set. This can be done from the command line. If it is not provided at the command line, the user is prompted to provide it. Each strategy is represented in the file system by a directory bearing the strategy's name, therefore a strategy name must be a valid filename. Further, although a valid filename can contain spaces, make uses the space character as a list separator. There are other special characters that can affect make's operation so care must be taken to keep the strategy name to a very simple character set.

SKEL-STRAT-DIR:=.skeleton-strategy

new-strategy: NEWSTRAT?="$(shell read newstrat && echo $$newstrat)"
new-strategy:
	@echo Setting up new strategy $(NEWSTRAT)
	rsync --links --ignore-existing --recursive --times $(SKEL-STRAT-DIR)/* $(NEWSTRAT)
