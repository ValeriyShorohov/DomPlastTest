
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПоказыватьКодыСтрокДекларацииНУ = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПоказыватьКодыСтрокДекларацииНУ", "Просмотр");
	Если ПоказыватьКодыСтрокДекларацииНУ <> Неопределено Тогда
		Элементы.ФормаПоказыватьКодыСтрокДекларацииНУ.Пометка   = ПоказыватьКодыСтрокДекларацииНУ;
		Элементы.КодыСтрокДекларацииПоНалогуНаПрибыль.Видимость = ПоказыватьКодыСтрокДекларацииНУ;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;	
	
	ПриЗакрытииНаСервере(Элементы.ФормаПоказыватьКодыСтрокДекларацииНУ.Пометка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОкончаниеЗагрузкиКлассификатораСтатейЗатрат" Тогда
		Элементы.Список.Обновить();
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Не Элементы.ФормаПоказыватьКодыСтрокДекларацииНУ.Пометка Тогда
		Возврат;
	КонецЕсли;
	
	СписокПриАктивизацииСтрокиНаКлиенте();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ


&НаКлиенте
Процедура ПоказыватьКодыСтрокДекларацииНУ(Команда)
	
	ПоказыватьКодыСтрокДекларацииНУ = НЕ Элементы.ФормаПоказыватьКодыСтрокДекларацииНУ.Пометка;	
	Элементы.ФормаПоказыватьКодыСтрокДекларацииНУ.Пометка = ПоказыватьКодыСтрокДекларацииНУ;
	Элементы.КодыСтрокДекларацииПоНалогуНаПрибыль.Видимость = ПоказыватьКодыСтрокДекларацииНУ;
	
	СписокПриАктивизацииСтрокиНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	ФормаЗаполнения = ПолучитьФорму("Справочник.СтатьиЗатрат.Форма.ФормаЗаполнения",  Новый Структура("ЗаполнениеКлассификатора", Истина));
	ФормаЗаполнения.ЗаполнитьКлассификатор();
	ФормаЗаполнения.Открыть();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
Процедура ПриЗакрытииНаСервере(Пометка)
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПоказыватьКодыСтрокДекларацииНУ", "Просмотр", Пометка);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтрокиНаКлиенте()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(КодыСтрокДекларацииПоНалогуНаПрибыль, "ВидДоходаРасхода", ТекущиеДанные.Ссылка, Истина);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды




 