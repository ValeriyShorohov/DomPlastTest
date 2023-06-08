///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстВыбора;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Запретим создание новых
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Взаимодействия.УстановитьЗаголовокФормыЭлектронногоПисьма(ЭтотОбъект);
	ЗапрещенныеРасширения = РаботаСФайламиСлужебный.СписокЗапрещенныхРасширений();
	
	// Заполним список выбора для поля РассмотретьПосле.
	Взаимодействия.ЗаполнитьСписокВыбораДляРассмотретьПосле(Элементы.РассмотретьПосле.СписокВыбора);
	Если Рассмотрено Тогда
		Элементы.РассмотретьПосле.Доступность = Ложь;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "СтраницаДополнительныеРеквизиты");
		ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Если Объект.Ссылка.Пустая() Тогда
		Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ВключитьНебезопасноеСодержимое = Ложь;
	
	Взаимодействия.УстановитьРеквизитыФормыВзаимодействияПоДаннымРегистра(ЭтотОбъект);
	
	Вложения.Очистить();
	ТаблицаВложения = УправлениеЭлектроннойПочтой.ПолучитьВложенияЭлектронногоПисьма(Объект.Ссылка, Истина);
	
	Если ТаблицаВложения.Количество() > 0 Тогда
		
		НайденныеСтроки = ТаблицаВложения.НайтиСтроки(Новый Структура("ИДФайлаЭлектронногоПисьма", ""));
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(НайденныеСтроки, Вложения);
		
	КонецЕсли;
	
	Для Каждого УдаленноеВложение Из ТекущийОбъект.НепринятыеВложения Цикл
		
		НовоеВложение = Вложения.Добавить();
		НовоеВложение.ИмяФайла = УдаленноеВложение.ИмяВложение;
		НовоеВложение.ИндексКартинки = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(".msg") + 1;
		
	КонецЦикла;
	
	Если Вложения.Количество() = 0 Тогда
		
		Элементы.Вложения.Видимость = Ложь;
		
	КонецЕсли;
	
	// Установим текст и вид текста.
	Если Объект.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML Тогда
		ПрочитатьТекстПисьмаHTML();
		Элементы.ТекстПисьма.Вид = ВидПоляФормы.ПолеHTMLДокумента;
		Элементы.ТекстПисьма.ТолькоПросмотр = Ложь;
	Иначе
		ТекстПисьма = Объект.Текст;
		Элементы.ТекстПисьма.Вид = ВидПоляФормы.ПолеТекстовогоДокумента;
	КонецЕсли;
	УстановитьВидимостьПредупрежденияБезопасности();
	
	// Сформируем представление отправителя.
	ОтправительПредставление = ВзаимодействияКлиентСервер.ПолучитьПредставлениеАдресата(
		Объект.ОтправительПредставление, Объект.ОтправительАдрес,"");
	
	// Сформируем представление Кому и Копии.
	ПолучателиПредставление =
		ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(Объект.ПолучателиПисьма, Ложь);
	ПолучателиКопийПредставление =
		ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(Объект.ПолучателиКопий, Ложь);
	ПолучателиОтветаПредставление = 
		ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(Объект.ПолучателиОтвета, Ложь);
		
	Если ПустаяСтрока(ПолучателиКопийПредставление) Тогда
		Элементы.ПолучателиКопийПредставление.Видимость = Ложь;
	КонецЕсли;

	ЗаполнитьДополнительнуюИнформацию();
	
	ОбработатьНеобходимостьУведомленияОПрочтении();
	
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект, ЭтотОбъект, "ЭлектронноеПисьмоВходящее");
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения

	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
		МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		Если МодульУправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
			ОбновитьЭлементыДополнительныхРеквизитов();
			МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	ВзаимодействияКлиент.ОтработатьОповещение(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.УточнениеКонтактов") Тогда
		
		Если ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") Тогда
			Возврат;
		КонецЕсли;
		
		ЗаполнитьУточненныеКонтакты(ВыбранноеЗначение);
		ИзменилисьКонтакты = Истина;
		Модифицированность = Истина;
		
	Иначе
		
		ВзаимодействияКлиент.ФормаОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора, КонтекстВыбора);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, РежимЗаписи, РежимПроведения)
	
	Взаимодействия.ПередЗаписьюВзаимодействияИзФормы(ЭтотОбъект, ТекущийОбъект, ИзменилисьКонтакты);
	
	Если Рассмотрено И ТребуетсяУстановкаФлагаОтправкиУведомления Тогда
		УстановитьПризнакОтправкиУведомления(Объект.Ссылка, Истина);
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Взаимодействия.ПриЗаписиВзаимодействияИзФормы(ТекущийОбъект, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницыОписаниеДополнительноПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства")
		И ТекущаяСтраница.Имя = "СтраницаДополнительныеРеквизиты"
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		
		СвойстваВыполнитьОтложеннуюИнициализацию();
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура РассмотретьПослеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВзаимодействияКлиент.ОбработатьВыборВПолеРассмотретьПосле(РассмотретьПосле,
	                                                          ВыбранноеЗначение,
	                                                          СтандартнаяОбработка,
	                                                          Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура РассмотреноПриИзменении(Элемент)
	
	Элементы.РассмотретьПосле.Доступность = НЕ Рассмотрено;
	Если Рассмотрено И ТребуетсяЗапросУведомленияОПрочтении Тогда
		
		ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ВопросОНеобходимостиОтправкиУведомленияОПрочтенииПослеЗавершения", ЭтотОбъект);
		ПоказатьВопрос(ОбработчикОповещенияОЗакрытии,
		       НСтр("ru = 'Отправитель запросил уведомление о прочтении. Отправить?'"),
		       РежимДиалогаВопрос.ДаНет,
		       ,
		       КодВозвратаДиалога.Да,
		       НСтр("ru = 'Запрос уведомления'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьПолучателей()
	
	// Получим список адресатов
	МассивОтправителей = Новый Массив;
	МассивОтправителей.Добавить(Новый Структура("Адрес,Представление,Контакт",
		Объект.ОтправительАдрес,
		Объект.ОтправительПредставление, 
		Объект.ОтправительКонтакт));
	
	СписокПолучателей = Новый СписокЗначений;
	СписокПолучателей.Добавить(МассивОтправителей, "Отправитель");
	СписокПолучателей.Добавить(
		УправлениеЭлектроннойПочтойКлиент.ТаблицуКонтактовВМассив(Объект.ПолучателиПисьма), "Получатели");
	СписокПолучателей.Добавить(
		УправлениеЭлектроннойПочтойКлиент.ТаблицуКонтактовВМассив(Объект.ПолучателиКопий),  "Копии");
	СписокПолучателей.Добавить(
		УправлениеЭлектроннойПочтойКлиент.ТаблицуКонтактовВМассив(Объект.ПолучателиОтвета), "Ответ");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УчетнаяЗапись", Объект.УчетнаяЗапись);
	ПараметрыФормы.Вставить("СписокВыбранных", СписокПолучателей);
	ПараметрыФормы.Вставить("Предмет", Предмет);
	ПараметрыФормы.Вставить("Письмо", Объект.Ссылка);
	
	// Откроем форму для редактирования списка адресатов.
	ОткрытьФорму("ОбщаяФорма.УточнениеКонтактов", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьУточненныеКонтакты(Результат)
	
	Объект.ПолучателиКопий.Очистить();
	Объект.ПолучателиОтвета.Очистить();
	Объект.ПолучателиПисьма.Очистить();
	
	Для каждого ЭлементМассива Из Результат Цикл
	
		Если ЭлементМассива.Группа = "Получатели" Тогда
			ТаблицаПолучателей = Объект.ПолучателиПисьма;
		ИначеЕсли ЭлементМассива.Группа = "Копии" Тогда
			ТаблицаПолучателей = Объект.ПолучателиКопий;
		ИначеЕсли ЭлементМассива.Группа = "Ответ" Тогда
			ТаблицаПолучателей = Объект.ПолучателиОтвета;
		ИначеЕсли ЭлементМассива.Группа = "Отправитель" Тогда
			Объект.ОтправительАдрес = ЭлементМассива.Адрес;
			Объект.ОтправительКонтакт = ЭлементМассива.Контакт;
			Продолжить;
		Иначе
			Продолжить;
		КонецЕсли;
		
		СтрокаПолучатели = ТаблицаПолучателей.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПолучатели,ЭлементМассива);
	
	КонецЦикла;
	
	// Сформируем представление отправителя.
	ОтправительПредставление = ВзаимодействияКлиентСервер.ПолучитьПредставлениеАдресата(
		Объект.ОтправительПредставление, Объект.ОтправительАдрес, "");
	
	// Сформируем представление Кому и Копии.
	ПолучателиПредставление       =
		ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(Объект.ПолучателиПисьма, Ложь);
	ПолучателиКопийПредставление  =
		ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(Объект.ПолучателиКопий, Ложь);
	ПолучателиОтветаПредставление = 
		ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(Объект.ПолучателиОтвета, Ложь);
	
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект, ЭтотОбъект, "ЭлектронноеПисьмоВходящее");

КонецПроцедуры

&НаКлиенте
Процедура ОтправительПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Объект.ОтправительКонтакт) Тогда
		ПоказатьЗначение(, Объект.ОтправительКонтакт);
	Иначе
		РедактироватьПолучателей();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстПисьмаПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ВзаимодействияКлиент.ПолеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВзаимодействияКлиент.ПредметНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредупреждениеОНебезопасномСодержимомОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	Если НавигационнаяСсылкаФорматированнойСтроки = "ВключитьНебезопасноеСодержимое" Тогда
		СтандартнаяОбработка = Ложь;
		ВключитьНебезопасноеСодержимое = Истина;
		ПрочитатьТекстПисьмаHTML();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВложения

&НаКлиенте
Процедура ВложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьВложение();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Вложения.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВложениеСуществует = ЗначениеЗаполнено(ТекущиеДанные.Ссылка);
	Элементы.ВложенияКонтекстноеМенюСвойстваВложения.Доступность = ВложениеСуществует;
	Элементы.ОткрытьВложение.Доступность = ВложениеСуществует;
	Элементы.СохранитьВложение.Доступность = ВложениеСуществует;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьВложениеВыполнить()
	
	ОткрытьВложение();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВложениеВыполнить()
	
	ТекущиеДанные = Элементы.Вложения.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если НЕ ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
			Возврат;
		КонецЕсли;
		
		ДанныеФайла = РаботаСФайламиКлиент.ДанныеФайла(
			ТекущиеДанные.Ссылка, УникальныйИдентификатор);
		
		РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УточнитьКонтакты(Команда)
	
	РедактироватьПолучателей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПисьма(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Создано",             Объект.Дата);
	ПараметрыФормы.Вставить("Получено",            Объект.ДатаПолучения);
	ПараметрыФормы.Вставить("УведомитьОДоставке",  Объект.УведомитьОДоставке);
	ПараметрыФормы.Вставить("УведомитьОПрочтении", Объект.УведомитьОПрочтении);
	ПараметрыФормы.Вставить("ЗаголовкиИнтернета",  Объект.ВнутреннийЗаголовок);
	ПараметрыФормы.Вставить("Письмо",              Объект.Ссылка);
	ПараметрыФормы.Вставить("ТипПисьма",           "ЭлектронноеПисьмоВходящее");
	ПараметрыФормы.Вставить("Кодировка",           Объект.Кодировка);
	ПараметрыФормы.Вставить("ВнутреннийНомер",     Объект.Номер);
	ПараметрыФормы.Вставить("УчетнаяЗапись",       Объект.УчетнаяЗапись);
	
	ОткрытьФорму("ЖурналДокументов.Взаимодействия.Форма.ПараметрыЭлектронногоПисьма", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СвязанныеВзаимодействияВыполнить()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОбъектОтбора", Объект.Предмет);
	
	ОткрытьФорму("ЖурналДокументов.Взаимодействия.ФормаСписка", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьКодировку(Команда)
	
	СписокКодировок = СписокКодировок();
	ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ВыборКодировкиПослеЗавершения", ЭтотОбъект);
	СписокКодировок.ПоказатьВыборЭлемента(ОбработчикОповещенияОЗакрытии,
		НСтр("ru = 'Выберите кодировку'"), СписокКодировок.НайтиПоЗначению(НРег(Объект.Кодировка)));
	
КонецПроцедуры 

&НаКлиенте
Процедура СвойстваВложения(Команда)
	
	ТекущиеДанные = Элементы.Вложения.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ПрисоединенныйФайл, ТолькоПросмотр", ТекущиеДанные.Ссылка,Истина);
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныйФайл", ПараметрыФормы,, ТекущиеДанные.Ссылка);
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьВложение()
	
	ТекущиеДанные = Элементы.Вложения.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если НЕ ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
			Возврат;
		КонецЕсли;
		
		Если ВзаимодействияКлиентСервер.ЭтоФайлПисьмо(ТекущиеДанные.ИмяФайла) Тогда
			
			ПараметрыВложения = ВзаимодействияКлиент.ПустаяСтруктураПараметровПисьмаВложения();
			ПараметрыВложения.ДатаПисьмаОснования = Объект.ДатаПолучения;
			ПараметрыВложения.ПисьмоОснование     = Объект.Ссылка;
			ПараметрыВложения.ТемаПисьмаОснования = Объект.Тема;

			ВзаимодействияКлиент.ОткрытьВложениеПисьмо(ТекущиеДанные.Ссылка, ПараметрыВложения, ЭтотОбъект);
			
		Иначе
			
			УправлениеЭлектроннойПочтойКлиент.ОткрытьВложение(ТекущиеДанные.Ссылка, ЭтотОбъект);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПреобразоватьКодировкуПисьма(ВыбраннаяКодировка)
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ЗаписьТекста = Новый ЗаписьТекста(ИмяВременногоФайла, Объект.Кодировка);
	ЗаписьТекста.Записать(
		?(Объект.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML, Объект.ТекстHTML, Объект.Текст));
	ЗаписьТекста.Закрыть();
	
	ЧтениеТекста = Новый ЧтениеТекста(ИмяВременногоФайла, ВыбраннаяКодировка);
	Если Объект.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML Тогда
		Объект.ТекстHTML = ЧтениеТекста.Прочитать();
		ТекстПисьма = Объект.ТекстHTML;
		Взаимодействия.ОтфильтроватьСодержимоеТекстаHTML(ТекстПисьма, ВыбраннаяКодировка, Не ВключитьНебезопасноеСодержимое, ЕстьНебезопасноеСодержимое);
	Иначе
		Объект.Текст = ЧтениеТекста.Прочитать();
		ТекстПисьма = Объект.Текст;
	КонецЕсли;
	ЧтениеТекста.Закрыть();
	УдалитьФайлы(ИмяВременногоФайла);
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ЗаписьТекста = Новый ЗаписьТекста(ИмяВременногоФайла, Объект.Кодировка);
	ЗаписьТекста.ЗаписатьСтроку(ОтправительПредставление);
	ЗаписьТекста.ЗаписатьСтроку(ПолучателиКопийПредставление);
	ЗаписьТекста.ЗаписатьСтроку(ПолучателиОтветаПредставление);
	ЗаписьТекста.ЗаписатьСтроку(ПолучателиПредставление);
	ЗаписьТекста.ЗаписатьСтроку(Объект.Тема);
	ЗаписьТекста.Закрыть();
	
	ЧтениеТекста = Новый ЧтениеТекста(ИмяВременногоФайла, ВыбраннаяКодировка);
	ОтправительПредставление = ЧтениеТекста.ПрочитатьСтроку();
	ПолучателиКопийПредставление = ЧтениеТекста.ПрочитатьСтроку();
	ПолучателиОтветаПредставление = ЧтениеТекста.ПрочитатьСтроку();
	ПолучателиПредставление = ЧтениеТекста.ПрочитатьСтроку();
	Объект.Тема = ЧтениеТекста.ПрочитатьСтроку();
	ЧтениеТекста.Закрыть();
	УдалитьФайлы(ИмяВременногоФайла);
	
	Объект.Кодировка = ВыбраннаяКодировка;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДополнительнуюИнформацию()
	
	ДополнительнаяИнформацияОПисьме = НСтр("ru = 'Создано:'") + "   " + Объект.Дата 
	+ Символы.ПС + НСтр("ru = 'Получено'") + ":  " + Объект.ДатаПолучения 
	+ Символы.ПС + НСтр("ru = 'Важность'") + ":  " + Объект.Важность
	+ Символы.ПС + НСтр("ru = 'Кодировка'") + ": " + Объект.Кодировка;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьНеобходимостьУведомленияОПрочтении()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УведомленияОПрочтении.Письмо
	|ИЗ
	|	РегистрСведений.УведомленияОПрочтении КАК УведомленияОПрочтении
	|ГДЕ
	|	УведомленияОПрочтении.Письмо = &Письмо
	|	И (НЕ УведомленияОПрочтении.ТребуетсяОтправка)";
	
	Запрос.УстановитьПараметр("Письмо",Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	НеобходимоеДействие = Взаимодействия.ПолучитьПараметрыРаботыПользователяДляВходящегоЭлектронногоПисьма();
	
	Если НеобходимоеДействие = Перечисления.ПорядокОтветовНаЗапросыУведомленийОПрочтении.ВсегдаОтправлятьУведомление Тогда
		
		ТребуетсяУстановкаФлагаОтправкиУведомления = Истина;
		
	ИначеЕсли НеобходимоеДействие = 
		Перечисления.ПорядокОтветовНаЗапросыУведомленийОПрочтении.НикогдаНеОтправлятьУведомление Тогда
		
		УправлениеЭлектроннойПочтой.УстановитьПризнакОтправкиУведомления(Объект.Ссылка,Ложь);
		
	ИначеЕсли НеобходимоеДействие = 
		Перечисления.ПорядокОтветовНаЗапросыУведомленийОПрочтении.ЗапрашиватьПередТемКакОтправитьУведомление Тогда
		
		ТребуетсяЗапросУведомленияОПрочтении = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьПризнакОтправкиУведомления(Ссылка, Флаг)

	УправлениеЭлектроннойПочтой.УстановитьПризнакОтправкиУведомления(Ссылка, Флаг)

КонецПроцедуры

&НаКлиенте
Процедура ВопросОНеобходимостиОтправкиУведомленияОПрочтенииПослеЗавершения(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		УстановитьПризнакОтправкиУведомления(Объект.Ссылка, Истина);
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		УстановитьПризнакОтправкиУведомления(Объект.Ссылка, Ложь);
	КонецЕсли;
	ТребуетсяЗапросУведомленияОПрочтении = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКодировкиПослеЗавершения(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт

	Если ВыбранныйЭлемент <> Неопределено Тогда
		ПреобразоватьКодировкуПисьма(ВыбранныйЭлемент.Значение);
	КонецЕсли;

КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Функция СписокКодировок()
	
	СписокКодировок = Новый СписокЗначений;
	
	СписокКодировок.Добавить("ibm852",       НСтр("ru = 'ibm852 (Центральноевропейская DOS)'"));
	СписокКодировок.Добавить("ibm866",       НСтр("ru = 'ibm866 (Кириллица DOS)'"));
	СписокКодировок.Добавить("iso-8859-1",   НСтр("ru = 'iso-8859-1 (Западноевропейская ISO)'"));
	СписокКодировок.Добавить("iso-8859-2",   НСтр("ru = 'iso-8859-2 (Центральноевропейская ISO)'"));
	СписокКодировок.Добавить("iso-8859-3",   НСтр("ru = 'iso-8859-3 (Латиница 3 ISO)'"));
	СписокКодировок.Добавить("iso-8859-4",   НСтр("ru = 'iso-8859-4 (Балтийская ISO)'"));
	СписокКодировок.Добавить("iso-8859-5",   НСтр("ru = 'iso-8859-5 (Кириллица ISO)'"));
	СписокКодировок.Добавить("iso-8859-7",   НСтр("ru = 'iso-8859-7 (Греческая ISO)'"));
	СписокКодировок.Добавить("iso-8859-9",   НСтр("ru = 'iso-8859-9 (Турецкая ISO)'"));
	СписокКодировок.Добавить("iso-8859-15",  НСтр("ru = 'iso-8859-15 (Латиница 9 ISO)'"));
	СписокКодировок.Добавить("koi8-r",       НСтр("ru = 'koi8-r (Кириллица KOI8-R)'"));
	СписокКодировок.Добавить("koi8-u",       НСтр("ru = 'koi8-u (Кириллица KOI8-U)'"));
	СписокКодировок.Добавить("us-ascii",     НСтр("ru = 'us-ascii США'"));
	СписокКодировок.Добавить("utf-8",        НСтр("ru = 'utf-8 (Юникод UTF-8)'"));
	СписокКодировок.Добавить("windows-1250", НСтр("ru = 'windows-1250 (Центральноевропейская Windows)'"));
	СписокКодировок.Добавить("windows-1251", НСтр("ru = 'windows-1251 (Кириллица Windows)'"));
	СписокКодировок.Добавить("windows-1252", НСтр("ru = 'windows-1252 (Западноевропейская Windows)'"));
	СписокКодировок.Добавить("windows-1253", НСтр("ru = 'windows-1253 (Греческая Windows)'"));
	СписокКодировок.Добавить("windows-1254", НСтр("ru = 'windows-1254 (Турецкая Windows)'"));
	СписокКодировок.Добавить("windows-1257", НСтр("ru = 'windows-1257 (Балтийская Windows)'"));
	
	Возврат СписокКодировок;

КонецФункции

&НаСервере
Процедура УстановитьВидимостьПредупрежденияБезопасности()
	ЗапрещеноОтображениеНебезопасногоСодержимогоВПисьмах = Взаимодействия.ЗапрещеноОтображениеНебезопасногоСодержимогоВПисьмах();
	Элементы.ПредупреждениеБезопасности.Видимость = Не ЗапрещеноОтображениеНебезопасногоСодержимогоВПисьмах
		И ЕстьНебезопасноеСодержимое И Не ВключитьНебезопасноеСодержимое;
КонецПроцедуры

&НаСервере
Процедура ПрочитатьТекстПисьмаHTML()
	ТекстПисьма = Взаимодействия.ОбработатьТекстHTML(Объект.Ссылка, Не ВключитьНебезопасноеСодержимое, ЕстьНебезопасноеСодержимое);
	УстановитьВидимостьПредупрежденияБезопасности();
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
	МодульПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
	МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
	МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
