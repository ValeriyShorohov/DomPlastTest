&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Источник = ПараметрыВыполненияКоманды.Источник;
	
	Если ТипЗнч(Источник) = Тип("УправляемаяФорма") Тогда
		ДополнительныеПараметры = Новый Структура("КлючФормы", Источник.КлючУникальности);
		ЭСФКлиент.ЗагрузитьНоменклатуруГСВСИзФайла(ДополнительныеПараметры);
	КонецЕсли;	
	
КонецПроцедуры

