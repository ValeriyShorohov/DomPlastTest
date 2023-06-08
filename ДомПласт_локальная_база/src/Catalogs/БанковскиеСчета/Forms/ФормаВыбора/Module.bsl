
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Параметры.РежимВыбора Тогда
		
		Если Параметры.Отбор.Свойство("Владелец") Тогда
			ОтборОрганизация = Параметры.Отбор.Владелец;
		КонецЕсли;
				
		Если Параметры.Свойство("ВыборВОтчет") И Параметры.ВыборВОтчет Тогда
			
			Если Параметры.Отбор.Свойство("Владелец") Тогда
				
				ОтборОрганизацияКонтрагент = Параметры.Отбор.Владелец;
				Параметры.Отбор.Удалить("Владелец");
				
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				ЭтаФорма.Список, "Владелец", ОтборОрганизацияКонтрагент, ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии,, Истина, 
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
				
			Иначе
				
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				ЭтаФорма.Список, "Владелец",, ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии,, Ложь, 
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	
	Если Параметры.Свойство("ВыбиратьСчетаВВалюте") И Параметры.ВыбиратьСчетаВВалюте Тогда
		
		ВалютаРегламентированногоУчета = ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ВалютаДенежныхСредств",
		ВалютаРегламентированногоУчета,
		ВидСравненияКомпоновкиДанных.НеРавно,
		,
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	КонецЕсли;     	
	
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	Элементы.ОтборОрганизация.Видимость = ОтборОрганизацияИспользование;
	
	ТипВладельца = ТипЗнч(ОтборОрганизация);
	Если ОтборОрганизацияИспользование Тогда
		Если ТипВладельца = Тип("СправочникСсылка.Контрагенты") Тогда
			Элементы.ОтборОрганизация.Заголовок = НСтр("ru = 'Контрагент'");
		ИначеЕсли ТипВладельца = Тип("СправочникСсылка.Организации") Тогда
			Элементы.ОтборОрганизация.Заголовок = НСтр("ru = 'Организация'");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)

	Если Параметры.Свойство("ВыборВОтчет") И Параметры.ВыборВОтчет Тогда
		
		ОтборОрганизация = Неопределено;
		
		Отборы = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.КомпоновщикНастроек.Настройки.Отбор, "Владелец");
		
		Если Отборы.Количество() > 0 Тогда
			ОтборОрганизация = Отборы[0];
		КонецЕсли;
		
		Если ОтборОрганизация = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Для Каждого ЭлементНастроек Из Настройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастроек) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
				Если ЭлементНастроек.ИдентификаторПользовательскойНастройки = "Владелец" И ОтборОрганизация <> Неопределено Тогда
					ЭлементНастроек.Использование  = ОтборОрганизация.Использование;
					ЭлементНастроек.ВидСравнения   = ОтборОрганизация.ВидСравнения;
					ЭлементНастроек.ПравоеЗначение = ОтборОрганизация.ПравоеЗначение;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
			
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦ ФОРМЫ

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

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

