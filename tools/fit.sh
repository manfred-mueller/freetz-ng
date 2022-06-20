#!/bin/bash
# fitimg unpacker & scanner
# uses: fdtdump dtc fdtget dumpimage and diff
MYPWD="$(dirname $(realpath $0))"
TOOLS_DIR="$MYPWD/tools"

# $1: .itb-file to scan
# $2: create kernel/filesystem/kernel-args links in this dir
analyze() {
	local PART COUNT=0 FILE="$1" LINK="$2"
	KPART= FPART= KTYPE= FTYPE= KNAME= FNAME= XARGS=
	for PART in $($TOOLS_DIR/fdtget $FILE /images -l); do
		let COUNT++
		[ "${PART/TZ_HW/}" != "$PART" ] && continue # TrustZone
		[ "${PART/_HW0/}"  != "$PART" ] && continue # other CPU
		[ "${PART/HW273/}" != "$PART" ] && continue # also 5590
		TYPE="$($TOOLS_DIR/fdtget $FILE /images/$PART 'type')"
		[ "$TYPE" == "flat_dt"  ] && continue
		if   [ "$TYPE" == "filesystem" -o "$TYPE" == "ramdisk" ]; then
			FPART="$COUNT"; FTYPE="$TYPE"; FNAME="$PART"; XARGS="$($TOOLS_DIR/fdtget $FILE /images/$PART 'avm,kernel-args' 2>/dev/null)"
		elif [ "$TYPE" == "kernel"     -o "$TYPE" == "avm,fit" ]; then
			KPART="$COUNT"; KTYPE="$TYPE"; KNAME="$PART"
		else
			echo "TYPE unknown: $TYPE"; return 1
		fi
	done

	if [ -n "$LINK" ]; then
		echo -n "$XARGS" > "$LINK/args.txt"
		$TOOLS_DIR/fdtget "$FILE" / 'timestamp' > "$LINK/date.txt"
		# root
		[ $FPART -le 9 ] && image="image.00$FPART" || image="image.0$FPART"
		echo -n "$image"  >  "$LINK/filesystem.txt"
		mv "$LINK/$image" "$LINK/filesystem.image"
		ln -s "filesystem.image" "$LINK/$image"
		# kern
		[ $KPART -le 9 ] && image="image.00$KPART" || image="image.0$KPART"
		echo -n "$image"  >  "$LINK/kernel.txt"
		mv "$LINK/$image" "$LINK/kernel.image"
		ln -s "kernel.image" "$LINK/$image"
	fi
}

# $1: source file to unpack
# $2: destination dir
unpack() {
	local c='0' FILE="$1" OUTP="${2:-.}"
	[ ! -e "$FILE" ] && echo "File $FILE does not exist" && exit 1
	mkdir -p "$OUTP"
	$MYPWD/yf/fit_tools/fit-remove-avm-header.sh "$FILE" > "$OUTP/image.itb" 2>/dev/null || cat "$FILE" > "$OUTP/image.itb"
	FILE="$OUTP/image.itb"
	$TOOLS_DIR/dtc -I dtb -O dts "$FILE" | tee "$OUTP/image.dts" | sed "s/^[ \t]*data = .*/XDATAXSEQUENCEX/g" > "$OUTP/image.its"
	[ ! -s  "$OUTP/image.its" ] && rm -f "$OUTP"/image.* && exit 1
	while grep -q "XDATAXSEQUENCEX" "$OUTP/image.its"; do
		[ $c -lt 9 ] && image="image.00$(($c+1))" || image="image.0$(($c+1))"
		sed "0,/XDATAXSEQUENCEX/s//\t\t\tdata = \/incbin\/(\"$image\");/" -i "$OUTP/image.its"
		$TOOLS_DIR/dumpimage "$FILE" -T flat_dt -p $c -o "$OUTP/$image" >/dev/null
		let c++
	done
	analyze "$FILE" "$OUTP"
}

# $1: directory wiht *.itb to scan
scandir() {
	local DIR="${1:-.}"
	for FILE in $DIR/*; do
		[ -d "$FILE" ] && continue
		echo -e "\n ## $FILE"
		analyze "$FILE"
		[ -n "$FNAME$KNAME$XARGS" ] || continue
		                   echo -e "filesystem   $FNAME"
		                   echo -e "kernel       $KNAME"
		[ -n "$XARGS" ] && echo -e "kernel-args  $XARGS"
	done
}

# main
case "$1" in
	u|unpack)	unpack  "$2" "$3" ;;
	s|scandir)	scandir "$2"      ;;
	o|original)	$TOOLS_DIR/fdtdump $MYPWD/../build/original/fit-image/image.itb | grep -vE 'data = ' ;;
	m|modified)	$TOOLS_DIR/fdtdump $MYPWD/../build/modified/fit-image/image.itb | grep -vE 'data = ' ;;
	d|diff)		diff -Naur \
			  <($TOOLS_DIR/dtc -I dtb -O dts $MYPWD/../build/o*/fit-image/image.itb | grep -vE 'data = |^$') \
			  <($TOOLS_DIR/dtc -I dtb -O dts $MYPWD/../build/m*/fit-image/image.itb | grep -vE 'data = |^$')
			;;
	*)		echo "Usage: $0 <unpack|scandir|original|modified|diff>" ;;
esac


