#!/bin/sh

CMD="$1"
shift

case "$CMD" in
  today)
    DATE="$1"
    [ -z "$DATE" ] && DATE=$(date +"%m%d")
    curl -s "https://api.whatistoday.cyou/index.cgi/v3/anniv/$DATE" \
      | jq -r '[.anniv1, .anniv2, .anniv3, .anniv4, .anniv5] | map(select(length > 0)) | .[]'
    ;;

  weather)
    CITY_NAME="$1"
    [ -z "$CITY_NAME" ] && CITY_NAME="東京"

    # XMLから都市ID取得
    CITY_ID=$(curl -s 'https://weather.tsukumijima.net/primary_area.xml' \
      | xmllint --xpath "string(//city[@title='$CITY_NAME']/@id)" -)

    if [ -z "$CITY_ID" ]; then
      echo "❌ 都市名 $CITY_NAME が見つかりません。県庁所在地にしてみてください。"
      exit 1
    fi

    # 天気API取得
    DATA=$(curl -s "https://weather.tsukumijima.net/api/forecast/city/$CITY_ID")

    # district / city / 今日の天気
    DISTRICT=$(echo "$DATA" | jq -r '.location.district')
    CITY=$(echo "$DATA" | jq -r '.location.city')
    WEATHER=$(echo "$DATA" | jq -r '.forecasts[0].telop')

    echo "🌤 $DISTRICT / $CITY の今日の天気: $WEATHER"
    ;;

forex)
    BASE="$1"
    TARGET="$2"

    if [ -z "$BASE" ] || [ -z "$TARGET" ]; then
        echo "Usage: tool forex <BASE> <TARGET>"
        echo "Example: tool forex USD JPY"
        exit 1
    fi

    RATE=$(curl -s "https://api.exchangerate.host/latest?base=${BASE}&symbols=${TARGET}" \
        | jq -r ".rates.${TARGET}")

    if [ "$RATE" = "null" ] || [ -z "$RATE" ]; then
        echo "Error: Could not fetch exchange rate for ${BASE} -> ${TARGET}"
        exit 1
    fi

    echo "1 ${BASE} = ${RATE} ${TARGET}"
    ;;


setup)
    echo "[*] Setting up tool..."

    # apt があるか確認
    if command -v apt >/dev/null 2>&1; then
        echo "[*] Installing dependencies via apt..."
        apt update -y
        apt install -y curl jq
    else
        echo "[!] apt not found. Please install curl and jq manually."
    fi

    mkdir -p "$HOME/bin"
    cp "$0" "$HOME/bin/tool"
    chmod +x "$HOME/bin/tool"

    if ! echo "$PATH" | grep -q "$HOME/bin"; then
        echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
        echo "[*] Added ~/bin to PATH. Run: source ~/.bashrc"
    fi

    echo "[*] Setup complete! Try: tool help"
    ;;

  help|*)
    echo "Usage: tool <command> [options]"
    echo "Commands:"
    echo "  today [MMDD]     - 今日または指定日付の記念日を表示"
    echo "  weather <都市名> - 今日の天気を district + city 表示"
    echo "  fx <通貨ペア>    - 為替表示（例: USDJPY, EURJPY）"
    echo "  setup            - ~/bin に追加して PATH に登録"
    echo "  help             - このヘルプを表示"
    ;;
esac
