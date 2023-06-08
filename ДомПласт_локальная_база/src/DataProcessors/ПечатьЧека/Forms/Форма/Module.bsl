
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// общие параметры
	ДокументСсылка = Параметры.ДокументСсылка;
	Организация    = Параметры.Организация;
	Партнер        = Параметры.Партнер;
	ТорговыйОбъект = Параметры.ТорговыйОбъект;
	
	ДоступнаРаботаСКМ 	= ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.РасходныйКассовыйОрдер") 
							И ДокументСсылка.ВидОперации = Перечисления.ВидыОперацийРКО.ВозвратДенежныхСредствПокупателю;

	ПечатьФискальныхДокументовРКПереопределяемый.ЗаполнитьКонтактнуюИнформациюПоПартнеру(ЭтотОбъект, Параметры.Партнер);
	
	ОбщегоНазначенияБКВызовСервера.НастроитьПодключаемоеОборудование(ЭтаФорма);

	// выбираем оборудование и заполняем таблицу оборудования (вынести)
	Если Параметры.ПодключенноеОборудование = Неопределено Тогда
		ПодключенноеОборудование = ПечатьФискальныхДокументовРКПереопределяемый.ПодключаемоеОборудованиеОрганизации(Организация);
	Иначе
		ПодключенноеОборудование = Параметры.ПодключенноеОборудование;
		Если ПодключенноеОборудование.Свойство("ККТ") И Не ПодключенноеОборудование.Свойство("ФискальныеУстройства") Тогда
			ПодключенноеОборудование.Вставить("ФискальныеУстройства", ПодключенноеОборудование.ККТ);
		КонецЕсли; 
	КонецЕсли;
	
	ОборудованиеТерминал           = ПодключенноеОборудование.Терминал;
	ПараметрыЭквайринговойОперации = Параметры.ПараметрыЭквайринговойОперации;
	
	Если ТипЗнч(ПодключенноеОборудование.ФискальныеУстройства) = Тип("Массив") Тогда
		
		Для Каждого ЭлементМассива Из ПодключенноеОборудование.ФискальныеУстройства Цикл
			
			Оборудование = ЭлементМассива;
			ВерсияФФД = ДобавитьВТаблицуОборудования(Оборудование);
			
		КонецЦикла;
		
	Иначе
		
		Оборудование = ПодключенноеОборудование.ФискальныеУстройства;
		ВерсияФФД = ДобавитьВТаблицуОборудования(Оборудование);
		
	КонецЕсли;
	
	Элементы.Оборудование.ТолькоПросмотр = (Элементы.Оборудование.СписокВыбора.Количество() = 1);
	Элементы.НетПодключенногоОборудования.Видимость = (Элементы.Оборудование.СписокВыбора.Количество() = 0);
	Элементы.Оборудование.Видимость                 = (Элементы.Оборудование.СписокВыбора.Количество() > 0);
	Элементы.ПробитьЧек.Доступность  = (Элементы.Оборудование.СписокВыбора.Количество() > 0);
	Элементы.ПолучательИИН.Видимость = ТипЗнч(ДокументСсылка) <> Тип("ДокументСсылка.ЧекККМ");
	
	РеквизитыКассира = ПечатьФискальныхДокументовРКПереопределяемый.ПолучитьРеквизитыКассира(Параметры);
	КассирПредставление = РеквизитыКассира.Наименование;
	ПраваДоступа     = ПечатьФискальныхДокументовРКПереопределяемый.ПолучитьПраваДоступа(Пользователи.ТекущийПользователь());
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(ДокументСсылка) Тогда
		Возврат;
	КонецЕсли;
	
	//ФР подключаем, который выбран пользователем
	ИспользуемоеОборудование = ИспользуемоеОборудование();
	Для Каждого Оборудование Из ИспользуемоеОборудование Цикл
		МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПоИдентификатору(
			Новый ОписаниеОповещения("НачатьПодключениеОборудованиеПоИдентификаторуЗавершение", ЭтотОбъект, Оборудование),
			УникальныйИдентификатор,
			Оборудование);
	КонецЦикла;
	
	// Попробуем подключить сканер штрихкода, 
	ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";    			
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(
		Неопределено,
		ЭтотОбъект,
		ПоддерживаемыеТипыПодключаемогоОборудования);

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" 
		И ВводДоступен()
		И Не ТолькоПросмотр Тогда
		Если ИмяСобытия = "ScanData" Тогда
			ДанныеШтрихкодов = МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр);
			ОбработатьШтрихкоды(ДанныеШтрихкодов);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОборудованиеПриИзменении(Элемент)
	
	ВерсияФФД = ВерсияФФД(ЭтотОбъект, Оборудование);
	
	ОборудованиеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтправкиЭлектронногоЧекаSMSПриИзменении(Элемент)
	ПодготовитьПараметрыОперацииФискализацииЧекаКПередаче();	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтправкиЭлектронногоЧекаEmailПриИзменении(Элемент)
	ПодготовитьПараметрыОперацииФискализацииЧекаКПередаче();
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтправкиЭлектронногоЧекаНеОтправлятьПриИзменении(Элемент)
	ПодготовитьПараметрыОперацииФискализацииЧекаКПередаче();
КонецПроцедуры

&НаКлиенте
Процедура EmailПриИзменении(Элемент)
	ВариантОтправкиЧека = ?(ЗначениеЗаполнено(Email), 1, ВариантОтправкиЧека);	
	ПодготовитьПараметрыОперацииФискализацииЧекаКПередаче();
КонецПроцедуры

&НаКлиенте
Процедура ТелефонПриИзменении(Элемент)
	ВариантОтправкиЧека = ?(ЗначениеЗаполнено(Телефон), 2, ВариантОтправкиЧека);	
	ПодготовитьПараметрыОперацииФискализацииЧекаКПередаче();
КонецПроцедуры

&НаКлиенте
Процедура ПолучательИИНПриИзменении(Элемент)
	
	ИИНЗаполненКорректно = Истина;
	
	ТекстСообщения = "";
	Если ПустаяСтрока(ПолучательИИН) Тогда
		ИИНЗаполненКорректно = Ложь;
	ИначеЕсли НЕ ПечатьФискальныхДокументовРККлиентПереопределяемый.ИИНСоответствуетТребованиям(ПолучательИИН, ТекстСообщения) Тогда
		
		ОчиститьСообщения();
		ИИНЗаполненКорректно = Ложь;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, ,"ПолучательИИН",,);
			
	КонецЕсли;
	
	ПодготовитьПараметрыОперацииФискализацииЧекаКПередаче();
	Если ИИНЗаполненКорректно Тогда
		ОчиститьСообщения();
	КонецЕсли;
	
	ВывестиМакетЧека();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТоваровПриИзменении(Элемент)
	
	//очистить текущии позиции чека
	ПараметрыОперацииФискализацииЧека.ПозицииЧека = Новый Массив;
	
	Для каждого СтрокаТаблицыТоваров Из Объект.ТаблицаТоваров Цикл
		Если СтрокаТаблицыТоваров.Количество = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаПозицииЧека = МенеджерОборудованияКлиентСерверПереопределяемый.ПараметрыФискальнойСтрокиЧека();
		
		ЗаполнитьЗначенияСвойств(СтрокаПозицииЧека, СтрокаТаблицыТоваров,, "СтавкаНДС");
		СтавкаНДСЧислом = ПечатьФискальныхДокументовРККлиентПереопределяемый.СтавкаНДСЧислом(СтрокаТаблицыТоваров.СтавкаНДС);
		СтрокаПозицииЧека.СтавкаНДС = СтавкаНДСЧислом * 100;
		ЕдиницаИзмерения = РеквизитыЕдиницыИзмерения(СтрокаТаблицыТоваров.ЕдиницаИзмерения);
		СтрокаПозицииЧека.КодЕдиницыИзмерения = ЕдиницаИзмерения.Код;
		СтрокаПозицииЧека.НаименованиеЕдиницыИзмерения = ЕдиницаИзмерения.Наименование;
		
		Если ЗначениеЗаполнено(СтрокаТаблицыТоваров.СтавкаНДС) Тогда
			РеквизитыСтавкиНДС = ЗначенияРеквизитовОбъекта(СтрокаТаблицыТоваров.СтавкаНДС, Новый Структура("ДляОсвобожденногоОборота, МестоРеализацииНеРК"));
			СтрокаПозицииЧека.ОсвобожденныйОборотНДС = РеквизитыСтавкиНДС.ДляОсвобожденногоОборота ИЛИ РеквизитыСтавкиНДС.МестоРеализацииНеРК;
		Иначе
			СтрокаПозицииЧека.ОсвобожденныйОборотНДС = Истина;
		КонецЕсли;
	
		Если Не ЗначениеЗаполнено(СтрокаПозицииЧека.НомерСекции) Тогда
			СтрокаПозицииЧека.НомерСекции = 1;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТаблицыТоваров.КодМаркировкиBase64) Тогда 
			СтрокаПозицииЧека.ДанныеКодаТоварнойНоменклатуры.Вставить("КодМаркировкиBase64", СтрокаТаблицыТоваров.КодМаркировкиBase64);
		КонецЕсли;
		
		ПараметрыОперацииФискализацииЧека.ПозицииЧека.Добавить(СтрокаПозицииЧека);
		
	КонецЦикла;
	
	ОбновитьОбщуюСумму();
	ВывестиМакетЧека();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТоваровЦенаПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ТаблицаТоваров.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСумму", "Количество");
	ПечатьФискальныхДокументовРККлиентПереопределяемый.ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, КэшированныеЗначения);
	СтрокаТаблицы.СуммаСкидок = 0;
	РассчитатьСуммуНДС(СтрокаТаблицы);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТоваровКоличествоПриИзменении(Элемент)
		
	СтрокаТаблицы = Элементы.ТаблицаТоваров.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСумму", "Количество");
	ПечатьФискальныхДокументовРККлиентПереопределяемый.ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, КэшированныеЗначения);
	СтрокаТаблицы.СуммаСкидок = 0;
	РассчитатьСуммуНДС(СтрокаТаблицы);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТоваровСуммаПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ТаблицаТоваров.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьЦенуПоСумме", "Количество");
	ПечатьФискальныхДокументовРККлиентПереопределяемый.ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, КэшированныеЗначения);	
	СтрокаТаблицы.СуммаСкидок = 0;
	РассчитатьСуммуНДС(СтрокаТаблицы);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТоваровСтавкаНДСПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ТаблицаТоваров.ТекущиеДанные;
	РассчитатьСуммуНДС(СтрокаТаблицы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПробитьЧек(Команда)
	
	ОчиститьСообщения();
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	//проверка общей суммы
	Если ВсегоПоЧеку <> СуммаДокумента Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Сумма позиций по чеку отличается от общей суммы оплаты!'"));
		Возврат;
		
	КонецЕсли;

	Если ЗначениеЗаполнено(ОборудованиеТерминал) Тогда
		
		Если ПараметрыЭквайринговойОперации = Неопределено Тогда
			
			ПечатьФискальныхДокументовРККлиентПереопределяемый.ОбработатьСостояниеСмены(
				ЭтотОбъект,
				Новый ОписаниеОповещения("ПослеОбработкиСостоянияСмены", ЭтотОбъект));
				
		Иначе
			
			ПараметрыОткрытияФормы = Новый Структура;
			ПараметрыОткрытияФормы.Вставить("ТипТранзакции",               ПараметрыЭквайринговойОперации.ТипТранзакции);
			ПараметрыОткрытияФормы.Вставить("Сумма",                       ПараметрыЭквайринговойОперации.Сумма);
			ПараметрыОткрытияФормы.Вставить("ПределСуммы",                 ПараметрыЭквайринговойОперации.Сумма);
			ПараметрыОткрытияФормы.Вставить("УказатьДополнительныеДанные", ПараметрыЭквайринговойОперации.ТипТранзакции = "AuthorizeRefund");
			ОповещениеЗавершение = Новый ОписаниеОповещения("ОплатитьКартойЗавершение", ЭтотОбъект, ПараметрыОткрытияФормы);
			
			ПечатьФискальныхДокументовРККлиентПереопределяемый.ОплатитьКартой(ЭтотОбъект, ОповещениеЗавершение); 
			
		КонецЕсли;
		
	Иначе
		ПечатьФискальныхДокументовРККлиентПереопределяемый.ОбработатьСостояниеСмены(
				ЭтотОбъект,
				Новый ОписаниеОповещения("ПослеОбработкиСостоянияСмены", ЭтотОбъект));		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВывестиМакетЧека()
	
	ТекстЧека = МенеджерОборудованияКлиентСерверПереопределяемый.СформироватьТекстНефискальногоЧека(ПараметрыОперацииФискализацииЧека, 34, ВерсияФФД);
	ТекстовыйДокумент.УстановитьТекст(ТекстЧека);
	
КонецФункции

&НаСервере
Процедура РассчитатьСуммы()
	
	Суммы = Оплаты(ПараметрыОперацииФискализацииЧека);
	
	СуммаДокумента  = Суммы.Всего;
	СуммаНаличные   = Суммы.ОплатаНаличные;
	СуммаКартой     = Суммы.ОплатаПлатежнаяКарта;
	СуммаПостоплаты = Суммы.Кредит;
	СуммаПредоплаты = Суммы.Предоплата;
	
	Элементы.Предоплата.Видимость = (СуммаПредоплаты > 0);
	Элементы.Наличные.Видимость   = (СуммаНаличные > 0);
	Элементы.Электронно.Видимость = (СуммаКартой > 0);
	Элементы.Кредит.Видимость     = (СуммаПостоплаты > 0);
	
КонецПроцедуры

&НаСервере
Функция Оплаты(ПараметрыОперацииФискализацииЧека)
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Всего",                0);
	ВозвращаемоеЗначение.Вставить("ОплатаНаличные",       0);
	ВозвращаемоеЗначение.Вставить("ОплатаПлатежнаяКарта", 0);
	ВозвращаемоеЗначение.Вставить("Кредит",               0);
	ВозвращаемоеЗначение.Вставить("Предоплата",           0);
	
	Для Каждого СтрокаОплаты Из ПараметрыОперацииФискализацииЧека.ТаблицаОплат Цикл
		
		ВозвращаемоеЗначение.Всего = ВозвращаемоеЗначение.Всего + СтрокаОплаты.Сумма;
		
		Если СтрокаОплаты.ТипОплаты = Перечисления.ТипыОплатыККТ.Наличные Тогда
			ВозвращаемоеЗначение.ОплатаНаличные = ВозвращаемоеЗначение.ОплатаНаличные + СтрокаОплаты.Сумма;
		КонецЕсли;
		
		Если СтрокаОплаты.ТипОплаты = Перечисления.ТипыОплатыККТ.Электронно Тогда
			ВозвращаемоеЗначение.ОплатаПлатежнаяКарта = ВозвращаемоеЗначение.ОплатаПлатежнаяКарта + СтрокаОплаты.Сумма;
		КонецЕсли;
		
		Если СтрокаОплаты.ТипОплаты = Перечисления.ТипыОплатыККТ.Постоплата Тогда
			ВозвращаемоеЗначение.Кредит = СтрокаОплаты.Сумма;
		КонецЕсли;
		
		Если СтрокаОплаты.ТипОплаты = Перечисления.ТипыОплатыККТ.Предоплата Тогда
			ВозвращаемоеЗначение.Предоплата = СтрокаОплаты.Сумма;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаСервере
Процедура ОборудованиеПриИзмененииНаСервере()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПодключаемоеОборудование.ТипОборудования КАК ТипОборудования,
	|	ПодключаемоеОборудование.СерийныйНомер   КАК СерийныйНомер
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Оборудование);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ПараметрыККТ = Новый Структура;
	ПараметрыККТ.Вставить("ТипОборудования",         Выборка.ТипОборудования);
	ПараметрыККТ.Вставить("СерийныйНомер",           Выборка.СерийныйНомер);
	ПараметрыККТ.Вставить("ИдентификаторУстройства", Оборудование);
	
	ПараметрыОперацииФискализацииЧека = ПечатьФискальныхДокументовРКПереопределяемый.ПараметрыОперацииФискализацииЧека(ДокументСсылка, 0, ВерсияФФДПараметровФискализации(ВерсияФФД));
	
	Если ПараметрыОперацииФискализацииЧека <> Неопределено Тогда
		
		ПолучательИИН = ПараметрыОперацииФискализацииЧека.ПолучательИИН;
		
		ПодготовитьПараметрыОперацииФискализацииЧекаКПередаче();
		
		РассчитатьСуммы();
		
		ВывестиМакетЧека();
		
		ВывестиЧекВТаблицу();
		
	Иначе
		
		Элементы.ПробитьЧек.Доступность   = Ложь;
		
	КонецЕсли;
	
	Элементы.ГруппаОтправкаЭлектронногоЧека.Видимость = (ПараметрыККТ.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ);
	
	ДрайверОборудования = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыККТ.ИдентификаторУстройства, "ДрайверОборудования");
	Если ЗначениеЗаполнено(ДрайверОборудования) Тогда
		ОбработчикДрайвера = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДрайверОборудования, "ОбработчикДрайвера");
		Если ОбработчикДрайвера = Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикWebkassaФискальныеРегистраторы Тогда
			Элементы.ГруппаОтправкаЭлектронногоЧека.Видимость = Истина;
			Элементы.ГруппаОтправитьSMS.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ИспользуемоеОборудование()
	
	ИспользуемоеОборудование = Новый Массив;
	Если ПараметрыЭквайринговойОперации <> Неопределено
		И ЗначениеЗаполнено(ОборудованиеТерминал) Тогда
		ИспользуемоеОборудование.Добавить(ОборудованиеТерминал);
	КонецЕсли;
	Для Каждого Оборудование Из Элементы.Оборудование.СписокВыбора.ВыгрузитьЗначения() Цикл
		ИспользуемоеОборудование.Добавить(Оборудование);
	КонецЦикла;
	
	Возврат ИспользуемоеОборудование;
	
КонецФункции

&НаСервере
Процедура ПодготовитьПараметрыОперацииФискализацииЧекаКПередаче()
	
	Если ВариантОтправкиЧека = 1 Тогда
		//email
		ПараметрыОперацииФискализацииЧека.ПокупательEmail = Email;
		ПараметрыОперацииФискализацииЧека.ПокупательНомер = "";
	ИначеЕсли ВариантОтправкиЧека = 2 Тогда  
		//телефон
		ПараметрыОперацииФискализацииЧека.ПокупательEmail = "";
		ПараметрыОперацииФискализацииЧека.ПокупательНомер = Телефон;
	Иначе
		//не отправлять
		ПараметрыОперацииФискализацииЧека.ПокупательEmail = "";
		ПараметрыОперацииФискализацииЧека.ПокупательНомер = "";
	КонецЕсли; 
	
	ПараметрыОперацииФискализацииЧека.Кассир    = РеквизитыКассира.Наименование;
	ПараметрыОперацииФискализацииЧека.КассирИНН = РеквизитыКассира.ИНН;
	
	// Для совместмости с фискальными регистраторами
	ПараметрыОперацииФискализацииЧека.СерийныйНомер = ПараметрыККТ.СерийныйНомер;
	
	// Для принтера чеков
	ПараметрыОперацииФискализацииЧека.НомерКассы = "00001";
	ПараметрыОперацииФискализацииЧека.НомерЧека  = 1;
	ПараметрыОперацииФискализацииЧека.НомерСмены = 1;
	ПараметрыОперацииФискализацииЧека.ДатаВремя  = ТекущаяДатаСеанса();
	ПараметрыОперацииФискализацииЧека.КопийЧека  = 1;
	
	//Дополнительные поля в чеке
	ПараметрыОперацииФискализацииЧека.ПолучательИИН = ПолучательИИН;
	
	Если (ПараметрыККТ.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ) Тогда
		ФорматноЛогическийКонтрольКлиентСервер.ПровестиФорматноЛогическийКонтроль(ПараметрыОперацииФискализацииЧека, ПараметрыККТ.ИдентификаторУстройства);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьКартойЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОперации = МенеджерОборудованияКлиент.ПараметрыВыполненияЭквайринговойОперации();
	ПараметрыОперации.ТипТранзакции  = ДополнительныеПараметры.ТипТранзакции;
	ПараметрыОперации.СуммаОперации  = Результат.Сумма;
	ПараметрыОперации.НомерЧека      = Результат.НомерЧека;
	ПараметрыОперации.СсылочныйНомер = Результат.СсылочныйНомер;
	
	Оповещение = Новый ОписаниеОповещения("ПослеВыполненияОперацииНаЭквайринговомТерминале", ЭтотОбъект, ДополнительныеПараметры);
	МенеджерОборудованияКлиент.НачатьВыполнениеОперацииНаЭквайринговомТерминале(
		Оповещение, УникальныйИдентификатор,
		ОборудованиеТерминал,
		ПараметрыККТ.ИдентификаторУстройства,
		ПараметрыОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыполненияОперацииНаЭквайринговомТерминале(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		
		Модифицированность = Истина;
		
		ВладелецФормы.Объект.НомерПлатежнойКарты = РезультатВыполнения.НомерКарты;
		ВладелецФормы.Объект.КодАвторизации      = РезультатВыполнения.КодАвторизации;
		ВладелецФормы.Объект.ОплатаВыполнена     = Истина;
		
		ОповещениеЗавершение = Новый ОписаниеОповещения("ПослеЗаписиОперацииПоПлатежнойКарте", ЭтотОбъект, ДополнительныеПараметры);
		ПечатьФискальныхДокументовРККлиентПереопределяемый.ЗаписатьОбъектЭквайринговаяОперация(ВладелецФормы, ОповещениеЗавершение);
		
	Иначе
		
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'При выполнении операции возникла ошибка:
				|""%1"".
				|Оплата по карте не была произведена.'"),
			РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписиОперацииПоПлатежнойКарте(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено
		И Результат Тогда
		
		ПечатьФискальныхДокументовРККлиентПереопределяемый.ОбработатьСостояниеСмены(
			ЭтотОбъект,
			Новый ОписаниеОповещения("ПослеОбработкиСостоянияСмены", ЭтотОбъект));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОбработкиСостоянияСмены(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение        = Новый ОписаниеОповещения("ПечатьЧека_Завершение", ЭтотОбъект);
	ПослеОткрытияЧека = Новый ОписаниеОповещения("ПечатьЧека_ПослеОткрытияЧека",  ЭтотОбъект);

	МенеджерОборудованияКлиент.НачатьФискализациюЧекаНаФискальномУстройстве(
		Оповещение,
		УникальныйИдентификатор,
		ПараметрыОперацииФискализацииЧека,
		ПараметрыККТ.ИдентификаторУстройства,
		ПослеОткрытияЧека);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьЧека_ПослеОткрытияЧека(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	ШапкаЧека = ПараметрыВыполнения.ВходныеПараметры;
	
	ШапкаЧека.НомерСмены = ПараметрыВыполнения.НомерСмены;
	ШапкаЧека.НомерЧека  = ПараметрыВыполнения.НомерЧека;
	
	ВыполнитьОбработкуОповещения(ПараметрыВыполнения.ОповещениеПродолжения, ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьЧека_Завершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		
		//дополнительная обработка результата (запись в журнал фискальных операций и тп)
		ПечатьФискальныхДокументовРККлиентПереопределяемый.ОбработатьРезультатаЧека(ЭтотОбъект, РезультатВыполнения.ВыходныеПараметры, Оплаты(ПараметрыОперацииФискализацииЧека));
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'При печати чека произошла ошибка.
		                            |Чек не напечатан на фискальном устройстве.
		                            |Дополнительное описание:
		                            |%ДополнительноеОписание%'");
		
		ТекстСообщения = СтрЗаменить(
			ТекстСообщения,
			"%ДополнительноеОписание%",
			РезультатВыполнения.ОписаниеОшибки);
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияПараметровУстройства(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		
		Если ЗначениеЗаполнено(РезультатВыполнения.ВыходныеПараметры.ВерсияФФДККТ) Тогда
			ДополнительныеПараметры.СтрокаТЧ.ВерсияФФД = РезультатВыполнения.ВыходныеПараметры.ВерсияФФДККТ;
		Иначе
			ДополнительныеПараметры.СтрокаТЧ.ВерсияФФД = ВерсияФФДПоУмолчанию();
		КонецЕсли;
		
	Иначе
		
		ДополнительныеПараметры.СтрокаТЧ.ВерсияФФД = ВерсияФФДПоУмолчанию();
		
	КонецЕсли;
	
	Если ДополнительныеПараметры.СтрокаТЧ.Оборудование = Оборудование Тогда
		ВерсияФФД = ДополнительныеПараметры.СтрокаТЧ.ВерсияФФД;
	КонецЕсли;
	
	ОборудованиеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьПодключениеОборудованиеПоИдентификаторуЗавершение(Данные, Оборудование) Экспорт
	
	Если Данные.Результат Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Оборудование", Оборудование);
		НайденныеСтроки = ТаблицаОборудования.НайтиСтроки(ПараметрыОтбора);
		Для Каждого СтрокаТЧ Из НайденныеСтроки Цикл
			
			СтрокаТЧ.Подключено = Истина;
			
			Если Не СтрокаТЧ.СчитанаВерсияФФД Тогда
				
				ДополнительныеПараметры = Новый Структура;
				ДополнительныеПараметры.Вставить("СтрокаТЧ", СтрокаТЧ);
				
				МенеджерОборудованияКлиент.НачатьПолучениеПараметровФискальногоУстройства(
					Новый ОписаниеОповещения("ПослеПолученияПараметровУстройства", ЭтотОбъект, ДополнительныеПараметры),
					ЭтаФорма.УникальныйИдентификатор, Оборудование, Ложь);
					
			Иначе
				
				Если СтрокаТЧ.Оборудование = Оборудование Тогда
					ВерсияФФД = СтрокаТЧ.ВерсияФФД;
				КонецЕсли;
				
				ОборудованиеПриИзмененииНаСервере();
				
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтрШаблон(
				НСтр("ru = 'При подключении устройства %1 произошла ошибка:
				           |""%2"".'"),
				Оборудование, 
				Данные.ОписаниеОшибки));
				
		УстановитьДоступностьЭлементовФормы(Ложь);

		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОтключениеОборудованиеПоИдентификаторуЗавершение(Данные, Оборудование) Экспорт
	
	Если Не Данные.Результат Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтрШаблон(
				НСтр("ru = 'При отключении устройства %1 произошла ошибка:
				           |""%2"".'"),
				Оборудование, 
				Данные.ОписаниеОшибки));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементовФормы(Доступность) Экспорт
	
	Элементы.ПробитьЧек.Доступность = Доступность;
	Элементы.ГруппаОтправкаЭлектронногоЧека.Доступность = Доступность;
	Элементы.ТаблицаТоваров.Доступность = Доступность;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ВерсияФФД(Форма, Оборудование)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Оборудование", Оборудование);
	НайденныеСтроки = Форма.ТаблицаОборудования.НайтиСтроки(ПараметрыОтбора);
	Если НайденныеСтроки.Количество() > 0 Тогда
		Возврат НайденныеСтроки[0].ВерсияФФД;
	Иначе
		Возврат ВерсияФФДПоУмолчанию();
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ВерсияФФДПараметровФискализации(ЗначениеВерсияФФД)
	
	Если ЗначениеВерсияФФД = МаксимальнаяВерсияФФД() Тогда
		Возврат АктуальнаяВерсияФФД();
	Иначе
		Возврат ЗначениеВерсияФФД;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВерсияФФДПоУмолчанию()
	
	Возврат "1.0";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция МаксимальнаяВерсияФФД()
	
	Возврат "1.1";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция АктуальнаяВерсияФФД()
	
	Возврат "1.0.5";
	
КонецФункции

&НаСервере
Функция ДобавитьВТаблицуОборудования(ПодключаемоеОборудование)
	
	ТипОборудования = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПодключаемоеОборудование, "ТипОборудования");
	
	СчитанаВерсияФФД = Ложь;
	ЗначениеВерсияФФД = "";
	Если ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ПринтерЧеков Тогда
		СчитанаВерсияФФД = Истина;
		ЗначениеВерсияФФД = ВерсияФФДПоУмолчанию();
	ИначеЕсли ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ФискальныйРегистратор Тогда
		СчитанаВерсияФФД = Истина;
		ЗначениеВерсияФФД = ВерсияФФДПоУмолчанию();
	Иначе
		
		ПараметрыРегистрацииУстройства = МенеджерОборудованияВызовСервера.ПолучитьПараметрыРегистрацииУстройства(ПодключаемоеОборудование);
		Если ПараметрыРегистрацииУстройства.ЕстьДанные Тогда
			ЗначениеВерсияФФД = ПараметрыРегистрацииУстройства.ВерсияФФДККТ;
		Иначе
			ЗначениеВерсияФФД = ВерсияФФДПоУмолчанию();
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.Оборудование.СписокВыбора.Добавить(ПодключаемоеОборудование);
	НовоеОборудование = ТаблицаОборудования.Добавить();
	НовоеОборудование.Оборудование     = ПодключаемоеОборудование;
	НовоеОборудование.ВерсияФФД        = ЗначениеВерсияФФД;
	НовоеОборудование.СчитанаВерсияФФД = СчитанаВерсияФФД;
	
	Возврат ЗначениеВерсияФФД;
	
КонецФункции

&НаСервере
Функция ВывестиЧекВТаблицу()
	
	Объект.ТаблицаТоваров.Очистить();
	Для каждого ПозицияЧека Из ПараметрыОперацииФискализацииЧека.ПозицииЧека Цикл
		НоваяСтрока = Объект.ТаблицаТоваров.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ПозицияЧека,,"СтавкаНДС");
		
		Если ПозицияЧека.Свойство("СтавкаНДССсылка") Тогда
			НоваяСтрока.СтавкаНДС = ПозицияЧека.СтавкаНДССсылка;
			ПозицияЧека.Удалить("СтавкаНДССсылка");
		Иначе
			НоваяСтрока.СтавкаНДС = ПечатьФискальныхДокументовРКПереопределяемый.ЗначениеСтавкиНДС(ПозицияЧека.СтавкаНДС);
		КонецЕсли;
		
		НоваяСтрока.ЕдиницаИзмерения = ПечатьФискальныхДокументовРКПереопределяемый.ЕдиницаИзмеренияПоКоду(ПозицияЧека.КодЕдиницыИзмерения);	
		
	КонецЦикла;
	
	ОбновитьОбщуюСумму();
	
КонецФункции

&НаСервере
Процедура ОбновитьОбщуюСумму()
	
	ВсегоПоЧеку = Объект.ТаблицаТоваров.Итог("Сумма");
	Если ВсегоПоЧеку <> СуммаДокумента Тогда
		Элементы.ГруппаСуммыРазличаются.Видимость = Истина;		
	Иначе
		Элементы.ГруппаСуммыРазличаются.Видимость = Ложь;		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КодЕдиницыИзмерения(Ссылка, ИмяРеквизита)
	                                                         
	Возврат ПечатьФискальныхДокументовРКПереопределяемый.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
	
КонецФункции

&НаСервереБезКонтекста
Функция РеквизитыЕдиницыИзмерения(Ссылка)
	
	ЕдиницаИзмерения = Новый Структура;
	ЕдиницаИзмерения.Вставить("Код", ПечатьФискальныхДокументовРКПереопределяемый.ЗначениеРеквизитаОбъекта(Ссылка, "Код"));
	ЕдиницаИзмерения.Вставить("Наименование", ПечатьФискальныхДокументовРКПереопределяемый.ЗначениеРеквизитаОбъекта(Ссылка, "Наименование"));
	Возврат ЕдиницаИзмерения;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗначенияРеквизитовОбъекта(Ссылка, Реквизиты)
	
	ЗначенияРеквизитов = Новый Структура;
	Для Каждого Реквизит Из Реквизиты Цикл
		ЗначенияРеквизитов.Вставить(Реквизит.Ключ, ПечатьФискальныхДокументовРКПереопределяемый.ЗначениеРеквизитаОбъекта(Ссылка, Реквизит.Ключ));
	КонецЦикла;
	Возврат ЗначенияРеквизитов;
	
КонецФункции

&НаКлиенте
Процедура РассчитатьСуммуНДС(СтрокаТаблицыТоваров)
	
	СтавкаНДСЧислом = ПечатьФискальныхДокументовРККлиентПереопределяемый.СтавкаНДСЧислом(СтрокаТаблицыТоваров.СтавкаНДС) * 100;
	СтрокаТаблицыТоваров.СуммаНДС = Окр(СтавкаНДСЧислом * 0.01 * СтрокаТаблицыТоваров.Сумма / (1 + СтавкаНДСЧислом / 100), 2);
	
КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов, ЗагрузкаИзТСД = Ложь)

	ШтрихКодКоличество = ДанныеШтрихкодов[0];
	
	Если ИмеютсяНедопустимыеСимволы(ШтрихКодКоличество.ШтрихКод) > 0 Тогда
		ШтрихкодированиеИСМПТККлиентСервер.ЗакодироватьШтрихкодДанныхBase64(ШтрихКодКоличество);
	КонецЕсли;
	
	ОбработатьШтрихкодСервер(ШтрихКодКоличество);
	
КонецПроцедуры

&НаКлиенте
Функция ИмеютсяНедопустимыеСимволы(ШтрихКод)
    
    РазделительGS1 = ПодключаемоеОборудованиеИСМПТККлиентСервер.РазделительGS1();
    Возврат Не СтрНайти(ШтрихКод, РазделительGS1) = 0;
    
КонецФункции

&НаСервере
Процедура ОбработатьШтрихкодСервер(ШтрихКодКоличество)
	
	ШтрихкодированиеИСМПТККлиентСервер.ДекодироватьШтрихкодДанныхBase64(ШтрихКодКоличество);
	ТипШтрихКода = МенеджерОборудованияКлиентСервер.ОпределитьТипШтрихкода(ШтрихКодКоличество.Штрихкод);
	
	КодМаркировки 	= "";
	ШтрихкодEAN		= ШтрихКодКоличество.Штрихкод;
	
	Если ТипШтрихКода = "CODE128" Тогда
		СтруктураРазбора = РазборКодаМаркировкиИСМПТКСлужебный.РазобратьКодМаркировки(ШтрихКодКоличество.Штрихкод);
		ШтрихкодированиеИСМПТККлиентСервер.ЗакодироватьШтрихкодДанныхBase64(ШтрихКодКоличество);
		Если Не СтруктураРазбора = Неопределено Тогда
			КодМаркировки 				= ШтрихКодКоличество.Штрихкод;
			ШтрихкодEAN					= СтруктураРазбора.СоставКодаМаркировки.EAN;
		КонецЕсли;
	Иначе
		КодМаркировки 	= "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КодМаркировки) И Не ДоступнаРаботаСКМ Тогда 
		
		ТекстСообщения = НСтр("ru = 'Добавление кодов маркировки доступно только для РКО с видом операции Возврат оплаты покупателю.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	ИначеЕсли ЗначениеЗаполнено(КодМаркировки) И
				Объект.ТаблицаТоваров.НайтиСтроки(Новый Структура("КодМаркировкиBase64", КодМаркировки)).Количество() > 0 Тогда 
		
		ТекстСообщения = НСтр("ru = 'В формируемый чек уже добавлен сканируемый код маркировки.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
	Иначе
		
		КэшированныеЗначения = Новый Структура("Штрихкоды", Новый Соответствие);
		ШтрихкодыEAN = Новый Массив;
		ШтрихкодыEAN.Добавить(ШтрихкодEAN);
				
		ТаблицаНоменклатурыПоШтрихкоду = РегистрыСведений.ШтрихкодыНоменклатуры.НоменклатураПоШтрихкоду(ШтрихкодEAN);
		Если ТаблицаНоменклатурыПоШтрихкоду.Количество() = 1  Тогда
			
			ДобавитьСтрокуСканирование(ТаблицаНоменклатурыПоШтрихкоду[0], КодМаркировки);
			
		КонецЕсли;  		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуСканирование(СтуктураДанныхНоменклатуры, КодМаркировки)
	
	НаименованиеТовара 	= ?(ЗначениеЗаполнено(СтуктураДанныхНоменклатуры.Номенклатура), ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтуктураДанныхНоменклатуры.Номенклатура, "Наименование"),
							"Неопределённый товар");
	СтавкаНДС 			= ?(ЗначениеЗаполнено(СтуктураДанныхНоменклатуры.Номенклатура), ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтуктураДанныхНоменклатуры.Номенклатура, "СтавкаНДС"),
							Справочники.СтавкиНДС.ПустаяСсылка());
	ЕдиницаИзмерения 	= ?(ЗначениеЗаполнено(СтуктураДанныхНоменклатуры.Номенклатура), ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтуктураДанныхНоменклатуры.Номенклатура, "БазоваяЕдиницаИзмерения"),
							Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка());
	
	НоваяСтрока = Объект.ТаблицаТоваров.Добавить();
	НоваяСтрока.Наименование 		= НаименованиеТовара;
	НоваяСтрока.ЕдиницаИзмерения 	= ЕдиницаИзмерения;
	НоваяСтрока.Количество 			= 1;
	НоваяСтрока.СтавкаНДС 			= СтавкаНДС;
		
	Если ЗначениеЗаполнено(КодМаркировки) Тогда
		НоваяСтрока.КодМаркировкиBase64	= КодМаркировки;
		НоваяСтрока.КодМаркировки		= Истина;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти