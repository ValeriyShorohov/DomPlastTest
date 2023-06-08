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
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("НУНУ");
	НаборПоказателей.Добавить("НУПР");
	НаборПоказателей.Добавить("НУВР");
	НаборПоказателей.Добавить("Контроль");
	
	Возврат НаборПоказателей;
	
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт
	
	ЗаголовокОтчета = НСтр("ru = 'Контрольная ведомость данных БУ и НУ %1'");
	ЗаголовокОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ЗаголовокОтчета, БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода));
	
	Возврат ЗаголовокОтчета;
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	МассивПоказателей = ПолучитьНаборПоказателей();
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	Если КоличествоПоказателей > 1 Тогда
		ГруппаПоказатели = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПоказатели.Заголовок     = НСтр("ru = 'Показатели'");
		ГруппаПоказатели.Использование = Истина;
		ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ЭлементМассива Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ЭлементМассива] Тогда 
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ЭлементМассива);
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
	// Строим структуру с учетом отмеченных пользователем полей
    ЕстьСальдоНаНачало  = ПараметрыОтчета.СальдоНаНачалоДт 	ИЛИ ПараметрыОтчета.СальдоНаНачалоКт  ИЛИ ПараметрыОтчета.СальдоНаНачалоИтого;
	ЕстьСальдоНаКонец  	= ПараметрыОтчета.СальдоНаКонецДт 	ИЛИ ПараметрыОтчета.СальдоНаКонецКт   ИЛИ ПараметрыОтчета.СальдоНаКонецИтого;
	ЕстьОборотыЗаПериод = ПараметрыОтчета.ОборотыЗаПериодДт ИЛИ ПараметрыОтчета.ОборотыЗаПериодКт ИЛИ ПараметрыОтчета.ОборотыЗаПериодИтого;
	ЕстьДетализацияПоДокументДвижения = Ложь;
	
	Если НЕ ЕстьСальдоНаНачало И НЕ ЕстьСальдоНаКонец И НЕ ЕстьОборотыЗаПериод Тогда
		// Если пользователь не отметил ни один показатель, устанавливаем по умолчанию 
		// итоги по всем
		ПараметрыОтчета.СальдоНаНачалоИтого  = Истина;
		ПараметрыОтчета.СальдоНаКонецИтого   = Истина;
		ПараметрыОтчета.ОборотыЗаПериодИтого = Истина;
		ЕстьСальдоНаНачало 		= Истина;
		ЕстьСальдоНаКонец 		= Истина;
		ЕстьОборотыЗаПериод		= Истина;
	КонецЕсли;
	
	ГруппировкаДокументДвижения = ПараметрыОтчета.ГруппировкаДоп.Найти("ДокументДвижения", "Поле");
	Если ГруппировкаДокументДвижения <> Неопределено И ГруппировкаДокументДвижения.Использование Тогда
		ЕстьДетализацияПоДокументДвижения =  Истина; // в этом случае строим отчет без сведений о вышестоящих группировках и сальдо
		ЕстьСальдоНаНачало 	= Ложь;
		ЕстьСальдоНаКонец 	= Ложь;
	КонецЕсли;
	
	// Строим структуру отчета 
	Если ЕстьСальдоНаНачало	Тогда
		// групповая ветка
		ГруппаСальдоНаНачало = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаСальдоНаНачало.Заголовок     = НСтр("ru = 'Сальдо на начало периода'");
		ГруппаСальдоНаНачало.Использование = Истина;
	    Если ПараметрыОтчета.СальдоНаНачалоДт Тогда
			ГруппаСальдоНаНачалоДт = ГруппаСальдоНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ГруппаСальдоНаНачалоДт.Заголовок     = НСтр("ru = 'Дебет'");
			ГруппаСальдоНаНачалоДт.Использование = Истина;
			ГруппаСальдоНаНачалоДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		КонецЕсли;
		Если ПараметрыОтчета.СальдоНаНачалоКт Тогда
			ГруппаСальдоНаНачалоКт = ГруппаСальдоНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ГруппаСальдоНаНачалоКт.Заголовок     = НСтр("ru = 'Кредит'");
			ГруппаСальдоНаНачалоКт.Использование = Истина;
			ГруппаСальдоНаНачалоКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		КонецЕсли;	
	    Если ПараметрыОтчета.СальдоНаНачалоИтого Тогда
			ГруппаСальдоНаНачалоОбщие = ГруппаСальдоНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ГруппаСальдоНаНачалоОбщие.Заголовок     = НСтр("ru = 'Итого'");
			ГруппаСальдоНаНачалоОбщие.Использование = Истина;
			ГруппаСальдоНаНачалоОбщие.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		КонецЕсли;
	КонецЕсли;
	
	Если ЕстьОборотыЗаПериод Тогда
		// групповая ветка
		ГруппаОбороты = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаОбороты.Заголовок     = НСтр("ru = 'Обороты за период'");
		ГруппаОбороты.Использование = Истина;	
	    Если ПараметрыОтчета.ОборотыЗаПериодДт Тогда
			ГруппаОборотыДт = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ГруппаОборотыДт.Заголовок     = НСтр("ru = 'Дебет'");
			ГруппаОборотыДт.Использование = Истина;
			ГруппаОборотыДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		КонецЕсли;
		Если ПараметрыОтчета.ОборотыЗаПериодКт Тогда
			ГруппаОборотыКт = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ГруппаОборотыКт.Заголовок     = НСтр("ru = 'Кредит'");
			ГруппаОборотыКт.Использование = Истина;
			ГруппаОборотыКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		КонецЕсли;	
		Если ПараметрыОтчета.ОборотыЗаПериодИтого Тогда
			ГруппаОборотыОбщие = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ГруппаОборотыОбщие.Заголовок     = НСтр("ru = 'Итого'");
			ГруппаОборотыОбщие.Использование = Истина;
			ГруппаОборотыОбщие.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		КонецЕсли;	
	КонецЕсли;
	
	Если ЕстьСальдоНаКонец Тогда
		// групповая ветка
		ГруппаСальдоНаКонец = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаСальдоНаКонец.Заголовок     = НСтр("ru = 'Сальдо на конец периода'");
		ГруппаСальдоНаКонец.Использование = Истина;
		Если ПараметрыОтчета.СальдоНаКонецДт Тогда
			ГруппаСальдоНаКонецДт = ГруппаСальдоНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ГруппаСальдоНаКонецДт.Заголовок     = НСтр("ru = 'Дебет'");
			ГруппаСальдоНаКонецДт.Использование = Истина;
			ГруппаСальдоНаКонецДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		КонецЕсли;
		Если ПараметрыОтчета.СальдоНаКонецКт Тогда
			ГруппаСальдоНаКонецКт = ГруппаСальдоНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ГруппаСальдоНаКонецКт.Заголовок     = НСтр("ru = 'Кредит'");
			ГруппаСальдоНаКонецКт.Использование = Истина;
			ГруппаСальдоНаКонецКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		КонецЕсли;	
	    Если ПараметрыОтчета.СальдоНаКонецИтого Тогда
			ГруппаСальдоНаКонецОбщие = ГруппаСальдоНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ГруппаСальдоНаКонецОбщие.Заголовок     = НСтр("ru = 'Итого'");
			ГруппаСальдоНаКонецОбщие.Использование = Истина;
			ГруппаСальдоНаКонецОбщие.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		КонецЕсли;	
	КонецЕсли;	
	
	ВидОстатков = "";
	Для Каждого ЭлементМассива Из МассивПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ЭлементМассива] Тогда 
			// в расшифровке по регистратору сальдо не выводится
			Если ЕстьСальдоНаНачало И ПараметрыОтчета.СальдоНаНачалоИтого Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоОбщие, "СальдоНаНачалоПериода." + ЭлементМассива + "СуммаНачальныйОстаток");			
			КонецЕсли;
			Если ЕстьСальдоНаНачало И ПараметрыОтчета.СальдоНаНачалоДт Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоДт, "СальдоНаНачалоПериода." + ЭлементМассива + "СуммаНачальныйОстатокДт");
			КонецЕсли;
			Если ЕстьСальдоНаНачало И ПараметрыОтчета.СальдоНаНачалоКт Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоКт, "СальдоНаНачалоПериода." + ЭлементМассива + "СуммаНачальныйОстатокКт");
			КонецЕсли;
			Если ПараметрыОтчета.ОборотыЗаПериодИтого Тогда
				Если ЕстьДетализацияПоДокументДвижения Тогда
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыОбщие, "ДетальныеОборотыЗаПериод." + ЭлементМассива + "СуммаОборот");
				Иначе					
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыОбщие, "ОборотыЗаПериод." + ЭлементМассива + "СуммаОборот");
				КонецЕсли;
			КонецЕсли;
			
			Если ПараметрыОтчета.ОборотыЗаПериодДт Тогда
				Если ЕстьДетализацияПоДокументДвижения Тогда
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыДт, "ДетальныеОборотыЗаПериод." + ЭлементМассива + "СуммаОборотДт");
				Иначе	
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыДт, "ОборотыЗаПериод." + ЭлементМассива + "СуммаОборотДт");
				КонецЕсли;	
			КонецЕсли;				
			
			Если ПараметрыОтчета.ОборотыЗаПериодКт Тогда
				Если ЕстьДетализацияПоДокументДвижения Тогда
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыКт, "ДетальныеОборотыЗаПериод." + ЭлементМассива + "СуммаОборотКт");
				Иначе	
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыКт, "ОборотыЗаПериод." + ЭлементМассива + "СуммаОборотКт");
				КонецЕсли;
			КонецЕсли;
			// в расшифровке по регистратору сальдо не выводится
			Если ЕстьСальдоНаКонец И ПараметрыОтчета.СальдоНаКонецИтого Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецОбщие, "СальдоНаКонецПериода." + ЭлементМассива + "СуммаКонечныйОстаток");
			КонецЕсли;
			Если ЕстьСальдоНаКонец И ПараметрыОтчета.СальдоНаКонецДт Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецДт, "СальдоНаКонецПериода." + ЭлементМассива + "СуммаКонечныйОстатокДт");
			КонецЕсли;
			Если ЕстьСальдоНаКонец И ПараметрыОтчета.СальдоНаКонецКт Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецКт, "СальдоНаКонецПериода." + ЭлементМассива + "СуммаКонечныйОстатокКт");
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Схема));
	
	Для Каждого Параметр Из КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы Цикл
		Параметр.Использование = Истина;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	БухгалтерскиеОтчеты.ДобавитьОтборПоОрганизациямИПодразделениям(КомпоновщикНастроек, ПараметрыОтчета);
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	// Формирование структуры отчета
	//Установим группировку по полям дополнительной группировки
	//группировка счета и валюты будут всегда ниже доп. группировок
	Структура = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	Первый = Истина;
	//ИспользоватьОформлениеГруппировок = НастройкиФормы.ИспользоватьОформлениеГруппировок;
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.ГруппировкаДоп Цикл 
		Если ЕстьДетализацияПоДокументДвижения И НЕ ПолеВыбраннойГруппировки.Поле = "ДокументДвижения" Тогда
			Продолжить;
			// для расшифровки не выводим вышестоящие группировки,
			// так как компоновка не может пока вывести разнонаправленные ресурсы при наличии нескольких группировок в нужном нам виде
		КонецЕсли;	
		
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Если Не Первый Тогда 
				Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			КонецЕсли;
			Первый = Ложь;
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование = Истина;
			ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			Если ПолеВыбраннойГруппировки.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Иерархия Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.ТолькоИерархия Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;			
        			
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));														
									
			Если ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("СчетНУ") Тогда 												
				Если Не ПараметрыОтчета.ПоСубсчетам Тогда
					ЗначениеОтбора = БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Структура.Отбор, "SystemFields.LevelInGroup", 1);
					ЗначениеОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
					БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
				КонецЕсли;				
			КонецЕсли;						
		                        		
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		КонецЕсли;
	КонецЦикла;
	
	// Отключим вывод отборов
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	
	Если ПараметрыОтчета.ПоСубсчетам Тогда
		
		УсловноеОформление = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();	
		УстановитьОформлениеПолей(КомпоновщикНастроек.Настройки.Выбор.Элементы, УсловноеОформление);
		
		Поле = УсловноеОформление.Поля.Элементы.Добавить();
		Поле.Поле = Новый ПолеКомпоновкиДанных("СчетНУ");
		
		Если ПараметрыОтчета.РазмещениеДополнительныхПолей = 1 Тогда 
			Для Каждого ДопПоле Из ПараметрыОтчета.ДополнительныеПоля Цикл 
				
				Поле = УсловноеОформление.Поля.Элементы.Добавить();
				Поле.Поле = Новый ПолеКомпоновкиДанных(Сред(ДопПоле.Поле, 1, Найти(ДопПоле.Поле, ".")));			
				
			КонецЦикла;
		КонецЕсли;
			
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(УсловноеОформление.Отбор, "СчетНУ.Родитель", ПланыСчетов.Налоговый.ПустаяСсылка());
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(УсловноеОформление.Оформление, "Шрифт", Новый Шрифт(, , Истина));
		
		УсловноеОформление.Представление = НСтр("ru = 'Выделять группы счетов'");
		
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ЕстьДетализацияПоДокументДвижения", ЕстьДетализацияПоДокументДвижения);
	
	СчетаУчетаВА = Новый СписокЗначений;
	СчетаУчетаВА.Добавить(ПланыСчетов.Типовой.ОсновныеСредства_); 				// 2400
	СчетаУчетаВА.Добавить(ПланыСчетов.Типовой.НематериальныеАктивы);  			// 2700
	СчетаУчетаВА.Добавить(ПланыСчетов.Типовой.БиологическиеАктивы);   			// 2500 
	СчетаУчетаВА.Добавить(ПланыСчетов.Типовой.ДолгосрочныеАктивыДляПродажи_); 	// 1500
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаВА", СчетаУчетаВА);
	
КонецПроцедуры

Процедура УстановитьОформлениеПолей(ЭлеметыКомпоновки, УсловноеОформление)
	
	Для Каждого Элемент Из ЭлеметыКомпоновки Цикл 
		
		Если ТипЗнч(Элемент) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда 
			УстановитьОформлениеПолей(Элемент.Элементы, УсловноеОформление);
		Иначе 
			Поле = УсловноеОформление.Поля.Элементы.Добавить();
			Поле.Поле = Элемент.Поле;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	МакетШапкиОтчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетШапки(МакетКомпоновки);
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	КоличествоГруппировок = 1;
	
	ЗаголовокКолонкиГруппировок = ""; 
	Для Каждого Строка Из  МакетШапкиОтчета.Макет Цикл
		
		Если Строка.Ячейки[0].Элементы.Количество() > 0 Тогда
			ЗаголовокКолонкиГруппировок = ЗаголовокКолонкиГруппировок + ?(ПустаяСтрока(ЗаголовокКолонкиГруппировок), "", Символы.ПС);
		КонецЕсли;
		
		Для Каждого Элемент Из Строка.Ячейки[0].Элементы Цикл
			ЗаголовокКолонкиГруппировок = ЗаголовокКолонкиГруппировок + Элемент.Значение;
		КонецЦикла;
		
	КонецЦикла;
	
	Ячейка2 = МакетШапкиОтчета.Макет[1].Ячейки[1];
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка2.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);

	КоличествоСтрокШапки = Макс(КоличествоГруппировок, 2);
	ПараметрыОтчета.Вставить("ВысотаШапки", КоличествоСтрокШапки);
	
	МассивДляУдаления = Новый Массив;
	Для Индекс = КоличествоСтрокШапки По МакетШапкиОтчета.Макет.Количество() - 1 Цикл
		МассивДляУдаления.Добавить(МакетШапкиОтчета.Макет[Индекс]);
	КонецЦикла;
	
	КоличествоСтрок = МакетШапкиОтчета.Макет.Количество();
	Для ИндексСтроки = 2 По КоличествоСтрок - 1 Цикл
		СтрокаМакета = МакетШапкиОтчета.Макет[ИндексСтроки];
		
		КоличествоКолонок = СтрокаМакета.Ячейки.Количество();		
	КонецЦикла;
	
	МакетПодвалаОтчета            = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетПодвала(МакетКомпоновки);
	МакетГруппировкиОрганизация   = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Организация");
	МакетГруппировкиСчетНУ        = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "СчетНУ");
	МакетГруппировкиПодразделение = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Подразделение");
		
	Для Каждого Элемент Из МассивДляУдаления Цикл
		МакетШапкиОтчета.Макет.Удалить(Элемент);
	КонецЦикла;
	
	Ячейка2 = МакетШапкиОтчета.Макет[0].Ячейки[0];
	Ячейка2.Элементы.Очистить();
	НовыйЭлемент = Ячейка2.Элементы.Добавить(Тип("ПолеОбластиКомпоновкиДанных"));
	НовыйЭлемент.Значение = ЗаголовокКолонкиГруппировок;	
	Ячейка2 = МакетШапкиОтчета.Макет[1].Ячейки[0];
	Ячейка2.Элементы.Очистить();
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка2.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
	
	Для Каждого Макет Из МакетКомпоновки.Макеты Цикл 
		Если Макет = МакетШапкиОтчета Тогда
		Иначе
			Индекс = -1;
			МассивПоказателей = ПолучитьНаборПоказателей();
			
			Для Каждого ЭлементМассива Из МассивПоказателей Цикл
				Если ПараметрыОтчета["Показатель" + ЭлементМассива] Тогда 
					Индекс = Индекс + 1;
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;
	КонецЦикла;
	
	ЗначенияПоказателей = Новый Массив(6, КоличествоПоказателей);
	Для Каждого Массив Из ЗначенияПоказателей Цикл
		Для Индекс = 0 По КоличествоПоказателей - 1 Цикл
			Массив[Индекс] = 0;
		КонецЦикла;
	КонецЦикла;
	
	ПараметрыОтчета.Вставить("МакетШапкиОтчета"     , МакетШапкиОтчета);
	ПараметрыОтчета.Вставить("МакетСчетНУ"          , МакетГруппировкиСчетНУ);
	ПараметрыОтчета.Вставить("МакетПодвал"          , МакетПодвалаОтчета);
	ПараметрыОтчета.Вставить("КоличествоПоказателей", КоличествоПоказателей);
	ПараметрыОтчета.Вставить("ЗначенияПоказателей"  , ЗначенияПоказателей);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


#КонецЕсли