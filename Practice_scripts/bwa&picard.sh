#!/bin/bash
for indir in $INDIR/*
do
	for file in `find  $indir -name "*R1.clean.fq.gz"`
	do
		outdir=${indir##*/}
		infile_fq_1=$file
		infile_fq_2=${file%R*}R2.clean.fq.gz
		temp=${infile_fq_1##*/}
		temp2=${temp%%_*}
		sample=${temp2%%.*}		
		outfile_sam=$sample.sam
		outfile_bam=$sample.sort.bam
		outfile_bam_stat=${outfile_bam%.*}.stat
		outfile_bam_bai=$sample.sort.bai
		outfile_depth=$sample.depth.txt
		outfile_rmdup=$sample.sort.rmdup.bam
		outfile_rmdup_bai=$sample.sort.rmdup.bai
		outfile_metrics=$sample.metrics
		echo "cd $OUTDIR/$outdir;$BWA mem -t 6 -R '@RG\tID:$sample\tSM:$sample\tLB:$sample' $reference $infile_fq_1 $infile_fq_2 | $SAMTOOLS sort -O BAM -T $sample -l 3 -o $outfile_bam;$SAMTOOLS flagstat $outfile_bam > $outfile_bam_stat;$SAMTOOLS index $outfile_bam $outfile_bam_bai;$SAMTOOLS depth $outfile_bam > $OUTDIR_depth/$outfile_depth;$JAVA -Xmx2500m -jar $PICARD MarkDuplicates INPUT=$outfile_bam OUTPUT=$OUTDIR_picard/$outdir/$outfile_rmdup METRICS_FILE=$OUTDIR_picard/$outdir/$outfile_metrics REMOVE_DUPLICATES=true ASSUME_SORTED=true VALIDATION_STRINGENCY=LENIENT;$SAMTOOLS index $OUTDIR_picard/$outdir/$outfile_rmdup $OUTDIR_picard/$outdir/$outfile_rmdup_bai" >> /w/00/u/user201/bwa_picard.sh
	done
done
