#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("ДокументСсылка.ЭСФ") Тогда
		
		ЭСФСервер.ЗаполнитьСчетФактуруПолученный(ДанныеЗаполнения, ЭтотОбъект);
		
	ИначеЕсли ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		
		ЗаполнитьПоДокументуОснования(ДанныеЗаполнения);
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);	
		
	Иначе
		
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
		
		УчетНДСИАкциза.ЗаполнитьПоставщикПокупательПоОрганизации(ЭтотОбъект, "Покупатель");
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.Автор) Тогда
		ЭтотОбъект.Автор = Пользователи.ТекущийПользователь();
	КонецЕсли;
				
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если НЕ ДатаОборотаВТабличнойЧасти Тогда
		ПроверяемыеРеквизиты.Добавить("ДатаСовершенияОборотаПоРеализации");
	КонецЕсли;
		
	Если ЭтотОбъект.Товары.Количество() > 0 
		ИЛИ ЭтотОбъект.Услуги.Количество() > 0
			ИЛИ ЭтотОбъект.ОС.Количество() > 0 
			ИЛИ ЭтотОбъект.НМА.Количество() > 0 Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги");
		МассивНепроверяемыхРеквизитов.Добавить("ОС");
		МассивНепроверяемыхРеквизитов.Добавить("НМА");
		
	КонецЕсли;
	
	Если ЭтотОбъект.ДополнительныеСвойства.Свойство("ЗаписьИзДокументаПодтверждающегоОтгрузку") Тогда
		Если ЭтотОбъект.ДополнительныеСвойства.ЗаписьИзДокументаПодтверждающегоОтгрузку = Истина Тогда
			
			// Проверка будет выполнена ниже.
			МассивНепроверяемыхРеквизитов.Добавить("ОсновнойСчетФактура");
			
			// Если реквизит ОсновнойСчетФактура будет пустым,
			// то будет показано сообщение, но отказ от проведения не произойдет,
			// так как иначе не удастся записать документ отгрузки или поступления.			
			Если ВидСчетаФактуры = Перечисления.ВидыСчетовФактур.Дополнительный
			 ИЛИ ВидСчетаФактуры = Перечисления.ВидыСчетовФактур.Исправленный Тогда
				
				Если НЕ ЗначениеЗаполнено(ЭтотОбъект.ОсновнойСчетФактура) Тогда					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Поле ""Основной счет-фактура"" не заполнено.'"), ЭтотОбъект.Ссылка, "ОсновнойСчетФактура")					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ВидСчетаФактуры <> Перечисления.ВидыСчетовФактур.Дополнительный
		И ВидСчетаФактуры <> Перечисления.ВидыСчетовФактур.Исправленный Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ОсновнойСчетФактура");
		
	КонецЕсли;
	
	Если НЕ ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНДС(Организация, Дата)
		ИЛИ НЕ УчитыватьНДС Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СтавкаНДС");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СтавкаНДС");
		МассивНепроверяемыхРеквизитов.Добавить("ОС.СтавкаНДС");
		МассивНепроверяемыхРеквизитов.Добавить("НМА.СтавкаНДС");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЭтотОбъект.ДокументОснование)
		И ТипЗнч(ЭтотОбъект.ДокументОснование) = Тип("ДокументСсылка.ПоступлениеДопРасходов")
		И НЕ ЭтотОбъект.ДокументОснование.УчитыватьНДС Тогда
		
		ТекстСообщения = НСтр("ru = 'В связанном счете-фактуре очистились показатели ""Ставка НДС"", %1 и %2 не проведутся! Для проведения %2 необходимо в счете-фактуре снять признак ""Подтвержден документами отгрузки""'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ЭтотОбъект.Ссылка, ЭтотОбъект.ДокументОснование);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект.Ссылка, , "Объект");
		
	КонецЕсли;

	Если ВидСчетаФактуры = Перечисления.ВидыСчетовФактур.Дополнительный Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если ПодтвержденДокументамиОтгрузки И ДокументыОснования.Количество() > 1 Тогда 
		ПроверитьРеквизитыДокументовОснований(Отказ);
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ВыполненаПроверкаЗаполнения", Истина);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение 
		И НЕ ДополнительныеСвойства.Свойство("ВыполненаПроверкаЗаполнения") 
		ИЛИ (ДополнительныеСвойства.Свойство("ВыполненаПроверкаЗаполнения") И НЕ ДополнительныеСвойства.ВыполненаПроверкаЗаполнения) Тогда 
		
		Отказ = НЕ ПроверитьЗаполнение();
	КонецЕсли;
		
	Если ДокументыОснования.Количество() = 0 Тогда
		ПодтвержденДокументамиОтгрузки = Ложь;
	КонецЕсли;
	
	УчетНДСИАкциза.ОчиститьДанныеПоУчастникамСовместнойДеятельности(ЭтотОбъект, ДоговорКонтрагента);

	СуммаДокумента = УчетНДСИАкциза.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Товары") + УчетНДСИАкциза.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Услуги") + УчетНДСИАкциза.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "ОС") + УчетНДСИАкциза.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "НМА");
	
	Документы.СчетФактураПолученный.ОпределениеПараметровСчетаФактуры(ЭтотОбъект);
	
	ЭСФСервер.ПередЗаписьюСчетаФактуры(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.СчетФактураПолученный.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
	Документы.СчетФактураПолученный.ПроверитьВозможностьПроведения(ЭтотОбъект, Отказ);	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ

	Если ВидСчетаФактуры = Перечисления.ВидыСчетовФактур.Исправленный Тогда
		МассивСФПрекратившихДействие = Новый Массив;
		Документы.СчетФактураПолученный.ДобавитьДвиженияСторнирующиеИсправляемыеСчетаФактуры(ЭтотОбъект, МассивСФПрекратившихДействие);
		Документы.СчетФактураПолученный.ДобавитьДвиженияПоСчетамФактурамПрекратившимДействие(ЭтотОбъект, МассивСФПрекратившихДействие);
	КонецЕсли;
	
	ЭСФСервер.ОбновитьДвиженияСторнирующихДокументов(ЭтотОбъект);


	// Если вдруг не удалось получить параметры проведения и не установлен флаг Отказ, то просто выйдем из проведения
	Если ПараметрыПроведения = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	 
	Если ПараметрыПроведения.СчетФактураПолученныйТаблицаТовары.Количество() <> 0 Тогда 
		УчетНДСИАкциза.СформироватьДвиженияСчетФактураПолученный(ПараметрыПроведения.СчетФактураПолученныйТаблицаТовары,
			ПараметрыПроведения.СчетФактураПолученныйРеквизиты, Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.СчетФактураПолученныйТаблицаУслуги.Количество() <> 0 Тогда 
		УчетНДСИАкциза.СформироватьДвиженияСчетФактураПолученный(ПараметрыПроведения.СчетФактураПолученныйТаблицаУслуги,
			ПараметрыПроведения.СчетФактураПолученныйРеквизиты, Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.СчетФактураПолученныйТаблицаОС.Количество() <> 0 Тогда 
		УчетНДСИАкциза.СформироватьДвиженияСчетФактураПолученный(ПараметрыПроведения.СчетФактураПолученныйТаблицаОС,
			ПараметрыПроведения.СчетФактураПолученныйРеквизиты, Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.СчетФактураПолученныйТаблицаНМА.Количество() <> 0 Тогда 
		УчетНДСИАкциза.СформироватьДвиженияСчетФактураПолученный(ПараметрыПроведения.СчетФактураПолученныйТаблицаНМА,
			ПараметрыПроведения.СчетФактураПолученныйРеквизиты, Движения, Отказ);
	КонецЕсли;
					
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Документы.СчетФактураПолученный.ПроверитьВозможностьОтменыПроведения(ЭтотОбъект, Отказ);
	
	Если НЕ Отказ Тогда
		ЭСФСервер.ОбновитьДвиженияСторнирующихДокументов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(),,, ОбъектКопирования.Ссылка);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ЭСФСервер.ОбновитьСторнирующиеДокументы(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура выполняет заполнение документа по документу-основанию
//
Процедура ЗаполнитьПоДокументуОснования(Основание) Экспорт
	
	Документы.СчетФактураПолученный.ЗаполнитьПоДокументуОснования(ЭтотОбъект, Основание);

КонецПроцедуры

Процедура ПроверитьРеквизитыДокументовОснований(Отказ)
	
	ТекстЗапросаШаблон = "
	|
	|ВЫБРАТЬ 
	|	Док.Ссылка,
	|	%1,
	|	%2,
	|	%3
	|ИЗ
	|	Документ.%4 КАК Док
	|ГДЕ
	|	Док.Ссылка В(&МассивОснований)
	|";
	
	ТекстОбъединения = "
	|ОБЪЕДИНИТЬ ВСЕ";
	
	МассивОснований = ОбщегоНазначения.ВыгрузитьКолонку(ДокументыОснования, "ДокументОснование", Истина);
	МассивТиповОснований = Новый Массив;
	
	ПерваяТаблица = Истина;
	ТекстЗапроса = "";
	Для Каждого ТекОснование Из МассивОснований Цикл
		
		ТипЗначенияОснования = ТипЗнч(ТекОснование);
		Если МассивТиповОснований.Найти(ТипЗначенияОснования) <> Неопределено
			ИЛИ ТипЗначенияОснования = Тип("ДокументСсылка.АвансовыйОтчет") Тогда 
			Продолжить;
		КонецЕсли;
		
		МассивТиповОснований.Добавить(ТипЗначенияОснования);

		МетаданныеДокументаОснования = ТекОснование.Метаданные();
		ЕстьРеквизитКонтрагент 		 = ОбщегоНазначенияБК.ЕстьРеквизитДокумента("Контрагент",         МетаданныеДокументаОснования);
		ЕстьРеквизитДоговор 		 = ОбщегоНазначенияБК.ЕстьРеквизитДокумента("ДоговорКонтрагента", МетаданныеДокументаОснования);
		ЕстьРеквизитВалютаДокумента  = ОбщегоНазначенияБК.ЕстьРеквизитДокумента("ВалютаДокумента",    МетаданныеДокументаОснования);
		
		Если НЕ ПерваяТаблица Тогда 
			ТекстЗапроса = ТекстЗапроса + ТекстОбъединения;
		КонецЕсли;
		ПерваяТаблица = Ложь;
		
		ТекстЗапроса = ТекстЗапроса + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
											ТекстЗапросаШаблон,
											?(ЕстьРеквизитКонтрагент,      "Док.Контрагент",         "НЕОПРЕДЕЛЕНО"),
											?(ЕстьРеквизитДоговор,         "Док.ДоговорКонтрагента", "НЕОПРЕДЕЛЕНО"),
											?(ЕстьРеквизитВалютаДокумента, "Док.ВалютаДокумента",    "НЕОПРЕДЕЛЕНО"),
											МетаданныеДокументаОснования.Имя);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОснований", МассивОснований);
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Для Каждого СтрокаТабличнойЧасти Из ДокументыОснования Цикл
		
		Если НЕ Выборка.НайтиСледующий(СтрокаТабличнойЧасти.ДокументОснование) Тогда 
			Продолжить;
		КонецЕсли;
		
		Если НЕ Выборка.Контрагент = Неопределено И Контрагент <> Выборка.Контрагент Тогда 
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка", 
				"Корректность", 
				НСтр("ru='Документ-основание'"), 
				СтрокаТабличнойЧасти.НомерСтроки, 
				НСтр("ru='Документы-основания'"), 
				НСтр("ru='Значение контрагента не соответствует значению, установленному в счете-фактуре'"));
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"ДокументыОснования[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ДокументОснование",
				,
				Отказ);
		КонецЕсли;
		
		Если НЕ Выборка.ДоговорКонтрагента = Неопределено И ДоговорКонтрагента <> Выборка.ДоговорКонтрагента Тогда 
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка", 
				"Корректность", 
				НСтр("ru='Документ-основание'"), 
				СтрокаТабличнойЧасти.НомерСтроки, 
				НСтр("ru='Документы-основания'"), 
				НСтр("ru='Значение договора контрагента не соответствует значению, установленному в счете-фактуре'"));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"ДокументыОснования[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ДокументОснование",
				,
				Отказ);
		КонецЕсли;
		
		Если НЕ Выборка.ВалютаДокумента = Неопределено И ВалютаДокумента <> Выборка.ВалютаДокумента Тогда 
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка", 
				"Корректность", 
				НСтр("ru='Документ-основание'"), 
				СтрокаТабличнойЧасти.НомерСтроки, 
				НСтр("ru='Документы-основания'"), 
				НСтр("ru='Значение валюты документа не соответствует значению, установленному в счете-фактуре'"));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"ДокументыОснования[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ДокументОснование",
				,
				Отказ);
		КонецЕсли;
		
		Выборка.Сбросить();
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли