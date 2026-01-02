if [ $# -ne 2 ]; then
  echo "no arguments specified, but expected 2: filename and path, stop is optional" 1>&2
  exit 2
fi

FILENAME="${1%/}"
SEARCHPATH="${2%/}"
STOP="/"

if [ $# -eq 3 ]; then
  STOP="${3%/}"
fi

dir="$SEARCHPATH"

while [[ "$dir" != "/" && "$dir" != "$STOP" ]]; do
  if [[ -f "$dir/$FILENAME" ]]; then
    exit 0 # file was found
  fi
  dir="$(dirname "$dir")"
done
exit 1 # file wasn't found
