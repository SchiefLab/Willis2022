# Willis _et al_ - Data Analysis

This repository contains instructions for obtaining the Next-Generation Sequencing (NGS) raw reads as well as post-production formatted sequencing data used in [Willis _et al_., _Immunity_ 10.1126/aax4380 (2022)]().

In addition, this repository contains an example [JupyterNotebooks](https://zeppelin.apache.org/) notebook containing [PySpark](https://spark.apache.org/docs/0.9.0/python-programming-guide.html) code used to execute searches on the sequencing data.

## Raw Sequencing Reads

Paired reads for NextSeq and HiSeq sequencing data obtained in this study are available for download from our publicly available Amazon Web Services S3 data bucket found [here](https://steichenetalpublicdata.s3-us-west-2.amazonaws.com/raw_sequences/paired_reads.tgz). Paired reads from HiSeq sequencing data from [Briney _et al_, Nature 2019](https://www.ncbi.nlm.nih.gov/pubmed/30664748) that were used in Steichen et al are also available in our S3 data bucket using the above link.

## Joined, Annotated, and Clustered Sequences

Beyond the raw reads, we are also making available the joined, annotated and clustered sequences, as a compressed csv file. It is these sequences that were analyzed in the manuscript. You may use your own database framework to analyze the clustered sequences in the csv file.

The compressed csv file is available for download [here](https://steichenetalpublicdata.s3-us-west-2.amazonaws.com/analyzed_sequences/AllDataMerged.csv.gz).

**Caution - the compressed csv file is 100 GB while the uncompressed file is over 700GB**

In addition, we are also providing all the sequences in the csv file as a converted parquet file which is more convenient for those that wish to carry out analyses using Amazon EMR (see below), as we did in this study. The compressed parquet file can be found at [here](https://steichenetalpublicdata.s3-us-west-2.amazonaws.com/analyzed_sequences/parquet.gz). Instructions for loading and querying parquet files are found below.

The fields in the csv file include the following annotations from [AbStar](https://github.com/briney/abstar) as well as several clustering and other metadata fields.

### Abstar Annotations

| Name     |                    Description                    |
| -------- | :-----------------------------------------------: |
| \_id     |                hash id of sequence                |
| chain    |                  heavy or light                   |
| cdr3_aa  |     CDR3 amino acid sequence, IMGT definition     |
| cdr3_nt  |     CDR3 amino acid sequence, IMGT definition     |
| junct_nt | Junctional nucleotide sequence as defined by IMGT |
| isotype  |       Antibody Isotype, e.g. IgM, IgG etc..       |
| vdj_aa   |  The V,D and J gene segment amino acid sequences  |
| vdj_nt   |  The V,D and J gene segment nucleotide sequences  |
| v_full   |  The full V gene segment name, e.g. IGHV1-69\*01  |
| v_fam    |       The V gene segment family, e.g. IGHV1       |
| v_gene   |         The V gene segment, e.g. IGHV1-69         |
| d_full   |  The full D gene segment name, e.g. IGHD3-3\*01   |
| d_fam    |       The D gene segment family, e.g. IGHD3       |
| d_gene   |         The D gene segment, e.g. IGHD3-3          |
| j_full   |   The full J gene segment name, e.g. IGHJ6\*01    |
| j_gene   |          The J gene segment, e.g. IGHJ6           |

### Clustering Metadata

| Name                |                             Description                              |
| ------------------- | :------------------------------------------------------------------: |
| donor               |             The de-identified donor id, e.g donor_316188             |
| collection          |    The demultiplexed technical replicate collection specification    |
| generation          |                 The sequencing generation, see below                 |
| method              |         The sequencing platform used, e.g. HiSeq, see below          |
| ez_donor            |              An integer based designation of the donor               |
| unique_donors       | How many unique donors this sequence cluster was found in, see below |
| unique_mRNA         |  How many mRNA transcripts were found across replicates, see below   |
| original_cursor     |                       Legacy field, not needed                       |
| original_collection |                       Legacy field, not needed                       |

### Method

The method designation is either HiSeq, NextSeq or Clustered HiSeq (cHiSeq).

### Generation

Generations correspond to the the sequencing generation as obtained during the course of the study. Generation 1 was the first four donors which were run through multiple independent HiSeq and NextSeq runs. Generation 2 is the next 8 donors in which a unique molecular identifier (UMI) was used to group PCR bias before HiSeq. Generation 3 was the last two donors using HiSeq and UMIs.

### Unique mRNA

The Unique mRNA corresponds to the number of times a sequence was found in the same donor but in multiple collections. Each collection corresponds to an individual PCR reaction from different mRNA preps.

# Setting up AWS EMR

While we have provided the sequencing data via formatted csv and raw sequencing reads to enable the user to employ their own sequence analysis pipelines, we found that a managed Hadoop cluster via Spark was an effective database implementation that could handle the large datasets with relatively low overhead.

We recommend [Amazon Web Services Elastic Map Reduce (EMR) service](https://aws.amazon.com/emr/) which has the option to automatically setup a managed [Spark Cluster](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-spark.html). AWS has the added convenience of allowing the user you to designate the amount of worker nodes. More nodes means faster queries but will have a higher cost.

To setup an AWS EMR cluster, you can use the command line in this repo `start_cli.sh`. However, there are several caveats. The security groups `sg-xxxx` and subnet `subnet-xxxx` need to changes to your own security groups and subnet. You can find these by going to the EC2 console and selecting the security groups and subnets you wish to use. You can also use the AWS CLI to find these values.

If you don't wish to use the `AWS CLI`, you can use the AWS EMR Console to setup the cluster. We use the following settings:

### Release: EMR-6.7.0

including:

- JupyterHub
- JupyterEnterpriseGateway
- os-release-label: 2.0.20220606.1

We recommend 1 main node (`m5.xlarge`) and 10 worker nodes (`m5.2xlarge`). The subnets and security groups will automatically be created. You can then use the Notebooks option from the EMR console. You can then import our notebook [V2ApexFrequency.ipynb](V2ApexFrequency.ipynb) and run the queries as is.
