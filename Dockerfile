FROM registry.access.redhat.com/rhel6.6 

ENV GCC_VER 4.9.2

ADD centos.repo /etc/yum.repos.d/

RUN rpm -ivh http://mirror.centos.org/centos/6/os/x86_64/Packages/tar-1.23-15.el6_8.x86_64.rpm && \
    yum install -y http://mirror.centos.org/centos/6/os/x86_64/Packages/fipscheck-1.2.0-7.el6.x86_64.rpm && \
    yum install -y http://mirror.centos.org/centos/6/os/x86_64/Packages/tcp_wrappers-libs-7.6-58.el6.x86_64.rpm && \
    yum install -y http://mirror.centos.org/centos/6/os/x86_64/Packages/wget-1.12-10.el6.x86_64.rpm && \
    yum install -y http://mirror.centos.org/centos/6/os/x86_64/Packages/bzip2-1.0.5-7.el6_0.x86_64.rpm && \
    yum install -y http://mirror.centos.org/centos/6/os/x86_64/Packages/gzip-1.3.12-24.el6.x86_64.rpm && \
    yum install -y http://mirror.centos.org/centos/6/os/x86_64/Packages/openssh-server-5.3p1-123.el6_9.x86_64.rpm && \
    yum install -y http://mirror.centos.org/centos/6/os/x86_64/Packages/zlib-devel-1.2.3-29.el6.x86_64.rpm
    #rpm -ivh http://mirror.centos.org/centos/6/os/x86_64/Packages/fipscheck-lib-1.2.0-7.el6.x86_64.rpm
RUN (yum groupinstall -y 'Development Tools' || \
    yum groupinstall -y 'Development Tools' || \
    yum groupinstall -y 'Development Tools')
RUN wget -O /root/gcc-${GCC_VER}.tar.bz2  https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/gcc-${GCC_VER}.tar.bz2 && \
    cd /root && tar xvjf gcc-${GCC_VER}.tar.bz2  && \
    cd /root/gcc-${GCC_VER} && contrib/download_prerequisites && \
    mkdir -p /root/gcc-${GCC_VER}/build && cd /root/gcc-${GCC_VER}/build && \
    ../configure --prefix=/usr/local/gcc --disable-bootstrap --with-system-zlib --enable-languages=c,c++ --build=x86_64-redhat-linux --disable-multilib && \
    make -j8 && \
    make install && \
    yum clean all && \
    rm -rf /root/* && \
    rm /usr/bin/gcc /usr/bin/g++ /usr/bin/cpp && \
    ln -s /usr/local/gcc/bin/gcc /usr/bin/ && \
    ln -s /usr/local/gcc/bin/g++ /usr/bin/ && \
    ln -s /usr/local/gcc/bin/cpp /usr/bin/ && \
    service sshd start
RUN echo 'root:password' | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
