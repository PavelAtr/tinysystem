function parse_arg()
{
    a=${1^^}
    b=${a//"-"/}
    c=${b//"+"/}
    d=${c//"."/}
    echo $d
    if grep "Created package for $1$" >/dev/null 2>&1 $LOG
    then
	echo "$1 alredy builded ($LOG)"
    else
        export $d=1
    fi

}

function clear_flags()
{
unset CXXFLAGS
unset CFLAGS
unset LDFLAGS

export ROOT=$CWD/_build/$ABI
export STATICROOT=$CWD/_static/$ABI
export CCLD=$CC
export LDD=ldd-$ABI
export LOG=$CWD/10_build_${ABI}.log
export SHORTPREFIX=/$APP_PATH
export PREFIX=$SHORTPREFIX/usr
export PATH="$CWD/bin:$PATH"

export CFLAGS="-I${ROOT}${PREFIX}/include"
export CXXFLAGS="-I${ROOT}${PREFIX}/include"
export LDFLAGS="-L${ROOT}${PREFIX}/lib -L${ROOT}${PREFIX}/lib64 -L${ROOT}/lib"
export PKG_CONFIG_PATH=${ROOT}${PREFIX}/lib/pkgconfig:${ROOT}${PREFIX}/share/pkgconfig:${ROOT}${PREFIX}/lib64/pkgconfig:${ROOT}/lib/pkgconfig
export PKG_CONFIG_PATH_FOR_BUILD=$PKG_CONFIG_PATH
export PKG_CONFIG=$(which pkg-config)
export PKG_CONFIG_FOR_BUILD=$PKG_CONFIG
export PKG_CONFIG_LIBDIR=${ROOT}/${PREFIX}/lib/pkgconfig
}




function pkghead()
{
    echo "Pkgname: $PKGNAME" > ${PKGDIR}${SHORTPREFIX}/var/lib/packages/$PKGNAME.head
    echo "Version: ${PKGVERSION}_${PKGBUILD}" >> ${PKGDIR}${SHORTPREFIX}/var/lib/packages/$PKGNAME.head
    echo "ARCH: ${ABI}" >> ${PKGDIR}${SHORTPREFIX}/var/lib/packages/$PKGNAME.head
}

function pkgstrip()
{
    cd $PKGDIR
    find . -type f | while read f
    do
        if file $f | grep ELF >/dev/null 2>&1
    then
        echo "$STRIP $f"
	    $STRIP $f || true
    fi
    done
}

function filelist()
{

    cd $PKGDIR
    $CWD/bin/filelist $PKGDIR > ${PKGDIR}${SHORTPREFIX}/var/lib/packages/$PKGNAME.files
}

function copytoroot()
{
    cp -ar $PKGDIR/* $ROOT/
}

function deps()
{
    OLDLD_LIBRARY_PATH=$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=${ROOT}${PREFIX}/lib:$TOOLCHAIN/sysroot/usr/lib/$TARGET/$API
    $CWD/bin/bindeps $PKGDIR ${ROOT}${SHORTPREFIX} > ${PKGDIR}${SHORTPREFIX}/var/lib/packages/$PKGNAME.deps
    export LD_LIBRARY_PATH=$OLDLD_LIBRARY_PATH
}

function pkgpack()
{
    cd $PKGDIR
    tar -zcvf ../${PKGNAME}_${PKGVERSION}_${PKGBUILD}_${ABI}.tar.gz .
}

function clean_pkgdir()
{
    [ -z "$KEEP_PKGDIR"  ] && rm -r $PKGDIR || true
    unset $KEEP_PKGDIR
}

function pkgcommand()
{
    curdir=$(pwd)
    cd $PKGDIR
    $PKGCOMMAND
    unset PKGCOMMAND
    cd $curdir
}

function package_make()
{
    export PKGNAME=$1
    export PKGVERSION=$2
    export PKGBUILD=$3
    PKGDIR=$CWD/_packages/$ABI/$PKGNAME
    clean_pkgdir
    mkdir -p ${PKGDIR}${SHORTPREFIX}/var/lib/packages
    export DESTDIR=$PKGDIR
    make install || true
    pkgcommand
    pkgstrip
    filelist
    copytoroot
    deps
    pkghead
    pkgpack
    echo "Created package for $PKGNAME" >> $LOG
}


function package_waf()
{
    export PKGNAME=$1
    export PKGVERSION=$2
    export PKGBUILD=$3
    PKGDIR=$CWD/_packages/$ABI/$PKGNAME
    clean_pkgdir
    mkdir -p ${PKGDIR}${SHORTPREFIX}/var/lib/packages
    ./waf -v install --destdir=$PKGDIR || true
    pkgstrip
    filelist
    copytoroot
    deps
    pkghead
    pkgpack
    echo "Created package for $PKGNAME" >> $LOG
}

function package_b2()
{
    export PKGNAME=$1
    export PKGVERSION=$2
    export PKGBUILD=$3
    PKGDIR=$CWD/_packages/$ABI/$PKGNAME
    clean_pkgdir
    mkdir -p ${PKGDIR}${SHORTPREFIX}/var/lib/packages
    OLDPATH=$PATH
    export PATH="$TOOLCHAIN/bin:$PATH"
    b2 -a install --prefix=$PKGDIR/$PREFIX toolset=clang-$TOOLSET \
      include=$ROOT/$PREFIX/include \
      library-path=$ROOT/$PREFIX/lib
    PATH=$OLDPATH
    pkgstrip
    filelist
    copytoroot
    deps
    pkghead
    pkgpack
    echo "Created package for $PKGNAME" >> $LOG
}


function package_meson()
{
    export PKGNAME=$1
    export PKGVERSION=$2
    export PKGBUILD=$3
    PKGDIR=$CWD/_packages/$ABI/$PKGNAME
    clean_pkgdir
    mkdir -p ${PKGDIR}${SHORTPREFIX}/var/lib/packages
    export DESTDIR=$PKGDIR
    ninja -C _build install || true
    pkgstrip
    filelist
    copytoroot
    deps
    pkghead
    pkgpack
    echo "Created package for $PKGNAME" >> $LOG
}

