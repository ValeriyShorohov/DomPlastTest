#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ);
	
	МаксКоличествоСубконто = ПроцедурыБухгалтерскогоУчета.МаксимальноеКоличествоСубконто();
	Если СписокВидовСубконто.Количество() > МаксКоличествоСубконто Тогда
		ТекстСообщения = НСтр("ru = 'Выбрано слишком много видов субконто, максимально допустимо %1'");
		ОбщегоНазначения.СообщитьПользователю(СтрШаблон(ТекстСообщения, МаксКоличествоСубконто),, "Отчет.СписокВидовСубконто",, Отказ);
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

#КонецЕсли