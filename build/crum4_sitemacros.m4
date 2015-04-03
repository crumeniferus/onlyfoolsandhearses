m4_dnl Shared macros for site building.
m4_dnl
m4_dnl Page content macros.


m4_dnl Input checking for page generation.
m4_dnl Most important at this time is to check and set:
m4_dnl  createpagename
m4_dnl  createpagefile
m4_dnl m4_define(`crum4_createpagefile', Filename)
m4_dnl m4_define(`crum4_createpagename', PageTest)
m4_dnl m4_define(`crum4_navitems_add', `<li><a href="./$1">$2</a></li>m4_ifelse(`$#',`0',,`crum4_navitems_add(m4_shift($3))')')
m4_dnl m4_define(`crum4_navitems_add', `<li><a href="./$1">$2</a></li>m4_ifelse(`$#',`8',,`crum4_navitems_add(nextfile.html,next_page)')')
m4_define(`crum4_navitems_add', `<`li'm4_ifelse(`$1',crum4_createpagename,` class="active"',`')><a href="./$2">$1</a></li>
m4_ifelse(`$3',`',`',`crum4_navitems_add(m4_shift(m4_shift($@)))')')
m4_define(`crum4_social_link', `<a href="m4_sinclude(`site_$2.txt')" rel="alternate" title="`$1' page for m4_sinclude(`site_title.txt')">m4_sinclude(`site_title.txt') `$1' page</a>')
m4_define(`crum4_social_link_long', `<a href="m4_sinclude(`site_$2.txt')" rel="alternate" title="`$1' page for m4_sinclude(`site_title.txt')">m4_sinclude(`site_title.txt') `$1' page</a>')
m4_define(`crum4_social_link_short', `<a href="m4_sinclude(`site_$2.txt')" rel="alternate" title="`$1' page for m4_sinclude(`site_title.txt')">`$1'</a>')
