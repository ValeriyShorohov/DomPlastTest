
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьКоличествоОрганизаций();
	
	ПравоНастройки = РольДоступна("НастройкаИнтеграцииWebKassa") ИЛИ РольДоступна("ПолныеПрава");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьКомандРегистрации();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УстановитьДоступностьКомандРегистрации();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РегистрацияОрганизации(Команда)
	ОповещениеПослеРегистрации = Новый ОписаниеОповещения("РегистрацияОрганизации_Завершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.РегистрацияОрганизации", , ЭтаФорма, , , , ОповещениеПослеРегистрации);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьУправлениеКасс(Команда)
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ТекстОшибки = НСтр("ru='Не заполнена огранизация!'");
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "Ошибка заполнения", ,);
		Возврат;
	КонецЕсли;
	
	ПараметрыПодключения = Новый Структура;
	ВходныеПараметры = Новый Структура;
	ВходныеПараметры.Вставить("Организация", Организация);
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОткрытьУправлениеКасс_Завершение", ЭтотОбъект);
	ИнтеграцияWebKassaКлиент.НачатьПолучениеСпискаКасс(ОповещениеПриЗавершении, ВходныеПараметры, ПараметрыПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьУправлениеКассирами(Команда)
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ТекстОшибки = НСтр("ru='Не заполнена огранизация!'");
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "Ошибка заполнения", ,);
		Возврат;
	КонецЕсли;
	
	ПараметрыПодключения = Новый Структура;
	ВходныеПараметры = Новый Структура;
	ВходныеПараметры.Вставить("Организация", Организация);
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОткрытьУправлениеКассирами_Завершение", ЭтотОбъект);
	ИнтеграцияWebKassaКлиент.НачатьПолучениеСпискаПользователей(ОповещениеПриЗавершении, ВходныеПараметры, ПараметрыПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСменаАдреса(Команда)
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ТекстОшибки = НСтр("ru='Не заполнена огранизация!'");
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "Ошибка заполнения", ,);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", ?(Организация=Неопределено,Неопределено, Организация));
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОткрытьСменаАдреса_Завершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.СменаАдресаСервиса", ПараметрыФормы, ЭтаФорма, , , ,ОповещениеПриЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодключаемоеОборудование(Команда)
	
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.Форма.ПодключениеИНастройкаОборудования");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокПользователей(Команда)
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ТекстОшибки = НСтр("ru='Не заполнена огранизация!'");
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "Ошибка заполнения", ,);
		Возврат;
	КонецЕсли;
	
	ВходныеПараметры = Новый Структура;
	ВходныеПараметры.Вставить("Организация", ?(Организация=Неопределено, Неопределено, Организация));
	ПараметрыПодключения = Новый Структура;
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОбновитьСписокПользователей_Завершение", ЭтотОбъект);
	ИнтеграцияWebKassaКлиент.НачатьПолучениеСпискаПользователей(ОповещениеПриЗавершении, ВходныеПараметры, ПараметрыПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкиИнтеграции(Команда)
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ПараметрыФормы = Новый Структура();
		СсылкаНаНастройки = НастройкаОрганизации(Организация);
		Если СсылкаНаНастройки <> Неопределено Тогда
			ПараметрыФормы.Вставить("Ключ", СсылкаНаНастройки);
		КонецЕсли;
		ОткрытьФорму("Справочник.НастройкиИнтеграцииWebKassa.ФормаОбъекта", ПараметрыФормы);
	Иначе
		ОткрытьФорму("Справочник.НастройкиИнтеграцииWebKassa.ФормаОбъекта");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьДоступностьКомандРегистрации()
	
	ДоступностьЭлемента = ЗначениеЗаполнено(Организация);
	
	ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьУправлениеКассами",    "Доступность", ДоступностьЭлемента);
	ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьУправлениеКассирами",  "Доступность", ДоступностьЭлемента);
	ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "ОбновитьСписокПользователей", "Доступность", ДоступностьЭлемента);
	ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьСменаАдреса",          "Доступность", ДоступностьЭлемента);
	
	ИспользоватьПодключаемоеОборудование = ИнтеграцияWebKassaВызовСервераПереопределяемый.ИспользоватьПодключаемоеОборудование();
	Элементы.ОткрытьПодключаемоеОборудование.Доступность = ИспользоватьПодключаемоеОборудование;
	
	Если НЕ ПравоНастройки Тогда
		ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьУправлениеКассирами",            "Видимость", Ложь);
		ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "ОбновитьСписокПользователей",           "Видимость", Ложь);
		ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьСменаАдреса",                    "Видимость", Ложь);
		ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьПодключаемоеОборудование",       "Видимость", Ложь);
		ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьРегистрациюОрганизации",         "Видимость", Ложь);
		ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьНастройкиИнтеграцииОрганизации", "Видимость", Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоличествоОрганизаций()
	
	ЗарегистрированныеОрганизации = Справочники.НастройкиИнтеграцииWebKassa.ЗарегистрированныеОрганизации();
	КоличествоОрганизаций = ЗарегистрированныеОрганизации.Количество();
	ПанельНастроек = Элементы.НастройкиСервиса;
	Если КоличествоОрганизаций = 0 Тогда
		ПанельНастроек.ТекущаяСтраница = ПанельНастроек.ПодчиненныеЭлементы.НетОгранизаций;
	ИначеЕсли КоличествоОрганизаций = 1 Тогда
		ПанельНастроек.ТекущаяСтраница = ПанельНастроек.ПодчиненныеЭлементы.ОднаОрганизация;
		Организация = ЗарегистрированныеОрганизации[0];
		Элементы.Организация.ТолькоПросмотр = Истина;
	Иначе
		ПанельНастроек.ТекущаяСтраница = ПанельНастроек.ПодчиненныеЭлементы.ОднаОрганизация;
		Элементы.Организация.ТолькоПросмотр = Ложь;
		Элементы.Организация.РежимВыбораИзСписка = Истина;
		Для Каждого Орг из ЗарегистрированныеОрганизации Цикл
			Элементы.Организация.СписокВыбора.Добавить(Орг);
		КонецЦикла;
		Организация = ЗарегистрированныеОрганизации[0];
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрацияОрганизации_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.РезультатВыполнения Тогда
		Организация = Результат.Организация;
		Элементы.Организация.СписокВыбора.Добавить(Результат.Организация);
		КоличествоОрганизаций = Элементы.Организация.СписокВыбора.Количество();
		ПанельНастроек = Элементы.НастройкиСервиса;
		
		Если КоличествоОрганизаций = 0 Тогда
			ПанельНастроек.ТекущаяСтраница = ПанельНастроек.ПодчиненныеЭлементы.НетОгранизаций;
		ИначеЕсли КоличествоОрганизаций = 1 Тогда
			ПанельНастроек.ТекущаяСтраница = ПанельНастроек.ПодчиненныеЭлементы.ОднаОрганизация;
			Элементы.Организация.ТолькоПросмотр = Истина;
		Иначе
			ПанельНастроек.ТекущаяСтраница = ПанельНастроек.ПодчиненныеЭлементы.ОднаОрганизация;
			Элементы.Организация.ТолькоПросмотр = Ложь;
			Элементы.Организация.РежимВыбораИзСписка = Истина;
		КонецЕсли;
		
		УстановитьДоступностьКомандРегистрации();
		
		Если Результат.Свойство("Сообщение") Тогда
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(Результат.Сообщение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьУправлениеКасс_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.РезультатВыполнения Тогда
		Попытка
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Организация", ?(Организация=Неопределено, Неопределено, Организация));
			ПараметрыФормы.Вставить("КассыККМ", Новый Массив);
			Для Каждого Касса из Результат.ОбъектыJSON.Data Цикл
				ВремСтруктура = Новый Структура("ДатаОкончания, ТокенОФД, СерийныйНомер");
				ВремСтруктура.СерийныйНомер=Касса.CashboxUniqueNumber;
				ВремСтруктура.ДатаОкончания=?(Касса.Свойство("ActivationEndDate"),Касса.ActivationEndDate,"");
				ВремСтруктура.ТокенОФД=Касса.OfdToken;
				ПараметрыФормы.КассыККМ.Добавить(ВремСтруктура);
			КонецЦикла;
	
			ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.УправлениеКассами", ПараметрыФормы, ЭтаФорма);
		Исключение
			ТекстСообщения = НСтр("ru = 'При получении списка касс произошла ошибка.
			                      |Дополнительное описание:
			                      |%ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ОписаниеОшибки());
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
		
	Иначе
		ТекстСообщения = НСтр("ru = 'При получении списка касс произошла ошибка.
			                      |Дополнительное описание:
			                      |%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", Результат.ВыходныеПараметры[1]);
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьУправлениеКассирами_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.РезультатВыполнения Тогда
		Попытка
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Организация", ?(Организация=Неопределено, Неопределено, Организация));
			ПараметрыФормы.Вставить("Кассиры", Результат.ОбъектыJSON.Data);
			
			ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.УправлениеКассирами", ПараметрыФормы, ЭтаФорма);
		Исключение
			ТекстСообщения = НСтр("ru = 'При получении списка кассиров произошла ошибка.
			                      |Дополнительное описание:
			                      |%ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ОписаниеОшибки());
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
		
	Иначе
		ТекстСообщения = НСтр("ru = 'При получении списка кассиров произошла ошибка.
			                      |Дополнительное описание:
			                      |%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", Результат.ВыходныеПараметры[1]);
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСменаАдреса_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.РезультатВыполнения Тогда
		ТекстСообщения = НСтр("ru = 'Адрес сервиса успешно изменен.'");
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТекстСообщения = НСтр("ru = 'При изменении адреса сервиса произошла ошибка.'");
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокПользователей_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОчиститьСообщения();
	
	Если Результат.РезультатВыполнения Тогда
		
		Попытка
			//выгружаем логины емейлы в массив и добавляем их в настройки
			ПолученныеПользователи = Новый Массив;
			Для Каждого Пользователь из Результат.ОбъектыJSON.Data Цикл
				ПолученныеПользователи.Добавить(Пользователь.Email);
			КонецЦикла;
			
			РезультатВыбора = Новый Структура;
			РезультатВыбора.Вставить("РезультатВыполнения", Истина);
			РезультатВыбора.Вставить("Организация", Организация);
			
			Если ДобавитьПользователейВНастройкуИнтеграции(Результат.ДополнительныеПараметры.Организация, ПолученныеПользователи) Тогда
				ТекстСообщения = НСтр("ru = 'Список пользователей организации успешно обновлен!'");
			Иначе
				ТекстСообщения = НСтр("ru = 'При обновлении пользователей организации произошла ошибка.'");
			КонецЕсли;
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		Исключение
			ТекстСообщения = НСтр("ru = 'При обновлении пользователей организации произошла ошибка.
									|Дополнительное описание:
									|%ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ОписаниеОшибки());
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
		
	Иначе
		Если Результат.ВыходныеПараметры[0] = 999 Тогда
			ТекстСообщения = НСтр("ru = 'При обновлении пользователей организации произошла ошибка.
			|Дополнительное описание: %ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", Результат.ВыходныеПараметры[1]);
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДобавитьПользователейВНастройкуИнтеграции(Организация, МассивПользователей)
	
	Возврат Справочники.НастройкиИнтеграцииWebKassa.ДобавитьПользователейВНастройкуИнтеграции(Организация, МассивПользователей);
	
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборКонстант" Тогда
		УстановитьДоступностьКомандРегистрации();
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция НастройкаОрганизации(Организация)
	
	СсылкаНаНастройки = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	НастройкиИнтеграции.Ссылка
	|ИЗ
	|	Справочник.НастройкиИнтеграцииWebKassa КАК НастройкиИнтеграции
	|ГДЕ
	|	НастройкиИнтеграции.Организация = &Организация";
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СсылкаНаНастройки = Выборка.Ссылка;
	КонецЦикла;
	
	Возврат СсылкаНаНастройки;
	
КонецФункции

#КонецОбласти
