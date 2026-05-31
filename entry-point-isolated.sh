#!/bin/bash
set -e

check_network_blocked() {
    failures="$(mktemp)"

    logdate() {
        date '+%Y-%m-%d %H:%M:%S'
    }

    check_host() {
        local host="$1"
        local description="$2"
        local port="${3:-80}"

        {
            if ping -c 1 -W 1 "$host" >/dev/null 2>&1; then
                echo "$(logdate) ERROR: $description ($host) is reachable via ICMP." >> "$failures"
            fi
        } &

        {
            if nc -z -w 2 "$host" "$port" >/dev/null 2>&1; then
                echo "$(logdate) ERROR: outbound connectivity exists to $description ($host):$port" >> "$failures"
            fi
        } &
    }

    echo "$(logdate) Checking that outgoing network traffic is blocked..."

    # Internet checks
    check_host 1.1.1.1 "Cloudflare" 80
    check_host 1.1.1.1 "Cloudflare DNS" 53

    # Common local network checks
    check_host 10.0.0.1 "Router" 80
    check_host 10.0.0.2 "Host" 80
    check_host 192.168.0.1 "Router" 80
    check_host 192.168.1.1 "Router" 80

    wait

    if [ -s "$failures" ]; then
        cat "$failures"
        rm -f "$failures"
        echo "$(logdate) Refusing to start service due to unblocked network detected."
        # Slow it down in case it auto restarts
        sleep 5
        exit 1
    fi

    rm -f "$failures"
}

check_network_blocked

echo "$(logdate) Outgoing network block appears active. Starting service..."

exec "$@"