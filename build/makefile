#Makefile to build the pages.
#Macro needs to.

#Start by always building everything.
#We could do with a script that automatically calculates dependencies from the macro files: there are quite a few nested macro calls.
#The plain text files that define contact names, telephone numbers, etc. need to have the final newline removed otherwise extraneous spaces appear in the text.
#This is a charcteristic of m4 taking an included file literally and in its entirety, whereas many Unix tools rely on CR just before EOF.
#An alternative workaround is to quote all the required contents of those files in m4 style (i.e. `') followed immediately by the inbuilt m4 macro dnl.
#This second option is somewhat inconvenient and, whilst lacking a final CR could be problematic for some tools, at least the first option means that the file is still human-readable and much more useable by other tools.
#A command that works wll to remove the final CR is:
# perl -pi -e 'chomp if eof' <filename>
#*However* this command will mess up symbolic links, converting them into real files.
#Also, we had probably better not mess woth the file ending of the page list (page_list.txt).

#GnuWin32PATH=C:\Users\ian\GnuWin32\bin

PAGE_DEFS=page_list.txt
PAGE_NAME_FILTER:=cut --delimiter=',' --fields=1
PAGE_FILE_FILTER:=cut --delimiter=',' --fields=2
PAGE_ARRAY:=$(shell grep -v '\#' $(PAGE_DEFS) | tr '\n' ',')	#This leaves a trailing comma that messes up list processing.
PAGE_NAMES:=$(shell grep -v '\#' $(PAGE_DEFS) | $(PAGE_NAME_FILTER))
PAGE_FILES:=$(shell grep -v '\#' $(PAGE_DEFS) | $(PAGE_FILE_FILTER))
PAGE_TEMPLATES=$(wildcard template_*.m4)
CRUMENIFERUS_DEFS=$(wildcard crum_*.m4)
page_name=$(shell grep "$@$$" $(PAGE_DEFS) | $(PAGE_NAME_FILTER))

.PHONY : site 

site : $(PAGE_DEFS) $(PAGE_FILES)
#	$(PAGE_ARRAY)
#	@echo $(PAGE_ARRAY)
	@echo Page names are: $(PAGE_NAMES)
	@echo Page files are: $(PAGE_FILES)
	@echo Pre-requisites for $@ are: $^
	
#$(PAGE_NAMES) : thispagefile=$(shell grep $(PAGE_NAME) $(PAGEARRAY)


$(PAGE_FILES) : %.html : $(wildcard %_*.m4) $(PAGE_TEMPLATES) $(CRUMENIFERUS_DEFS) pages.m4
	@echo Making $@ for the $(page_name) page.
	m4 --debug=V --prefix-builtins --define=crum4_pagelist="$(PAGE_ARRAY)" --define=crum4_createpagename=$(page_name) --define=crum4_createpagefile=$@ pages.m4 > $@

*.m4 :
