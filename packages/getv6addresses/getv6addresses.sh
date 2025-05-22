PUBLIC_ONLY=false
EUI64_ONLY=false
EXCLUDE_RANGES=false

# Usage function
usage() {
  echo "Usage: $0 [options]" 1>&2
  echo "Options:" 1>&2
  echo "  -p, --public           Public addresses only" 1>&2
  echo "  -e, --eui64            EUI64 addresses only" 1>&2
  echo "  -x, --exclude-ranges   Exclude /{CIDR} from the end of addresses" 1>&2
  echo "  -h, --help             Show this message" 1>&2
  exit 1
}


while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -p|--public)
      PUBLIC_ONLY=true
      shift
      ;;
    -e|--eui64)
      EUI64_ONLY=true
      shift
      ;;
    -x|--exclude-ranges)
      EXCLUDE_RANGES=true
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      usage
      ;;
  esac
done

get_raw_addresses() {
  ip -6 addr show | grep "^\s*inet6" | awk -F'inet6 ' '{ print $2; }' | awk '{ print $1; }'
}

extend_address() {
  ip=$1
  ip_info=$(sipcalc "$ip")
  extended_ip=$(echo -ne "$ip_info" | grep -im1 "Expanded Address" | awk -F'- ' '{ print $2; }')
  range=$(echo "$ip" | cut -d'/' -f2)
  echo -ne "$extended_ip/$range"
}

filter_private() {
  echo -ne "$1" | grepcidr 2000::/3
}

filter_non_eui64() {
  echo -ne "$1" | grep -iE '^.{27}ff:fe'
}

exclude_ranges() {
  echo -ne "$1" | cut -d'/' -f1
}

addresses=""
for ip in $(get_raw_addresses) ; do
  addresses="$(extend_address "$ip")\n$addresses"
done
addresses=$(echo -ne "$addresses" | sed -z 's/\n*$//')

$PUBLIC_ONLY && addresses="$(filter_private "$addresses")"
$EUI64_ONLY && addresses="$(filter_non_eui64 "$addresses")"
$EXCLUDE_RANGES && addresses="$(exclude_ranges "$addresses")"

echo -e "$addresses"
