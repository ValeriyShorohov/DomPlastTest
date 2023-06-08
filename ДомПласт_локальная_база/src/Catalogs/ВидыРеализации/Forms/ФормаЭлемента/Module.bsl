
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
        КодыСтрок.Отбор, 
        "ВидОперации", 
        Объект.Ссылка, 
        ВидСравненияКомпоновкиДанных.Равно, 
        "Вид поступления ТМЗ", 
        Истина
    );
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура КодыСтрокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
						
		ТекстВопроса = НСтр("ru = 'Перед редактированием данных по Декларации необходимо записать элемент.
		|Записать?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаЗаписатьВФорме", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		Отказ = Истина;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодыСтрокПриАктивизацииСтроки(Элемент)
	
	КодСтроки = "";
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		КодСтроки = Строка(Элемент.ТекущиеДанные.КодСтроки);
	КонецЕсли;
	
	ОбновитьПредставлениеЭлемента("КодСтрокиДекларации",КодСтроки);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПослеЗакрытияВопросаЗаписатьВФорме(Результат, Параметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		// записываем объект
		Если Записать() Тогда
			УстановитьОтборВОтражениеВДекларацииПоНДС();      
			ЗначенияЗаполнения = Новый Структура("ВидОперации", Объект.Ссылка);
			ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
			ОткрытьФорму("РегистрСведений.КодыСтрокДекларацииПоНДС.ФормаЗаписи", ПараметрыФормы, ЭтаФорма);
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ОбновитьПредставлениеЭлемента(ИмяОбновляемогоЭлемента, КодСтроки)
	
	Если ИмяОбновляемогоЭлемента = "КодСтрокиДекларации" Тогда
				
		Если ПустаяСтрока(СтрЗаменить(КодСтроки, ".", "")) Тогда
			Элементы.ДекорацияРасшифровкаКодСтроки.Заголовок = НСтр("ru ='<не указано>'");
		Иначе
			
			Если мМакетКодовСтрок.ВысотаТаблицы = 0 Тогда
			
				мМакетКодовСтрок	= УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_КодыСтрокНалоговыхДеклараций");	 						
			
			КонецЕсли;
			
			мОбластьСтрок = мМакетКодовСтрок.Области.Найти("НДС_Реализация");
			
			КодОсновнойСтроки = Лев(КодСтроки,10);
			ИмяОбластиМакета = "НДС_Реализация_" + СтрЗаменить(КодОсновнойСтроки, ".", "_");
			ОбластьДополнительныхСтрок = мМакетКодовСтрок.Области.Найти(ИмяОбластиМакета);
			
			Если ОбластьДополнительныхСтрок = Неопределено Тогда
				НаименованиеСтроки = РегламентированнаяОтчетность.ПолучитьНаименованиеСтрокиКлассификатораПоКоду(мМакетКодовСтрок, мОбластьСтрок, КодСтроки);
				
			Иначе	
				КодДополнительнойСтроки = Прав(КодСтроки, СтрДлина(КодСтроки) - 11);
				НаименованиеСтроки = РегламентированнаяОтчетность.ПолучитьНаименованиеСтрокиКлассификатораПоКоду(мМакетКодовСтрок, ОбластьДополнительныхСтрок, КодДополнительнойСтроки);
			КонецЕсли;
			
			Если ПустаяСтрока(НаименованиеСтроки) Тогда
				Элементы.ДекорацияРасшифровкаКодСтроки.Заголовок = НСтр("ru ='строка с кодом " + СокрЛП(КодСтроки) + " не найдена.'");
			Иначе
				Элементы.ДекорацияРасшифровкаКодСтроки.Заголовок = НаименованиеСтроки;
			КонецЕсли;
			
		КонецЕсли;
	
	КонецЕсли;
	       
КонецПроцедуры // ОбновитьПредставлениеЭлемента()

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Если НЕ ЗначениеЗаполнено(Объект.ПолноеНаименование) Тогда
		Объект.ПолноеНаименование = Объект.Наименование;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборВОтражениеВДекларацииПоНДС()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				КодыСтрок.Отбор, 
				"ВидОперации", 
				Объект.Ссылка, 
				ВидСравненияКомпоновкиДанных.Равно, 
				"Вид поступления ТМЗ", 
				Истина
				)	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УстановитьОтборВОтражениеВДекларацииПоНДС()

КонецПроцедуры
