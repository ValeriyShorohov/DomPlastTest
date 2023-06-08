#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьРеквизитыБанка(Банк) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Банки.Город,
	                      |	Банки.КоррСчет,
	                      |	Банки.Адрес,
	                      |	Банки.РНН,
	                      |	Банки.ПроцентКомиссии,
	                      |	Банки.Контрагент,
	                      |	Банки.КодВПлатежнойСистеме,
	                      |	Банки.ИдентификационныйНомер,
	                      |	Банки.БИК,
	                      |	Банки.БИКДоРеформыБанковскихСчетов,
	                      |	Банки.Наименование
	                      |ИЗ
	                      |	Справочник.Банки КАК Банки
	                      |ГДЕ
	                      |	Банки.Ссылка = &Банк");
		
	Запрос.УстановитьПараметр("Банк", Банк);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Наименование = Выборка.Наименование;
		Город = Выборка.Город;
		Адрес = Выборка.Адрес;
		Контрагент = Выборка.Контрагент;
		ИдентификационныйНомер = Выборка.ИдентификационныйНомер;
		БИКДоРеформыБанковскихСчетов = Выборка.БИКДоРеформыБанковскихСчетов;
		БИК = Выборка.БИК;
		КодВПлатежнойСистеме = Выборка.КодВПлатежнойСистеме;
	Иначе 
		Наименование = "";
		Город = "";
		Адрес = "";
		Контрагент = Неопределено;
		ИдентификационныйНомер = "";
		БИКДоРеформыБанковскихСчетов = "";
		БИК = "";
		КодВПлатежнойСистеме = "";
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура("Ссылка,Наименование, Город, Адрес, Контрагент, ИдентификационныйНомер, БИК, БИКДоРеформыБанковскихСчетов, КодВПлатежнойСистеме ",
	    Банк,
		Наименование,
		Город,
		Адрес,
		Контрагент,
		ИдентификационныйНомер,
		БИК,
		БИКДоРеформыБанковскихСчетов,
		КодВПлатежнойСистеме
	);
	
	Возврат СтруктураРеквизитов;

КонецФункции

Функция ПолучитьБИКБанка(ДатаПериода, Банк) Экспорт
	
	РеквизитыБанка = Неопределено;
	Если ТипЗнч(Банк) = Тип("СправочникСсылка.Банки") Тогда
		РеквизитыБанка = ПолучитьРеквизитыБанка(Банк);
	ИначеЕсли ТипЗнч(Банк) = Тип("СправочникОбъект.Банки") Тогда
		РеквизитыБанка = Банк;
	ИначеЕсли ТипЗнч(Банк) = Тип("Структура") Тогда
		РеквизитыБанка = Банк;
	Иначе 
		Возврат "";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаПериода) Тогда
	    ДатаПериода =  ТекущаяДата();	
	КонецЕсли;
	
	ЗначениеБИК = ?(ДатаПериода >= Дата(2010,06,07), РеквизитыБанка.БИК, РеквизитыБанка.БИКДоРеформыБанковскихСчетов);
	
	Возврат ЗначениеБИК;
	
КонецФункции

Функция ПолучитьИмяРеквизитаБИКБанка(ДатаПериода) Экспорт
	Если НЕ ЗначениеЗаполнено(ДатаПериода) Тогда
	    ДатаПериода =  ТекущаяДата();	
	КонецЕсли;
	ИмяРеквизитаБИК = ?(ДатаПериода >= Дата(2010,06,07), "БИК", "БИКДоРеформыБанковскихСчетов");
	
	Возврат ИмяРеквизитаБИК
	
КонецФункции 

Функция ПолучитьИмяРеквизитаКодБанкаВПлатежнойСистеме(ДатаПериода) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ДатаПериода) Тогда
	    ДатаПериода =  ТекущаяДата();	
	КонецЕсли;
	ИмяРеквизитаБИК = ?(ДатаПериода >= Дата(2010,06,07), "КодВПлатежнойСистеме", "КодВПлатежнойСистемеДоРеформыБанковскихСчетов");
	
	Возврат ИмяРеквизитаБИК
КонецФункции // ПолучитьИмяРеквизитаКодБанкаВПлатежнойСистеме()

#КонецЕсли
