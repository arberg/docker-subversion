mapfile -t SERVICES < <(docker compose config --services)

if (( ${#SERVICES[@]} != 1 )); then
    echo "Expected exactly one service; found ${#SERVICES[@]}" >&2
    exit 1
fi

docker compose exec -T "${SERVICES[0]}" cat /var/log/svn.log
