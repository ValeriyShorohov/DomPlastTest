
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗапускатьФоновоеЗадание", ЭСФКлиентСерверПереопределяемый.ИспользоватьФоновуюОтправкуЭСФ());
	ПараметрыФормы.Вставить("РежимЗапуска", "СинхронизацияСВС");
	
	ОткрытьФорму("Обработка.ОбменЭСФ.Форма.СинхронизацияСВС", ПараметрыФормы, , "ФормаСинхронизацииВС");

КонецПроцедуры
