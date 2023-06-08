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

// Обновление ИБ
Процедура ЗаполнитьКонстантуИспользоватьТипыЦенНоменклатуры() Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Константы.ИспользоватьТипыЦенНоменклатуры.Установить(КоличествоТиповЦен() > 0);
	
КонецПроцедуры

Процедура ПроверитьЗначениеОпцииИспользоватьТипыЦенНоменклатуры() Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьТипыЦенНоменклатуры") И КоличествоТиповЦен() > 0 Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		Константы.ИспользоватьТипыЦенНоменклатуры.Установить(Истина);
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

Функция КоличествоТиповЦен()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ИЗ
		|	Справочник.ТипыЦенНоменклатуры КАК ТипыЦенНоменклатуры";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Количество = Выборка.Количество;
	Иначе
		Количество = 0;
	КонецЕсли;
	
	Возврат Количество;
	
КонецФункции

#КонецЕсли
