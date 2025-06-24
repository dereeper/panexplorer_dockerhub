FROM ghcr.io/pangenome/pggb:latest

RUN apt update  -y

RUN apt-get install -y bash wget r-base-core r-cran-svglite r-cran-upsetr r-cran-optparse r-cran-dendextend r-cran-gplots r-bioc-ctc ncbi-blast+ ncbi-blast+-legacy roary prokka snakemake python3 cd-hit mafft mcl phylip python3-pip libstatistics-linefit-perl bioperl libstatistics-distributions-perl pdf2svg r-cran-heatmaply python3-numpy python3-plotly pipx autoconf libgsl-dev fastani python3-virtualenv cmake samtools curl make g++-11 pybind11-dev libbz2-dev bc libatomic-ops-dev autoconf libgsl-dev zlib1g-dev libzstd-dev libjemalloc-dev libhts-dev build-essential pkg-config time pigz bcftools libcairo2-dev unzip parallel circos multiqc gffread trf scoary


RUN pip3 install biopython pandas seaborn xarray

RUN pip3 install git+https://github.com/microbial-bioinformatics/prokka.git

RUN git clone https://github.com/pangenome/pggb.git
RUN sed -i "s/which time/\/usr\/bin\/which time/g" pggb/pggb
RUN cp pggb/pggb /usr/local/bin/pggb # buildkit
RUN chmod 777 /usr/local/bin/pggb # buildkit
RUN cp pggb/partition-before-pggb /usr/local/bin/partition-before-pggb # buildkit
RUN chmod a+rx /usr/local/bin/partition-before-pggb # buildkit

RUN wget -qO- https://get.nextflow.io | bash
RUN chmod 777 nextflow
RUN cp nextflow /usr/local/bin/nextflow

RUN git clone https://github.com/aleimba/bac-genomics-scripts.git
RUN cp -rf bac-genomics-scripts /usr/local/bin

RUN R --quiet --slave -e 'install.packages("micropan", version = "1.3.0", repos="https://cloud.r-project.org/")'

RUN R --quiet --slave -e 'devtools::install_github("KlausVigo/phangorn")'

RUN wget http://downloads.sourceforge.net/project/pgap/PGAP-1.2.1/PGAP-1.2.1.tar.gz
RUN tar -xzvf PGAP-1.2.1.tar.gz
RUN cp -rf PGAP-1.2.1 /usr/local/bin
RUN sed -i "s/\/home\/zhaoyb\/work\/PGAP\/PGAP\/Programs\/ExtraBin\/mcl/\/usr\/bin\/mcl/g" /usr/local/bin/PGAP-1.2.1/PGAP.pl
RUN sed -i "s/\/home\/zhaoyb\/work\/PGAP\/PGAP\/Programs\/ExtraBin\//\/usr\/bin\//g" /usr/local/bin/PGAP-1.2.1/PGAP.pl
RUN sed -i "s/\/share\/ibm-1\/bin\//\/usr\/bin\//g" /usr/local/bin/PGAP-1.2.1/PGAP.pl

RUN wget https://github.com/davidemms/OrthoFinder/releases/latest/download/OrthoFinder.tar.gz
RUN tar -xzvf OrthoFinder.tar.gz
RUN cp -rf OrthoFinder /usr/bin/

# minimap2
RUN git clone https://github.com/lh3/minimap2
RUN cd minimap2 && make
RUN cp -rf minimap2 /usr/bin/

#RUN git clone https://github.com/gpertea/gffread
#RUN cd gffread
#RUN make release
#RUN cp -rf gffread /usr/bin/

RUN curl -o datasets 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/datasets'
RUN chmod +x datasets
RUN cp -rf datasets /usr/bin/

RUN wget http://github.com/bbuchfink/diamond/releases/download/v2.1.8/diamond-linux64.tar.gz
RUN tar xzf diamond-linux64.tar.gz
RUN cp -rf ./diamond /usr/bin/OrthoFinder/bin/

RUN git clone https://github.com/SouthGreenPlatform/PanExplorer_workflow.git

ENV PANEX_PATH=/usr/local/bin/PanExplorer_workflow
RUN cp -rf PanExplorer_workflow /usr/local/bin
RUN wget https://ftp.ncbi.nlm.nih.gov/pub/mmdb/cdd/little_endian/Cog_LE.tar.gz
RUN tar -xzvf Cog_LE.tar.gz
RUN cp -rf Cog.* $PANEX_PATH/COG

RUN echo "#!/bin/bash" >/usr/bin/consense
RUN echo "phylip consense $*" >>/usr/bin/consense
RUN chmod 755 /usr/bin/consense
RUN echo "#!/bin/bash" >/usr/bin/neighbor
RUN echo "phylip neighbor $*" >>/usr/bin/neighbor
RUN chmod 755 /usr/bin/neighbor
RUN echo "#!/bin/bash" >/usr/bin/seqboot
RUN echo "phylip seqboot $*" >>/usr/bin/seqboot
RUN chmod 755 /usr/bin/seqboot
RUN echo "#!/bin/bash" >/usr/bin/dnadist
RUN echo "phylip dnadist $*" >>/usr/bin/dnadist
RUN chmod 755 /usr/bin/dnadist
RUN echo "#!/bin/bash" >/usr/bin/dnapars
RUN echo "phylip dnapars $*" >>/usr/bin/dnapars
RUN chmod 755 /usr/bin/dnapars
RUN echo "#!/bin/bash" >/usr/bin/dnaml
RUN echo "phylip dnaml $*" >>/usr/bin/dnaml
RUN chmod 755 /usr/bin/dnaml

RUN wget https://mmseqs.com/latest/mmseqs-linux-sse41.tar.gz --no-check-certificate
RUN tar xvfz mmseqs-linux-sse41.tar.gz
RUN cp -rf mmseqs/bin/mmseqs /usr/bin/

#RUN export PIPX_HOME=/opt/pipx
#RUN export PIPX_BIN_DIR=/usr/local/bin
RUN pip install panacota

RUN git clone https://github.com/lh3/gfatools
RUN cd gfatools && make
RUN cp -rf  gfatools /usr/bin/

RUN git clone https://github.com/lh3/minigraph
RUN cd minigraph && make
RUN cp -rf minigraph /usr/bin/

ENV PATH="$PATH:/usr/bin/OrthoFinder:/usr/bin/OrthoFinder/bin"
