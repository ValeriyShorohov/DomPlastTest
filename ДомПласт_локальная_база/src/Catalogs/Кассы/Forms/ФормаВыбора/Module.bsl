
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
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
	
	Если Параметры.Свойство("ВалютаДенежныхСредств") Тогда
		
		ВалютаОтбора = Параметры.ВалютаДенежныхСредств;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ВалютаДенежныхСредств",
		ВалютаОтбора,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	КонецЕсли;
	
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	Элементы.ОтборОрганизация.Видимость = ОтборОрганизацияИспользование;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)

	Если Параметры.Свойство("ВыборВОтчет") И Параметры.ВыборВОтчет Тогда
		
		ЭлементОтбораОрганизация = Неопределено;

		Отборы = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.КомпоновщикНастроек.Настройки.Отбор, "Владелец");
		
		Если Отборы.Количество() > 0 Тогда
			ЭлементОтбораОрганизация = Отборы[0];
		КонецЕсли;
		
		Если ЭлементОтбораОрганизация = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Для Каждого ЭлементНастроек Из Настройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастроек) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
				Если ЭлементНастроек.ИдентификаторПользовательскойНастройки = "Владелец" И ЭлементОтбораОрганизация <> Неопределено Тогда
					ЭлементНастроек.Использование  = ЭлементОтбораОрганизация.Использование;
					ЭлементНастроек.ВидСравнения   = ЭлементОтбораОрганизация.ВидСравнения;
					ЭлементНастроек.ПравоеЗначение = ЭлементОтбораОрганизация.ПравоеЗначение;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры


