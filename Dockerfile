FROM ghcr.io/pangenome/pggb:latest

RUN apt update  -y

RUN apt-get install -y bash wget r-base-core r-cran-svglite r-cran-upsetr r-cran-optparse r-cran-dendextend r-cran-gplots r-bioc-ctc r-cran-ape ncbi-blast+ ncbi-blast+-legacy roary python3 cd-hit mcl phylip python3-pip libstatistics-linefit-perl bioperl libstatistics-distributions-perl pdf2svg r-cran-heatmaply python3-numpy python3-plotly autoconf libgsl-dev fastani python3-virtualenv cmake samtools curl make g++-11 pybind11-dev libbz2-dev bc libatomic-ops-dev autoconf libgsl-dev zlib1g-dev libzstd-dev libjemalloc-dev libhts-dev build-essential pkg-config time pigz bcftools libcairo2-dev unzip parallel circos gffread trf scoary snakemake

# python packages
RUN pip3 install biopython pandas seaborn xarray
RUN pip install panacota

# R packages
RUN R --quiet --slave -e 'install.packages("micropan", version = "1.3.0", repos="https://cloud.r-project.org/")'
RUN R --quiet --slave -e 'devtools::install_github("KlausVigo/phangorn")'

# nextflow
RUN wget -qO- https://get.nextflow.io | bash
RUN chmod 777 nextflow
RUN cp nextflow /usr/local/bin/nextflow

# BAC genomics
#RUN git clone https://github.com/aleimba/bac-genomics-scripts.git
#RUN cp -rf bac-genomics-scripts /usr/local/bin

# orthofinder
RUN wget https://github.com/davidemms/OrthoFinder/releases/latest/download/OrthoFinder.tar.gz
RUN tar -xzvf OrthoFinder.tar.gz -C /usr/bin/

# prokka
RUN git clone https://github.com/tseemann/prokka.git
RUN cp -rf prokka /usr/bin/
RUN /usr/bin/prokka/bin/prokka --setupdb

# minimap2
RUN git clone https://github.com/lh3/minimap2
RUN cd minimap2 && make
RUN cp -rf minimap2/minimap2 /usr/bin/

# NCBI datasets
RUN curl -o datasets 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/datasets'
RUN chmod +x datasets
RUN cp -rf datasets /usr/bin/

# PanExplorer workflow
RUN git clone https://github.com/SouthGreenPlatform/PanExplorer_workflow.git
RUN cp -rf PanExplorer_workflow /usr/local/bin
RUN wget https://ftp.ncbi.nlm.nih.gov/pub/mmdb/cdd/little_endian/Cog_LE.tar.gz
RUN tar -xzvf Cog_LE.tar.gz -C /usr/local/bin/PanExplorer_workflow/COG


# gfatools
#RUN git clone https://github.com/lh3/gfatools
#RUN cd gfatools && make
#RUN cp -rf gfatools/gfatools /usr/bin/

# minigraph
#RUN git clone https://github.com/lh3/minigraph
#RUN cd minigraph && make
#RUN cp -rf minigraph/minigraph /usr/bin/

# mmseqs
RUN wget https://mmseqs.com/latest/mmseqs-linux-sse41.tar.gz --no-check-certificate
#RUN tar xvfz mmseqs-linux-sse41.tar.gz -C /usr/bin/
#RUN cp -rf mmseqs/bin/mmseqs /usr/bin/



# PHYLIP
#RUN echo "#!/bin/bash" >/usr/bin/consense
#RUN echo "phylip consense $*" >>/usr/bin/consense
#RUN chmod 755 /usr/bin/consense
#RUN echo "#!/bin/bash" >/usr/bin/neighbor
#RUN echo "phylip neighbor $*" >>/usr/bin/neighbor
#RUN chmod 755 /usr/bin/neighbor
#RUN echo "#!/bin/bash" >/usr/bin/seqboot
#RUN echo "phylip seqboot $*" >>/usr/bin/seqboot
#RUN chmod 755 /usr/bin/seqboot
#RUN echo "#!/bin/bash" >/usr/bin/dnadist
#RUN echo "phylip dnadist $*" >>/usr/bin/dnadist
#RUN chmod 755 /usr/bin/dnadist
#RUN echo "#!/bin/bash" >/usr/bin/dnapars
#RUN echo "phylip dnapars $*" >>/usr/bin/dnapars
#RUN chmod 755 /usr/bin/dnapars
#RUN echo "#!/bin/bash" >/usr/bin/dnaml
#RUN echo "phylip dnaml $*" >>/usr/bin/dnaml
#RUN chmod 755 /usr/bin/dnaml


ENV PATH="$PATH:/usr/bin/OrthoFinder:/usr/bin/OrthoFinder/bin:/usr/bin/prokka/bin:/usr/bin/mmseqs/bin/mmseqs"
ENV PANEX_PATH=/usr/local/bin/PanExplorer_workflow
