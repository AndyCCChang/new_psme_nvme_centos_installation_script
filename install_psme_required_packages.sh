#!/bin/bash
FABREX_VER="1.1"
#FABREX_REPO="http://cyber1/LEX/Releases/FCS/"
#FABREX_TARBALL="FabreX_v${FABREX_VER}_CentOS7.tar.bz2"
#PKGDIR="centos7/package/"
ILOG="install_psme_required_packages.log"
ISUMMARY="psme-pkg-install-summary.log"
PACKAGES=(
epel-release
cmake3
llvm-toolset-7
centos-release-scl
devtoolset-7
gnutls-devel
libcurl-devel
libmicrohttpd-devel
libudev-devel
lvm2-devel
libnl3-devel
python-pip
psmisc
libibverbs
gmp-devel
mpfr-devel
libmpc-devel

            )
YUMFLAGS="-y"
#wget ${FABREX_REPO}${FABREX_TARBALL} -O ${FABREX_TARBALL}
#echo "Untar tarball"
echo "=================================" | tee $ILOG $ISUMMARY
echo "      Host Install Begin" | tee -a $ILOG $ISUMMARY
echo "=================================" | tee -a $ILOG $ISUMMARY
echo "#Installing Development Tools" | tee -a ${ILOG}
sudo yum group install "Development Tools" ${YUMFLAGS} | tee -a ${ILOG}
for p in ${PACKAGES[@]} ; do
        PKGVERSION=$(rpm -qp --queryformat "%-25{NAME} %{VERSION}\n" ${PKGDIR}${p}*x86_64.rpm 2>/dev/null)
        echo "#Installing ${p}" | tee -a ${ILOG}
        #sudo yum install ${PKGDIR}${p}*x86_64.rpm ${YUMFLAGS} | tee -a ${ILOG}
        sudo yum install ${p} ${YUMFLAGS} | tee -a ${ILOG}
        echo "=================================" | tee -a $ILOG $ISUMMARY
done
echo "Install Python packages" | tee -a ${ILOG}
 sudo pip install --upgrade pip | tee -a $ILOG $ISUMMARY
 pip install -U Sphinx | tee -a $ILOG $ISUMMARY
 sudo yum install -y psmisc | tee -a $ILOG $ISUMMARY
echo "enable devtoolset"| tee -a ${ILOG}
source /opt/rh/devtoolset-7/enable
echo "set cmake3 as default"| tee -a ${ILOG}
sudo alternatives --install /usr/local/bin/cmake cmake /usr/bin/cmake 10 \
--slave /usr/local/bin/ctest ctest /usr/bin/ctest \
--slave /usr/local/bin/cpack cpack /usr/bin/cpack \
--slave /usr/local/bin/ccmake ccmake /usr/bin/ccmake \
--family cmake
 sudo alternatives --install /usr/local/bin/cmake cmake /usr/bin/cmake3 20 \
--slave /usr/local/bin/ctest ctest /usr/bin/ctest3 \
--slave /usr/local/bin/cpack cpack /usr/bin/cpack3 \
--slave /usr/local/bin/ccmake ccmake /usr/bin/ccmake3 \
--family cmake

echo "Install libmicrohttpd-0.9.59 " | tee -a ${ILOG}
tar zxf libmicrohttpd-0.9.59.tar.gz
cd libmicrohttpd-0.9.59
./configure; make; sudo make install; cd ..

echo "Install gcc-5.4.0" | tee -a ${ILOG}
tar -xf gcc-5.4.0.tar.bz2
mkdir gcc-5.4.0-build
cd gcc-5.4.0-build
../gcc-5.4.0/configure --enable-languages=c,c++ --disable-multilib
make -j$(nproc) && make install
echo "Export path" | tee -a ${ILOG}
export PATH=/usr/local/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
gcc --version 


#POST INSTALL
#!/bin/bash
#create psme bin and etc path
mkdir -p /usr/local/bin/
mkdir -p /usr/local/etc/psme-config/
mkdir -p /usr/local/psme_storage_package/etc/
mkdir -p /usr/local/psme_storage_package/bin/
mkdir -p /etc/psme

install -m 755 psme_centos_etc_bin/etc/* /usr/local/etc/psme-config/
install -m 755 psme_centos_etc_bin/bin/* /usr/local/bin/
#copy psme package
#install -m 755 /usr/local/psme_storage_package/etc/* /usr/local/etc/psme-config/
#install -m 755 /usr/local/psme_storage_package/bin/* /usr/local/bin/

#copy ca
mkdir -p /etc/psme/certs
cp -pr certs /etc/psme/
#cp -pr /usr/local/certs /etc/psme/

# Create directory for DB
mkdir -p /var/opt/psme/discovery
mkdir -p /var/opt/psme/nvme/
mkdir -p /var/opt/psme/rest-discovery/

bash ./create-upstart-psme-nvme-service_centos.sh
bash ./create-upstart-psme-rest-service_centos.sh



echo "=================================" | tee -a $ILOG $ISUMMARY
echo "      Packages Install Complete" | tee -a $ILOG $ISUMMARY
echo "=================================" | tee -a $ILOG $ISUMMARY

