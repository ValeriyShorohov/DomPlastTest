
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭСФЧерезAPI") 
		И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭСФЧерезXML") Тогда
		ОтказПриОткрытии = Истина;
	КонецЕсли;
	
КонецПроцедуры
 
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОтказПриОткрытии Тогда
		Отказ = Истина;
		Предупреждение(ЭСФКлиентСервер.ТекстСообщенияНеУстановленыОбеКонстанты());
	КонецЕсли;
	
КонецПроцедуры