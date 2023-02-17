function BackupDir {
	
	local -
	set -o pipefail

	inputDir=$(printf $1 | sed 's/\/$//g')
	[ $? -eq 0 ] || return 1
	outName=$(basename $inputDir)
	[ $? -eq 0 ] || return 1
	ext=.tar.bz2.gpg
	outDir=~
	outFile=$outDir/$outName$ext

	tar cj $inputDir | gpg -c --batch --passphrase-fd 1 --passphrase-file /home/keith/.pw > $outFile
	[ $? -eq 0 ] || return 1

	echo $outDir
	echo $outName
	echo $ext
	echo 3
}

function BackupToAws {

	local -
	set -o pipefail

	inputDir=$(printf $1 | sed 's/\/$//g')
	expectedNumberOfVals=3
	#One extra line for the number-of-vals output.
	returnedVals=($(BackupDir $inputDir 2>&1 | tee /dev/tty | tail -n $(( $expectedNumberOfVals + 1)) ))
	[ $? -eq 0 ] || return 1

	#Last element contains number of returned vals.
	if [ ${returnedVals[$(( ${#returnedVals[@]} - 1 ))]} -ne $expectedNumberOfVals ]; then
		echo "code out of sync at $0:$LINENO";
		return 1
	fi

	outDir=${returnedVals[0]}
	outName=${returnedVals[1]}
	ext=${returnedVals[2]}

	permLatestFileName=$outName$ext
	expiringCopyName=ice-$outName-$(date +%Y%m%d)$ext
	[ $? -eq 0 ] || return 1

	bucketUrl=s3://totallyawesomebucket 

	s3cmd put ~/$permLatestFileName $bucketUrl && rm ~/$permLatestFileName
	[ $? -eq 0 ] || return 1
	s3cmd cp $bucketUrl/$permLatestFileName $bucketUrl/$expiringCopyName
	[ $? -eq 0 ] || return 1

}

