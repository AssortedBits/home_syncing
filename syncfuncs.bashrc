function Backup {

	local -
	set -o pipefail

	inputItem=$(printf $1 | sed 's/\/$//g')
	[ $? -eq 0 ] || return 1
	if [ -z "$inputItem" ]; then
		echo "empty arg 'inputItem' at $0:$LINENO" >&2
	fi

	archiveOpt=$2
	snapshotOpt=$3

	outName=$(basename $inputItem)
	[ $? -eq 0 ] || return 1

	readFileCmd=
	if [ -d "$inputItem" ]; then
		readFileCmd="tar c"
		outName=$outName"".tar
	else
		readFileCmd="cat"
	fi

	archiveFileCmd=
	case "$archiveOpt" in
		asIs)
			;;
		compressedAndEncrypted)
			archiveFileCmd="$archiveFileCmd | bzip2 -c"
			outName=$outName"".bz2
			;& #fall through
		encrypted)
			archiveFileCmd="$archiveFileCmd | gpg -c --batch --passphrase-fd 1 --passphrase-file /home/keith/.pw"
			outName=$outName"".gpg
			;;
		*)
			echo "invalid value '$encryptedOrPlaintext' for 'encryptedOrPlaintext' param at $0:$LINENO" >&2
			return 1
			;;
	esac

	s3BucketUrl=s3://totallyawesomebucket 
	sendToBackupCmd=" | s3cmd put - $s3BucketUrl/$outName"

	cmd="$readFileCmd $inputItem $archiveFileCmd $sendToBackupCmd"
	#read -p "$cmd ?"
	eval "$cmd"
	[ $? -eq 0 ] || return 1
	
	case "$snapshotOpt" in
		withSnapshot)
			snapshotName=ice-$(date +%Y%m%d)-$outName
			[ $? -eq 0 ] || return 1
			s3cmd cp $s3BucketUrl/"$outName" $s3BucketUrl/"$snapshotName"
			[ $? -eq 0 ] || return 1
			;;
		noSnapshot)
			;;
		*)
			echo "invalid value '$snapshotOpt' for param 'snapShotOpt' at $0:$LINENO"
			;;
	esac
	
}

