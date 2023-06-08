///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокПолей = Параметры.СписокПолей;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)
	
	МассивОтмеченныхЭлементовСписка = ОбщегоНазначенияКлиентСервер.ОтмеченныеЭлементы(СписокПолей);
	
	Если МассивОтмеченныхЭлементовСписка.Количество() = 0 Тогда
		
		НСтрока = НСтр("ru = 'Укажите хотя бы одно поле'");
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтрока,,"СписокПолей");
		
		Возврат;
		
	КонецЕсли;
	
	ОповеститьОВыборе(СписокПолей.Скопировать());
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ОповеститьОВыборе(Неопределено);
	
КонецПроцедуры

#КонецОбласти
