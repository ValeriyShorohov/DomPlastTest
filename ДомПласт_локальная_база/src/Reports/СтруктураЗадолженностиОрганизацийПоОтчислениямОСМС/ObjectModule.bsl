#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры 

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт

	Элементы = Форма.Элементы;
	
	Элементы.ГруппаПериод.Видимость = Истина;
	Форма.ЕстьНачалоПериодаБК       = Истина;
	Форма.ЕстьКонецПериодаБК        = Истина;
	
	Элементы.Период.Видимость = Ложь;
	Форма.ЕстьПериодБК        = Ложь;
	
	Элементы.ГруппаОрганизацияРегистрНУ.Видимость   = Ложь;
    Элементы.ГруппаОрганизация.Видимость            = Истина;	
	Элементы.ГруппаДополнительные.Видимость         = Ложь;
	
	Элементы.ВыводитьЗаголовок.Видимость            = Истина;
	Элементы.ВыводитьПодписи.Видимость              = Истина;
	Элементы.ВыводитьПодписиРуководителей.Видимость = Истина;
	
	Если НЕ Форма.РежимРасшифровки Тогда
		Форма.НачалоПериода = НачалоМесяца(ОбщегоНазначения.ТекущаяДатаПользователя());
		Форма.КонецПериода  = КонецМесяца(ОбщегоНазначения.ТекущаяДатаПользователя());
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ЗаполняемыеНастройки = Новый Структура("Группировка, Показатели", Истина, Истина);
	БухгалтерскиеОтчетыВызовСервера.ПередЗагрузкойНастроекВКомпоновщик(ЭтотОбъект, Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД, ЗаполняемыеНастройки);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ДополнительныеСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
	Если ДополнительныеСвойства.Свойство("НастройкиОтчета") И ТипЗнч(ДополнительныеСвойства.НастройкиОтчета) = Тип("Структура") Тогда
		НастройкиОтчета  = ДополнительныеСвойства.НастройкиОтчета;
		НачалоПериода    = НастройкиОтчета.НачалоПериода;
		КонецПериода     = НастройкиОтчета.КонецПериода;
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, Новый Структура("КорректностьПериода", Истина));
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ДокументРезультат.Очистить();
	
	ОтчетМетаданные = Метаданные();
	
	РежимВариантаОтчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьРежимВыполненияОтчета(ОтчетМетаданные);
	
	Если НЕ РежимВариантаОтчета Тогда
	
		СтандартнаяОбработка = Ложь;
		БухгалтерскиеОтчетыВызовСервера.ОбработкаСобытияПриКомпоновкеРезультата(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки);
		Возврат;
		
	Иначе
		
		ПользовательскиеНастройки = ЭтотОбъект.КомпоновщикНастроек.ПользовательскиеНастройки;
		
		//ХранилищеСвойств = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "НастройкиОтчета");
		//Если ХранилищеСвойств <> Неопределено И ТипЗнч(ХранилищеСвойств.Значение) = Тип("ХранилищеЗначения") Тогда
		//	НастройкиОтчета = ХранилищеСвойств.Значение.Получить();
		//Иначе
		//	Возврат;
		//КонецЕсли;
		
		ПараметрНастройкиОтчета = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "НастройкиОтчета");
		Если ПараметрНастройкиОтчета <> Неопределено И ТипЗнч(ПараметрНастройкиОтчета.Значение) = Тип("ХранилищеЗначения") Тогда
			НастройкиОтчета = ПараметрНастройкиОтчета.Значение.Получить();
		КонецЕсли;
		
		Если НастройкиОтчета = Неопределено Тогда
			ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("НастройкиОтчета", НастройкиОтчета);
		КонецЕсли;
		
		Если ТипЗнч(НастройкиОтчета) = Тип("ХранилищеЗначения") Тогда
			НастройкиОтчета = НастройкиОтчета.Получить();
		КонецЕсли;
		
		Если НастройкиОтчета = Неопределено Тогда
			Возврат;
		Иначе
			БухгалтерскиеОтчетыВызовСервера.УстановкаПериодаОтчетаРассылка(НастройкиОтчета, ПользовательскиеНастройки);
		КонецЕсли;
		
		Если НастройкиОтчета.ВыводитьЗаголовок Тогда
			БухгалтерскиеОтчетыВызовСервера.ВывестиЗаголовокОтчета(НастройкиОтчета, КомпоновщикНастроек, ДокументРезультат);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НастройкиОтчета.НачалоПериода) Тогда
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(НастройкиОтчета.НачалоПериода));
		Иначе
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", Дата(1, 1, 1));
		КонецЕсли;
		Если ЗначениеЗаполнено(НастройкиОтчета.КонецПериода) Тогда
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(НастройкиОтчета.КонецПериода));
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериодаОстатков", Новый Граница(КонецДня(НастройкиОтчета.КонецПериода), ВидГраницы.Включая));
		Иначе
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", Дата(3999, 11, 1));
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериодаОстатков", Новый Граница(КонецДня(Дата(3999, 11, 1)), ВидГраницы.Включая));
		КонецЕсли;
		
		ПользовательскийОтбор = ПользовательскиеНастройки.Элементы.Найти(КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки);
		Если ТипЗнч(ПользовательскийОтбор) = Тип("ОтборКомпоновкиДанных") Тогда
			БухгалтерскиеОтчеты.ДобавитьОтборПоОрганизациямИПодразделениям(ПользовательскийОтбор, НастройкиОтчета);
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ВывестиПодписи(ДокументРезультат) Экспорт
	
	ДополнительныеСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
	Если ДополнительныеСвойства.Свойство("НастройкиОтчета") И ТипЗнч(ДополнительныеСвойства.НастройкиОтчета) = Тип("Структура") Тогда
		НастройкиОтчета = ДополнительныеСвойства.НастройкиОтчета;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если НастройкиОтчета.ВыводитьПодписи Тогда
		БухгалтерскиеОтчетыВызовСервера.ВыводПодписейОтчета(НастройкиОтчета, ДокументРезультат);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки, ОтчетОбъект) Экспорт
	
	Если ОтчетОбъект.РежимРасшифровки Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗаполняемыеНастройки.Свойство("Группировка") И ЗаполняемыеНастройки.Группировка Тогда
	
		ТаблицаГруппировка = ОтчетОбъект.Группировка;

		ТаблицаГруппировка.Очистить();
		
		НоваяСтрока = ТаблицаГруппировка.Добавить();
		НоваяСтрока.Поле           = "Организация";
		НоваяСтрока.Использование  = Истина;
		НоваяСтрока.Представление  = НСтр("ru = 'Организация'");
		НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;	
	
		НоваяСтрока = ТаблицаГруппировка.Добавить();
		НоваяСтрока.Поле           = "ВидПлатежа";
		НоваяСтрока.Использование  = Истина;
		НоваяСтрока.Представление  = НСтр("ru = 'Вид платежа'");
		НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;
		
		НоваяСтрока = ТаблицаГруппировка.Добавить();
		НоваяСтрока.Поле           = "МесяцНалоговогоПериода";
		НоваяСтрока.Использование  = Истина;
		НоваяСтрока.Представление  = НСтр("ru = 'Месяц'");
		НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;
		
		НоваяСтрока = ТаблицаГруппировка.Добавить();
		НоваяСтрока.Поле           = "Физлицо";
		НоваяСтрока.Использование  = Истина;
		НоваяСтрока.Представление  = НСтр("ru = 'Физическое лицо'");
		НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;	
			
	КонецЕсли;
	
	// Заполнение таблицы Показатели	
	Если ЗаполняемыеНастройки.Свойство("Показатели") И ЗаполняемыеНастройки.Показатели Тогда
	
		ТаблицаПоказатели = ОтчетОбъект.Показатели;

		ТаблицаПоказатели.Очистить();
		
		СписокПоказателей = Новый СписокЗначений;
		СписокПоказателей.Добавить("СальдоНачальное", НСтр("ru = 'Сальдо начальное'"));
		СписокПоказателей.Добавить("Исчислено"      , НСтр("ru = 'Исчислено (возврат)'"));
		СписокПоказателей.Добавить("Перечислено"    , НСтр("ru = 'Перечислено'"));
		СписокПоказателей.Добавить("СальдоКонечное" , НСтр("ru = 'Сальдо конечное'"));
		
		Для Каждого ЭлементСписка Из СписокПоказателей Цикл
			СтрокаТЧ 				= ТаблицаПоказатели.Добавить();
			СтрокаТЧ.Поле 			= ЭлементСписка.Значение;
			СтрокаТЧ.Представление 	= ЭлементСписка.Представление;
			СтрокаТЧ.Использование 	= Истина;
		КонецЦикла;

	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

#КонецЕсли