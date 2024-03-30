# !/bin/ksh

while getopts ":a" opt; do
  case $opt in
    a)
      show_all=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND - 1))

if [ $# -eq 0 ]; then
  echo "Usage: $0 [-a] name ..."
  exit 1
fi

search_path=$(echo "$PATH" | tr ":" "\n")

found=false

for name in "$@"; do
  while IFS= read -r dir; do
    file_path="$dir/$name"
    if [ -x "$file_path" ]; then
        echo "$file_path"
        found=true
      if [ "$show_all" = false ]; then
        break
      fi
    fi
  done <<< "$search_path"
if [ "$found" = false ]; then
    >&2 echo "$name: Command not found."
fi
done

if [ "$found" = false ]; then
  exit 2
fi

exit 0
