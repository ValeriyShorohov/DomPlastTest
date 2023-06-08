#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
	
////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// ДА-2 (Инвентарная карточка учета ДА)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПечатьДА2";
	КомандаПечати.Представление = НСтр("ru = 'ДА-2 (Инвентарная карточка учета ДА)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = НЕ ПользователиБКВызовСервераПовтИсп.РазрешитьПечатьНепроведенныхДокументов();
	КомандаПечати.Порядок = 50;
	
	// Настраиваемый комплект документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПечатьДА2";
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
	
	// Печать расходной накладной
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьДА2") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПечатьДА2",
			НСтр("ru = 'ДА-2 (Инвентарная карточка учета ДА)'"),
			ПечатьДА2(МассивОбъектов, ОбъектыПечати),
			,
			"ОбщийМакет.ПФ_MXL_ДА2");
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Подготовка табличных печатных документов.

Функция ПечатьДА2(МассивОбъектов, ОбъектыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДатаСведений = ОбщегоНазначения.ТекущаяДатаПользователя();
	
	ЗапросНМА = Новый Запрос;
	ЗапросНМА.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	ЗапросНМА.УстановитьПараметр("ДатаСведений",   ДатаСведений);
	ЗапросНМА.УстановитьПараметр("ТекстПередачаНМА", Нстр("ru = 'передача НМА'"));
	ЗапросНМА.УстановитьПараметр("ТекстСписаниеНМА", Нстр("ru = 'списание НМА'"));
	
	ЗапросНМА.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НематериальныеАктивы.Ссылка КАК НематериальныйАктив,
		|	НематериальныеАктивы.НаименованиеПолное,
		|	НематериальныеАктивы.Код КАК ИнвентарныйНомер
		|ПОМЕСТИТЬ ВТ_СписокНМА
		|ИЗ
		|	Справочник.НематериальныеАктивы КАК НематериальныеАктивы
		|ГДЕ
		|	НематериальныеАктивы.Ссылка В(&МассивОбъектов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВТ_СписокНМА.НематериальныйАктив,
		|	ВЫБОР
		|		КОГДА ПервоначальныеСведенияНМАБухгалтерскийУчет.НематериальныйАктив ЕСТЬ NULL
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ОтсутствуютПервоначальныеСведения,
		|	ПервоначальныеСведенияНМАБухгалтерскийУчет.ПервоначальнаяСтоимость,
		|	ПервоначальныеСведенияНМАБухгалтерскийУчет.СрокПолезногоИспользования,
		|	ПервоначальныеСведенияНМАБухгалтерскийУчет.Организация,
		|	ПервоначальныеСведенияНМАБухгалтерскийУчет.Организация.Представление КАК ОрганизацияПредставление,
		|	ВЫРАЗИТЬ(ПервоначальныеСведенияНМАБухгалтерскийУчет.Организация.НаименованиеПолное КАК СТРОКА(1000)) КАК ОрганизацияПолноеНаименование,
		|	ПервоначальныеСведенияНМАБухгалтерскийУчет.Организация.ИдентификационныйНомер КАК ОрганизацияБИН
		|	
		|ПОМЕСТИТЬ ВТ_ПервоначальныеСведения
		|ИЗ
		|	ВТ_СписокНМА КАК ВТ_СписокНМА
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМАБухгалтерскийУчет.СрезПоследних(&ДатаСведений, ) КАК ПервоначальныеСведенияНМАБухгалтерскийУчет
		|		ПО ВТ_СписокНМА.НематериальныйАктив = ПервоначальныеСведенияНМАБухгалтерскийУчет.НематериальныйАктив
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВТ_ПервоначальныеСведения.НематериальныйАктив,
		|	ВТ_ПервоначальныеСведения.Организация,
		|	СостоянияНМАОрганизаций.Период,
		|	СостоянияНМАОрганизаций.Регистратор,
		|	СостоянияНМАОрганизаций.Состояние
		|ПОМЕСТИТЬ ВТ_СостоянияНМА
		|ИЗ
		|	ВТ_ПервоначальныеСведения КАК ВТ_ПервоначальныеСведения
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияНМАОрганизаций КАК СостоянияНМАОрганизаций
		|		ПО ВТ_ПервоначальныеСведения.НематериальныйАктив = СостоянияНМАОрганизаций.НематериальныйАктив
		|			И ВТ_ПервоначальныеСведения.Организация = СостоянияНМАОрганизаций.Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВТ_СписокНМА.НематериальныйАктив,
		|	ВТ_СписокНМА.НаименованиеПолное,
		|	ВЫРАЗИТЬ(ВТ_СписокНМА.НаименованиеПолное КАК СТРОКА(100)) КАК НаименованиеАктива,
		|	ВТ_СписокНМА.ИнвентарныйНомер,
		|	ВТ_ПервоначальныеСведения.ОтсутствуютПервоначальныеСведения,
		|	ВТ_ПервоначальныеСведения.Организация,
		|	ВТ_ПервоначальныеСведения.ОрганизацияПредставление,
		|	ВТ_ПервоначальныеСведения.ОрганизацияПолноеНаименование,
		|	ВТ_ПервоначальныеСведения.ОрганизацияБИН,
		|	ВТ_ПервоначальныеСведения.ПервоначальнаяСтоимость,
		|	ВТ_ПервоначальныеСведения.СрокПолезногоИспользования,
		|	СостоянияНМАПоступил.Период КАК ПериодПоступил,
		|	СостоянияНМАПоступил.Регистратор КАК РегистраторПоступил,
		|	СостоянияНМАПоступил.Регистратор.Номер КАК РегистраторПоступилНомер,
		|	СостоянияНМАПринятКУчету.Период КАК ПериодПринятКУчету,
		|	СостоянияНМАПринятКУчету.Регистратор КАК РегистраторПринятКУчету,
		|	СостоянияНМАПринятКУчету.Регистратор.Номер КАК РегистраторПринятКУчетуНомер,
		|	СостоянияНМАСписан.Период КАК ПериодСписан,
		|	СостоянияНМАСписан.Регистратор КАК РегистраторСписан,
		|	СостоянияНМАСписан.Регистратор.Номер КАК РегистраторСписанНомер,
		|	ВЫБОР
		|		КОГДА СостоянияНМАСписан.Регистратор ССЫЛКА Документ.ПередачаНМА
		|			ТОГДА &ТекстПередачаНМА
		|		КОГДА СостоянияНМАСписан.Регистратор ССЫЛКА Документ.СписаниеНМА
		|			ТОГДА &ТекстСписаниеНМА
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК ПричинаВыбытия,
		|	ВЫБОР
		|		КОГДА СостоянияНМАСписан.Регистратор ССЫЛКА Документ.ПередачаНМА
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ПередачаНМА,
		|	ПередачаНМА.Сумма,
		|	ПередачаНМА.СуммаВключаетНДС,
		|	ПередачаНМА.СуммаНДС,
		|	ПередачаНМА.Дата КАК ДатаПередачаНМА,
		|	ПередачаНМА.ВалютаДокумента
		|ИЗ
		|	ВТ_СписокНМА КАК ВТ_СписокНМА
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПервоначальныеСведения КАК ВТ_ПервоначальныеСведения
		|		ПО ВТ_СписокНМА.НематериальныйАктив = ВТ_ПервоначальныеСведения.НематериальныйАктив
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СостоянияНМА КАК СостоянияНМАПоступил
		|		ПО ВТ_СписокНМА.НематериальныйАктив = СостоянияНМАПоступил.НематериальныйАктив
		|			И (СостоянияНМАПоступил.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.Поступил))
		|	
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СостоянияНМА КАК СостоянияНМАПринятКУчету
		|		ПО ВТ_СписокНМА.НематериальныйАктив = СостоянияНМАПринятКУчету.НематериальныйАктив
		|			И (СостоянияНМАПринятКУчету.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПринятКУчету))
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СостоянияНМА КАК СостоянияНМАСписан
		|		ПО ВТ_СписокНМА.НематериальныйАктив = СостоянияНМАСписан.НематериальныйАктив
		|			И (СостоянияНМАСписан.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.Списан))
		|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПередачаНМА КАК ПередачаНМА
		|			ПО СостоянияНМАСписан.НематериальныйАктив = ПередачаНМА.НематериальныйАктив
		|				И СостоянияНМАСписан.Регистратор = ПередачаНМА.Ссылка
		|	
		|УПОРЯДОЧИТЬ ПО
		|	ВТ_СписокНМА.НематериальныйАктив		
		|";
		
	ВыборкаНМА = ЗапросНМА.Выполнить().Выбрать();
	
	ВалютаРегламентированногоУчета 	= ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ТабДок 												  = Новый ТабличныйДокумент();
	ТабДок.КлючПараметровПечати 						  = "НематериальныеАктивы_ДА2";
	
	Макет		   										  = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_ДА2");
	ЛицеваяСторона 										  = Макет.ПолучитьОбласть("ЛицеваяСторона");
	
	СведенияОДостройкеИРемонтеШапка           			  = Макет.ПолучитьОбласть("СведенияОДостройкеИРемонтеШапка");
	СведенияОДостройкеИРемонтеШапка.Параметры.Валюта 	  = ВалютаРегламентированногоУчета;
	СведенияОДостройкеИРемонтеСтрока         			  = Макет.ПолучитьОбласть("СведенияОДостройкеИРемонтеСтрока");
	СведенияОПереоценкиИПеремещенииШапка      			  = Макет.ПолучитьОбласть("СведенияОПереоценкиИПеремещенииШапка");
	СведенияОПереоценкиИПеремещенииШапка.Параметры.Валюта = ВалютаРегламентированногоУчета;	
	СведенияОПереоценкиИПеремещенииСтрока     			  = Макет.ПолучитьОбласть("СведенияОПереоценкиИПеремещенииСтрока");
	КраткаяИндивидуальнаяХарактеристикаАктива 			  = Макет.ПолучитьОбласть("КраткаяИндивидуальнаяХарактеристикаАктива");
	
	Пока ВыборкаНМА.Следующий() Цикл
		
		Если ТабДок.ВысотаТаблицы > 0 Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		ЛицеваяСторона.Параметры.ПредставлениеОрганизации = ?(ЗначениеЗаполнено(СокрЛП(ВыборкаНМА.ОрганизацияПолноеНаименование)), СокрЛП(ВыборкаНМА.ОрганизацияПолноеНаименование), ВыборкаНМА.ОрганизацияПредставление);
		ЛицеваяСторона.Параметры.ОрганизацияРНН_БИН       = ВыборкаНМА.ОрганизацияБИН; 
		ЛицеваяСторона.Параметры.ДатаДокумента            = Формат(ДатаСведений, "ДФ=dd.MM.yyyy");
		ЛицеваяСторона.Параметры.Валюта                   = ВалютаРегламентированногоУчета;
	
		Если ВыборкаНМА.ОтсутствуютПервоначальныеСведения Тогда
			ТекстСообщения = НСтр("ru = 'На момент формирования отчета нематериальный актив ""%1"" не принимался к учету.
			|Карточка объекта не сформирована.'");
			ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ВыборкаНМА.НаименованиеПолное));
			Продолжить;
		КонецЕсли;	
	
		ЗаполнитьЗначенияСвойств(ЛицеваяСторона.Параметры, ВыборкаНМА);
		
		Если ЗначениеЗаполнено(ВыборкаНМА.РегистраторПоступил) Тогда
			
			РегистраторПоступилНомер = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаНМА.РегистраторПоступилНомер, ВыборкаНМА.РегистраторПоступил);
			ЛицеваяСторона.Параметры.ДокументПриобритенияНаименование = ТипЗнч(ВыборкаНМА.РегистраторПоступил);
			ЛицеваяСторона.Параметры.ДокументПриобритенияНомер        = РегистраторПоступилНомер;
			ЛицеваяСторона.Параметры.ДокументПриобритенияДата         = Формат(ВыборкаНМА.ПериодПоступил, "ДФ=dd.MM.yyyy");
			
		КонецЕсли;
		
		СуммаНачисленнойАмортизации = "";
		БалансоваяСтоимость = "";
		
		СтоимостьАмортизацияНМА = УправлениеВнеоборотнымиАктивамиСервер.ОпределитьСтоимостьПоСпискуНМА(ВыборкаНМА.Организация, Неопределено, ВыборкаНМА.НематериальныйАктив, ДатаСведений);
		
		Если СтоимостьАмортизацияНМА.Количество() > 0 Тогда
			СуммаНачисленнойАмортизации = СтоимостьАмортизацияНМА[0].АмортизацияБУ;
			БалансоваяСтоимость = СтоимостьАмортизацияНМА[0].СтоимостьБУ - СтоимостьАмортизацияНМА[0].АмортизацияБУ;
		КонецЕсли;
		
		ЛицеваяСторона.Параметры.СуммаНачисленнойАмортизации = СуммаНачисленнойАмортизации;
		ЛицеваяСторона.Параметры.БалансоваяСтоимость = БалансоваяСтоимость;
			
		Если ЗначениеЗаполнено(ВыборкаНМА.РегистраторПринятКУчету) Тогда
			
			РегистраторПринятКУчетуНомер = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаНМА.РегистраторПринятКУчетуНомер, ВыборкаНМА.РегистраторПринятКУчету);
			
			ЛицеваяСторона.Параметры.ДокументВводаДатаНомер = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("№ %1 от %2", РегистраторПринятКУчетуНомер, Формат(ВыборкаНМА.ПериодПринятКУчету, "ДФ=dd.MM.yyyy"));

		КонецЕсли;
		
		Если ЗначениеЗаполнено(ВыборкаНМА.РегистраторСписан) Тогда
			
			РегистраторСписанНомер = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаНМА.РегистраторСписанНомер, ВыборкаНМА.РегистраторСписан);
		
			ЛицеваяСторона.Параметры.ДокументВыбытияДатаНомер = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("№ %1 от %2", РегистраторСписанНомер, Формат(ВыборкаНМА.ПериодСписан, "ДФ=dd.MM.yyyy"));
			ЛицеваяСторона.Параметры.ПричинаВыбытия = ВыборкаНМА.ПричинаВыбытия;
			
			Если ВыборкаНМА.ПередачаНМА Тогда
				
				Если ВыборкаНМА.СуммаВключаетНДС Тогда
					СуммаРеализации = ВыборкаНМА.Сумма - ВыборкаНМА.СуммаНДС;	
				Иначе
					СуммаРеализации = ВыборкаНМА.Сумма; 	
				КонецЕсли;
				
				Если ВыборкаНМА.ВалютаДокумента <> ВалютаРегламентированногоУчета Тогда
					
					ВалютаДокументаКурсКратность = ОбщегоНазначенияБК.ПолучитьКурсВалюты(ВыборкаНМА.ВалютаДокумента, ВыборкаНМА.ДатаПередачаНМА);
					ВалютаРегУчетаКурсКратность  = ОбщегоНазначенияБК.ПолучитьКурсВалюты(ВалютаРегламентированногоУчета, ВыборкаНМА.ДатаПередачаНМА);
					
					СуммаРеализации = ОбщегоНазначенияБККлиентСервер.ПересчитатьИзВалютыВВалюту(
										СуммаРеализации, 
										ВыборкаНМА.ВалютаДокумента, 
										ВалютаРегламентированногоУчета, 
										ВалютаДокументаКурсКратность.Курс, 
										ВалютаРегУчетаКурсКратность.Курс, 
										ВалютаДокументаКурсКратность.Кратность, 
										ВалютаРегУчетаКурсКратность.Кратность);
					
				КонецЕсли;
				
				ЛицеваяСторона.Параметры.СуммаДоходаУбыткаОтРеализации = СуммаРеализации;	
				
			КонецЕсли;
			
		КонецЕсли; 
		
		ТабДок.Вывести(ЛицеваяСторона);
		
		ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		
		ТабДок.Вывести(СведенияОДостройкеИРемонтеШапка);
		ТабДок.Вывести(СведенияОДостройкеИРемонтеСтрока);
		ТабДок.Вывести(СведенияОПереоценкиИПеремещенииШапка);
		ТабДок.Вывести(СведенияОПереоценкиИПеремещенииСтрока);
		ТабДок.Вывести(КраткаяИндивидуальнаяХарактеристикаАктива);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, ВыборкаНМА.НематериальныйАктив);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции // ПечатьДА2

#Область ОбработчикиОбновления

Процедура ВключитьИспользованиеДополнительныхРеквизитовИСведений() Экспорт

	НаборДополнительныхРеквизитовИСведенийСсылка = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.НаборыДополнительныхРеквизитовИСведений.Справочник_НематериальныеАктивы");
	Если НаборДополнительныхРеквизитовИСведенийСсылка <> Неопределено Тогда
	
		НаборДополнительныхРеквизитовИСведенийОбъект = НаборДополнительныхРеквизитовИСведенийСсылка.ПолучитьОбъект();
		НаборДополнительныхРеквизитовИСведенийОбъект.Используется = Истина;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НаборДополнительныхРеквизитовИСведенийОбъект);
	
	КонецЕсли; 

КонецПроцедуры

#КонецОбласти

#КонецЕсли

