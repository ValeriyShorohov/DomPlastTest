#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура НайтиНеиспользуемыеЭлементыСправочникаВФоне(Адрес) Экспорт
	
	ДатаЗапуска =  ВСОбщегоНазначения.ТекущаяДатаПользователя();
	
	Если НЕ ВССерверПереопределяемый.ЭтоПолноправныйПользователь() Тогда
		ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(НСтр("ru='Недостаточно прав для выполнения операции'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	//Вспомогательные данные, которые заполняются и используются в процессе удаления
	ВедущиеИзмеренияРегистровСведений = Неопределено;
	ВсеПодчиненныеСправочники = Неопределено;
										
	ИмяСправочника = "ИсточникиПроисхождения" ;
	ПредставлениеСправочника = "Источники происхождения";
	РазмерПорции = 100;
		
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|Ссылка
		|ПОМЕСТИТЬ ВыборкаСправочник
		|ИЗ Справочник."+ИмяСправочника+" КАК Справочник
		|ГДЕ (НЕ Справочник.Предопределенный)";
		Запрос.Выполнить();
	СчетчикВсегоОбъектов = 0;
	
	//Посчитаем сколько всего позиций будет обработано
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;

	Запрос.Текст = "ВЫБРАТЬ
	|Количество(Ссылка) КАК Количество
	|ИЗ ВыборкаСправочник
	|";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СчетчикВсегоОбъектов = Выборка.Количество;
	КонецЕсли;
	Если СчетчикВсегоОбъектов = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ВедущиеИзмеренияРегистровСведений = Неопределено Тогда
		ВедущиеИзмеренияРегистровСведений = Новый Соответствие;
	КонецЕсли;
	
	//Поиск у каких справочников данный справочник является владельцем
	ПодчиненныеСправочники = Новый Соответствие;
	Если ВсеПодчиненныеСправочники = Неопределено Тогда
		ВсеПодчиненныеСправочники = Новый Структура;
		Для каждого Справочник Из Метаданные.Справочники Цикл
			ИмяПодчиненного = Справочник.Имя;
			Если Справочник.Владельцы.Количество() > 0 Тогда
				МассивВладельцев = Новый Массив;
				Для каждого СправочникВладелец Из Справочник.Владельцы Цикл
					МассивВладельцев.Добавить(СправочникВладелец.Имя);
					Если СправочникВладелец.Имя = ИмяСправочника Тогда
						ПодчиненныеСправочники.Вставить(ИмяПодчиненного, Тип("СправочникСсылка."+ИмяПодчиненного)); 
					КонецЕсли;
				КонецЦикла;
				ВсеПодчиненныеСправочники.Вставить(ИмяПодчиненного, МассивВладельцев);
			КонецЕсли;
		КонецЦикла;
	Иначе
		Для Каждого ПодчиненныйСправочник ИЗ ВсеПодчиненныеСправочники Цикл
			ИмяПодчиненного = ПодчиненныйСправочник.Ключ;
			МассивВладельцев = ПодчиненныйСправочник.Значение;
			Если МассивВладельцев.Найти(ИмяСправочника) <> Неопределено Тогда
				ПодчиненныеСправочники.Вставить(ИмяПодчиненного, Тип("СправочникСсылка."+ИмяПодчиненного)); 
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	МассивОбработанныхЭлементов = Новый Массив();
	МассивЭлементовКУдалению = Новый Массив();
	МассивПодчиненныхЭлементовКУдалению = Новый Массив();

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ "+РазмерПорции+"
	|	Ссылка
	|ИЗ
	|	ВыборкаСправочник
	|ГДЕ
	|	
	| НЕ Ссылка В (&МассивОбработанныхЭлементов)
	|";
	
	Запрос.УстановитьПараметр("МассивОбработанныхЭлементов", Новый Массив);
	РезультатЗапроса = Запрос.Выполнить();
	
	Пока НЕ РезультатЗапроса.Пустой() Цикл //Обработка порциями
		МассивСсылок = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		//запомним обрабатываемые элементы для следующего прохода
		Для Каждого ЭлементМассива ИЗ МассивСсылок Цикл
			МассивОбработанныхЭлементов.Добавить(ЭлементМассива);
		КонецЦикла;
		
		ТабСсылок = НайтиПоСсылкам(МассивСсылок);
		
		МассивТиповСсылкиНаПодчиненныеСправочники = Новый Массив;
		МассивЭлементовСоСсылкамиНаПодчиненные = Новый Массив;
		МассивСтрокКУдалению = Новый Массив();
		
		//Из таблицы ссылок необходимо удалить лишние строки 
		//1) которые являются исключением 
		//2) Данные = Регистр сведений со ссылкой на ведущее измерение
		Для Каждого СтрокаТаблицыСсылок Из ТабСсылок Цикл
			ПолноеИмяЗависимогоОбъекта = СтрокаТаблицыСсылок.Метаданные.ПолноеИмя();
			//Проверка того что ссылка является исключением
			Если ПодчиненныеСправочники.Количество() > 0 
				И ВСОбщегоНазначения.ЭтоСправочник(СтрокаТаблицыСсылок.Метаданные)  Тогда
				//Возможно это ссылка из подчиненного справочника - запишем чтобы потом обработать отдельно
				Если ПодчиненныеСправочники[СтрокаТаблицыСсылок.Метаданные.Имя] <> Неопределено И
					СтрокаТаблицыСсылок.Данные.Владелец = СтрокаТаблицыСсылок.Ссылка Тогда
					ТипДанных = ТипЗнч(СтрокаТаблицыСсылок.Данные);
					Если  МассивТиповСсылкиНаПодчиненныеСправочники.Найти(ТипДанных) = Неопределено Тогда
						МассивТиповСсылкиНаПодчиненныеСправочники.Добавить(ТипДанных);
					КонецЕсли;
					Если МассивЭлементовСоСсылкамиНаПодчиненные.Найти(СтрокаТаблицыСсылок.Ссылка) = Неопределено Тогда
						МассивЭлементовСоСсылкамиНаПодчиненные.Добавить(СтрокаТаблицыСсылок.Ссылка);
					КонецЕсли;
				КонецЕсли;
				Продолжить;
			КонецЕсли;
			
			Если НЕ ВСОбщегоНазначения.ЭтоРегистрСведений(СтрокаТаблицыСсылок.Метаданные) Тогда
				Продолжить;
			КонецЕсли;
			
			ВедущиеИзмерения = ВедущиеИзмеренияРегистровСведений[ПолноеИмяЗависимогоОбъекта];

			Если ВедущиеИзмерения = Неопределено Тогда
				// Заполнение измерений
				ВедущиеИзмерения = Новый Массив;
				ВедущиеИзмеренияРегистровСведений.Вставить(ПолноеИмяЗависимогоОбъекта, ВедущиеИзмерения);

				Для каждого Измерение Из СтрокаТаблицыСсылок.Метаданные.Измерения Цикл
					Если Измерение.Ведущее Тогда
						ВедущиеИзмерения.Добавить(Измерение.Имя);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если ВедущиеИзмерения.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			УдаляемыйОбъектВВедущемИзмерении = Ложь;
			Для Каждого ВедущееИзмерение ИЗ ВедущиеИзмерения Цикл
				Если СтрокаТаблицыСсылок.Данные[ВедущееИзмерение] = СтрокаТаблицыСсылок.Ссылка Тогда
					УдаляемыйОбъектВВедущемИзмерении = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если УдаляемыйОбъектВВедущемИзмерении Тогда
				МассивСтрокКУдалению.Добавить(СтрокаТаблицыСсылок);
			КонецЕсли;
		КонецЦикла;
		//Удаление лишних строк из таблицы ссылок
		Для Каждого СтрокаТЗ ИЗ МассивСтрокКУдалению Цикл
			ТабСсылок.Удалить(СтрокаТЗ);
		КонецЦикла;
		
		//Поиск позиций, на которые нет ссылок
		ЗапросНаУдаление = Новый Запрос;
		ЗапросНаУдаление.МенеджерВременныхТаблиц = МенеджерВТ;
		ЗапросНаУдаление.Текст = 
		"ВЫБРАТЬ 
		|	Ссылка 
		|ИЗ
		|	ВыборкаСправочник
		|ГДЕ
		|	(НЕ Ссылка В (&СписокИспользуемых))
		|	И Ссылка В (&ТекущаяПорция)
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка
		|АВТОУПОРЯДОЧИВАНИЕ";
		
		ТабСсылокСвернутая = ТабСсылок.Скопировать();
		ТабСсылокСвернутая.Свернуть("Ссылка");

		ЗапросНаУдаление.УстановитьПараметр("СписокИспользуемых", ТабСсылокСвернутая.ВыгрузитьКолонку("Ссылка"));
		//Явно задаем состав обрабатываемой порции, чтобы не удалилось лишнего
		ЗапросНаУдаление.УстановитьПараметр("ТекущаяПорция", МассивСсылок);      
		
		Результат = ЗапросНаУдаление.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Пока Выборка.Следующий() Цикл
				МассивЭлементовКУдалению.Добавить(Выборка.Ссылка);
			КонецЦикла;
		КонецЕсли;
		
		//Обработка справочников, имеющих подчиненные элементы
		Если МассивТиповСсылкиНаПодчиненныеСправочники.Количество() > 0 
			И МассивЭлементовСоСсылкамиНаПодчиненные.Количество() > 0 Тогда
			
			ОписаниеТиповПодчиненныеСправочники = Новый ОписаниеТипов(МассивТиповСсылкиНаПодчиненныеСправочники);
			
			//Поиск позиций справочника, ссылки на который есть только у подчиненных справочников
			Для Каждого ТекЭлемент Из МассивЭлементовСоСсылкамиНаПодчиненные Цикл
				МассивСсылокНаЭлемент = ТабСсылок.НайтиСтроки(Новый Структура("Ссылка", ТекЭлемент));
				СсылкиНаПодчиненныеЭлементы = Новый Массив;
				СсылкиТолькоНаПодчиненныеЭлементы = Истина;
				Для Каждого СтрокаСсылок из МассивСсылокНаЭлемент Цикл
					Если ОписаниеТиповПодчиненныеСправочники.СодержитТип(ТипЗнч(СтрокаСсылок.Данные))
						И СтрокаСсылок.Данные.Владелец = текЭлемент Тогда
						СсылкиНаПодчиненныеЭлементы.Добавить(СтрокаСсылок.Данные);
					Иначе
						СсылкиТолькоНаПодчиненныеЭлементы = Ложь;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если НЕ СсылкиТолькоНаПодчиненныеЭлементы Тогда
					Продолжить;
				КонецЕсли;
				//На текущий элемент справочника есть ссылки только у подчиненных справочников
				//Поиск ссылок на подчиненные справочники
				ТабСсылокНаПодчиненные = НайтиПоСсылкам(СсылкиНаПодчиненныеЭлементы);
				МожноУдалятьПодчиненные = Ложь;
				Если ТабСсылокНаПодчиненные.Количество() = 0 Тогда
					МожноУдалятьПодчиненные = Истина;
				Иначе
					//проверка, возможно ссылки только на элемент-владелец
					МожноУдалятьПодчиненные = Истина;
					Для Каждого СтрокаСсылкиНаПодчиненные ИЗ ТабСсылокНаПодчиненные Цикл
						Если СтрокаСсылкиНаПодчиненные.Данные <> текЭлемент Тогда
							МожноУдалятьПодчиненные = Ложь;
							Прервать;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
				Если МожноУдалятьПодчиненные Тогда
					Для Каждого ПодчиненныйЭлемент ИЗ СсылкиНаПодчиненныеЭлементы Цикл
						МассивПодчиненныхЭлементовКУдалению.Добавить(ПодчиненныйЭлемент);
					КонецЦикла;
					//Удаление текущего элемента справочника
					МассивЭлементовКУдалению.Добавить(текЭлемент);
				КонецЕсли;
			КонецЦикла; //Для Каждого ТекЭлемент Из МассивЭлементовСоСсылкамиНаПодчиненные Цикл
		КонецЕсли;  //Если МассивТиповСсылкиНаПодчиненныеСправочники.Количество() > 0
		//Получим очередную порцию данных
		Запрос.УстановитьПараметр("МассивОбработанныхЭлементов", МассивОбработанныхЭлементов);
		РезультатЗапроса = Запрос.Выполнить();
		
	КонецЦикла;  //Пока Истина Цикл //Обработка порциями
	
	РезультатПоиска = Новый Структура;
	РезультатПоиска.Вставить("МассивПодчиненныхЭлементовКУдалению", МассивПодчиненныхЭлементовКУдалению);
	РезультатПоиска.Вставить("МассивЭлементовКУдалению",			МассивЭлементовКУдалению);
	
	ПоместитьВоВременноеХранилище(РезультатПоиска, Адрес);

КонецПроцедуры

Процедура УдалитьНеиспользуемыеИсточникиПроисхождения(ТаблицаНеиспользуемыхИсточников, Адрес) Экспорт
	
	СчетчикУдаленныхОбъектов = 0;
	КоличествоСтрокКУдалению = 0;
	МассивУдаленныхСтрок = Новый Массив;                                                                                               
	Для Каждого СтрокаИсточник Из ТаблицаНеиспользуемыхИсточников Цикл
		Если  НЕ СтрокаИсточник.Пометка Тогда
			Продолжить;
		КонецЕсли;
		КоличествоСтрокКУдалению = КоличествоСтрокКУдалению + 1;		
		УдалитьЭлементСправочника(СтрокаИсточник.ИсточникПроисхождения,СчетчикУдаленныхОбъектов, МассивУдаленныхСтрок);		
	КонецЦикла;
	//Обновим таблицу неиспользуемых источников:
	 Запрос = Новый Запрос;
	 Запрос.УстановитьПараметр("ТаблицаИсточников", ТаблицаНеиспользуемыхИсточников);
	 Запрос.УстановитьПараметр("МассивИсточниковУдаленных", МассивУдаленныхСтрок);
	 
	 Запрос.Текст = "ВЫБРАТЬ
	                |	Источники.ИсточникПроисхождения КАК ИсточникПроисхождения
	                |ПОМЕСТИТЬ ВТ_Таблица
	                |ИЗ
	                |	&ТаблицаИсточников КАК Источники
	                |ГДЕ
	                |	НЕ Источники.ИсточникПроисхождения В (&МассивИсточниковУдаленных)
	                |;
	                |
	                |////////////////////////////////////////////////////////////////////////////////
	                |ВЫБРАТЬ
	                |	ВТ_Источники.ИсточникПроисхождения,
	                |	ЛОЖЬ КАК Пометка
	                |ИЗ
	                |	ВТ_Таблица КАК ВТ_Источники"; 
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	ТекстСообщения = ЭСФКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(НСтр("ru='Удалено элементов: %1 из %2'"),СчетчикУдаленныхОбъектов, КоличествоСтрокКУдалению); 
	ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения);
	
	ПоместитьВоВременноеХранилище(РезультатЗапроса, Адрес);
КонецПроцедуры

Процедура УдалитьЭлементСправочника(Ссылка, СчетчикУдаленныхОбъектов, МассивУдаленныхСтрок)
	
	ПредставлениеОбъекта = СокрЛП(Ссылка);
	МетаданныеОбъекта = Ссылка.Метаданные();
		
	Попытка
		СпрОбъект = Ссылка.ПолучитьОбъект();
		СпрОбъект.Удалить();
	Исключение
		УровеньЖурнала = УровеньЖурналаРегистрации.Ошибка;
		ИмяСобытия = НСтр("ru='Не удалось удалить элемент справочника'")+ПредставлениеОбъекта + ОписаниеОшибки() ;
		
		ЗаписьЖурналаРегистрации(НСтр("ru='УдалениеНеиспользуемыхИсточниковПроисхождения'"),
				УровеньЖурнала,
				МетаданныеОбъекта,
				Ссылка,
				ИмяСобытия
				);
 		ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(ИмяСобытия);		
		
		Возврат;
	КонецПопытки;
	
	УровеньЖурнала = УровеньЖурналаРегистрации.Информация;
	ИмяСобытия = НСтр("ru='Удален:'") + " " + ПредставлениеОбъекта;
	
	ЗаписьЖурналаРегистрации(НСтр("ru='УдалениеНеиспользуемыхИсточниковПроисхождения'"),
				УровеньЖурнала,
				МетаданныеОбъекта,
				Ссылка,
				ИмяСобытия
				);

	СчетчикУдаленныхОбъектов = СчетчикУдаленныхОбъектов + 1;
	МассивУдаленныхСтрок.Добавить(Ссылка);
	
КонецПроцедуры

#КонецЕсли