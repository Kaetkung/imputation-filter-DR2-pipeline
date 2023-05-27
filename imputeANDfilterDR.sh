#!/bin/bash

# Convert .vcf.gz to bfile for QC
./plink --vcf 1000sample.vcf.gz --make-bed --out tempFILE

./plink --bfile tempFILE --list-duplicate-vars ids-only suppress-first

./plink --bfile tempFILE --geno 0.05 --mind 0.05 --maf 0.01 --chr 1-22 --snps-only just-acgt --exclude plink.dupvar --allow-no-sex --nonfounders --recode vcf --out merged_filteredKIT && bgzip merged_filteredKIT.vcf

# Set the input and output file names
input_vcf="merged_filteredKIT.vcf.gz"
output_prefix="merged_filteredKIT_phased_imputed"

# Set the reference panel file prefix
ref_prefix="chr{chr}.1kg.phase3.v5a.b37.bref3"

# Loop through chromosomes 1-22
for chr in {1..22}; do
  echo "Processing Chromosome ${chr}..."

  # Replace {chr} in ref_prefix with the current chromosome number
  current_ref_prefix=$(echo $ref_prefix | sed "s/{chr}/$chr/g")

  # Phase and impute the input VCF file using Beagle
  java -Xmx8g -jar beagle.22Jul22.46e.jar \
    gt=${input_vcf} \
    ref=${current_ref_prefix} \
    out=${output_prefix}_chr${chr} \
    chrom=${chr} \
    nthreads=12
done

# Index files
for chr in {1..22}; do
  bcftools index merged_filteredKIT_phased_imputed_chr${chr}.vcf.gz
done

# Merge imputed VCF files
bcftools concat -Oz -o merged_filteredKIT_phased_imputed.vcf.gz merged_filteredKIT_phased_imputed_chr{1..22}.vcf.gz

# Index the merged VCF file
bcftools index merged_filteredKIT_phased_imputed.vcf.gz

# Filter good quality SNPs
input_vcf="merged_filteredKIT_phased_imputed.vcf.gz"

output_vcf="merged_filteredKIT_phased_imputed_filtered_dr2_05.vcf.gz"
bcftools filter -Oz -i 'INFO/DR2 > 0.5' -o ${output_vcf} ${input_vcf}

output_vcf="merged_filteredKIT_phased_imputed_filtered_dr2_07.vcf.gz"
bcftools filter -Oz -i 'INFO/DR2 > 0.7' -o ${output_vcf} ${input_vcf}

output_vcf="merged_filteredKIT_phased_imputed_filtered_dr2_08.vcf.gz"
bcftools filter -Oz -i 'INFO/DR2 > 0.8' -o ${output_vcf} ${input_vcf}
