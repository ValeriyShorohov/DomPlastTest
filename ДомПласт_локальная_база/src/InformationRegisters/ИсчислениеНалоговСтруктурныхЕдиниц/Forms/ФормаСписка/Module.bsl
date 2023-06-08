////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	
	Если Не ПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда
		
		ТекстСообщения = НСтр("ru = 'В настройках параметров учета не указана поддержка работы со структурными подразделениями!'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
		Отказ = Истина;
		
	КонецЕсли;
	
	ПравоРедактирования = ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.ИсчислениеНалоговСтруктурныхЕдиниц);
	Элементы.ФормаАвтозаполнение.Видимость = ПравоРедактирования;
	Элементы.ФормаГруппаОчистить.Видимость = ПравоРедактирования;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновлениеИсчислениеНалоговСтруктурныхЕдиниц" 
		И Источник <> Неопределено И Найти(Источник.ИмяФормы, "ФормаЗаполнения") > 0 Тогда
		
		Элементы.Список.Обновить();

	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Автозаполнение(Команда)
	
	ОткрытьФорму("РегистрСведений.ИсчислениеНалоговСтруктурныхЕдиниц.Форма.ФормаЗаполнения",,ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьВсе(Команда)
	
	ТекстВопроса = НСтр("ru='Очистить полностью все записи регистра?'");
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОчиститьВсе", ЭтотОбъект, Параметры);
	ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПоРазделуНУ(Команда)
	
	ОчиститьРегистрСведенийПоОтборуНаКлиенте("РазделНалоговогоУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПоСтруктурнойЕдинице(Команда)
	
	ОчиститьРегистрСведенийПоОтборуНаКлиенте("СтруктурнаяЕдиница");

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ 

&НаКлиенте
Процедура ПослеЗакрытияВопросаОчиститьВсе(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьНаборЗаписейРегистра();
	
	Элементы.Список.Обновить();
	
КонецПроцедуры	

&НаСервере
Процедура ОчиститьНаборЗаписейРегистра()
	
	НаборЗаписей = РегистрыСведений.ИсчислениеНалоговСтруктурныхЕдиниц.СоздатьНаборЗаписей();
	НаборЗаписей.Записать();
	
КонецПроцедуры 

&НаКлиенте
// Выполняет очистку регистра сведений по текущему значению указанного измерения
//
Процедура ОчиститьРегистрСведенийПоОтборуНаКлиенте(ИмяИзмерения)

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеОтбора = ТекущиеДанные[ИмяИзмерения];

	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Очистить полностью все записи регистра по %1 ?'"), ЗначениеОтбора);
	
	Режим = РежимДиалогаВопрос.ДаНет;
	
	ПараметрыОповещения = Новый Структура("ИмяИзмерения, ЗначениеОтбора", ИмяИзмерения, ЗначениеОтбора);
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОчиститьПоОтбору", ЭтотОбъект, ПараметрыОповещения);
	ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);

КонецПроцедуры // ОчиститьРегистрСведенийПоОтбору()

&НаКлиенте
Процедура ПослеЗакрытияВопросаОчиститьПоОтбору(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьНаборЗаписейРегистраПоОтбору(ПараметрыОповещения.ИмяИзмерения, ПараметрыОповещения.ЗначениеОтбора);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьНаборЗаписейРегистраПоОтбору(ИмяИзмерения, ЗначениеОтбора)
	
	НаборЗаписей = РегистрыСведений.ИсчислениеНалоговСтруктурныхЕдиниц.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор[ИмяИзмерения].Установить(ЗначениеОтбора, Истина);
	НаборЗаписей.Записать();
	
КонецПроцедуры 
