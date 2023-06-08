////////////////////////////////////////////////////////////////////////////////
// ОбработкаТабличныхЧастей:
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура заполняет ставку НДС в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти     - строка табличной части документа,
//  ДокументОбъект           - объект редактируемого документа.
//
Процедура ЗаполнитьСтавкуНДСТабЧасти(СтрокаТабличнойЧасти, ИмяТабличнойЧасти, МетаданныеДокумента) Экспорт

	//Заполнить СтавкаНДС
	Если ОбщегоНазначенияБК.ЕстьРеквизитТабЧастиДокумента("СтавкаНДС", МетаданныеДокумента, ИмяТабличнойЧасти) Тогда
		СтрокаТабличнойЧасти.СтавкаНДС = СтрокаТабличнойЧасти.Номенклатура.СтавкаНДС;
	КонецЕсли;

КонецПроцедуры // ЗаполнитьСтавкуНДСТабЧасти()

// Процедура заполняет ставку Акциза в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти     - строка табличной части документа,
//  ДокументОбъект           - объект редактируемого документа.
//
Процедура ЗаполнитьСтавкуАкцизаТабЧасти(СтрокаТабличнойЧасти, ИмяТабличнойЧасти, МетаданныеДокумента) Экспорт

	Если ОбщегоНазначенияБК.ЕстьРеквизитТабЧастиДокумента("СтавкаАкциза", МетаданныеДокумента, ИмяТабличнойЧасти) Тогда
		СтрокаТабличнойЧасти.СтавкаАкциза = СтрокаТабличнойЧасти.Номенклатура.СтавкаАкциза;
	КонецЕсли;

КонецПроцедуры // ЗаполнитьСтавкуАкцизаТабЧасти()

// Процедура заполняет Вид поступления в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти	- строка табличной части документа,
//	ТекПользователь			- пользователь
//  Корректировка           - может принимать значения Истина, Ложь или Неопределено.
//                            Используется для проверки реквизита ПризнакКорректировки у полученного Вида поступления.
//                            Если Корректировка=Истина, то Виды поступления с ПризнакКорректировки=Ложь очищаются.
//                            Если Корректировка=Ложь, то Виды поступления с ПризнакКорректировки=Истина очищаются.
//                            Если Корректировка=Неопределено (или не задан), то проверка реквизита ПризнакКорректировки не выполняется.
//
Процедура ЗаполнитьНДСВидПоступленияТабЧасти(СтрокаТабличнойЧасти, ИмяТабличнойЧасти, МетаданныеДокумента, ТекПользователь, Корректировка = Неопределено) Экспорт
	
	Если ОбщегоНазначенияБК.ЕстьРеквизитТабЧастиДокумента("НДСВидПоступления", МетаданныеДокумента, ИмяТабличнойЧасти) 
		И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.НДСВидПоступления) Тогда
		
		ВидДокумента = МетаданныеДокумента.Имя;
		
		Если ВидДокумента = "ВозвратТоваровПоставщику" ИЛИ
			 ВидДокумента = "ВозвратТоваровПоставщикуИзНТТ" Тогда
			// для возвратов подставляем предопределенный элемент
			СтрокаТабличнойЧасти.НДСВидПоступления = Справочники.ВидыПоступления.ВозвратТМЗ;
		ИначеЕсли ВидДокумента = "СписаниеТоваров" Тогда
			// для возвратов подставляем предопределенный элемент
			СтрокаТабличнойЧасти.НДСВидПоступления = Справочники.ВидыПоступления.СписаниеТМЗ;	
		ИначеЕсли ВидДокумента = "ГТДИмпорт" Тогда			
			СтрокаТабличнойЧасти.НДСВидПоступления = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновнойВидПоступленияИмпорт");
		Иначе
			// для остальных документов - значение по умолчанию для пользователя
			СтрокаТабличнойЧасти.НДСВидПоступления = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновнойВидПоступления");
		КонецЕсли;
		
		Если Корректировка <> Неопределено И ЗначениеЗаполнено(СтрокаТабличнойЧасти.НДСВидПоступления) Тогда
			ПризнакКорректировки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТабличнойЧасти.НДСВидПоступления, "ПризнакКорректировки");
			Если Корректировка <> ПризнакКорректировки Тогда
				СтрокаТабличнойЧасти.НДСВидПоступления = Справочники.ВидыПоступления.ПустаяСсылка();
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;	
	
КонецПроцедуры // ЗаполнитьНДСВидПоступленияТабЧасти()

// Процедура заполняет Вид реализации в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти	- строка табличной части документа,
//	ТекПользователь			- пользователь
//
Процедура ЗаполнитьНДСВидРеализацииТабЧасти(СтрокаТабличнойЧасти, ИмяТабличнойЧасти, МетаданныеДокумента, ТекПользователь) Экспорт

	Если ОбщегоНазначенияБК.ЕстьРеквизитТабЧастиДокумента("НДСВидОперацииРеализации", МетаданныеДокумента, ИмяТабличнойЧасти)
	   И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.НДСВидОперацииРеализации) Тогда
	   
		ВидДокумента = МетаданныеДокумента.Имя;
		
		Если ВидДокумента = "ВозвратТоваровОтПокупателя" Тогда
			// Для возвратов подставляем предопределенный элемент
			СтрокаТабличнойЧасти.НДСВидОперацииРеализации = Справочники.ВидыРеализации.ВозвратТМЗ;
		Иначе
			// Для остальных документов - значение по умолчанию для пользователя
			СтрокаТабличнойЧасти.НДСВидОперацииРеализации = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновнойВидОперацииРеализации");
			
			//если не заполнена настройка по умолчанию
			Если Не ЗначениеЗаполнено(СтрокаТабличнойЧасти.НДСВидОперацииРеализации) Тогда
				СтрокаТабличнойЧасти.НДСВидОперацииРеализации  = Справочники.ВидыРеализации.РеализацияТМЗ;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ЗаполнитьНДСВидРеализацииТабЧасти()

// Процедура заполняет Вид реализации по Акцизу в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти     - строка табличной части документа,
//	ТекПользователь			- пользователь
//
Процедура ЗаполнитьАкцизВидРеализацииТабЧасти(СтрокаТабличнойЧасти, ИмяТабличнойЧасти, МетаданныеДокумента, ТекПользователь) Экспорт

	Если ОбщегоНазначенияБК.ЕстьРеквизитТабЧастиДокумента("АкцизВидОперацииРеализации", МетаданныеДокумента, ИмяТабличнойЧасти)
	   И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.АкцизВидОперацииРеализации) Тогда
	   
		//Значение по умолчанию для пользователя
		СтрокаТабличнойЧасти.АкцизВидОперацииРеализации = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновнойВидОперацииОблагаемойАкцизом");

		//если не заполнена настройка по умолчанию
		Если Не ЗначениеЗаполнено(СтрокаТабличнойЧасти.АкцизВидОперацииРеализации) Тогда
			СтрокаТабличнойЧасти.АкцизВидОперацииРеализации  = Справочники.ВидыОперацийОблагаемыхАкцизом.Реализация;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ЗаполнитьНДСВидРеализацииТабЧасти()

// Процедура заполняет Вид оборота в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти     - строка табличной части документа,
//  ДокументОбъект           - объект редактируемого документа.
//
Процедура ЗаполнитьНДСВидОборотаТабЧасти(СтрокаТабличнойЧасти, ДокументОбъект, ИмяТабличнойЧасти, МетаданныеДокумента) Экспорт
	
	Если ОбщегоНазначенияБК.ЕстьРеквизитТабЧастиДокумента("НДСВидОборота", МетаданныеДокумента, ИмяТабличнойЧасти)
	   И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.НДСВидОборота) Тогда
	   
		Если УчетнаяПолитикаСервер.ПолучитьМетодОтнесенияНДСВЗачет(ДокументОбъект.Организация, ДокументОбъект.Дата) = Перечисления.МетодыОтнесенияНДСВЗачет.Пропорциональный Тогда
			СтрокаТабличнойЧасти.НДСВидОборота = Перечисления.ВидыОборотовПоРеализации.Общий;
		Иначе
			СтрокаТабличнойЧасти.НДСВидОборота = Перечисления.ВидыОборотовПоРеализации.Облагаемый;
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры // ЗаполнитьНДСВидОборотаТабЧасти()

// Процедура заполняет Содержание из полного наименования номенклатуры в строке табличной части
//
// Параметры
//  СтрокаТабличнойЧасти - Строка табличной части
//
Процедура ЗаполнитьСодержаниеТабЧасти(СтрокаТабличнойЧасти, Документобъект, ИмяТабличнойЧасти, МетаданныеДокумента) Экспорт

	Если ОбщегоНазначенияБК.ЕстьРеквизитТабЧастиДокумента("Содержание", МетаданныеДокумента, ИмяТабличнойЧасти) Тогда
		
		НаименованиеПолное = СтрокаТабличнойЧасти.Номенклатура.НаименованиеПолное;

		Если ПустаяСтрока(НаименованиеПолное) Тогда
			СтрокаТабличнойЧасти.Содержание = СтрокаТабличнойЧасти.Номенклатура.Наименование;
		Иначе
			СтрокаТабличнойЧасти.Содержание = НаименованиеПолное;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ЗаполнитьСодержаниеТабЧасти()

// Процедура заполняет единицу и цену по ценам продажи в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа,
//  ДокументОбъект       - объект редактируемого документа.
//  ВалютаРегламентированногоУчета - валюта регламентированного учета
//
Процедура ЗаполнитьЕдиницуЦенуПродажиТабЧасти(СтрокаТабличнойЧасти, ДокументОбъект, ИмяТабличнойЧасти, МетаданныеДокумента) Экспорт

	ВалютаРегламентированногоУчета = ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Если ТипЗнч(ДокументОбъект) = Тип("Структура") Тогда  		
		ВалютаДокумента = ?(ДокументОбъект.Свойство("ВалютаДокумента"), ДокументОбъект.ВалютаДокумента, ВалютаРегламентированногоУчета);
		Если ДокументОбъект.Свойство("КурсДокумента") Тогда
			КурсДок = ДокументОбъект.КурсДокумента;  
		ИначеЕсли ДокументОбъект.Свойство("КурсВзаиморасчетов") Тогда
			КурсДок = ДокументОбъект.КурсВзаиморасчетов;  
		Иначе
			КурсДок = 1;  
		КонецЕсли;
		Если ДокументОбъект.Свойство("КратностьДокумента") Тогда
			КратностьДок = ДокументОбъект.КратностьДокумента;  
		ИначеЕсли ДокументОбъект.Свойство("КратностьВзаиморасчетов") Тогда
			КратностьДок = ДокументОбъект.КратностьВзаиморасчетов;  
		Иначе
			КратностьДок = 1;  
		КонецЕсли;
	Иначе           		 		
		ВалютаДокумента = ?(ОбщегоНазначенияБК.ЕстьРеквизитДокумента("ВалютаДокумента", МетаданныеДокумента), ДокументОбъект.ВалютаДокумента, ВалютаРегламентированногоУчета);  
		КурсДок         = ?(ОбщегоНазначенияБК.ЕстьРеквизитДокумента("ВалютаДокумента", МетаданныеДокумента), ОбщегоНазначенияБК.КурсДокумента(ДокументОбъект, ВалютаРегламентированногоУчета), 1);
		КратностьДок    = ?(ОбщегоНазначенияБК.ЕстьРеквизитДокумента("ВалютаДокумента", МетаданныеДокумента), ОбщегоНазначенияБК.КратностьДокумента(ДокументОбъект, ВалютаРегламентированногоУчета), 1);		
	КонецЕсли;

	// Из регистра сведений ЦеныНоменклатуры по Номенклатура, ТипЦен получить ресурсы, 
	// установить коэффициент.
	// Если не заданы значения измерений, то устанавливаем по справочнику
	ТипЦен = "";

	Если МетаданныеДокумента.Реквизиты.Найти("ТипЦен") <> Неопределено Тогда
		ТипЦен = ДокументОбъект.ТипЦен;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТипЦен) Тогда
		
		// из регистра ЦеныНоменклатурыДокументов
		ЦенаИНДС = УправлениеЦенообразованием.ПолучитьЦенуПоДокументам(СтрокаТабличнойЧасти.Номенклатура,
			Перечисления.СпособыЗаполненияЦен.ПоПродажнымЦенам,
			ДокументОбъект.Дата, ВалютаДокумента,
			КурсДок, КратностьДок);
		
		Цена = ЦенаИНДС.Цена;
		ЦенаВключаетНДС = ЦенаИНДС.ЦенаВключаетНДС;
		
		Если ЗначениеЗаполнено(Цена) Тогда
			
			СуммаВключаетНДС = ОбщегоНазначенияБК.ЕстьРеквизитДокумента("СуммаВключаетНДС", МетаданныеДокумента)
				И ДокументОбъект.СуммаВключаетНДС;
			
			УчитыватьНДС     = ОбщегоНазначенияБК.ЕстьРеквизитДокумента("УчитыватьНДС", МетаданныеДокумента)
				И ДокументОбъект.УчитыватьНДС;
			
			Если ОбщегоНазначенияБК.ЕстьРеквизитТабЧастиДокумента("СтавкаНДС", МетаданныеДокумента, ИмяТабличнойЧасти) Тогда
				СтавкаНДС = УчетНДСиАкцизаВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС);
			Иначе
				СтавкаНДС = 0;
			КонецЕсли;
			
			Цена = ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(
						Цена, Перечисления.СпособыЗаполненияЦен.ПоПродажнымЦенам, ЦенаВключаетНДС, УчитыватьНДС, СуммаВключаетНДС, СтавкаНДС);

			СтрокаТабличнойЧасти.Цена = Цена;
			
		Иначе

			СтрокаТабличнойЧасти.Цена = 0;
			
		КонецЕсли;
		
		// ЕдиницаИзмерения и Коэффициент берем из самого реквизита Номенклатура
		Если ОбщегоНазначенияБК.ЕстьРеквизитТабЧастиДокумента("ЕдиницаИзмерения", МетаданныеДокумента, ИмяТабличнойЧасти) Тогда
			СтрокаТабличнойЧасти.ЕдиницаИзмерения = СтрокаТабличнойЧасти.Номенклатура.БазоваяЕдиницаИзмерения;
		КонецЕсли;
		Если ОбщегоНазначенияБК.ЕстьРеквизитТабЧастиДокумента("Коэффициент", МетаданныеДокумента, ИмяТабличнойЧасти) Тогда
			СтрокаТабличнойЧасти.Коэффициент      = 1;
		КонецЕсли;
			
	Иначе
		// из регистра
		Цена = УправлениеЦенообразованием.ПолучитьЦенуНоменклатуры(СтрокаТабличнойЧасти.Номенклатура,
										ДокументОбъект.ТипЦен, ДокументОбъект.Дата,
										ВалютаДокумента, КурсДок, КратностьДок, ДокументОбъект.Организация);

		// Если цену заполнили из регистра, то ее надо пересчитывать по флагам налогообложения
		Если НЕ ЗначениеЗаполнено(Цена) Тогда
			СтрокаТабличнойЧасти.Цена = 0;
		Иначе

			СтрокаТабличнойЧасти.Цена = ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(Цена, 
																					Перечисления.СпособыЗаполненияЦен.ПоЦенамНоменклатуры, 
																					ДокументОбъект.ТипЦен.ЦенаВключаетНДС,
																					ОбщегоНазначенияБК.ЕстьРеквизитДокумента("УчитыватьНДС", МетаданныеДокумента) 
																					И ДокументОбъект.УчитыватьНДС, 
																					ОбщегоНазначенияБК.ЕстьРеквизитДокумента("СуммаВключаетНДС", МетаданныеДокумента) 
																					И ДокументОбъект.СуммаВключаетНДС, 
																					?(ОбщегоНазначенияБК.ЕстьРеквизитТабЧастиДокумента("СтавкаНДС", МетаданныеДокумента, ИмяТабличнойЧасти),
																					УчетНДСиАкцизаВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС), 0));
		КонецЕсли;

		// Если единица оказалась не заполненной, то заполняем ее основной единицей номеклатуры
		Если ОбщегоНазначенияБК.ЕстьРеквизитТабЧастиДокумента("ЕдиницаИзмерения", МетаданныеДокумента, ИмяТабличнойЧасти) Тогда
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ЕдиницаИзмерения) Тогда
				СтрокаТабличнойЧасти.ЕдиницаИзмерения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТабличнойЧасти.Номенклатура, "БазоваяЕдиницаИзмерения");
				СтрокаТабличнойЧасти.Коэффициент      = 1;
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

// Процедура заполняет единицу и цену по ценам покупки в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти           - строка табличной части документа,
//  ДокументОбъект                 - объект редактируемого документа.
//  ВалютаРегламентированногоУчета - валюта регламентированного учета
//  ПересчитыватьНалогиВЦене       - булево, определяет необходимость пересчета цен по флагам налогов в документе,
//                                   необязательный, по умолчанию Истина.
//
Процедура ЗаполнитьЕдиницуЦенуПокупкиТабЧасти(СтрокаТабличнойЧасти, ДокументОбъект,  ИмяТабличнойЧасти, МетаданныеДокумента, ПересчитыватьНалогиВЦене = Истина) Экспорт

	ВалютаРегламентированногоУчета = ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ТипЦен           = ?(ОбщегоНазначенияБК.ЕстьРеквизитДокумента("ТипЦен", МетаданныеДокумента), ДокументОбъект.ТипЦен, "");  
	ДатаДокумента    = ДокументОбъект.Дата;  
	ВалютаДокумента  = ?(ОбщегоНазначенияБК.ЕстьРеквизитДокумента("ВалютаДокумента", МетаданныеДокумента), ДокументОбъект.ВалютаДокумента, ВалютаРегламентированногоУчета);  
	УчитыватьНДС     = ?(ОбщегоНазначенияБК.ЕстьРеквизитДокумента("УчитыватьНДС", МетаданныеДокумента), ДокументОбъект.УчитыватьНДС, Истина);  
	СуммаВключаетНДС = ?(ОбщегоНазначенияБК.ЕстьРеквизитДокумента("СуммаВключаетНДС", МетаданныеДокумента), ДокументОбъект.СуммаВключаетНДС, Истина);  	
	КурсДок          = ?(ОбщегоНазначенияБК.ЕстьРеквизитДокумента("ВалютаДокумента", МетаданныеДокумента), ОбщегоНазначенияБК.КурсДокумента(ДокументОбъект, ВалютаРегламентированногоУчета), 1);
	КратностьДок     = ?(ОбщегоНазначенияБК.ЕстьРеквизитДокумента("ВалютаДокумента", МетаданныеДокумента), ОбщегоНазначенияБК.КратностьДокумента(ДокументОбъект, ВалютаРегламентированногоУчета), 1);
	
	// Если не заданы значения измерений, то устанавливаем по справочнику
	Если НЕ ЗначениеЗаполнено(ТипЦен) Тогда 

		// берем из самого реквизита Номенклатура
		Если ОбщегоНазначенияБК.ЕстьРеквизитТабЧастиДокумента("ЕдиницаИзмерения", МетаданныеДокумента, ИмяТабличнойЧасти) Тогда
			СтрокаТабличнойЧасти.ЕдиницаИзмерения = СтрокаТабличнойЧасти.Номенклатура.БазоваяЕдиницаИзмерения;
		КонецЕсли;	
		Если ОбщегоНазначенияБК.ЕстьРеквизитТабЧастиДокумента("Коэффициент", МетаданныеДокумента, ИмяТабличнойЧасти) Тогда
			СтрокаТабличнойЧасти.Коэффициент      = 1;
		КонецЕсли;
		СтрокаТабличнойЧасти.Цена             = 0;		

	Иначе
		// из регистра
		Цена = УправлениеЦенообразованием.ПолучитьЦенуНоменклатуры(СтрокаТабличнойЧасти.Номенклатура,
										ТипЦен, ДатаДокумента,
										ВалютаДокумента, КурсДок, КратностьДок, ДокументОбъект.Организация);

		// Если цену заполнили из регистра, то ее надо пересчитывать по флагам налогообложения
		Если НЕ ЗначениеЗаполнено(Цена) Тогда
			СтрокаТабличнойЧасти.Цена = 0;
		Иначе

			Если ПересчитыватьНалогиВЦене Тогда
				СтрокаТабличнойЧасти.Цена = ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(	Цена, 
																						Перечисления.СпособыЗаполненияЦен.ПоЦенамНоменклатурыКонтрагентов, 
																						ТипЦен.ЦенаВключаетНДС,
																						УчитыватьНДС, СуммаВключаетНДС, 
																						УчетНДСиАкцизаВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));
			Иначе
				СтрокаТабличнойЧасти.Цена = Цена;
			КонецЕсли;
		КонецЕсли;

		// Если единица оказалась не заполненной, то заполняем ее основной единицей номеклатуры
		Если ОбщегоНазначенияБК.ЕстьРеквизитТабЧастиДокумента("ЕдиницаИзмерения", МетаданныеДокумента, ИмяТабличнойЧасти) Тогда
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ЕдиницаИзмерения) Тогда
				СтрокаТабличнойЧасти.ЕдиницаИзмерения  = СтрокаТабличнойЧасти.Номенклатура.БазоваяЕдиницаИзмерения;
				СтрокаТабличнойЧасти.Коэффициент = 1
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;

	// если в документе существует реквизит КоличествоМест, то рассчитанная цена идет за него
	// вычислим цену за базовую единицу
	Если ОбщегоНазначенияБК.ЕстьРеквизитТабЧастиДокумента("ЕдиницаИзмерения", МетаданныеДокумента, ИмяТабличнойЧасти) Тогда
		Если СтрокаТабличнойЧасти.Коэффициент > 0 Тогда
			СтрокаТабличнойЧасти.Цена = СтрокаТабличнойЧасти.Цена / СтрокаТабличнойЧасти.Коэффициент;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ЗаполнитьЕдиницуЦенуПокупкиТабЧасти()

Функция ПолучитьСведенияОНоменклатуре(Номенклатура, ПараметрыОбъекта) Экспорт

	Если ТипЗнч(Номенклатура) <> Тип("СправочникСсылка.Номенклатура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СписокНоменклатуры = Новый Массив;
	СписокНоменклатуры.Добавить(Номенклатура);
	
	СведенияОНоменклатуре = ПолучитьСведенияОСпискеНоменклатуры(СписокНоменклатуры, ПараметрыОбъекта).Получить(Номенклатура);
	
	Возврат СведенияОНоменклатуре;

КонецФункции

// Возвращает сведения о массиве номенклатуры
//
// Параметры:
//  СписокНоменклатуры - массив номенклатуры
//  ПараметрыОбъекта   - структура содержащая поля:
//  - Дата                    - обязательный
//  - Организация             - обязательный
//  - ТипЦен                  - не обязательный
//  - ВалютаДокумента         - не обязательный
//  - КурсВзаиморасчетов      - не обязательный
//  - КратностьВзаиморасчетов - не обязательный
//  - СуммаВключаетНДС        - не обязательный
//  - СтавкаНДС               - не обязательный (Если параметр передан,
//    то будет использована переданная ставка, иначе ставка из номенклатуры)
//
// Возвращает соответствие:
//  Ключ     - номенклатура
//  Значение - структура сведений о номенклатуре
//
Функция ПолучитьСведенияОСпискеНоменклатуры(СписокНоменклатуры, ПараметрыОбъекта) Экспорт
	Перем СтавкаНДС, ЦенаВключаетНДС, СуммаВключаетНДС, СтавкаАкциза;
	Перем ВалютаДокумента, КурсДокумента, КратностьДокумента;
	Перем ТипЦен, ТипЦенПлановойСебестоимости;
	Перем ТаблицаЦен, ТаблицаЦенПлановойСебестоимости, ЗаполнятьЦену;
	Перем Реализация, ЗаполнятьСпецификацию;
	Перем СпособЗаполненияЦены;
	
	Дата		= ПараметрыОбъекта.Дата;
	Организация	= ПараметрыОбъекта.Организация;
	
	Если НЕ ПараметрыОбъекта.Свойство("Реализация", Реализация) Тогда
		Реализация = Ложь;
	КонецЕсли;
	
	Если НЕ ПараметрыОбъекта.Свойство("ЗаполнятьСпецификацию", ЗаполнятьСпецификацию) Тогда
		ЗаполнятьСпецификацию = Ложь;
	КонецЕсли;
		
	ПараметрыОбъекта.Свойство("СтавкаНДС", СтавкаНДС);
	ПараметрыОбъекта.Свойство("СпособЗаполненияЦены", СпособЗаполненияЦены);
	ПараметрыОбъекта.Свойство("ТипЦенПлановойСебестоимости", ТипЦенПлановойСебестоимости); 

	Если ПараметрыОбъекта.Свойство("ТипЦен", ТипЦен) И ЗначениеЗаполнено(ТипЦен) Тогда
		ЦенаВключаетНДС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТипЦен, "ЦенаВключаетНДС");
	Иначе
		ЦенаВключаетНДС = Ложь;
	КонецЕсли;
	
	Если НЕ ПараметрыОбъекта.Свойство("СуммаВключаетНДС", СуммаВключаетНДС) Тогда
		СуммаВключаетНДС = ЦенаВключаетНДС;
	КонецЕсли;
	
	Если ПараметрыОбъекта.Свойство("ЗаполнятьЦену", ЗаполнятьЦену) Тогда
		ЗаполнятьЦену = ЗаполнятьЦену И (ЗначениеЗаполнено(ТипЦен) ИЛИ ЗначениеЗаполнено(СпособЗаполненияЦены));
	Иначе
		ЗаполнятьЦену = ЗначениеЗаполнено(ТипЦен) ИЛИ ЗначениеЗаполнено(СпособЗаполненияЦены);	
	КонецЕсли;

	ВалютаРегламентированногоУчета = ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Если НЕ ПараметрыОбъекта.Свойство("ВалютаДокумента", ВалютаДокумента)
		ИЛИ НЕ ЗначениеЗаполнено(ВалютаДокумента) Тогда
		ВалютаДокумента = ВалютаРегламентированногоУчета;
	КонецЕсли;
	
	Если ВалютаДокумента <> ВалютаРегламентированногоУчета Тогда
		
		ПараметрыОбъекта.Свойство("КурсДокумента", КурсДокумента);
		ПараметрыОбъекта.Свойство("КратностьДокумента", КратностьДокумента);
		
		Если КурсДокумента = Неопределено ИЛИ КратностьДокумента = Неопределено Тогда
			ПараметрыОбъекта.Свойство("КурсВзаиморасчетов", КурсДокумента);
			ПараметрыОбъекта.Свойство("КратностьВзаиморасчетов", КратностьДокумента);
		КонецЕсли;
		
		Если КурсДокумента = Неопределено ИЛИ КратностьДокумента = Неопределено Тогда
			КурсНаДату = ОбщегоНазначенияБК.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
			КурсДокумента		= КурсНаДату.Курс;
			КратностьДокумента	= КурсНаДату.Кратность;
		КонецЕсли;
		
	Иначе
		КурсДокумента		= 1;
		КратностьДокумента	= 1;
	КонецЕсли;
	
	ИменаРеквизитов =
		"Код, Наименование, НаименованиеПолное, Артикул,
		|БазоваяЕдиницаИзмерения, СтавкаНДС,
		|Услуга, НоменклатурнаяГруппа,
		|СтавкаАкциза, КоэффициентРасчетаОблагаемойБазыАкциза,
		|ОсобенностьУчета";
	
	СоответствиеСведенийОНоменклатуре = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(СписокНоменклатуры, ИменаРеквизитов);
	
	СоответствиеСчетовУчета = ПроцедурыБухгалтерскогоУчета.ПолучитьСчетаУчетаСпискаНоменклатуры(
		Организация, СписокНоменклатуры, Дата);
	
	Если ЗаполнятьЦену Тогда
		Если ЗначениеЗаполнено(ТипЦен) Тогда
			ТаблицаЦен = УправлениеЦенообразованием.ПолучитьТаблицуЦенНоменклатуры(СписокНоменклатуры, ТипЦен, Дата, Организация);
		ИначеЕсли ЗначениеЗаполнено(СпособЗаполненияЦены) Тогда
			ТаблицаЦен = УправлениеЦенообразованием.ПолучитьТаблицуЦенНоменклатурыДокументов(СписокНоменклатуры, СпособЗаполненияЦены, Дата);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТипЦенПлановойСебестоимости) Тогда
		ТаблицаЦенПлановойСебестоимости = УправлениеЦенообразованием.ПолучитьТаблицуЦенНоменклатуры(СписокНоменклатуры, ТипЦенПлановойСебестоимости, Дата, Организация);
	КонецЕсли;
	
	Если ЗаполнятьСпецификацию Тогда
		ТаблицаСпецификаций = УправлениеПроизводствомСервер.ОпределитьСпецификациюПоУмолчанию(СписокНоменклатуры, Дата, Истина);
	КонецЕсли;
		
	ВидСубконтоНоменклатурныеГруппы = ПланыВидовХарактеристик.ВидыСубконтоТиповые.НоменклатурныеГруппы;
	
	Для Каждого Номенклатура Из СписокНоменклатуры Цикл
		
		СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(Номенклатура);
		Если СведенияОНоменклатуре = Неопределено Тогда
			СведенияОНоменклатуре = Новый Структура(ИменаРеквизитов);
			СоответствиеСведенийОНоменклатуре.Вставить(Номенклатура, СведенияОНоменклатуре);
		КонецЕсли;
		
		Если ПустаяСтрока(СведенияОНоменклатуре.НаименованиеПолное) Тогда
			СведенияОНоменклатуре.НаименованиеПолное = СведенияОНоменклатуре.Наименование;
		КонецЕсли;
		
		СведенияОНоменклатуре.Вставить("Коэффициент", 1);  		
				
		СчетаУчета = СоответствиеСчетовУчета.Получить(Номенклатура);
		СведенияОНоменклатуре.Вставить("СчетаУчета", СчетаУчета);  
		
		Содержание = ?(ПустаяСтрока(СведенияОНоменклатуре.НаименованиеПолное), СведенияОНоменклатуре.Наименование, СведенияОНоменклатуре.НаименованиеПолное);
		СведенияОНоменклатуре.Вставить("Содержание", Содержание);  
		
		Если ЗначениеЗаполнено(СтавкаНДС) Тогда;
			// Ставка НДС передана в параметрах
			СведенияОНоменклатуре.СтавкаНДС = СтавкаНДС;      			
		ИначеЕсли ЗначениеЗаполнено(СтавкаАкциза) Тогда;
			// Ставка НДС передана в параметрах
			СведенияОНоменклатуре.СтавкаАкциза = СтавкаАкциза;			
		КонецЕсли;
		
		Цена = 0;
		Если ЗаполнятьЦену И (ЗначениеЗаполнено(ТипЦен) ИЛИ ЗначениеЗаполнено(СпособЗаполненияЦены)) Тогда
			
			НайденнаяСтрока	= ТаблицаЦен.Найти(Номенклатура, "Номенклатура");
			Если НайденнаяСтрока <> Неопределено Тогда
				
				Если НЕ ЗначениеЗаполнено(ТипЦен) И ЗначениеЗаполнено(СпособЗаполненияЦены) Тогда
					// используются данные регистра сведений ЦеныНоменклатурыДокументов,
					// в ТаблицаЦен есть колонка ЦенаВключаетНДС
					ЦенаВключаетНДС = НайденнаяСтрока.ЦенаВключаетНДС;
				КонецЕсли;
				
				Цена = ОбщегоНазначенияБККлиентСервер.ПересчитатьИзВалютыВВалюту(
					НайденнаяСтрока.Цена,
					НайденнаяСтрока.Валюта, ВалютаДокумента,
					НайденнаяСтрока.Курс, КурсДокумента,
					НайденнаяСтрока.Кратность, КратностьДокумента);

				Цена = ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(Цена, 
																Перечисления.СпособыЗаполненияЦен.ПоЦенамНоменклатуры, 
																ЦенаВключаетНДС,
																ПараметрыОбъекта.Свойство("УчитыватьНДС") 
																И ПараметрыОбъекта.УчитыватьНДС, 
																ПараметрыОбъекта.Свойство("СуммаВключаетНДС") 
																И СуммаВключаетНДС, 
																?(ЗначениеЗаполнено(СведенияОНоменклатуре.СтавкаНДС),
																УчетНДСиАкцизаВызовСервераПовтИсп.ПолучитьСтавкуНДС(СведенияОНоменклатуре.СтавкаНДС),0));
					
			КонецЕсли;
			
		КонецЕсли;
		СведенияОНоменклатуре.Вставить("Цена", Цена);
		СведенияОНоменклатуре.Вставить("ЦенаВключаетНДС", ЦенаВключаетНДС);
		
		ПлановаяСтоимость = 0;
		Если ЗначениеЗаполнено(ТипЦенПлановойСебестоимости) Тогда
			
			НайденнаяСтрока = ТаблицаЦенПлановойСебестоимости.Найти(Номенклатура, "Номенклатура");
			Если НайденнаяСтрока <> Неопределено Тогда
				
				ПлановаяСтоимость = ОбщегоНазначенияБККлиентСервер.ПересчитатьИзВалютыВВалюту(
					НайденнаяСтрока.Цена,
					НайденнаяСтрока.Валюта, ВалютаРегламентированногоУчета,
					НайденнаяСтрока.Курс, 1,
					НайденнаяСтрока.Кратность, 1);
			КонецЕсли;
			
		КонецЕсли;
		СведенияОНоменклатуре.Вставить("ПлановаяСтоимость", ПлановаяСтоимость);
			
		Если ЗаполнятьСпецификацию Тогда
			СпецификацияНоменклатуры = Справочники.СпецификацииНоменклатуры.ПустаяСсылка();
			НайденнаяСтрока	= ТаблицаСпецификаций.Найти(Номенклатура, "Номенклатура");
			Если НайденнаяСтрока <> Неопределено Тогда
				СпецификацияНоменклатуры = НайденнаяСтрока.СпецификацияНоменклатуры;
			КонецЕсли;      			
			СведенияОНоменклатуре.Вставить("Спецификация", СпецификацияНоменклатуры);
		КонецЕсли; 		
	КонецЦикла;
	
	Возврат СоответствиеСведенийОНоменклатуре;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


#Область КопированиеВставкаСтрокЧерезБуферОбмена

// Определяет наличие свойств в таблице значений для переноса в табличную часть
//
// Параметры:
//  Данные  - ТаблицаЗначений - таблица из буфера обмена
//
//  СписокСвойств  - Массив - массив свойств вида строка для переноса в табличную часть
//
// Возвращаемое значение:
//   Строка   - список свойств через запятую, которые были обнаружены в таблице из буфера
//
Функция ПолучитьСписокСвойствИмеющихсяВТаблицеДанных(Данные, СписокСвойств) Экспорт
	
	Колонки = Данные.Колонки;
	СвойстваКЗаполнению = Новый Массив;
	Для Каждого Свойство Из СписокСвойств Цикл
		
		Если Колонки.Найти(СокрЛП(Свойство)) = Неопределено Тогда
			
			Продолжить;
			
		КонецЕсли;
		СвойстваКЗаполнению.Добавить(Свойство);
			
	КонецЦикла;
	
	Возврат СтрСоединить(СвойстваКЗаполнению, ", ");
	
КонецФункции

// Подготавливает параметры для обработки вставки данных из буфера обмена
//
// Параметры:
//  Ссылка  - ДокументСсылка - ссылка на документ, в котором будет произведена вставка данных
//
//  ИмяТаблицы  - Строка - имя табличной части, куда будет произведена вставка данных из буфера обмена
//
// Возвращаемое значение:
//   Структура   - структура параметров для обработки вставки данных из буфера обмена
//
Функция ПолучитьПараметрыВставкиДанныхИзБуфераОбмена(Ссылка, ИмяТаблицы) Экспорт
	
	ПараметрыВставки = Новый Структура;
	ПараметрыВставки.Вставить("ЭтоВставкаИзБуфера",		 Истина);
	ДанныеИзБуфераОбмена = ОбщегоНазначения.СтрокиИзБуфераОбмена();
	ПараметрыВставки.Вставить("Источник",				 ДанныеИзБуфераОбмена.Источник);
	ПараметрыВставки.Вставить("Данные",					 ДанныеИзБуфераОбмена.Данные);
	ПараметрыВставки.Вставить("ИмяТаблицы",				 ИмяТаблицы);
	
	ПараметрыВставки.Вставить("ПоказыватьСчетаУчетаВДокументах", Истина);
		
	ПараметрыВставки.Вставить("ИсточникИДокументОдногоВида",
		Ссылка.Метаданные().Имя = ДанныеИзБуфераОбмена.Источник);
		
	ПараметрыВставки.Вставить("КоличествоДобавленныхСтрок",		 0);
	ПараметрыВставки.Вставить("СписокСвойств",					 "");
		
	Возврат ПараметрыВставки;
	
КонецФункции

#КонецОбласти




