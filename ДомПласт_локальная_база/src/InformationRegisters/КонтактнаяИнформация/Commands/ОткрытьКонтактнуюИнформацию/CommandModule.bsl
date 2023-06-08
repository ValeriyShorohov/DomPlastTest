
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОбъектКИ = ПараметрКоманды;
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Организации") Тогда 
		ОбъектКИ = КонтактнаяИнформацияКлиентСерверПовтИсп.ПроверитьИПолучитьОбъектКИОрганизации(ОбъектКИ);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ОбъектКИ", ОбъектКИ);
	ОткрытьФорму("РегистрСведений.КонтактнаяИнформация.Форма.ФормаКонтактнойИнформации", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
