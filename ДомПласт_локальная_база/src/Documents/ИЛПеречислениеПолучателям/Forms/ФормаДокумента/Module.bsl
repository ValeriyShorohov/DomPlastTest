
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ПодготовитьФормуНаСервере();
		РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// РедактированиеДокументовПользователей
	ПраваДоступаКОбъектам.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец РедактированиеДокументовПользователей
	
	ПодготовитьФормуНаСервере();
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);	
	МесяцНачисленияСтрокой = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(Объект.ПериодРегистрации);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
		
	ОбщегоНазначенияБККлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "Документ ""ил перечисление получателям"" (проведение)";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	УстановитьИмяКнопки(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СтруктурноеПодразделениеОрганизация) Тогда 
		Объект.Организация = Неопределено;
		Объект.СтруктурноеПодразделение = Неопределено;
	Иначе 
		Результат = РаботаСДиалогамиКлиент.ПроверитьИзменениеЗначенийОрганизацииСтруктурногоПодразделения(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение);
		Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
			СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.СтруктурноеПодразделениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Объект.Организация, Объект.СтруктурноеПодразделение, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаПриИзменении(Элемент)
	
	РаботаСДиалогамиКлиент.ДатаКакМесяцПодобратьДатуПоТексту(МесяцНачисленияСтрокой, Объект.ПериодРегистрации);
	МесяцНачисленияСтрокой = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(Объект.ПериодРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Объект.ПериодРегистрации = ДобавитьМесяц(Объект.ПериодРегистрации, Направление);
	МесяцНачисленияСтрокой = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(Объект.ПериодРегистрации);
	Модифицированность = Истина;
	УстановитьИмяКнопки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если Текст = "" Тогда
		Ожидание = 0;
		РаботаСДиалогамиКлиент.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, Объект.ПериодРегистрации, ЭтаФорма, , Истина);
	Иначе
		РаботаСДиалогамиКлиент.ДатаКакМесяцАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.ДатаКакМесяцОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	УстановитьИмяКнопки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
		
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ИсполнительныеЛисты

&НаКлиенте
Процедура ИсполнительныеЛистыПолучательПриИзменении(Элемент)
	
	ДанныеСтрокиТаблицы = Новый Структура("Получатель, ДокументОснование, СуммаВзаиморасчетов, 
											|СуммаСборов, СуммаПлатежа, НомерВходящегоДокумента, ДатаВходящегоДокумента");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, Элементы.ИсполнительныеЛисты.ТекущиеДанные);
	
	ПараметрыОбъекта = Новый Структура("Организация, СтруктурноеПодразделение, Дата, Ссылка, СпособПеречисления, СуммаДокумента, ПериодРегистрации");
	ЗаполнитьЗначенияСвойств(ПараметрыОбъекта, Объект);
	
	ИсполнительныеЛистыПолучательПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ПараметрыОбъекта);
	
	ЗаполнитьЗначенияСвойств(Элементы.ИсполнительныеЛисты.ТекущиеДанные, ДанныеСтрокиТаблицы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительныеЛистыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	// рассчитываем общую сумму платежа по строке
	ТекущиеДанные = Элементы.ИсполнительныеЛисты.ТекущиеДанные;	
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные.СуммаПлатежа = ТекущиеДанные.СуммаВзаиморасчетов + ТекущиеДанные.СуммаСборов;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗаполнитьОстаткиНаДатуДокумента(Команда)
	
	Если Объект.ИсполнительныеЛисты.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru= 'Перед заполнением табличная часть будет очищена. Заполнить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередЗаполнениемНаДатуДокумента", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		
	Иначе
		
		АвтозаполнениеНаСервере("Остатки");
		Если Объект.ИсполнительныеЛисты.Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не обнаружены данные для записи в табличную часть документа'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, , "Объект");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстаткиНаКонецМесяца(Команда)
	
	Если Объект.ИсполнительныеЛисты.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru= 'Перед заполнением табличная часть будет очищена. Заполнить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередЗаполнениемНаКонецМесяца", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		
	Иначе
		
		АвтозаполнениеНаСервере("ОстаткиНаКонецМесяца");
		Если Объект.ИсполнительныеЛисты.Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не обнаружены данные для записи в табличную часть документа'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, , "Объект");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьОстаткиНаДатуДокумента(Команда)
	
	Если Модифицированность ИЛИ Параметры.Ключ.Пустая() Тогда
		
		ТекстВопроса = НСтр("ru= 'Перед расчетом необходимо записать документ. Продолжить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередРасчетомНаДатуДокумента", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		 				
	Иначе
		
		РассчитатьНаСервере("НаДатуДокумента");

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьОстаткиНаКонецМесяца(Команда)
	
	Если Модифицированность ИЛИ Параметры.Ключ.Пустая() Тогда
		
		ТекстВопроса = НСтр("ru= 'Перед расчетом необходимо записать документ. Продолжить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередРасчетомНаКонецМесяца", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		 				
	Иначе
		
		РассчитатьНаСервере("НаКонецМесяца");

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)

	ТекстВопроса = НСтр("ru= 'Табличная часть будет очищена. Продолжить?'");
	Режим = РежимДиалогаВопрос.ДаНет;
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОбОчисткеТабЧасти", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыВходящегоДокумента(Команда)
	
	ТекущийНомер = 0;
	ОповещениеЧисло = Новый ОписаниеОповещения("ПослеВводаНомераДокумента", ЭтотОбъект);
	ПоказатьВводЧисла(ОповещениеЧисло, ТекущийНомер, "Введите номер первого документа", 10, 0) 
	 
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБККлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(Объект,,,, Параметры.ЗначениеКопирования);
		КонецЕсли;
		
		Объект.Дата = КонецДня(Объект.Дата);
		
		Если НЕ ЗначениеЗаполнено(Объект.СпособПеречисления) Тогда
			Объект.СпособПеречисления = Перечисления.СпособыПеречисленияПоИсполнительномуЛисту.ЧерезПочту;
		КонецЕсли;
				
	Иначе
		
		ПроверитьДокументыВведенныеНаОсновании();
		
	КонецЕсли;

	УстановитьИмяКнопки(ЭтаФорма);
	// Заполним реквизит формы МесяцСтрока.
	МесяцНачисленияСтрокой = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(Объект.ПериодРегистрации);

	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация(Элементы.СтруктурноеПодразделениеОрганизация, Объект.СтруктурноеПодразделение, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	
	ОбщегоНазначенияБК.УстановитьТекстАвтора(НадписьАвтор, Объект.Автор);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьДокументыВведенныеНаОсновании()
	
	Если Не Параметры.Ключ.Пустая() Тогда
		Если ОбщегоНазначенияБК.СуществуютПроведенныеДокументыВведенныеНаОсновании(Объект.Ссылка) Тогда
			ЭтаФорма.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере(СтруктураПараметров = Неопределено)
	
	Если СтруктураПараметров = Неопределено 
		ИЛИ (СтруктураПараметров.Свойство("НеобходимоИзменитьЗначенияРеквизитовОбъекта") 
				И СтруктураПараметров.НеобходимоИзменитьЗначенияРеквизитовОбъекта) Тогда 
		РаботаСДиалогами.СтруктурноеПодразделениеПриИзменении(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктураПараметров);
	КонецЕсли;
	
	ПриИзмененииЗначенияОрганизацииСервер(СтруктураПараметров,Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделения(Результат, Параметры) Экспорт
	
	РаботаСДиалогамиКлиент.ПослеВыбораСтруктурногоПодразделения(Результат, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
		Модифицированность = Истина;
		ПриИзмененииЗначенияОрганизацииСервер(Результат,Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииЗначенияОрганизацииСервер(СтруктураПараметров,СтруктураРезультатаВыполнения)
	
	Если НЕ СтруктураПараметров.ИзмененаОрганизация И НЕ СтруктураПараметров.ИзмененоСтруктурноеПодразделение Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьФункциональныеОпцииФормы();
	
	СтруктураРезультатаВыполнения = Неопределено;
	
	РаботаСДиалогами.ПриИзмененииЗначенияОрганизации(Объект,,СтруктураРезультатаВыполнения);
	
КонецПроцедуры

&НаСервере
Процедура  ИсполнительныеЛистыПолучательПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ПараметрыОбъекта)
	
	// Если по получателю имеется единственный исполнительный лист, то подставляем его автоматически
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Получатель", ДанныеСтрокиТаблицы.Получатель);
	Запрос.УстановитьПараметр("ДатаАктуальности", КонецМесяца(ПараметрыОбъекта.ПериодРегистрации));
	Запрос.УстановитьПараметр("Организация", ПараметрыОбъекта.Организация);
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(ИсполнительныйЛист.Ссылка) КАК КоличествоДокументов,
	|	МАКСИМУМ(ИсполнительныйЛист.Ссылка) КАК ДокументОснование
	|ИЗ
	|	Документ.ИсполнительныйЛист КАК ИсполнительныйЛист
	|ГДЕ
	|	ИсполнительныйЛист.Получатель = &Получатель И
	|	ИсполнительныйЛист.Организация = &Организация И
	|	ИсполнительныйЛист.Проведен И
	|	ИсполнительныйЛист.ДатаДействия <= &ДатаАктуальности И
	|	ИсполнительныйЛист.ДатаОкончания >= &ДатаАктуальности
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Если Выборка.КоличествоДокументов = 1 Тогда
			ДанныеСтрокиТаблицы.ДокументОснование = Выборка.ДокументОснование;
		КонецЕсли;
	Иначе
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru ='По получателю %1 нет действующих исполнительных листов!'"), ДанныеСтрокиТаблицы.Получатель);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, , "Объект");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция  ПолучитьДатуДокумента()Экспорт 
	
	ДатаДок = ОбщегоНазначения.ТекущаяДатаПользователя();
	
	Возврат ДатаДок;
	
КонецФункции

&НаКлиенте
Процедура ПослеВводаНомераДокумента(Число, Параметры) Экспорт
	
	Если Число <> Неопределено Тогда
		ОповещениеДата = Новый ОписаниеОповещения("ПослеВводаДатыДокумента", ЭтотОбъект);
		ТекущийНомер = Число;
		ДатаДок = ПолучитьДатуДокумента();
		ПоказатьВводДаты(ОповещениеДата,ДатаДок, "Введите дату документов", ЧастиДаты.Дата);
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаДатыДокумента(Дата, Параметры) Экспорт
	
	Если Дата <> Неопределено Тогда
		ДатаДок = ПолучитьДатуДокумента();
		
		Для Каждого СтрокаТЧ Из Объект.ИсполнительныеЛисты Цикл
			СтрокаТЧ.НомерВходящегоДокумента 	= Формат(ТекущийНомер, "ЧГ=0");
			СтрокаТЧ.ДатаВходящегоДокумента 	= ДатаДок;
			ТекущийНомер = ТекущийНомер + 1;
		КонецЦикла;
	Иначе 
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОбОчисткеТабЧасти(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
	
	Объект.ИсполнительныеЛисты.Очистить();

КонецПроцедуры

&НаКлиенте  
Процедура ПослеЗакрытияВопросаПередЗаполнениемНаДатуДокумента(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
	
	Объект.ИсполнительныеЛисты.Очистить();
	
	АвтозаполнениеНаСервере("Остатки");
	
	Если Объект.ИсполнительныеЛисты.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не обнаружены данные для записи в табличную часть документа'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, , "Объект");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте  
Процедура ПослеЗакрытияВопросаПередЗаполнениемНаКонецМесяца(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
	
	Объект.ИсполнительныеЛисты.Очистить();
	
	АвтозаполнениеНаСервере("ОстаткиНаКонецМесяца");
	
	Если Объект.ИсполнительныеЛисты.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не обнаружены данные для записи в табличную часть документа'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, , "Объект");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте  
Процедура ПослеЗакрытияВопросаПередРасчетомНаДатуДокумента(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
		
	ЭтотОбъект.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Запись));

	РассчитатьНаСервере("НаДатуДокумента");
	
КонецПроцедуры

&НаКлиенте  
Процедура ПослеЗакрытияВопросаПередРасчетомНаКонецМесяца(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
		
	ЭтотОбъект.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Запись));

	РассчитатьНаСервере("НаКонецМесяца");
	
КонецПроцедуры

&НаСервере
Процедура АвтозаполнениеНаСервере(ВариантЗаполнения) 
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		КлючеваяОперация 	= "Документ ""ил перечисление получателям"" (заполнение" + ВариантЗаполнения + ")";
		ВремяНачалаЗамера 	= ОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;
	
	Документы.ИЛПеречислениеПолучателям.Автозаполнение(Объект, ВариантЗаполнения);

	ОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачалаЗамера);
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьНаСервере(ВариантРасчета)
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		КлючеваяОперация 	= "Документ ""ил перечисление получателям"" (расчет" + ВариантРасчета + ")";
		ВремяНачалаЗамера 	= ОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;
	
	Документы.ИЛПеречислениеПолучателям.Рассчитать(Объект, ВариантРасчета);

	ОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачалаЗамера);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьИмяКнопки(Форма)
	
	Объект		= Форма.Объект;
	Элементы	= Форма.Элементы;

	Элементы.ФормаЗаполнитьОстаткиНаДатуДокумента.Заголовок	 = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru ='По задолженности на %1'"),
																	Формат(Объект.Дата, "ДФ=дд.ММ.гггг"));
	Элементы.ФормаЗаполнитьОстаткиНаКонецМесяца.Заголовок 	 = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru ='По задолженности на конец %1'"),
																	Формат(Объект.ПериодРегистрации, "ДФ='ММММ гггг'"));
																	
   	Элементы.ФормаРассчитатьОстаткиНаДатуДокумента.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru ='По задолженности на %1'"),
																	Формат(Объект.ПериодРегистрации, "ДФ=дд.ММ.гггг"));
   	Элементы.ФормаРассчитатьОстаткиНаКонецМесяца.Заголовок   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru ='По задолженности на конец %1'"),
																	Формат(Объект.ПериодРегистрации, "ДФ='ММММ гггг'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеВыбораИзСпискаПредставленияПериодаРегистрации(ВыбранныйЭлемент, ДопПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	ИначеЕсли Год(ВыбранныйЭлемент.Значение) <> Год(ДопПараметры.ПериодРегистрации) Тогда
		РаботаСДиалогамиКлиент.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(ДопПараметры.Элемент, ВыбранныйЭлемент.Значение, ЭтаФорма, ВыбранныйЭлемент.Значение, Истина);
		Возврат;	
	КонецЕсли;
	
	Объект.ПериодРегистрации = ВыбранныйЭлемент.Значение; 
	МесяцНачисленияСтрокой   = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(ВыбранныйЭлемент.Значение);
	Модифицированность = Истина;
	УстановитьИмяКнопки(ЭтаФорма);

КонецПроцедуры

