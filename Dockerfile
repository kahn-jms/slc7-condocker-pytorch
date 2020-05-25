FROM nvidia/cuda:10.1-cudnn7-runtime-centos7
#FROM cern/cc7-base:latest

MAINTAINER James Kahn  <james.kahn@kit.edu>
#MAINTAINER Matthias J. Schnepf  <matthias.jochen.schnepf@cern.ch>

# CERN CA
#ADD cerngridca.crt /etc/pki/ca-trust/source/anchors/cerngridca.crt
#ADD cernroot.crt /etc/pki/ca-trust/source/anchors/cernroot.crt
RUN update-ca-trust


ADD repos/UMD-4-updates.repo /etc/yum.repos.d/
ADD repos/egi-trustanchors.repo /etc/yum.repos.d/

ADD http://repository.egi.eu/sw/production/cas/1/GPG-KEY-EUGridPMA-RPM-3 /etc/pki/rpm-gpg/

RUN yum -y update && yum clean all
RUN yum -y groupinstall 'Development Tools' && yum clean all
RUN yum -y install \
ca-policy-egi-core authconfig boost-devel glibc-headers globus-proxy-utils \
globus-gass-copy-progs which \
attr cyrus-sasl-devel e2fsprogs-devel expat-devel \
file-devel giflib-devel gmp-devel gpm-devel kernel-devel libacl-devel \
libattr-devel libcap-devel libcom_err-devel libcurl-devel libdrm-devel \
libdrm-devel libstdc++-devel libuuid-devel libxml2-devel lockdev-devel \
libjpeg-turbo-devel netpbm-devel popt-devel python-devel \
rpm-devel tcl-devel tk-devel openssh-clients PyXML \ 
voms-clients3 wlcg-voms-cms emi-wn \
HEP_OSlibs time tar perl bzip2 gcc freetype glibc-headers glibc-devel \
subversion make gcc gcc-c++ binutils patch wget python python3 libxml2-devel \
libX11-devel libXpm-devel libXft-devel libXext-devel bzip2-devel openssl-devel \
ncurses-devel readline-devel mesa-libGL-devel libgfortran.x86_64 glew-devel \
git krb5-workstation libtool-ltdl lcg-util.x86_64 bc tcsh atlas \
gsl gsl-devel xrootd-client sssd dcap-tunnel-gsi \
libpng-devel \
&& yum clean all

RUN curl -o ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh && \
     #/opt/conda/bin/conda install -y python=$PYTHON_VERSION numpy pyyaml scipy ipython mkl mkl-include ninja cython typing && \
     /opt/conda/bin/conda install -y -c pytorch pytorch torchvision cudatoolkit=10.1 && \
     #/opt/conda/bin/conda install -y -c pytorch magma-cuda100 && \
     /opt/conda/bin/conda clean -ya
ENV PATH /opt/conda/bin:$PATH

# Following is for PyTorch package local install
# This must be done before pip so that requirements.txt is available
#WORKDIR /opt/pytorch
#COPY . .

#RUN git submodule sync && git submodule update --init --recursive
#RUN TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1 7.0+PTX" TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
#    CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
#    pip install -v .

#RUN if [ "$WITH_TORCHVISION" = "1" ] ; then git clone https://github.com/pytorch/vision.git && cd vision && pip install -v . ; else echo "building without torchvision" ; fi

WORKDIR /workspace
RUN chmod -R a+w .
