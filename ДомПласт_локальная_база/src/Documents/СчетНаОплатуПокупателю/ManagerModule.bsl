#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ТекстЗапросаДанныеДляОбновленияЦенДокументов() Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СчетНаОплатуПокупателюТовары.Номенклатура КАК Номенклатура,
	|	СчетНаОплатуПокупателюТовары.Цена КАК Цена,
	|	&Валюта КАК Валюта,
	|	&СпособЗаполненияЦены,
	|	&ЦенаВключаетНДС
	|ПОМЕСТИТЬ ТаблицаНоменклатуры
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю.Товары КАК СчетНаОплатуПокупателюТовары
	|ГДЕ
	|	СчетНаОплатуПокупателюТовары.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СчетНаОплатуПокупателюУслуги.Номенклатура КАК Номенклатура,
	|	СчетНаОплатуПокупателюУслуги.Цена КАК Цена,
	|	&Валюта КАК Валюта,
	|	&СпособЗаполненияЦены,
	|	&ЦенаВключаетНДС
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю.Услуги КАК СчетНаОплатуПокупателюУслуги
	|ГДЕ
	|	СчетНаОплатуПокупателюУслуги.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Цена,
	|	Валюта";
	
	ТекстЗапроса = ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
	
	Возврат ТекстЗапроса;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Счет на оплату
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СчетЗаказНаОплату";
	КомандаПечати.Представление = НСтр("ru = 'Счет на оплату'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.ПроверкаПроведенияПередПечатью = НЕ ПользователиБКВызовСервераПовтИсп.РазрешитьПечатьНепроведенныхДокументов();
	КомандаПечати.Порядок = 50;
	
	// Настраиваемый комплект документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СчетЗаказНаОплату";
	КомандаПечати.Представление = НСтр("ru = 'Настраиваемый комплект документов'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = НЕ ПользователиБКВызовСервераПовтИсп.РазрешитьПечатьНепроведенныхДокументов();
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Настраиваемый комплект'");
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
	КомандаПечати.Порядок = 75;
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Печать счета на оплату
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетЗаказНаОплату") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"СчетЗаказНаОплату",
			НСтр("ru = 'Счет на оплату'"),
			ПечатьСчетаЗаказа(МассивОбъектов, ОбъектыПечати),
			,
			"Документ.СчетНаОплатуПокупателю.ПФ_MXL_СчетЗаказ");
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Подготовка табличных печатных документов.

// Функция формирует табличный документ с печатной формой заказа или счета,
// разработанного методистами
//
// Возвращаемое значение:
//  Табличный документ - сформированная печатная форма
//
Функция ПечатьСчетаЗаказа(МассивОбъектов, ОбъектыПечати) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		ВыводитьКоды    = Истина;
		Колонка         = "Артикул";
		ТекстКодАртикул = "Артикул";
	ИначеЕсли ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
		ВыводитьКоды    = Истина;
		Колонка         = "Код";
		ТекстКодАртикул = "Код";		
	Иначе
		ВыводитьКоды    = Ложь;
		Колонка         = "";
		ТекстКодАртикул = "Код";
	КонецЕсли;
	
	Если ВыводитьКоды Тогда
		ОбластьШапки  = "ШапкаТаблицыСКодом";
		ОбластьСтроки = "СтрокаСКодом";
	Иначе
		ОбластьШапки  = "ШапкаТаблицы";
		ОбластьСтроки = "Строка";
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст ="
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Ссылка,
	|	Номер,
	|	Дата,
	|	ДоговорКонтрагента,
	|	Организация,
	|	Организация.ФайлЛоготипа КАК ЛоготипОрганизации,
	|	СтруктурноеПодразделение,
	|	Контрагент КАК Получатель,
	|	Организация КАК Руководители,
	|	Организация КАК Поставщик,
	|	СтруктурнаяЕдиница,
	|	СуммаДокумента,
	|	ВалютаДокумента,
	|	УчитыватьНДС,
	|	СуммаВключаетНДС,
	|   КодНазначенияПлатежа,
	|	Ответственный
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю КАК ЗаказПокупателя
	|
	|ГДЕ
	|	ЗаказПокупателя.Ссылка В (&МассивОбъектов)";

	Шапка = Запрос.Выполнить().Выбрать();

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.КлючПараметровПечати = "СчетНаОплатуПокупателю_СчетЗаказ";
                   
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
				   |	ВложенныйЗапрос.Ссылка КАК Ссылка,
				   |	ВложенныйЗапрос.Номенклатура,
				   |	ВложенныйЗапрос.Товар,
				   |	ВложенныйЗапрос.КодАртикул,
				   |	ВложенныйЗапрос.Количество,
				   |	ВложенныйЗапрос.ЕдиницаИзмерения,
				   |	ВложенныйЗапрос.Цена,
				   |	ВложенныйЗапрос.Сумма,
				   |	ВложенныйЗапрос.СуммаНДС,
				   |	ВложенныйЗапрос.НомерСтроки,
				   |	ВложенныйЗапрос.ID
				   |ИЗ
				   |	(ВЫБРАТЬ 
	               |	ВложенныйЗапрос.Ссылка КАК Ссылка,
	               |	ВложенныйЗапрос.Номенклатура,
	               |	ВЫРАЗИТЬ(ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) КАК Товар,
	               |	ВложенныйЗапрос.Номенклатура." + ТекстКодАртикул + " КАК КодАртикул,
	               |	ВложенныйЗапрос.Количество,
	               |	ВложенныйЗапрос.ЕдиницаИзмерения,
	               |	ВложенныйЗапрос.Цена,
	               |	ВложенныйЗапрос.Сумма,
	               |	ВложенныйЗапрос.СуммаНДС,
	               |	ВложенныйЗапрос.НомерСтроки КАК НомерСтроки,
	               |	1 КАК ID
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ЗаказПокупателя.Ссылка КАК Ссылка,
	               |		ЗаказПокупателя.Номенклатура КАК Номенклатура,
	               |		ЗаказПокупателя.Номенклатура.БазоваяЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
	               |		ЗаказПокупателя.Цена КАК Цена,
	               |		СУММА(ЗаказПокупателя.Количество) КАК Количество,
	               |		СУММА(ЗаказПокупателя.Сумма) КАК Сумма,
	               |		СУММА(ЗаказПокупателя.СуммаНДС) КАК СуммаНДС,
	               |		МИНИМУМ(ЗаказПокупателя.НомерСтроки) КАК НомерСтроки
	               |	ИЗ
	               |		Документ.СчетНаОплатуПокупателю.Товары КАК ЗаказПокупателя
	               |	ГДЕ
	               |		ЗаказПокупателя.Ссылка В (&МассивОбъектов)
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		ЗаказПокупателя.Ссылка,
	               |		ЗаказПокупателя.Номенклатура,
	               |		ЗаказПокупателя.Номенклатура.БазоваяЕдиницаИзмерения.Наименование,
	               |		ЗаказПокупателя.Цена) КАК ВложенныйЗапрос
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ЗаказПокупателя.Ссылка,
	               |	ЗаказПокупателя.Содержание,
	               |	ЗаказПокупателя.Содержание,
	               |	ЗаказПокупателя.Номенклатура." + ТекстКодАртикул + " КАК КодАртикул,
	               |	ЗаказПокупателя.Количество,
	               |	ЕСТЬNULL(ЗаказПокупателя.Номенклатура.БазоваяЕдиницаИзмерения.Наименование, ""--""),
	               |	ЗаказПокупателя.Цена,
	               |	ЗаказПокупателя.Сумма,
	               |	ЗаказПокупателя.СуммаНДС,
	               |	ЗаказПокупателя.НомерСтроки,
	               |	2
	               |ИЗ
	               |	Документ.СчетНаОплатуПокупателю.Услуги КАК ЗаказПокупателя
	               |ГДЕ
	               |	ЗаказПокупателя.Ссылка В (&МассивОбъектов)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ЗаказПокупателя.Ссылка,
	               |	ЗаказПокупателя.ОсновноеСредство,
	               |	ВЫРАЗИТЬ(ЗаказПокупателя.ОсновноеСредство.НаименованиеПолное КАК СТРОКА(1000)),
	               |	NULL,
	               |	1,
	               |	""шт"",
	               |	ЗаказПокупателя.Сумма,
	               |	ЗаказПокупателя.Сумма,
	               |	ЗаказПокупателя.СуммаНДС,
	               |	ЗаказПокупателя.НомерСтроки,
	               |	3
	               |ИЗ
	               |	Документ.СчетНаОплатуПокупателю.ОС КАК ЗаказПокупателя
	               |ГДЕ
	               |	ЗаказПокупателя.Ссылка В (&МассивОбъектов)) КАК ВложенныйЗапрос
				   |
				   |УПОРЯДОЧИТЬ ПО
				   |	ID,
				   |	НомерСтроки
				   |
				   |ИТОГИ ПО
				   |	Ссылка";

	ВыборкаДанныхПоДокументам = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				   
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.СчетНаОплатуПокупателю.ПФ_MXL_СчетЗаказ");

	Пока Шапка.Следующий() Цикл
		
		Если ТабДокумент.ВысотаТаблицы > 0 Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку накладной
		СтруктурнаяЕдиницаОрганизация = ОбщегоНазначенияБК.ПолучитьСтруктурнуюЕдиницу(Шапка.Поставщик, Шапка.СтруктурноеПодразделение); 
		СведенияОПоставщике = ОбщегоНазначенияБКВызовСервера.СведенияОЮрФизЛице(СтруктурнаяЕдиницаОрганизация, Шапка.Дата);
		
		ОбластьМакетаЗаголовокСчета       = Макет.ПолучитьОбласть("ЗаголовокСчета");
		ОбластьМакетаЗаголовокСчета.Параметры.Заполнить(Шапка);
		ОбластьМакетаЗаголовокСчета.Параметры.ПоставщикРНН_БИН = ОбщегоНазначенияБК.ПолучитьРегистрационныйНомерОрганизацииКонтрагентаВПечатнуюФорму(СведенияОПоставщике, Шапка.Дата);
	    ОбластьМакетаЗаголовокСчета.Параметры.ПоставщикКБЕ	 = СведенияОПоставщике.КБЕ;
		Если ТипЗнч(Шапка.СтруктурнаяЕдиница) = Тип("СправочникСсылка.БанковскиеСчета") Тогда
			
			Банк             = Шапка.СтруктурнаяЕдиница.Банк;
			РеквизитыБанка   = Справочники.Банки.ПолучитьРеквизитыБанка(Банк);
			БИК              = Справочники.Банки.ПолучитьБИКБанка(Шапка.Дата, РеквизитыБанка);
			ГородБанка       = РеквизитыБанка.Город;
			СтрокаГородБанка = ?(ПустаяСтрока(ГородБанка), "", НСтр("ru = ' г.'") + " " + ГородБанка);
			НомерСчета       = Шапка.СтруктурнаяЕдиница.НомерСчета;
			
			ОбластьМакетаЗаголовокСчета.Параметры.БИКБанкаПолучателя   = БИК;
			ОбластьМакетаЗаголовокСчета.Параметры.БанкПолучателя       = СокрЛП(Банк) + СтрокаГородБанка;
			ОбластьМакетаЗаголовокСчета.Параметры.НомерСчетаПолучателя = НомерСчета;
			
		КонецЕсли;   
		ОбластьМакетаЗаголовокСчета.Параметры.ПредставлениеПоставщика = ОбщегоНазначенияБКВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,",, Шапка.Дата);
		ТабДокумент.Вывести(ОбластьМакетаЗаголовокСчета);			
		
		Если ЗначениеЗаполнено(Шапка.ЛоготипОрганизации) Тогда
			СсылкаНаДвоичныеДанныеФайла = РаботаСФайлами.ДанныеФайла(Шапка.ЛоготипОрганизации).СсылкаНаДвоичныеДанныеФайла;
			Если ЗначениеЗаполнено(СсылкаНаДвоичныеДанныеФайла) Тогда
				ТабДокумент.Область("Логотип").Картинка = Новый Картинка(ПолучитьИзВременногоХранилища(СсылкаНаДвоичныеДанныеФайла));
			КонецЕсли;
		КонецЕсли;	
		
		ОбластьМакетаЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакетаЗаголовок.Параметры.ТекстЗаголовка = РаботаСДиалогами.СформироватьЗаголовокДокумента(Шапка.Ссылка, НСтр("ru = 'Счет на оплату'"));
		
		ТабДокумент.Вывести(ОбластьМакетаЗаголовок);

		ОбластьМакетаПоставщик = Макет.ПолучитьОбласть("Поставщик");
		ОбластьМакетаПоставщик.Параметры.Заполнить(Шапка);
		ОбластьМакетаПоставщик.Параметры.ПредставлениеПоставщика = ОбщегоНазначенияБКВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "ИдентификационныйНомер,ПолноеНаименование,ЮридическийАдрес,Телефоны,",,Шапка.Дата);
		ТабДокумент.Вывести(ОбластьМакетаПоставщик);

		СведенияОПолучателе = ОбщегоНазначенияБКВызовСервера.СведенияОЮрФизЛице(Шапка.Получатель, Шапка.Дата);
		ОбластьМакетаПокупатель = Макет.ПолучитьОбласть("Покупатель");
		ОбластьМакетаПокупатель.Параметры.Заполнить(Шапка);
		ОбластьМакетаПокупатель.Параметры.ПредставлениеПолучателя = ОбщегоНазначенияБКВызовСервера.ОписаниеОрганизации(ОбщегоНазначенияБКВызовСервера.СведенияОЮрФизЛице(Шапка.Получатель, Шапка.Дата), "ИдентификационныйНомер,ПолноеНаименование,ЮридическийАдрес,Телефоны,",,Шапка.Дата);
		ТабДокумент.Вывести(ОбластьМакетаПокупатель);

		ОбластьМакетаДоговор = Макет.ПолучитьОбласть("Договор");
		ОбластьМакетаДоговор.Параметры.Заполнить(Шапка);
		ТабДокумент.Вывести(ОбластьМакетаДоговор);

		ОбластьНомера = Макет.ПолучитьОбласть(ОбластьШапки + "|НомерСтроки");
		ОбластьДанных = Макет.ПолучитьОбласть(ОбластьШапки + "|Данные");
		ОбластьСуммы  = Макет.ПолучитьОбласть(ОбластьШапки + "|Сумма");

		ТабДокумент.Вывести(ОбластьНомера);
		Если ВыводитьКоды Тогда
			ОбластьДанных.Параметры.Колонка = Колонка;
		КонецЕсли;	
		ТабДокумент.Присоединить(ОбластьДанных);
		ТабДокумент.Присоединить(ОбластьСуммы);

		ОбластьКолонкаТовар = Макет.Область("Товар");

		ОбластьНомера = Макет.ПолучитьОбласть(ОбластьСтроки + "|НомерСтроки");
		ОбластьДанных = Макет.ПолучитьОбласть(ОбластьСтроки + "|Данные");
		ОбластьСуммы  = Макет.ПолучитьОбласть(ОбластьСтроки + "|Сумма");

		Сумма    = 0;
		СуммаНДС = 0;
		ВсегоСкидок    = 0;
		ВсегоБезСкидок = 0;
		СчетчикСтрок = 0;

		ВыборкаДанныхПоДокументам.Сбросить();
		ВыборкаДанныхПоДокументам.НайтиСледующий(Новый Структура("Ссылка", Шапка.Ссылка));
		ДанныеПоДокументу = ВыборкаДанныхПоДокументам.Выбрать();

		Пока ДанныеПоДокументу.Следующий() Цикл 

			СчетчикСтрок = СчетчикСтрок + 1;
			
			ОбластьНомера.Параметры.НомерСтроки = СчетчикСтрок;
			ТабДокумент.Вывести(ОбластьНомера);

			ОбластьДанных.Параметры.Заполнить(ДанныеПоДокументу);
			ОбластьДанных.Параметры.Товар       = СокрЛП(ДанныеПоДокументу.Товар);
			ОбластьДанных.Параметры.Количество  = Формат(ДанныеПоДокументу.Количество, "ЧДЦ=3");
			Если ВыводитьКоды Тогда
				ОбластьДанных.Параметры.КодАртикул = ?(ДанныеПоДокументу.ID = 3, ДанныеПоДокументу.Номенклатура.Код, ДанныеПоДокументу.КодАртикул);				
			КонецЕсли;
			ТабДокумент.Присоединить(ОбластьДанных);
			
			ОбластьСуммы.Параметры.Заполнить(ДанныеПоДокументу);
			ТабДокумент.Присоединить(ОбластьСуммы);
			Сумма          = Сумма       + ДанныеПоДокументу.Сумма;
			СуммаНДС       = СуммаНДС    + ДанныеПоДокументу.СуммаНДС;

		КонецЦикла;

		// Вывести Итого
		ОбластьНомера = Макет.ПолучитьОбласть("Итого|НомерСтроки");
		ОбластьДанных = Макет.ПолучитьОбласть("Итого|Данные");
		ОбластьСуммы  = Макет.ПолучитьОбласть("Итого|Сумма");

		ТабДокумент.Вывести(ОбластьНомера);
		ТабДокумент.Присоединить(ОбластьДанных);
		ОбластьСуммы.Параметры.Всего = ОбщегоНазначенияБКВызовСервера.ФорматСумм(Сумма);
		ТабДокумент.Присоединить(ОбластьСуммы);

		// Вывести ИтогоНДС
		ОбластьНомера = Макет.ПолучитьОбласть("ИтогоНДС|НомерСтроки");
		ОбластьДанных = Макет.ПолучитьОбласть("ИтогоНДС|Данные");
		ОбластьСуммы  = Макет.ПолучитьОбласть("ИтогоНДС|Сумма");
		
		//Вывести ИтогоСНДС
		ОбластьИтогоСНДС = Макет.ПолучитьОбласть("ИтогоСНДС");
		
		ТабДокумент.Вывести(ОбластьНомера);
		Если Шапка.УчитыватьНДС Тогда
			ОбластьДанных.Параметры.НДС = ?(Шапка.СуммаВключаетНДС, НСтр("ru = 'В том числе НДС:'"), НСтр("ru = 'Сумма НДС:'"));
			ОбластьСуммы.Параметры.ВсегоНДС = ОбщегоНазначенияБКВызовСервера.ФорматСумм(СуммаНДС,, "-");    
			
			Если НЕ Шапка.СуммаВключаетНДС Тогда 
				ОбластьИтогоСНДС.Параметры.Всего = НСтр("ru = 'Всего:'");
				ОбластьИтогоСНДС.Параметры.ВсегоСНДС = ОбщегоНазначенияБКВызовСервера.ФорматСумм(Сумма + СуммаНДС);
			КонецЕсли;
		КонецЕсли;    
		
		ТабДокумент.Присоединить(ОбластьДанных);
		
		ТабДокумент.Присоединить(ОбластьСуммы);        
		
		ТабДокумент.Вывести(ОбластьИтогоСНДС);
		
		// Вывести Сумму прописью
		ОбластьМакетаСуммаПрописью = Макет.ПолучитьОбласть("СуммаПрописью");
		СуммаКПрописи = Сумма + ?(Шапка.СуммаВключаетНДС, 0, СуммаНДС);
		ОбластьМакетаСуммаПрописью.Параметры.ИтоговаяСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Всего наименований %1, на сумму %2'"), 
			ДанныеПоДокументу.Количество(), 
			ОбщегоНазначенияБКВызовСервера.ФорматСумм(СуммаКПрописи, Шапка.ВалютаДокумента));
			
		ОбластьМакетаСуммаПрописью.Параметры.СуммаПрописью = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Всего к оплате: %1'"),
			ОбщегоНазначенияБКВызовСервера.СформироватьСуммуПрописью(СуммаКПрописи, Шапка.ВалютаДокумента));
			
		ТабДокумент.Вывести(ОбластьМакетаСуммаПрописью);

		// Вывести подписи
	   	ОбластьМакетаПодвалЗаказа = Макет.ПолучитьОбласть("ПодвалЗаказа");
		ОбластьМакетаПодвалЗаказа.Параметры.ФИОИсполнителя = "/" + Шапка.Ответственный.Наименование + "/";
		
		ОбластьМакетаПодвалЗаказа.Параметры.Заполнить(Шапка);
		ТабДокумент.Вывести(ОбластьМакетаПодвалЗаказа);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
	// из-за малой высоты области подвала в ней не помещается полноразмерная печать
	Для Каждого ОбластьТабДокумента Из ТабДокумент.Области Цикл
		Если ТипЗнч(ОбластьТабДокумента) = Тип("РисунокТабличногоДокумента") И СтрНачинаетсяС(ОбластьТабДокумента.Имя, "ПечатьОрганизации") Тогда
			ОбластьТабДокумента.Верх = ОбластьТабДокумента.Верх - ОбластьТабДокумента.Высота;
			ОбластьТабДокумента.Лево = ОбластьТабДокумента.Лево - ОбластьТабДокумента.Ширина;
			ОбластьТабДокумента.Высота = ОбластьТабДокумента.Высота * 2;
			ОбластьТабДокумента.Ширина = ОбластьТабДокумента.Ширина * 2;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТабДокумент;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Взаимодействия.

Функция ПолучитьКонтакты(Ссылка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаПоКонтактам();
	Запрос.УстановитьПараметр("Предмет",Ссылка);
	
	НачатьТранзакцию();
	Попытка
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			Результат = Неопределено;
		Иначе
			Результат = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Контакт");
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция ТекстЗапросаПоКонтактам(Объединить = Ложь) Экспорт
	
	ШаблонВыбрать = ?(Объединить, "ВЫБРАТЬ РАЗЛИЧНЫЕ", "ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ");
	
	ТекстЗапроса = "
	|%ШаблонВыбрать%
	|	ТаблицаДокумента.Контрагент КАК Контакт
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Предмет
	|	И (НЕ ТаблицаДокумента.Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаДокумента.Организация КАК Контакт
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Предмет
	|	И (НЕ ТаблицаДокумента.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаДокумента.Автор КАК Контакт
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Предмет
	|	И (НЕ ТаблицаДокумента.Автор = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаДокумента.СтруктурноеПодразделение КАК Контакт
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Предмет
	|	И (НЕ ТаблицаДокумента.СтруктурноеПодразделение = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаДокумента.Ответственный КАК Контакт
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Предмет
	|	И (НЕ ТаблицаДокумента.Ответственный = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка))";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ШаблонВыбрать%", ШаблонВыбрать);
	
	Если Объединить Тогда
		
		ТекстЗапроса = "
		| ОБЪЕДИНИТЬ
		|" + ТекстЗапроса;
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецЕсли
