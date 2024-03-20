# Goaccess
- фильтрую по коду ответа в веб версии командой

_goaccess -f ../04/*.log --sort-panel=STATUS_CODES,BY_DATA,ASC --log-format=COMBINED -o report.html_

![сортировка_по_коду_ответа_веб](images/1.png)

- в терминале командой (сортировка намеренно выбрана в обратную сторону)

_goaccess -f ../04/*.log --sort-panel=STATUS_CODES,BY_DATA,DESC_

![сортировка_по_коду_ответа_терминал](images/2.png)

___
- все уникальные ip

_goaccess -f ../04/*.log --log-format=
COMBINED -o report.html_

![в_веб_интерфейсе](images/3.png)

_goaccess -f ../04/*.log_

![в_веб_терминале](images/4.png)

___

- просмотр только кодов с ошибкой

![в_веб_интерфейсе](images/5.png)

- в терминале

![в терминале]

![в_веб_интерфейсе](images/6.png)

___

