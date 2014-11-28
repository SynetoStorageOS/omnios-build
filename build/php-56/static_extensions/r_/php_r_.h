#ifndef PHP_R__H
#define PHP_R__H 1
#define PHP_R__VERSION "1.0"
#define PHP_R__EXTNAME "r_"

PHP_FUNCTION(r_);

extern zend_module_entry r__module_entry;
#define phpext_r__ptr &r__module_entry

#endif
