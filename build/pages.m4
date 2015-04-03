m4_dnl To create a page, invoke this script with:
m4_dnl  -P
m4_dnl AND define either the page name or the file name using
m4_dnl  --define=createpagename=<displayed name of page that you want to create>
m4_dnl OR
m4_dnl  --define=createpagefile=<file name of page that you want to create>
m4_dnl Defining both is presently unpredictable. Once I've written the input checking code, I'll have a clearer idea of what would be sensible.
m4_dnl Also, always pass --define=pagelist=<pairs of page title, page file name>

m4_include(`crum4_sitemacros.m4') 
m4_include(`template_preamble.m4')
m4_include(`template_header.m4')
m4_include(`template_content.m4')
m4_include(`template_footer.m4')
m4_include(`template_closure.m4')