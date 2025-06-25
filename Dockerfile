FROM ghcr.io/pangenome/pggb:latest

RUN apt update  -y

RUN apt-get install -y bash wget r-base-core r-cran-svglite r-cran-upsetr r-cran-optparse r-cran-dendextend r-cran-gplots r-bioc-ctc ncbi-blast+ ncbi-blast+-legacy roary prokka snakemake python3 cd-hit mafft mcl phylip python3-pip libstatistics-linefit-perl bioperl libstatistics-distributions-perl pdf2svg r-cran-heatmaply python3-numpy python3-plotly pipx autoconf libgsl-dev fastani python3-virtualenv cmake samtools curl make g++-11 pybind11-dev libbz2-dev bc libatomic-ops-dev autoconf libgsl-dev zlib1g-dev libzstd-dev libjemalloc-dev libhts-dev build-essential pkg-config time pigz bcftools libcairo2-dev unzip parallel circos multiqc gffread trf scoary


ENV PATH="$PATH:/usr/bin/OrthoFinder:/usr/bin/OrthoFinder/bin"
