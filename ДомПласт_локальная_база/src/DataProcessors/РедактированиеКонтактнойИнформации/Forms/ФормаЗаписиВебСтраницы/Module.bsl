
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
	
	// Зависимости от интерфейса
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.Представление.КартинкаКнопкиВыбора = Новый Картинка;
	КонецЕсли;
	
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
Процедура ПредставлениеПриИзменении(Элемент)
	Объект.Представление = СокрЛП(Объект.Представление);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ПустаяСтрока(Объект.Представление) Тогда
		Попытка
			ЗапуститьПриложение(Объект.Представление);
		Исключение
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не удалось открыть веб-страницу по причине: %1'", ОписаниеОшибки())),
				,
				"Представление",
				"Объект");
		КонецПопытки;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
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
