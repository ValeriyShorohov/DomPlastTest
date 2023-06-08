&НаКлиенте
Перем УстановкаОсновнойКассыВыполнена;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "УстановкаОсновнойКассыВыполнена" Тогда
		
		УстановкаОсновнойКассыВыполнена = Истина;
		
	ИначеЕсли ИмяСобытия = "УстановкаОсновнойКассыПриЗаписи" Тогда
		
		Если ЗначениеЗаполнено(Владелец) И Владелец = Параметр.КонтрагентОрганизация Тогда
			
			Если УстановкаОсновнойКассыВыполнена = Истина Тогда
				
				ОсновнаяКасса = Параметр.ОсновнаяКасса;
				УстановитьПараметрыСписка(ЭтотОбъект);
				
				УправлениеФормойКлиент();
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ИзмененаКасса" Тогда
		
		Если Параметр.Свойство("ОсновнаяКасса")
			И ЗначениеЗаполнено(Владелец) И Владелец = Параметр.Владелец Тогда
			ОсновнаяКасса = Параметр.ОсновнаяКасса;
		КонецЕсли;
		
		УстановитьПараметрыСписка(ЭтотОбъект);
		УправлениеФормойКлиент();
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	Если Параметры.Отбор.Свойство("Владелец") Тогда
		
		Если Параметры.Свойство("ВладелецПодразделение") Тогда
			Владелец = Параметры.ВладелецПодразделение;
		Иначе
			Владелец = Параметры.Отбор.Владелец;
		КонецЕсли;

	КонецЕсли;
	
	Если ЗначениеЗаполнено(Владелец) Тогда
		
		Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Контрагенты") Тогда
			
			Элементы.Владелец.Заголовок = НСтр("ru = 'Контрагент'");
			ДоступноИспользоватьОсновной = ПравоДоступа("Редактирование", Метаданные.Справочники.Контрагенты);
			
		ИначеЕсли ТипЗнч(Владелец) = Тип("СправочникСсылка.Организации") Тогда
			
			Элементы.Владелец.Заголовок = НСтр("ru = 'Организация'");
			ДоступноИспользоватьОсновной = ПравоДоступа("Редактирование", Метаданные.Справочники.Организации);
			
		ИначеЕсли ТипЗнч(Владелец) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
			
			Элементы.Владелец.Заголовок = НСтр("ru = 'Физическое лицо'");
			ДоступноИспользоватьОсновной = ПравоДоступа("Редактирование", Метаданные.Справочники.ФизическиеЛица);
			
		ИначеЕсли ТипЗнч(Владелец) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
			
			Элементы.Владелец.Заголовок = НСтр("ru = 'Подразделение'");
			ДоступноИспользоватьОсновной = ПравоДоступа("Редактирование", Метаданные.Справочники.ПодразделенияОрганизаций);

		КонецЕсли;
		
		ОсновнаяКасса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "ОсновнаяКасса");
	КонецЕсли;
	
	Элементы.ФормаИспользоватьОсновной.Видимость = ЗначениеЗаполнено(Владелец) И ДоступноИспользоватьОсновной;
	
	Элементы.Основной.Видимость = ЗначениеЗаполнено(Владелец);
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Кассы);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	УстановитьПараметрыСписка(ЭтотОбъект);
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// Команда "Назначить основным"
&НаКлиенте
Процедура ИспользоватьОсновной(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено
		Или Не Элементы.Список.ТекущиеДанные.Свойство("Ссылка")
		Или Не Элементы.Список.ТекущиеДанные.Свойство("Владелец") Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.Список.ТекущиеДанные.Ссылка = ОсновнаяКасса Тогда
		ОсновнаяКасса = ПредопределенноеЗначение("Справочник.Кассы.ПустаяСсылка");
	Иначе
		ОсновнаяКасса = Элементы.Список.ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	УстановитьПараметрыСписка(ЭтотОбъект);
	
	УстановкаОсновнойКассыВыполнена = Ложь;
	Если ТипЗнч(Владелец) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда		
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("КонтрагентОрганизация",  Владелец);
		СтруктураПараметров.Вставить("ОсновнаяКасса", ОсновнаяКасса);
	Иначе
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("КонтрагентОрганизация",  Элементы.Список.ТекущиеДанные.Владелец);
		СтруктураПараметров.Вставить("ОсновнаяКасса", ОсновнаяКасса);
	КонецЕсли;
	
	Оповестить("УстановкаОсновнойКассы", СтруктураПараметров);
	
	// Если форма владельца закрыта, то запишем основную кассу самостоятельно.
	Если Не УстановкаОсновнойКассыВыполнена Тогда
		УстановитьОсновнуюКассу(СтруктураПараметров);
	КонецЕсли;
	
	УправлениеФормойКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКомандыУстановитьОсновнуюКассу();
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеФормойКлиент()
	
	Если ОсновнаяКасса = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ДоступноИспользоватьОсновной И ТекущиеДанные <> Неопределено Тогда
		Если ТекущиеДанные.Свойство("Ссылка") Тогда
			Элементы.ФормаИспользоватьОсновной.Пометка = ТекущиеДанные.Ссылка = ОсновнаяКасса;
		КонецЕсли;
		
		Если ТекущиеДанные.Свойство("ПометкаУдаления") И ТекущиеДанные.ПометкаУдаления Тогда
			Элементы.ФормаИспользоватьОсновной.Доступность = Ложь;
		Иначе
			Элементы.ФормаИспользоватьОсновной.Доступность = Истина;
		КонецЕсли;
	Иначе
		Элементы.ФормаИспользоватьОсновной.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандыУстановитьОсновнуюКассу()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Элементы.ФормаИспользоватьОсновной.Доступность = Ложь;
	Иначе
		Элементы.ФормаИспользоватьОсновной.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьОсновнуюКассу(СтруктураПараметров)
	
	Справочники.Кассы.УстановитьОсновнуюКассу(
	СтруктураПараметров.КонтрагентОрганизация,
	СтруктураПараметров.ОсновнаяКасса);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыСписка(Форма)
	
	Список = Форма.Список;
	
	Если ЗначениеЗаполнено(Форма.ОсновнаяКасса) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ОсновнаяКасса", Форма.ОсновнаяКасса);
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("ОсновнаяКасса", Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры
