
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ЛокальнаяСтруктураЗаписи) Тогда
		ЗаполнитьЗначенияСвойств(Объект, Параметры.ЛокальнаяСтруктураЗаписи);
	КонецЕсли;
	
	Объект.Тип = Параметры.ТипКИ;
	
	Объект.ДоступностьОбъекта = Параметры.ДоступностьОбъекта;
	Объект.ЗаписыватьВРегистр = Параметры.ЗаписыватьВРегистр;
	
	Если Объект.Вид = Неопределено Тогда
		Объект.Вид = Справочники.ВидыКонтактнойИнформации.ПустаяСсылка();
	КонецЕсли;
	
	РедактируетсяНаборЗаписей = Параметры.РедактируетсяНаборЗаписей;
	
	ВидОбъектаКИ = КонтактнаяИнформацияКлиентСерверПовтИсп.ВидОбъектаКИ(Объект.Объект);

	Элементы.ОбъектКонтактнойИнформации.Видимость = Объект.ДоступностьОбъекта;
	
	Если НЕ ЗначениеЗаполнено(Объект.Объект) И Объект.ДоступностьОбъекта Тогда
		ЭтаФорма.ТекущийЭлемент = Элементы.ОбъектКонтактнойИнформации;
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.Вид) Тогда
		ЭтаФорма.ТекущийЭлемент = Элементы.ВидКонтактнойИнформации;
	Иначе
		ЭтаФорма.ТекущийЭлемент = Элементы.Представление;
	КонецЕсли;
	
	УстановитьПиктограммуКомментария(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("ПодтвердитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОбъектКонтактнойИнформацииПриИзменении(Элемент)
	
	ВидОбъектаКИ = КонтактнаяИнформацияКлиентСерверПовтИсп.ВидОбъектаКИ(Объект.Объект);

	Если НЕ ЗначениеЗаполнено(Объект.Объект) И ТипЗнч(Объект.Вид) = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
		
		Объект.Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ПустаяСсылка");
		ВидОбъектаКИ = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодСтраныПриИзменении(Элемент)
	
	Если Лев(СокрЛ(Объект.Поле1), 1) <> "+" И НЕ ПустаяСтрока(Объект.Поле1) Тогда
		Объект.Поле1 = СокрЛП(Объект.Поле1);
		Пока Лев(Объект.Поле1, 1) = "0" Цикл
			Объект.Поле1 = Сред(Объект.Поле1, 2);
		КонецЦикла;
		Если НЕ ПустаяСтрока(Объект.Поле1) Тогда
			Объект.Поле1 = "+" + Объект.Поле1;
		КонецЕсли; 
	КонецЕсли; 
	
	КонтактнаяИнформацияКлиентСервер.СформироватьПредставлениеТелефона(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура КодГородаПриИзменении(Элемент)
	
	КонтактнаяИнформацияКлиентСервер.СформироватьПредставлениеТелефона(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура НомерТелефонаПриИзменении(Элемент)
	
	Объект.Поле3 = КонтактнаяИнформацияКлиентСервер.ПривестиНомерТелефонаКШаблону(Объект.Поле3);
	КонтактнаяИнформацияКлиентСервер.СформироватьПредставлениеТелефона(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавочныйПриИзменении(Элемент)
	
	Объект.Поле4 = КонтактнаяИнформацияКлиентСервер.ПривестиНомерТелефонаКШаблону(Объект.Поле4);
	КонтактнаяИнформацияКлиентСервер.СформироватьПредставлениеТелефона(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	УстановитьПиктограммуКомментария(ЭтотОбъект);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КомандаОК(Команда)
	ПодтвердитьИЗакрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТелефон(Команда)
	
	Для Индекс = 1 По 4 Цикл
		Объект["Поле" + Индекс] = "";
	КонецЦикла;
	
	Объект.Комментарий   = "";
	Объект.Представление = "";
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПодтвердитьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	// При немодифицированности работает "отмена"
	
	Если Модифицированность Тогда
		
		Если НЕ ПроверитьЗаполнение() Тогда
			Возврат;
		КонецЕсли;
		
		Результат = РезультатВыбора();
		
		СброситьМодифицированностьПриВыборе();
		
	Иначе
		
		Результат = Неопределено;
		
	КонецЕсли;
	
	Если (МодальныйРежим Или ЗакрыватьПриВыборе) И Открыта() Тогда
		СброситьМодифицированностьПриВыборе();
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьМодифицированностьПриВыборе()
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Функция РезультатВыбора()
	
	Если НЕ РедактируетсяНаборЗаписей Тогда
		СтруктураЗаписи = КонтактнаяИнформацияКлиентСервер.ПолучитьСтруктуруЗаписиРегистра(Объект);
		СтруктураЗаписи.Вставить("ДобавленаНоваяКИ", Ложь);
	ИначеЕсли РедактируетсяНаборЗаписей Тогда
		СтруктураЗаписи = КонтактнаяИнформацияКлиентСервер.ПолучитьСтруктуруЗаписиРегистра(Объект);
		СтруктураЗаписи.Вставить("ДобавленаНоваяКИ", Истина);
	КонецЕсли;
	
	Если Объект.ЗаписыватьВРегистр Тогда
		МенеджерЗаписи = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Объект);
		
		Попытка
			МенеджерЗаписи.Записать(Ложь);
		Исключение
			ТекстСообщения = НСтр("ru = 'Не удалось записать данные о контактной информации по причине: %1.'");
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли; 
	
	Возврат СтруктураЗаписи;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПиктограммуКомментария(Форма)
	
	Если ПустаяСтрока(Форма.Объект.Комментарий) Тогда
		Форма.Элементы.ТелефонСтраницаКомментарий.Картинка = Новый Картинка;
	Иначе
		Форма.Элементы.ТелефонСтраницаКомментарий.Картинка = БиблиотекаКартинок.Комментарий;
	КонецЕсли;
		
КонецПроцедуры
