
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем УИДЗамера;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	РежимВариантаОтчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьРежимВыполненияОтчета(ОтчетОбъект.Метаданные());
	
	Если РежимВариантаОтчета Тогда
		Возврат;
	КонецЕсли;
	
	ОтчетыВызовСервераБК.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	РассылкаОтчетовБК.ПриСозданииНаСервере(ЭтаФорма);
		
	Если НЕ Отчет.РежимРасшифровки Тогда
		ЗаполняемыеНастройки = Новый Структура("Группировка", Истина);
		ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если РежимВариантаОтчета Тогда
		Отказ = Истина;
		ОткрытьФормуВариантыОтчета();
		Возврат;
	КонецЕсли;
	
	Элементы.РежимВариантаОтчета.Доступность = НЕ Отчет.РежимРасшифровки И НЕ ОткрытИзРассылки;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Отчет.Периодичность = 0 Тогда
		Отчет.Периодичность = 9;
	КонецЕсли;
		
	ИБФайловая = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	ПодключитьОбработчикОжидания = Не ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	Если ПодключитьОбработчикОжидания Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
	Отчет.ПредставлениеСпискаОрганизаций = БухгалтерскиеОтчетыКлиентСервер.ВыгрузитьСписокВСтроку(СписокСтруктурныхЕдиниц);
	
	Элементы.ПредставлениеСпискаОрганизаций.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
	
	Если ОткрытИзРассылки И НЕ ЗавершениеРаботы Тогда
		ПриСохраненииПользовательскихНастроекНаСервереРассылка();
		РассылкаОтчетовБККлиент.ПередЗакрытием(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОтменитьВыполнениеЗадания();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	ВариантыОтчетов.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Если РежимВариантаОтчета Тогда
		Возврат;
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) И НЕ ОткрытИзРассылки Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	ИначеЕсли ОткрытИзРассылки Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	Если РежимВариантаОтчета Тогда
		Возврат;
	КонецЕсли;
	
	ОтчетыВызовСервераБК.ПриЗагрузкеВариантаНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.РассылкиОтчетов.Форма.НастройкаРассылкиБК" Тогда
		ОбработкаНастройкиРассылкиОтчета(ВыбранноеЗначение);
	Иначе
		БухгалтерскиеОтчетыКлиент.ОтправитьОтчетыПоПочтеОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСпискаОрганизацийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("СписокСтруктурныхЕдиниц" , СписокСтруктурныхЕдиниц);
	
	БухгалтерскиеОтчетыКлиент.ПредставлениеСпискаОрганизацийНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСпискаОрганизацийОчистка(Элемент, СтандартнаяОбработка)
	
	Если Не УчетПоВсемОрганизациям Тогда
		СтандартнаяОбработка = Ложь;
	Иначе 
		СписокСтруктурныхЕдиниц.Очистить();
		
		Отчет.ПредставлениеСпискаОрганизаций   = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьДиаграммуПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодписиПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РежимВариантаОтчетаПриИзменении(Элемент)
	
	Если РежимВариантаОтчета И УстановитьРежимВыполненияОтчета() Тогда
		ОткрытьФормуВариантыОтчета();
		Закрыть();
	Иначе
		РежимВариантаОтчета = Ложь;
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ ТАБЛИЧНОГО ДОКУМЕНТА

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтаФорма, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ГРУППИРОВКА

&НаКлиенте
Процедура ПериодичностьПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);  
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ОТБОРЫ

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПриИзменении(ЭтаФорма, Элемент, Ложь);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокПараметров = ПолучитьПараметрыВыбораЗначенияОтбора();
	БухгалтерскиеОтчетыКлиент.ОтборыПравоеЗначениеНачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка, СписокПараметров);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ДОПОЛНИТЕЛЬНЫЕПОЛЯ

&НаКлиенте
Процедура РазмещениеДополнительныхПолейПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СОРТИРОВКА

&НаКлиенте
Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Отчет.НачалоПериода, Отчет.КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	УИДЗамера = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Ложь, "Отчет ""поступление денежных средств"" (формирование)"); 
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	Иначе
		ЗафиксироватьДлительностьКлючевойОперации();
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе	
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)

	ПоказатьДиалогОтправкиПоЭлектроннойПочте();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРассылкуОтчета(Команда)
	
	ЗаполнитьНастройкиОтчетаДляРассылки();
	
	РассылкаОтчетовБККлиент.НастроитьРассылкуИзОтчета(ЭтотОбъект);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ОбновитьТекстЗаголовка(ЭтаФорма); 
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = НСтр("ru = 'Поступления денежных средств %1'");
	ЗаголовокОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ЗаголовокОтчета, БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода));

	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ОтменитьВыполнениеЗадания()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет",
			ПараметрыОтчета,
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
			
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("НачалоПериода"                         , Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"                          , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("РазмещениеДополнительныхПолей"         , Отчет.РазмещениеДополнительныхПолей);
	ПараметрыОтчета.Вставить("Периодичность"                         , Отчет.Периодичность);
	ПараметрыОтчета.Вставить("Группировка"                           , Отчет.Группировка.Выгрузить());
	ПараметрыОтчета.Вставить("ДополнительныеПоля"                    , Отчет.ДополнительныеПоля.Выгрузить());
	ПараметрыОтчета.Вставить("РежимРасшифровки"                      , Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("СписокСтруктурныхЕдиниц"               , СписокСтруктурныхЕдиниц);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"                     , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("ВыводитьДиаграмму"                     , ВыводитьДиаграмму);
	ПараметрыОтчета.Вставить("ВыводитьПодписи"                       , ВыводитьПодписи);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                     , ДанныеРасшифровки);
	ПараметрыОтчета.Вставить("МакетОформления"                       , МакетОформления);	
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"                 , ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"                   , БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтаФорма));
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"             , Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат         = РезультатВыполнения.Результат;
	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 

			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		    ЗафиксироватьДлительностьКлючевойОперации();
			
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		УИДЗамера = Неопределено;
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Приоритет");
	
	Если Режим = "Группировка" Тогда
		БухгалтерскиеОтчетыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтаФорма, СписокПолей);
	КонецЕсли;
	
	Если Режим = "Выбор" ИЛИ Режим = "Отбор" Тогда
		СписокПолей.Добавить("ВидПоступления");;
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыВыбораЗначенияОтбора() Экспорт
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Организация", СписокСтруктурныхЕдиниц);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделения(РезультатВыбора, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ПослеВыбораСтруктурногоПодразделения(ЭтаФорма, РезультатВыбора);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки) Экспорт
	
	Если Отчет.РежимРасшифровки Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗаполняемыеНастройки.Свойство("Группировка") Тогда
		Если ЗаполняемыеНастройки.Группировка Тогда
	
			Отчет.Группировка.Очистить();
			
			Если УчетПоВсемОрганизациям Тогда
				НоваяСтрока = Отчет.Группировка.Добавить();
				НоваяСтрока.Поле           = "Организация";
				НоваяСтрока.Использование  = Ложь;
				НоваяСтрока.Представление  = НСтр("ru = 'Организация'");
				НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;	
			КонецЕсли;
			
			НоваяСтрока = Отчет.Группировка.Добавить();
			НоваяСтрока.Поле           = "ВидПоступления";
			НоваяСтрока.Использование  = Истина;
			НоваяСтрока.Представление  = НСтр("ru = 'Вид поступления'");
			НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;	
			
			НоваяСтрока = Отчет.Группировка.Добавить();
			НоваяСтрока.Поле           = "Счет";
			НоваяСтрока.Использование  = Ложь;
			НоваяСтрока.Представление  = НСтр("ru = 'Счет'");
			НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Иерархия;
			
			НоваяСтрока = Отчет.Группировка.Добавить();
			НоваяСтрока.Поле           = "КорСчет";
			НоваяСтрока.Использование  = Ложь;
			НоваяСтрока.Представление  = НСтр("ru = 'Кор. счет'");
			НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Иерархия;	
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДиалогОтправкиПоЭлектроннойПочте()
	     	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОтправитьОтчетыПоПочтеНастройкаУчетнойЗаписиПредложена", БухгалтерскиеОтчетыКлиент, ЭтотОбъект);

	РаботаСПочтовымиСообщениямиКлиент.ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Функция УстановитьРежимВыполненияОтчета()
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	ОтчетМетаданные = ОтчетОбъект.Метаданные();
	
	ОтчетРежим = РегистрыСведений.ОтчетыВРежимеВариантыОтчетов.СоздатьМенеджерЗаписи();

 	ОтчетРежим.Отчет = ОтчетМетаданные.ПолноеИмя();
 	ОтчетРежим.Пользователь = Пользователи.ТекущийПользователь();
	
	Попытка
		ОтчетРежим.Записать();
		Возврат Истина;
	Исключение
		ТекстСообщения = НСтр("ru='Операция не выполнена'");
		Комментарий = НСтр("ru = 'При записи данных в регистр сведений ""Отчеты в режиме ""Варианты отчетов"""" произошла ошибка:
		|%1'");
		
		ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Комментарий, ПодробноеПредставлениеОшибки);
		
		ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, Комментарий);				
		ОбщегоНазначения.СообщитьПользователю(Комментарий);
		Возврат Ложь;
	КонецПопытки; 			

КонецФункции

&НаКлиенте
Процедура ОткрытьФормуВариантыОтчета()
	
	ПараметрыФормы = Новый Структура("КлючВарианта", КлючТекущегоВарианта);
	ОткрытьФорму("Отчет.ПоступлениеДенежныхСредств.ФормаОбъекта", ПараметрыФормы, ВладелецФормы);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиОтчетаДляРассылки()
	
	РассылкаОтчетовБК.ЗаполнитьНастройкиОтчетаДляРассылки(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаНастройкиРассылкиОтчета(ВыбранноеЗначение)
	
	РассылкаОтчетовБК.ФормаОтчетаОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервереРассылка()
	
	КомпоновщикНастроекКД = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроекКД.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	КомпоновщикНастроекКД.ЗагрузитьНастройки(Отчет.КомпоновщикНастроек.ПолучитьНастройки());

	Настройки = КомпоновщикНастроекКД.Настройки;

	// Установка пользовательских настроек
	Настройки.Отбор.ИдентификаторПользовательскойНастройки              = "Отбор";
	Настройки.Порядок.ИдентификаторПользовательскойНастройки            = "Порядок";
	Настройки.УсловноеОформление.ИдентификаторПользовательскойНастройки = "УсловноеОформление";
	
	// Перенос пользовательских настроек в основные
	КомпоновщикНастроекКД.ЗагрузитьПользовательскиеНастройки(Отчет.КомпоновщикНастроек.ПользовательскиеНастройки);
	КомпоновщикНастроекКД.ЗагрузитьНастройки(КомпоновщикНастроекКД.ПолучитьНастройки());

	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, КомпоновщикНастроекКД.ПользовательскиеНастройки);
	
	НастройкиДляСохранения = ЭтаФорма.НастройкиОтчета.ПользовательскиеНастройки.ДополнительныеСвойства.НастройкиОтчета.Получить();
	ДанныеОтчетаРассылка   = КомпоновщикНастроекКД.ПользовательскиеНастройки.ДополнительныеСвойства.ДанныеОтчетаРассылка.Получить();
	ЗаполнитьЗначенияСвойств(НастройкиДляСохранения, ДанныеОтчетаРассылка);
	НастройкиДляСохранения.Вставить("ДанныеОтчетаРассылка", ДанныеОтчетаРассылка);
	НастройкиДляСохранения.Вставить("НастройкиКомпоновкиДанных", КомпоновщикНастроекКД.ПолучитьНастройки());
	КомпоновщикНастроекКД.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("НастройкиОтчета", Новый ХранилищеЗначения(НастройкиДляСохранения));
	НастройкиОтчета.АдресНастроекОтчета = ПоместитьВоВременноеХранилище(КомпоновщикНастроекКД.ПользовательскиеНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьДлительностьКлючевойОперации()
	
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамера);
	
КонецПроцедуры