#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьПослеКомпоновкиМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьДанныеРасшифровки",
							Истина, Истина, Истина, Истина);
							
КонецФункции

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("ВалютнаяСумма");
	НаборПоказателей.Добавить("Количество");
	НаборПоказателей.Добавить("РазвернутоеСальдо");
	
	Возврат НаборПоказателей;
	
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт
	
	ЗаголовокОтчета = НСтр("ru = 'Анализ счета %1 %2'");
	ЗаголовокОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ЗаголовокОтчета, ПараметрыОтчета.Счет, БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода));
	
	Возврат ЗаголовокОтчета;
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Счет", ПараметрыОтчета.Счет);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", ПараметрыОтчета.Периодичность);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ПараметрыОтчета.КонецПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ТекущаяДатаСеанса()));
	КонецЕсли;
	
	БухгалтерскиеОтчеты.ДобавитьОтборПоОрганизациямИПодразделениям(КомпоновщикНастроек, ПараметрыОтчета);
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");
	МассивПоказателей.Добавить("ВалютнаяСумма");
	МассивПоказателей.Добавить("Количество");
	
	Если КоличествоПоказателей > 1 Тогда
		
		ГруппаПоказатели = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПоказатели.Заголовок     = НСтр("ru = 'Показатели'");
		ГруппаПоказатели.Использование = Истина;
		ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Индекс = 1 По 3 Цикл
			Если Индекс = 1 Тогда
				ЗначениеПодстановки = "НачальныйОстаток";
			ИначеЕсли Индекс = 2 Тогда 
				ЗначениеПодстановки = "Оборот";
			Иначе
				ЗначениеПодстановки = "КонечныйОстаток";
			КонецЕсли;
			Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
				Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ИмяПоказателя + ЗначениеПодстановки);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	ГруппаДт = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаДт.Заголовок     = НСтр("ru = 'Дебет'");
	ГруппаДт.Использование = Истина;
	ГруппаДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаКт = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаКт.Заголовок     = НСтр("ru = 'Кредит'");
	ГруппаКт.Использование = Истина;
	ГруппаКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;	
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");
		
	МассивПоказателейДоп = Новый Массив;
	МассивПоказателейДоп.Добавить("ВалютнаяСумма");
	МассивПоказателейДоп.Добавить("Количество");
	
	ВидОстатков = ?(ПараметрыОтчета.ПоказательРазвернутоеСальдо, "Развернутый", "");
	
	Для Каждого ЭлементМассива Из МассивПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ЭлементМассива] Тогда 
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДт, "СальдоНаНачалоПериода." + ЭлементМассива + "Начальный" + ВидОстатков + "ОстатокДт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаКт, "СальдоНаНачалоПериода." + ЭлементМассива + "Начальный" + ВидОстатков + "ОстатокКт");
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементМассива Из МассивПоказателейДоп Цикл
		Если ПараметрыОтчета["Показатель" + ЭлементМассива] Тогда 
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДт, "СальдоНаНачалоПериода." + ЭлементМассива + "НачальныйОстатокДт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаКт, "СальдоНаНачалоПериода." + ЭлементМассива + "НачальныйОстатокКт");
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементМассива Из МассивПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ЭлементМассива] Тогда 
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДт,        "ОборотыЗаПериод."       + ЭлементМассива + "ОборотДт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаКт,        "ОборотыЗаПериод."       + ЭлементМассива + "ОборотКт");
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементМассива Из МассивПоказателейДоп Цикл
		Если ПараметрыОтчета["Показатель" + ЭлементМассива] Тогда 
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДт,        "ОборотыЗаПериод."       + ЭлементМассива + "ОборотДт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаКт,        "ОборотыЗаПериод."       + ЭлементМассива + "ОборотКт");
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементМассива Из МассивПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ЭлементМассива] Тогда 
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДт,  "СальдоНаКонецПериода."  + ЭлементМассива + "Конечный"  + ВидОстатков + "ОстатокДт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаКт,  "СальдоНаКонецПериода."  + ЭлементМассива + "Конечный"  + ВидОстатков + "ОстатокКт");
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементМассива Из МассивПоказателейДоп Цикл
		Если ПараметрыОтчета["Показатель" + ЭлементМассива] Тогда 
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДт,  "СальдоНаКонецПериода."  + ЭлементМассива + "КонечныйОстатокДт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаКт,  "СальдоНаКонецПериода."  + ЭлементМассива + "КонечныйОстатокКт");
		КонецЕсли;
	КонецЦикла;
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	Структура = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	Первый = Истина;
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Если Не Первый Тогда 
				Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			КонецЕсли;
			Первый = Ложь;
						
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			
			Если ПолеВыбраннойГруппировки.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Иерархия Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.ТолькоИерархия Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;
			
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных")); 
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "РасположениеГруппировки", РасположениеГруппировкиКомпоновкиДанных.НачалоИКонец);
			
			Если ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("Счет") Тогда 
				
				Если Не ПараметрыОтчета.ПоСубсчетам Тогда
					ЗначениеОтбора = БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Структура.Отбор, "SystemFields.LevelInGroup", 1);
					ЗначениеОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;		
					БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	// Период
	Если ПараметрыОтчета.Периодичность > 0 Тогда
		БухгалтерскиеОтчетыВызовСервера.ДобавитьГруппировкуПоПериоду(ПараметрыОтчета, Структура);
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "РасположениеГруппировки", РасположениеГруппировкиКомпоновкиДанных.НачалоИКонец); 
	КонецЕсли;
	
	// Кор счет
	Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование  = Истина;
	ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("КорСчет");	
	Если ПараметрыОтчета.ПоСубсчетамКорСчетов И ПараметрыОтчета.ПоПодразделамКорСчетов Тогда
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
	ИначеЕсли ПараметрыОтчета.ПоСубсчетамКорСчетов Тогда
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
	ИначеЕсли ПараметрыОтчета.ПоПодразделамКорСчетов Тогда
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
	КонецЕсли;
	Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "ВыводитьОтбор"               , ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "РасположениеПолейГруппировки", РасположениеПолейГруппировкиКомпоновкиДанных.ОтдельноИТолькоВИтогах); 
	
	//КорСубконто 
	КоличествоКорГруппировок = 0;
	Для Каждого СтрокаГруппировки Из ПараметрыОтчета.ГруппировкаКор Цикл
		Если СтрокаГруппировки.Использование Тогда
			КоличествоКорСубконто = СтрЧислоВхождений(СтрокаГруппировки.ПоСубконто, "+");
			КоличествоКорГруппировок = Макс(КоличествоКорГруппировок, КоличествоКорСубконто);
		КонецЕсли;
	КонецЦикла;
	
	Для Индекс = 1 По КоличествоКорГруппировок Цикл 
		Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("КорСубконто" + Индекс);		
		Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));	
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	КорСчетаВсе = Новый СписокЗначений;
	
	// Корректировка запроса для группировка по кор. счетам
	ИсходныйТекстЗапроса = МакетКомпоновки.НаборыДанных.ОсновнойНаборДанных.Элементы.Обороты.Запрос;
	КонечныйТекстЗапроса = "";
	ПозицияКорсчета = СтрНайти(ИсходныйТекстЗапроса, ", ) КАК ТиповойОбороты");
	ПостояннаяЧастьЗапроса = Лев(ИсходныйТекстЗапроса, ПозицияКорСчета - 1);
	ЗавершающаяЧастьЗапроса = Сред(ИсходныйТекстЗапроса, ПозицияКорсчета + 2);
	
	// Поиск условия по кор. счету
	Индекс = СтрДлина(ПостояннаяЧастьЗапроса);
	Символ = Сред(ПостояннаяЧастьЗапроса, Индекс, 1); 
	УсловиеКорСчета = "";
	Пока Индекс > 0 Цикл
		Индекс = Индекс - 1;
		Символ = Сред(ПостояннаяЧастьЗапроса, Индекс, 1);		
		Если Символ = "," Тогда
			УсловиеКорСчета = Сред(ПостояннаяЧастьЗапроса, Индекс + 1);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	// Формируем запрос-объединение для детализации корсчетов
	Индекс = 1;

	// Оставим уникальные строки со счетами.
	ГруппировкаКор  = БухгалтерскиеОтчеты.УникальныеНастройкиОтчетаПоСчетам(ПараметрыОтчета.ГруппировкаКор);
	
	Для Каждого СтрокаТаблицы Из ГруппировкаКор Цикл 
		
		ИерархияКорСчета = СтрокаТаблицы.СчетаВИерархии;
		Для Каждого КорСчет Из ИерархияКорСчета Цикл
			КорСчетаВсе.Добавить(КорСчет);
		КонецЦикла;
		
		Если Не ПустаяСтрока(УсловиеКорСчета) Тогда
			ТекстУсловияКорСчета = " И КорСчет В (&КорСчет" + Индекс + ")";
		Иначе
			ТекстУсловияКорСчета = " КорСчет В (&КорСчет" + Индекс + ")";
		КонецЕсли;
		
		// Добавим значение корсчета.
		НовоеЗначение = МакетКомпоновки.ЗначенияПараметров.Добавить();
		НовоеЗначение.Имя      = "КорСчет" + Индекс;
		НовоеЗначение.Значение = ИерархияКорСчета;
		
		// Добавим значение корсубконто.
		СписокКорСубконто = Новый СписокЗначений;
		
		ДанныеСчета = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы.Счет);
		СписокВидовСубконто = Новый СписокЗначений;
		КоличествоСубконто = СтрДлина(СтрокаТаблицы.ПоСубконто) / 2;
		Для НомерСубконто = 1 По КоличествоСубконто Цикл
			Если Сред(СтрокаТаблицы.ПоСубконто, НомерСубконто*2, 1)="0" Тогда
				Продолжить;
			КонецЕсли;
			Если  ?(Сред(СтрокаТаблицы.ПоСубконто, НомерСубконто * 2 - 1, 1) = "+", Истина, Ложь) Тогда
				СписокКорСубконто.Добавить(ДанныеСчета["ВидСубконто" + Сред(СтрокаТаблицы.ПоСубконто, НомерСубконто*2, 1)]); 
			КонецЕсли;
		КонецЦикла;
		
		НовоеЗначение = МакетКомпоновки.ЗначенияПараметров.Добавить();
		НовоеЗначение.Имя = "КорСубконто" + Индекс;
		НовоеЗначение.Значение = СписокКорСубконто;
		
		Если СписокКорСубконто.Количество() = 0 Тогда 
			ТекстУсловияКорСубконто = "";
			НачальныйИндексКор = 0;
		Иначе
			ТекстУсловияКорСубконто = "&КорСубконто" + Индекс;
			НачальныйИндексКор = СписокКорСубконто.Количество();
		КонецЕсли;
		
		ПромежуточныйТекстЗапроса = ПостояннаяЧастьЗапроса;
		
		Для ИндексКор = НачальныйИндексКор + 1 По 3 Цикл
			НачалоСтроки = СтрНайти(ПромежуточныйТекстЗапроса, "ТиповойОбороты.КорСубконто" + ИндексКор);
			Пока НачалоСтроки <> 0 Цикл
				ВременныйТекст = Сред(ПромежуточныйТекстЗапроса, НачалоСтроки);
				КонецСтроки = СтрНайти(ВременныйТекст, " КАК ");
				СтрокаПоиска = Сред(ВременныйТекст, 1, КонецСтроки - 1) + " КАК "; 
				
				Если СтрНайти(СтрокаПоиска, ") КАК ") <> 0 Тогда
					СтрокаЗамены = "NULL) КАК ";
				Иначе
					СтрокаЗамены = "NULL КАК ";
				КонецЕсли;
				
				ПромежуточныйТекстЗапроса = СтрЗаменить(ПромежуточныйТекстЗапроса, СтрокаПоиска, СтрокаЗамены);
				НачалоСтроки = СтрНайти(ПромежуточныйТекстЗапроса, "ТиповойОбороты.КорСубконто" + ИндексКор);
			КонецЦикла;
		КонецЦикла;
		
		КонечныйТекстЗапроса = КонечныйТекстЗапроса + " " + ПромежуточныйТекстЗапроса + " " + ТекстУсловияКорСчета + ", " + ТекстУсловияКорСубконто + ЗавершающаяЧастьЗапроса;
		КонечныйТекстЗапроса = КонечныйТекстЗапроса + " ОБЪЕДИНИТЬ ВСЕ ";
		
		Индекс = Индекс + 1;

	КонецЦикла;
	
	Если Индекс > 1 Тогда 
		КонечныйТекстЗапроса = Сред(КонечныйТекстЗапроса, 0, СтрДлина(КонечныйТекстЗапроса) - 16);
	КонецЕсли;
	
	ПостояннаяЧастьЗапроса = СтрЗаменить(ПостояннаяЧастьЗапроса, "ТиповойОбороты.СтруктурноеПодразделениеКор КАК", "NULL КАК");
	Для НомерСубконто = 1 По 3 Цикл
		ПостояннаяЧастьЗапроса = СтрЗаменить(ПостояннаяЧастьЗапроса, "ТиповойОбороты.КорСубконто" + НомерСубконто + " КАК", "NULL КАК");
	КонецЦикла;	
	
	Если Индекс > 1 Тогда
		Если Не ПустаяСтрока(УсловиеКорСчета) Тогда
			ТекстУсловияКорСчета = " И КорСчет НЕ В (&КорСчетВсе)";
		Иначе
			ТекстУсловияКорСчета = " КорСчет НЕ В (&КорСчетВсе)";
		КонецЕсли;
		НовоеЗначение = МакетКомпоновки.ЗначенияПараметров.Добавить();
		НовоеЗначение.Имя      = "КорСчетВсе";
		НовоеЗначение.Значение = КорСчетаВсе;	
		
		ИсходныйТекстЗапроса = ПостояннаяЧастьЗапроса + ТекстУсловияКорСчета + ЗавершающаяЧастьЗапроса;
	КонецЕсли;
	
	Если Не ПустаяСтрока(КонечныйТекстЗапроса) Тогда
		КонечныйТекстЗапроса = ИсходныйТекстЗапроса + " ОБЪЕДИНИТЬ ВСЕ " + КонечныйТекстЗапроса;
	Иначе
		КонечныйТекстЗапроса = ИсходныйТекстЗапроса;
	КонецЕсли;
	
	КонечныйТекстЗапроса = СокрЛП(СтрЗаменить(КонечныйТекстЗапроса, "РАЗРЕШЕННЫЕ", ""));
	КонечныйТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ " + Сред(КонечныйТекстЗапроса, 8); 
	
	МакетКомпоновки.НаборыДанных.ОсновнойНаборДанных.Элементы.Обороты.Запрос = КонечныйТекстЗапроса;
	

	// Обработка макета компоновки для вывода
	МакетШапкиОтчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетШапки(МакетКомпоновки);
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	КолонкаКорСчета = 1;
	Для Каждого СтрокаМакета Из МакетШапкиОтчета.Макет Цикл
		КолонкаМакета = 0;
		Для Каждого Ячейка Из СтрокаМакета.Ячейки Цикл
			Если Ячейка.Элементы.Количество() = 1 Тогда
				Если ТипЗнч(Ячейка.Элементы[0].Значение) = Тип("Строка") 
					И ВРег(Строка(Ячейка.Элементы[0].Значение)) = "КОР. СЧЕТ" Тогда 
					КолонкаКорСчета = КолонкаМакета;
					Прервать;
				КонецЕсли;
			КонецЕсли;
			КолонкаМакета = КолонкаМакета + 1;
		КонецЦикла;
	КонецЦикла;
	
	КоличествоГруппировок = 0 + ?(ПараметрыОтчета.Периодичность > 0, 1, 0);
	Для Каждого Группировка Из ПараметрыОтчета.Группировка Цикл
		Если Группировка.Использование Тогда
			КоличествоГруппировок = КоличествоГруппировок + 1;
		КонецЕсли;
	КонецЦикла;
	
	КоличествоОсновныхГруппировок = КоличествоГруппировок;
	
	КоличествоКорГруппировок = 0;
	Для Каждого СтрокаГруппировки Из ПараметрыОтчета.ГруппировкаКор Цикл
		Если СтрокаГруппировки.Использование Тогда
			КоличествоКорСубконто = СтрЧислоВхождений(СтрокаГруппировки.ПоСубконто, "+");
			КоличествоКорГруппировок = Макс(КоличествоКорГруппировок, КоличествоКорСубконто);
		КонецЕсли;
	КонецЦикла;
	
	КоличествоКорГруппировок = КоличествоКорГруппировок + 1;
	
	КоличествоСтрокШапки = Макс(КоличествоГруппировок, КоличествоКорГруппировок);
	ПараметрыОтчета.Вставить("ВысотаШапки", КоличествоСтрокШапки);
	
	МассивДляУдаления = Новый Массив;
	Для Индекс = КоличествоСтрокШапки По МакетШапкиОтчета.Макет.Количество() - 1 Цикл
		МассивДляУдаления.Добавить(МакетШапкиОтчета.Макет[Индекс]);
	КонецЦикла;
	
	КоличествоСтрок = МакетШапкиОтчета.Макет.Количество();
	Для ИндексСтроки = 1 По КоличествоСтрок - 1 Цикл
		СтрокаМакета = МакетШапкиОтчета.Макет[ИндексСтроки];
		
		КоличествоКолонок = СтрокаМакета.Ячейки.Количество();
		
		Для ИндексКолонки = КоличествоКолонок - 3 По КоличествоКолонок - 1 Цикл
			Ячейка = СтрокаМакета.Ячейки[ИндексКолонки];
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
		КонецЦикла;
	КонецЦикла;
	
	КоличествоКолонок = МакетШапкиОтчета.Макет[0].Ячейки.Количество();
	МаксимальныйИндексКорКолонки = ?(КоличествоПоказателей > 1, КоличествоКолонок - 4, КоличествоКолонок - 3);
	Для ИндексКолонки = КолонкаКорСчета По МаксимальныйИндексКорКолонки Цикл
		Если КоличествоОсновныхГруппировок > 1 Тогда
			Для ИндексСтроки = 0 По КоличествоКорГруппировок - 1 Цикл
				ЯчейкаПриемник = МакетШапкиОтчета.Макет[ИндексСтроки].Ячейки[ИндексКолонки];
				ЯчейкаИсточник = МакетШапкиОтчета.Макет[КоличествоОсновныхГруппировок + ИндексСтроки - 1].Ячейки[ИндексКолонки];
				
				ЯчейкаПриемник.Элементы.Очистить();
				Для Каждого Элемент Из ЯчейкаИсточник.Элементы Цикл
					НовыйЭлемент = ЯчейкаПриемник.Элементы.Добавить(ТипЗнч(Элемент));
					ЗаполнитьЗначенияСвойств(НовыйЭлемент, Элемент);
				КонецЦикла; 
				
				Для Каждого Элемент Из ЯчейкаИсточник.Оформление.Элементы Цикл
					Индекс = ЯчейкаИсточник.Оформление.Элементы.Индекс(Элемент);
					ЗаполнитьЗначенияСвойств(ЯчейкаПриемник.Оформление.Элементы[Индекс], Элемент);
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Для ИндексКолонки = КолонкаКорСчета По МаксимальныйИндексКорКолонки Цикл 
		ЯчейкаИсточник = МакетШапкиОтчета.Макет[КоличествоКорГруппировок - 1].Ячейки[ИндексКолонки];
		Для ИндексСтроки = КоличествоКорГруппировок По КоличествоСтрокШапки - 1 Цикл
			Ячейка = МакетШапкиОтчета.Макет[ИндексСтроки].Ячейки[ИндексКолонки];
			Для Каждого Элемент Из ЯчейкаИсточник.Оформление.Элементы Цикл
				Индекс = ЯчейкаИсточник.Оформление.Элементы.Индекс(Элемент);
				ЗаполнитьЗначенияСвойств(Ячейка.Оформление.Элементы[Индекс], Элемент);
			КонецЦикла;
		КонецЦикла;
		Для ИндексСтроки = 0 По КоличествоКорГруппировок - 1 Цикл
			Ячейка = МакетШапкиОтчета.Макет[ИндексСтроки].Ячейки[ИндексКолонки];
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Ложь);
		КонецЦикла;
		Для ИндексСтроки = КоличествоКорГруппировок По КоличествоСтрокШапки - 1 Цикл
			Ячейка = МакетШапкиОтчета.Макет[ИндексСтроки].Ячейки[ИндексКолонки];
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
		КонецЦикла;
	КонецЦикла;
	
	Для ИндексКолонки = 0 По КолонкаКорСчета - 1 Цикл 
		Для ИндексСтроки = КоличествоОсновныхГруппировок По КоличествоСтрокШапки - 1 Цикл
			Ячейка = МакетШапкиОтчета.Макет[ИндексСтроки].Ячейки[ИндексКолонки];
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
		КонецЦикла;
	КонецЦикла;
		
	МакетГруппировкиСчетЗаголовок = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Счет", , "Заголовок");
	МакетГруппировкиСчетПодвал    = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Счет", , "Подвал");
	
	МакетГруппировкиСубконтоЗаголовок = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Субконто", , "Заголовок");
	МакетГруппировкиСубконтоПодвал    = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Субконто", , "Подвал");
	
	МакетГруппировкиПодразделениеЗаголовок = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Подразделение", , "Заголовок");
	МакетГруппировкиПодразделениеПодвал    = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Подразделение", , "Подвал");

	МакетГруппировкиОрганизацияЗаголовок = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Организация", , "Заголовок");
	МакетГруппировкиОрганизацияПодвал    = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Организация", , "Подвал");

	МакетГруппировкиВалютаЗаголовок = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Валюта", , "Заголовок");
	МакетГруппировкиВалютаПодвал    = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Валюта", , "Подвал");

	МакетГруппировкиПериодЗаголовок = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Период", , "Заголовок");
	МакетГруппировкиПериодПодвал    = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Период", , "Подвал");

	
	МакетГруппировкиКорЗаголовок = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Кор", , "Заголовок");

	Для Каждого Элемент Из МассивДляУдаления Цикл
		МакетШапкиОтчета.Макет.Удалить(Элемент);
	КонецЦикла;

	Для Каждого Макет Из МакетКомпоновки.Макеты Цикл 
		МассивДляУдаления.Очистить();
		Если МакетГруппировкиСчетЗаголовок.Найти(Макет) <> Неопределено 
			ИЛИ МакетГруппировкиСубконтоЗаголовок.Найти(Макет) <> Неопределено
			ИЛИ МакетГруппировкиПодразделениеЗаголовок.Найти(Макет) <> Неопределено
			ИЛИ МакетГруппировкиОрганизацияЗаголовок.Найти(Макет) <> Неопределено
			ИЛИ МакетГруппировкиВалютаЗаголовок.Найти(Макет) <> Неопределено
			ИЛИ МакетГруппировкиПериодЗаголовок.Найти(Макет) <> Неопределено Тогда
			КоличествоПоказателей = Макет.Макет.Количество() / 3;
			Для Индекс = КоличествоПоказателей По Макет.Макет.Количество() - 1 Цикл
				МассивДляУдаления.Добавить(Макет.Макет[Индекс]);
			КонецЦикла;
			Для Индекс = 0 По КоличествоПоказателей - 1 Цикл
				Ячейка = Макет.Макет[Индекс].Ячейки[КолонкаКорСчета];
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоГоризонтали", Ложь);	
			КонецЦикла;
			
			Ячейка00 = Макет.Макет[0].Ячейки[0];
			ПараметрОтступ = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(Ячейка00.Оформление.Элементы, "Отступ");
			ПараметрШрифт  = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(Ячейка00.Оформление.Элементы, "Шрифт");
			Ячейка01 = Макет.Макет[0].Ячейки[КолонкаКорСчета];
			НовыйЭлемент = Ячейка01.Элементы.Добавить(Тип("ПолеОбластиКомпоновкиДанных"));
			НовыйЭлемент.Значение = НСтр("ru = 'Начальное сальдо'");
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка01.Оформление.Элементы, "Отступ", ПараметрОтступ.Значение);
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка01.Оформление.Элементы, "Шрифт", ПараметрШрифт.Значение);
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка01.Оформление.Элементы, "Размещение", ТипРазмещенияТекстаКомпоновкиДанных.Переносить);
		КонецЕсли;
		
		Если МакетГруппировкиСчетПодвал.Найти(Макет) <> Неопределено 
			ИЛИ МакетГруппировкиСубконтоПодвал.Найти(Макет) <> Неопределено
			ИЛИ МакетГруппировкиПодразделениеПодвал.Найти(Макет) <> Неопределено
			ИЛИ МакетГруппировкиОрганизацияПодвал.Найти(Макет) <> Неопределено
			ИЛИ МакетГруппировкиВалютаПодвал.Найти(Макет) <> Неопределено
			ИЛИ МакетГруппировкиПериодПодвал.Найти(Макет) <> Неопределено Тогда
			КоличествоПоказателей = Макет.Макет.Количество() / 3;
			Для Индекс = 0 По КоличествоПоказателей - 1 Цикл
				МассивДляУдаления.Добавить(Макет.Макет[Индекс]);  
			КонецЦикла;
			Ячейка00 = Макет.Макет[0].Ячейки[0];
			ПараметрОтступ = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(Ячейка00.Оформление.Элементы, "Отступ");
			ПараметрШрифт = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(Ячейка00.Оформление.Элементы, "Шрифт");
			
			// Область итога "Оборот"
			Для Каждого Ячейка Из Макет.Макет[КоличествоПоказателей].Ячейки Цикл
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Ложь);	
			КонецЦикла;
			
			ЯчейкаN1 = Макет.Макет[КоличествоПоказателей].Ячейки[КолонкаКорСчета];
			НовыйЭлемент = ЯчейкаN1.Элементы.Добавить(Тип("ПолеОбластиКомпоновкиДанных"));
			НовыйЭлемент.Значение = "Оборот";
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ЯчейкаN1.Оформление.Элементы, "Отступ", ПараметрОтступ.Значение);
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ЯчейкаN1.Оформление.Элементы, "Шрифт", ПараметрШрифт.Значение);
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ЯчейкаN1.Оформление.Элементы, "Размещение", ТипРазмещенияТекстаКомпоновкиДанных.Переносить);
		
			Для Индекс = 0 По Макет.Макет.Количество() - 1 Цикл
				Ячейка = Макет.Макет[Индекс].Ячейки[КолонкаКорСчета];
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоГоризонтали", Ложь);
			КонецЦикла;
			
			// Область итога "Конечное сальдо"
			Для Каждого Ячейка Из Макет.Макет[КоличествоПоказателей * 2].Ячейки Цикл
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Ложь);	
			КонецЦикла;
			
			Ячейка2N1 = Макет.Макет[КоличествоПоказателей * 2].Ячейки[КолонкаКорСчета];
			НовыйЭлемент = Ячейка2N1.Элементы.Добавить(Тип("ПолеОбластиКомпоновкиДанных"));
			НовыйЭлемент.Значение = "Конечное сальдо";
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка2N1.Оформление.Элементы, "Отступ", ПараметрОтступ.Значение);
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка2N1.Оформление.Элементы, "Шрифт", ПараметрШрифт.Значение);
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка2N1.Оформление.Элементы, "Размещение", ТипРазмещенияТекстаКомпоновкиДанных.Переносить);
			
			Для ИндексКолонки = 1 По КолонкаКорСчета - 1 Цикл
				Для ИндексСтроки = КоличествоПоказателей По КоличествоПоказателей * 3 - 1 Цикл
					Ячейка = Макет.Макет[ИндексСтроки].Ячейки[ИндексКолонки];
					БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоГоризонтали", Истина);
				КонецЦикла;
			КонецЦикла;
			Для ИндексКолонки = 0 По КолонкаКорСчета - 1 Цикл
				Для ИндексСтроки = КоличествоПоказателей + 1 По КоличествоПоказателей * 2 - 1 Цикл
					Ячейка = Макет.Макет[ИндексСтроки].Ячейки[ИндексКолонки];
					БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
				КонецЦикла;
				Для ИндексСтроки = КоличествоПоказателей * 2 + 1 По КоличествоПоказателей * 3 - 1 Цикл
					Ячейка = Макет.Макет[ИндексСтроки].Ячейки[ИндексКолонки];
					БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		
		Если МакетГруппировкиКорЗаголовок.Найти(Макет) <> Неопределено Тогда
			КоличествоПоказателей = Макет.Макет.Количество() / 3;
			Для Индекс = 0 По КоличествоПоказателей - 1 Цикл
				МассивДляУдаления.Добавить(Макет.Макет[Индекс]);  
			КонецЦикла;
			Для Индекс = КоличествоПоказателей * 2 По КоличествоПоказателей * 3 - 1 Цикл
				МассивДляУдаления.Добавить(Макет.Макет[Индекс]);  
			КонецЦикла;
			
			КоличествоКолонок = Макет.Макет[0].Ячейки.Количество();
			МаксимальныйИндексКолонки = ?(КоличествоПоказателей > 1, КоличествоКолонок - 4, КоличествоКолонок - 3);
			Для ИндексКолонки = 0 По МаксимальныйИндексКолонки Цикл
				Ячейка = Макет.Макет[КоличествоПоказателей].Ячейки[ИндексКолонки];
				Ячейка01 = Макет.Макет[0].Ячейки[ИндексКолонки];
				Для Каждого Элемент Из Ячейка01.Элементы Цикл
					НовыйЭлемент = Ячейка.Элементы.Добавить(ТипЗнч(Элемент));
					ЗаполнитьЗначенияСвойств(НовыйЭлемент, Элемент);
				КонецЦикла; 
				
				Для Каждого Элемент Из Ячейка01.Оформление.Элементы Цикл
					Индекс = Ячейка01.Оформление.Элементы.Индекс(Элемент);
					Приемник = Ячейка.Оформление.Элементы[Индекс];
					ЗаполнитьЗначенияСвойств(Приемник, Элемент);
				КонецЦикла;
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Ложь);
			КонецЦикла;
			
			Для ИндексКолонки = 1 По КолонкаКорСчета - 1 Цикл
				Для ИндексСтроки = КоличествоПоказателей По КоличествоПоказателей * 2 - 1 Цикл
					Ячейка = Макет.Макет[ИндексСтроки].Ячейки[ИндексКолонки];
					БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоГоризонтали", Истина);
				КонецЦикла;
			КонецЦикла;
			Для ИндексКолонки = 0 По КолонкаКорСчета - 1 Цикл
				Для ИндексСтроки = КоличествоПоказателей + 1 По КоличествоПоказателей * 2 - 1 Цикл
					Ячейка = Макет.Макет[ИндексСтроки].Ячейки[ИндексКолонки];
					БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		//
		Для Каждого Элемент Из МассивДляУдаления Цикл
			Макет.Макет.Удалить(Элемент);
		КонецЦикла;
	//	
	КонецЦикла;
	
	Если Не ПараметрыОтчета.ПоСубсчетам Тогда
		Для Каждого Макет Из МакетКомпоновки.Макеты Цикл
			Если ТипЗнч(Макет.Макет) = Тип("МакетГруппировкиДиаграммыОбластиКомпоновкиДанных")
				ИЛИ ТипЗнч(Макет.Макет) = Тип("МакетРесурсаДиаграммыОбластиКомпоновкиДанных") Тогда
				Для Каждого Параметр Из Макет.Параметры Цикл
					Если ТипЗнч(Параметр) = Тип("ПараметрОбластиРасшифровкаКомпоновкиДанных") Тогда
						ВыражениеПоля = Параметр.ВыраженияПолей.Добавить();	
						ВыражениеПоля.Поле      = "Счет";
						ВыражениеПоля.Выражение = "&Счет";
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	ВыводитьКолонкуСчет = Ложь;
	
	КоличествоГруппировок = 0;
	Для Каждого СтрокаГруппировки Из ПараметрыОтчета.Группировка Цикл
		Если СтрокаГруппировки.Использование Тогда
			КоличествоГруппировок = КоличествоГруппировок + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если ПараметрыОтчета.ПоСубсчетам ИЛИ ПараметрыОтчета.Периодичность > 0 ИЛИ КоличествоГруппировок > 0 Тогда 
		ВыводитьКолонкуСчет = Истина;
	КонецЕсли;
	
	Если Результат.Области.Найти("Заголовок") = Неопределено Тогда
		Результат.ФиксацияСверху = ПараметрыОтчета.ВысотаШапки;
	Иначе
		Результат.ФиксацияСверху = Результат.Области.Заголовок.Низ + ПараметрыОтчета.ВысотаШапки;
	КонецЕсли;
	
	ВыводитьКолонкуСчет = Ложь;
	
	КоличествоГруппировок = 0;
	Для Каждого СтрокаГруппировки Из ПараметрыОтчета.Группировка Цикл
		Если СтрокаГруппировки.Использование Тогда
			КоличествоГруппировок = КоличествоГруппировок + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если ПараметрыОтчета.ПоСубсчетам ИЛИ ПараметрыОтчета.ПоказательВалютнаяСумма ИЛИ ПараметрыОтчета.Периодичность > 0 ИЛИ КоличествоГруппировок > 0 Тогда 
		ВыводитьКолонкуСчет = Истина;
	КонецЕсли;
	
	Если Не ВыводитьКолонкуСчет Тогда
		Результат.УдалитьОбласть(Результат.Область("C1"), ТипСмещенияТабличногоДокумента.ПоВертикали);	
	КонецЕсли;
	
	Результат.ФиксацияСлева = 0;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


#КонецЕсли