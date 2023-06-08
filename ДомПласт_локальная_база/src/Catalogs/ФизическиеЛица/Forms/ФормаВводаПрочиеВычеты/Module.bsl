
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("ФизЛицо", ОбъектВладелец);
	Если Не ЗначениеЗаполнено(ОбъектВладелец) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <ИМЯ ТАБЛИЦЫ ФОРМЫ>

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)

	Оповестить("ИзменениеДанныхПрочиеВычеты", , ЭтотОбъект);
	
	Закрыть();
	 
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)

	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ИПНЗаявлениеНаПредоставлениеВычета, "ФизЛицо", ОбъектВладелец); 
	
КонецПроцедуры
