#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
// Процедура - обработчик события ПередЗаписью
// Менеджера константы
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ЭтоПодчиненныйУзелРИБ = ПланыОбмена.ГлавныйУзел() <> Неопределено;
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ЭтоПодчиненныйУзелРИБ Тогда
		
		ТекстСообщения = НСтр("ru = 'Изменение константы может быть выполнено
		                            |только в главном узле распределенной информационной базы.'");
		Отказ = Истина;
		ВызватьИсключение ТекстСообщения;
									
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли