
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭСФЧерезAPI") Тогда
		ОтказПриОткрытии = Истина;
	КонецЕсли;
	
КонецПроцедуры
 
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();	
	Контейнер.ПриОткрытииФормы(ЭтаФорма, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтказПриОткрытии Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, ЭСФКлиентСервер.ТекстСообщенияНеУстановленОбменЧерезAPI());
	КонецЕсли;
	
КонецПроцедуры