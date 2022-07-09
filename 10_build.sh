#!/bin/bash

umask 022
set -e
trap "sudo -u pavel beep" ERR

[ -z "$1" ] && echo "Usage: $0 <shortpkgname1> <shortpkgname2> ..." && exit 1

WD=$(dirname $0)
cd $WD
export CWD=$(pwd)

. $CWD/functions.sh

. $CWD/Application.cfg

. $CWD/10_cross_${ABI}_ndk.cfg

clear_flags

for arg in $*
do
    parse_arg $arg
done


mkdir -p ${ROOT}${PREFIX}
mkdir -p ${STATICROOT}${PREFIX}
[ ! -e $SHORTPREFIX ] && ln -s ${ROOT}${SHORTPREFIX} $SHORTPREFIX || true

. $CWD/flow/headers
. $CWD/flow/tinysystem-base
. $CWD/flow/android-stub
. $CWD/flow/libc++_shared
. $CWD/flow/zlib
. $CWD/flow/tar
. $CWD/flow/strace
. $CWD/flow/ncurses
. $CWD/flow/util-linux
. $CWD/flow/musl
. $CWD/flow/libc_nonshared
. $CWD/flow/util-linux-static
. $CWD/flow/dash
. $CWD/flow/login
. $CWD/flow/eudev
. $CWD/flow/coreutils
. $CWD/flow/psmisc
. $CWD/flow/libxcrypt
. $CWD/flow/libffi
. $CWD/flow/glib2.0
. $CWD/flow/openssl
. $CWD/flow/expat
. $CWD/flow/python3.9
. $CWD/flow/libxml2
. $CWD/flow/libarchive
. $CWD/flow/android-lf
. $CWD/flow/icu
. $CWD/flow/boost1.74
. $CWD/flow/taglib
. $CWD/flow/pcre3
. $CWD/flow/libmd
. $CWD/flow/libbsd
. $CWD/flow/android-videolibs

. $CWD/flow/X11stub
. $CWD/flow/xcb-proto
. $CWD/flow/libxau
. $CWD/flow/xorg-macros
. $CWD/flow/libxcb
. $CWD/flow/libx11
. $CWD/flow/libxext
. $CWD/flow/libxinerama
. $CWD/flow/libxrender
. $CWD/flow/libxfixes
. $CWD/flow/libxi
. $CWD/flow/libxtst



##. $CWD/scripts/freetype;		package_make freetype
##. $CWD/scripts/libxfixes;		package_make libfixes
. $CWD/flow/libxkbcommon
. $CWD/flow/wayland
. $CWD/flow/wayland-protocols
. $CWD/flow/weston

##. $CWD/scripts/libogg;			package_make libogg
##. $CWD/scripts/lame;			package_make lame
##. $CWD/scripts/flac;			package_make flac
##. $CWD/scripts/libvorbis;		package_make libvorbis
##. $CWD/scripts/libsndfile;		package_make libsndfile
##. $CWD/scripts/ffmpeg;			package_make ffmpeg
##. $CWD/scripts/libtool;		package_make libtool
##. $CWD/scripts/libsamplerate;		package_make libsamplerate
##. $CWD/scripts/vamp-plugin-sdk;	package_make vamp-plugin-sdk

##. $CWD/scripts/alsa-lib;		package_make alsa-lib
##. $CWD/scripts/opensles-alsa;		package_make opensles-alsa
##. $CWD/scripts/libsigc++;		package_make libsigc++
##. $CWD/scripts/android-shm;		package_make android-shm
##. $CWD/scripts/android-shmem;		package_make android-shmem
##. $CWD/scripts/libbthread;		package_make libbthread
##. $CWD/scripts/jack2;			package_waf jack2
##. $CWD/scripts/glibmm2.4;		package_make glibmm2.4
##. $CWD/scripts/libpng1.6;		package_make libpng1.6
##. $CWD/scripts/pixman;			package_make pixman
##. $CWD/scripts/brotli;			package_make brotli
##. $CWD/scripts/libestr;		package_make libestr
##. $CWD/scripts/libfastjson;		package_make libfastjson
##. $CWD/scripts/libgpg-error;		package_make libgpg-error
##. $CWD/scripts/libgcrypt20;		package_make libgcrypt20
##. $CWD/scripts/libksba;		package_make libksba
##. $CWD/scripts/libassuan;		package_make libassuan
##. $CWD/scripts/npth;		package_make npth
##. $CWD/scripts/nettle;		package_make nettle
##. $CWD/scripts/libtasn1-6;		package_make libtasn1-6
##. $CWD/scripts/libunistring;		package_make libunistring
##. $CWD/scripts/p11-kit;		package_make p11-kit 0.23.22 tw1
##. $CWD/scripts/unbound;		package_make unbound 1.13.1 tw1
##. $CWD/scripts/gnutls28;		package_make gnutls28
##. $CWD/scripts/sqlite3;		package_make sqlite3 3.34.1 tw1
##. $CWD/scripts/e2fsprogs;		package_make e2fsprogs 1.46.2 tw1
##. $CWD/scripts/heimdal;		package_make heimdal 7.7.0 dfsg
####. $CWD/scripts/cyrus-sasl2;		#package_make cyrus-sasl2 2.1.27 dfsg
##. $CWD/scripts/db5.3;		package_make db5.3 5.3.28 dfsg1
###. $CWD/scripts/openldap;		package_make openldap 2.4.57 dfsg
##. $CWD/scripts/gnupg2;		package_make gnupg2 2.2.27 tw1
##. $CWD/scripts/curl;			package_make curl
##. $CWD/scripts/rsyslog;		package_make rsyslog

##. $CWD/scripts/fontconfig;		package_make fontconfig
##. $CWD/scripts/cairo;			package_make cairo
##. $CWD/scripts/cairomm;			package_make cairomm
##. $CWD/scripts/gobject-introspection;	package_meson gobject-introspection
##. $CWD/scripts/atk1.0;			package_meson atk1.0
##. $CWD/scripts/atkmm1.6;		package_make atkmm1.6
##. $CWD/scripts/libdatrie;		package_make libdartie
##. $CWD/scripts/libthai;			package_make libthai
##. $CWD/scripts/harfbuzz;		package_make harfbuzz
##. $CWD/scripts/pango1.0;		package_meson pango1.0
##. $CWD/scripts/pangomm;			package_make pangomm
##. $CWD/scripts/xmlto;			package_make xmlto
##. $CWD/scripts/shared-mime-info;	package_meson shared-mime-info
##. $CWD/scripts/gdk-pixbuf;		package_meson gdk-pixbuf
##. $CWD/scripts/gtk+2.0;			package_make gtk+2.0
##. $CWD/scripts/libepoxy;		package_meson libepoxy
##. $CWD/scripts/dbus;			package_make dbus
##. $CWD/scripts/at-spi2-core;		package_meson at-spi2-core
##. $CWD/scripts/at-spi2-atk;		package_meson at-spi2-atk
##. $CWD/scripts/gtk+3.0;			package_make gtk+3.0
##. $CWD/scripts/gtkmm2.4;		package_make gtkmm2.4
##. $CWD/scripts/gtkmm3.0;		package_make gtkmm3.0
##. $CWD/scripts/libxfce4util;		package_make libxfce4util
##. $CWD/scripts/xfconf;			package_make xfconf
##. $CWD/scripts/libxfce4ui;		package_make libxfce4ui
##. $CWD/scripts/libwnck3;		package_meson libwnck3
##. $CWD/scripts/xfwm4;			package_make xfwm4
##. $CWD/scripts/pulseaudio;		package_make pulseaudio
##. $CWD/scripts/lv2;			package_make lv2
##. $CWD/scripts/suil;			package_waf suil
##. $CWD/scripts/liblo;			package_make liblo
##. $CWD/scripts/fftw3;			package_make fftw3
##. $CWD/scripts/ladspa-sdk;		package_make ladspa-sdk
##. $CWD/scripts/rubberband;		package_make rebberband
##. $CWD/scripts/aubio;			package_waf aubio
##. $CWD/scripts/serd;			package_waf serd
##. $CWD/scripts/sord;			package_waf sord
##. $CWD/scripts/sratom;			package_waf sratom
##. $CWD/scripts/lilv;			package_waf lilv
##. $CWD/scripts/raptor2;			package_make raptor2
##. $CWD/scripts/rasqal;			package_make rasqal
##. $CWD/scripts/redland;		package_make redland
##. $CWD/scripts/liblrdf;			package_make liblrdf
##. $CWD/scripts/ardour;			package_waf ardour
##. $CWD/scripts/libevent;		package_make libevent
##. $CWD/scripts/avahi;			package_make avahi
##. $CWD/scripts/eigen3;			package_make eigen3
##. $CWD/scripts/noise-repellent;		package_meson noise-repellent
##. $CWD/scripts/fonts-dejavu-core;	package_make fonts-dejacu-core
##. $CWD/scripts/guitarix;		package_waf guitarix
##. $CWD/scripts/am;			package_make am
