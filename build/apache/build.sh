#!/usr/bin/bash

# Load support functions
. ../../lib/functions.sh

PROG=httpd
VER=2.4.10
PKG=server/httpd
SUMMARY="$PROG - Apache Web Server ($VER)"
DESC="$SUMMARY"

REMOVE_PREVIOUS=1

BUILD_DEPENDS_IPS="database/sqlite-3 library/security/openssl library/apr library/apr-util" 
DEPENDS_IPS="library/apr library/apr-util library/security/openssl database/sqlite-3"

PREFIX=/usr
reset_configure_opts

# Package info
NAME=httpd
CATEGORY=network

BUILDARCH=64
MPMS="worker event prefork" # Which MPMs to build

# Define some architecture specific variables
if [[ $ISAPART == "i386" ]]; then
    LAYOUT64=SolAmd64
    #DEF64="-DALTLAYOUT -DAMD64"
else
    # sparc
    LAYOUT64=SolSparc64
    #DEF64="-DALTLAYOUT -DSPARCV9"
fi

# General configure options - BASE is for options to be applied everywhere
# and the *64 variables are for 64 bit builds.
CONFIGURE_OPTS_BASE="
    --enable-ldap
    --enable-authnz-ldap
    --enable-ssl
    --with-ssl=/usr
    --enable-file-cache
    --enable-proxy
    --enable-proxy-http
    --enable-cache
    --enable-disk-cache
    --enable-mem-cache
    --enable-modules=all
    --disable-reqtimeout
    --disable-proxy-scgi"
CONFIGURE_OPTS_64="
    --enable-layout=$LAYOUT64
    --with-apr=/usr/bin/$ISAPART64/apr-1-config
    --with-apr-util=/usr/bin/$ISAPART64/apu-1-config"

LDFLAGS64="$LDFLAGS64 -L/usr/lib/$ISAPART64 -R/usr/lib/$ISAPART64"
CFLAGS64="$CFLAGS64 -g"

# Run a build for each MPM
# This function is provided with a callback parameter - this should be the
# name of the function to call to actually do the building
build_mpm() {
    CALLBACK=$1
    for MPM in $MPMS; do
        logmsg "Building $MPM MPM"
        if [[ "$MPM" != "prefork" ]]; then
            CONFIGURE_OPTS="$CONFIGURE_OPTS_BASE
                --with-program-name=httpd.$MPM
                --with-mpm=$MPM"
        else
            # prefork doesn't need any special options
            CONFIGURE_OPTS="$CONFIGURE_OPTS_BASE"
        fi
        # run the callback function
        $CALLBACK
    done
}

# Redefine the build64 to build all MPMs
save_function build64 build64_orig

build64() {
    logcmd perl -pi -e "
    s#-L/usr/lib#-L/usr/lib/$ISAPART64 -R/usr/lib/$ISAPART64#g;
    s#(-[LR]/usr/lib(?!/))#"'$1'"/$ISAPART64#g;
    s#^EXTRA_LDFLAGS = .+#EXTRA_LDFLAGS = #;
    " $TMPDIR/$BUILDDIR/build/config_vars.mk
    build_mpm build64_orig
}

# Extra script/file installs
add_file() {
    logcmd cp $SRCDIR/files/$1 $DESTDIR/$2
    logcmd chown root:root $DESTDIR/$2
    if [[ -n "$3" ]]; then
        logcmd chmod $3 $DESTDIR/$2
    else
        logcmd chmod 0444 $DESTDIR/$2
    fi
}

add_extra_files() {
    logmsg "Installing custom files and scripts"
    logcmd install -d $DESTDIR/lib/svc/manifest/network/
    add_file manifest-http-apache.xml lib/svc/manifest/network/httpd.xml
    logcmd rm -f $DESTDIR/etc/httpd/httpd.*.conf
    logcmd mv $DESTDIR/etc/httpd/httpd.conf $DESTDIR/etc/httpd/httpd.conf.dist
    add_file httpd.conf etc/httpd/httpd.conf
    logcmd install -d $DESTDIR/var/www
    logcmd install -d $DESTDIR/etc/httpd/conf.d
}

# Add some more files once the source code has been downloaded
save_function download_source download_source_orig
download_source() {
    download_source_orig "$@"
    logcmd cp $SRCDIR/files/config.layout $TMPDIR/$BUILDDIR/
}

# Add another step after patching the source (a new file needs to be made
# executable
save_function patch_source patch_source_orig
patch_source() {
    patch_source_orig
    logcmd chmod +x $TMPDIR/$BUILDDIR/libtool-dep-extract
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
add_extra_files
make_package
clean_up
