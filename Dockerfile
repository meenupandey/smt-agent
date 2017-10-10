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
    yum clean all && \
    chkconfig iptables off && \
    chkconfig ntpd on && \
    useradd -ms /bin/bash thot
    
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
    mkdir -p /home/thot/mono-1.2.3 && \
    mkdir -p /home/thot/PVTCLLibrary && \
    mkdir -p /home/thot/Spirent_Communications/Spirent_TestCenter && \
    mkdir -p /home/thot/Spirent_Communications/Tcl
    
RUN wget http://artifactory.calenglab.spirentcom.com:8081/artifactory/generic-local/THOT/linux/linux_4.96.05.tar && \
    tar -xvf linux_4.96.05.tar && \
    cp -r ./linux_4.96.05/* /home/thot/THoT/ && \
    mkdir -p /home/thot/mono-1.2.3 && \
    tar xvfz ./linux_4.96.05/Mono/RH8/mono1.2.3RH8.tar.gz -C /home/thot/mono-1.2.3 && \
    rm -rf linux_*
