
while read line
do
	temp=${line##*/}
	sample=${temp%-*}
	outdir=$OUTDIR/$sample
	in_file1=$line
	in_file2=${line%R*}R2.fastq.gz
	paired_file1temp=${in_file1##*/}
	paired_file2temp=${in_file2##*/}
	paired_file1=${paired_file1temp%fastq*}clean.fq.gz
	paired_file2=${paired_file2temp%fastq*}clean.fq.gz
	unpaired_file1=${paired_file1temp%fastq*}unpaireq.fq.gz
	unpaired_file2=${paired_file2temp%fastq*}unpaireq.fq.gz
	echo "cd $outdir;/data/apps/jdk/jdk1.8.0_131/bin/java -jar /data/apps/trimmomatic/Trimmomatic-0.36/trimmomatic-0.36.jar PE -threads 1 $in_file1 $in_file2 $paired_file1 $unpaired_file1 $paired_file2 $unpaired_file2 LEADING:20 TRAILING:20 SLIDINGWINDOW:4:20 MINLEN:36;rm $unpaired_file1 $unpaired_file2" >> $Userhome/tri.sh
done <$Userhome/rawfile

