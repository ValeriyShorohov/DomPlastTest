
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОписаниеОповещенияОЗакрытии <> Неопределено
		И ТипЗнч(ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры) = Тип("Структура")
		И ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Свойство("КонтактнаяИнформация") Тогда

		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.КонтактнаяИнформация = ТекущиеДанные.Представление;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.Список.РежимВыбора Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Закрыть(ТекущиеДанные.Представление);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не Копирование Тогда
		
		Отказ = Истина;    	
		
		//если в форме установлен отбор по объекту, с видом сравнения "Равно".
		СписокПолей = Новый Массив();
		СписокПолей.Добавить("Объект");		
		СписокОтбораПоОбъекту = БухгалтерскиеОтчетыКлиентСервер.НайтиЭлементыОтбора(Список.Отбор, СписокПолей, Истина); 		
		
		Если СписокОтбораПоОбъекту.Количество() = 1 Тогда
			СтруктураПредустановленныхЗначений = Новый Структура();
			СтруктураПредустановленныхЗначений.Вставить("Объект",СписокОтбораПоОбъекту[0].ПравоеЗначение); 
		Иначе 			
			СтруктураПредустановленныхЗначений = Неопределено;
		КонецЕсли;   		
			
		КонтактнаяИнформацияКлиент.ОткрытьФормуРедактированияЗаписиРегистра(Список, Истина, ЭтотОбъект,СтруктураПредустановленныхЗначений, Истина);
		
	Иначе
		Отказ = Истина;
		КонтактнаяИнформацияКлиент.ОткрытьФормуРедактированияЗаписиРегистра(Список, Истина, ЭтотОбъект, КонтактнаяИнформацияКлиентСервер.ПолучитьСтруктуруЗаписиРегистра(Элементы.Список.ТекущиеДанные), Истина);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	КонтактнаяИнформацияКлиент.ОткрытьФормуРедактированияЗаписиРегистра(Элементы.Список.ТекущиеДанные, Истина, ЭтотОбъект, , Истина);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПослеЗакрытияФормыРедактированияЗаписиКИ(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Список.Обновить();

КонецПроцедуры
