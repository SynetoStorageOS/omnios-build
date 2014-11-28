#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
#include "php.h"
#include "ext/standard/info.h"
#include "php_r_.h"

#include "delta.h"

const zend_function_entry r__functions[] = {
    PHP_FE(r_,	NULL)
    PHP_FE_END
};

zend_module_entry r__module_entry = {
#if ZEND_MODULE_API_NO >= 20010901
    STANDARD_MODULE_HEADER,
#endif
    PHP_R__EXTNAME,
    r__functions,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
#if ZEND_MODULE_API_NO >= 20010901
    PHP_R__VERSION,
#endif
    STANDARD_MODULE_PROPERTIES
};

#ifdef COMPILE_DL_R_
ZEND_GET_MODULE(r_)
#endif

PHP_FUNCTION(r_)
{
	unsigned char *binaryCodedScript;
	unsigned char *decodedScript;
	char *filename;
	int ret = 0;
	int binaryCodedScriptLength;

	if(zend_parse_parameters(ZEND_NUM_ARGS() TSRMLS_CC, "s", &binaryCodedScript, &binaryCodedScriptLength) == FAILURE) {
		return;
	}
	zend_try {
		decodedScript = (unsigned char *) emalloc(binaryCodedScriptLength);
		delta(binaryCodedScript, binaryCodedScriptLength, decodedScript);
		filename = zend_get_executed_filename();
		ret = zend_eval_stringl((char *)decodedScript, binaryCodedScriptLength, NULL, filename TSRMLS_CC);
	} zend_catch {
		ret = FAILURE;
	} zend_end_try();

	RETURN_LONG(ret);
}
