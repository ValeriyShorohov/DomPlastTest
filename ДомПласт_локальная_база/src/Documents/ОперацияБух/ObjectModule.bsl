#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область УправлениеДоступом

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ОбщегоНазначенияБК.ЗаполнитьНаборыПоОрганизацииСтурктурномуПодразделению(ЭтотОбъект, Таблица, "Организация", "СтруктурноеПодразделение");
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Устанавливает/снимает признак активности движений документа в зависимости от пометки удаления.
// Следует вызывать перед записью измененной пометки удаления.
// Помеченный на удаление документ не должен иметь активных движений.
// Не помеченный на удаление документ может иметь неактивные движения.
Процедура СинхронизироватьАктивностьДвиженийСПометкойУдаления()
	
	Если НЕ ПометкаУдаления 
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления") = ПометкаУдаления Тогда
		// Не помеченный на удаление документ может иметь неактивные движения.
		// Однако, при снятии пометки удаления все движения становятся активными.
		Возврат;
	КонецЕсли;
	
	Активность = НЕ ПометкаУдаления;
	
	Для Каждого Движение Из Движения Цикл
		
		Если НЕ ПравоДоступа("Чтение", Движение.Метаданные()) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Движение.Записывать = Ложь Тогда // При работе формы набор может быть уже "потроган" (прочитан, модифицирован)
			// Набор никто не трогал
			Движение.Прочитать();
		КонецЕсли;
		
		Для Каждого Строка Из Движение Цикл
			
			Если Строка.Активность = Активность Тогда
				Продолжить;
			КонецЕсли;
			
			Строка.Активность   = Активность;
			Движение.Записывать = Истина; // На случай, если набор был прочитан выше
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьРегистрНакопления(ИмяРегистра)
	
	Если ТаблицаРегистровНакопления.Найти(ИмяРегистра, "Имя") = Неопределено Тогда
		ТаблицаРегистровНакопления.Добавить().Имя = ИмяРегистра;
	КонецЕсли;
	
КонецПроцедуры
		
Процедура ДобавитьРегистрСведений(ИмяРегистра)
	
	Если ТаблицаРегистровСведений.Найти(ИмяРегистра, "Имя") = Неопределено Тогда
		ТаблицаРегистровСведений.Добавить().Имя = ИмяРегистра;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого НаборЗаписей ИЗ Движения Цикл
		     		
		Если НаборЗаписей.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ПустаяТаблица   = НаборЗаписей.ВыгрузитьКолонки();
		ЕстьОрганизация = ПустаяТаблица.Колонки.Найти("Организация") <> Неопределено;
		ЕстьПериод      = ПустаяТаблица.Колонки.Найти("Период") <> Неопределено;
		
		Если НЕ (ЕстьОрганизация ИЛИ ЕстьПериод) Тогда
			Продолжить;
		КонецЕсли;
		
		ТаблицаДвижений = НаборЗаписей.Выгрузить();
		Если ЕстьОрганизация Тогда
			ТаблицаДвижений.ЗаполнитьЗначения(Организация, "Организация");
		КонецЕсли;
		Если ЕстьПериод Тогда
			ТаблицаДвижений.ЗаполнитьЗначения(Дата, "Период");
		КонецЕсли;
		
		Если ТипЗнч(НаборЗаписей) = Тип("РегистрБухгалтерииНаборЗаписей.Типовой") Тогда
			Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьВалютныйУчет") Тогда
				ВалютаУчета = ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
				Для Каждого Проводка Из ТаблицаДвижений Цикл
					Если Проводка.СчетДт.Валютный Тогда				
						Проводка.ВалютаДт        = ВалютаУчета;
						Проводка.ВалютнаяСуммаДт = Проводка.Сумма;				
					КонецЕсли;
					Если Проводка.СчетКт.Валютный Тогда				
						Проводка.ВалютаКт        = ВалютаУчета;
						Проводка.ВалютнаяСуммаКт = Проводка.Сумма;				
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
				
		НаборЗаписей.Загрузить(ТаблицаДвижений);
		
		// Актуализируем списки регистров
		ИмяРегистра = НаборЗаписей.Метаданные().Имя;
		Если Метаданные.РегистрыНакопления.Содержит(НаборЗаписей.Метаданные()) Тогда
			ДобавитьРегистрНакопления(ИмяРегистра);
		ИначеЕсли Метаданные.РегистрыСведений.Содержит(НаборЗаписей.Метаданные()) Тогда
			ДобавитьРегистрСведений(ИмяРегистра);
		КонецЕсли;
		
	КонецЦикла; 			
	
	Если СпособЗаполнения = "Вручную" Тогда 		
		СторнируемыйДокумент = Неопределено; 		
	КонецЕсли;
	             	
	СинхронизироватьАктивностьДвиженийСПометкойУдаления();

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Движения.Налоговый.Количество() > 0 Тогда
		ПроверитьЗаполнениеТабличнойЧастиПострочно(Движения.Налоговый, "Налоговый", Отказ);
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	Если СтрНайти(СпособЗаполнения, "Корректировка") = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СторнируемыйДокумент");
	КонецЕсли;
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Массив") Тогда
		МассивЗаполнения = ДанныеЗаполнения;
	Иначе
		МассивЗаполнения = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеЗаполнения);
	КонецЕсли;
	
	Для Каждого ДокументЗаполнения из МассивЗаполнения Цикл
		МетаданныеОснования = Метаданные.НайтиПоТипу(ТипЗнч(ДокументЗаполнения));
		Если Метаданные.Документы.Найти(МетаданныеОснования.Имя) <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДокументЗаполнения,,"Дата,Номер,Проведен");
			НачалоСодержания = ?(Содержание = "", НСтр("ru = 'Корректировка: '"), Содержание + ", ");
			Комментарий = "";
			Содержание = НачалоСодержания + Строка(ДокументЗаполнения);			
			СторнируемыйДокумент = ДокументЗаполнения;			
			СпособЗаполнения = "Корректировка";
		КонецЕсли;
	КонецЦикла; 	

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПроверитьЗаполнениеТабличнойЧастиПострочно(ПроверяемаяТабличнаячасть, ИмяТабличнойЧасти, Отказ, ПараметрыПроверки = Неопределено)
	
	Для Каждого СтрокаТабличнойЧасти Из ПроверяемаяТабличнаячасть Цикл
		
		Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетДт) И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ВидУчетаДт) Тогда
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Вид учета Дт'"),
				СтрокаТабличнойЧасти.НомерСтроки + 1, ?(ИмяТабличнойЧасти = "Налоговый", "Налоговый учет", ИмяТабличнойЧасти));
			Поле = "ТабличноеПолеДвиженияНУ" + "[" + (СтрокаТабличнойЧасти.НомерСтроки) + "].ВидУчетаДт";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , "ЭтаФорма.Элементы.ТабличноеПолеДвиженияНУ", Отказ);
		КонецЕсли;
						
		Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетКт) И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ВидУчетаКт) Тогда
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Вид учета Кт'"),
				СтрокаТабличнойЧасти.НомерСтроки + 1, ?(ИмяТабличнойЧасти = "Налоговый", "Налоговый учет", ИмяТабличнойЧасти));
			Поле = "ТабличноеПолеДвиженияНУ" + "[" + (СтрокаТабличнойЧасти.НомерСтроки) + "].ВидУчетаКт";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , "ЭтаФорма.Элементы.ТабличноеПолеДвиженияНУ", Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры


//////////////////////////////////////////////////////////////////////////////////
//// ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Производит замену предопределенных конструкций в формульном выражении
// К формульным конструкциям относятся выражения типа:  Проводка1.СубконтоДт1
//
// Параметры:
//  Формула  - Строка формулы
//  Проводки - ссылка на текущий набор записей регистра бухгалтерии
//
// Возвращаемое значение:
//  Строка - преобразованное формульное выражение
//
Функция ЗаменитьПараметры(Формула, Проводки)

	Для каждого Пров Из Проводки Цикл

		Ном = 1 + Проводки.Индекс(Пров);

		// Субконто Дт
		Если Не Пров.СчетДт.Пустая() Тогда

			ВидыСубконто =Пров.СчетДт.ВидыСубконто;
			Для Каждого Стр Из ВидыСубконто Цикл

				ИндСубк = ВидыСубконто.Индекс(Стр);
				Что     = "Проводка" + Ном + ".СубконтоДт" + (ИндСубк+1);
				НаЧто   = "Проводки[" + (Ном-1) + "].СубконтоДт[ПланыВидовХарактеристик.ВидыСубконтоТиповые.НайтиПоКоду(""" + Стр.ВидСубконто.Код + """)]";
				Формула = СтрЗаменить(Формула, Что, НаЧто);

			КонецЦикла;

		КонецЕсли;

		// Субконто Кт
		Если Не Пров.СчетКт.Пустая() Тогда

			ВидыСубконто =Пров.СчетКт.ВидыСубконто;

			Для Каждого Стр Из ВидыСубконто Цикл

				ИндСубк = ВидыСубконто.Индекс(Стр);
				Что     = "Проводка" + Ном + ".СубконтоКт" + (ИндСубк+1);
				НаЧто   = "Проводки[" + (Ном-1) + "].СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоТиповые.НайтиПоКоду(""" + Стр.ВидСубконто.Код + """)]";
				Формула = СтрЗаменить(Формула, Что, НаЧто);

			КонецЦикла;

		КонецЕсли;

		// остальные поля
		Что     = "Проводка" + Ном;
		НаЧто   = "Проводки[" + (Ном-1) + "]";
		Формула = СтрЗаменить(Формула, Что, НаЧто);

	КонецЦикла;

	Возврат(Формула);

КонецФункции // ЗаменитьПараметры()

// Разбирает строку на две части: до подстроки разделителя и после
//
// Параметры:
//  Стр            - разбираемая строка
//  Разделитель    - подстрока-разделитель
//  Режим          - 0 - разделитель в возвращаемые подстроки не включается
//                   1 - разделитель включается в левую подстроку
//                   2 - разделитель включается в правую подстроку
//
// Возвращаемое значение:
//  Правая часть строки - до символа-разделителя
// 
Функция ОтделитьРазделителем(Стр, Знач Разделитель, Режим=0)

	ПраваяЧасть      = "";
	ПозРазделителя   = Найти(Стр, Разделитель);
	ДлинаРазделителя = СтрДлина(Разделитель);

	Если ПозРазделителя > 0 Тогда
		ПраваяЧасть = Сред(Стр, ПозРазделителя + ?(Режим = 2, 0, ДлинаРазделителя));
		Стр         = СокрЛП(Лев(Стр, ПозРазделителя - ?(Режим = 1, -ДлинаРазделителя + 1, 1)));
	КонецЕсли;

	Возврат(ПраваяЧасть);

КонецФункции // ОтделитьРазделителем()

// Вычислет значение поля (реквизита) проводки в соответствии с настройкой
// шаблона проводки в типовой операции
//
// Параметры:
//  ИмяПоля      - Строка - имя поля. Например: Сумма
//  Проводки	 - ссылка на текущий набор записей регистра бухгалтерии
//  Проводка     - ссылка на текущую запись в наборе регистра бухгалтерии
//  ШаблонЗаписи - ссылка на строку табличной части "Типовой" типовой операции
//  Формулы      - Структура, содержащая формулы полей
//  Параметры	 - Структура, содержащая значения параметров типовой операции
//
// Возвращаемое значение:
//  Значение типа соответствующего типу поля (реквизита) проводки
//
Функция ЗначениеПоля(ИмяПоля, Проводки, Проводка, ШаблонЗаписи, Формулы, Параметры)

	Значение       = Неопределено;
	ПрограммныйКод = "";

	Если Формулы <> Неопределено Тогда

		Формула = СокрЛП(Формулы[СокрЛП(ИмяПоля)]);

		Если Формула <> "" Тогда

			Значение = "";
			Стр      = "";

			Для каждого Пар Из Параметры Цикл
				Стр = Стр + Пар.Ключ + " = Параметры." + Пар.Ключ + ";" + Символы.ПС;
			КонецЦикла;

			Стр = Стр + "Значение = " + ЗаменитьПараметры(Формула, Проводки) + ";";

			Попытка
				Выполнить(Стр);
			Исключение

				СтрокаМодуля    = ОтделитьРазделителем(ОписаниеОшибки(), "{");
				ОписаниеОшибки  = ОтделитьРазделителем(СтрокаМодуля, "}: ");
				Сообщить("Ошибка при вычислении значения поля по формуле: " + ИмяПоля + " - " + ОписаниеОшибки);

			КонецПопытки; 

			Возврат Значение;

		КонецЕсли;

	КонецЕсли;

	Значение = ШаблонЗаписи[ИмяПоля];

	Возврат Значение;

КонецФункции // ЗначениеПоля()


//////////////////////////////////////////////////////////////////////////////////
//// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Заполняет документ на основании типовой операции
//
// Параметры:
//  ТО       - ссылка на элемент справочника Типовые операции. Типовая операция,
//             на основании которой заполняется документ
//  Очистить - Булево - если Истина, то перед заполнением удаляются
//             существующие проводки
//
// Возвращаемое значение:
//  Нет
//
Процедура ЗаполнитьНаОснованииТиповойОперации(ТО, Очистить = Истина) Экспорт

	Проводки    = Движения.Типовой;
	ПроводкиНУ  = Движения.Налоговый;

	Если Очистить = Истина Тогда
		Проводки.Очистить();
		ПроводкиНУ.Очистить();
	КонецЕсли;

	// Инициализация параметров

	Параметры = Новый Структура();

	// Не запрашиваемые параметры
	Для каждого Параметр Из ТО.Параметры Цикл

		Если Не Параметр.НеЗапрашивать Тогда
			Продолжить;
		КонецЕсли;

		Параметры.Вставить(Параметр.Имя, Параметр.Значение);

	КонецЦикла;

	// Запрашиваемые параметры
	Для каждого Параметр Из ЗапрашиваемыеПараметры Цикл
		Параметры.Вставить(Параметр.Имя, Параметр.Значение);
	КонецЦикла;

	// НачалоАлгоритма
	НачалоАлгоритма = "";
	Для каждого Параметр Из Параметры Цикл
		НачалоАлгоритма = НачалоАлгоритма + Параметр.Ключ + " = Параметры." + Параметр.Ключ + ";" + Символы.ПС;
	КонецЦикла;

	// КонецАлгоритма
	КонецАлгоритма = Символы.ПС;
	Для каждого Параметр Из Параметры Цикл
		КонецАлгоритма = КонецАлгоритма + "Параметры." + Параметр.Ключ + " = " + Параметр.Ключ + ";" + Символы.ПС;
	КонецЦикла;

	// АлгоритмПриВводе
	АлгоритмПриВводе = ТО.АлгоритмПриВводе;
	Если Не ПустаяСтрока(АлгоритмПриВводе) Тогда

		Попытка
			Выполнить(НачалоАлгоритма + АлгоритмПриВводе + КонецАлгоритма);
		Исключение

			СтрокаМодуля   = ОтделитьРазделителем(ОписаниеОшибки(), "{");
			ОписаниеОшибки = ОтделитьРазделителем(СтрокаМодуля, "}: ");
			Сообщить("Алгоритм типовой операции (перед формированием проводок):  " + ОписаниеОшибки);

		КонецПопытки;

	КонецЕсли;

	// Неудовлетворяющие условиям проводки будем добавлять в массив
	МассивУдаляемыхПроводок    = Новый Массив;
	МассивУдаляемыхПроводокНУ  = Новый Массив;

	// Заполняем проводки по шаблонам БУ
	Для каждого ШаблонЗаписи Из ТО.Типовой Цикл

		Проводка   = Проводки.Добавить();

		Формулы    = Неопределено;
		СтрФормулы = СокрЛП(ШаблонЗаписи.Формулы);

		Если СтрФормулы <> "" Тогда
			Формулы = ЗначениеИзСтрокиВнутр(СтрФормулы);
		КонецЕсли;

		СубконтоДт1     = "";
		СубконтоДт2     = "";
		СубконтоДт3     = "";

		КоличествоДт    = 0;
		ВалютаДт        = "";
		ВалютнаяСуммаДт = 0;

		СубконтоКт1     = "";
		СубконтоКт2     = "";
		СубконтоКт3     = "";

		КоличествоКт    = 0;
		ВалютаКт        = "";
		ВалютнаяСуммаКт = 0;

		Проводка.СчетДт = ЗначениеПоля("СчетДт", Проводки, Проводка, ШаблонЗаписи, Формулы, Параметры);
		СчетДт          = Проводка.СчетДт;

		Если Не Проводка.СчетДт.Пустая() Тогда

			ВидыСубконто = Проводка.СчетДт.ВидыСубконто;

			Для Каждого Стр Из ВидыСубконто Цикл

				ИмяПеременной = "СубконтоДт" + Строка(1+ВидыСубконто.Индекс(Стр));
				Зн            = ЗначениеПоля(ИмяПеременной, Проводки, Проводка, ШаблонЗаписи, Формулы, Параметры);
				Проводка.СубконтоДт[Стр.ВидСубконто] = Зн;

				Выполнить(ИмяПеременной + " = Зн;");

			КонецЦикла;

			Если Проводка.СчетДт.Количественный Тогда
				Проводка.КоличествоДт = ЗначениеПоля("КоличествоДт", Проводки, Проводка, ШаблонЗаписи, Формулы, Параметры);
				КоличествоДт          = Проводка.КоличествоДт;
			КонецЕсли;

			Если Проводка.СчетДт.Валютный Тогда

				Проводка.ВалютаДт        = ЗначениеПоля("ВалютаДт", Проводки, Проводка, ШаблонЗаписи, Формулы, Параметры);
				ВалютаДт                 = Проводка.ВалютаДт;
				Проводка.ВалютнаяСуммаДт = ЗначениеПоля("ВалютнаяСуммаДт", Проводки, Проводка, ШаблонЗаписи, Формулы, Параметры);
				ВалютнаяСуммаДт          = Проводка.ВалютнаяСуммаДт;

			КонецЕсли;

		КонецЕсли;

		Проводка.СчетКт = ЗначениеПоля("СчетКт", Проводки, Проводка, ШаблонЗаписи, Формулы, Параметры);
		СчетКт          = Проводка.СчетКт;

		Если Не Проводка.СчетКт.Пустая() Тогда

			ВидыСубконто = Проводка.СчетКт.ВидыСубконто;

			Для Каждого Стр Из ВидыСубконто Цикл

				ИмяПеременной = "СубконтоКт" + Строка(1+ВидыСубконто.Индекс(Стр));
				Зн            = ЗначениеПоля(ИмяПеременной, Проводки, Проводка, ШаблонЗаписи, Формулы, Параметры);
				Проводка.СубконтоКт[Стр.ВидСубконто] = Зн;

				Выполнить(ИмяПеременной + " = Зн;");

			КонецЦикла;

			Если Проводка.СчетКт.Количественный Тогда
				Проводка.КоличествоКт = ЗначениеПоля("КоличествоКт", Проводки, Проводка, ШаблонЗаписи, Формулы, Параметры);
				КоличествоКт          = Проводка.КоличествоКт;
			КонецЕсли;

			Если Проводка.СчетКт.Валютный Тогда

				Проводка.ВалютаКт        = ЗначениеПоля("ВалютаКт", Проводки, Проводка, ШаблонЗаписи, Формулы, Параметры);
				ВалютаКт                 = Проводка.ВалютаКт;
				Проводка.ВалютнаяСуммаКт = ЗначениеПоля("ВалютнаяСуммаКт", Проводки, Проводка, ШаблонЗаписи, Формулы, Параметры);
				ВалютнаяСуммаКт          = Проводка.ВалютнаяСуммаКт;

			КонецЕсли;

		КонецЕсли;

		Проводка.Сумма        = ЗначениеПоля("Сумма", Проводки, Проводка, ШаблонЗаписи, Формулы, Параметры);
		Сумма                 = Проводка.Сумма;

		Проводка.НомерЖурнала = ЗначениеПоля("НомерЖурнала", Проводки, Проводка, ШаблонЗаписи, Формулы, Параметры);
		НомерЖурнала          = Проводка.НомерЖурнала;

		Проводка.Содержание   = ЗначениеПоля("Содержание", Проводки, Проводка, ШаблонЗаписи, Формулы, Параметры);

		// Условие формирования проводки
		СтрокаУсловия = ШаблонЗаписи.Условие;

		Если Не ПустаяСтрока(СтрокаУсловия) Тогда

			УсловиеВыполняется = Ложь;
			АлгоритмУсловия    = НачалоАлгоритма + "УсловиеВыполняется = " + ЗаменитьПараметры(СтрокаУсловия, Проводки) + ";";

			Попытка

				Выполнить(АлгоритмУсловия);

				Если Не УсловиеВыполняется Тогда
					МассивУдаляемыхПроводок.Добавить(Проводка);
				КонецЕсли;

			Исключение

				СтрокаМодуля    = ОтделитьРазделителем(ОписаниеОшибки(), "{");
				ОписаниеОшибки  = ОтделитьРазделителем(СтрокаМодуля, "}: ");
				Сообщить("Условие формирования проводки №" + (1 + ТО.Типовой.Индекс(ШаблонЗаписи))  + " " + ОписаниеОшибки);

			КонецПопытки;

		КонецЕсли;

	КонецЦикла; // по шаблонам проводок

	// Заполняем проводки по шаблонам НУ
	Для каждого ШаблонЗаписи Из ТО.Налоговый Цикл

		Проводка   = ПроводкиНУ.Добавить();

		Формулы    = Неопределено;
		СтрФормулы = СокрЛП(ШаблонЗаписи.Формулы);

		Если СтрФормулы <> "" Тогда
			Формулы = ЗначениеИзСтрокиВнутр(СтрФормулы);
		КонецЕсли;

		СубконтоДт1     = "";
		СубконтоДт2     = "";
		СубконтоДт3     = "";

		КоличествоДт    = 0;

		СубконтоКт1     = "";
		СубконтоКт2     = "";
		СубконтоКт3     = "";

		КоличествоКт    = 0;

		Проводка.СчетДт = ЗначениеПоля("СчетДт", ПроводкиНУ, Проводка, ШаблонЗаписи, Формулы, Параметры);
		СчетДт          = Проводка.СчетДт;

		Если Не Проводка.СчетДт.Пустая() Тогда

			ВидыСубконто = Проводка.СчетДт.ВидыСубконто;

			Для Каждого Стр Из ВидыСубконто Цикл

				ИмяПеременной = "СубконтоДт" + Строка(1+ВидыСубконто.Индекс(Стр));
				Зн            = ЗначениеПоля(ИмяПеременной, ПроводкиНУ, Проводка, ШаблонЗаписи, Формулы, Параметры);
				Проводка.СубконтоДт[Стр.ВидСубконто] = Зн;

				Выполнить(ИмяПеременной + " = Зн;");

			КонецЦикла;

			Если Проводка.СчетДт.Количественный Тогда
				Проводка.КоличествоДт = ЗначениеПоля("КоличествоДт", ПроводкиНУ, Проводка, ШаблонЗаписи, Формулы, Параметры);
				КоличествоДт          = Проводка.КоличествоДт;
			КонецЕсли;

		КонецЕсли;

		Проводка.СчетКт = ЗначениеПоля("СчетКт", ПроводкиНУ, Проводка, ШаблонЗаписи, Формулы, Параметры);
		СчетКт          = Проводка.СчетКт;

		Если Не Проводка.СчетКт.Пустая() Тогда

			ВидыСубконто = Проводка.СчетКт.ВидыСубконто;

			Для Каждого Стр Из ВидыСубконто Цикл

				ИмяПеременной = "СубконтоКт" + Строка(1+ВидыСубконто.Индекс(Стр));
				Зн            = ЗначениеПоля(ИмяПеременной, ПроводкиНУ, Проводка, ШаблонЗаписи, Формулы, Параметры);
				Проводка.СубконтоКт[Стр.ВидСубконто] = Зн;

				Выполнить(ИмяПеременной + " = Зн;");

			КонецЦикла;

			Если Проводка.СчетКт.Количественный Тогда
				Проводка.КоличествоКт = ЗначениеПоля("КоличествоКт", ПроводкиНУ, Проводка, ШаблонЗаписи, Формулы, Параметры);
				КоличествоКт          = Проводка.КоличествоКт;
			КонецЕсли;

		КонецЕсли;

		Проводка.Сумма        = ЗначениеПоля("Сумма", ПроводкиНУ, Проводка, ШаблонЗаписи, Формулы, Параметры);
		Сумма                 = Проводка.Сумма;

		Проводка.НомерЖурнала = ЗначениеПоля("НомерЖурнала", ПроводкиНУ, Проводка, ШаблонЗаписи, Формулы, Параметры);
		НомерЖурнала          = Проводка.НомерЖурнала;

		Проводка.ВидУчетаДт   = ЗначениеПоля("ВидУчетаДт", ПроводкиНУ, Проводка, ШаблонЗаписи, Формулы, Параметры);
		ВидУчета              = Проводка.ВидУчетаДт;

		Проводка.ВидУчетаКт   = ЗначениеПоля("ВидУчетаКт", ПроводкиНУ, Проводка, ШаблонЗаписи, Формулы, Параметры);
		ВидУчета              = Проводка.ВидУчетаКт;

		Проводка.Содержание   = ЗначениеПоля("Содержание", ПроводкиНУ, Проводка, ШаблонЗаписи, Формулы, Параметры);

		// Условие формирования проводки
		СтрокаУсловия = ШаблонЗаписи.Условие;

		Если Не ПустаяСтрока(СтрокаУсловия) Тогда

			УсловиеВыполняется = Ложь;
			АлгоритмУсловия    = НачалоАлгоритма + "УсловиеВыполняется = " + ЗаменитьПараметры(СтрокаУсловия, ПроводкиНУ) + ";";

			Попытка

				Выполнить(АлгоритмУсловия);

				Если Не УсловиеВыполняется Тогда
					МассивУдаляемыхПроводокНУ.Добавить(Проводка);
				КонецЕсли;

			Исключение

				СтрокаМодуля    = ОтделитьРазделителем(ОписаниеОшибки(), "{");
				ОписаниеОшибки  = ОтделитьРазделителем(СтрокаМодуля, "}: ");
				Сообщить("Условие формирования проводки (НУ) №" + (1 + ТО.Налоговый.Индекс(ШаблонЗаписи))  + " " + ОписаниеОшибки);

			КонецПопытки;

		КонецЕсли;

	КонецЦикла; // по шаблонам проводок

	// Выполним алгоритм после формирования проводок
	АлгоритмОперации = СокрЛП(ТО.АлгоритмПослеВвода);
	Если Не ПустаяСтрока(АлгоритмОперации) Тогда

		Попытка
			Выполнить(НачалоАлгоритма + ЗаменитьПараметры(АлгоритмОперации, Проводки));
		Исключение
			СтрокаМодуля    = ОтделитьРазделителем(ОписаниеОшибки(), "{");
			ОписаниеОшибки  = ОтделитьРазделителем(СтрокаМодуля, "}: ");
			Сообщить("Алгоритм типовой операции (после формирования проводок):  " + ОписаниеОшибки);
		КонецПопытки; 

	КонецЕсли;

	// Вычислим содержание операции по формуле
	ФормулаСодержания = СокрЛП(ТО.ФормулаСодержания);
	Если ФормулаСодержания <> "" Тогда

		АлгоритмСодержания = НачалоАлгоритма + "Содержание = " + ЗаменитьПараметры(ФормулаСодержания, Проводки) + ";";

		Попытка
			Выполнить(АлгоритмСодержания);
		Исключение
			СтрокаМодуля    = ОтделитьРазделителем(ОписаниеОшибки(), "{");
			ОписаниеОшибки  = ОтделитьРазделителем(СтрокаМодуля, "}: ");
			Сообщить("Формула содержания операции:  " + ОписаниеОшибки);
		КонецПопытки;

	КонецЕсли;

	// Вычислим сумму операции по формуле
	ФормулаСуммыОперации = СокрЛП(ТО.ФормулаСуммыОперации);
	Если ФормулаСуммыОперации <> "" Тогда

		АлгоритмСуммыОперации = НачалоАлгоритма + "СуммаОперации = " + ЗаменитьПараметры(ФормулаСуммыОперации, Проводки) + ";";

		Попытка
			Выполнить(АлгоритмСуммыОперации);
		Исключение
			СтрокаМодуля    = ОтделитьРазделителем(ОписаниеОшибки(), "{");
			ОписаниеОшибки  = ОтделитьРазделителем(СтрокаМодуля, "}: ");
			Сообщить("Формула суммы операции:  " + ОписаниеОшибки);
		КонецПопытки;

	КонецЕсли;

	// Удалим неудовлетворяющие условиям проводки
	Для каждого Проводка Из МассивУдаляемыхПроводок Цикл
		Проводки.Удалить(Проводка);
	КонецЦикла;

	// Удалим неудовлетворяющие условиям проводки
	Для каждого Проводка Из МассивУдаляемыхПроводокНУ Цикл
		ПроводкиНУ.Удалить(Проводка);
	КонецЦикла;    	

КонецПроцедуры // ЗаполнитьНаОснованииТиповойОперации()

#КонецЕсли

