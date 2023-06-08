#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьМассивПодчиненныхКонтрагентов(ГоловнойКонтрагент) Экспорт
	
	МассивКонтрагентов	= Новый Массив;
	
	Если НЕ ЗначениеЗаполнено(ГоловнойКонтрагент) Тогда
		Возврат МассивКонтрагентов;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГоловнойКонтрагент",	ГоловнойКонтрагент);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка КАК Ссылка,
	|	Контрагенты.Наименование КАК Наименование
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ГоловнойКонтрагент = &ГоловнойКонтрагент
	|	И Контрагенты.Ссылка <> &ГоловнойКонтрагент
	|	И НЕ Контрагенты.ЭтоГруппа";
	
	Результат = Запрос.Выполнить();
	МассивКонтрагентов	= Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат МассивКонтрагентов;
	
КонецФункции

Функция ПолучитьРозничногоКонтрагента() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Контрагенты.Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ЭтоГруппа = ЛОЖЬ
	|	И Контрагенты.ИдентификационныйКодЛичности = ""000000000000""
	|	И Контрагенты.РНН = ""000000000000""
	|";
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.следующий();
		Возврат Выборка.Ссылка;
	Иначе
		
		НовыйКонтрагент = Справочники.Контрагенты.СоздатьЭлемент();
		НовыйКонтрагент.ИдентификационныйКодЛичности = "000000000000";
		НовыйКонтрагент.Наименование = "Розничная выручка";
		НовыйКонтрагент.НаименованиеПолное = "Розничная выручка";
		НовыйКонтрагент.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо;
		НовыйКонтрагент.РНН = "000000000000";
		НовыйКонтрагент.Записать();
		
		Возврат НовыйКонтрагент.Ссылка;
		
	КонецЕсли;
	
КонецФункции

Функция НайтиКонтрагентовПоНаименованиюБИНилиРНН(Наименование, БИН, РНН) Экспорт 
	
	МассивКонтрагентов	= Новый Массив;
	
	Если НЕ (ЗначениеЗаполнено(Наименование) ИЛИ ЗначениеЗаполнено(БИН) ИЛИ ЗначениеЗаполнено(РНН)) Тогда
		Возврат МассивКонтрагентов;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("БИН", БИН);
	Запрос.УстановитьПараметр("ИскатьПоБИН", ЗначениеЗаполнено(БИН));
	Запрос.УстановитьПараметр("РНН", РНН);
	Запрос.УстановитьПараметр("ИскатьПоРНН", ЗначениеЗаполнено(РНН));
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Контрагенты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Наименование = &Наименование
	|	ИЛИ (&ИскатьПоБИН И Контрагенты.ИдентификационныйКодЛичности = &БИН)
	|	ИЛИ (&ИскатьПоРНН И Контрагенты.РНН = &РНН)
	|	И НЕ Контрагенты.ЭтоГруппа";
	
	Результат = Запрос.Выполнить();
	МассивКонтрагентов	= Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат МассивКонтрагентов;
	
КонецФункции

//Функция определяет наличие дублей у контрагента.
// 
// Параметры:
//  БИН_ИИН - БИН / ИИН проверяемого контрагента, Тип - Строка(12)
//  Ссылка - Сам проверяемый контрагент, Тип - СправочникСсылка.Контрагенты
//
Функция ПроверитьДублиСправочникаКонтрагентыПоБИН_ИИНилиРНН(Знач БИН_ИИНилиРНН, Знач Ссылка, ПроверяемыеДанные = "БИН_ИИН") Экспорт
	
	Дубли = Новый Массив;
	
	Запрос = Новый Запрос;
	
	ИмяРеквизита = "РНН";
	Если ПроверяемыеДанные = "БИН_ИИН" Тогда 
		ИмяРеквизита = "ИдентификационныйКодЛичности";
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	НЕ Контрагенты.ЭтоГруппа
	|	И НЕ Контрагенты.Ссылка = &Ссылка
	|	И Контрагенты." + ИмяРеквизита + " = &БИН_ИИНилиРНН";
	
	Запрос.УстановитьПараметр("БИН_ИИНилиРНН", СокрЛП(БИН_ИИНилиРНН));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДублей = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДублей.Следующий() Цикл
		Дубли.Добавить(ВыборкаДублей.Ссылка);
	КонецЦикла;
	
	Возврат Дубли;
	
КонецФункции

Функция ВозможноИспользованиеКонтрагента(Контрагент, Объект) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда 
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	1 КАК КонтрагентЯвляетсяЮрЛицом
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Ссылка = &Контрагент
	|	И Контрагенты.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ФизЛицо)";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 не является физическим лицом, расчет налогов при поступлении активов и услуг для него не предусмотрен!'"), СокрЛП(Контрагент));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект.Ссылка);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
		
КонецПроцедуры

#КонецЕсли
