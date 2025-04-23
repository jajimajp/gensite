# lighttpd で mod\_openssl が見つからないときの対処法
## 状況

Ubuntu でソースからビルドした lighttpd を利用している状況で[公式ドキュメント](https://redmine.lighttpd.net/projects/lighttpd/wiki/Docs_SSL)に従って TLS/SSL を有効にしようとしたが動かなかった。

journald のログを見ると、/usr/local/lib に mod\_openssl.so が見つからない旨のエラーが出ていた。

## 解決
ビルド時の設定で `--with-openssl` をつけたら動いた:

```sh
MAKE=gmake ./configure -C --with-openssl
```
