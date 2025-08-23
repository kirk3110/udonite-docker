# Udonite Docker

[Udonite](https://github.com/Mafty-Hs/Udonite) を Docker Compose で動かすための環境です。  
MongoDB / Node.js サーバー / Angular クライアント（Nginx 配信）をまとめています。  
MongoDB の自動バックアップ機能も同梱しています。

---

## 構成

- **mongo** : MongoDB 6.0
- **server** : [Udonite Server](https://github.com/Mafty-Hs/Udonite-Server)
- **client** : [Udonite](https://github.com/Mafty-Hs/Udonite) をビルドして Nginx で配信
- **backup** : MongoDB バックアップ用コンテナ（cron で `mongodump` 実行）

---

## セットアップ

### 1. リポジトリ取得
```bash
git clone https://github.com/kirk3110/udonite-docker.git
cd udonite-docker
```

### 2. 環境変数設定
`.env.template` をコピーして `.env` を作成し、必要な値を設定します。
```bash
cp .env.template .env
```

### 3. 起動
```bash
docker compose up -d --build
```
起動後、`.env` の `PUBLIC_URL` に設定したURLにアクセスすることで Udonite を利用できます。

## バージョン更新
```bash
git pull origin main
docker compose up -d --build
```

---

## バックアップ

### 自動バックアップ
* 定期的にMongoDB のデータをバックアップ
* 保存先: `./backups/mongo-YYYY-MM-DD-HHMM.gz`
* 保存周期: `.env` の `BACKUP_CRON` に設定した周期
* 最大保持期間: `.env` の `BACKUP_RETENTION_DAYS` に設定した日数

### 手動バックアップ
```bash
docker exec -it udon-backup /usr/local/bin/backup.sh
ls -lh backups/
# mongo-2025-08-24-0330.gz
# files-2025-08-24-0330.tar.gz
```

### 復元

#### MongoDBの復元
1. Mongo コンテナが起動していることを確認
   ```bash
   docker ps | grep udon-mongo
   ```
2. 最新バックアップから復元
   ```bash
   LATEST=$(ls -1t backups/mongo-*.gz | head -1)
   cat "$LATEST" | docker exec -i udon-mongo sh -lc 'mongorestore --archive --gzip --drop'
   ```
   * --drop を付けると既存DBを削除してから復元します。注意してください。

#### audio/image データの復元
```bash
# 例: 最新の tar アーカイブを展開
LATEST=$(ls -1t backups/files-*.tar.gz | head -1)
tar -xzf "$LATEST" -C /your/path/to/udonite-docker/
```
展開後、`data/audio` と `data/image` が復元されます。

---

## ライセンス
* このリポジトリの Docker 化部分は MIT License です
* [Udonite](https://github.com/Mafty-Hs/Udonite) および [Udonite Server](https://github.com/Mafty-Hs/Udonite-Server) 本体はそれぞれのライセンスに従います
