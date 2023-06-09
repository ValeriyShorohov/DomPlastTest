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
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства	
	
	Если Объект.Ссылка.Пустая() Тогда
		//заполнение реквизитов новой номенклатуры по параметрам
		Если Параметры.Свойство("НоменклатурнаяГруппа") Тогда
			Объект.НоменклатурнаяГруппа = Параметры.НоменклатурнаяГруппа;
		КонецЕсли;
		Если Параметры.Свойство("Родитель") Тогда
			Объект.Родитель = Параметры.Родитель;
		КонецЕсли;
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ПолучитьЗначениеЦеныПродажи();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ФормаВыбораИзКлассификатора") Тогда
		
		Если ВРег(ИсточникВыбора.ИмяМакета) = ВРег("КодыКПВЭД") Тогда
			
			Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда 
				Объект.КодКПВЭД = ВыбранноеЗначение;
			Иначе 
				Объект.КодКПВЭД 									  = ВыбранноеЗначение.КодСтроки;
				Элементы.ДекорацияРасшифровкаКодСтрокиКПВЭД.Заголовок = ВыбранноеЗначение.Наименование;
			КонецЕсли;
		КонецЕсли;
		
		Модифицированность = Истина;
		
	ИначеЕсли  ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.НоменклатураГСВС.Форма.ФормаВыбора") Тогда
		
		УстановитьКодТНВЭД(ВыбранноеЗначение);
		ДобавитьИнформациюОНоменклатуре();
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	ПараметрыЗаписи.Вставить("НоменклатурнаяГруппа", Объект.НоменклатурнаяГруппа);
	Оповестить("Запись_Номенклатура", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр)Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ИмяСобытия = "Запись_КонстантаНастройкаЗаполненияЦеныПродажи" Тогда
		ИзменениеНаФорме();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства 
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства 

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
			
	ЗаписатьИзменениеЦеныВРегистр(ТекущийОбъект);	
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура УслугаПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если ФормироватьНаименованиеПолноеАвтоматически Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПолноеПриИзменении(Элемент)
	
	УстановитьФлагФормироватьНаименованиеПолноеАвтоматически();

КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПолноеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Список = Новый СписокЗначений;
	Если ЗначениеЗаполнено(Объект.НаименованиеПолное) Тогда
		Список.Добавить(Объект.НаименованиеПолное);
	КонецЕсли;
	Для каждого НаименованиеАвтозаполнения Из НаименованияАвтозаполнения Цикл
		ТекНаименование = НаименованиеАвтозаполнения.Значение;
		Если ЗначениеЗаполнено(ТекНаименование)	
			И Список.НайтиПоЗначению(ТекНаименование) = Неопределено Тогда
			Список.Добавить(ТекНаименование);
		КонецЕсли;
	КонецЦикла;
	Если ЗначениеЗаполнено(Объект.Наименование)
		И Список.НайтиПоЗначению(Объект.Наименование) = Неопределено Тогда
		Список.Добавить(Объект.Наименование);
	КонецЕсли;

	Оповещение = Новый ОписаниеОповещения("НаименованиеПолноеНачалоВыбораЗавершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(Оповещение, Список, Элементы.НаименованиеПолное);
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПолноеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Объект.НаименованиеПолное = Результат.Значение;
		Модифицированность = Истина;
		ФормироватьНаименованиеПолноеАвтоматически = ПустаяСтрока(Объект.НаименованиеПолное)
			ИЛИ (Объект.НаименованиеПолное = Объект.Наименование);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодТНВЭДПриИзменении(Элемент)
	
	ОбновитьПредставлениеЭлемента("КодСтрокиТНВЭД");
	
	УправлениеФормой(ЭтотОбъект)
    	
КонецПроцедуры

&НаКлиенте
Процедура КодТНВЭДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора"		  , Истина);
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ТипКодаГСВС", ПредопределенноеЗначение("Перечисление.ТипыКодовГСВС.ТНВЭД"));
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора);
	ПараметрыФормы.Вставить("ТекущийКодТНВЭД"	  , ?(НЕ ЗначениеЗаполнено(Объект.КодТНВЭД), Неопределено, СокрЛП(Объект.КодТНВЭД)));
	
	ОткрытьФорму("Справочник.НоменклатураГСВС.ФормаВыбора", ПараметрыФормы, ЭтаФорма, Истина);

КонецПроцедуры

&НаКлиенте
Процедура КодКПВЭДПриИзменении(Элемент)
	
	ОбновитьПредставлениеЭлемента("КодСтрокиКПВЭД");
	
КонецПроцедуры

&НаКлиенте
Процедура КодКПВЭДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора"		  , Истина);
	ПараметрыФормы.Вставить("ИмяМакета"			  , "КодыКПВЭД");
	ПараметрыФормы.Вставить("ИмяСекции"			  ,	"Классификатор");
	ПараметрыФормы.Вставить("ПолучатьПолныеДанные", Истина);
	ПараметрыФормы.Вставить("ТекущийКодСтроки"	  , ?(НЕ ЗначениеЗаполнено(Объект.КодКПВЭД), Неопределено, СокрЛП(Объект.КодКПВЭД)));
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораИзКлассификатора", ПараметрыФормы, ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодсказкаЦеныПродажиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "e1cib/command/ОбщаяКоманда.НастройкаПараметровУчета" Тогда
		
		СтандартнаяОбработка = Ложь; // Форму будем открывать с параметром
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ОткрытаИзКарточкиНоменклатуры", Истина);
		
		ОткрытьФорму("ОбщаяФорма.НастройкаПараметровУчета", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенаПродажиИзНоменклатурыПриИзменении(Элемент)
	ЦенаПродажиМодифицирована = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВалютаЦеныПродажиСВалютамиПриИзменении(Элемент)
	ЦенаПродажиМодифицирована = Истина;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Функция ПечатьШтрихкодовНоменклатуры(ПараметрыПечати) Экспорт
	
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("ОбъектыПечати"				, ПараметрыПечати.ОбъектыПечати);
	СтруктураРезультат.Вставить("Идентификатор" 			, УникальныйИдентификатор);
	СтруктураРезультат.Вставить("Форма"						, ЭтаФорма);
	
	УправлениеПечатьюБККлиент.ПечатьШтрихкодовНоменклатуры(СтруктураРезультат);
	
КонецФункции


// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

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
Процедура ПодготовитьФормуНаСервере()
	
	//обновление наименования строки КПВЭД и ТНВЭД
	
	ОбновитьПредставлениеЭлемента("КодСтрокиКПВЭД");
	ОбновитьПредставлениеЭлемента("КодСтрокиТНВЭД");

	УстановитьФлагФормироватьНаименованиеПолноеАвтоматически();
	
	НаименованияАвтозаполнения.Очистить();
	НаименованияАвтозаполнения.Добавить(Объект.НаименованиеПолное);
	НаименованияАвтозаполнения.Добавить(Объект.Наименование);
	
	ЧтениеЦенПродаж    = ПравоДоступа("Чтение", Метаданные.Константы.НастройкаЗаполненияЦеныПродажи);
	
	Если Не ЧтениеЦенПродаж Тогда
		Элементы.ГруппаЦенаПродажи.Видимость = Ложь;
	Иначе	
		НастроитьВидимостьЭлементыУправленияЦенойПродажи();
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
		ВалютаЦены         = ВалютаРегламентированногоУчета;
		ВалютыЦеныБезВалют = ВалютаРегламентированногоУчета;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.ВидНДСПриИмпорте.Доступность 					   = НЕ (Объект.Услуга);
	Элементы.БазоваяЕдиницаИзмерения.АвтоВыборНезаполненного   = НЕ (Объект.Услуга);
	Элементы.ДекорацияПереченьИзъятия.Видимость  			   = НЕ (Элементы.ДекорацияПереченьИзъятия.Заголовок = "");
	
КонецПроцедуры 

&НаСервере
Процедура ОбновитьПредставлениеЭлемента(ИмяОбновляемогоЭлемента)
	
	Если ИмяОбновляемогоЭлемента = "КодСтрокиКПВЭД" Тогда
		
		Если ПустаяСтрока(СтрЗаменить(Объект.КодКПВЭД, ".", "")) Тогда
			Элементы.ДекорацияРасшифровкаКодСтрокиКПВЭД.Заголовок = НСтр("ru ='<не указано>'");
		Иначе
			
			Если МакетКодовСтрокКПВЭД.ВысотаТаблицы = 0 Тогда
				МакетКодовСтрокКПВЭД = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_КодыКПВЭД");
			КонецЕсли;
			
			ОбластьСтрокКПВЭД = МакетКодовСтрокКПВЭД.Области.Найти("Классификатор");
			
			НаименованиеСтроки = РегламентированнаяОтчетность.ПолучитьНаименованиеСтрокиКлассификатораПоКоду(МакетКодовСтрокКПВЭД, ОбластьСтрокКПВЭД, Объект.КодКПВЭД, 3, 4);
			
			Если ПустаяСтрока(НаименованиеСтроки) Тогда
				Элементы.ДекорацияРасшифровкаКодСтрокиКПВЭД.Заголовок = НСтр("ru ='строка с кодом " + СокрЛП(Объект.КодКПВЭД) + " не найдена.'");
			Иначе
				Элементы.ДекорацияРасшифровкаКодСтрокиКПВЭД.Заголовок = НаименованиеСтроки;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяОбновляемогоЭлемента = "КодСтрокиТНВЭД" Тогда
		
		Если ПустаяСтрока(СтрЗаменить(Объект.КодТНВЭД, ".", "")) Тогда
			Элементы.ДекорацияРасшифровкаКодСтрокиТНВЭД.Заголовок = НСтр("ru ='<не указано>'");
			Элементы.ДекорацияВедетсяУчетПоТоварамВС.Заголовок = "";
			Элементы.ДекорацияПереченьИзъятия.Заголовок = "";
			Элементы.ДекорацияУникальныйТовар.Заголовок = "";
		Иначе
			ДобавитьИнформациюОНоменклатуре();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФлагФормироватьНаименованиеПолноеАвтоматически()

	Если ПустаяСтрока(Объект.НаименованиеПолное) 
	 ИЛИ Объект.НаименованиеПолное = Объект.Наименование Тогда
	 	ФормироватьНаименованиеПолноеАвтоматически = Истина;
	Иначе
		ФормироватьНаименованиеПолноеАвтоматически = Ложь;
	КонецЕсли;

КонецПроцедуры 

&НаСервере
Процедура ДобавитьИнформациюОНоменклатуре()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", ТекущаяДата());
	Запрос.УстановитьПараметр("КодТНВЭД", Объект.КодТНВЭД);
	
	Запрос.Текст = "ВЫБРАТЬ
		|	СведенияОНоменклатуреГСВССрезПоследних.ПризнакУчетаНаВиртуальномСкладе КАК ПризнакУчетаНаВиртуальномСкладе,
		|	СведенияОНоменклатуреГСВССрезПоследних.ПризнакУникальногоТовара КАК ПризнакУникальногоТовара,
		|	СведенияОНоменклатуреГСВССрезПоследних.ПризнакПеречняИзьятий КАК ПризнакПеречняИзьятий,
		|	СпрНоменклатураГСВС.КодГСВС КАК КодТНВЭД,
		|	СпрНоменклатураГСВС.ПолноеНаименованиеRu КАК ПолноеНаименование
		|ИЗ
		|	РегистрСведений.СведенияОНоменклатуреГСВС.СрезПоследних(&Дата, ) КАК СведенияОНоменклатуреГСВССрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НоменклатураГСВС КАК СпрНоменклатураГСВС
		|		ПО СведенияОНоменклатуреГСВССрезПоследних.НоменклатураГСВС = СпрНоменклатураГСВС.Ссылка
		|ГДЕ
		|	СпрНоменклатураГСВС.КодГСВС = &КодТНВЭД
		|	И СпрНоменклатураГСВС.ТипКодаГСВС = ЗНАЧЕНИЕ(Перечисление.ТипыКодовГСВС.ТНВЭД)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если Выборка.ПризнакУчетаНаВиртуальномСкладе Тогда
			Элементы.ДекорацияВедетсяУчетПоТоварамВС.Заголовок = НСтр("ru ='Товар ВС;'");
		Иначе
			Элементы.ДекорацияВедетсяУчетПоТоварамВС.Заголовок = "";
		КонецЕсли;
		Если Выборка.ПризнакПеречняИзьятий Тогда
			Элементы.ДекорацияПереченьИзъятия.Заголовок = НСтр("ru ='Товар входит в перечень изъятий;'");
		Иначе
			Элементы.ДекорацияПереченьИзъятия.Заголовок = "";
		КонецЕсли;
		Если Выборка.ПризнакУникальногоТовара Тогда
			Элементы.ДекорацияУникальныйТовар.Заголовок = НСтр("ru ='Уникальный товар'");
		Иначе
			Элементы.ДекорацияУникальныйТовар.Заголовок = "";
		КонецЕсли;
		Если ПустаяСтрока(Выборка.ПолноеНаименование) Тогда
			Элементы.ДекорацияРасшифровкаКодСтрокиТНВЭД.Заголовок = НСтр("ru ='строка с кодом " + СокрЛП(Объект.КодТНВЭД) + " не найдена.'");
		Иначе
			Элементы.ДекорацияРасшифровкаКодСтрокиТНВЭД.Заголовок = Выборка.ПолноеНаименование;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
    УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства 

&НаСервере
Процедура ИзменениеНаФорме()
	
	ПолучитьЗначениеЦеныПродажи();
	НастроитьВидимостьЭлементыУправленияЦенойПродажи();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИзменениеЦеныВРегистр(ТекущийОбъект)
	
	ПравоНаИзменениеРегистраЦен = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ЦеныНоменклатурыДокументов); 	
	
	Если ПравоНаИзменениеРегистраЦен Тогда
		
		РедактироватьВКарточкеНоменклатуры = 
			(Константы.НастройкаЗаполненияЦеныПродажи.Получить() = Перечисления.НастройкаЗаполненияЦеныПродажи.Номенклатура);
		
		Если РедактироватьВКарточкеНоменклатуры и ЦенаПродажиМодифицирована Тогда
			
			МенеджерЗаписи 						= РегистрыСведений.ЦеныНоменклатурыДокументов.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Номенклатура 		= ТекущийОбъект.Ссылка;
			МенеджерЗаписи.СпособЗаполненияЦены = Перечисления.СпособыЗаполненияЦен.ПоПродажнымЦенам;
			МенеджерЗаписи.Валюта				= ВалютаЦены;
			МенеджерЗаписи.Цена 				= ЦенаПродажи;
			МенеджерЗаписи.ЦенаВключаетНДС      = Истина;
			
			МенеджерЗаписи.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьЗначениеЦеныПродажи()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура", Объект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЦеныНоменклатурыДокументов.Цена КАК Цена,
	|	ЦеныНоменклатурыДокументов.Валюта КАК Валюта,
	|	ЦеныНоменклатурыДокументов.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	ЦеныНоменклатурыДокументов.Номенклатура.СтавкаНДС КАК СтавкаНДС
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатурыДокументов КАК ЦеныНоменклатурыДокументов
	|ГДЕ
	|	ЦеныНоменклатурыДокументов.Номенклатура = &Номенклатура
	|	И ЦеныНоменклатурыДокументов.СпособЗаполненияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаполненияЦен.ПоПродажнымЦенам)";
		
	ВыборкаДанных = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаДанных.Следующий() Тогда
		
		Если Не ВыборкаДанных.ЦенаВключаетНДС Тогда
			// В форме номенклатуры цену всегда показываем окончательную для покупателя - т.е. с НДС
			СтавкаНДС = ВыборкаДанных.СтавкаНДС;
			ЗначениеСтавкиНДС = УчетНДСиАкцизаВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтавкаНДС);
			ЦенаПродажи    = ВыборкаДанных.Цена * (1 + ЗначениеСтавкиНДС / 100);
		Иначе
			ЦенаПродажи    = ВыборкаДанных.Цена;
		КонецЕсли;
		
		ВалютаЦены         = ВыборкаДанных.Валюта;
		ВалютыЦеныБезВалют = ВыборкаДанных.Валюта;
		
	Иначе 
		
		ЦенаПродажи                    = 0;
		ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
		ВалютаЦены                     = ВалютаРегламентированногоУчета;
		ВалютыЦеныБезВалют             = ВалютаРегламентированногоУчета;
		
	КонецЕсли;
	
	ЦенаПродажиМодифицирована = Ложь;	
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьЭлементыУправленияЦенойПродажи()
	
	ИзменениеЦенПродаж = ПравоДоступа("Изменение", Метаданные.Константы.НастройкаЗаполненияЦеныПродажи);
	
	Если Не ИзменениеЦенПродаж Тогда		
		ТолькоПросмотрЦеныПродажи = Истина;	
	Иначе	
		ТолькоПросмотрЦеныПродажи = Ложь;
	КонецЕсли;
		
	Элементы.ГруппаЦенаПродажи.Видимость = Истина;
	РедактироватьВКарточкеНоменклатуры = (Константы.НастройкаЗаполненияЦеныПродажи.Получить() = Перечисления.НастройкаЗаполненияЦеныПродажи.Номенклатура);
	ЕстьВалюты = ПолучитьФункциональнуюОпцию("ИспользоватьВалютныйУчет");
	
	Если Не ТолькоПросмотрЦеныПродажи Тогда
		
		Элементы.ЦенаПродажиИзНоменклатуры.ТолькоПросмотр = Не РедактироватьВКарточкеНоменклатуры;	
			
		Если РедактироватьВКарточкеНоменклатуры Тогда

			Элементы.ВалютаЦеныПродажиСВалютами.Видимость   = ЕстьВалюты;
			Элементы.ВалютаЦеныПродажиБезВалют. Видимость   = Не ЕстьВалюты;
			
		Иначе
					
			Элементы.ВалютаЦеныПродажиСВалютами.Видимость   = Ложь;
			Элементы.ВалютаЦеныПродажиБезВалют. Видимость   = Истина;
			
		КонецЕсли;
		
	Иначе
		
		Элементы.ЦенаПродажиИзНоменклатуры.	 ТолькоПросмотр = Истина;
		Элементы.ВалютаЦеныПродажиСВалютами. Видимость      = Ложь;
		Элементы.ВалютаЦеныПродажиБезВалют.  Видимость      = Истина;
		
	КонецЕсли;
	
	
	// Установка подсказки
	
	ЭлементыСтроки = Новый Массив;
	
	Если РедактироватьВКарточкеНоменклатуры Тогда
		
		ЭлементыСтроки.Добавить(НСтр("ru = 'Если в документах продажи не установлен ""Тип цены"", тогда по умолчанию цена продажи устанавливается в карточке номенклатуры.'"));
		
	Иначе
		
		ЭлементыСтроки.Добавить(НСтр("ru = 'Если в документах продажи не установлен ""Тип цены"", тогда по умолчанию цена продажи определяется из предыдущего документа продажи.'"));
		
	КонецЕсли;
	
	ПросмотрНастроекПараметровУчета = ПравоДоступа("Просмотр", Метаданные.ОбщиеКоманды.НастройкаПараметровУчета);
	
	Если ПросмотрНастроекПараметровУчета Тогда
		ЭлементыСтроки.Добавить(Символы.ПС);
		ЭлементыСтроки.Добавить(НСтр("ru = 'Изменить настройку можно в форме '"));
		ЭлементыСтроки.Добавить(Новый ФорматированнаяСтрока("Настройка параметров учета",,,, "e1cib/command/ОбщаяКоманда.НастройкаПараметровУчета"));
	КонецЕсли;
	
	ТекстПодсказкиДляЦеныПродажи = Новый ФорматированнаяСтрока(ЭлементыСтроки);
	
	Элементы.ВалютаЦеныПродажиСВалютами.РасширеннаяПодсказка.Заголовок = ТекстПодсказкиДляЦеныПродажи;
	Элементы.ВалютаЦеныПродажиБезВалют. РасширеннаяПодсказка.Заголовок = ТекстПодсказкиДляЦеныПродажи;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКодТНВЭД(НомеклатураГСВС)
	
	Объект.КодТНВЭД = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НомеклатураГСВС, "КодГСВС");
	
КонецПроцедуры
