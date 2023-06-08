
&НаКлиенте
Перем ЭтоРедактированиеСтроки;

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

&НаСервере
Процедура  ОбработкаВыбораНаСервере(ВыбранноеЗначение)
	Документы.НачислениеЗарплатыРаботникамОрганизаций.Автозаполнение(Объект, ЭтотОбъект, ПоддержкаРаботыСоСтруктурнымиПодразделениями, ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.СотрудникиОрганизаций.Форма.ФормаСписка" Тогда
		
		Если ПоПлановымНачислениям Тогда
			ОбработкаВыбораНаСервере(ВыбранноеЗначение);
		Иначе
			Для Каждого СтрокаМассива Из ВыбранноеЗначение Цикл
				Если Объект.Начисления.НайтиСтроки(Новый Структура("Сотрудник", СтрокаМассива)).Количество() = 0 Тогда
					НоваяСтрока = Объект.Начисления.Добавить();	
					НоваяСтрока.Сотрудник = СтрокаМассива;
					НоваяСтрока.ДатаНачала 					= НачалоМесяца(Объект.ПериодРегистрации);
					НоваяСтрока.ДатаОкончания 				= КонецМесяца(Объект.ПериодРегистрации);
					ВыполнитьЗаполнениеДанныхСотрудника(НоваяСтрока);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;	
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Обработка.РасчетПоСреднемуЗаработку.Форма.ФормаРасчетОтпуска"
		ИЛИ ИсточникВыбора.ИмяФормы = "Обработка.РасчетПоСреднемуЗаработку.Форма.ФормаРасчетБольничного" Тогда
		
		ОбработкаВыбораРасчетСреднегоНаСервере(ВыбранноеЗначение);
		
	КонецЕсли;
		
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
		КлючеваяОперация = "Документ ""начисление зарплаты сотрудникам организации"" (проведение)";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Для Каждого Строка Из ТекущийОбъект.Начисления Цикл
		Если ЗначениеЗаполнено(Строка.ДатаНачала) И ЗначениеЗаполнено(Строка.ДатаОкончания) И Строка.ДатаНачала > Строка.ДатаОкончания Тогда
			Поле = "Начисления[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ДатаОкончания";	
			ТекстСообщения = НСтр("ru = 'Дата конца не может быть меньше даты начала начисления'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ТекущийОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
	КонецЦикла;

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
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СтруктурноеПодразделениеОрганизация) Тогда 
		Объект.Организация = Неопределено;
		Объект.СтруктурноеПодразделение = Неопределено;
	Иначе  
		Результат = РаботаСДиалогамиКлиент.ПроверитьИзменениеЗначенийОрганизацииСтруктурногоПодразделения(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение);
		Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
			СтруктураРезультатаВыполнения = Неопределено;
			СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере(, СтруктураРезультатаВыполнения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.СтруктурноеПодразделениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Объект.Организация, Объект.СтруктурноеПодразделение, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)	
	
	РаботаСДиалогамиКлиент.ДатаКакМесяцПодобратьДатуПоТексту(МесяцНачисленияСтрокой, Объект.ПериодРегистрации);
	МесяцНачисленияСтрокой = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(Объект.ПериодРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры 

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Объект.ПериодРегистрации = ДобавитьМесяц(Объект.ПериодРегистрации, Направление);
	МесяцНачисленияСтрокой = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(Объект.ПериодРегистрации);
	Модифицированность = Истина;
	
КонецПроцедуры 

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодборТекста(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если Текст = "" Тогда
		Ожидание = 0;
		РаботаСДиалогамиКлиент.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, Объект.ПериодРегистрации, ЭтаФорма);
	Иначе
		РаботаСДиалогамиКлиент.ДатаКакМесяцАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.ДатаКакМесяцОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Начисления

&НаКлиенте
Процедура НачисленияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ЭтоРедактированиеСтроки = Истина;
	
	Если НоваяСтрока И НЕ Копирование Тогда
		ТекущиеДанные 				= Элементы.Начисления.ТекущиеДанные;
		ТекущиеДанные.ДатаНачала 	= НачалоМесяца(Объект.ПериодРегистрации);
		ТекущиеДанные.ДатаОкончания = КонецМесяца(Объект.ПериодРегистрации);
		ТекущиеДанные.ВидРасчета	= Объект.ВидРасчета;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ЭтоРедактированиеСтроки Тогда
		ЭтоРедактированиеСтроки = Ложь;
		ПодключитьОбработчикОжидания("УстановитьИмяКнопки", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияСотрудникПриИзменении(Элемент)
	
	ДанныеСтрокиТаблицы = Новый Структура("Сотрудник, Физлицо, ВидРасчета, ПодразделениеОрганизации, СпособОтраженияВБухучете, Размер, ДатаНачала, ДатаОкончания");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, Элементы.Начисления.ТекущиеДанные);
	
	ПараметрыОбъекта = Новый Структура("Организация, СтруктурноеПодразделение, Дата, Ссылка, Начисления");
	ЗаполнитьЗначенияСвойств(ПараметрыОбъекта, Объект);
	
	НачисленияСотрудникПриИзмененииНаСервереБезКонтекста(ДанныеСтрокиТаблицы, ПараметрыОбъекта);
	
	ПроставитьРазмерПлановогоНачисления(ДанныеСтрокиТаблицы); 
	ЭтоРедактированиеСтроки = Истина;
	
	ЗаполнитьЗначенияСвойств(Элементы.Начисления.ТекущиеДанные, ДанныеСтрокиТаблицы);
		
КонецПроцедуры

&НаКлиенте
Процедура НачисленияСотрудникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Истина);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	
	ОбработчикОповещения = Новый ОписаниеОповещения("СписокСотрудниковСписокЗавершениеВыбора", ЭтотОбъект);

	ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, Элемент,,,,ОбработчикОповещения, Режим);
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("УстановитьИмяКнопки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияВидРасчетаПриИзменении(Элемент)
	
	ДанныеСтрокиТаблицы = Новый Структура("Сотрудник, ВидРасчета, ДатаНачала, Размер");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, Элементы.Начисления.ТекущиеДанные);
	
	ПроставитьРазмерПлановогоНачисления(ДанныеСтрокиТаблицы); 
	
	ЗаполнитьЗначенияСвойств(Элементы.Начисления.ТекущиеДанные, ДанныеСтрокиТаблицы);

КонецПроцедуры

&НаКлиенте
Процедура НачисленияОтработаноДнейПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Начисления.ТекущиеДанные;	
	// считаем часы по пятидневке
	СтрокаТабличнойЧасти.ОтработаноЧасов = 8 * СтрокаТабличнойЧасти.ОтработаноДней;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияДатаНачалаПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Начисления.ТекущиеДанные;	

	СтрокаТабличнойЧасти.ОтработаноДней = 0;
	СтрокаТабличнойЧасти.ОтработаноЧасов = 0;
	
	ДанныеСтрокиТаблицы = Новый Структура("Сотрудник, ВидРасчета, ДатаНачала, Размер");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, Элементы.Начисления.ТекущиеДанные);
	
	ПроставитьРазмерПлановогоНачисления(ДанныеСтрокиТаблицы); 
	
	ЗаполнитьЗначенияСвойств(Элементы.Начисления.ТекущиеДанные, ДанныеСтрокиТаблицы);
		
КонецПроцедуры

&НаКлиенте
Процедура НачисленияДатаОкончанияПриИзменении(Элемент)

	СтрокаТабличнойЧасти = Элементы.Начисления.ТекущиеДанные;	

	СтрокаТабличнойЧасти.ОтработаноДней = 0;
	СтрокаТабличнойЧасти.ОтработаноЧасов = 0;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПоВсемСотрудникам(Команда)
	
	Если Объект.Проведен Тогда
		
		ТекстВопроса = НСтр("ru= 'Автоматически заполнить документ можно только после отмены его проведения. Выполнить отмену проведения документа?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередАвтоЗаполнениемТабличнойЧасти", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		
	ИначеЕсли Модифицированность ИЛИ Параметры.Ключ.Пустая() Тогда
		
		ТекстВопроса = НСтр("ru= 'Автоматически заполнить документ можно только после его записи. Записать?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередАвтоЗаполнениемТабличнойЧасти", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
						
	Иначе
		
		АвтозаполнениеПоВсемСотрудникамНаСервере();

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпискомСотрудников(Команда)
	
	Если Объект.Проведен Тогда
		
		ТекстВопроса = НСтр("ru= 'Автоматически заполнить документ можно только после отмены его проведения. Выполнить отмену проведения документа?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередАвтоЗаполнениемТабличнойЧастиСотрудниками", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		
	ИначеЕсли Модифицированность ИЛИ Объект.Ссылка.Пустая() Тогда
		
		ТекстВопроса = НСтр("ru= 'Автоматически заполнить документ можно только после его записи. Записать?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередАвтоЗаполнениемТабличнойЧастиСотрудниками", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		 				
	Иначе
		
		АвтозаполнениеПоВсемСотрудникамНаСервере();

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьВсе(Команда)

	Если Объект.Проведен Тогда
		ТекстВопроса = НСтр("ru= 'Автоматически рассчитать документ можно только после отмены его проведения. Выполнить отмену проведения документа?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		СтруктураПараметров = Новый Структура("РассчитатьСотрудника, КомментироватьРасчет", Ложь, Ложь);
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередРассчетом", ЭтотОбъект, СтруктураПараметров);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	ИначеЕсли  Модифицированность ИЛИ Параметры.Ключ.Пустая() Тогда
		ТекстВопроса = НСтр("ru= 'Автоматически рассчитать документ можно только после его записи. Записать?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		СтруктураПараметров = Новый Структура("РассчитатьСотрудника, КомментироватьРасчет", Ложь, Ложь);
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередРассчетом", ЭтотОбъект, СтруктураПараметров);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	Иначе
		РассчитатьНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьОтпуск(Команда)
	
	Если Модифицированность ИЛИ Параметры.Ключ.Пустая() Тогда
		ТекстВопроса = НСтр("ru= 'Автоматически рассчитать документ можно только после его записи. Записать?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		СтруктураПараметров = Новый Структура("Режим", "РасчетОтпуска");
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередРасчетомСреднегоЗаработка", ЭтотОбъект, СтруктураПараметров);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	Иначе
		РассчитатьПоСреднемуЗаработку("РасчетОтпуска");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьКомпенсацию(Команда)
	
	Если Модифицированность ИЛИ Параметры.Ключ.Пустая() Тогда
		ТекстВопроса = НСтр("ru= 'Автоматически рассчитать документ можно только после его записи. Записать?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		СтруктураПараметров = Новый Структура("Режим", "РасчетКомпенсации");
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередРасчетомСреднегоЗаработка", ЭтотОбъект, СтруктураПараметров);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	Иначе
		РассчитатьПоСреднемуЗаработку("РасчетКомпенсации");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РассчитатьБольничныйЛист(Команда)
	
	Если Модифицированность ИЛИ Параметры.Ключ.Пустая() Тогда
		ТекстВопроса = НСтр("ru= 'Автоматически рассчитать документ можно только после его записи. Записать?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		СтруктураПараметров = Новый Структура("Режим", "РасчетБольничного");
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередРасчетомСреднегоЗаработка", ЭтотОбъект, СтруктураПараметров);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	Иначе
		РассчитатьПоСреднемуЗаработку("РасчетБольничного");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСотрудника(Команда)

	Если Объект.Проведен Тогда
		ТекстВопроса = НСтр("ru= 'Автоматически рассчитать документ можно только после отмены его проведения. Выполнить отмену проведения документа?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		СтруктураПараметров = Новый Структура("РассчитатьСотрудника, КомментироватьРасчет", Истина, Ложь);
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередРассчетом", ЭтотОбъект, СтруктураПараметров);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		
	ИначеЕсли  Модифицированность ИЛИ Параметры.Ключ.Пустая() Тогда
		ТекстВопроса = НСтр("ru= 'Автоматически рассчитать документ можно только после его записи. Записать?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		СтруктураПараметров = Новый Структура("РассчитатьСотрудника, КомментироватьРасчет", Истина, Ложь);
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередРассчетом", ЭтотОбъект, СтруктураПараметров);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	Иначе
		РассчитатьНаСервере(Истина, Ложь);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСотрудникаСКомментарием(Команда)
	
	Если Объект.Проведен Тогда
		ТекстВопроса = НСтр("ru= 'Автоматически рассчитать документ можно только после отмены его проведения. Выполнить отмену проведения документа?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		СтруктураПараметров = Новый Структура("РассчитатьСотрудника, КомментироватьРасчет", Истина, Истина);
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередРассчетом", ЭтотОбъект, СтруктураПараметров);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	ИначеЕсли  Модифицированность ИЛИ Параметры.Ключ.Пустая() Тогда
		ТекстВопроса = НСтр("ru= 'Автоматически рассчитать документ можно только после его записи. Записать?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		СтруктураПараметров = Новый Структура("РассчитатьСотрудника, КомментироватьРасчет", Истина, Истина);
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередРассчетом", ЭтотОбъект, СтруктураПараметров);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	Иначе
		РассчитатьНаСервере(Истина, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)

	ТекстВопроса = НСтр("ru= 'Табличные части будут очищены. Продолжить?'");
	Режим = РежимДиалогаВопрос.ДаНет;
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОбОчисткеТабЧасти", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДокументу(Команда)
	
	Если Объект.Начисления.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Табличная часть будет полностью перезаполнена. Продолжить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаЗаполнитьПоДокументу", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)

	ПоПлановымНачислениям = Ложь;
	НачатьПодбор();

КонецПроцедуры

&НаКлиенте
Процедура НачатьПодбор()
	
	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Ложь);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",				Истина);
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов",		ИспользованиеГруппИЭлементов.Элементы);
	ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
	ПараметрыФормы.Вставить("ОтборПодразделениеОрганизации", Объект.ПодразделениеОрганизации);
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;

	ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, ЭтаФорма, , , ,,Режим)
	
КонецПроцедуры


&НаКлиенте
Процедура ПодборПоПлановымНачислениям(Команда)
	
	ПоПлановымНачислениям = Истина;
	НачатьПодбор();
	
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
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	Если Параметры.Ключ.Пустая() Тогда
		Объект.Дата = КонецМесяца(Объект.Дата);
	КонецЕсли;
	
	// Заполним реквизит формы МесяцСтрока.
	МесяцНачисленияСтрокой = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(Объект.ПериодРегистрации);
	
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация(Элементы.СтруктурноеПодразделениеОрганизация, Объект.СтруктурноеПодразделение, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
		
	ОбщегоНазначенияБК.УстановитьТекстАвтора(НадписьАвтор, Объект.Автор);
		
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБККлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	ОрганизацияЯвляетсяВкладчикомОППВ = ПроцедурыНалоговогоУчета.ПолучитьПризнакВкладчикаПрофПенсионныхВзносов(Объект.Организация, Объект.Дата);
	
КонецПроцедуры 

&НаСервере
Процедура ПриИзмененииЗначенияОрганизацииСервер(СтруктураПараметров, СтруктураРезультатаВыполнения)
	
	Если НЕ СтруктураПараметров.ИзмененаОрганизация И НЕ СтруктураПараметров.ИзмененоСтруктурноеПодразделение Тогда
		Возврат;
	КонецЕсли;
	
	 Объект.ПодразделениеОрганизации = Неопределено;

	// Если нет данных в ТЧ, то нет необходимости проверки и очищения некорректного значения Подразделения
	Если  Объект.Начисления.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Список для обработки ТЧ
	СписокТабличныхЧастей = Новый СписокЗначений;
	СписокРеквизитовПодразделения = Новый СписокЗначений;
	
	// ТЧ Работники
	СписокРеквизитовПодразделения.Добавить("ПодразделениеОрганизации"); 
	СтруктураРеквизтов = Новый Структура("ТабличнаяЧасть, СписокРеквизитовПодразделения",  Объект.Начисления, СписокРеквизитовПодразделения); 
	СписокТабличныхЧастей.Добавить(СтруктураРеквизтов);
	
	// Очистим некорректные значения подразделений не входящими в выбранное структурное подразделение "Куда"
	РаботаСДиалогами.ПроверитьСоответствиеПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, , СписокТабличныхЧастей); 
	
КонецПроцедуры

&НаСервере
Процедура СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере(СтруктураПараметров = Неопределено, СтруктураРезультатаВыполнения = Неопределено)
	
	Если СтруктураПараметров = Неопределено 
		ИЛИ (СтруктураПараметров.Свойство("НеобходимоИзменитьЗначенияРеквизитовОбъекта") 
			И СтруктураПараметров.НеобходимоИзменитьЗначенияРеквизитовОбъекта) Тогда 
		РаботаСДиалогами.СтруктурноеПодразделениеПриИзменении(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктураПараметров);
	КонецЕсли;
	
	ПриИзмененииЗначенияОрганизацииСервер(СтруктураПараметров, СтруктураРезультатаВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделения(Результат, Параметры) Экспорт
		
	РаботаСДиалогамиКлиент.ПослеВыбораСтруктурногоПодразделения(Результат, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
		Модифицированность = Истина;
		Результат.Вставить("НеобходимоИзменитьЗначенияРеквизитовОбъекта", Ложь);
		РаботаСДиалогамиКлиент.ПоказатьВопросОбОчисткеНекорректныхЗначенийПодразделения(ЭтаФорма, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОбОчисткеНекорректныхЗначенийПодразделения(Результат, Параметры) Экспорт
	
	Параметры.Вставить("ОчищатьНекорректныеЗначения", Результат = КодВозвратаДиалога.Да);
	СтруктураРезультатаВыполнения = Неопределено;

	Если Результат =КодВозвратаДиалога.Да  Тогда
		ПриИзмененииЗначенияОрганизацииСервер(Параметры, СтруктураРезультатаВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроставитьРазмерПлановогоНачисления(СтрокаТабличнойЧасти)
	
	ПроцедурыУправленияПерсоналомСервер.ПроставитьРазмерПлановогоНачисления(СтрокаТабличнойЧасти, Объект.Организация, Объект.Дата);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура НачисленияСотрудникПриИзмененииНаСервереБезКонтекста(СтрокаТабличнойЧасти, ПараметрыОбъекта)

	ПроцедурыУправленияПерсоналомСервер.ПроставитьДанныеСтроки(ПараметрыОбъекта.Дата, СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОбОчисткеТабЧасти(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
	
	Объект.Начисления.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьОтменивПроведение() 
	
	Если Объект.Проведен Тогда
		ЭтотОбъект.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.ОтменаПроведения));
	ИначеЕсли Модифицированность ИЛИ Объект.Ссылка.Пустая() Тогда
		ЭтотОбъект.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Запись));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте  
Процедура ПослеЗакрытияВопросаПередАвтоЗаполнениемТабличнойЧасти(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
	
	ЗаписатьОтменивПроведение();
	
	ЭтаФорма.Модифицированность = Истина;

	Если Объект.Начисления.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru = 'Очистить перед заполнением существующие данные?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОчиститьПередАвтоЗаполнением", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим);
		
	Иначе
		
		АвтозаполнениеПоВсемСотрудникамНаСервере();
		
		Если Объект.Начисления.Количество() = 0 Тогда
			
			ТекстСообщения = НСтр("ru = 'Не обнаружены данные для записи в табличную часть документа'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, , "Объект");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОчиститьПередАвтоЗаполнением(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;

	Объект.Начисления.Очистить();
	
	АвтозаполнениеПоВсемСотрудникамНаСервере();
	ЭтаФорма.Модифицированность = Истина;

	Если Объект.Начисления.Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Не обнаружены данные для записи в табличные части документа'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, , "Объект");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура АвтозаполнениеПоВсемСотрудникамНаСервере() 
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		КлючеваяОперация 	= "Документ ""начисление зарплаты сотрудникам организации"" (автозаполнение по всем сотрудникам)";
		ВремяНачалаЗамера 	= ОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;
	
	Документы.НачислениеЗарплатыРаботникамОрганизаций.Автозаполнение(Объект, ЭтотОбъект, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	
	ОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачалаЗамера);
	
КонецПроцедуры

&НаКлиенте  
Процедура ПослеЗакрытияВопросаПередАвтоЗаполнениемТабличнойЧастиСотрудниками(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
	
	ЗаписатьОтменивПроведение();

	Если Объект.Начисления.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru = 'Табличная часть будет полностью перезаполнена. Продолжить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОчиститьПередЗаполнениемСотрудниками", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОчиститьПередЗаполнениемСотрудниками(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;

	Объект.Начисления.Очистить();
	ЭтотОбъект.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаЗаполнитьПоДокументу(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
	
	Объект.Начисления.Очистить();

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьФИО(ТекущийСотрудник)
	
	ФИО = ОбщегоНазначенияБК.ФамилияИнициалыФизЛица(ТекущийСотрудник.ФизЛицо);
	
	Возврат ФИО
	
КонецФункции  

&НаКлиенте
Процедура УстановитьИмяКнопки()

	Если ЭтоРедактированиеСтроки Тогда
		Возврат;
	КонецЕсли;
	
	КнопкаРассчитатьРаботника = Элементы.ФормаРассчитатьСотрудника;
	Если КнопкаРассчитатьРаботника = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Начисления.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		СотрудникСтроки = ПредопределенноеЗначение("Справочник.СотрудникиОрганизаций.ПустаяСсылка");
	Иначе
		СотрудникСтроки = ТекущиеДанные.Сотрудник;
	КонецЕсли;
	
	Если СотрудникСтроки = ПредопределенноеЗначение("Справочник.СотрудникиОрганизаций.ПустаяСсылка") Тогда
		
		Если НЕ КнопкаРассчитатьРаботника = Неопределено Тогда
			КнопкаРассчитатьРаботника.Заголовок = НСтр("ru = 'Рассчитать сотрудника'");
		КонецЕсли;
		
		ТекущийСотрудник = СотрудникСтроки;
		
	Иначе
		
		Если ТекущийСотрудник <> СотрудникСтроки Тогда
			
			ФИО = ПолучитьФИО(СотрудникСтроки);
			КнопкаРассчитатьРаботника.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Рассчитать %1'"), ФИО);
			ТекущийСотрудник = СотрудникСтроки;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте 
Процедура ПослеЗакрытияВопросаПередРассчетом(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьОтменивПроведение();
	
	РассчитатьНаСервере(Параметры.РассчитатьСотрудника, Параметры.КомментироватьРасчет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаПередРасчетомСреднегоЗаработка(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
	
	ЗаписатьОтменивПроведение();
	
	РассчитатьПоСреднемуЗаработку(Параметры.Режим);

КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудниковСписокЗавершениеВыбора(ВыбранноеЗначение, Параметры) Экспорт

	ТекущаяСтрока = Элементы.Начисления.ТекущиеДанные;
	Если  ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		ТекущаяСтрока.Сотрудник = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗаполнениеДанныхСотрудника(ДанныеСотрудника)
	
	ДанныеСтрокиТаблицы = Новый Структура("Сотрудник, Физлицо, ПодразделениеОрганизации, ВидРасчета");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ДанныеСотрудника);
	
	ПараметрыОбъекта = Новый Структура("Организация, СтруктурноеПодразделение, Дата, Ссылка, ВидРасчета");
	ЗаполнитьЗначенияСвойств(ПараметрыОбъекта, Объект);
	
	НачислениеСотрудникПриИзмененииБезКонтекста(ДанныеСтрокиТаблицы, ПараметрыОбъекта);
	
	ЗаполнитьЗначенияСвойств(ДанныеСотрудника, ДанныеСтрокиТаблицы);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура НачислениеСотрудникПриИзмененииБезКонтекста(СтрокаТабличнойЧасти, ПараметрыОбъекта)

	ПроцедурыУправленияПерсоналомСервер.ПроставитьДанныеСтроки(ОбщегоНазначения.ТекущаяДатаПользователя(), СтрокаТабличнойЧасти);
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ПараметрыОбъекта, "ВидРасчета");
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////////
// Процедуры расчета

&НаСервере
Процедура ОбработкаВыбораРасчетСреднегоНаСервере(Параметры)

	ТаблицаОбработки = ПолучитьИзВременногоХранилища(Параметры.АдресРасчетаСреднегоВХранилище);
	
	Объект.Начисления.Загрузить(ТаблицаОбработки);
	
	Объект.СпособОтраженияВБухучете = Параметры.СпособОтраженияВБухучете;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьПоСреднемуЗаработку(Режим)
	
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("Режим", Режим);
	ПараметрыОбработки.Вставить("Ссылка", Объект.Ссылка);
	ПараметрыОбработки.Вставить("ИмяТабличнойЧасти", "Начисления");
	ПараметрыОбработки.Вставить("Организация", Объект.Организация);
	ПараметрыОбработки.Вставить("СпособОтраженияВБухучете", Объект.СпособОтраженияВБухучете);
	
	ОткрытьФорму("Обработка.РасчетПоСреднемуЗаработку.Форма", ПараметрыОбработки, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьНаСервере(РассчитатьСотрудника = Ложь, КомментироватьРасчет = Ложь) 
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		Если РассчитатьСотрудника Тогда
			КлючеваяОперация 	= "Документ ""начисление зарплаты сотрудникам организации"" (расчет сотрудника)";
		Иначе 
			КлючеваяОперация 	= "Документ ""начисление зарплаты сотрудникам организации"" (расчет)";
		КонецЕсли;	
		ВремяНачалаЗамера 	= ОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;
	
	Если РассчитатьСотрудника Тогда
		Документы.НачислениеЗарплатыРаботникамОрганизаций.Рассчитать(Объект, ТекущийСотрудник, КомментироватьРасчет);
	Иначе
		Документы.НачислениеЗарплатыРаботникамОрганизаций.Рассчитать(Объект);
	КонецЕсли;
	
	ОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачалаЗамера);
	
КонецПроцедуры


ЭтоРедактированиеСтроки = Ложь;