////////////////////////////////////////////////////////////////////////////////
// ИнтеграцияWebKassaКлиентСервер: общий механизм интеграции с сервисом 1С:WebKassa.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция возвращает описание ошибки сервиса.
//
Функция ПолучитьОписаниеОшибки(КодОшибки) Экспорт
	
	ОписаниеОшибки = "";
	Если КодОшибки = 1 Тогда
		ОписаниеОшибки = НСтр("ru='Неверный логин и/или пароль'");
	ИначеЕсли КодОшибки = 2 Тогда
		ОписаниеОшибки = НСтр("ru='Срок действия сессии истек'");
	ИначеЕсли КодОшибки = 3 Тогда
		ОписаниеОшибки = НСтр("ru='Пользователь не авторизован'");
	ИначеЕсли КодОшибки = 4 Тогда
		ОписаниеОшибки = НСтр("ru='Нет доступа к операции'");
	ИначеЕсли КодОшибки = 5 Тогда
		ОписаниеОшибки = НСтр("ru='Нет доступа к кассе'");
	ИначеЕсли КодОшибки = 6 Тогда
		ОписаниеОшибки = НСтр("ru='Касса не найдена'");
	ИначеЕсли КодОшибки = 7 Тогда
		ОписаниеОшибки = НСтр("ru='Касса заблокирована'");
	ИначеЕсли КодОшибки = 8 Тогда
		ОписаниеОшибки = НСтр("ru='Недостаточно суммы для изъятия'");
	ИначеЕсли КодОшибки = 9 Тогда
		ОписаниеОшибки = НСтр("ru='Ошибка валидации данных'");
	ИначеЕсли КодОшибки = 10 Тогда
		ОписаниеОшибки = НСтр("ru='Касса не активирована'");
	ИначеЕсли КодОшибки = 11 Тогда
		ОписаниеОшибки = НСтр("ru='Продолжительность смены превышает 24 часа. Для продолжения работы необходимо закрыть смену'");
	ИначеЕсли КодОшибки = 12 Тогда
		ОписаниеОшибки = НСтр("ru='Смена уже закрыта'");
	ИначеЕсли КодОшибки = 13 Тогда
		ОписаниеОшибки = НСтр("ru='Не найдена открытая смена'");
	ИначеЕсли КодОшибки = 14 Тогда
		ОписаниеОшибки = НСтр("ru='Дублирующийся код системы-источника'");
	ИначеЕсли КодОшибки = 15 Тогда
		ОписаниеОшибки = НСтр("ru='Смена не найдена'");
	ИначеЕсли КодОшибки = 1000 Тогда
		ОписаниеОшибки = НСтр("ru='Данная организация уже существует'");
	ИначеЕсли КодОшибки = 1001 Тогда
		ОписаниеОшибки = НСтр("ru='Данный пользователь уже существует'");
	ИначеЕсли КодОшибки = 1002 Тогда
		ОписаниеОшибки = НСтр("ru='Касса с данными идентификационными параметрами уже зарегистрирована в системе'");
	ИначеЕсли КодОшибки = 1003 Тогда
		ОписаниеОшибки = НСтр("ru='Активационная карта была использована ранее'");
	ИначеЕсли КодОшибки = 1004 Тогда
		ОписаниеОшибки = НСтр("ru='Неверные активационные данные'");
	ИначеЕсли КодОшибки = 1014 Тогда
		ОписаниеОшибки = НСтр("ru='Данная смена открыта. Z-отчет отсутствует.'");
	ИначеЕсли КодОшибки = 1015 Тогда
		ОписаниеОшибки = НСтр("ru='Компания партнер не найдена'");
	ИначеЕсли КодОшибки = 1016 Тогда
		ОписаниеОшибки = НСтр("ru='Неверный код подтверждения'");
	ИначеЕсли КодОшибки = 1017 Тогда
		ОписаниеОшибки = НСтр("ru='Перевод кассы невозможен. Имеются лицензии в ожидании активации.'");
	Иначе
		ОписаниеОшибки = НСтр("ru=''");
	КонецЕсли;
	
	Возврат ОписаниеОшибки;
	
КонецФункции

// Возвращает строковую константу для формирования сообщений журнала регистрации.
//
// Возвращаемое значение:
//   Строка
//
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Интеграция 1С:WebKassa'");
	
КонецФункции

// Функция выполняет запрос к сервису и возвращает результат выполнения операции.
//
Функция ОтправитьЗапросНаСервисWebkassa(АдресСервиса, ПутьОперации, ЗапросJSON) Экспорт
	
	РезультатЗапроса = Неопределено;
	
	СтруктураАдреса = ИнтеграцияWebKassaКлиентСерверПереопределяемый.СтруктураURI(АдресСервиса);
	Если НРег(СтруктураАдреса.Схема) = "https" Тогда
		SSL = Новый ЗащищенноеСоединениеOpenSSL(Неопределено, Неопределено);
	Иначе
		SSL = Неопределено;
	КонецЕсли;
	
	Прокси = ИнтеграцияWebKassaКлиентСерверПереопределяемый.ПолучитьПрокси(НРег(СтруктураАдреса.Схема));
	Таймаут = 60; // таймаут запроса (в секундах)
	
	Попытка
		HTTPСоединение = Новый HTTPСоединение(СтруктураАдреса.Хост, СтруктураАдреса.Порт,,, Прокси,Таймаут, SSL);
		HTTPЗапрос = Новый HTTPЗапрос(ПутьОперации);
		HTTPЗапрос.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
		HTTPЗапрос.Заголовки.Вставить("Content-Charset", "utf-8");
		HTTPЗапрос.УстановитьТелоИзСтроки(ЗапросJSON, "UTF-8");//, ИспользованиеByteOrderMark.НеИспользовать);
		ОтветСервиса = HTTPСоединение.ОтправитьДляОбработки(HTTPЗапрос);
		РезультатЗапроса = ОтветСервиса.ПолучитьТелоКакСтроку("UTF-8");
	Исключение
		РезультатЗапроса = Неопределено;
	КонецПопытки;
	
	Возврат РезультатЗапроса;
	
КонецФункции

// Рассчитывает ставку НДС по значениям суммы позиции и суммы НДС
//
Функция ВычислитьСтавкуНДС(ПозицияЧека) Экспорт
	
	СуммаПозиции = Окр(ПозицияЧека.Price * ПозицияЧека.Count, 2);
	СтавкаНДС = Окр(ПозицияЧека.Tax * 100 / (СуммаПозиции - ПозицияЧека.Discount + ПозицияЧека.Markup - ПозицияЧека.Tax),0);
	Возврат СтавкаНДС;
	
КонецФункции

Процедура ДополнитьФорматДанныхЧека(СтруктураДанных) Экспорт
	
	ОФД = Новый Структура;
	ОФД.Вставить("Host", "");
	ОФД.Вставить("Name","");
	ОФД.Вставить("Code", 0);
	ИнформацияОКассе = Новый Структура;
	ИнформацияОКассе.Вставить("UniqueNumber", "");
	ИнформацияОКассе.Вставить("RegistrationNumber", "");
	ИнформацияОКассе.Вставить("IdentityNumber", "");
	ИнформацияОКассе.Вставить("Address", "");
	ИнформацияОКассе.Вставить("Ofd", ОФД);
	ШаблоннаяСтруктураДанных = Новый Структура;
	ШаблоннаяСтруктураДанных.Вставить("CheckNumber", "");
	ШаблоннаяСтруктураДанных.Вставить("DateTime", Дата(1, 1, 1, 0, 0, 0));
	ШаблоннаяСтруктураДанных.Вставить("OfflineMode", Ложь);
	ШаблоннаяСтруктураДанных.Вставить("CashboxOfflineMode", Ложь);
	ШаблоннаяСтруктураДанных.Вставить("CheckOrderNumber", 0);
	ШаблоннаяСтруктураДанных.Вставить("ShiftNumber", 0);
	ШаблоннаяСтруктураДанных.Вставить("EmployeeName", "");
	ШаблоннаяСтруктураДанных.Вставить("TicketUrl", "");
	ШаблоннаяСтруктураДанных.Вставить("TicketPrintUrl", "");
	ШаблоннаяСтруктураДанных.Вставить("Cashbox", ИнформацияОКассе);
	
	ПроверитьУровеньСтруктуры(СтруктураДанных, ШаблоннаяСтруктураДанных);
	
КонецПроцедуры

Процедура ДополнитьФорматДанныхЧекаИстории(СтруктураДанных) Экспорт
	
	ШаблоннаяСтруктураДанных = Новый Структура;
	ШаблоннаяСтруктураДанных.Вставить("Address", "");
	ШаблоннаяСтруктураДанных.Вставить("CashboxIdentityNumber", 0);
	ШаблоннаяСтруктураДанных.Вставить("CashboxRegistrationNumber", "");
	ШаблоннаяСтруктураДанных.Вставить("CashboxUniqueNumber", "");
	ШаблоннаяСтруктураДанных.Вставить("Change", 0);
	ШаблоннаяСтруктураДанных.Вставить("CustomerXin", "");
	ШаблоннаяСтруктураДанных.Вставить("Discount", 0);
	ШаблоннаяСтруктураДанных.Вставить("DocumentNumber", 0);
	ШаблоннаяСтруктураДанных.Вставить("EmployeeCode", 0);
	ШаблоннаяСтруктураДанных.Вставить("EmployeeName", "");
	ШаблоннаяСтруктураДанных.Вставить("IsOffline", Ложь);
	ШаблоннаяСтруктураДанных.Вставить("LotteryInformation", "");
	ШаблоннаяСтруктураДанных.Вставить("Markup", 0);
	ШаблоннаяСтруктураДанных.Вставить("MarkupPercent", 0);
	ШаблоннаяСтруктураДанных.Вставить("Number", "");
	
	ОФД = Новый Структура;
	ОФД.Вставить("Host", "");
	ОФД.Вставить("Name","");
	ОФД.Вставить("Code", 0);
	ШаблоннаяСтруктураДанных.Вставить("Ofd", ОФД);
	
	ШаблоннаяСтруктураДанных.Вставить("OperationType", 2);
	ШаблоннаяСтруктураДанных.Вставить("OperationTypeText", "ПРОДАЖА");
	ШаблоннаяСтруктураДанных.Вставить("OrderNumber", 0);
	
	ПримерПлатежа = Новый Структура("Sum, PaymentTypeName", 0, "");
	Платежи = Новый Массив;
	Платежи.Добавить(ПримерПлатежа);
	ШаблоннаяСтруктураДанных.Вставить("Payments", Платежи);
	
	ПримерПозиции = Новый Структура;
	ПримерПозиции.Вставить("PositionName", "");
	ПримерПозиции.Вставить("PositionCode", "");
	ПримерПозиции.Вставить("Count", 0);
	ПримерПозиции.Вставить("Price", 0);
	ПримерПозиции.Вставить("DiscountDeleted", Ложь);
	ПримерПозиции.Вставить("DiscountPercent", 0);
	ПримерПозиции.Вставить("DiscountTenge", 0);
	ПримерПозиции.Вставить("MarkupDeleted", Ложь);
	ПримерПозиции.Вставить("Markup", 0);
	ПримерПозиции.Вставить("MarkupPercent", 0);
	ПримерПозиции.Вставить("Tax", 0);
	ПримерПозиции.Вставить("TaxPercent", 0);
	ПримерПозиции.Вставить("IsNds", Ложь);
	ПримерПозиции.Вставить("IsStorno", Ложь);
	ПримерПозиции.Вставить("Mark", "");
	ПримерПозиции.Вставить("Sum", 0);
	ПримерПозиции.Вставить("UnitCode", 0);
	
	Позиции = Новый Массив;
	Позиции.Добавить(ПримерПозиции);
	ШаблоннаяСтруктураДанных.Вставить("Positions", Позиции);
	
	ШаблоннаяСтруктураДанных.Вставить("RegistratedOn", Дата(1, 1, 1, 0, 0, 0));
	ШаблоннаяСтруктураДанных.Вставить("ShiftNumber", 0);
	ШаблоннаяСтруктураДанных.Вставить("Taken", 0);
	ШаблоннаяСтруктураДанных.Вставить("Tax", 0);
	ШаблоннаяСтруктураДанных.Вставить("TaxPercent", 0);
	ШаблоннаяСтруктураДанных.Вставить("TicketUrl", "");
	ШаблоннаяСтруктураДанных.Вставить("Total", 0);
	ШаблоннаяСтруктураДанных.Вставить("VATPayer", Ложь);
	
	ПроверитьУровеньСтруктуры(СтруктураДанных, ШаблоннаяСтруктураДанных);
	
КонецПроцедуры

// Декодирует штрихкод по алгоритму Base64 в строковый формат.
//
Функция ПреобразоватьBase64ВШтрихкод(ШтрихкодВBase64) Экспорт
	
	Возврат ИнтеграцияWebKassaКлиентСерверПереопределяемый.ПреобразоватьBase64ВШтрихкод(ШтрихкодВBase64);
	
КонецФункции

Функция УдалитьНедопустимыеСимволыXML(Знач Текст) Экспорт
	
	Возврат ИнтеграцияWebKassaКлиентСерверПереопределяемый.УдалитьНедопустимыеСимволыXML(Текст);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьУровеньСтруктуры(СтруктураДанных, Шаблон)
	
	Для каждого Элемент Из Шаблон Цикл
		НайденноеЗначение = Неопределено;
		Если Не СтруктураДанных.Свойство(Элемент.Ключ, НайденноеЗначение) Тогда
			СтруктураДанных.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЕсли;
		Если ТипЗнч(Элемент.Значение) = Тип("Структура") Тогда
			СтруктураДанных.Свойство(Элемент.Ключ, НайденноеЗначение);
			Если ТипЗнч(НайденноеЗначение) = Тип("Структура") Тогда
				//проверка вложенной структуры
				ПроверитьУровеньСтруктуры(СтруктураДанных[Элемент.Ключ], Элемент.Значение);
			Иначе
				СтруктураДанных[Элемент.Ключ] = Элемент.Значение;
			КонецЕсли;
		КонецЕсли;
		Если ТипЗнч(Элемент.Значение) = Тип("Массив") Тогда
			СтруктураДанных.Свойство(Элемент.Ключ, НайденноеЗначение);
			Если ТипЗнч(НайденноеЗначение) = Тип("Массив") Тогда
				//проверка массива с элементами-структурами
				Для каждого ЭлементМассива Из НайденноеЗначение Цикл
					ПроверитьУровеньСтруктуры(ЭлементМассива, Элемент.Значение[0]);
				КонецЦикла;
			Иначе
				СтруктураДанных[Элемент.Ключ] = Элемент.Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
