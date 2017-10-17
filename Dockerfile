#use centos 6.9

From centos:centos6.9

RUN yum update -y && \
    yum install -y wget && \
    yum install -y which && \
    yum -y install rpcbind && \
    yum -y install nfs-utils && \
    yum -y install ntp && \
    yum -y install libaio && \
    yum -y install openssh-clients && \
    yum -y install syslog && \
    chkconfig iptables off && \
    chkconfig ntpd on && \
    yum -y install glib2 && \
#    yum -y install p7zip && \
    yum -y install telnet-server && \
    yum -y install telnet && \
    chkconfig telnet on && \
    chkconfig xinetd on && \
    useradd -ms /bin/bash thot && \
    yum clean all

RUN wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/bllbldlnx/p4 && \
    mv p4 /usr/local/bin/p4 && \
    chmod a+x /usr/local/bin/p4

RUN echo "results.cal.ci.spirentcom.com:smt  /results/smt   nfs   rw,proto=tcp  0 0" >> /etc/fstab && \
    mkdir -p /results/smt && \
    echo "gibson.spirentcom.com:/export/archive/pv   /gibson nfs  ro,nolock    0 0" >> /etc/fstab && \
    mkdir -p /gibson && \
    mkdir -p /home/thot/Spirent_Communications && \
    mkdir -p /home/thot/temp && \
    mkdir -p /home/thot/THoT && \
    mkdir -p /home/thot/thot_repo && \
    mkdir -p /home/thot/videoFiles && \
    mkdir -p /home/thot/PVTCLLibrary && \
    mkdir -p /home/thot/Spirent_Communications/Spirent_TestCenter && \
    mkdir -p /home/thot/Spirent_Communications/Tcl

#install Thot with 64 bit libs
RUN wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/smt-agent/THOT/linux/linux_4.96.05.tar && \
    tar -xvf linux_4.96.05.tar && \
    cp -r ./linux_4.96.05/* /home/thot/THoT/ && \
    mkdir -p /home/thot/mono-1.2.3 && \
    tar xvfz ./linux_4.96.05/Mono/RH8/mono1.2.3RH8.tar.gz -C /home/thot/mono-1.2.3 && \
    rm -rf linux_* && \
    wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/smt-agent/THOT/64bit-specific/_TH_python.so && \
    wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/smt-agent/THOT/64bit-specific/libifacegen.so && \
    wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/smt-agent/THOT/64bit-specific/libstdc++.so.6.0.20 && \
    wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/smt-agent/THOT/64bit-specific/libtclStruct.so && \
    wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/smt-agent/THOT/64bit-specific/libthlib.so && \
    mv ./*.so /home/thot/THoT/ && \
    mv ./libstdc++.so.6.0.20 /home/thot/THoT/ && \
    rm -f /home/thot/THoT/libstdc++.so.6 && \
    rm -f /home/thot/THoT/libstdc++.so && \
    ln -s /home/thot/THoT/libstdc++.so.6.0.20 /home/thot/THoT/libstdc++.so.6 && \
    ln -s /home/thot/THoT/libstdc++.so.6 /home/thot/THoT/libstdc++.so && \
    chown -R thot:thot /home/thot/

#install Active TCL
RUN wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/smt-agent/64bit/ActiveTCL/ActiveTcl8.5.11.1.295590-linux-x86_64-threaded.tar.gz && \
    tar xvfz ActiveTcl8.5.11.1.295590-linux-x86_64-threaded.tar.gz && \
    ./ActiveTcl8.5.11.1.295590-linux-x86_64-threaded/install.sh --directory /home/thot/Spirent_Communications/Tcl && \
    rm -rf ActiveTcl* && \
    mkdir -p /home/thot/Spirent_Communications/Tcl/lib/stc2.0 && \
    mkdir -p /home/thot/Spirent_Communications/Tcl/lib/PVTCLLIB1.0 && \
    wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/smt-agent/64bit/ActiveTCL/PVTCLLIB1.0/pkgIndex.tcl && \
    mv ./pkgIndex.tcl /home/thot/Spirent_Communications/Tcl/lib/PVTCLLIB1.0/ && \
    wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/smt-agent/64bit/ActiveTCL/stc2.0/pkgIndex.tcl && \
    mv ./pkgIndex.tcl /home/thot/Spirent_Communications/Tcl/lib/stc2.0/ && \
    chmod 775 /home/thot/Spirent_Communications/Tcl/lib/PVTCLLIB1.0/pkgIndex.tcl && \
    chmod 775 /home/thot/Spirent_Communications/Tcl/lib/stc2.0/pkgIndex.tcl && \
    chown -R thot:thot /home/thot/Spirent_Communications/Tcl


#install wireshark
RUN wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/smt-agent/64bit/wireshark/wireshark-1.10.3-spirent_15.x86_64.rpm.tar.gz && \
    tar xvzf wireshark-1.10.3-spirent_15.x86_64.rpm.tar.gz && \
    yum -y install ./wireshark-1.10.3-spirent_15/wireshark-1.10.3-spirent_15.x86_64.rpm && \
    chmod a+x /usr/local/bin/dumpcap &&  \
    rm -rf ./wireshark-1.10.3-spirent*

#install teacup and other packages
RUN /home/thot/Spirent_Communications/Tcl/bin/teacup link make "/home/thot/Spirent_Communications/Tcl/lib/teapot" /home/thot/Spirent_Communications/Tcl/bin/tclsh && \
    /home/thot/Spirent_Communications/Tcl/bin/teacup install Expect && \
    /home/thot/Spirent_Communications/Tcl/bin/teacup install math && \
    /home/thot/Spirent_Communications/Tcl/bin/teacup install math::bignum && \
    /home/thot/Spirent_Communications/Tcl/bin/teacup install ip && \
    /home/thot/Spirent_Communications/Tcl/bin/teacup install htmlparse && \
    /home/thot/Spirent_Communications/Tcl/bin/teacup install math::statistics && \
    /home/thot/Spirent_Communications/Tcl/bin/teacup install dom && \
    /home/thot/Spirent_Communications/Tcl/bin/teacup install dict && \
    /home/thot/Spirent_Communications/Tcl/bin/teacup install XMLRPC

#install ia32bit libs
RUN yum -y install glibc.i686 arts.i686 audiofile.i686 bzip2-libs.i686 cairo.i686 cyrus-sasl-lib.i686 dbus-libs.i686 directfb.i686 esound-libs.i686 fltk.i686 freeglut.i686 gtk2.i686 hal-libs.i686 imlib.i686 lcms-libs.i686 lesstif.i686 libacl.i686 libao.i686 libattr.i686 libcap.i686 libdrm.i686 libexif.i686 libgnomecanvas.i686 libICE.i686 libieee1284.i686 libsigc++20.i686 libSM.i686 libtool-ltdl.i686 libusb.i686 libwmf.i686 libwmf-lite.i686 libX11.i686 libXau.i686 libXaw.i686 libXcomposite.i686 libXdamage.i686 libXdmcp.i686 libXext.i686 libXfixes.i686 libxkbfile.i686 libxml2.i686 libXmu.i686 libXp.i686 libXpm.i686 libxslt.i686 libXt.i686 libXtst.i686 libXxf86vm.i686 lzo.i686 mesa-libGL.i686 mesa-libGLU.i686 cdk.i686 openldap.i686 pam.i686 popt.i686 sane-backends-libs-gphoto2.i686 sane-backends-libs.i686 SDL.i686 svgalib.i686 unixODBC.i686 zlib.i686 compat-expat1.i686 compat-libstdc++-33.i686 openal-soft.i686 redhat-lsb.i686 alsa-plugins-oss.i686 alsa-lib.i686 nspluginwrapper.i686 libXv.i686 libXScrnSaver.i686 qt.i686 qt-x11.i686 pulseaudio-libs.i686 pulseaudio-libs-glib2.i686 alsa-plugins-pulseaudio.i686 && \
    yum clean all

RUN wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/smt-agent/64bit/bash_profile && \
    mv bash_profile /home/thot/.bash_profile && \
    wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/smt-agent/64bit/bashrc && \
    mv bashrc /home/thot/.bashrc && \
    wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/smt-agent/64bit/rc.local && \
    mv rc.local /etc/rc.d/rc.local && \
    chmod a+x /etc/rc.d/rc.local

RUN yum -y install sudo && \
    echo "thot ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    yum clean all
                                                             
