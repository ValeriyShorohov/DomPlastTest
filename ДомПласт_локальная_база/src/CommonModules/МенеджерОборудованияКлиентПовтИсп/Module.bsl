
#Область ПрограммныйИнтерфейс

// Функция возвращает объект обработчика драйвера по его наименованию.
// 
// Параметры:
// 	ОбработчикДрайвера
// 	ЗагружаемыйДрайвер
// 	ТипОборудованияИмя
// Возвращаемое значение:
// 	
Функция ПолучитьОбработчикДрайвера(ОбработчикДрайвера, ЗагружаемыйДрайвер, ТипОборудованияИмя) Экспорт
	
	Возврат МенеджерОборудованияКлиентПереопределяемый.ПолучитьОбработчикДрайвера(ОбработчикДрайвера, ЗагружаемыйДрайвер, ТипОборудованияИмя);
	   
КонецФункции

// Функция возвращает список подключенного в справочнике ПО
// 
// Параметры:
// 	ТипыПО - Неопределено - Описание.
// 	Идентификатор - Неопределено - Описание.
// 	РабочееМесто - Неопределено - Описание.
// Возвращаемое значение:
// Массив из Структура - содержит:
// *Наименование - Строка - .
Функция ОборудованиеПоПараметрам(ТипыПО = Неопределено, Идентификатор = Неопределено, РабочееМесто = Неопределено) Экспорт

	Возврат МенеджерОборудованияВызовСервера.ОборудованиеПоПараметрам(ТипыПО, Идентификатор, РабочееМесто);

КонецФункции

// Возвращает структуру параметров конкретного экземпляра устройства.
// При первом обращении получает из БД сохраненные ранее параметры.
Функция ПолучитьПараметрыУстройства(Идентификатор) Экспорт

	Возврат МенеджерОборудованияВызовСервера.ПолучитьПараметрыУстройства(Идентификатор);

КонецФункции

// Функция возвращает структуру с данными устройства
// (со значениями реквизитов элемента справочника).
// 
// Параметры:
// 	Идентификатор - СправочникСсылка.ПодключаемоеОборудование - .
// Возвращаемое значение:
// 	Структура - Описание:
// *ОбработчикДрайвераИмя - Строка - имя драйвера.
// *ОбработчикДрайвера - Строка - обработчик драйвера. 
// *ИмяКомпьютера - Строка - наименование компьютера. 
// *РабочееМесто - СправочникСсылка.РабочиеМеста - рабочее место.
// *Параметры - Структура - структура с полями:
// **ДатаНачала - Дата - .
// **ДатаОкончания - Дата - .
// **ПериодВыгрузки - Структура - структура с полями:
// ***ДатаНачала - Дата - дата начала загрузки.
// ***ДатаОкончания - Дата - дата окончания загрузки. 
// *ИмяФайлаДрайвера - Строка - имя файла драйвера.
// *ИмяМакетаДрайвера - Строка - имя макета драйвера.
// *ПоставляетсяДистрибутивом - Булево - признак поставки дистрибутивом.
// *ИдентификаторОбъекта - Строка - идентификатор объекта строкой.
// *ВСоставеКонфигурации - Булево - признак поставке в составе конфигурации.
// *ДрайверОборудованияИмя - Строка - драйвер оборудования строкой.
// *ДрайверОборудования - СправочникСсылка.ДрайверОборудования - драйвер оборудования.
// *ТипОборудованияИмя - Строка - тип опоборудования строкой.
// *ТипОборудования - ПеречислениеСсылка.ТипыПодключаемогоОборудования - тип оборудования.
// *Наименование - Строка - наименование оборудования.
// *ИдентификаторУстройства - Строка - идентификатор устройства.
// *Ссылка - СправочникСсылка.ПодключаемоеОборудование - экземпляр подключаемого оборудования.
//
Функция ПолучитьДанныеУстройства(Идентификатор) Экспорт

	Возврат МенеджерОборудованияВызовСервера.ПолучитьДанныеУстройства(Идентификатор);

КонецФункции

// Возвращает имя компьютера клиента.
// При первом обращении получает имя компьютера из переменной сеанса.
Функция ПолучитьРабочееМестоКлиента() Экспорт

	Возврат МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();

КонецФункции

// Возвращает имя компьютера клиента.
// При первом обращении получает имя компьютера из переменной сеанса.
Функция НайтиРабочиеМестаПоИД(ИдентификаторКлиента) Экспорт

	Возврат МенеджерОборудованияВызовСервера.НайтиРабочиеМестаПоИД(ИдентификаторКлиента);

КонецФункции

// Возвращает Истина, если клиентское приложение запущено под управлением ОС Linux.
//
Функция ЭтоLinuxКлиент() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	
	ЭтоLinuxКлиент = СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86
	             ИЛИ СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86_64;
	
	Возврат ЭтоLinuxКлиент;
	
КонецФункции

// Получает ревизию требований для драйверов подключаемого оборудования.
//
Функция РевизияИнтерфейсаДрайверов() Экспорт
	
	Возврат МенеджерОборудованияВызовСервера.РевизияИнтерфейсаДрайверов();
	
КонецФункции

// Получить код типа расчета денежными средствами.
// 
Функция КодРасчетаДенежнымиСредствами(ТипРасчета) Экспорт
	
	Возврат МенеджерОборудованияКлиентСервер.КодРасчетаДенежнымиСредствами(ТипРасчета);
	
КонецФункции

// Возвращает Истина, если "функциональная" подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// У "функциональной" подсистемы снят флажок "Включать в командный интерфейс".
//
// Параметры:
//  ПолноеИмяПодсистемы - Строка - полное имя объекта метаданных подсистема
//                        без слов "Подсистема." и с учетом регистра символов.
//                        Например: "СтандартныеПодсистемы.ВариантыОтчетов".
//
// Пример:
//
//  Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
//  	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
//  	МодульВариантыОтчетов.<Имя метода>();
//  КонецЕсли;
//
// Возвращаемое значение:
//  Булево.
//
Функция ПодсистемаСуществует(ПолноеИмяПодсистемы) Экспорт
	
	Возврат МенеджерОборудованияВызовСервера.ПодсистемаСуществует(ПолноеИмяПодсистемы);
	
КонецФункции

// Возвращает Истина, если используется подсистемы фискальных устройств и эти подсистемы существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// У хотя бы одной "функциональной" подсистемы включен флажок "Включать в командный интерфейс".
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяПодсистемыФискальныхУстройств() Экспорт
	
	Возврат МенеджерОборудованияВызовСервера.ИспользуетсяПодсистемыФискальныхУстройств();
	
КонецФункции

// Возвращает ссылку на общий модуль по имени.
//
// Параметры:
//  Имя          - Строка - имя общего модуля, например:
//                 "ОбщегоНазначения",
//                 "ОбщегоНазначенияКлиент".
//
// Возвращаемое значение:
//  ОбщийМодуль.
//
Функция ОбщийМодуль(Имя) Экспорт
	
	Попытка
		Модуль = Вычислить(Имя);
	Исключение
		Модуль = Неопределено;
	КонецПопытки;
	
	Если ТипЗнч(Модуль) <> Тип("ОбщийМодуль") Тогда
		ВызватьИсключение СтрЗаменить(НСтр("ru = 'Общий модуль ""%1"" не найден.'"), "%1", Имя);
	КонецЕсли;
	
	Возврат Модуль;
	
КонецФункции

#КонецОбласти