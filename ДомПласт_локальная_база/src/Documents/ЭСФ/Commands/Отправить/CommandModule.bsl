
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Источник = ПараметрыВыполненияКоманды.Источник;
	
	Если ТипЗнч(Источник) = Тип("УправляемаяФорма") Тогда
			
		Если Источник.ИмяФормы = "Документ.ЭСФ.Форма.ФормаДокумента" Тогда
			
			ЭСФКлиент.ОтправитьИсходящиеЭСФ(ПараметрКоманды, Новый Структура("ЗапускатьФоновоеЗадание", Ложь));
			
		Иначе
			
			ИспользоватьФоновуюОтправкуЭСФ = ЭСФКлиентСерверПереопределяемый.ИспользоватьФоновуюОтправкуЭСФ();
			
			ДополнительныеПараметры = Новый Структура("ЗапускатьФоновоеЗадание, КлючФормы", ИспользоватьФоновуюОтправкуЭСФ, Источник.КлючУникальности);
			
			ЭСФКлиент.ОтправитьИсходящиеЭСФ(ПараметрКоманды, ДополнительныеПараметры);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
