# MongoObjCDriver

ObjC wrapper of [mongo-c-driver](https://github.com/mongodb/mongo-c-driver) to connect to a mongodb with an async API.

## mongo-c-driver

mongo-c-driver 1.3.5 is pre-built on OS X 10.11 with a target of OS X 10.8.

macOS 10.12 adds clock_gettime, which will be used if available. Thus building on 10.12 means the library will have linker errors on previous verisions of OS X.

### Build Steps

* `brew install automake autoconf libtool pkgconfig`
* Set environment variables:

      export CFLAGS="-mmacosx-version-min=10.8"
      export LDFLAGS="-L/usr/local/opt/openssl/lib"
      export CPPFLAGS="-mmacosx-version-min=10.8 -I/usr/local/opt/openssl/include"

* `./autogen.sh --prefix=`pwd`/install --enable-static CFLAGS='-mmacosx-version-min=10.8' --with-libbson=bundled`
* `make`
* `make install`
