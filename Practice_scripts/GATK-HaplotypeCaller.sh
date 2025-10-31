#!/bin/bash
for indir in $INDIR/*
do
	for file in `find  $indir -name "*sort.rmdup.bam"`
	do
		outdir=${indir##*/}
		infile=$file
		temp=${infile##*/}
		outfile_gvcf=${temp%sort*}g.vcf.gz
		echo "source ~/.bashrc;cd $OUTDIR/$outdir;/data/apps/jdk/jdk1.8.0_131/bin/java -Xmx16g -jar /data/apps/gatk/gatk-4.0.5.1/gatk-package-4.0.5.1-local.jar HaplotypeCaller --native-pair-hmm-threads 6 -R $reference -I $infile -O $outfile_gvcf -ERC GVCF --heterozygosity 0.01" >>  /w/00/u/user201/gatk.sh
	done
done
