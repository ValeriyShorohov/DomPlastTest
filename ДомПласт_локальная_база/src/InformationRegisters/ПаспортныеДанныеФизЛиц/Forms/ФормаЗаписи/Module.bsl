
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Запись.ФизЛицо) Тогда
		мФизЛицо = Запись.ФизЛицо;		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ОбновитьФорму", Новый Структура("ИмяЭлемента","УдостоверениеЛичности"), Запись.ФизЛицо);
	
	Если мФизЛицо <> Запись.ФизЛицо Тогда
		// оповестим также форму того физлица, данные которого начинали редактировать
		Оповестить("ОбновитьФорму", Новый Структура("ИмяЭлемента","УдостоверениеЛичности"), мФизЛицо);
		мФизЛицо = Запись.ФизЛицо;
	КонецЕсли;

	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	РабочаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	Если Запись.Период > РабочаяДата Тогда
		
		ТекстВопроса = НСтр("ru='Вы действительно хотите ввести данные" + Символы.ПС + "об удостоверении личности физлица на будущую дату?'");
		Режим 	     = РежимДиалогаВопрос.ДаНет;
		КнопкаПоУмолчанию = КодВозвратаДиалога.Нет;
		Оповещение   = Новый ОписаниеОповещения("ПослеИзмененияПериода", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0, КнопкаПоУмолчанию);
		
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПослеИзмененияПериода(Результат, Параметры) Экспорт
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Запись.Период = РабочаяДата;
	КонецЕсли;	
КонецПроцедуры	



