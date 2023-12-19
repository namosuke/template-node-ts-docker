# template-node-ts-docker

Node.js、TypeScript、Docker のテンプレート

## 使い方

### ファイル名を指定して実行

```sh
pnpm ts src/index.ts
```

### 開発用に起動

```sh
pnpm dev
```

### 本番用に起動

```sh
pnpm build
pnpm start
```

### Docker

一時的に起動したい場合

```sh
docker build -t project-name . && docker run --rm -it --env-file .env -p 3000:3000 project-name
```

ビルド

```sh
docker build -t project-name .
```

デバッグしたい場合

```sh
docker run --rm -it project-name
```

実行し続ける場合

```sh
docker run -it -d --restart always --env-file .env -p 3000:3000 project-name
```

## 環境変数について

`.env`ファイルがあれば、`process.env.DATABASE_URL`のような書き方で値を読み込めます。
