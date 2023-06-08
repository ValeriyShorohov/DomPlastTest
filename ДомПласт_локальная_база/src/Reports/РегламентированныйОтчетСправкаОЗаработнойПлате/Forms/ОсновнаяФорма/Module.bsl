
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
	Если Параметры.Свойство("мСписокСтруктурныхЕдиниц")
		И ТипЗнч(Параметры.мСписокСтруктурныхЕдиниц) = Тип("СписокЗначений") Тогда
		мСписокСтруктурныхЕдиниц.ЗагрузитьЗначения(Параметры.мСписокСтруктурныхЕдиниц.ВыгрузитьЗначения());
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.мВыбраннаяФорма) Тогда
		мПараметрыПрежнейФормы = Новый Структура("мВыбраннаяФорма, мСохраненныйДок, Организация, мДатаНачалаПериодаОтчета, мДатаКонцаПериодаОтчета",
												Параметры.мВыбраннаяФорма, Параметры.мСохраненныйДок, Параметры.Организация, Параметры.мДатаНачалаПериодаОтчета, Параметры.мДатаКонцаПериодаОтчета);
	КонецЕсли;	

	ИсточникОтчета = СтрЗаменить(СтрЗаменить(Строка(ЭтаФорма.ИмяФормы), "Отчет.", ""), ".Форма.ОсновнаяФорма", "");
	
	ТаблицаФормОтчета = РеквизитФормыВЗначение("ОтчетОбъект").ТаблицаФормОтчета();
	
	ЗначениеВДанныеФормы(ТаблицаФормОтчета, мТаблицаФормОтчета);
	
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Месяц,   "Ежемесячно");
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Квартал, "Ежеквартально");
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Год, "Ежегодно");
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить("ПроизвольныйПериод", "Произвольный период");
		   		
	УчетПоВсемОрганизациям 	= РегламентированнаяОтчетностьПереопределяемый.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;

	ОрганизацияПоУмолчанию = РегламентированнаяОтчетностьПереопределяемый.ПолучитьОрганизациюПоУмолчанию();
	
	// Устанавливаем границы периода построения отчета как квартал
	// предшествующий текущему, нарастающим итогом с начала года.
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) И НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		мДатаКонцаПериодаОтчета  = НачалоГода(ТекущаяДатаСеанса()) - 1;
		мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(мПериодичность) Тогда
		мПериодичность = Перечисления.Периодичность.Год;
	КонецЕсли;

	ПолеВыбораПериодичность = мПериодичность;
	
	ПоказатьПериод(ЭтаФорма); 	
	
	Если НЕ ЗначениеЗаполнено(Организация) 
	   И ЗначениеЗаполнено(ОрганизацияПоУмолчанию) Тогда
		Организация = ОрганизацияПоУмолчанию;
		
		Если не ЗначениеЗаполнено(мСписокСтруктурныхЕдиниц) Тогда
			мСписокСтруктурныхЕдиниц = Новый СписокЗначений;
			мСписокСтруктурныхЕдиниц.Добавить(ОрганизацияПоУмолчанию);
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
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", мДатаНачалаПериодаОтчета, мДатаКонцаПериодаОтчета);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.КнопкаВыбораПериода,,,, ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	
	Если мСкопированаФорма <> Неопределено Тогда
		// Документ был скопиран. 
		// Проверяем соответствие форм.
		Если мВыбраннаяФорма <> мСкопированаФорма Тогда
			ПоказатьПредупреждение(,(НСтр("ru='Форма отчета изменилась, копирование невозможно!'")));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда						
		ОбщегоНазначенияКлиент.СообщитьПользователю(РегламентированнаяОтчетностьКлиент.ОсновнаяФормаОрганизацияНеЗаполненаВывестиТекст());				
		Возврат;		
	КонецЕсли;
	
	Если (мДатаКонцаПериодаОтчета < мДатаНачалаПериодаОтчета) ИЛИ (НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета)) ИЛИ (НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета)) Тогда
		ТекстСообщения = НСтр("ru='Неверно задан период.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);				
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(мВыбраннаяФорма) Тогда				
		ТекстСообщения = НСтр("ru='Форма отчета для указанного периода не определена.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);				
		Возврат;		
	КонецЕсли;

	// Основная форма была открыта из формы периода.
	Если мПараметрыПрежнейФормы <> Неопределено Тогда
		
		ТекстИзменений = НСтр("ru = 'Изменены параметры формирования отчета:'");
		ЕстьИзменения = Ложь;
		НеобходимоСохранитьФорму = Ложь;
		НеобходимоОчиститьФорму = Ложь;
		Если мПараметрыПрежнейФормы.Организация <> Организация Тогда
			ТекстИзменений = ТекстИзменений + НСТР("ru = 'организация отчета'");
			ЕстьИзменения = Истина;
			НеобходимоОчиститьФорму = Истина;
		КонецЕсли;	
				
		Если мПараметрыПрежнейФормы.мДатаНачалаПериодаОтчета <> мДатаНачалаПериодаОтчета ИЛИ мПараметрыПрежнейФормы.мДатаКонцаПериодаОтчета <> мДатаКонцаПериодаОтчета Тогда
			ТекстИзменений = ТекстИзменений + ?(ЕстьИзменения, НСТР("ru=' и '"), "") + НСТР("ru = 'отчетный период'");
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
			
			ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ВопросОНеобходимостиЗакрытияПредыдущейФормы",
			ЭтотОбъект);
			ПоказатьВопрос(ОбработчикОповещенияОЗакрытии, ТекстВопроса, РежимДиалогаВопрос.ДаНет);		
			Возврат; // дальнейшие действия будут выполнены в обработке оповещения
			
		КонецЕсли;	
		
		Если ЕстьИзменения И НеобходимоОчиститьФорму Тогда
			// форма открыта из формы отчета. При изменении формы периода требуется открыть новую форму
			ТекстВопроса = ТекстИзменений + НСТР("ru = '. Данные в форме будут очищены! Продолжить?'");
			
			ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ВопросОНеобходимостиОчисткиПредыдущейФормы", ЭтотОбъект);
			ПоказатьВопрос(ОбработчикОповещенияОЗакрытии, ТекстВопроса, РежимДиалогаВопрос.ДаНет);		
			Возврат; // дальнейшие действия будут выполнены в обработке оповещения
			
		КонецЕсли;	
	КонецЕсли;	
	            	
	ОткрытьВыбраннуюФорму();
	
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

	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Закрыть();
	КонецЕсли;
	
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
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось очистить отчет.'"));
	КонецПопытки;
	
	ОткрытьВыбраннуюФорму(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВыбраннуюФорму(ОбновитьПараметрыОткрытойФормы = Ложь)

	мСписокСтруктурныхЕдиниц.Очистить();
	мСписокСтруктурныхЕдиниц.Добавить(Организация);
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыФормы.Вставить("мСохраненныйДок",          мСохраненныйДок);
	ПараметрыФормы.Вставить("мСкопированаФорма",        мСкопированаФорма);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("мПериодичность",           мПериодичность);
	ПараметрыФормы.Вставить("Организация",        	    Организация);	
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	ПараметрыФормы.Вставить("мСписокСтруктурныхЕдиниц", мСписокСтруктурныхЕдиниц);	
		
	Если ОбновитьПараметрыОткрытойФормы И ВладелецФормы <> Неопределено Тогда
		// при повторном открытии не выполняется создание формы на сервере
		// необходимо самостоятельно обновить параметры формы и зависимые данные
		ВладелецФормы.ОбновитьПараметрыФормыНаКлиенте(ПараметрыФормы);
	КонецЕсли;	
	
	Попытка
		Если ВладелецФормы  = Неопределено Тогда
			ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы);
		Иначе
			ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы,, ВладелецФормы.КлючУникальности);
		КонецЕсли;			
		Закрыть(); // закрываем основную форму
	Исключение
		ТекстСообщения = НСтр("ru='Форма отчета для указанного периода не определена.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);		
	КонецПопытки;	
		  	
КонецПроцедуры

&НаКлиенте
Процедура мДатаНачалаПериодаОтчетаПриИзменении(Элемент)
	
	Если мДатаКонцаПериодаОтчета > '20200101' Тогда
		мВыбраннаяФорма = "ФормаОтчета2020Кв1";	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура мДатаКонцаПериодаОтчетаПриИзменении(Элемент)
	
	Если мДатаКонцаПериодаОтчета > '20200101' Тогда
		мВыбраннаяФорма = "ФормаОтчета2020Кв1";	
	КонецЕсли;
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
		Форма.ОписаниеНормативДок = "";
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Ложь;
	КонецЕсли;
	
	Если Форма.мПериодичность = "ПроизвольныйПериод" Тогда
		Форма.Элементы.ГруппаПроизвольныйПериод.Видимость = Истина;
		Форма.Элементы.ГруппаПериод.Видимость = Ложь;
		Форма.Элементы.ПериодС.Видимость      = Истина;
		Форма.Элементы.Период.Видимость       = Ложь;
	Иначе
		Форма.Элементы.ГруппаПроизвольныйПериод.Видимость = Ложь;
		Форма.Элементы.ГруппаПериод.Видимость = Истина;
		Форма.Элементы.ПериодС.Видимость      = Ложь;
		Форма.Элементы.Период .Видимость      = Истина;
	КонецЕсли;
	
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

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	мДатаНачалаПериодаОтчета = РезультатВыбора.НачалоПериода;
	мДатаКонцаПериодаОтчета  = РезультатВыбора.КонецПериода;	

	ПоказатьПериод(ЭтаФорма);
	
КонецПроцедуры

