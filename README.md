# PerlTask

### 1. Разбор лога.
Запуск:
> perl LogParser.pl --database database_name --user user_name --password user_password --file log_file

По умолчанию используются параметры database=maillog user=task password=task_password file=out
- Использована база данный mysql, в репозитории представлен файл schema.sql со схемой таблиц.
- Встретившиеся строки лога, соответствующие входящему сообщению, и не содержащие значения id, были проигнорированы. В задании о них не было сказано, а id является первичным ключом, что не опзволяет рассматривать строки без него.

### 2. Отображение html-страницы.
Запуск:
> perl LogSearcher.pl --database database_name --user user_name --password user_password

После запуска в браузере форму поиска по логам можно будет увидеть по адресу http://localhost:3000.
