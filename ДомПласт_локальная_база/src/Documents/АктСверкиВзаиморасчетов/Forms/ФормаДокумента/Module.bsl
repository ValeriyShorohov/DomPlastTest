&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаКлиенте
Перем УИДЗамераЗаполнения;

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
		
	ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ЗаблокироватьРеквизиты(ЭтотОбъект, Объект.Проведен);  
	
	УстановитьОформлениеДоговора();

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
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ЗаблокироватьРеквизиты(ЭтотОбъект, Объект.Проведен);
	
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
		КлючеваяОперация = "Документ ""акт сверки взаиморасчетов"" (проведение)";
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
	
	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;
	
		// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБККлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента, Объект.ВалютаДокумента, ВалютаРегламентированногоУчета);

	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		
		СтруктураРезультатаВыполненияПриИзмененииДаты = Неопределено;
		ДатаПриИзмененииНаСервере(СтруктураРезультатаВыполненияПриИзмененииДаты);
		
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)	
	
	РаботаСДиалогамиКлиент.СтруктурноеПодразделениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Объект.Организация, Объект.СтруктурноеПодразделение, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СтруктурноеПодразделениеОрганизация) Тогда 
		Объект.Организация = Неопределено;
		Объект.СтруктурноеПодразделение = Неопределено;
	Иначе 
		Результат = РаботаСДиалогамиКлиент.ПроверитьИзменениеЗначенийОрганизацииСтруктурногоПодразделения(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение);
		Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
			ПриИзмененииЗначенияОрганизацииНаСервере(Результат);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаДокументаПриИзменении(Элемент)
	
	УстановитьПодписиВалют(ЭтаФорма);
	
	ВалютаДокументаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ВалютаДокументаПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.ВалютаДокумента) И Объект.ВалютаДокумента <> Объект.ДоговорКонтрагента.ВалютаВзаиморасчетов Тогда		
		Объект.ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;    	
	
	УстановитьПараметрыВыбораДоговора(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СверкаСогласованаПриИзменении(Элемент)
	
	ИзменитьДоступностьПоСогласованиюСверки(ЭтаФорма);
	
	СверкаСогласованаПриИзмененииНаСервере();
	
КонецПроцедуры  

&НаСервере
Процедура СверкаСогласованаПриИзмененииНаСервере()  
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключатьДочерниеПриИзменении(Элемент)
	
	Если Объект.ВключатьДочерние Тогда
		Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
			Объект.ДоговорКонтрагента = Неопределено;
		КонецЕсли;	
	КонецЕсли;

	ИзменитьДоступностьПоСогласованиюСверки(ЭтаФорма);    
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	КонтрагентПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОстатокНаНачалоПриИзменении(Элемент)
	
	ПересчитатьОстатки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСпискаСтруктурныхЕдиницНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокСтруктурныхЕдиниц = ПолучитьСписокОрганизацийПоТабЧасти(ЭтаФорма);
	
	РаботаСДиалогамиКлиент.НачалоВыбораСпискаСтруктурныхЕдиниц(СписокСтруктурныхЕдиниц, ЭтаФорма, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСпискаСтруктурныхЕдиниц(Результат, Параметры) Экспорт

	Если Результат <> Неопределено Тогда
		
		ЗаполнитьТабЧастьПоСпискуОрганизаций(Результат);
		
		ПредставлениеСпискаСтруктурныхЕдиниц = БухгалтерскиеОтчетыКлиентСервер.ВыгрузитьСписокВСтроку(Результат); 
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)

	ДоговорКонтрагентаПриИзмененииНаСервере();
		
КонецПроцедуры

&НаСервере
Процедура ДоговорКонтрагентаПриИзмененииНаСервере()

	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) И (НЕ Объект.ДоговорКонтрагента.ЭтоГруппа) 
	   И Объект.ВалютаДокумента <> Объект.ДоговорКонтрагента.ВалютаВзаиморасчетов Тогда
		Объект.ВалютаДокумента = Объект.ДоговорКонтрагента.ВалютаВзаиморасчетов;
	КонецЕсли;  
	
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) И (НЕ Объект.ДоговорКонтрагента.ЭтоГруппа) Тогда
		Объект.РазбитьПоДоговорам = Ложь; 
	КонецЕсли; 

	УстановитьПараметрыВыбораДоговора(ЭтаФорма);
	УстановитьПараметрыВыбораДокумента(ЭтаФорма);  
	
	УправлениеФормой(ЭтотОбъект);
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСнятьФлажки(Пометка = Неопределено)
	
	Если Пометка = Неопределено Тогда 
		Для Каждого СтрокаСписокСчетов Из Объект.СписокСчетов Цикл
			СтрокаСписокСчетов.УчаствуетВРасчетах = НЕ СтрокаСписокСчетов.УчаствуетВРасчетах;
		КонецЦикла;
	Иначе
		Для Каждого СтрокаСписокСчетов Из Объект.СписокСчетов Цикл
			СтрокаСписокСчетов.УчаствуетВРасчетах = Пометка;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры       

&НаКлиенте
Процедура РазбитьПоДоговорамПриИзменении(Элемент)
	
	Если Объект.ПоДаннымОрганизации.Количество() > 0
		ИЛИ Объект.ПоДаннымКонтрагента.Количество() >0 Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросРазбитьПоДоговорамЗавершение", ЭтотОбъект);
		Текст = НСтр("ru='При изменении флага ""Разбить по договорам"" табличные части будут очищены. Продолжить?'");
		ПоказатьВопрос(ОписаниеОповещения, Текст, РежимДиалогаВопрос.ДаНет, 0, КодВозвратаДиалога.Да);
		
	Иначе
		Объект.ОстатокНаНачало = 0;
		ПересчитатьОстатки();
		УправлениеФормой(ЭтаФорма);
	КонецЕсли;

КонецПроцедуры 

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ПоДаннымОрганизации

&НаКлиенте
Процедура ПоДаннымОрганизацииПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НЕ ОтменаРедактирования Тогда
		ПересчитатьОстатки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоДаннымОрганизацииПослеУдаления(Элемент)
	
	ПересчитатьОстатки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоДаннымОрганизацииДокументПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПоДаннымОрганизации.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Документ) Тогда
		
		ДанныеСтрокиТаблицы = Новый Структура("Документ, ВидВходящегоДокумента, НомерВходящегоДокумента, ДатаВходящегоДокумента");
		ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, Элементы.ПоДаннымОрганизации.ТекущиеДанные);
		
		ПоДаннымОрганизацииДокументПриИзмененииНаСервере(ДанныеСтрокиТаблицы);
			
		ЗаполнитьЗначенияСвойств(Элементы.ПоДаннымОрганизации.ТекущиеДанные, ДанныеСтрокиТаблицы);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ПоДаннымКонтрагента

&НаКлиенте
Процедура ПоДаннымКонтрагентаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НЕ ОтменаРедактирования Тогда
		ПересчитатьОстатки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоДаннымКонтрагентаПослеУдаления(Элемент)
	
	ПересчитатьОстатки();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СписокСчетов

&НаКлиенте
Процедура СписокСчетовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные = Элементы.СписокСчетов.ТекущиеДанные;
		
		Если НЕ ТекущиеДанные = Неопределено Тогда
			
			ТекущиеДанные.УчаствуетВРасчетах = Истина;
			
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗаполнитьПоУмолчанию(Команда)
	
	Если Объект.СписокСчетов.Количество() > 0 Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросЗаполнитьСчетамиПоУмолчаниюЗавершение", ЭтотОбъект);
		
		Текст = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		
		ПоказатьВопрос(ОписаниеОповещения, Текст, Режим, 0, КодВозвратаДиалога.Да);
		
	Иначе
		
		// СписокСчетов будет заполнен вместе с таблицей-шаблоном
		ЗаполнитьСчетамиПоУмолчаниюНаСервере();
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаполнитьСчетамиПоУмолчаниюЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Объект.СписокСчетов.Очистить();
		
		// СписокСчетов будет заполнен вместе с таблицей-шаблоном
		ЗаполнитьСчетамиПоУмолчаниюНаСервере();
		Модифицированность = Истина;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДаннымУчета(Команда)
	
	Если Объект.ПоДаннымОрганизации.Количество() > 0 Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросЗаполнитьПоДаннымУчетаЗавершение", ЭтотОбъект);
		Текст = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		ПоказатьВопрос(ОписаниеОповещения, Текст, Режим, 0, КодВозвратаДиалога.Да);
		
	Иначе
		
		Если Объект.СписокОрганизаций.Количество() = 0 Тогда
			
			НоваяСтрокаСпискаОрганизаций = Объект.СписокОрганизаций.Добавить();
			НоваяСтрокаСпискаОрганизаций.Организация = Объект.Организация;

			ПредставлениеСпискаСтруктурныхЕдиниц = БухгалтерскиеОтчетыКлиентСервер.ВыгрузитьСписокВСтроку(ПолучитьСписокОрганизацийПоТабЧасти(ЭтаФорма)); 
			
		КонецЕсли;
		
		ЗаполнитьДаннымиБухгалтерскогоУчетаНаКлиенте();
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаполнитьПоДаннымУчетаЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Если Объект.СписокОрганизаций.Количество() = 0 Тогда
		
			НоваяСтрокаСпискаОрганизаций = Объект.СписокОрганизаций.Добавить();
			НоваяСтрокаСпискаОрганизаций.Организация = Объект.Организация;

			ПредставлениеСпискаСтруктурныхЕдиниц = БухгалтерскиеОтчетыКлиентСервер.ВыгрузитьСписокВСтроку(ПолучитьСписокОрганизацийПоТабЧасти(ЭтаФорма)); 
			
		КонецЕсли;
		
		Объект.ПоДаннымОрганизации.Очистить();
		ЗаполнитьДаннымиБухгалтерскогоУчетаНаКлиенте();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеКонтрагентаПоДаннымОрганизации(Команда)
	
	Если Объект.ПоДаннымКонтрагента.Количество() > 0 Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросЗаполнитьДанныеКонтрагентаЗавершение", ЭтотОбъект);
		Текст = НСтр("ru='Перед заполнением табличная часть будет очищена. Продолжить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		ПоказатьВопрос(ОписаниеОповещения, Текст, Режим, 0, КодВозвратаДиалога.Да);
		
	Иначе
		
		ЗаполнитьДанныеКонтрагентаПоДаннымОрганизацииСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаполнитьДанныеКонтрагентаЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = Неопределено ИЛИ Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ПоДаннымКонтрагента.Очистить();

	//проверим заполненность обязательных реквизитов:
	Если Объект.ПоДаннымОрганизации.Количество() = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru='Таблица ""По данным организации"" не заполнена!'"));
	Иначе
		ЗаполнитьДанныеКонтрагентаПоДаннымОрганизацииСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбораПериода = Новый Структура("НачалоПериода, КонецПериода", Объект.ДатаНачала, Объект.ДатаОкончания);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбораПериода, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлаги(Команда)

	УстановитьСнятьФлажки(Ложь);	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлаги(Команда)

	УстановитьСнятьФлажки(Истина);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура РазблокироватьРеквизиты() Экспорт
	
	Элементы.ПоДаннымОрганизации.ТолькоПросмотр       = Ложь;
	Элементы.ПоДаннымОрганизации.ИзменятьСоставСтрок  = Ложь;
	Элементы.ПоДаннымОрганизации.ИзменятьПорядокСтрок = Ложь;
	
	Элементы.ПоДаннымКонтрагента.ТолькоПросмотр           = Ложь;
	Элементы.ПоДаннымКонтрагента.ИзменятьСоставСтрок      = Ложь;
	Элементы.ПоДаннымКонтрагента.ИзменятьПорядокСтрок     = Ложь;

	Элементы.СписокСчетов.ТолькоПросмотр          = Ложь;
	Элементы.СписокСчетов.ИзменятьСоставСтрок     = Ложь;
	Элементы.СписокСчетов.ИзменятьПорядокСтрок    = Ложь;
	

КонецПроцедуры

&НаСервере
Функция РеквизитыЗаблокированы()
	
	Возврат ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ЭтотОбъект, "ПараметрыЗапретаРедактированияРеквизитов");
	
КонецФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
    
    ПоказыватьВДокументахСчетаУчета = Истина;
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация (Элементы.СтруктурноеПодразделениеОрганизация, Объект.СтруктурноеПодразделение, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Объект.СверкаСогласована = Ложь;
		Если НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			Объект.ДатаОкончания = ОбщегоНазначения.ТекущаяДатаПользователя();
		КонецЕсли;
		
		ЗаполнитьСчетамиПоУмолчаниюНаСервере();
		
	КонецЕсли;	
	
	ТекущийПериод.ДатаНачала    = Объект.ДатаНачала;
	ТекущийПериод.ДатаОкончания = Объект.ДатаОкончания;
	
	ПредставлениеСпискаСтруктурныхЕдиниц = БухгалтерскиеОтчетыКлиентСервер.ВыгрузитьСписокВСтроку(ПолучитьСписокОрганизацийПоТабЧасти(ЭтаФорма));

	ПересчитатьОстаткиНаСервере();
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	УстановитьПараметрыВыбораДокумента(ЭтотОбъект);
	УстановитьПараметрыВыбораДоговора(ЭтаФорма);
	
	ИзменитьДоступностьПоСогласованиюСверки(ЭтаФорма);
	УправлениеФормой(ЭтаФорма);
	
	ОбщегоНазначенияБК.УстановитьТекстАвтора(НадписьАвтор, Объект.Автор);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста 
Процедура УправлениеФормой(Форма)

	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	УстановитьПодписиВалют(Форма);
    
    Элементы.ГруппаСписокСчетов.Видимость = Форма.ПоказыватьВДокументахСчетаУчета;  
	
	Элементы.РазбитьПоДоговорам.Доступность = НЕ ЗначениеЗаполнено(Объект.ДоговорКонтрагента)
		ИЛИ Объект.ДоговорКонтрагента.ЭтоГруппа
		И НЕ Объект.СверкаСогласована;

КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделения(Результат, Параметры) Экспорт
	
	РаботаСДиалогамиКлиент.ПослеВыбораСтруктурногоПодразделения(Результат, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
		Модифицированность = Истина;
		Результат.Вставить("НеобходимоИзменитьЗначенияРеквизитовОбъекта", Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСчетамиПоУмолчаниюНаСервере()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Контрагенты", ПланыВидовХарактеристик.ВидыСубконтоТиповые.Контрагенты);
	Запрос.УстановитьПараметр("Договоры",	 ПланыВидовХарактеристик.ВидыСубконтоТиповые.Договоры);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Типовой.Ссылка КАК Счет
	|ИЗ
	|	ПланСчетов.Типовой КАК Типовой
	|ГДЕ
	|	Типовой.ВидыСубконто.ВидСубконто = &Контрагенты
	|	И Типовой.ВидыСубконто.ВидСубконто = &Договоры
	|	И (НЕ Типовой.Забалансовый)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Типовой.Порядок";
						 
	ТаблицаСчетов = Запрос.Выполнить().Выгрузить();
	ТаблицаСчетов.Колонки.Добавить("УчаствуетВРасчетах");
	ТаблицаСчетов.ЗаполнитьЗначения(Истина, "УчаствуетВРасчетах");
	Объект.СписокСчетов.Загрузить(ТаблицаСчетов);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДаннымиБухгалтерскогоУчетаНаКлиенте()

	УИДЗамераЗаполнения = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Ложь, "Документ ""акт сверки взаиморасчетов"" (заполнение)");
	
	Результат = ЗаполнитьДаннымиБухгалтерскогоУчетаНаСервере();
	
	Если ТипЗнч(Результат) = Тип("Структура") 
		и НЕ Результат.ЗаданиеВыполнено Тогда
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
	Иначе
		
		ЗафиксироватьДлительностьКлючевойОперации();
		
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Функция ЗаполнитьДаннымиБухгалтерскогоУчетаНаСервере()
	
	//проверим заполненность обязательных реквизитов
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Истина;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("ДатаНачала",                Объект.ДатаНачала);
	СтруктураПараметров.Вставить("ДатаОкончания",             Объект.ДатаОкончания);
	СтруктураПараметров.Вставить("Контрагент",                Объект.Контрагент);
	СтруктураПараметров.Вставить("ВключатьДочерние",          Объект.ВключатьДочерние);
	СтруктураПараметров.Вставить("Организация",               Объект.Организация);
	СтруктураПараметров.Вставить("СтруктурноеПодразделение",  Объект.СтруктурноеПодразделение);
	СтруктураПараметров.Вставить("ВключатьВнутренниеОбороты", Объект.ВключатьВнутренниеОбороты);
	
	СписокОрганизацийПрочих = Объект.СписокОрганизаций.Выгрузить().ВыгрузитьКолонку("Организация");
	ОрганизацияДляИсключения = СписокОрганизацийПрочих.Найти(Объект.Организация);
	Если ОрганизацияДляИсключения <> Неопределено Тогда
		СписокОрганизацийПрочих.Удалить(ОрганизацияДляИсключения);
	КонецЕсли;
	СтруктураПараметров.Вставить("СписокОрганизаций",        СписокОрганизацийПрочих);
			
	ФильтрСписокСчетов = Новый Массив();
	Для Каждого СтрокаСчета Из Объект.СписокСчетов Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаСчета.Счет) ИЛИ НЕ СтрокаСчета.УчаствуетВРасчетах Тогда
			Продолжить;
		Иначе
			ФильтрСписокСчетов.Добавить(СтрокаСчета.Счет);
		КонецЕсли; 
	КонецЦикла; 
	СтруктураПараметров.Вставить("ФильтрСписокСчетов",  ФильтрСписокСчетов);
		
	СтруктураПараметров.Вставить("ДоговорКонтрагента",  Объект.ДоговорКонтрагента);
	СтруктураПараметров.Вставить("ВалютаДокумента",     Объект.ВалютаДокумента);
	СтруктураПараметров.Вставить("ПоДаннымОрганизации", Объект.ПоДаннымОрганизации.Выгрузить());
	СтруктураПараметров.Вставить("РазбитьПоДоговорам", Объект.РазбитьПоДоговорам);
	
	НаименованиеЗадания = "ЗаполнитьПоДаннымОрганизации";
	
	РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор, 
		"Документы.АктСверкиВзаиморасчетов.ЗаполнитьПоДаннымБухгалтерскогоУчета", 
		СтруктураПараметров, 
		НаименованиеЗадания);
		
	АдресХранилища = РезультатВыполнения.АдресХранилища;

	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДанныеКонтрагентаПоДаннымОрганизацииСервер()

	ПоДаннымКонтрагента = Объект.ПоДаннымОрганизации.Выгрузить();
	
	ПоДаннымКонтрагента.Колонки.Дебет.Имя  = "КредитК";
	ПоДаннымКонтрагента.Колонки.Кредит.Имя = "Дебет";
	ПоДаннымКонтрагента.Колонки.КредитК.Имя= "Кредит";
	
	Объект.ПоДаннымКонтрагента.Загрузить(ПоДаннымКонтрагента);
	ПересчитатьОстаткиНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьОстатки()

	Если Объект.ПоДаннымОрганизации.Количество() = 0 И Объект.ОстатокНаНачало <> 0 Тогда

		ТекстСообщения = НСтр("ru = 'За указанный период оборотов не обнаружено, но есть начальный остаток по взаиморасчетам на дату: %1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Формат(Объект.ДатаНачала, "ДФ=dd.MM.yyyy"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект");

	КонецЕсли;
	
	ОстатокНаКонец = Объект.ОстатокНаНачало + Объект.ПоДаннымОрганизации.Итог("Дебет") - Объект.ПоДаннымОрганизации.Итог("Кредит");
	ОстатокНаНачалоКонтрагент = - Объект.ОстатокНаНачало;
	
	ОстатокНаКонецКонтрагент = ОстатокНаНачалоКонтрагент + Объект.ПоДаннымКонтрагента.Итог("Дебет") - Объект.ПоДаннымКонтрагента.Итог("Кредит");
	
	Если Объект.Расхождение <> ОстатокНаКонец + ОстатокНаКонецКонтрагент Тогда
		Объект.Расхождение = ОстатокНаКонец + ОстатокНаКонецКонтрагент;
	КонецЕсли;
	Расхождение = Объект.Расхождение;
	РасхождениеКонтрагента = - Расхождение;
	
	ОборотыДебет = Объект.ПоДаннымОрганизации.Итог("Дебет");
	ОборотыКредит = Объект.ПоДаннымОрганизации.Итог("Кредит");
	
	ОборотыДебетКонтрагент = Объект.ПоДаннымКонтрагента.Итог("Дебет");
	ОборотыКредитКонтрагент = Объект.ПоДаннымКонтрагента.Итог("Кредит");

КонецПроцедуры

&НаСервере
Процедура ПересчитатьОстаткиНаСервере()

	Если Объект.ПоДаннымОрганизации.Количество() = 0 И Объект.ОстатокНаНачало <> 0 Тогда

		ТекстСообщения = НСтр("ru = 'За указанный период оборотов не обнаружено, но есть начальный остаток по взаиморасчетам на дату: %1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Формат(Объект.ДатаНачала, "ДФ=dd.MM.yyyy"));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект");
		
	КонецЕсли;
	
	ОстатокНаКонец = Объект.ОстатокНаНачало + Объект.ПоДаннымОрганизации.Итог("Дебет") - Объект.ПоДаннымОрганизации.Итог("Кредит");
	ОстатокНаНачалоКонтрагент = - Объект.ОстатокНаНачало;
	
	ОстатокНаКонецКонтрагент = ОстатокНаНачалоКонтрагент + Объект.ПоДаннымКонтрагента.Итог("Дебет") - Объект.ПоДаннымКонтрагента.Итог("Кредит");
	
	Если Объект.Расхождение <> ОстатокНаКонец + ОстатокНаКонецКонтрагент Тогда
		Объект.Расхождение = ОстатокНаКонец + ОстатокНаКонецКонтрагент;
	КонецЕсли;
	Расхождение = Объект.Расхождение;
	РасхождениеКонтрагента = - Расхождение;

	ОборотыДебет = Объект.ПоДаннымОрганизации.Итог("Дебет");
	ОборотыКредит = Объект.ПоДаннымОрганизации.Итог("Кредит");
	
	ОборотыДебетКонтрагент = Объект.ПоДаннымКонтрагента.Итог("Дебет");
	ОборотыКредитКонтрагент = Объект.ПоДаннымКонтрагента.Итог("Кредит");
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ОстатокНаНачало = СтруктураДанных.ОстатокНаНачало;
	
	Объект.ПоДаннымОрганизации.Загрузить(СтруктураДанных.ПоДаннымОрганизации);
	
	ПересчитатьОстаткиНаСервере();
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПодготовленныеДанные();
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			ЗафиксироватьДлительностьКлючевойОперации();
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		УИДЗамераЗаполнения = Неопределено;
		ВремяНачалаОперации = Неопределено;
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста 
Процедура УстановитьПодписиВалют(ЭтаФорма)
	
	Элементы = ЭтаФорма.Элементы;
	Объект = ЭтаФорма.Объект;
	
	ПодписьВалюты = НСтр("ru = '(%1)'");
	
	Если НЕ ЗначениеЗаполнено(Объект.ВалютаДокумента) Тогда
		ПодписьВалюты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПодписьВалюты, ЭтаФорма.ВалютаРегламентированногоУчета);
	Иначе
		ПодписьВалюты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПодписьВалюты, СокрЛП(Строка(Объект.ВалютаДокумента)));
	КонецЕсли; 
	
	Элементы.ПоДаннымОрганизацииДебет.Заголовок  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Дебет %1'"), ПодписьВалюты);
	Элементы.ПоДаннымОрганизацииКредит.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Кредит %1'"), ПодписьВалюты);
	
	Элементы.ПоДаннымКонтрагентаДебет.Заголовок  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Дебет %1'"), ПодписьВалюты);
	Элементы.ПоДаннымКонтрагентаКредит.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Кредит %1'"), ПодписьВалюты);
	
	Элементы.ДекорацияОстаткиПоОрганизации.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Остатки %1:'"), ПодписьВалюты);
	Элементы.ДекорацияОстаткиПоКонтрагенту.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Остатки %1:'"), ПодписьВалюты);
	
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста 
Процедура ИзменитьДоступностьПоСогласованиюСверки(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Элементы.СтруктурноеПодразделениеОрганизация.Доступность	= НЕ Объект.СверкаСогласована;
	Элементы.ПоДаннымКонтрагента.Доступность 					= НЕ Объект.СверкаСогласована;
	Элементы.ПоДаннымОрганизации.Доступность 					= НЕ Объект.СверкаСогласована;
	Элементы.Контрагент.Доступность          					= НЕ Объект.СверкаСогласована;
	Элементы.ДоговорКонтрагента.Доступность  					= НЕ Объект.СверкаСогласована;
	Элементы.ОстатокНаНачало.Доступность     					= НЕ Объект.СверкаСогласована;
	Элементы.СписокСчетов.Доступность 		  					= НЕ Объект.СверкаСогласована;
	Элементы.ВалютаДокумента.Доступность 	  					= НЕ Объект.СверкаСогласована;
	Элементы.ДатаНачала.Доступность 		  					= НЕ Объект.СверкаСогласована;
	Элементы.ДатаОкончания.Доступность 	  					    = НЕ Объект.СверкаСогласована;
	Элементы.ВключатьДочерние.Доступность 						= НЕ Объект.СверкаСогласована;
	Элементы.ВыбратьПериод.Доступность	                        = НЕ Объект.СверкаСогласована;
	Элементы.ПредставлениеСпискаСтруктурныхЕдиниц.Доступность 	= НЕ Объект.СверкаСогласована;
	Элементы.ВключатьВнутренниеОбороты.Доступность	            = НЕ Объект.СверкаСогласована;
	Элементы.РазбитьПоДоговорам.Доступность                     = НЕ Объект.СверкаСогласована;
			
	Элементы.ПоДаннымОрганизацииЗаполнитьПоДаннымБухгалтерскогоУчета.Доступность = НЕ Объект.СверкаСогласована;
	Элементы.ПоДаннымКонтрагентаЗаполнитьПоДаннымОрганизации.Доступность = НЕ Объект.СверкаСогласована;
	Элементы.СписокСчетовЗаполнитьПоУмолчанию.Доступность = НЕ Объект.СверкаСогласована;
		
	Если НЕ Объект.СверкаСогласована Тогда
		
		Элементы.ДоговорКонтрагента.Доступность = НЕ Объект.ВключатьДочерние;
		
	КонецЕсли;                                                       
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()
	
	Для Каждого СтрокаТаблицы Из Объект.ПоДаннымОрганизации Цикл
		
		Если НЕ СтрокаТаблицы.Документ = Неопределено 
			И СтрокаТаблицы.Документ.Метаданные().Реквизиты.Найти("ВидВходящегоДокумента") <> Неопределено Тогда
			
			Попытка
				СвойстваДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
				СтрокаТаблицы.Документ, "ВидВходящегоДокумента, ДатаВходящегоДокумента, НомерВходящегоДокумента");
				
				СтрокаТаблицы.ВидВходящегоДокумента    = СвойстваДокумента.ВидВходящегоДокумента;
				СтрокаТаблицы.ДатаВходящегоДокумента   = СвойстваДокумента.ДатаВходящегоДокумента;
				СтрокаТаблицы.НомерВходящегоДокумента  = СвойстваДокумента.НомерВходящегоДокумента;
			Исключение
			КонецПопытки;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры  

&НаСервере
Процедура ПриИзмененииЗначенияОрганизацииНаСервере(СтруктураПараметров = Неопределено)

	Если СтруктураПараметров = Неопределено	ИЛИ (СтруктураПараметров.Свойство("НеобходимоИзменитьЗначенияРеквизитовОбъекта") 
				И СтруктураПараметров.НеобходимоИзменитьЗначенияРеквизитовОбъекта) Тогда 
		РаботаСДиалогами.СтруктурноеПодразделениеПриИзменении(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктураПараметров);
	КонецЕсли;

	РаботаСДиалогами.ПриИзмененииЗначенияОрганизации(Объект);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПоДаннымОрганизацииДокументПриИзмененииНаСервере(ДанныеСтрокиТаблицы)
	
	Если ДанныеСтрокиТаблицы.Документ.Метаданные().Реквизиты.Найти("ВидВходящегоДокумента") <> Неопределено Тогда
		ДанныеСтрокиТаблицы.ВидВходящегоДокумента   = ДанныеСтрокиТаблицы.Документ.ВидВходящегоДокумента;
		ДанныеСтрокиТаблицы.НомерВходящегоДокумента = ДанныеСтрокиТаблицы.Документ.НомерВходящегоДокумента;
		ДанныеСтрокиТаблицы.ДатаВходящегоДокумента  = ДанныеСтрокиТаблицы.Документ.ДатаВходящегоДокумента;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Объект.ДатаНачала	 = РезультатВыбора.НачалоПериода;
	Объект.ДатаОкончания = РезультатВыбора.КонецПериода;
	
	ПриИзмененииПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПериода()
	
	Если ТекущийПериод.ДатаНачала <> Объект.ДатаНачала ИЛИ ТекущийПериод.ДатаОкончания <> КонецДня(Объект.ДатаОкончания) Тогда
		
		Если Объект.ПоДаннымОрганизации.Количество() > 0 Тогда
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ВопросПриИзмененииПериодаЗавершение", ЭтотОбъект);
			Текст = НСтр("ru='При изменении периода сверки табличная часть будет очищена. Изменить период?'");
			Режим = РежимДиалогаВопрос.ДаНет;
			ПоказатьВопрос(ОписаниеОповещения, Текст, Режим, 0, КодВозвратаДиалога.Да);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросПриИзмененииПериодаЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ТекущийПериод.ДатаНачала	 = Объект.ДатаНачала;
		ТекущийПериод.ДатаОкончания	 = Объект.ДатаОкончания;
		Объект.ПоДаннымОрганизации.Очистить();
		ПересчитатьОстатки();
	Иначе
		Объект.ДатаНачала	 = ТекущийПериод.ДатаНачала;
		Объект.ДатаОкончания = ТекущийПериод.ДатаОкончания;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()
	
	// Выполняем общие действия для всех документов при изменении Контрагент.
	УправлениеВзаиморасчетамиСервер.ПриИзмененииЗначенияКонтрагента(Объект);

	Объект.ПредставительКонтрагента = Объект.Контрагент.ОсновноеКонтактноеЛицо;
	
	Если Объект.ВключатьДочерние ИЛИ НЕ ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам")Тогда
		Объект.ДоговорКонтрагента = Неопределено;		
	КонецЕсли;
	
	ДоговорКонтрагентаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСписокОрганизацийПоТабЧасти(ЭтаФорма) Экспорт
	
	Объект = ЭтаФорма.Объект;
	
	СписокСтруктурныхЕдиниц = Новый СписокЗначений;
	
	Для Каждого СтрокаСпискаОрганизаций Из Объект.СписокОрганизаций Цикл
		СписокСтруктурныхЕдиниц.Добавить(СтрокаСпискаОрганизаций.Организация);
	КонецЦикла;
	
	Возврат СписокСтруктурныхЕдиниц;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьТабЧастьПоСпискуОрганизаций(СписокСтруктурныхЕдиниц) Экспорт
	
	Объект.СписокОрганизаций.Очистить();
	
	Для Каждого ЭлементСписка Из СписокСтруктурныхЕдиниц Цикл
		
		НоваяСтрокаСпискаОрганизаций = Объект.СписокОрганизаций.Добавить();
		НоваяСтрокаСпискаОрганизаций.Организация = ЭлементСписка.Значение;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере(СтруктураРезультатаВыполненияПриИзмененииДаты)
	
	РаботаСДиалогами.ПриИзмененииЗначенияДатыДокумента(Объект, ВалютаРегламентированногоУчета, , Истина, СтруктураРезультатаВыполненияПриИзмененииДаты);	
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьПараметрыВыбораДокумента(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	НовыеПараметры = Новый Массив();
	
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.ДоговорКонтрагента", Объект.ДоговорКонтрагента));
	КонецЕсли;
	
	Элементы.ПоДаннымОрганизацииДокумент.ПараметрыВыбора = Новый ФиксированныйМассив(НовыеПараметры);
			
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьПараметрыВыбораДоговора(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	НовыеПараметры = Новый Массив();
	
	Если ЗначениеЗаполнено(Объект.ВалютаДокумента) Тогда
		НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.ВалютаВзаиморасчетов", Объект.ВалютаДокумента));
		НовыеПараметры.Добавить(Новый ПараметрВыбора("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы));
	КонецЕсли;
	
	Элементы.ДоговорКонтрагента.ПараметрыВыбора = Новый ФиксированныйМассив(НовыеПараметры);
			
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьДлительностьКлючевойОперации()
	
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамераЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросРазбитьПоДоговорамЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
			
		Объект.ОстатокНаНачало = 0;
		Объект.ПоДаннымОрганизации.Очистить();
		Объект.ПоДаннымКонтрагента.Очистить();
		ПересчитатьОстатки();

		УправлениеФормой(ЭтаФорма);
	Иначе
		Объект.РазбитьПоДоговорам = НЕ Объект.РазбитьПоДоговорам; 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОформлениеДоговора()
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ПоДаннымОрганизацииДоговор");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ПоДаннымКонтрагентаДоговор");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
	"Объект.РазбитьПоДоговорам", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

