PHP_ARG_ENABLE(r_, whether to enable r_ extension,
[ --enable-r_   Enable r_ extension])
 
if test "$PHP_R_" = "yes"; then
  AC_DEFINE(HAVE_R__EXTENSION, 1, [Whether you have r_ extension])
  PHP_NEW_EXTENSION(r_, delta.c r_.c, $ext_shared)
fi
