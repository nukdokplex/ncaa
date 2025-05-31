function power_menu_requester() {
  echo -e "Power off\nReboot\nSuspend\nHibernate\nLock\nLogout"
}

function power_menu_provider() {
  read -r power_command

  case "$power_command" in 
    "Power off") systemctl poweroff ;;
    "Reboot") systemctl reboot ;;
    "Suspend") systemctl suspend ;;
    "Hibernate") systemctl hibernate ;;
    "Lock") loginctl lock-session ;;
    "Logout") loginctl terminate-session ;;
  esac
}

function fuzzel_power_menu() {
  notify_sound dialog-question
  power_menu_requester | fuzzel --dmenu --no-run-if-empty --prompt="What do you want to do?" | power_menu_provider
}

