////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация              = Параметры.Организация;
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	мПериодичность           = Параметры.мПериодичность;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	мСписокСтруктурныхЕдиниц = Параметры.мСписокСтруктурныхЕдиниц;
	
	мДатаНачалаСравнительногоПериодаОтчета = Параметры.мДатаНачалаСравнительногоПериодаОтчета;
	мДатаКонцаСравнительногоПериодаОтчета = Параметры.мДатаКонцаСравнительногоПериодаОтчета;
	
	Если ЗначениеЗаполнено(Параметры.мВыбраннаяФорма) Тогда
		мПараметрыПрежнейФормы = Новый Структура("мВыбраннаяФорма, мСохраненныйДок, Организация, мДатаНачалаПериодаОтчета, мДатаКонцаПериодаОтчета, мДатаНачалаСравнительногоПериодаОтчета, мДатаКонцаСравнительногоПериодаОтчета",
												Параметры.мВыбраннаяФорма, Параметры.мСохраненныйДок, Параметры.Организация, Параметры.мДатаНачалаПериодаОтчета, Параметры.мДатаКонцаПериодаОтчета, Параметры.мДатаНачалаСравнительногоПериодаОтчета, Параметры.мДатаКонцаСравнительногоПериодаОтчета);
	КонецЕсли;	
	
	ИсточникОтчета = СтрЗаменить(СтрЗаменить(Строка(ЭтаФорма.ИмяФормы), "Отчет.", ""), ".Форма.ОсновнаяФорма", "");
	
	ТаблицаФормОтчета = РеквизитФормыВЗначение("ОтчетОбъект").ТаблицаФормОтчета();
	
	ЗначениеВДанныеФормы(ТаблицаФормОтчета, мТаблицаФормОтчета);
	
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Месяц,   "Ежемесячно");
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Квартал, "Ежеквартально");
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Год, "Ежегодно");
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить("ПроизвольныйПериод", "Произвольный период");
    		
	УчетПоВсемОрганизациям = РегламентированнаяОтчетностьПереопределяемый.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;

	ОргПоУмолчанию       = РегламентированнаяОтчетностьПереопределяемый.ПолучитьОрганизациюПоУмолчанию();
				
	Если НЕ ЗначениеЗаполнено(мПериодичность) Тогда
		мПериодичность = Перечисления.Периодичность.Квартал;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВариантСравненияПериодов) Тогда
		ВариантСравненияПериодов = "ПредыдущийПериод";
	КонецЕсли;
	// Устанавливаем границы периода построения отчета как квартал
	// предшествующий текущему, нарастающим итогом с начала года.
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) И НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда		
		мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(КонецКвартала(ТекущаяДатаСеанса()), -3));
		мДатаНачалаПериодаОтчета = НачалоКвартала(ДобавитьМесяц(КонецКвартала(ТекущаяДатаСеанса()), -3));    
		
		УстановитьСравнительныйПериод(ЭтотОбъект);
	КонецЕсли;

	ПолеВыбораПериодичность = мПериодичность;
	
	ПоказатьПериод(ЭтаФорма);
	
	Если НЕ ЗначениеЗаполнено(Организация) 
	   И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
		
		Если не ЗначениеЗаполнено(мСписокСтруктурныхЕдиниц) Тогда
			мСписокСтруктурныхЕдиниц = Новый СписокЗначений;
			мСписокСтруктурныхЕдиниц.Добавить(ОргПоУмолчанию);
		КонецЕсли;	
	КонецЕсли;
	
	мПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	// здесь отключаем стандартную обработку ПередЗакрытием формы
	// для подавления выдачи запроса на сохранение формы.
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда						
		ОбщегоНазначенияКлиент.СообщитьПользователю(РегламентированнаяОтчетностьКлиент.ОсновнаяФормаОрганизацияНеЗаполненаВывестиТекст());				
		Возврат;		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(мВыбраннаяФорма) Тогда				
		ТекстСообщения = НСтр("ru='Форма отчета для указанного периода не определена.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);				
		Возврат;		
	КонецЕсли;
	
	Если  (мДатаНачалаПериодаОтчета > мДатаКонцаПериодаОтчета ИЛИ (НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета)) ИЛИ (НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета)))  Тогда 
		ТекстСообщения = НСтр("ru='Неверно задан период.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);		
		Возврат;
	КонецЕсли;
	
	Если (мДатаНачалаСравнительногоПериодаОтчета > мДатаКонцаСравнительногоПериодаОтчета ИЛИ (НЕ ЗначениеЗаполнено(мДатаНачалаСравнительногоПериодаОтчета)) ИЛИ (НЕ ЗначениеЗаполнено(мДатаКонцаСравнительногоПериодаОтчета)))  Тогда 
		ТекстСообщения = НСтр("ru='Неверно задан сравнительный период.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);		
		Возврат;
	КонецЕсли;


	Если мСкопированаФорма <> Неопределено Тогда
		// Документ был скопиран. 
		// Проверяем соответствие форм.
		Если мВыбраннаяФорма <> мСкопированаФорма Тогда
			
			ПоказатьПредупреждение(,(НСтр("ru='Форма отчета изменилась, копирование невозможно!'")));
			Возврат;
						
		КонецЕсли;
	КонецЕсли;
	
	// Основная форма была открыта из формы периода.
	Если мПараметрыПрежнейФормы <> Неопределено Тогда
		ТекстИзменений = НСТР("ru = 'Изменены параметры формирования отчета:'");
		ЕстьИзменения = Ложь;
		НеобходимоСохранитьФорму = Ложь;
		НеобходимоОчиститьФорму = Ложь;
		Если мПараметрыПрежнейФормы.Организация <> Организация Тогда
			ТекстИзменений = ТекстИзменений + НСТР("ru = ' организация отчета'");
			ЕстьИзменения = Истина;
			НеобходимоОчиститьФорму = Истина;
		КонецЕсли;	
		
		Если мПараметрыПрежнейФормы.мДатаНачалаПериодаОтчета <> мДатаНачалаПериодаОтчета ИЛИ мПараметрыПрежнейФормы.мДатаКонцаПериодаОтчета <> мДатаКонцаПериодаОтчета Тогда
			ТекстИзменений = ТекстИзменений + ?(ЕстьИзменения, НСТР("ru=' и'"), "") + НСТР("ru = ' отчетный период'");
			ЕстьИзменения = Истина;
			НеобходимоОчиститьФорму = Истина;
		КонецЕсли;	
		
		Если мПараметрыПрежнейФормы.мДатаНачалаСравнительногоПериодаОтчета <> мДатаНачалаСравнительногоПериодаОтчета ИЛИ мПараметрыПрежнейФормы.мДатаКонцаСравнительногоПериодаОтчета <> мДатаКонцаСравнительногоПериодаОтчета Тогда
			ТекстИзменений = ТекстИзменений + ?(ЕстьИзменения, НСТР("ru=' и'"), "") + НСТР("ru = ' сравнительный период'");
			ЕстьИзменения = Истина;
			НеобходимоОчиститьФорму = Истина;
		КонецЕсли;	
				
		Если мПараметрыПрежнейФормы.мВыбраннаяФорма <> мВыбраннаяФорма Тогда
			ЕстьИзменения = Истина;
			НеобходимоСохранитьФорму = Истина;
		КонецЕсли;
		
		Если ЕстьИзменения И НеобходимоСохранитьФорму Тогда			
			// форма открыта из формы отчета. При изменении формы периода требуется открыть новую форму
			ТекстВопроса = ТекстИзменений + НСТР("ru = '. Будет закрыта форма текущего отчета и открыта новая форма, соответствующая данному периоду. Продолжить?'");
			
			ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ВопросОНеобходимостиЗакрытияПредыдущейФормы",	ЭтотОбъект);
			ПоказатьВопрос(ОбработчикОповещенияОЗакрытии, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);		
			Возврат; // дальнейшие действия будут выполнены в обработке оповещения
			
		КонецЕсли;	
		
		Если ЕстьИзменения И НеобходимоОчиститьФорму Тогда
			// форма открыта из формы отчета. При изменении формы периода требуется открыть новую форму
			ТекстВопроса = ТекстИзменений + НСТР("ru = '. Данные в форме будут очищены! Продолжить?'");
			
			ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ВопросОНеобходимостиОчисткиПредыдущейФормы", ЭтотОбъект);
			ПоказатьВопрос(ОбработчикОповещенияОЗакрытии, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);		
			Возврат; // дальнейшие действия будут выполнены в обработке оповещения
			
		КонецЕсли;	
	КонецЕсли;	

	
	ОткрытьВыбраннуюФорму();	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", мДатаНачалаПериодаОтчета, мДатаКонцаПериодаОтчета);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект, Новый Структура("ТипПериода", "Отчетный период"));
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.КнопкаВыбораПериода, , , , ОписаниеОповещения);
	ПоказатьПериод(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСравнительныйПериод(Команда)
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", мДатаНачалаСравнительногоПериодаОтчета, мДатаКонцаСравнительногоПериодаОтчета);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект, Новый Структура("ТипПериода", "Сравнительный период"));
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.КнопкаВыбораПериода, , , , ОписаниеОповещения);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ПолеВыбораПериодичностьПриИзменении(Элемент)
Если ПолеВыбораПериодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда  // ежегодно
		мДатаКонцаПериодаОтчета  = КонецГода(мДатаКонцаПериодаОтчета);
		мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);
	ИначеЕсли ПолеВыбораПериодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда  // ежеквартально
		мДатаКонцаПериодаОтчета  = КонецКвартала(мДатаКонцаПериодаОтчета);
		мДатаНачалаПериодаОтчета = НачалоКвартала(мДатаКонцаПериодаОтчета);	
	Иначе
		мДатаКонцаПериодаОтчета  = КонецМесяца(мДатаКонцаПериодаОтчета);
		мДатаНачалаПериодаОтчета = НачалоМесяца(мДатаКонцаПериодаОтчета);
	КонецЕсли;

	мПериодичность = ПолеВыбораПериодичность;
	
	ПоказатьПериод(ЭтаФорма);
	УстановитьСравнительныйПериод(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	ИзменитьПериод(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	
	ИзменитьПериод(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	РаботаСДиалогамиКлиент.НачалоВыбораСпискаСтруктурныхЕдиниц(мСписокСтруктурныхЕдиниц,
											ЭтотОбъект, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСпискаСтруктурныхЕдиниц(Результат, Параметры) Экспорт

	Если Результат <> Неопределено Тогда
		мСписокСтруктурныхЕдиниц = Результат;
		Если мСписокСтруктурныхЕдиниц.Количество() > 0 Тогда
			Организация = мСписокСтруктурныхЕдиниц[0].Значение;
		Иначе
			Организация = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");
		КонецЕсли;						
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВариантСравненияПериодовПриИзменении(Элемент)
	УстановитьСравнительныйПериод(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтчетаПриИзменении(Элемент)
	
	ПоказатьПериод(ЭтаФорма);
	УстановитьСравнительныйПериод(ЭтотОбъект);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура управляет показом в форме периода построения отчета.
//
&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма)

	Если  (Форма.мДатаКонцаПериодаОтчета < Форма.мДатаНачалаПериодаОтчета) Тогда
		Сообщить("Неверно задан период", СтатусСообщения.Важное);
		Возврат;
	КонецЕсли;

	СтрПериодОтчета = ПредставлениеПериода(НачалоДня(Форма.мДатаНачалаПериодаОтчета), КонецДня(Форма.мДатаКонцаПериодаОтчета), "ФП = Истина" );
		
	Форма.НадписьПериодСоставленияОтчета = СтрПериодОтчета;

	КоличествоФорм = РегламентированнаяОтчетностьКлиентСервер.КоличествоФормСоответствующихВыбранномуПериоду(Форма);
	Если КоличествоФорм >= 1 Тогда     	
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Истина;
	Иначе
		
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Ложь;
		Форма.ОписаниеНормативДок = "";		
	КонецЕсли;

	Форма.Элементы.ГруппаПроизвольныйПериод.Видимость = Форма.мПериодичность = "ПроизвольныйПериод";
	Форма.Элементы.ГруппаПериод.Видимость = НЕ Форма.Элементы.ГруппаПроизвольныйПериод.Видимость;

	РегламентированнаяОтчетностьКлиентСервер.ВыборФормыРегламентированногоОтчетаПоУмолчанию(Форма);

КонецПроцедуры

// Процедура устанавливает границы периода построения отчета.
//
// Параметры:
//  Шаг          - число, количество стандартных периодов, на которое необходимо
//                 сдвигать период построения отчета;
//
&НаКлиенте
Процедура ИзменитьПериод(Шаг)
	Если ПолеВыбораПериодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда  // ежегодно
		мДатаКонцаПериодаОтчета  = КонецГода(ДобавитьМесяц(мДатаКонцаПериодаОтчета, Шаг*12));
		мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);
	ИначеЕсли ПолеВыбораПериодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда  // ежеквартально
		мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(мДатаКонцаПериодаОтчета, Шаг*3));
		мДатаНачалаПериодаОтчета = НачалоКвартала(мДатаКонцаПериодаОтчета);
	Иначе
		мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(мДатаКонцаПериодаОтчета, Шаг)); 
		мДатаНачалаПериодаОтчета = НачалоМесяца(мДатаКонцаПериодаОтчета);
	КонецЕсли;

	ПоказатьПериод(ЭтаФорма);
	
	УстановитьСравнительныйПериод(ЭтотОбъект);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
// Процедура рассчитывает границы сравнительного периода финансовой отчетности
// Сравнительный период - сопоставимый прошлый отчетный период
Процедура УстановитьСравнительныйПериод(Форма)
	Если Форма.ВариантСравненияПериодов = "ПредыдущийПериод" Тогда // сравниваем с предыдущим периодом от текущего периода
		
		Если Форма.мПериодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда 		
			НачалоСравнительногоПериода     = НачалоМесяца(Форма.мДатаНачалаПериодаОтчета - 1);			
			КонецСравнительногоПериода  	= КонецМесяца(НачалоСравнительногоПериода); 
			
		ИначеЕсли Форма.мПериодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
			НачалоСравнительногоПериода     = НачалоКвартала(Форма.мДатаНачалаПериодаОтчета - 1);  		
			КонецСравнительногоПериода  	= КонецКвартала(НачалоСравнительногоПериода); 
			
		ИначеЕсли Форма.мПериодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
			НачалоСравнительногоПериода = НачалоГода(Форма.мДатаНачалаПериодаОтчета - 1);  
			КонецСравнительногоПериода  = КонецГода(НачалоСравнительногоПериода); 
			
		Иначе //если был выбран произвольный период
			 // ведем расчет от количества дней произвольного периода   			 
			 
			КонецСравнительногоПериода 	=  Форма.мДатаНачалаПериодаОтчета - 1;
			
			ДатаНач = НачалоДня(Форма.мДатаНачалаПериодаОтчета);
			ДатаКон = КонецДня(Форма.мДатаКонцаПериодаОтчета);
			
			КоличествоДней  = (ДатаКон - ДатаНач+1)/(60*60*24);			
			
			НачалоСравнительногоПериода = НачалоДня(КонецСравнительногоПериода - КоличествоДней*(60*60*24));  						
		КонецЕсли;
		
	Иначе // сравниваем с сопоставимым периодом предшествующего финансового года
		
		Если Форма.мПериодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда 		
			КонецСравнительногоПериода  = КонецМесяца(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, (-12))); 
			НачалоСравнительногоПериода = НачалоМесяца(КонецСравнительногоПериода);
		ИначеЕсли Форма.мПериодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
			КонецСравнительногоПериода  = КонецКвартала(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, (-12))); 
			НачалоСравнительногоПериода     = НачалоКвартала(КонецСравнительногоПериода);  		
		ИначеЕсли Форма.мПериодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
			КонецСравнительногоПериода  = КонецГода(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, (-12))); 
			НачалоСравнительногоПериода     = НачалоГода(КонецСравнительногоПериода);  
		Иначе //если был выбран произвольный период
			// найдем даты предыдущего периода для проивольного периода
			НачалоСравнительногоПериода  = ДобавитьМесяц(Форма.мДатаНачалаПериодаОтчета,-12);  		
			КонецСравнительногоПериода 	 = ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета,-12);  					
		КонецЕсли;
		
	КонецЕсли;
	    		
	Форма.мДатаНачалаСравнительногоПериодаОтчета = НачалоДня(НачалоСравнительногоПериода);
    Форма.мДатаКонцаСравнительногоПериодаОтчета = КонецДня(КонецСравнительногоПериода);
	
	Если  (Форма.мДатаКонцаСравнительногоПериодаОтчета < Форма.мДатаНачалаСравнительногоПериодаОтчета) Тогда
		Сообщить("Неверно задан сравнительный период", СтатусСообщения.Важное);
		Возврат;
	КонецЕсли;
	
	Форма.НадписьСравнительныйПериодСоставленияОтчета = ПредставлениеПериода(НачалоДня(Форма.мДатаНачалаСравнительногоПериодаОтчета), КонецДня(Форма.мДатаКонцаСравнительногоПериодаОтчета), "ФП = истина");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВыбраннуюФорму(ОбновитьПараметрыОткрытойФормы = Ложь)

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыФормы.Вставить("мСохраненныйДок",          мСохраненныйДок);
	ПараметрыФормы.Вставить("мСкопированаФорма",        мСкопированаФорма);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("мПериодичность",           мПериодичность);
	ПараметрыФормы.Вставить("Организация",              Организация);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	ПараметрыФормы.Вставить("мСписокСтруктурныхЕдиниц", мСписокСтруктурныхЕдиниц);	
	ПараметрыФормы.Вставить("мПериодичность",			мПериодичность);	
	ПараметрыФормы.Вставить("мДатаНачалаСравнительногоПериодаОтчета", мДатаНачалаСравнительногоПериодаОтчета);
	ПараметрыФормы.Вставить("мДатаКонцаСравнительногоПериодаОтчета", мДатаКонцаСравнительногоПериодаОтчета);
	
	Если ОбновитьПараметрыОткрытойФормы Тогда
		// при повторном открытии не выполняется создание формы на сервере
		// необходимо самостоятельно обновить параметры формы и зависимые данные
		ВладелецФормы.ОбновитьПараметрыФормыНаКлиенте(ПараметрыФормы);
	КонецЕсли;	
	
	Попытка
		Если ВладелецФормы  = Неопределено Тогда
			ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы);
		Иначе
			ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы,,ВладелецФормы.КлючУникальности);
		КонецЕсли;		
		Закрыть(); // закрываем основную форму
	Исключение
		ТекстСообщения = НСтр("ru='Форма отчета для указанного периода не определена.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОНеобходимостиЗакрытияПредыдущейФормы(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	Попытка
		ВладелецФормы.СохранитьДанные(); // экспортная процедура формы
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСТР("ru = 'Не удалось сохранить отчет.'"));
	КонецПопытки;

	ВладелецФормы.Закрыть();
	
	ОткрытьВыбраннуюФорму(); 
КонецПроцедуры

&НаКлиенте
Процедура ВопросОНеобходимостиОчисткиПредыдущейФормы(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		КодОсновнойФормыВладельца = ВладелецФормы.СписокФормДерева.ПолучитьЭлементы()[0].КодФормы;
		ВладелецФормы.Очистить(КодОсновнойФормыВладельца, Истина);
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСТР("ru = 'Не удалось очистить отчет.'"));
	КонецПопытки;
	
	ОткрытьВыбраннуюФорму(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если  ДопПараметры.ТипПериода = "Отчетный период" Тогда		
		мДатаНачалаПериодаОтчета 	= РезультатВыбора.НачалоПериода;
		мДатаКонцаПериодаОтчета 	= РезультатВыбора.КонецПериода;	
		
		УстановитьСравнительныйПериод(ЭтотОбъект);
	Иначе
		мДатаНачалаСравнительногоПериодаОтчета 	= РезультатВыбора.НачалоПериода;
		мДатаКонцаСравнительногоПериодаОтчета 	= РезультатВыбора.КонецПериода;	
	КонецЕсли;
КонецПроцедуры

