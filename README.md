# dropbox_backup.sh

dropbox_backup.sh was created to backup the entire site. It compresses the site's folders and site SQL dumped information into a single file and uploads it to dropbox.

### Installing

* 1. dropbox_backup.sh requires dropbox_uploader first.
https://github.com/andreafabrizi/Dropbox-Uploader

* 2. create mysql client option file (.dbaccess.cnf)
```
$ touch ~/.dbaccess.cnf
```
.dbaccess.cnf content is as follows.
```
[client]
user = root
password = yourpassword
host = 127.0.0.1
```

* 3. download and execute dropbox_uploader.sh
```
$ git clone https://github.com/kmusiclife/dropbox_backup.sh.git
$ chmod 755 dropbox_backup.sh.git
$ ./dropbox_backup.sh.git
```

## Acknowledgments

Inspiration, code snippets, etc.
* [Dropbox-Uploader](https://github.com/andreafabrizi/Dropbox-Uploader)
* [mysql client option](https://dev.mysql.com/doc/refman/8.0/en/mysql-command-options.html)