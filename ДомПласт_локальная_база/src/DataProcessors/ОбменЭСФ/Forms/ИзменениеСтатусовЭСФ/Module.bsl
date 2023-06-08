////////////////////////////////////////////////////////////////////////////////
// Форма для выполнения методов declineInvoiceById, revokeInvoiceById, unrevokeInvoiceById и т.д.
//
// Параметры формы:
//  См. ЭСФКлиентСервер.ПустыеПараметрыФормыИзменениеСтатусовЭСФ().
//
// Возвращаемое значение формы:
//  Нет.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Действие = Параметры.Действие;
	
	Если ВозможноВыполнитьДействие() Тогда
		
		СтруктурнаяЕдиница = ЭСФСервер.СтруктурнаяЕдиницаЭСФ(Параметры.МассивЭСФ[0]);
		УстановитьПараметрыВыбораЭСФ();
		ЗаполнитьСписокЭСФ();
		
	Иначе
		
		Отказ = Истина;
		
	КонецЕсли;
	
	УстановитьЗаголовокФормы();
	УстановитьЗаголовокКнопкиВыполнитьДействие();	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();	
	Контейнер.ПриОткрытииФормы(ЭтаФорма, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого СтрокаСписокЭСФ Из СписокЭСФ Цикл
		
		Если ПустаяСтрока(СтрокаСписокЭСФ.Идентификатор) Тогда
			
			ИндексСтроки = СписокЭСФ.Индекс(СтрокаСписокЭСФ);
			НомерСтроки = ИндексСтроки + 1;
			
			Сообщение = Новый СообщениеПользователю;
			
			Сообщение.Текст = НСтр("ru = 'В строке %НомерСтроки% не заполнено поле ""Идентификатор"".'"); 
			Сообщение.Текст = СтрЗаменить(Сообщение.Текст, "%НомерСтроки%", Формат(НомерСтроки, "ЧГ="));
			
			Сообщение.Поле = "СписокЭСФ[%ИндексСтроки%].Идентификатор";
			Сообщение.Поле = СтрЗаменить(Сообщение.Поле, "%ИндексСтроки%", Формат(ИндексСтроки, "ЧГ="));
			
			Сообщение.Сообщить();
			
			Отказ = Истина;	
			
		Иначе
			
			ТекстСообщения = "";
			
			Если НЕ ЭСФКлиентСервер.ИдентификаторКорректен(СтрокаСписокЭСФ.Идентификатор, ТекстСообщения) Тогда 
				
				ИндексСтроки = СписокЭСФ.Индекс(СтрокаСписокЭСФ);
				НомерСтроки = ИндексСтроки + 1;
				
				Сообщение = Новый СообщениеПользователю;
				
				Сообщение.Текст = НСтр("ru = 'В строке %НомерСтроки% поле ""Идентификатор"" заполнено некорректно. Причина: %Причина%'"); 
				Сообщение.Текст = СтрЗаменить(Сообщение.Текст, "%НомерСтроки%", Формат(НомерСтроки, "ЧГ="));
				Сообщение.Текст = СтрЗаменить(Сообщение.Текст, "%Причина%", ТекстСообщения);
				
				Сообщение.Поле = "СписокЭСФ[%ИндексСтроки%].Идентификатор";
				Сообщение.Поле = СтрЗаменить(Сообщение.Поле, "%ИндексСтроки%", Формат(ИндексСтроки, "ЧГ="));
				
				Сообщение.Сообщить();
				
				Отказ = Истина;	
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ЭСФКлиентСервер.ИмяСобытияЗаписьЭСФ()
		И НЕ Параметр = Неопределено 
		И Источник = ЭтаФорма Тогда
		
		КоллекцияРезультатовИзмененияСтатусов = ПолучитьИзВременногоХранилища(Параметр.АдресХранилища);
		
		Если НЕ Тип("Соответствие") = ТипЗнч(КоллекцияРезультатовИзмененияСтатусов) Тогда
			Возврат
		КонецЕсли;

		// Обработать результаты действия.
	    ОбработатьРезультатыИзмененияСтатусовНаСервере(КоллекцияРезультатовИзмененияСтатусов);
		
		// Обновить открытые формы.
		МассивЭСФ = Новый Массив;
		Для Каждого СтрокаТаблицы Из СписокЭСФ Цикл
			Если ЗначениеЗаполнено(СтрокаТаблицы.ЭСФ) Тогда
				МассивЭСФ.Добавить(СтрокаТаблицы.ЭСФ);
			КонецЕсли;
		КонецЦикла; 
		
		// Показать результат отзыва.		
		Если ВсеСтатусыУспешноИзменены() Тогда
			
			ЗакрытьПослеОповещения = Новый ОписаниеОповещения("ЗакрытьФормуПослеОповещения", ЭтаФорма);
			ПоказатьПредупреждение(ЗакрытьПослеОповещения, НСтр("ru = 'Действие выполнено успешно.'"));
			
		Иначе
			
			ПоказатьПредупреждение(, НСтр("ru = 'Не удалось выполнить действие для всех электронных счетов-фактур.'"));
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ЭСФ_ПроверятьОповещенияФоновогоЗадания"
		И ЭтаФорма.КлючУникальности = Источник Тогда
		
		ЭСФКлиентПереопределяемый.ОбработкаОповещенияЭСФ_ПроверятьОповещенияФоновогоЗадания(ЭтаФорма, Параметр);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуПослеОповещения(Результат) Экспорт

	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ

&НаКлиенте
Процедура СписокЭСФЭСФПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокЭСФ.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если ЗначениеЗаполнено(ТекущиеДанные.ЭСФ) Тогда 
			ДанныеЭСФ = ДанныеЭСФ(ТекущиеДанные.ЭСФ);
			ТекущиеДанные.Идентификатор = ДанныеЭСФ.Идентификатор;
			ТекущиеДанные.Статус = ДанныеЭСФ.Статус;
			ТекущиеДанные.Вид = ДанныеЭСФ.Вид;
		КонецЕсли;
		
		ТекущиеДанные.ОшибкаПредставление = "";
		ТекущиеДанные.ОшибкаРасшифровка = "";
		ТекущиеДанные.ОшибкаЕсть = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЭСФИдентификаторПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокЭСФ.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		Если НЕ ЗначениеЗаполнено(ТекущиеДанные.ЭСФ) Тогда 
			ТекущиеДанные.Статус = Неопределено;
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЭСФПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда 
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЭСФВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ТекущиеДанные = Элементы.СписокЭСФ.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если ТекущиеДанные.ОшибкаЕсть Тогда
			
			Если Поле.Имя = "СписокЭСФОшибкаПредставление" Тогда
				СтандартнаяОбработка = Ложь;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = ТекущиеДанные.ОшибкаРасшифровка;
				Сообщение.Поле = "СписокЭСФ[" + Формат(СписокЭСФ.Индекс(ТекущиеДанные), "ЧН=0; ЧГ=") + "].ОшибкаПредставление";
				Сообщение.Сообщить();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ИзменитьСтатусЭСФ(Команда)
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();

	Если НЕ Контейнер.КриптопровайдерПодключается() Тогда
		Возврат;
	КонецЕсли;	
	
	// Проверить заполнение.
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат
	КонецЕсли;
	
	КоллекцияСгруппированныхЭСФ = Новый Соответствие;
	КоллекцияСгруппированныхЭСФ.Вставить(СтруктурнаяЕдиница, );
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("КоллекцияСгруппированныхЭСФ", КоллекцияСгруппированныхЭСФ);

	ИзменитьСтатусЭСФЗавершение = Новый ОписаниеОповещения("ИзменитьСтатусЭСФЗавершение", ЭтаФорма, ДополнительныеПараметры);
	ПараметрыФормы = Новый Структура("СписокСтруктурныхЕдиниц, ТребуетсяВыборСертификата", КоллекцияСгруппированныхЭСФ, Истина);
	
	ЭСФКлиент.ОткрытьФормуВводаДанныхИСЭСФ(ИзменитьСтатусЭСФЗавершение, ПараметрыФормы);	
	
КонецПроцедуры
	
&НаКлиенте
Процедура ИзменитьСтатусЭСФЗавершение(ДанныеПрофилейИСЭСФ, ДополнительныеПараметры) Экспорт
	
	Если ДанныеПрофилейИСЭСФ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// форма изменения статуса работает только с одной структурной единицей
	ДанныеКлючаЭЦП = ДанныеПрофилейИСЭСФ.Получить(СтруктурнаяЕдиница);
	ДанныеПрофиляИСЭСФ = ЭСФВызовСервера.ДанныеПрофиляИСЭСФ(ДанныеКлючаЭЦП.ПрофильИСЭСФ);
	ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ДанныеКлючаЭЦП.ПарольИСЭСФ;
	
	Если Действие = ЭСФКлиентСервер.ДействиеОтклонение() Тогда
		
		// Это отклонение, а при отклонении иногда требуется выполнить два запроса к API ИС ЭСФ, т.к.:
		// 1. Для отклонения отозванных используется метод unrevokeInvoiceById.
		// 2. Для отклонения дополнительных и исправленных используется метод declineInvoiceById.
		
		КоллекцияРезультатовИзмененияСтатусов = ОтклонитьИсправленныеИлиДополнительныеИлиОтозванныеЭСФ(ДанныеПрофиляИСЭСФ, ДанныеКлючаЭЦП);
		
	Иначе
		
		// Это отзыв или другое действие, которое не требует выполнения нескольких различных запросов.
		
		// Сформировать коллекцию для выполнения действия.
		КоллецияДляИзмененияСтатусов = Новый Соответствие;
		Для Каждого СтрокаТаблицы Из СписокЭСФ Цикл
			КоллецияДляИзмененияСтатусов.Вставить(СтрокаТаблицы.Идентификатор, Причина);	
		КонецЦикла;
		
		// Выполнить действие.
		КоллекцияРезультатовИзмененияСтатусов = ЭСФКлиент.ИзменитьСтатусыЭСФ(Действие, КоллецияДляИзмененияСтатусов, ДанныеПрофиляИСЭСФ, ДанныеКлючаЭЦП, УникальныйИдентификатор, Параметры.ЗапускатьФоновоеЗадание);		
				
	КонецЕсли;
	
	Если НЕ Действие = ЭСФКлиентСервер.ДействиеОтклонение() И Параметры.ЗапускатьФоновоеЗадание Тогда
				
		Если ТипЗнч(КоллекцияРезультатовИзмененияСтатусов) = Тип("Структура") Тогда
			КоллекцияРезультатовИзмененияСтатусов.Вставить("ТекстСообщения", НСтр("ru = 'Отзыв документов из ИС ЭСФ'"));
		КонецЕсли;
		
		ЭСФКлиент.ОповеститьФормы("ЭСФ_ПроверятьОповещенияФоновогоЗадания", КоллекцияРезультатовИзмененияСтатусов, КлючУникальности);
		
	Иначе
		
		// Обработать результаты действия.
	    ОбработатьРезультатыИзмененияСтатусовНаСервере(КоллекцияРезультатовИзмененияСтатусов);
		
		АдресХранилища = ПоместитьВоВременноеХранилище(КоллекцияРезультатовИзмененияСтатусов);
		ЭСФКлиент.ОповеститьФормы(ЭСФКлиентСервер.ИмяСобытияЗаписьЭСФ(), Новый Структура("АдресХранилища", АдресХранилища), ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьРезультатыИзмененияСтатусовНаСервере(Знач КоллекцияРезультатовИзмененияСтатусов)
	
	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();	
	ОбработкаОбменЭСФ.ОбработатьРезультатыИзмененияСтатусов(КоллекцияРезультатовИзмененияСтатусов, ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Проверка возможности выполнения действия

&НаСервере
Функция ВозможноВыполнитьДействие()
	
	Возможно = Истина;
	
	РезультатЗапроса = ДанныеДляПроверкиВозможностиВыполненияДействия();
	
	// Проверить количество ЭСФ.
	Если РезультатЗапроса.Пустой() Тогда
		
		Возможно = Ложь;
		ЭСФКлиентСервер.СообщитьПользователю(НСтр("ru = 'Невозможно выполнить действие, так как не указаны электронные счета-фактуры, для которых необходимо выполнить действие.'"));
		
	КонецЕсли;
	
	// Проверить, что во всех ЭСФ указана одинаковая организация и подразделение организации. 
	Если Возможно Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		// Проверить, что во всех ЭСФ указана одинаковая организация.
		Выборка.Сбросить();
		Выборка.Следующий();
		ПерваяОрганизация = Выборка.Организация;
		Пока Выборка.Следующий() Цикл
			Если Выборка.Организация <> ПерваяОрганизация Тогда
				ОтзывВозможен = Ложь;
				ЭСФКлиентСервер.СообщитьПользователю(НСтр("ru = 'Все электронные счета-фактуры должны принадлежать одной организации.'"));
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		// Проверить, что во всех ЭСФ указано одинаковое подразделение организации.
		Если ЭСФКлиентСерверПереопределяемый.ИспользуютсяСтруктурныеПодразделения() Тогда
			Выборка.Сбросить();
			Выборка.Следующий();
			ПервоеПодразделение = Выборка.СтруктурноеПодразделение;
			Пока Выборка.Следующий() Цикл
				Если Выборка.СтруктурноеПодразделение <> ПервоеПодразделение Тогда
					ОтзывВозможен = Ложь;
					ЭСФКлиентСервер.СообщитьПользователю(НСтр("ru = 'Все электронные счета-фактуры должны принадлежать одному структурному подразделению.'"));
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	// Проверить, чтобы у всех ЭСФ было одинаковое направление, в зависимости от действия.
	ТребуемоеНаправление = НаправлениеДляДействия(Действие);
	Если НЕ ВсеЭСФИмеютНаправление(ТребуемоеНаправление, РезультатЗапроса, Истина) Тогда
		Возможно = Ложь;
	КонецЕсли;
	
	Если Возможно Тогда
		
		// 1. Для отклонения отозванных используется метод unrevokeInvoiceById.
		// 2. Для отклонения дополнительных и исправленных используется метод declineInvoiceById.
		// Все отклоняемые ЭСФ должны быть первого или второго типа.
		Если Действие = ЭСФКлиентСервер.ДействиеОтклонение() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				Если Выборка.Вид <> Перечисления.ВидыЭСФ.Дополнительный
					И Выборка.Вид <> Перечисления.ВидыЭСФ.Исправленный
					И Выборка.Статус <> Перечисления.СтатусыЭСФ.Отозванный Тогда
					
					Возможно = Ложь;
					
					ТекстСообщения = НСтр("ru = 'Невозможно выполнить действие, так как ""[ЭСФ]"" не является дополнительным, исправленным или отозванным.'");		
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "[ЭСФ]", Выборка.ЭСФ);
					ЭСФКлиентСервер.СообщитьПользователю(ТекстСообщения);
					
				КонецЕсли;	
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
		
	Возврат Возможно;
	
КонецФункции

&НаСервере
Функция НаправлениеДляДействия(Знач Действие)
	
	Направление = Неопределено;
	
	Если Действие = ЭСФКлиентСервер.ДействиеОтзыв() Тогда
		
		Направление = Перечисления.НаправленияЭСФ.Исходящий;
		
	ИначеЕсли Действие = ЭСФКлиентСервер.ДействиеОтклонение() Тогда
		
		Направление = Перечисления.НаправленияЭСФ.Входящий;
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Внутренняя ошибка. Необработанное действие.'");
		
	КонецЕсли;
	
	Возврат Направление;
	
КонецФункции

&НаСервере
Функция ВсеЭСФИмеютНаправление(Знач Направление, Знач РезультатЗапроса, Знач ПоказыватьСообщения)
	
	ВсеЭСФИмеютНаправление = Истина;
	
	Выборка = РезультатЗапроса.Выбрать();		
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Направление <> Направление Тогда
			
			ВсеЭСФИмеютНаправление = Ложь;
			
			Если ПоказыватьСообщения Тогда 
				ТекстСообщения = НСтр("ru = 'Невозможно выполнить действие для документа ""%ЭСФ%"", так как он %Направление%.'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЭСФ%", Выборка.ЭСФ);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Направление%", НРег(Выборка.Направление));				
				ЭСФКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;	
	
	Возврат ВсеЭСФИмеютНаправление;
	
КонецФункции

&НаСервере
Функция ДанныеДляПроверкиВозможностиВыполненияДействия()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭСФ.Ссылка КАК ЭСФ,
	|	ЭСФ.Направление,
	|	ЭСФ.СтруктурноеПодразделение,
	|	ЭСФ.Организация,
	|	ЭСФ.Статус,
	|	ЭСФ.Вид
	|ИЗ
	|	Документ.ЭСФ КАК ЭСФ
	|ГДЕ
	|	ЭСФ.Ссылка В(&МассивЭСФ)";
	
	Запрос.УстановитьПараметр("МассивЭСФ", Параметры.МассивЭСФ);
	
	Если НЕ ЭСФКлиентСерверПереопределяемый.ИспользуютсяСтруктурныеПодразделения() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ЭСФ.СтруктурноеПодразделение,", "");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();

	Возврат РезультатЗапроса;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Прочие служебные процедуры и функции

&НаКлиенте
Функция ВсеСтатусыУспешноИзменены()
	
	Успешно = Истина;
	
	Для Каждого СтрокаСписокЭСФ Из СписокЭСФ Цикл
		Если СтрокаСписокЭСФ.ОшибкаЕсть Тогда
			Успешно = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Успешно;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокЭСФ()	
	
	СписокЭСФ.Очистить();
	
	Если Действие = ЭСФКлиентСервер.ДействиеОтзыв() Тогда
		
		ЗаполнитьСписокЭСФ_Отзыв();
	
	ИначеЕсли Действие = ЭСФКлиентСервер.ДействиеОтклонение() Тогда
		
		ЗаполнитьСписокЭСФ_Отклонение();
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Внутренняя ошибка. Необработанное действие.'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокЭСФ_Отзыв()
	
	Запрос = Новый Запрос;	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭСФ.Ссылка КАК ЭСФ,
	|	0 КАК Порядок
	|ПОМЕСТИТЬ ОтзываемыеИДополнительныеЭСФ
	|ИЗ
	|	Документ.ЭСФ КАК ЭСФ
	|ГДЕ
	|	ЭСФ.Ссылка В(&МассивОтзываемыхЭСФ)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭСФ.Ссылка,
	|	1
	|ИЗ
	|	Документ.ЭСФ КАК ЭСФ
	|ГДЕ
	|	ЭСФ.СвязанныйЭСФ В(&МассивОтзываемыхЭСФ)
	|	И ЭСФ.Вид = ЗНАЧЕНИЕ(Перечисление.ВидыЭСФ.Дополнительный)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОтзываемыеИДополнительныеЭСФ.ЭСФ,
	|	МИНИМУМ(ОтзываемыеИДополнительныеЭСФ.Порядок) КАК Порядок
	|ПОМЕСТИТЬ СгруппированныеЭСФ
	|ИЗ
	|	ОтзываемыеИДополнительныеЭСФ КАК ОтзываемыеИДополнительныеЭСФ
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтзываемыеИДополнительныеЭСФ.ЭСФ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СгруппированныеЭСФ.ЭСФ КАК ЭСФ,
	|	СгруппированныеЭСФ.ЭСФ.Идентификатор КАК Идентификатор,
	|	СгруппированныеЭСФ.ЭСФ.Статус КАК Статус,
	|	СгруппированныеЭСФ.ЭСФ.Вид КАК Вид
	|ИЗ
	|	СгруппированныеЭСФ КАК СгруппированныеЭСФ
	|
	|УПОРЯДОЧИТЬ ПО
	|	СгруппированныеЭСФ.Порядок";
	
	Запрос.УстановитьПараметр("МассивОтзываемыхЭСФ", Параметры.МассивЭСФ);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаСписокЭСФ = СписокЭСФ.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаСписокЭСФ, Выборка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокЭСФ_Отклонение()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭСФ.Ссылка КАК ЭСФ,
	|	ЭСФ.Идентификатор,
	|	ЭСФ.Статус,
	|	ЭСФ.Вид
	|ИЗ
	|	Документ.ЭСФ КАК ЭСФ
	|ГДЕ
	|	ЭСФ.Ссылка В(&МассивЭСФ)";
	
	Запрос.УстановитьПараметр("МассивЭСФ", Параметры.МассивЭСФ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаСписокЭСФ = СписокЭСФ.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаСписокЭСФ, Выборка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораЭСФ()
	
	Массив = Новый Массив;
	
	ПараметрВыбора = Новый ПараметрВыбора("Отбор.Направление", НаправлениеДляДействия(Действие)); 
	Массив.Добавить(ПараметрВыбора);
	
	ПараметрВыбора = Новый ПараметрВыбора("Отбор.Организация", Параметры.МассивЭСФ[0].Организация); 
	Массив.Добавить(ПараметрВыбора);	
	
	Если ЭСФКлиентСерверПереопределяемый.ИспользуютсяСтруктурныеПодразделения() Тогда
		ПараметрВыбора = Новый ПараметрВыбора("Отбор.СтруктурноеПодразделение", Параметры.МассивЭСФ[0].СтруктурноеПодразделение); 
		Массив.Добавить(ПараметрВыбора);		
	КонецЕсли;
	
	Элементы.СписокЭСФЭСФ.ПараметрыВыбора = Новый ФиксированныйМассив(Массив);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеЭСФ(ЭСФ)
	
	Данные = Новый Структура;
	Данные.Вставить("Идентификатор", "");
	Данные.Вставить("Статус", Перечисления.СтатусыЭСФ.ПустаяСсылка());
	Данные.Вставить("Вид", Перечисления.ВидыЭСФ.ПустаяСсылка());
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭСФ.Идентификатор,
	|	ЭСФ.Статус,
	|	ЭСФ.Вид
	|ИЗ
	|	Документ.ЭСФ КАК ЭСФ
	|ГДЕ
	|	ЭСФ.Ссылка = &ЭСФ";	
	
	Запрос.УстановитьПараметр("ЭСФ", ЭСФ);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Данные.Идентификатор = Выборка.Идентификатор;
		Данные.Статус = Выборка.Статус;
		Данные.Вид = Выборка.Вид;
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	Если Действие = ЭСФКлиентСервер.ДействиеОтзыв() Тогда
		
		ЭтаФорма.Заголовок = НСтр("ru = 'Отзыв электронных счетов-фактур'");
		
	ИначеЕсли Действие = ЭСФКлиентСервер.ДействиеОтклонение() Тогда
		
		ЭтаФорма.Заголовок = НСтр("ru = 'Отклонение электронных счетов-фактур'");
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Внутренняя ошибка. Необработанное действие.'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокКнопкиВыполнитьДействие()
	
	Если Действие = ЭСФКлиентСервер.ДействиеОтзыв() Тогда
		
		Элементы.ФормаВыполнитьДействие.Заголовок = НСтр("ru = 'Отозвать ЭСФ в ИС ЭСФ'");
		
	ИначеЕсли Действие = ЭСФКлиентСервер.ДействиеОтклонение() Тогда
		
		Элементы.ФормаВыполнитьДействие.Заголовок = НСтр("ru = 'Отклонить ЭСФ в ИС ЭСФ'");
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Внутренняя ошибка. Необработанное действие.'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОтклонитьИсправленныеИлиДополнительныеИлиОтозванныеЭСФ(ДанныеПрофиляИСЭСФ, ДанныеКлючаЭЦП)
	
	/////////////////////////////////////////////////////////////////////////////
	// Выполнить отклонение отозванных ЭСФ.
	
	// Сформировать коллекцию для отклонения отозванных.
	КоллецияДляИзмененияСтатусов = Новый Соответствие;
	Для Каждого СтрокаТаблицы Из СписокЭСФ Цикл
		Если СтрокаТаблицы.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЭСФ.Отозванный") Тогда
			КоллецияДляИзмененияСтатусов.Вставить(СтрокаТаблицы.Идентификатор, Причина);
		КонецЕсли;
	КонецЦикла;
	
	// Выполнить отклонение отозванных.
	Если КоллецияДляИзмененияСтатусов.Количество() <> 0 Тогда
		
		КоллекцияРезультатовОтклоненияОтозванных = ЭСФКлиент.ИзменитьСтатусыЭСФ(
			ЭСФКлиентСервер.ДействиеОтклонениеОтзыва(),
			КоллецияДляИзмененияСтатусов,
			ДанныеПрофиляИСЭСФ,
			ДанныеКлючаЭЦП,
			УникальныйИдентификатор,
			// всегда равено Ложь, тк действие требует выполнения нескольких запросов
			Ложь);
			
	Иначе
		
		КоллекцияРезультатовОтклоненияОтозванных = Новый Соответствие;
		
	КонецЕсли;
	
	
	
	/////////////////////////////////////////////////////////////////////////////
	// Выполнить отклонение исправленных или дополнительных ЭСФ.
	
	// Сформировать коллекцию для отклонения дополнительных и исправленных.
	КоллецияДляИзмененияСтатусов = Новый Соответствие;
	Для Каждого СтрокаТаблицы Из СписокЭСФ Цикл
		Если СтрокаТаблицы.Статус <> ПредопределенноеЗначение("Перечисление.СтатусыЭСФ.Отозванный") Тогда
			// В данной проверке не проверяется "Дополнительный" или "Исправленный",
			// чтобы во второй запрос попали все ЭСФ, которые не являются отозванными.
			КоллецияДляИзмененияСтатусов.Вставить(СтрокаТаблицы.Идентификатор, Причина);
		КонецЕсли;
	КонецЦикла;
	
	// Выполнить отклонение дополнительных и исправленных.
	Если КоллецияДляИзмененияСтатусов.Количество() <> 0 Тогда
		
		КоллекцияРезультатовОтклоненияДополнительныхИлиИсправленных = ЭСФКлиент.ИзменитьСтатусыЭСФ(
			ЭСФКлиентСервер.ДействиеОтклонениеДополнительногоИлиИсправленного(), 
			КоллецияДляИзмененияСтатусов, 
			ДанныеПрофиляИСЭСФ, 
			ДанныеКлючаЭЦП,
			УникальныйИдентификатор,
			// всегда равено Ложь, тк действие требует выполнения нескольких запросов
			Ложь);
			
	Иначе
		
		КоллекцияРезультатовОтклоненияДополнительныхИлиИсправленных = Новый Соответствие;
		
	КонецЕсли;
	
	
	
	/////////////////////////////////////////////////////////////////////////////
	// Объединить результаты выполнения двух отклонений.
	
	КоллекцияРезультатовИзмененияСтатусов = Новый Соответствие;
	
	Для Каждого ЭлементКоллекции Из КоллекцияРезультатовОтклоненияОтозванных Цикл
		КоллекцияРезультатовИзмененияСтатусов.Вставить(ЭлементКоллекции.Ключ, ЭлементКоллекции.Значение);
	КонецЦикла;
	
	Для Каждого ЭлементКоллекции Из КоллекцияРезультатовОтклоненияДополнительныхИлиИсправленных Цикл
		КоллекцияРезультатовИзмененияСтатусов.Вставить(ЭлементКоллекции.Ключ, ЭлементКоллекции.Значение);
	КонецЦикла;
	
	
	
	/////////////////////////////////////////////////////////////////////////////
	// Возврат результата.
	
	Возврат КоллекцияРезультатовИзмененияСтатусов;
	
КонецФункции

