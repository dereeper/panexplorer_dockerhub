FROM ghcr.io/pangenome/pggb:latest

RUN apt update  -y

RUN apt-get install -y bash wget r-base-core r-cran-svglite r-cran-upsetr r-cran-optparse r-cran-dendextend r-cran-gplots r-bioc-ctc ncbi-blast+ ncbi-blast+-legacy roary python3 cd-hit mcl phylip python3-pip libstatistics-linefit-perl bioperl libstatistics-distributions-perl pdf2svg r-cran-heatmaply python3-numpy python3-plotly autoconf libgsl-dev fastani python3-virtualenv cmake samtools curl make g++-11 pybind11-dev libbz2-dev bc libatomic-ops-dev autoconf libgsl-dev zlib1g-dev libzstd-dev libjemalloc-dev libhts-dev build-essential pkg-config time pigz bcftools libcairo2-dev unzip parallel circos gffread trf scoary 

RUN pip3 install biopython pandas seaborn xarray


RUN R --quiet --slave -e 'devtools::install_github("KlausVigo/phangorn")'

# prokka
RUN git clone https://github.com/tseemann/prokka.git
RUN cp -rf prokka /usr/bin/
RUN /usr/bin/prokka/bin/prokka --setupdb

# minimap2
RUN git clone https://github.com/lh3/minimap2
RUN cd minimap2 && make
RUN cp -rf minimap2/minimap2 /usr/bin/

RUN curl -o datasets 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/datasets'
RUN chmod +x datasets
RUN cp -rf datasets /usr/bin/

RUN git clone https://github.com/lh3/gfatools
RUN cd gfatools && make
RUN cp -rf gfatools/gfatools /usr/bin/

RUN git clone https://github.com/lh3/minigraph
RUN cd minigraph && make
RUN cp -rf minigraph/minigraph /usr/bin/


ENV PATH="$PATH:/usr/bin/OrthoFinder:/usr/bin/OrthoFinder/bin:/usr/bin/prokka/bin"
