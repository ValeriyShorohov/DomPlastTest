#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьПослеКомпоновкиМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьДанныеРасшифровки,
							|ИспользоватьРасширенныеПараметрыРасшифровки,
							|ИспользоватьПриВыводеПодвала",
							Истина, Ложь, Истина, Истина, Истина, Истина);
							
КонецФункции

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("Количество");
	
	Возврат НаборПоказателей;
	
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт
	
	ЗаголовокОтчета = НСтр("ru = 'Материальная ведомость %1
	                             |по счетам: %2'");
	ЗаголовокОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ЗаголовокОтчета, БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода), ПараметрыОтчета.СписокСчетов);
	
	Возврат ЗаголовокОтчета;
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();

	//////////////////////////////////
	// Установка параметров
	//
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ТекущаяДатаСеанса()));
	КонецЕсли;
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидыСубконто", ПараметрыОтчета.ВидыСубконтоСчетовНоменклатуры);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СписокОрганизаций", ПараметрыОтчета.СписокСтруктурныхЕдиниц);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ЕстьСклады", ПараметрыОтчета.ЕстьСклады);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СписокСчетов", ПараметрыОтчета.СписокСчетов);
	
	БухгалтерскиеОтчеты.ДобавитьОтборПоОрганизациямИПодразделениям(КомпоновщикНастроек, ПараметрыОтчета);
	
	Таблица = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ТаблицаКомпоновкиДанных"));
	
	///////////////////////////////////////	
	// Колонки отчета
	//
	ЕстьКоличество = ПараметрыОтчета.ПоказательКоличество;
	ЕстьСумма      = ПараметрыОтчета.ПоказательБУ;
	
	// НачальныйОстаток
	НоваяКолонкаОтчета = Таблица.Колонки.Добавить();
	НоваяКолонкаОтчета.Использование = ПараметрыОтчета.НачальныйОстаток;
	ГруппировкаКолонки = НоваяКолонкаОтчета.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ГруппировкаКолонки.Поле = Новый ПолеКомпоновкиДанных("ОстатокНаНачало.НачальныйОстаток");
	ПолеВыбора = НоваяКолонкаОтчета.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("ОстатокНаНачало.НачальныйОстаток");
	ПолеВыбора = НоваяКолонкаОтчета.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("ОстатокНаНачало.УчетнаяЦенаНачальныйОстаток");
	ПолеВыбора.Использование = ЕстьКоличество;
	ПолеВыбора = НоваяКолонкаОтчета.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("ОстатокНаНачало.КоличествоНачальныйОстаток");
	ПолеВыбора.Использование = ЕстьКоличество;
	ПолеВыбора = НоваяКолонкаОтчета.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("ОстатокНаНачало.СуммаНачальныйОстаток");
	ПолеВыбора.Использование = ЕстьСумма;
	
	// Приход
	НоваяКолонкаОтчета = Таблица.Колонки.Добавить();
	НоваяКолонкаОтчета.Использование = ПараметрыОтчета.Приход;
	ГруппировкаКолонки = НоваяКолонкаОтчета.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ГруппировкаКолонки.Поле = Новый ПолеКомпоновкиДанных("ОборотыПриход.Приход");
	ПолеВыбора = НоваяКолонкаОтчета.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("ОборотыПриход.Приход");
	ПолеВыбора = НоваяКолонкаОтчета.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("ОборотыПриход.КоличествоДт");
	ПолеВыбора.Использование = ЕстьКоличество;
	ПолеВыбора = НоваяКолонкаОтчета.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("ОборотыПриход.СуммаДт");
	ПолеВыбора.Использование = ЕстьСумма;

	// КорСчет
	Если ПараметрыОтчета.ПоКорСчетам Тогда
		КорСчет = НоваяКолонкаОтчета.Структура.Добавить();
		КорСчет.Использование = Истина;
		ГруппировкаКолонки = КорСчет.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ГруппировкаКолонки.Поле = Новый ПолеКомпоновкиДанных("ОборотыПриход.КорСчетДт");
		ПолеВыбора = КорСчет.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		НовыйОтбор = КорСчет.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
		НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОборотыПриход.КорСчетДт");
		НовыйОтбор.Использование = Истина;
		
		// КорСубконто1
		Если ПараметрыОтчета.ПоКорСубконто1 Тогда
			КорСубконто1 = КорСчет.Структура.Добавить();
			КорСубконто1.Использование = Истина;
			ГруппировкаКолонки = КорСубконто1.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ГруппировкаКолонки.Поле = Новый ПолеКомпоновкиДанных("ОборотыПриход.КорСубконто1Дт");
			ПолеВыбора = КорСубконто1.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			НовыйОтбор = КорСубконто1.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
			НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОборотыПриход.КорСубконто1Дт");
			НовыйОтбор.Использование = Истина;
			
			// КорСубконто2
			Если ПараметрыОтчета.ПоКорСубконто2 Тогда
				КорСубконто2 = КорСубконто1.Структура.Добавить();
				КорСубконто2.Использование = Истина;
				ГруппировкаКолонки = КорСубконто2.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
				ГруппировкаКолонки.Поле = Новый ПолеКомпоновкиДанных("ОборотыПриход.КорСубконто2Дт");
				ПолеВыбора = КорСубконто2.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
				НовыйОтбор = КорСубконто2.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
				НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОборотыПриход.КорСубконто2Дт");
				НовыйОтбор.Использование = Истина;
				
				// КорСубконто3
				Если ПараметрыОтчета.ПоКорСубконто3 Тогда
					КорСубконто3 = КорСубконто2.Структура.Добавить();
					КорСубконто3.Использование = Истина;
					ГруппировкаКолонки = КорСубконто3.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
					ГруппировкаКолонки.Поле = Новый ПолеКомпоновкиДанных("ОборотыПриход.КорСубконто3Дт");
					ПолеВыбора = КорСубконто3.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
					НовыйОтбор = КорСубконто3.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
					НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
					НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОборотыПриход.КорСубконто3Дт");
					НовыйОтбор.Использование = Истина;
				КонецЕсли;  // Если ПараметрыОтчета.ПоКорСубконто3
			КонецЕсли;  // Если ПараметрыОтчета.ПоКорСубконто2
		КонецЕсли;  // Если ПараметрыОтчета.ПоКорСубконто1
	КонецЕсли;  // Если ПараметрыОтчета.ПоКорСчетам
		
	// Расход
	НоваяКолонкаОтчета = Таблица.Колонки.Добавить();
	НоваяКолонкаОтчета.Использование = ПараметрыОтчета.Расход;
	ГруппировкаКолонки = НоваяКолонкаОтчета.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ГруппировкаКолонки.Поле = Новый ПолеКомпоновкиДанных("ОборотыРасход.Расход");
	ПолеВыбора = НоваяКолонкаОтчета.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("ОборотыРасход.Расход");
	ПолеВыбора = НоваяКолонкаОтчета.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("ОборотыРасход.КоличествоКт");
	ПолеВыбора.Использование = ЕстьКоличество;
	ПолеВыбора = НоваяКолонкаОтчета.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("ОборотыРасход.СуммаКт");
	ПолеВыбора.Использование = ЕстьСумма;

	// КорСчет
	Если ПараметрыОтчета.ПоКорСчетам Тогда
		КорСчет = НоваяКолонкаОтчета.Структура.Добавить();
		КорСчет.Использование = Истина;
		ГруппировкаКолонки = КорСчет.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ГруппировкаКолонки.Поле = Новый ПолеКомпоновкиДанных("ОборотыРасход.КорСчетКт");
		ПолеВыбора = КорСчет.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		НовыйОтбор = КорСчет.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
		НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОборотыРасход.КорСчетКт");
		НовыйОтбор.Использование = Истина;
		
		// КорСубконто1
		Если ПараметрыОтчета.ПоКорСубконто1 Тогда
			КорСубконто1 = КорСчет.Структура.Добавить();
			КорСубконто1.Использование = Истина;
			ГруппировкаКолонки = КорСубконто1.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ГруппировкаКолонки.Поле = Новый ПолеКомпоновкиДанных("ОборотыРасход.КорСубконто1Кт");
			ПолеВыбора = КорСубконто1.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			НовыйОтбор = КорСубконто1.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
			НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОборотыРасход.КорСубконто1Кт");
			НовыйОтбор.Использование = Истина;
			
			// КорСубконто2
			Если ПараметрыОтчета.ПоКорСубконто2 Тогда
				КорСубконто2 = КорСубконто1.Структура.Добавить();
				КорСубконто2.Использование = Истина;
				ГруппировкаКолонки = КорСубконто2.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
				ГруппировкаКолонки.Поле = Новый ПолеКомпоновкиДанных("ОборотыРасход.КорСубконто2Кт");
				ПолеВыбора = КорСубконто2.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
				НовыйОтбор = КорСубконто2.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
				НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОборотыРасход.КорСубконто2Кт");
				НовыйОтбор.Использование = Истина;
				
				// КорСубконто3
				Если ПараметрыОтчета.ПоКорСубконто3 Тогда
					КорСубконто3 = КорСубконто2.Структура.Добавить();
					КорСубконто3.Использование = Истина;
					ГруппировкаКолонки = КорСубконто3.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
					ГруппировкаКолонки.Поле = Новый ПолеКомпоновкиДанных("ОборотыРасход.КорСубконто3Кт");
					ПолеВыбора = КорСубконто3.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
					НовыйОтбор = КорСубконто3.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
					НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
					НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОборотыРасход.КорСубконто3Кт");
					НовыйОтбор.Использование = Истина;
				КонецЕсли;  // Если ПараметрыОтчета.ПоКорСубконто3
			КонецЕсли;  // Если ПараметрыОтчета.ПоКорСубконто2
		КонецЕсли;  // Если ПараметрыОтчета.ПоКорСубконто1
	КонецЕсли;  // Если ПараметрыОтчета.ПоКорСчетам
	
	// Конечный остаток
	НоваяКолонкаОтчета = Таблица.Колонки.Добавить();
	НоваяКолонкаОтчета.Использование = ПараметрыОтчета.КонечныйОстаток;
	ГруппировкаКолонки = НоваяКолонкаОтчета.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ГруппировкаКолонки.Поле = Новый ПолеКомпоновкиДанных("ОстатокНаКонец.КонечныйОстаток");
	ПолеВыбора = НоваяКолонкаОтчета.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("ОстатокНаКонец.КонечныйОстаток");
	ПолеВыбора = НоваяКолонкаОтчета.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("ОстатокНаКонец.УчетнаяЦенаКонечныйОстаток");
	ПолеВыбора.Использование = ЕстьКоличество;
	ПолеВыбора = НоваяКолонкаОтчета.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("ОстатокНаКонец.КоличествоКонечныйОстаток");
	ПолеВыбора.Использование = ЕстьКоличество;
	ПолеВыбора = НоваяКолонкаОтчета.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("ОстатокНаКонец.СуммаКонечныйОстаток");
	ПолеВыбора.Использование = ЕстьСумма;
	
	Структура = Таблица.Строки.Добавить();
	КоличествоГруппировок = 0;
	Первый = Истина;
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Если Не Первый Тогда 
				Структура = Структура.Структура.Добавить();
			КонецЕсли;
			Первый = Ложь;
			
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование = Истина;
			ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			
			Если ПолеВыбраннойГруппировки.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Иерархия Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.ТолькоИерархия Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;
			
			Если ПолеВыбраннойГруппировки.Поле = "Номенклатура" Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Структура.Выбор, "SystemFields.SerialNumber");
			КонецЕсли;
			
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
			КоличествоГруппировок = КоличествоГруппировок + 1;
			
			Если ПолеВыбраннойГруппировки.Поле = "Номенклатура" Тогда
				ДопПолеСчетУчета = ПараметрыОтчета.ДополнительныеПоля.Найти("Номенклатура.СчетУчета", "Поле");
				Если ДопПолеСчетУчета <> Неопределено И ДопПолеСчетУчета.Использование Тогда
					ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
					ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("Номенклатура.СчетУчета");
					ПараметрыОтчета.ДополнительныеПоля.Удалить(ДопПолеСчетУчета);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);

	ЗначениеПараметра = Таблица.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("HorizontalOverallPlacement"));
	ЗначениеПараметра.Значение = РасположениеИтоговКомпоновкиДанных.Нет;
	ЗначениеПараметра.Использование = Истина;
	
	ЗначениеПараметра = Таблица.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("VerticalOverallPlacement"));
	ЗначениеПараметра.Использование = Истина;
	Если ПараметрыОтчета.ОбщиеИтоги Тогда
		ЗначениеПараметра.Значение = РасположениеИтоговКомпоновкиДанных.Конец;
	Иначе
		ЗначениеПараметра.Значение = РасположениеИтоговКомпоновкиДанных.Нет;
	КонецЕсли;
	
	Для Каждого Элемент ИЗ КомпоновщикНастроек.Настройки.Структура Цикл
		Если ТипЗнч(Элемент) = Тип("ТаблицаКомпоновкиДанных") ТОгда
			Для Каждого Колонка ИЗ Элемент.Колонки Цикл
				Если ТипЗнч(Колонка) = Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
					ЭтоПриход = Ложь;
					ЭтоРасход = Ложь;
					Для Каждого ПолеГруппировки ИЗ Колонка.ПоляГруппировки.Элементы Цикл
						Если ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("ОборотыПриход.Приход") Тогда
							ЭтоПриход = Истина;
							Прервать;
						КонецЕсли;
						Если ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("ОборотыРасход.Расход") Тогда
							ЭтоРасход = Истина;
							Прервать;
						КонецЕсли;
					КонецЦикла;
					Если ЭтоПриход ИЛИ ЭтоРасход ТОгда
						ЗначениеПараметра = Колонка.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("GroupPlacement"));
						ЗначениеПараметра.Использование = Истина;
						ЗначениеПараметра.Значение = РасположениеГруппировкиКомпоновкиДанных.Конец;
						ЗначениеПараметра = Колонка.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("РасположениеОбщихИтогов"));
						ЗначениеПараметра.Использование = Истина;
						ЗначениеПараметра.Значение = РасположениеИтоговКомпоновкиДанных.Конец;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Для Каждого СтрокаОтчета ИЗ Элемент.Строки Цикл
				Если ТипЗнч(СтрокаОтчета) = Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
					ЗначениеПараметра = СтрокаОтчета.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("РасположениеОбщихИтогов"));
					ЗначениеПараметра.Использование = Истина;
					ЗначениеПараметра.Значение = РасположениеИтоговКомпоновкиДанных.Конец;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

КонецПроцедуры

Процедура ПриВыводеПодвала(ПараметрыОтчета, Результат) Экспорт
	
	Если НЕ ПараметрыОтчета.ВыводитьПодписи Тогда
		Возврат;
	КонецЕсли;
	
	Макет = ПолучитьМакет("МакетПодвала");
	ОбластьИнтервал = Макет.ПолучитьОбласть("ПодписиИнтервал");
	ОбластьРуководители = Макет.ПолучитьОбласть("ПодписиРуководители");
	ОбластьМОЛ = Макет.ПолучитьОбласть("ПодписиМОЛ");
	
	Результат.Вывести(ОбластьИнтервал);
	
	Если ПараметрыОтчета.ВыводитьПодписиРуководителей Тогда
		
		Если ПараметрыОтчета.СписокСтруктурныхЕдиниц.Количество() > 0 Тогда
			ИскомаяОрганизация = ПараметрыОтчета.СписокСтруктурныхЕдиниц[0].Значение;
		Иначе
			ИскомаяОрганизация = Справочники.Организации.ПустаяСсылка();
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ИскомаяОрганизация) Тогда
			ИскомаяОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();             
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИскомаяОрганизация) Тогда
			ОтветЛица = ОбщегоНазначенияБКВызовСервера.ОтветственныеЛицаОрганизаций(ИскомаяОрганизация, КонецДня(ПараметрыОтчета.КонецПериода));
			Если НЕ ЗначениеЗаполнено(ОтветЛица.РуководительДолжность) Тогда
				ОтветЛица.РуководительДолжность     = НСтр("ru = 'Руководитель'");
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(ОтветЛица.ГлавныйБухгалтерДолжность) Тогда
				ОтветЛица.ГлавныйБухгалтерДолжность = НСтр("ru = 'Главный бухгалтер'");
			КонецЕсли;
			ОбластьРуководители.Параметры.Заполнить(ОтветЛица);
		Иначе
			ОтветЛица = Новый Структура("РуководительДолжность, ГлавныйБухгалтерДолжность",
			                             НСтр("ru = 'Руководитель'"), НСтр("ru = 'Главный бухгалтер'"));
		КонецЕсли;
		ОбластьРуководители.Параметры.Заполнить(ОтветЛица);
		
		Результат.Вывести(ОбластьРуководители);
		
	КонецЕсли;
	
	// попытаемся определить ответственного по складу, если отбор установлен
	ОтборПоСкладу = Неопределено;
	ИскомыйСклад  = Неопределено;
	Для Каждого ЭлементОтбора Из ПараметрыОтчета.НастройкиКомпоновкиДанных.Отбор.Элементы Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") И ВРег(ЭлементОтбора.ЛевоеЗначение) = "СКЛАД" Тогда
			ОтборПоСкладу = ЭлементОтбора;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ОтборПоСкладу <> Неопределено И ОтборПоСкладу.Использование Тогда
		
		Склады = ОтборПоСкладу.ПравоеЗначение;
		
		// в отборе может присутствовать список складов
		Если ТипЗнч(Склады) = Тип("СписокЗначений") Тогда
			Если Склады.Количество() > 0 Тогда
				ИскомыйСклад = Склады[0].Значение;
			КонецЕсли;
		ИначеЕсли ТипЗнч(Склады) = Тип("СправочникСсылка.Склады") Тогда
			ИскомыйСклад = Склады;
		КонецЕсли;
	КонецЕсли;
	
	// если ничего не нашли, то берем из настроек пользователя
	Если Не ЗначениеЗаполнено(ИскомыйСклад) Тогда
		ИскомыйСклад = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(Пользователи.ТекущийПользователь(), "ОсновнойСклад");             		
	КонецЕсли;
              			
	ОтветЛицо = ПрочитатьОтветственноеЛицо(ИскомыйСклад);
	Если Не ОтветЛицо = Неопределено Тогда
		ОбластьМОЛ.Параметры.ОтветственноеЛицо = ОбщегоНазначенияБК.ФамилияИнициалыФизЛица(ОтветЛицо);
	КонецЕсли;
	
	Результат.Вывести(ОбластьМОЛ);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
	
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(Адрес);
	
	ОтчетОбъект       = ДанныеОбъекта.Объект;
	ДанныеРасшифровки = ДанныеОбъекта.ДанныеРасшифровки;
	
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
	ЕстьПоказатель = Ложь;
	ПервыйЭлемент  = Неопределено;
	Счет  = Неопределено;
	Склад = Неопределено;
	Номенклатура   = Неопределено;
	
	УстановитьВсеПоказатели = Ложь;
	
	ВидыСубконтоСчета = Новый Структура;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(ДанныеРасшифровки.Настройки);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ДанныеОбъекта.Объект.СхемаКомпоновкиДанных));

	МассивПолей = БухгалтерскиеОтчетыВызовСервера.ПолучитьМассивПолейРасшифровки(Расшифровка, ДанныеРасшифровки, КомпоновщикНастроек, Истина);
	
	МаксимальныйИндекс = МассивПолей.ВГраница();
	Для Индекс = 0 по МаксимальныйИндекс Цикл
		Элемент = МассивПолей[МаксимальныйИндекс - Индекс];
		Если ТипЗнч(Элемент) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") Тогда
			
			Если Найти(Элемент.Поле, "ОборотыРасход.")
				ИЛИ Найти(Элемент.Поле, "ОборотыПриход.")
				ИЛИ Найти(Элемент.Поле, "ОстатокНаНачало.")
				ИЛИ Найти(Элемент.Поле, "ОстатокНаКонец.") Тогда
				МассивПолей.Удалить(МаксимальныйИндекс - Индекс);
				Продолжить;
			КонецЕсли;
			
			Если Элемент.Поле <> "Показатель" Тогда 
				ПервыйЭлемент = Элемент;
			КонецЕсли;
			Если Элемент.Поле = "Показатель" Тогда
				Элемент.Значение = ?(Элемент.Значение = "Сумма", "БУ", Элемент.Значение);
				УстановитьВсеПоказатели = Элемент.Значение = "УчетнаяЦена";
				ЕстьПоказатель = Истина;
			КонецЕсли;
			
			Если (Элемент.Поле = "Номенклатура.СчетУчета" ИЛИ Элемент.Поле = "Счет") И ТипЗнч(Элемент.Значение) = Тип("ПланСчетовСсылка.Типовой") Тогда
				Счет = Элемент.Значение;
				СубконтоНоменклатура = Счет.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Номенклатура);
				Если СубконтоНоменклатура <> Неопределено Тогда
					ВидыСубконтоСчета.Вставить("Номенклатура", СубконтоНоменклатура.НомерСтроки);
				КонецЕсли;
				СубконтоСклады = Счет.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Склады);
				Если СубконтоСклады <> Неопределено Тогда
					ВидыСубконтоСчета.Вставить("Склады", СубконтоСклады.НомерСтроки);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	СписокПунктовМеню = Новый СписокЗначений;
	
	Если ЕстьПоказатель Тогда
		
		Если НЕ ЗначениеЗаполнено(Счет) ТОгда
			ТекстСообщения = НСтр("ru = 'Расшифровка невозможна. Неизвестен счет.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
			Возврат;
		КонецЕсли;
		
		ПредставлениеДляКарточкиСчета = НСтр("ru = 'Карточка счета %Счет%'");
		ПредставлениеДляКарточкиСчета = СтрЗаменить(ПредставлениеДляКарточкиСчета, "%Счет%", Счет);
		
        СписокПунктовМеню.Добавить("КарточкаСчетаТиповой", ПредставлениеДляКарточкиСчета);
		
	Иначе
		
		Если ЗначениеЗаполнено(ПервыйЭлемент.Значение) И Не БухгалтерскиеОтчетыКлиентСервер.ПростойТип(ПервыйЭлемент.Значение) Тогда
			ПредставлениеОткрытьОбъект = НСтр("ru = 'Открыть ""%Значение%""'");
			Представление = СтрЗаменить(ПредставлениеОткрытьОбъект, "%Значение%", ПервыйЭлемент.Значение);
			СписокПунктовМеню.Добавить(ПервыйЭлемент.Значение, Представление);
		КонецЕсли;
	КонецЕсли;
	
	НастройкиРасшифровки = Новый Структура;   
	Если СписокПунктовМеню <> Неопределено Тогда
		Для Каждого ПунктМеню Из СписокПунктовМеню Цикл
			Если ТипЗнч(ПунктМеню.Значение) = Тип("Строка") Тогда
				НастройкиРасшифровки.Вставить(ПунктМеню.Значение, ПолучитьНастройкиДляРасшифровки(МассивПолей, ОтчетОбъект, УстановитьВсеПоказатели, ВидыСубконтоСчета));
			КонецЕсли;
		КонецЦикла;
		
		ДанныеОбъекта.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
		Адрес = ПоместитьВоВременноеХранилище(ДанныеОбъекта, Адрес);
		
		ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьНастройкиДляРасшифровки(МассивПолей, ОтчетОбъект, УстановитьВсеПоказатели, ВидыСубконтоСчета)
	
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	
	Счет              = Неопределено;
	
	ЕстьСчет          = Истина;
	ЕстьПодразделение = Ложь;
	
	Для Каждого Элемент Из МассивПолей Цикл
		Если ТипЗнч(Элемент) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных")
			И ( Элемент.Поле = "Номенклатура.СчетУчета" ИЛИ Элемент.Поле = "Счет") Тогда
			Счет = Элемент.Значение;
		КонецЕсли;
	КонецЦикла;
	
	ДобавитьОтборПоВидСубконто    = Истина;
	ДобавитьОтборПоВидКорСубконто = Истина;
	
	ПользовательскиеНастройки  = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ПользовательскиеОтборы     = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ДополнительныеСвойства     = ПользовательскиеНастройки.ДополнительныеСвойства;
	ДополнительныеСвойства.Вставить("ПараметрыВыводаРасшифровки", Новый Структура);
	ПараметрыВыводаРасшифровки = ДополнительныеСвойства.ПараметрыВыводаРасшифровки;
	
	ПользовательскиеОтборы.ИдентификаторПользовательскойНастройки = "Отбор";
	
	ДополнительныеСвойства.Вставить("РежимРасшифровки", Истина);
	ДополнительныеСвойства.Вставить("Счет", Счет);
	
	Для Каждого Отбор из МассивПолей Цикл
		Если ТипЗнч(Отбор) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных")
			И  Отбор.Поле = "СтруктурноеПодразделение" тогда
			Отбор.Поле = "Подразделение";
		КонецЕсли;	
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("СписокСтруктурныхЕдиниц", ОтчетОбъект.СписокСтруктурныхЕдиниц);
	ПредставлениеСпискаОрганизаций = БухгалтерскиеОтчетыКлиентСервер.ВыгрузитьСписокВСтроку(ОтчетОбъект.СписокСтруктурныхЕдиниц);
	ДополнительныеСвойства.Вставить("ПредставлениеСпискаОрганизаций", ПредставлениеСпискаОрганизаций);

	ДополнительныеСвойства.Вставить("СписокПодразделений", ОтчетОбъект.СписокПодразделений);
	ПредставлениеСпискаПодразделений = БухгалтерскиеОтчетыКлиентСервер.ВыгрузитьСписокВСтроку(ОтчетОбъект.СписокПодразделений);
	ДополнительныеСвойства.Вставить("ПредставлениеСпискаПодразделений", ПредставлениеСпискаПодразделений);
	ДополнительныеСвойства.Вставить("СписокВладельцевГоловныхПодразделений", ОтчетОбъект.СписокВладельцевГоловныхПодразделений);
	
	ГруппировкаПоОрганизации 	= Неопределено;
	ГруппировкаПоПодразделению 	= Неопределено;
	
	СписокСтруктурныхЕдиниц = Новый СписокЗначений;
	СписокПодразделений = Новый СписокЗначений;
	
	СписокПолейОтборов = Новый Массив;
	Для каждого Отбор из МассивПолей Цикл
		Если ТипЗнч(Отбор) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") тогда
			Если Отбор.Значение = NULL тогда
				Продолжить;
			КонецЕсли;
			Если (Отбор.Поле = "Счет" ИЛИ Отбор.Поле = "Номенклатура.СчетУчета") И НЕ ЕстьСчет Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение, ВидСравненияКомпоновкиДанных.ВИерархии);		
			ИначеЕсли (Отбор.Поле = "Счет" ИЛИ Отбор.Поле = "Номенклатура.СчетУчета") И ЕстьСчет Тогда	
			ИначеЕсли Отбор.Поле = "Номенклатура"
				      И ВидыСубконтоСчета.Свойство("Номенклатура") И ВидыСубконтоСчета.Номенклатура <> Неопределено Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, "Субконто" + ВидыСубконтоСчета.Номенклатура, Отбор.Значение);
				СписокПолейОтборов.Добавить(Отбор.Поле);
			ИначеЕсли Отбор.Поле = "Склад"
				      И ВидыСубконтоСчета.Свойство("Склады") И ВидыСубконтоСчета.Склады <> Неопределено Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, "Субконто" + ВидыСубконтоСчета.Склады, Отбор.Значение);
				СписокПолейОтборов.Добавить(Отбор.Поле);
			ИначеЕсли Найти(Отбор.Поле, "КорСубконто") = 1 тогда
				ПозицияСубконто = Найти(Отбор.Поле, "КорСубконто");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Сред(Отбор.Поле, ПозицияСубконто, СтрДлина(Отбор.Поле) - ПозицияСубконто + 1), Отбор.Значение);
			ИначеЕсли Отбор.Поле = "Подразделение" тогда
				ГруппировкаПоПодразделению = Отбор.Значение;
				Если ПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда
					СписокПодразделений.Очистить();
					СписокПодразделений.Добавить(Отбор.Значение, ?(ЗначениеЗаполнено(Отбор.Значение), "", "Головное подразделение"));
					ДополнительныеСвойства.Вставить("СписокПодразделений", СписокПодразделений);
					ПредставлениеСпискаПодразделений = БухгалтерскиеОтчетыКлиентСервер.ВыгрузитьСписокВСтроку(СписокПодразделений);
					ДополнительныеСвойства.Вставить("ПредставлениеСпискаПодразделений", ПредставлениеСпискаПодразделений);
				Иначе
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение);
				КонецЕсли;
				ЕстьПодразделение = Истина;
			ИначеЕсли Отбор.Поле = "Организация" Тогда
				ГруппировкаПоОрганизации = Отбор.Значение;
				СписокСтруктурныхЕдиниц.Очистить();
				СписокСтруктурныхЕдиниц.Добавить(Отбор.Значение);
				ДополнительныеСвойства.Вставить("СписокСтруктурныхЕдиниц", СписокСтруктурныхЕдиниц);
				ПредставлениеСпискаОрганизаций = БухгалтерскиеОтчетыКлиентСервер.ВыгрузитьСписокВСтроку(СписокСтруктурныхЕдиниц);
				ДополнительныеСвойства.Вставить("ПредставлениеСпискаОрганизаций", ПредставлениеСпискаОрганизаций);
			ИначеЕсли Отбор.Поле = "Показатель" Тогда 
				Показатель = Отбор.Значение;
			Иначе
				Если Отбор.Иерархия Тогда
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение, ВидСравненияКомпоновкиДанных.ВИерархии);
				Иначе
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение);
				КонецЕсли;
			КонецЕсли;	
		ИначеЕсли ТипЗнч(Отбор) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Если СписокПолейОтборов.Найти(Строка(Отбор.ЛевоеЗначение)) = Неопределено Тогда
				Если Отбор.Представление = "###ОтборПоОрганизации###" Тогда
					ДополнительныеСвойства.Вставить("СписокСтруктурныхЕдиниц", Отбор.ПравоеЗначение);
					ПредставлениеСпискаОрганизаций = БухгалтерскиеОтчетыКлиентСервер.ВыгрузитьСписокВСтроку(Отбор.ПравоеЗначение);
					ДополнительныеСвойства.Вставить("ПредставлениеСпискаОрганизаций", ПредставлениеСпискаОрганизаций);
				ИначеЕсли Отбор.Представление = "###ОтборПоВидуУчета###" Тогда
					ДополнительныеСвойства.Вставить("ВидУчета", Отбор.ПравоеЗначение);
				ИначеЕсли Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение") И ЕстьПодразделение Тогда
				ИначеЕсли Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение") 
					И Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии
					И ПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда
					ДополнительныеСвойства.Вставить("Подразделение", Отбор.ПравоеЗначение);
				ИначеЕсли Строка(Отбор.ЛевоеЗначение) = "Склад"
					      И ВидыСубконтоСчета.Свойство("Склады") И ВидыСубконтоСчета.Склады <> Неопределено Тогда
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, "Субконто" + ВидыСубконтоСчета.Склады, Отбор.ПравоеЗначение, Отбор.ВидСравнения);
				Иначе
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.ЛевоеЗначение, Отбор.ПравоеЗначение, Отбор.ВидСравнения);
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли ТипЗнч(Отбор) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Если Отбор.Представление = "###ОтборПоОрганизации###" Тогда
				
				Если (ГруппировкаПоОрганизации = Неопределено) Тогда 
					ДополнительныеСвойства.Вставить("СписокСтруктурныхЕдиниц", ОтчетОбъект.СписокСтруктурныхЕдиниц);
					ПредставлениеСпискаОрганизаций = БухгалтерскиеОтчетыКлиентСервер.ВыгрузитьСписокВСтроку(ОтчетОбъект.СписокСтруктурныхЕдиниц);
					ДополнительныеСвойства.Вставить("ПредставлениеСпискаОрганизаций", ПредставлениеСпискаОрганизаций);
				КонецЕсли;
				
				Если (ГруппировкаПоПодразделению = Неопределено) Тогда
					ДополнительныеСвойства.Вставить("СписокПодразделений", ОтчетОбъект.СписокПодразделений);
					ПредставлениеСпискаПодразделений = БухгалтерскиеОтчетыКлиентСервер.ВыгрузитьСписокВСтроку(ОтчетОбъект.СписокПодразделений);
					ДополнительныеСвойства.Вставить("ПредставлениеСпискаПодразделений", ПредставлениеСпискаПодразделений);
					ДополнительныеСвойства.Вставить("СписокВладельцевГоловныхПодразделений", ОтчетОбъект.СписокВладельцевГоловныхПодразделений);
				КонецЕсли;
				
			КонецЕсли;				
			
		КонецЕсли;
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("НачалоПериода", ОтчетОбъект.НачалоПериода);
	ДополнительныеСвойства.Вставить("КонецПериода" , ОтчетОбъект.КонецПериода);
	
	// Настройка показателей
	Если УстановитьВсеПоказатели Тогда
		Для Каждого ИмяПоказателя Из ОтчетОбъект.НаборПоказателей Цикл
			ДополнительныеСвойства.Вставить("Показатель" + ИмяПоказателя , ОтчетОбъект["Показатель" + ИмяПоказателя]);
		КонецЦикла;
		Если ОтчетОбъект.НаборПоказателей.Найти("Количество") = Неопределено Тогда
			Если ЕстьСчет И ЗначениеЗаполнено(Счет) И Счет.Количественный Тогда
				ДополнительныеСвойства.Вставить("ПоказательКоличество", Истина);
			КонецЕсли;
		КонецЕсли;
	Иначе
		ДополнительныеСвойства.Вставить("Показатель" + Показатель , Истина);
	КонецЕсли;
	
	Возврат ПользовательскиеНастройки;
	
КонецФункции

Функция ПрочитатьОтветственноеЛицо(ИскомыйСклад)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ФизическоеЛицо
	               |ИЗ
	               |	РегистрСведений.ОтветственныеЛица.СрезПоследних(&Период, СтруктурнаяЕдиница = &СтруктурнаяЕдиница) КАК ОтветственныеЛицаСрезПоследних";
	
	Запрос.УстановитьПараметр("Период", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", ИскомыйСклад);
	
	СрезПоследних = Запрос.Выполнить().Выгрузить();
	 	
	Если СрезПоследних.Количество() < 1 Тогда
		Возврат Неопределено;
	Иначе
		Возврат СрезПоследних[0].ФизическоеЛицо;
	КонецЕсли;

КонецФункции // ПрочитатьОтветственноеЛицо()


#КонецЕсли