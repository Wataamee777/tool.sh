
---

# 🛠 tool.sh

Linux で使える便利コマンド集です。
今日の記念日・天気予報・為替レートがコマンドで呼び出せます。

---

## 📦 インストール
```
apt install tool
```

または

```
# クローンして実行権限を付与
git clone https://github.com/Wataamee777/tool.sh.git

chmod +x tool

# bin に配置
./tool setup
```

---

## 🚀 使い方

```
tool <command> [options]
```

### コマンド一覧

| コマンド                 | 説明                            |
| -------------------- | ----------------------------- |
| `tool forex <USD> <JPY> [1]`| 為替レートを取得 USD以外にも対応 |
| `tool weather <地域名>` | 天気予報を取得（例: `tool weather 千葉`） |
| `tool today`         | 今日が何の日かを取得                    |
| `tool help`          | コマンド一覧を表示                     |
| `./tool setup`         | toolコマンドを使用可能にするため    |

---

## 🌦 天気APIについて

天気情報は [天気予報 API（livedoor 天気互換）](https://weather.tsukumijima.net/) を利用しています。
地域名から自動で city ID を取得し、予報を表示します。

---

## 💱 為替APIについて

為替情報は [exchangerate.host](https://exchangerate.host) を利用しています。
現在は USD → JPY のみ対応しています。

---

## 📅 今日が何の日

今日の記念日は [WhatIsToday API](https://api.whatistoday.cyou/) を利用しています。

---

