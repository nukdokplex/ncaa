#!/run/current-system/sw/bin/env sh

input=$(echo -e "Power off\nReboot\nSuspend\nHibernate\nLock\nLogout" | fuzzel --dmenu --no-run-if-empty --prompt="What do you want to do?")
[ -z "$input" ] && exit 0

confirmation=$(echo -e "Yes, I'm sure\nNo, don't do that" | fuzzel --dmenu --no-run-if-empty --prompt="Are you sure you want to do that?")
[ "$confirmation" = "Yes, I'm sure" ] || exit 0

case $input in
  "Power off") systemctl poweroff ;;
  "Reboot") systemctl reboot ;;
  "Suspend") systemctl suspend ;;
  "Hibernate") systemctl hibernate ;;
  "Lock") loginctl lock-session ;;
  "Logout") swaymsg exit ;;
esac
