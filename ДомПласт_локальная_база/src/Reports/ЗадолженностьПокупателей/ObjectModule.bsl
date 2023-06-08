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
	
	Элементы.ВыводитьЗаголовок.Видимость            = Истина;
	Элементы.ВыводитьПодписи.Видимость              = Истина;
	Элементы.ВыводитьПодписиРуководителей.Видимость = Ложь;
	
	Форма.ТипЗадолженности = 1;
	
	Если НЕ Форма.РежимРасшифровки Тогда
		Форма.НачалоПериода = НачалоМесяца(ОбщегоНазначения.ТекущаяДатаПользователя());
		Форма.КонецПериода  = КонецМесяца(ОбщегоНазначения.ТекущаяДатаПользователя());
	КонецЕсли;
	
	Элементы.ГруппаДополнительные.Видимость = Истина;
	Элементы.НастройкаСчетовУчетаРасчетовДополнительные.Видимость = Истина;
	
	Элементы.КоличествоВыводимыхЗаписейВДиаграммеДополнительные.Видимость = Ложь;
	Элементы.ПериодичностьДополнительные.Видимость = Ложь;
	
КонецПроцедуры

Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ЗаполняемыеНастройки = Новый Структура("Группировка", Истина);
	БухгалтерскиеОтчетыВызовСервера.ПередЗагрузкойНастроекВКомпоновщик(ЭтотОбъект, Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД, ЗаполняемыеНастройки);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если БухгалтерскиеОтчетыВызовСервера.ПропуститьПроверкуЗаполнения(ЭтотОбъект) Тогда
		ПроверяемыеРеквизиты.Очистить();
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
	Если ДополнительныеСвойства.Свойство("НастройкиОтчета") И ТипЗнч(ДополнительныеСвойства.НастройкиОтчета) = Тип("Структура") Тогда
		НастройкиОтчета  = ДополнительныеСвойства.НастройкиОтчета;
		НачалоПериода    = НастройкиОтчета.НачалоПериода;
		КонецПериода     = НастройкиОтчета.КонецПериода;
	КонецЕсли;
	
	Проверки = Новый Структура("КорректностьПериода", Истина);
	БухгалтерскиеОтчетыВызовСервера.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, Проверки);
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРезультат.Очистить();
	
	ОтчетМетаданные = Метаданные();
	ИмяОтчета       = ОтчетМетаданные.ПолноеИмя();
	МенеджерОтчета  = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяОтчета);
	
	РежимВариантаОтчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьРежимВыполненияОтчета(ОтчетМетаданные);
	
	Если НЕ РежимВариантаОтчета Тогда
		
		БухгалтерскиеОтчетыВызовСервера.ОбработкаСобытияПриКомпоновкеРезультата(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки);
		Возврат;
		
	Иначе
		
		РежимРасшифровки = КомпоновщикНастроек.ФиксированныеНастройки.ДополнительныеСвойства.Свойство("РежимРасшифровки");
		
		ПользовательскиеНастройки = КомпоновщикНастроек.ПользовательскиеНастройки;
		
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
		
		НастройкиОтчета.Вставить("ИспользоватьПослеВыводаРезультата", Истина);
		
		Если НастройкиОтчета.ВыводитьЗаголовок Тогда
			МенеджерОтчета.ПриВыводеЗаголовка(НастройкиОтчета, ДокументРезультат);
		КонецЕсли;
		
		ИзмененыНастройкиВариант = Истина;
		Если ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("КлючВарианта") Тогда
			Если ПользовательскиеНастройки.ДополнительныеСвойства.КлючВарианта <> "ЗадолженностьПокупателей" Тогда
				ИзмененыНастройкиВариант = Истина;
			Иначе
				Если НастройкиОтчета.Свойство("ИзмененыНастройкиВариант") Тогда
					ИзмененыНастройкиВариант = НастройкиОтчета.ИзмененыНастройкиВариант;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НастройкиОтчета.НачалоПериода) Тогда
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(НастройкиОтчета.НачалоПериода));
		Иначе
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", Дата(1, 1, 1));
		КонецЕсли;
		Если ЗначениеЗаполнено(НастройкиОтчета.КонецПериода) Тогда
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(НастройкиОтчета.КонецПериода));
		Иначе
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", Дата(3999, 11, 1));
		КонецЕсли;
		
		ПользовательскийОтбор = ПользовательскиеНастройки.Элементы.Найти(КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки);
		Если ТипЗнч(ПользовательскийОтбор) = Тип("ОтборКомпоновкиДанных") Тогда
			БухгалтерскиеОтчеты.ДобавитьОтборПоОрганизациямИПодразделениям(ПользовательскийОтбор, НастройкиОтчета);
		КонецЕсли;
		
		Если КомпоновщикНастроек.Настройки.Структура.Количество() > 0 И НЕ РежимРасшифровки И НЕ ИзмененыНастройкиВариант Тогда
			ПерваяГруппировка = КомпоновщикНастроек.Настройки.Структура[0];
			Если ТипЗнч(ПерваяГруппировка) = Тип("ГруппировкаКомпоновкиДанных") Тогда
				ПерваяГруппировка.Имя = "Группировка_";
			КонецЕсли;
		КонецЕсли;
	
	КонецЕсли;
	
	
	// Компоновка макета
	
	НастройкиДляКомпоновкиМакета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	Попытка
		
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиДляКомпоновкиМакета, ДанныеРасшифровки);

		ВнешниеНаборыДанных = МенеджерОтчета.ПолучитьВнешниеНаборыДанных(НастройкиОтчета, МакетКомпоновки);

		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		Если ВнешниеНаборыДанных = Неопределено Тогда
			ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,, ДанныеРасшифровки, Истина);
		Иначе
			ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
		КонецЕсли;	

		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
		ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
		
		ПроцессорВывода.НачатьВывод();
		ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
		
		Если НЕ РежимВариантаОтчета Тогда
			ВывестиПодписи(ДокументРезультат);
			КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(Новый ПользовательскиеНастройкиКомпоновкиДанных);
		КонецЕсли;
		
	Исключение
		// Запись в журнал регистрации не требуется
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Пока ИнформацияОбОшибке.Причина <> Неопределено Цикл
			ИнформацияОбОшибке = ИнформацияОбОшибке.Причина;
		КонецЦикла;
		ТекстСообщения = НСтр("ru = 'Отчет не сформирован!'") + Символы.ПС + ИнформацияОбОшибке.Описание;
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецПопытки;

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
	
	Если ЗаполняемыеНастройки.Свойство("Группировка") Тогда
		Если ЗаполняемыеНастройки.Группировка Тогда
			
			ТаблицаГруппировка = ОтчетОбъект.Группировка;
	
			ТаблицаГруппировка.Очистить();
			
			УчетПоВсемОрганизациям = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ПользователиКлиентСервер.ТекущийПользователь(), "УчетПоВсемОрганизациям");
			Если УчетПоВсемОрганизациям Тогда
				НоваяСтрока = ТаблицаГруппировка.Добавить();
				НоваяСтрока.Поле           = "Организация";
				НоваяСтрока.Использование  = Ложь;
				НоваяСтрока.Представление  = НСтр("ru = 'Организация'");
				НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;	
			КонецЕсли;
			
			НоваяСтрока = ТаблицаГруппировка.Добавить();
			НоваяСтрока.Поле           = "Контрагент";
			НоваяСтрока.Использование  = Истина;
			НоваяСтрока.Представление  = НСтр("ru = 'Контрагент'");
			НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;	
			
			НоваяСтрока = ТаблицаГруппировка.Добавить();
			НоваяСтрока.Поле           = "Договор";
			НоваяСтрока.Использование  = Ложь;
			НоваяСтрока.Представление  = НСтр("ru = 'Договор'");
			НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

#КонецЕсли