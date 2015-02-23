#!/usr/bin/bash
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 2011-2012 OmniTI Computer Consulting, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=php
VER=5.6.5
PKG=runtime/php
SUMMARY="PHP Server 5.6"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."

BUILD_DEPENDS_IPS="compress/bzip2
    database/sqlite-3
    database/bdb
    library/libtool/libltdl
    library/libxml2
    library/libxslt
    system/library/iconv/unicode
    system/library/iconv/utf-8
    system/library/iconv/utf-8/manual
    system/library/iconv/xsh4/latin
    system/libmemcached
    web/curl
    library/zlib
    library/freetype2
    library/libgd
    library/libjpeg
    library/libmcrypt
    library/libpng
    library/libssh2
    library/libtiff
    library/mhash"

DEPENDS_IPS="system/library server/httpd system/libmemcached"

# Though not strictly needed since we override build(), still nice to set
BUILDARCH=64
reset_configure_opts

CFLAGS="-O2 -DZLIB_INTERNAL=1 -std=gnu99"
CPPFLAGS=""
CPPFLAGS64="-I/usr/include/$ISAPART64 -I/usr/include/$ISAPART64/curl \
    -I/usr/include"
LDFLAGS64="$LDFLAGS64 -L/usr/lib/$ISAPART64 -R/usr/lib/$ISAPART64 \
    -L$PREFIX/lib -R$PREFIX/lib"


export EXTENSION_DIR=$PREFIX/lib/php/modules
CONFIGURE_OPTS_32=""
CONFIGURE_OPTS_64=""
CONFIGURE_OPTS="
        --prefix=$PREFIX
        --with-libdir=lib/$ISAPART64
        --with-config-file-path=/etc
        --with-config-file-scan-dir=/etc/php.ini.d
        --localstatedir=/var
        --includedir=$PREFIX/include
        --bindir=$PREFIX/bin
        --sbindir=$PREFIX/sbin
        --libdir=$PREFIX/lib
        --libexecdir=$PREFIX/libexec
        --datarootdir=$PREFIX/share
        --mandir=$PREFIX/share/man
        --with-pear=$PREFIX/pear
        --enable-dtrace
        --enable-cgi
        --enable-fpm
        --enable-zip=shared
        --with-zlib=shared
        --with-sqlite3=static
        --enable-pdo=static
        --with-pdo-sqlite=static
        --enable-mbstring=shared
        --with-mhash
        --with-mcrypt=shared
        --with-gd=shared
        --enable-gd-native-ttf
        --enable-exif=shared
        --enable-bcmath=shared
        --enable-calendar=shared
        --enable-ftp=shared
        --enable-mbstring=shared
        --enable-soap=shared
        --with-curl=shared
        --with-openssl
        --with-ldap=shared
        --enable-sockets
        --enable-pcntl
        --enable-posix
        --enable-sigchild
        --with-readline
        --with-pcre-regex
        --enable-ctype
        --enable-session
        --enable-xml
        --enable-simplexml
        --enable-filter
        --with-gettext
        --enable-dom
        --enable-tokenizer
        --enable-shmop
        --enable-sysvmsg
        --enable-sysvsem
        --enable-sysvshm
        --with-xsl
        --enable-fileinfo
        --enable-json
        --enable-hash
        --enable-xmlwriter
        --enable-phar
        --enable-igbinary
        --with-pam
        --with-iconv
        --enable-memcached
        --disable-memcached-sasl
        --enable-xdebug=shared
        --with-apxs2
        --enable-cli"

make_install() {
    logmsg "--- make install"
    logcmd $MAKE DESTDIR=${DESTDIR} INSTALL_ROOT=${DESTDIR} install || \
        logerr "--- Make install failed"
    logmsg "--- copy php.ini examples"
    logcmd cp $TMPDIR/$BUILDDIR/php.ini-production $DESTDIR/$PREFIX/etc/php.ini-production
    logcmd cp $TMPDIR/$BUILDDIR/php.ini-development $DESTDIR/$PREFIX/etc/php.ini-development
    logmsg "--- copy php.ini with sensible defaults"
    logcmd mkdir -p $DESTDIR/etc
    logcmd cp $SRCDIR/php.ini $DESTDIR/etc/php.ini
    logmsg "--- copy apache http configuration"
    logcmd mkdir -p $DESTDIR/etc/httpd/conf.d
    logcmd cp $SRCDIR/httpd-php.conf $DESTDIR/etc/httpd/conf.d/
}

# Create extension dir
create_extension_dir() {
    logmsg "--- Create extension directory"
    logcmd mkdir -p $DESTDIR/$EXTENSION_DIR
}

# PHP bcmath extension
install_ext_bcmath() {
    create_extension_dir
    logmsg "--- Moving files for bcmath extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/bcmath.so $DESTDIR/$EXTENSION_DIR/ || \
        logerr "--- Moving bcmath extensions failed."
}

# PHP calendar extension
install_ext_calendar() {
    create_extension_dir
    logmsg "--- Moving files for calendar extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/calendar.so $DESTDIR/$EXTENSION_DIR/ || \
        logerr "--- Moving calendar extensions failed."
}

# PHP curl extension
install_ext_curl() {
    create_extension_dir
    logmsg "--- Moving files for curl extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/curl.so $DESTDIR/$EXTENSION_DIR/ || \
        logerr "--- Moving curl extensions failed."
}

# PHP exif extension
install_ext_exif() {
    create_extension_dir
    logmsg "--- Moving files for exif extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/exif.so $DESTDIR/$EXTENSION_DIR/ || \
        logerr "--- Moving exif extensions failed."
}

# PHP ftp extension
install_ext_ftp() {
    create_extension_dir
    logmsg "--- Moving files for ftp extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/ftp.so $DESTDIR/$EXTENSION_DIR/ || \
        logerr "--- Moving ftp extensions failed."
}

# PHP gd extension
install_ext_gd() {
    create_extension_dir
    logmsg "--- Moving files for gd extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/gd.so $DESTDIR/$EXTENSION_DIR/ || \
        logerr "--- Moving gd extensions failed."
}

# PHP mbstring extension
install_ext_mbstring() {
    create_extension_dir
    logmsg "--- Moving files for mbstring extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/mbstring.so $DESTDIR/$EXTENSION_DIR/ || \
        logerr "--- Moving mbstring extensions failed."
}

# PHP mcrypt extension
install_ext_mcrypt() {
    create_extension_dir
    logmsg "--- Moving files for mcrypt extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/mcrypt.so $DESTDIR/$EXTENSION_DIR/ || \
        logerr "--- Moving mcrypt extensions failed."
}

# PHP pdo extension
install_ext_pdo() {
    logmsg "--- PDO compiled statically. Nothing to be done"
}

# PHP sqlite extension
install_ext_sqlite() {
    logmsg "--- Sqlite extensions compiled statically. Nothing to be done"
}

# PHP zlib extension
install_ext_zlib() {
    create_extension_dir
    logmsg "--- Moving files for zlib extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/zlib.so $DESTDIR/$EXTENSION_DIR/ || \
        logerr "--- Moving zlib extensions failed."
}

# PHP zip extension
install_ext_zip() {
    create_extension_dir
    logmsg "--- Moving files for zip extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/zip.so $DESTDIR/$EXTENSION_DIR/ || \
        logerr "--- Moving zip extensions failed."
}


# There are some dotfiles/dirs that look like noise
clean_dotfiles() {
    logmsg "--- Cleaning up dotfiles in destination directory"
    logcmd rm -rf $DESTDIR/.??* || \
        logerr "--- Unable to clean up destination directory"
}

add_static_extensions() {
    logmsg "--- Copying static extensions"
    logcmd cp -r ${SRCDIR}/static_extensions/* $TMPDIR/$BUILDDIR/ext/
    pushd $TMPDIR/$BUILDDIR
    MAKE=${MAKE} ./buildconf --force
    popd > /dev/null
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
add_static_extensions
build
clean_dotfiles
make_package php.mog

#################################
### CREATE EXTENSION PACKAGES ###
#################################

INSTALLDIR=$DESTDIR

PROG=php-bcmath
PKG=runtime/php/php-bcmath
SUMMARY="PHP 5.6 - bcmath extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS=""
prep_build
install_ext_bcmath
make_package ext.mog

PROG=php-calendar
PKG=runtime/php/php-calendar
SUMMARY="PHP 5.6 - calendar extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS=""
prep_build
install_ext_calendar
make_package ext.mog

PROG=php-curl
PKG=runtime/php/php-curl
SUMMARY="PHP 5.6 - curl extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS="local/web/curl library/libldap"
prep_build
install_ext_curl
make_package ext.mog

PROG=php-exif
PKG=runtime/php/php-exif
SUMMARY="PHP 5.6 - exif extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS=""
prep_build
install_ext_exif
make_package ext.mog

PROG=php-ftp
PKG=runtime/php/php-ftp
SUMMARY="PHP 5.6 - ftp extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS=""
prep_build
install_ext_ftp
make_package ext.mog

PROG=php-gd
PKG=runtime/php/php-gd
SUMMARY="PHP 5.6 - gd extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS="library/freetype2
    library/libjpeg
    library/libpng
    library/libtiff"
prep_build
install_ext_gd
make_package ext.mog

PROG=php-mbstring
PKG=runtime/php/php-mbstring
SUMMARY="PHP 5.6 - mcrypt extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS=""
prep_build
install_ext_mbstring
make_package ext.mog

PROG=php-mcrypt
PKG=runtime/php/php-mcrypt
SUMMARY="PHP 5.6 - mcrypt extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS="library/libmcrypt"
prep_build
install_ext_mcrypt
make_package ext.mog

PROG=php-pdo
PKG=runtime/php/php-pdo
SUMMARY="PHP 5.6 - pdo extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS=""
prep_build
install_ext_pdo
make_package ext.mog

PROG=php-sqlite
PKG=runtime/php/php-sqlite
SUMMARY="PHP 5.6 - sqlite extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS="database/sqlite-3"
prep_build
install_ext_sqlite
make_package ext_sqlite.mog

PROG=php-zib
PKG=runtime/php/php-zip
SUMMARY="PHP 5.6 - zip extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS="local/library/zlib"
prep_build
install_ext_zip
make_package ext.mog

PROG=php-zlib
PKG=runtime/php/php-zlib
SUMMARY="PHP 5.6 - zlib extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS="local/library/zlib"
prep_build
install_ext_zlib
make_package ext.mog

clean_up

# Vim hints
# vim:ts=4:sw=4:et:
