# imputation-filter-DR2-pipeline
This script used for dna imputation and filter hight quality snps

Overview
This script is a comprehensive solution for conducting quality control (QC) on Variant Call Format (VCF) files, phasing, imputing, and filtering of good quality Single Nucleotide Polymorphisms (SNPs). It uses a variety of bioinformatics tools such as PLINK, Beagle, and bcftools to conduct the various steps involved in this process.
Requirements

Ensure the following tools are installed on your system:
    PLINK
    bcftools
    Beagle
    Java Runtime Environment (JRE)

Input Files
To run this script, make sure you have the following files in your current directory:

    - 1000sample.vcf.gz: The initial compressed VCF file containing the genetic data.

    - chr{chr}.1kg.phase3.v5a.b37.bref3: The reference panel files for each chromosome used in phasing with Beagle. These should be named for each chromosome (chr1.1kg.phase3.v5a.b37.bref3, chr2.1kg.phase3.v5a.b37.bref3, etc.).

Usage
To execute the script, save it in a .sh file and provide execute permission. This can be done with the following commands:

bash
- $ chmod +x scriptname.sh
- $ ./scriptname.sh

Replace scriptname.sh with your actual script filename.
Output
The output of this script includes:

    - merged_filteredKIT.vcf.gz: The initial filtered VCF file.

    - merged_filteredKIT_phased_imputed_chr{chr}.vcf.gz: For each chromosome, a corresponding phased and imputed VCF file will be created.

    - merged_filteredKIT_phased_imputed.vcf.gz: The final merged VCF file, which is a combination of the phased and imputed VCF files for each chromosome.

    - merged_filteredKIT_phased_imputed_filtered_dr2_XX.vcf.gz: This script also produces filtered VCF files based on different levels of dosage r-squared (DR2) values (0.5, 0.7, 0.8), a measure of imputation quality.

Note
This script is tailored for a very specific bioinformatics workflow and assumes familiarity with the used tools and principles. If you're encountering problems or have questions about the specific steps, it's recommended to refer to the documentation of the respective tools: PLINK, bcftools, and Beagle.
